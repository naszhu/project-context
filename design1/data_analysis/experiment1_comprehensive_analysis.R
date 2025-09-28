# ------------------
# 0. Libraries
# ------------------
library(tidyverse)
library(lme4)
library(broom.mixed)

# ------------------
# 1. Load Data
# ------------------
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# ------------------
# 2. Helper: polynomial terms
# ------------------
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  v[is.na(v)] <- mean(v, na.rm = TRUE)
  v_center <- v - mean(v, na.rm = TRUE)

  u <- length(unique(v_center))
  n <- length(v_center)

  if (u < 2) {
    # 没有变异：线性、二次都置 0
    out <- data.frame(
      lin  = rep(0, n),
      quad = rep(0, n)
    )
  } else if (u < 3) {
    # 只有两种取值：只给线性（标准化），二次置 0
    lin  <- as.numeric(scale(v_center, center = TRUE, scale = TRUE))
    out <- data.frame(
      lin  = lin,
      quad = rep(0, n)
    )
  } else {
    # 足够变异：用正交多项式
    P <- poly(v_center, degree = 2, raw = FALSE)
    out <- as.data.frame(P)
  }

  names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
  return(out)
}

# ------------------
# 3. Initial Test Data
# ------------------
initial <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = as.numeric(coalesce(as.numeric(prespos_iposintrial_study), as.numeric(prespos))),
    test_position = as.numeric(coalesce(as.numeric(prespos_iposintrial_test), as.numeric(testpos))),
    list_number = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(study_position), !is.na(test_position), !is.na(item_type)) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))

cat("Initial test data prepared:", nrow(initial), "trials\n")

# ------------------
# 4. Final Test Data
# ------------------
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    # 对 foil 没有 prespos 的情况特殊处理
    study_position = case_when(
      probetype == "FOIL" ~ NA_real_,
      TRUE ~ as.numeric(prespos)
    ),
    test_position = as.numeric(testpos),
    list_number = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",  # Studied & Tested
      probetype == "TARGET_nontarget" ~ "SO",  # Studied Only
      probetype == "TARGET_foil"      ~ "TO",  # Tested Only
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(test_position), !is.na(item_type)) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))

cat("Final test data prepared:", nrow(final), "trials\n")
# ------------------
# 5. Models (all || and no item_id)
# ------------------

# Initial: Study Position
m_init_studypos <- glmer(
  accuracy ~ study_position_lin + study_position_quad + item_type +
    (1 + study_position_lin + study_position_quad || participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Test Position
m_init_testpos <- glmer(
  accuracy ~ test_position_lin + test_position_quad + item_type +
    (1 + test_position_lin + test_position_quad || participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Between-List
m_init_between <- glmer(
  accuracy ~ list_number_lin + list_number_quad + item_type +
    (1 + list_number_lin + list_number_quad || participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Study Position
m_final_studypos <- glmer(
  accuracy ~ study_position_lin + study_position_quad + item_type +
    (1 + study_position_lin + study_position_quad || participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Test Position
m_final_testpos <- glmer(
  accuracy ~ test_position_lin + test_position_quad + item_type +
    (1 + test_position_lin + test_position_quad || participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Initial List Position
m_final_initiallist <- glmer(
  accuracy ~ list_number_lin + list_number_quad + item_type +
    (1 + list_number_lin + list_number_quad || participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Test Chunk (using test_position)
m_final_testchunk <- glmer(
  accuracy ~ test_position_lin + test_position_quad + item_type +
    (1 + test_position_lin + test_position_quad || participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# ------------------
# 6. Save Results
# ------------------
results <- list(
  init_studypos = broom.mixed::tidy(m_init_studypos, effects = "fixed", conf.int = TRUE),
  init_testpos  = broom.mixed::tidy(m_init_testpos, effects = "fixed", conf.int = TRUE),
  init_between  = broom.mixed::tidy(m_init_between, effects = "fixed", conf.int = TRUE),
  final_studypos = broom.mixed::tidy(m_final_studypos, effects = "fixed", conf.int = TRUE),
  final_testpos  = broom.mixed::tidy(m_final_testpos, effects = "fixed", conf.int = TRUE),
  final_initiallist = broom.mixed::tidy(m_final_initiallist, effects = "fixed", conf.int = TRUE),
  final_testchunk  = broom.mixed::tidy(m_final_testchunk, effects = "fixed", conf.int = TRUE)
)

saveRDS(
  list(
    models = list(
      m_init_studypos = m_init_studypos,
      m_init_testpos  = m_init_testpos,
      m_init_between  = m_init_between,
      m_final_studypos = m_final_studypos,
      m_final_testpos  = m_final_testpos,
      m_final_initiallist = m_final_initiallist,
      m_final_testchunk  = m_final_testchunk
    ),
    summaries = results
  ),
  "experiment1_glmm_full.rds"
)

cat("Results saved to experiment1_glmm_full.rds\n")

