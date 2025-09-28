# FINAL TEST — SIMPLIFIED GLMM ANALYSIS (trial-level)

library(dplyr)
library(readr)
library(lme4)
library(broom.mixed)

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
# CALCULATE DESCRIPTIVE STATISTICS BY EXPOSURE HISTORY
# ------------------------------------------------------------
cat("\n=== EXPOSURE HISTORY DESCRIPTIVES ===\n")
exposure_stats <- final_dat %>%
  group_by(exposure_history) %>%
  summarise(
    mean_accuracy = mean(accuracy, na.rm = TRUE),
    sd_accuracy = sd(accuracy, na.rm = TRUE),
    n = n(),
    .groups = 'drop'
  )
print(exposure_stats)

# ------------------------------------------------------------
# SIMPLIFIED MODELS - ONE AT A TIME
# ------------------------------------------------------------

# Helper function for single model fitting
fit_single_model <- function(form, data, description) {
  cat("\n=== Fitting:", description, "===\n")
  tryCatch({
    model <- glmer(form, data = data, family = binomial,
                   control = glmerControl(optimizer = "bobyqa"))
    tidy_results <- tidy(model, effects = "fixed")

    # Save results
    readr::write_csv(tidy_results, paste0(gsub(" ", "_", tolower(description)), "_results.csv"))

    cat("Model fitted successfully.\n")
    return(list(model = model, tidy = tidy_results))
  }, error = function(e) {
    cat("Error fitting model:", e$message, "\n")
    return(NULL)
  })
}

# 1. FINAL TEST — WITHIN-LIST (Initial Study Order)
cat("\n=== ANALYSIS 1: Within-List by Initial Study Order ===\n")
final_within_study <- final_dat %>%
  filter(!is.na(initial_prespos_c),
         exposure_history %in% c("studied_and_tested","studied_only","tested_only"))

cat("Data size:", nrow(final_within_study), "trials\n")

# Simple linear model first
within_study_lin <- fit_single_model(
  accuracy ~ initial_prespos_c * exposure_history * condition + (1 | subject),
  final_within_study,
  "Final Within Initial Study Linear"
)

# Try quadratic if linear works
if (!is.null(within_study_lin)) {
  within_study_quad <- fit_single_model(
    accuracy ~ poly(initial_prespos_c, 2) * exposure_history * condition + (1 | subject),
    final_within_study,
    "Final Within Initial Study Quadratic"
  )
}

# 2. FINAL TEST — WITHIN-LIST (Initial Test Order)
cat("\n=== ANALYSIS 2: Within-List by Initial Test Order ===\n")
final_within_test <- final_dat %>%
  filter(!is.na(initial_testpos_c),
         exposure_history %in% c("studied_and_tested","tested_only"))

cat("Data size:", nrow(final_within_test), "trials\n")

within_test_lin <- fit_single_model(
  accuracy ~ initial_testpos_c * exposure_history * condition + (1 | subject),
  final_within_test,
  "Final Within Initial Test Linear"
)

if (!is.null(within_test_lin)) {
  within_test_quad <- fit_single_model(
    accuracy ~ poly(initial_testpos_c, 2) * exposure_history * condition + (1 | subject),
    final_within_test,
    "Final Within Initial Test Quadratic"
  )
}

# 3. FINAL TEST — BETWEEN-LIST (Final Test Order)
cat("\n=== ANALYSIS 3: Between-List by Final Test Order ===\n")
cat("Data size:", nrow(final_dat), "trials\n")

between_final_lin <- fit_single_model(
  accuracy ~ final_testpos_c * exposure_history * condition + (1 | subject),
  final_dat,
  "Final Between Final Order Linear"
)

if (!is.null(between_final_lin)) {
  between_final_quad <- fit_single_model(
    accuracy ~ poly(final_testpos_c, 2) * exposure_history * condition + (1 | subject),
    final_dat,
    "Final Between Final Order Quadratic"
  )
}

# 4. FINAL TEST — BETWEEN-LIST (Initial List Order)
cat("\n=== ANALYSIS 4: Between-List by Initial List Order ===\n")
final_between_initial_list <- final_dat %>% filter(!is.na(initial_list_c))

cat("Data size:", nrow(final_between_initial_list), "trials\n")

between_list_lin <- fit_single_model(
  accuracy ~ initial_list_c * exposure_history * condition + (1 | subject),
  final_between_initial_list,
  "Final Between Initial List Linear"
)

if (!is.null(between_list_lin)) {
  between_list_quad <- fit_single_model(
    accuracy ~ poly(initial_list_c, 2) * exposure_history * condition + (1 | subject),
    final_between_initial_list,
    "Final Between Initial List Quadratic"
  )
}

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("Check individual CSV files for detailed results.\n")