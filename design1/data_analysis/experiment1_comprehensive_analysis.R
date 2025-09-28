# ======================================================
# EXPERIMENT 1 ANALYSIS (robust, no many-to-many join for final between)
# ======================================================

library(tidyverse)
library(lme4)
library(lmerTest)
library(broom.mixed)

# ------------------
# 1) LOAD
# ------------------
df <- read_csv("dfchanged.csv", show_col_types = FALSE)
cat("Loaded df with", nrow(df), "rows\n")

# ------------------
# 2) HELPERS
# ------------------
create_poly_terms <- function(data, var, degree = 2) {
  v <- suppressWarnings(as.numeric(data[[var]]))
  v <- v - mean(v, na.rm = TRUE)
  deg <- min(degree, length(unique(v[!is.na(v)])) - 1)
  if (deg < 1) {
    out <- data.frame(v)
    names(out) <- paste0(var, "_lin")
    return(out)
  }
  P <- poly(v, degree = deg, raw = FALSE)
  colnames(P) <- paste0(var, c("_lin", "_quad"))[1:deg]
  as.data.frame(P)
}

run_glmm <- function(data, formula, family = binomial, max_iter = 2000) {
  opts <- c("bobyqa","Nelder_Mead","nlminbwrap")
  for (opt in opts) {
    fit <- try(glmer(formula, data = data, family = family,
                     control = glmerControl(optimizer = opt,
                                            optCtrl = list(maxfun = max_iter)),
                     na.action = na.exclude),
               silent = TRUE)
    if (!inherits(fit, "try-error")) {
      cat("Converged with", opt, "\n")
      return(fit)
    }
  }
  stop("All optimizers failed")
}

# ------------------
# 3) INITIAL TEST DATA (pretest_response)
# ------------------
initial <- df %>%
  filter(task == "pretest_response", !is.na(correct)) %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    item_id        = factor(stimulus_id),
    accuracy       = as.numeric(correct),
    condition      = factor(condition),
    item_type      = factor(case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )),
    # 强制数值并选择可用来源
    trialnum  = suppressWarnings(as.numeric(trialnum)),
    prespos   = suppressWarnings(as.numeric(prespos)),
    testpos   = suppressWarnings(as.numeric(testpos)),
    pos_study_init = suppressWarnings(as.numeric(prespos_iposintrial_study)),
    pos_test_init  = suppressWarnings(as.numeric(prespos_iposintrial_test)),
    study_position = coalesce(pos_study_init, prespos),
    test_position  = coalesce(pos_test_init,  testpos),
    list_number    = trialnum
  ) %>%
  filter(!is.na(item_type), !is.na(study_position), !is.na(test_position), !is.na(list_number))

# orthogonal poly
initial <- bind_cols(initial, create_poly_terms(initial, "study_position", 2))
initial <- bind_cols(initial, create_poly_terms(initial, "test_position",  2))
initial <- bind_cols(initial, create_poly_terms(initial, "list_number",    2))

cat("Initial trials:", nrow(initial), "\n")

# ------------------
# 4) FINAL TEST DATA (finalt_response)
#    —— 对“between-list”完全不做 join —— 
# ------------------
final_base <- df %>%
  filter(task == "finalt_response", !is.na(correct)) %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    item_id        = factor(stimulus_id),
    accuracy       = as.numeric(correct),
    condition      = factor(condition),
    item_type      = factor(case_when(
      probetype == "TARGET_target"    ~ "S&T",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "new_foil",
      TRUE ~ "unknown"
    )),
    # final 测试中的顺序（连续）
    final_test_pos = suppressWarnings(as.numeric(testpos)),
    # 初始“列表序号”（你绘图里用的 prespos_itrial）
    initial_list_pos = suppressWarnings(as.numeric(prespos_itrial))
  ) %>%
  filter(item_type != "unknown")

# final between：两个自变量都可从 final 行直接得到
# a) 初始列表位置（针对 S&T / SO / TO；new_foil 没有初始列表，须排除）
final_initiallist_between <- final_base %>%
  filter(item_type %in% c("S&T","SO","TO"), !is.na(initial_list_pos))

final_initiallist_between <- bind_cols(final_initiallist_between,
                                       create_poly_terms(final_initiallist_between, "initial_list_pos", 2))

# b) 最终测试分块位置（把 final_test_pos 分成 10 等量分位 chunk）
final_testchunk_between <- final_base %>%
  filter(!is.na(final_test_pos)) %>%
  mutate(final_test_chunk = cut_number(final_test_pos, 10, labels = 1:10) %>% as.numeric())

final_testchunk_between <- bind_cols(final_testchunk_between,
                                     create_poly_terms(final_testchunk_between, "final_test_chunk", 2))

