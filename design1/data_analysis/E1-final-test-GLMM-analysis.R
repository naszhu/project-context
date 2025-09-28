# FINAL TEST — WITHIN-LIST & BETWEEN-LIST ANALYSES (GLMM, trial-level)

library(dplyr)
library(readr)
library(lme4)
library(broom.mixed)
library(emmeans)

# ------------------------------------------------------------
# Load data
# ------------------------------------------------------------
df <- read_csv("dfchanged.csv")

# ------------------------------------------------------------
# Build mapping of initial (E1) positions for each subject×item
# ------------------------------------------------------------
# Items that were tested during initial phase
init_resp <- df %>%
  filter(task == "pretest_response") %>%
  select(ip, stimulus_id, prespos, testpos, probetype, prespos_itrial) %>%
  rename(
    initial_prespos = prespos,
    initial_testpos = testpos,
    initial_probetype = probetype,
    initial_list_index = prespos_itrial
  )

# Items that were only studied (never tested) during initial phase
init_study_only <- df %>%
  filter(task == "pretest_study") %>%
  anti_join(init_resp %>% select(ip, stimulus_id), by = c("ip", "stimulus_id")) %>%
  transmute(
    ip, stimulus_id,
    initial_prespos = prespos,
    initial_testpos = NA,
    initial_probetype = "TARGET_nontarget",
    initial_list_index = prespos_itrial
  )

init_map <- bind_rows(init_resp, init_study_only)

# ------------------------------------------------------------
# Prepare FINAL TEST trial-level dataset with initial mapping
# ------------------------------------------------------------
final_dat <- df %>%
  filter(task == "finalt_response", response != "null") %>%
  left_join(init_map, by = c("ip", "stimulus_id")) %>%
  mutate(
    accuracy = as.numeric(correct),
    subject  = factor(ip),
    condition = factor(condition),

    # exposure history (final test trials that are not initial foils or novel foils)
    exposure_history = case_when(
      initial_probetype == "TARGET_target"    ~ "studied_and_tested",
      initial_probetype == "TARGET_nontarget" ~ "studied_only",
      initial_probetype == "TARGET_foil"      ~ "tested_only",
      probetype == "FOIL"                     ~ "foil",
      TRUE ~ NA_character_
    ),

    # centers
    initial_prespos_c = ifelse(!is.na(initial_prespos),
                               scale(initial_prespos, center = TRUE, scale = FALSE)[,1], NA),
    initial_testpos_c = ifelse(!is.na(initial_testpos),
                               scale(initial_testpos, center = TRUE, scale = FALSE)[,1], NA),
    initial_list_c    = ifelse(!is.na(initial_list_index),
                               scale(as.numeric(initial_list_index), center = TRUE, scale = FALSE)[,1], NA),
    final_testpos_c   = scale(testpos, center = TRUE, scale = FALSE)[,1]
  ) %>%
  filter(!is.na(accuracy), !is.na(exposure_history))  # keep valid trials

# convenience: drop levels
final_dat$exposure_history <- factor(final_dat$exposure_history,
                                     levels = c("studied_and_tested","studied_only","tested_only","foil"))

# ------------------------------------------------------------
# HELPERS
# ------------------------------------------------------------
fit_compare_poly <- function(form_lin, form_quad, data) {
  cat("Fitting linear model...\n")
  m_lin  <- glmer(form_lin,  data = data, family = binomial,
                  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 20000)))
  cat("Fitting quadratic model...\n")
  m_quad <- glmer(form_quad, data = data, family = binomial,
                  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 20000)))
  cat("Comparing models...\n")
  list(
    m_lin = m_lin,
    m_quad = m_quad,
    anova = anova(m_lin, m_quad, test = "Chisq"),
    tidy = tidy(m_quad, effects = "fixed")
  )
}

pred_early_late <- function(model, var, data) {
  v <- data[[var]]
  emm <- emmeans(model, reformulate(var),
                 at   = setNames(list(c(min(v, na.rm=TRUE), max(v, na.rm=TRUE))), var),
                 type = "response")
  as.data.frame(emm)
}

# ------------------------------------------------------------
# FINAL TEST — WITHIN-LIST
# (A) Ordered by INITIAL STUDY ORDER (initial_prespos)
# ------------------------------------------------------------
final_within_study <- final_dat %>% filter(!is.na(initial_prespos_c),
                                           exposure_history %in% c("studied_and_tested","studied_only","tested_only"))

res_final_within_by_initial_study <- fit_compare_poly(
  form_lin  = accuracy ~ poly(initial_prespos_c, 1) * exposure_history * condition +
              (1 | subject),
  form_quad = accuracy ~ poly(initial_prespos_c, 2) * exposure_history * condition +
              (1 | subject),
  data = final_within_study
)

pred_final_within_by_initial_study <- pred_early_late(res_final_within_by_initial_study$m_quad,
                                                      "initial_prespos_c", final_within_study)

