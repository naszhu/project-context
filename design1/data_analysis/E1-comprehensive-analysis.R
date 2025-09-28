library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(lme4)
library(broom.mixed)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# ============================================================================
# 1. INITIAL WITHIN-LIST EFFECTS (Study Position & Test Position)
# ============================================================================

cat("\n=== INITIAL WITHIN-LIST ANALYSIS ===\n")

# Prepare trial-level data for initial within-list analysis
initial_within_data <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    # Convert accuracy to binary (0/1)
    accuracy = as.numeric(correct),
    # Center study position within each list
    prespos_c = scale(prespos, center = TRUE, scale = FALSE)[,1],
    # Center test position within each list
    testpos_c = scale(testpos, center = TRUE, scale = FALSE)[,1],
    # Create item type factor (target vs foil)
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    ),
    # Subject identifier
    subject = factor(ip),
    # List identifier (trial number acts as list index)
    list_index = factor(trialnum),
    # Condition factor
    condition = factor(condition)
  ) %>%
  filter(!is.na(item_type)) %>%
  filter(!is.na(accuracy))

cat("Prepared initial within-list data: ", nrow(initial_within_data), " trials\n")

# === STUDY POSITION EFFECTS ===
cat("\n--- Study Position Effects ---\n")

# Model with linear and quadratic study position effects
m_study_pos <- glmer(
  accuracy ~ poly(prespos_c, 2) * item_type * condition +
    (1 + poly(prespos_c, 2) | subject) +
    (1 | subject:list_index),
  data = initial_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_study_pos_linear <- glmer(
  accuracy ~ poly(prespos_c, 1) * item_type * condition +
    (1 + poly(prespos_c, 1) | subject) +
    (1 | subject:list_index),
  data = initial_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
study_pos_anova <- anova(m_study_pos_linear, m_study_pos, test = "Chisq")
cat("Quadratic vs Linear Study Position Model Comparison:\n")
print(study_pos_anova)

# Extract model summary
study_pos_summary <- tidy(m_study_pos, effects = "fixed")
cat("\nStudy Position Model Fixed Effects:\n")
print(study_pos_summary)

# === TEST POSITION EFFECTS ===
cat("\n--- Test Position Effects ---\n")

# Model with linear and quadratic test position effects
m_test_pos <- glmer(
  accuracy ~ poly(testpos_c, 2) * item_type * condition +
    (1 + poly(testpos_c, 2) | subject) +
    (1 | subject:list_index),
  data = initial_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_test_pos_linear <- glmer(
  accuracy ~ poly(testpos_c, 1) * item_type * condition +
    (1 + poly(testpos_c, 1) | subject) +
    (1 | subject:list_index),
  data = initial_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
test_pos_anova <- anova(m_test_pos_linear, m_test_pos, test = "Chisq")
cat("Quadratic vs Linear Test Position Model Comparison:\n")
print(test_pos_anova)

# Extract model summary
test_pos_summary <- tidy(m_test_pos, effects = "fixed")
cat("\nTest Position Model Fixed Effects:\n")
print(test_pos_summary)

# ============================================================================
# 2. INITIAL BETWEEN-LIST EFFECTS
# ============================================================================

cat("\n=== INITIAL BETWEEN-LIST ANALYSIS ===\n")

# Prepare trial-level data for between-list analysis
initial_between_data <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    # Convert accuracy to binary (0/1)
    accuracy = as.numeric(correct),
    # Center list index
    list_c = scale(as.numeric(trialnum), center = TRUE, scale = FALSE)[,1],
    # Create item type factor
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    ),
    # Subject identifier
    subject = factor(ip),
    # Condition factor
    condition = factor(condition)
  ) %>%
  filter(!is.na(item_type)) %>%
  filter(!is.na(accuracy))

cat("Prepared initial between-list data: ", nrow(initial_between_data), " trials\n")

# Model with linear and quadratic list effects
m_between_list <- glmer(
  accuracy ~ poly(list_c, 2) * item_type * condition +
    (1 + poly(list_c, 2) | subject),
  data = initial_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_between_list_linear <- glmer(
  accuracy ~ poly(list_c, 1) * item_type * condition +
    (1 + poly(list_c, 1) | subject),
  data = initial_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
between_list_anova <- anova(m_between_list_linear, m_between_list, test = "Chisq")
cat("Quadratic vs Linear Between-List Model Comparison:\n")
print(between_list_anova)

# Extract model summary
between_list_summary <- tidy(m_between_list, effects = "fixed")
cat("\nBetween-List Model Fixed Effects:\n")
print(between_list_summary)

# ============================================================================
# 3. FINAL WITHIN-LIST EFFECTS
# ============================================================================

cat("\n=== FINAL WITHIN-LIST ANALYSIS ===\n")

# Create final test data with initial positions
df_initial_positions <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(ip, stimulus_id, prespos, testpos, probetype) %>%
  mutate(
    initial_prespos = prespos,
    initial_testpos = testpos,
    initial_probetype = probetype
  ) %>%
  select(-prespos, -testpos, -probetype)

# Add study-only items
df_study_only <- dfchanged %>%
  filter(task == "pretest_study") %>%
  select(ip, stimulus_id, prespos) %>%
  anti_join(dfchanged %>% filter(task == "pretest_response") %>% select(ip, stimulus_id),
            by = c("ip", "stimulus_id")) %>%
  mutate(
    initial_prespos = prespos,
    initial_testpos = NA,
    initial_probetype = "TARGET_nontarget"
  ) %>%
  select(-prespos)

df_all_initial <- bind_rows(df_initial_positions, df_study_only)

# Prepare final test data
final_within_data <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  filter(probetype != "FOIL") %>%  # Foils don't have initial positions
  left_join(df_all_initial, by = c("ip", "stimulus_id")) %>%
  filter(!is.na(initial_prespos)) %>%
  mutate(
    # Convert accuracy to binary (0/1)
    accuracy = as.numeric(correct),
    # Center initial study position
    initial_prespos_c = scale(initial_prespos, center = TRUE, scale = FALSE)[,1],
    # Center initial test position (when available)
    initial_testpos_c = ifelse(!is.na(initial_testpos),
                              scale(initial_testpos, center = TRUE, scale = FALSE)[,1],
                              NA),
    # Create exposure history factor
    exposure_history = case_when(
      initial_probetype == "TARGET_target" ~ "studied_and_tested",
      initial_probetype == "TARGET_nontarget" ~ "studied_only",
      initial_probetype == "TARGET_foil" ~ "tested_only"
    ),
    # Subject identifier
    subject = factor(ip),
    # Condition factor
    condition = factor(condition)
  ) %>%
  filter(!is.na(exposure_history)) %>%
  filter(!is.na(accuracy))

cat("Prepared final within-list data: ", nrow(final_within_data), " trials\n")

# === FINAL TEST: INITIAL STUDY POSITION EFFECTS ===
cat("\n--- Final Test: Initial Study Position Effects ---\n")

# Model with initial study position effects
m_final_study_pos <- glmer(
  accuracy ~ poly(initial_prespos_c, 2) * exposure_history * condition +
    (1 + poly(initial_prespos_c, 2) | subject),
  data = final_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_final_study_pos_linear <- glmer(
  accuracy ~ poly(initial_prespos_c, 1) * exposure_history * condition +
    (1 + poly(initial_prespos_c, 1) | subject),
  data = final_within_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
final_study_pos_anova <- anova(m_final_study_pos_linear, m_final_study_pos, test = "Chisq")
cat("Final Test Study Position - Quadratic vs Linear Model Comparison:\n")
print(final_study_pos_anova)

# Extract model summary
final_study_pos_summary <- tidy(m_final_study_pos, effects = "fixed")
cat("\nFinal Test Study Position Model Fixed Effects:\n")
print(final_study_pos_summary)

# === FINAL TEST: INITIAL TEST POSITION EFFECTS ===
cat("\n--- Final Test: Initial Test Position Effects ---\n")

# Filter for items that were tested initially
final_test_pos_data <- final_within_data %>%
  filter(!is.na(initial_testpos_c))

if(nrow(final_test_pos_data) > 0) {
  # Model with initial test position effects
  m_final_test_pos <- glmer(
    accuracy ~ poly(initial_testpos_c, 2) * exposure_history * condition +
      (1 + poly(initial_testpos_c, 2) | subject),
    data = final_test_pos_data,
    family = binomial,
    control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
  )

  # Compare with linear-only model
  m_final_test_pos_linear <- glmer(
    accuracy ~ poly(initial_testpos_c, 1) * exposure_history * condition +
      (1 + poly(initial_testpos_c, 1) | subject),
    data = final_test_pos_data,
    family = binomial,
    control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
  )

  # Test significance of quadratic term
  final_test_pos_anova <- anova(m_final_test_pos_linear, m_final_test_pos, test = "Chisq")
  cat("Final Test Initial Test Position - Quadratic vs Linear Model Comparison:\n")
  print(final_test_pos_anova)

  # Extract model summary
  final_test_pos_summary <- tidy(m_final_test_pos, effects = "fixed")
  cat("\nFinal Test Initial Test Position Model Fixed Effects:\n")
  print(final_test_pos_summary)
} else {
  cat("No data available for initial test position effects in final test\n")
}

# ============================================================================
# 4. FINAL BETWEEN-LIST EFFECTS
# ============================================================================

cat("\n=== FINAL BETWEEN-LIST ANALYSIS ===\n")

# Prepare final test between-list data
final_between_data <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  mutate(
    # Convert accuracy to binary (0/1)
    accuracy = as.numeric(correct),
    # Center final test position
    final_testpos_c = scale(testpos, center = TRUE, scale = FALSE)[,1],
    # Center initial list position
    initial_list_c = scale(as.numeric(prespos_itrial), center = TRUE, scale = FALSE)[,1],
    # Create item type factor based on probetype
    item_type = case_when(
      probetype == "TARGET_target" ~ "studied_and_tested",
      probetype == "TARGET_nontarget" ~ "studied_only",
      probetype == "TARGET_foil" ~ "tested_only",
      probetype == "FOIL" ~ "foil"
    ),
    # Subject identifier
    subject = factor(ip),
    # Condition factor
    condition = factor(condition)
  ) %>%
  filter(!is.na(item_type)) %>%
  filter(!is.na(accuracy))

cat("Prepared final between-list data: ", nrow(final_between_data), " trials\n")

# === FINAL TEST ORDER EFFECTS ===
cat("\n--- Final Test Order Effects ---\n")

# Model with final test order effects
m_final_test_order <- glmer(
  accuracy ~ poly(final_testpos_c, 2) * item_type * condition +
    (1 + poly(final_testpos_c, 2) | subject),
  data = final_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_final_test_order_linear <- glmer(
  accuracy ~ poly(final_testpos_c, 1) * item_type * condition +
    (1 + poly(final_testpos_c, 1) | subject),
  data = final_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
final_test_order_anova <- anova(m_final_test_order_linear, m_final_test_order, test = "Chisq")
cat("Final Test Order - Quadratic vs Linear Model Comparison:\n")
print(final_test_order_anova)

# Extract model summary
final_test_order_summary <- tidy(m_final_test_order, effects = "fixed")
cat("\nFinal Test Order Model Fixed Effects:\n")
print(final_test_order_summary)

# === INITIAL LIST POSITION EFFECTS IN FINAL TEST ===
cat("\n--- Initial List Position Effects in Final Test ---\n")

# Model with initial list position effects
m_final_initial_list <- glmer(
  accuracy ~ poly(initial_list_c, 2) * item_type * condition +
    (1 + poly(initial_list_c, 2) | subject),
  data = final_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Compare with linear-only model
m_final_initial_list_linear <- glmer(
  accuracy ~ poly(initial_list_c, 1) * item_type * condition +
    (1 + poly(initial_list_c, 1) | subject),
  data = final_between_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa", calc.derivs = FALSE)
)

# Test significance of quadratic term
final_initial_list_anova <- anova(m_final_initial_list_linear, m_final_initial_list, test = "Chisq")
cat("Final Test Initial List Position - Quadratic vs Linear Model Comparison:\n")
print(final_initial_list_anova)

# Extract model summary
final_initial_list_summary <- tidy(m_final_initial_list, effects = "fixed")
cat("\nFinal Test Initial List Position Model Fixed Effects:\n")
print(final_initial_list_summary)

# ============================================================================
# SAVE RESULTS
# ============================================================================

# Save all model summaries to a list
all_results <- list(
  study_pos_anova = study_pos_anova,
  study_pos_summary = study_pos_summary,
  test_pos_anova = test_pos_anova,
  test_pos_summary = test_pos_summary,
  between_list_anova = between_list_anova,
  between_list_summary = between_list_summary,
  final_study_pos_anova = final_study_pos_anova,
  final_study_pos_summary = final_study_pos_summary,
  final_test_pos_anova = if(exists("final_test_pos_anova")) final_test_pos_anova else NULL,
  final_test_pos_summary = if(exists("final_test_pos_summary")) final_test_pos_summary else NULL,
  final_test_order_anova = final_test_order_anova,
  final_test_order_summary = final_test_order_summary,
  final_initial_list_anova = final_initial_list_anova,
  final_initial_list_summary = final_initial_list_summary
)

# Save results to RDS file
saveRDS(all_results, "E1_comprehensive_analysis_results.rds")

# Save summaries to CSV files for easy reading
write_csv(study_pos_summary, "study_position_effects.csv")
write_csv(test_pos_summary, "test_position_effects.csv")
write_csv(between_list_summary, "between_list_effects.csv")
write_csv(final_study_pos_summary, "final_study_position_effects.csv")
if(exists("final_test_pos_summary")) write_csv(final_test_pos_summary, "final_test_position_effects.csv")
write_csv(final_test_order_summary, "final_test_order_effects.csv")
write_csv(final_initial_list_summary, "final_initial_list_effects.csv")

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("All results saved to:\n")
cat("• E1_comprehensive_analysis_results.rds - Complete results object\n")
cat("• *_effects.csv files - Individual model summaries\n")