cat("Final between (initial-list) trials:", nrow(final_initiallist_between), "\n")
cat("Final between (test-chunk) trials:",  nrow(final_testchunk_between),  "\n")

# ------------------
# 5) （可选）FINAL WITHIN-LIST 需要初始“学习/测试位置”
#     此时才安全 join：先把 initial 压成 (participant_id,item_id) 唯一
# ------------------
initial_map <- initial %>%
  select(participant_id, item_id,
         study_position, test_position, list_number) %>%
  group_by(participant_id, item_id) %>%
  summarise(
    study_position = first(study_position),
    test_position  = first(test_position),
    list_number    = first(list_number),
    .groups = "drop"
  )

# 与 final 行按 (participant_id, item_id) 对接（不会 many-to-many）
final_within <- final_base %>%
  left_join(initial_map, by = c("participant_id", "item_id")) %>%
  # within-list 只针对有初始学习/初始测试位置的项目（S&T / SO / TO）
  filter(item_type %in% c("S&T","SO","TO"),
         !is.na(study_position), !is.na(test_position)) %>%
  bind_cols(create_poly_terms(., "study_position", 2)) %>%
  bind_cols(create_poly_terms(., "test_position",  2))

cat("Final within (joined safely) trials:", nrow(final_within), "\n")

# ------------------
# 6) MODELS
# ------------------

# Initial: study-position (within-list)
m_init_studypos <- run_glmm(
  initial,
  accuracy ~ study_position_lin + study_position_quad + item_type +
             (1 + study_position_lin + study_position_quad | participant_id) +
             (1 | item_id)
)

# Initial: test-position (within-list)
m_init_testpos <- run_glmm(
  initial,
  accuracy ~ test_position_lin + test_position_quad + item_type +
             (1 + test_position_lin + test_position_quad | participant_id) +
             (1 | item_id)
)

# Initial: between-list (list number)
m_init_between <- run_glmm(
  initial,
  accuracy ~ list_number_lin + list_number_quad + item_type +
             (1 + list_number_lin + list_number_quad | participant_id)
)

# Final: between-list (initial list position; no join; exclude new_foil)
m_final_initiallist <- run_glmm(
  final_initiallist_between,
  accuracy ~ initial_list_pos_lin + initial_list_pos_quad + item_type * condition +
             (1 + initial_list_pos_lin + initial_list_pos_quad | participant_id)
)

# Final: between-list (final test chunk; no join)
m_final_testchunk <- run_glmm(
  final_testchunk_between,
  accuracy ~ final_test_chunk_lin + final_test_chunk_quad + item_type * condition +
             (1 + final_test_chunk_lin + final_test_chunk_quad | participant_id)
)

# Final: within-list (needs initial study/test positions; uses safe join)
m_final_studypos <- run_glmm(
  final_within,
  accuracy ~ study_position_lin + study_position_quad + item_type +
             (1 + study_position_lin + study_position_quad | participant_id) +
             (1 | item_id)
)

m_final_testpos <- run_glmm(
  final_within,
  accuracy ~ test_position_lin + test_position_quad + item_type +
             (1 + test_position_lin + test_position_quad | participant_id) +
             (1 | item_id)
)

# ------------------
# 7) SAVE
# ------------------
summaries <- list(
  init_studypos        = tidy(m_init_studypos, effects = "fixed", conf.int = TRUE),
  init_testpos         = tidy(m_init_testpos,  effects = "fixed", conf.int = TRUE),
  init_between         = tidy(m_init_between,  effects = "fixed", conf.int = TRUE),
  final_initiallist    = tidy(m_final_initiallist, effects = "fixed", conf.int = TRUE),
  final_testchunk      = tidy(m_final_testchunk,   effects = "fixed", conf.int = TRUE),
  final_studypos       = tidy(m_final_studypos,    effects = "fixed", conf.int = TRUE),
  final_testpos        = tidy(m_final_testpos,     effects = "fixed", conf.int = TRUE)
)

saveRDS(summaries, "experiment1_glmm_results.rds")
cat("Lightweight summaries saved: experiment1_glmm_results.rds\n")

saveRDS(
  list(
    models = list(
      m_init_studypos     = m_init_studypos,
      m_init_testpos      = m_init_testpos,
      m_init_between      = m_init_between,
      m_final_initiallist = m_final_initiallist,
      m_final_testchunk   = m_final_testchunk,
      m_final_studypos    = m_final_studypos,
      m_final_testpos     = m_final_testpos
    ),
    summaries = summaries
  ),
  "experiment1_glmm_full.rds"
)
cat("Full models + summaries saved: experiment1_glmm_full.rds\n")
