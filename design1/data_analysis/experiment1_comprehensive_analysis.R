# ================================
# GLMMs with item-type-specific trends (interactions)
# ================================
library(tidyverse)
library(lme4)
library(broom.mixed)
library(emmeans)

# 0) Load
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# 1) Helper: safe poly (always returns *_lin, *_quad)
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  v[is.na(v)] <- mean(v, na.rm = TRUE)
  v_center <- v - mean(v, na.rm = TRUE)
  u <- length(unique(v_center)); n <- length(v_center)
  if (u < 2) {
    out <- data.frame(lin = rep(0, n), quad = rep(0, n))
  } else if (u < 3) {
    lin <- as.numeric(scale(v_center, center = TRUE, scale = TRUE))
    out <- data.frame(lin = lin, quad = rep(0, n))
  } else {
    out <- as.data.frame(poly(v_center, degree = 2, raw = FALSE))
  }
  names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
  out
}

# 2) Initial test (trial-level)
initial <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = as.numeric(coalesce(suppressWarnings(as.numeric(prespos_iposintrial_study)),
                                         suppressWarnings(as.numeric(prespos)))),
    test_position  = as.numeric(coalesce(suppressWarnings(as.numeric(prespos_iposintrial_test)),
                                         suppressWarnings(as.numeric(testpos)))),
    list_number    = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(study_position), !is.na(test_position), !is.na(item_type)) %>%
  mutate(item_type = factor(item_type, levels = c("foil","target"))) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))%>%
  mutate(participant_id = factor(as.character(PROLIFIC_PID))) %>%
filter(!is.na(participant_id))

cat("Initial test data prepared:", nrow(initial), "trials\n")

# 3) Final test (trial-level)
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = case_when(probetype == "FOIL" ~ NA_real_,
                               TRUE ~ suppressWarnings(as.numeric(prespos))),
    test_position  = suppressWarnings(as.numeric(testpos)),
    list_number    = suppressWarnings(as.numeric(trialnum)),
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(test_position), !is.na(item_type)) %>%
  mutate(item_type = factor(item_type, levels = c("foil","ST","SO","TO"))) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))%>%
  mutate(participant_id = factor(as.character(PROLIFIC_PID))) %>%
filter(!is.na(participant_id))

cat("Final test data prepared:", nrow(final), "trials\n")

# Convenience subsets for final-study-position models (drop foils lacking study_position)
final_study <- final %>%
  filter(!is.na(study_position)) %>%
  droplevels()  # drops foil level if empty here

# 4) Models (random intercepts; item-type-specific trends via interactions)

# Initial: Study Position × Item Type
m_init_studypos <- glmer(
  accuracy ~ (study_position_lin + study_position_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Test Position × Item Type
m_init_testpos <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Initial: Between-List (List Index) × Item Type
m_init_between <- glmer(
  accuracy ~ (list_number_lin + list_number_quad) * item_type +
    (1 | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Study Position × Item Type (ST/SO/TO only)
m_final_studypos <- glmer(
  accuracy ~ (study_position_lin + study_position_quad) * item_type +
    (1 | participant_id),
  data = final_study, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Test Position (final output order) × Item Type (includes foils)
m_final_testpos <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Initial List Position × Item Type
m_final_initiallist <- glmer(
  accuracy ~ (list_number_lin + list_number_quad) * item_type +
    (1 | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

# Final: Test Chunk (same as test_position model; kept for symmetry if you use chunking)
m_final_testchunk <- m_final_testpos

# 5) Summaries (fixed effects)
results <- list(
  init_studypos      = broom.mixed::tidy(m_init_studypos, effects = "fixed", conf.int = TRUE),
  init_testpos       = broom.mixed::tidy(m_init_testpos, effects = "fixed", conf.int = TRUE),
  init_between       = broom.mixed::tidy(m_init_between, effects = "fixed", conf.int = TRUE),
  final_studypos     = broom.mixed::tidy(m_final_studypos, effects = "fixed", conf.int = TRUE),
  final_testpos      = broom.mixed::tidy(m_final_testpos, effects = "fixed", conf.int = TRUE),
  final_initiallist  = broom.mixed::tidy(m_final_initiallist, effects = "fixed", conf.int = TRUE),
  final_testchunk    = broom.mixed::tidy(m_final_testchunk, effects = "fixed", conf.int = TRUE)
)

# 6) Item-type-specific linear trends (simple slopes) via emtrends
trends <- list(
  init_studypos_lin  = emtrends(m_init_studypos,  ~ item_type, var = "study_position_lin"),
  init_studypos_quad = emtrends(m_init_studypos,  ~ item_type, var = "study_position_quad"),
  init_testpos_lin   = emtrends(m_init_testpos,   ~ item_type, var = "test_position_lin"),
  init_testpos_quad  = emtrends(m_init_testpos,   ~ item_type, var = "test_position_quad"),
  init_between_lin   = emtrends(m_init_between,   ~ item_type, var = "list_number_lin"),
  init_between_quad  = emtrends(m_init_between,   ~ item_type, var = "list_number_quad"),
  final_studypos_lin = emtrends(m_final_studypos, ~ item_type, var = "study_position_lin"),
  final_studypos_quad= emtrends(m_final_studypos, ~ item_type, var = "study_position_quad"),
  final_testpos_lin  = emtrends(m_final_testpos,  ~ item_type, var = "test_position_lin"),
  final_testpos_quad = emtrends(m_final_testpos,  ~ item_type, var = "test_position_quad"),
  final_initial_lin  = emtrends(m_final_initiallist, ~ item_type, var = "list_number_lin"),
  final_initial_quad = emtrends(m_final_initiallist, ~ item_type, var = "list_number_quad")
)

# Convert emtrends to data frames
trends_df <- lapply(trends, function(x) tryCatch(as.data.frame(x), error = function(e) NULL))

# 7) Save
saveRDS(
  list(
    models    = list(
      m_init_studypos = m_init_studypos,
      m_init_testpos  = m_init_testpos,
      m_init_between  = m_init_between,
      m_final_studypos = m_final_studypos,
      m_final_testpos  = m_final_testpos,
      m_final_initiallist = m_final_initiallist,
      m_final_testchunk  = m_final_testchunk
    ),
    summaries = results,
    trends    = trends_df
  ),
  "experiment1_glmm_full_with_interactions.rds"
)

# Also export flat CSV for reporting
bind_rows(
  results$init_studypos  %>% mutate(model = "init_studypos"),
  results$init_testpos   %>% mutate(model = "init_testpos"),
  results$init_between   %>% mutate(model = "init_between"),
  results$final_studypos %>% mutate(model = "final_studypos"),
  results$final_testpos  %>% mutate(model = "final_testpos"),
  results$final_initiallist %>% mutate(model = "final_initiallist"),
  results$final_testchunk  %>% mutate(model = "final_testchunk")
) %>%
  write_csv("all_model_summaries_with_interactions.csv")

# Item-type-specific simple slopes (if any computed)
compact_trends <- purrr::imap_dfr(trends_df, ~{
  if (is.null(.x)) return(NULL)
  as_tibble(.x) %>% mutate(contrast = .y)
})
if (nrow(compact_trends) > 0) write_csv(compact_trends, "all_itemtype_trends.csv")

cat("Saved: experiment1_glmm_full_with_interactions.rds\n")
cat("Saved: all_model_summaries_with_interactions.csv\n")
if (exists("compact_trends") && nrow(compact_trends) > 0) cat("Saved: all_itemtype_trends.csv\n")