# ------------------------------------------------------------
# FINAL TEST — WITHIN-LIST
# (B) Ordered by INITIAL TEST ORDER (initial_testpos)
# ------------------------------------------------------------
final_within_test <- final_dat %>% filter(!is.na(initial_testpos_c),
                                          exposure_history %in% c("studied_and_tested","tested_only"))

res_final_within_by_initial_test <- fit_compare_poly(
  form_lin  = accuracy ~ poly(initial_testpos_c, 1) * exposure_history * condition +
              (1 | subject),
  form_quad = accuracy ~ poly(initial_testpos_c, 2) * exposure_history * condition +
              (1 | subject),
  data = final_within_test
)

pred_final_within_by_initial_test <- pred_early_late(res_final_within_by_initial_test$m_quad,
                                                     "initial_testpos_c", final_within_test)

# ------------------------------------------------------------
# FINAL TEST — BETWEEN-LIST
# (C) Ordered by FINAL TEST GROUP ORDER (final_testpos)
#     (i.e., output position during the final test)
# ------------------------------------------------------------
res_final_between_by_final_order <- fit_compare_poly(
  form_lin  = accuracy ~ poly(final_testpos_c, 1) * exposure_history * condition +
              (1 | subject),
  form_quad = accuracy ~ poly(final_testpos_c, 2) * exposure_history * condition +
              (1 | subject),
  data = final_dat
)

pred_final_between_by_final_order <- pred_early_late(res_final_between_by_final_order$m_quad,
                                                     "final_testpos_c", final_dat)

# ------------------------------------------------------------
# FINAL TEST — BETWEEN-LIST
# (D) Ordered by INITIAL TEST LIST ORDER (initial_list_index)
#     (i.e., which of the 10 initial lists the item came from)
# ------------------------------------------------------------
final_between_initial_list <- final_dat %>% filter(!is.na(initial_list_c))

res_final_between_by_initial_list <- fit_compare_poly(
  form_lin  = accuracy ~ poly(initial_list_c, 1) * exposure_history * condition +
              (1 | subject),
  form_quad = accuracy ~ poly(initial_list_c, 2) * exposure_history * condition +
              (1 | subject),
  data = final_between_initial_list
)

pred_final_between_by_initial_list <- pred_early_late(res_final_between_by_initial_list$m_quad,
                                                      "initial_list_c", final_between_initial_list)

# ------------------------------------------------------------
# OUTPUTS
# ------------------------------------------------------------
all_out <- list(
  # Within-list (final) — initial study order
  final_within_initial_study_models = res_final_within_by_initial_study[c("m_lin","m_quad")],
  final_within_initial_study_anova  = res_final_within_by_initial_study$anova,
  final_within_initial_study_fixed  = res_final_within_by_initial_study$tidy,
  final_within_initial_study_preds  = pred_final_within_by_initial_study,

  # Within-list (final) — initial test order
  final_within_initial_test_models  = res_final_within_by_initial_test[c("m_lin","m_quad")],
  final_within_initial_test_anova   = res_final_within_by_initial_test$anova,
  final_within_initial_test_fixed   = res_final_within_by_initial_test$tidy,
  final_within_initial_test_preds   = pred_final_within_by_initial_test,

  # Between-list (final) — final test group/order
  final_between_final_order_models  = res_final_between_by_final_order[c("m_lin","m_quad")],
  final_between_final_order_anova   = res_final_between_by_final_order$anova,
  final_between_final_order_fixed   = res_final_between_by_final_order$tidy,
  final_between_final_order_preds   = pred_final_between_by_final_order,

  # Between-list (final) — initial test list order
  final_between_initial_list_models = res_final_between_by_initial_list[c("m_lin","m_quad")],
  final_between_initial_list_anova  = res_final_between_by_initial_list$anova,
  final_between_initial_list_fixed  = res_final_between_by_initial_list$tidy,
  final_between_initial_list_preds  = pred_final_between_by_initial_list
)

saveRDS(all_out, "final_test_within_between_models.rds")

# Optional CSVs
readr::write_csv(res_final_within_by_initial_study$tidy,      "final_within_initial_study_fixed.csv")
readr::write_csv(res_final_within_by_initial_test$tidy,       "final_within_initial_test_fixed.csv")
readr::write_csv(res_final_between_by_final_order$tidy,       "final_between_final_order_fixed.csv")
readr::write_csv(res_final_between_by_initial_list$tidy,      "final_between_initial_list_fixed.csv")

# Quick console prints
cat("\n=== LRT: Final Within (Initial Study Order) ===\n"); print(res_final_within_by_initial_study$anova)
cat("\n=== LRT: Final Within (Initial Test Order) ===\n");  print(res_final_within_by_initial_test$anova)
cat("\n=== LRT: Final Between (Final Test Order) ===\n");    print(res_final_between_by_final_order$anova)
cat("\n=== LRT: Final Between (Initial List Order) ===\n");  print(res_final_between_by_initial_list$anova)