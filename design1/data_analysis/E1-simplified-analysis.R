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
# DESCRIPTIVE STATISTICS FOR REPORT
# ============================================================================

# Initial test descriptive stats
initial_stats <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    )
  ) %>%
  filter(!is.na(item_type)) %>%
  group_by(item_type, prespos) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    se_acc = sd(correct, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  )

# Get early, middle, late positions for targets
target_by_position <- initial_stats %>%
  filter(item_type == "target") %>%
  arrange(prespos)

early_pos <- target_by_position %>% slice_head(n = 3)
middle_pos <- target_by_position %>% slice(4:7)
late_pos <- target_by_position %>% slice_tail(n = 3)

cat("\nINITIAL TEST STUDY POSITION EFFECTS:\n")
cat("Targets - Early positions: M =", round(mean(early_pos$mean_acc), 3), "\n")
cat("Targets - Middle positions: M =", round(mean(middle_pos$mean_acc), 3), "\n")
cat("Targets - Late positions: M =", round(mean(late_pos$mean_acc), 3), "\n")

# Test position effects
test_pos_stats <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    )
  ) %>%
  filter(!is.na(item_type)) %>%
  group_by(item_type, testpos) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    se_acc = sd(correct, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  )

# Get early vs late test positions
target_test_pos <- test_pos_stats %>%
  filter(item_type == "target") %>%
  arrange(testpos)

early_test <- target_test_pos %>% slice_head(n = 3)
late_test <- target_test_pos %>% slice_tail(n = 3)

foil_test_pos <- test_pos_stats %>%
  filter(item_type == "foil") %>%
  arrange(testpos)

early_foil_test <- foil_test_pos %>% slice_head(n = 3)
late_foil_test <- foil_test_pos %>% slice_tail(n = 3)

cat("\nINITIAL TEST POSITION EFFECTS:\n")
cat("Targets - Early test positions: M =", round(mean(early_test$mean_acc), 3), "\n")
cat("Targets - Late test positions: M =", round(mean(late_test$mean_acc), 3), "\n")
cat("Foils - Early test positions: M =", round(mean(early_foil_test$mean_acc), 3), "\n")
cat("Foils - Late test positions: M =", round(mean(late_foil_test$mean_acc), 3), "\n")

# Overall target vs foil performance
overall_performance <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    )
  ) %>%
  filter(!is.na(item_type)) %>%
  group_by(item_type) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    sd_acc = sd(correct, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nOVERALL PERFORMANCE:\n")
print(overall_performance)

# Between-list effects
between_list_stats <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    )
  ) %>%
  filter(!is.na(item_type)) %>%
  group_by(item_type, trialnum) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    se_acc = sd(correct, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  )

list1_performance <- between_list_stats %>% filter(trialnum == 1)
list10_performance <- between_list_stats %>% filter(trialnum == 10)

cat("\nBETWEEN-LIST EFFECTS:\n")
cat("List 1 - Targets: M =", round(list1_performance$mean_acc[list1_performance$item_type == "target"], 3), "\n")
cat("List 10 - Targets: M =", round(list10_performance$mean_acc[list10_performance$item_type == "target"], 3), "\n")
cat("List 1 - Foils: M =", round(list1_performance$mean_acc[list1_performance$item_type == "foil"], 3), "\n")
cat("List 10 - Foils: M =", round(list10_performance$mean_acc[list10_performance$item_type == "foil"], 3), "\n")

# ============================================================================
# SIMPLIFIED MODELS FOR KEY EFFECTS
# ============================================================================

# Prepare simplified trial-level data
trial_data <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(
    accuracy = as.numeric(correct),
    prespos_c = scale(prespos, center = TRUE, scale = FALSE)[,1],
    testpos_c = scale(testpos, center = TRUE, scale = FALSE)[,1],
    list_c = scale(as.numeric(trialnum), center = TRUE, scale = FALSE)[,1],
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil" ~ "foil"
    ),
    subject = factor(ip)
  ) %>%
  filter(!is.na(item_type)) %>%
  filter(!is.na(accuracy))

cat("\n=== RUNNING SIMPLIFIED MODELS ===\n")

# 1. Study position model (simplified)
cat("Running study position model...\n")
m_study <- glmer(
  accuracy ~ poly(prespos_c, 2) * item_type +
    (1 | subject),
  data = trial_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

study_summary <- tidy(m_study, effects = "fixed")

# 2. Test position model (simplified)
cat("Running test position model...\n")
m_test <- glmer(
  accuracy ~ poly(testpos_c, 2) * item_type +
    (1 | subject),
  data = trial_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

test_summary <- tidy(m_test, effects = "fixed")

# 3. Between-list model (simplified)
cat("Running between-list model...\n")
m_between <- glmer(
  accuracy ~ poly(list_c, 2) * item_type +
    (1 | subject),
  data = trial_data,
  family = binomial,
  control = glmerControl(optimizer = "bobyqa")
)

between_summary <- tidy(m_between, effects = "fixed")

# ============================================================================
# FINAL TEST DESCRIPTIVE STATISTICS
# ============================================================================

# Final test overall performance by exposure type
final_stats <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  filter(probetype != "FOIL") %>%
  mutate(
    exposure_type = case_when(
      probetype == "TARGET_target" ~ "studied_and_tested",
      probetype == "TARGET_nontarget" ~ "studied_only",
      probetype == "TARGET_foil" ~ "tested_only"
    )
  ) %>%
  group_by(exposure_type) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    sd_acc = sd(correct, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nFINAL TEST PERFORMANCE BY EXPOSURE TYPE:\n")
print(final_stats)

# Final test by condition
final_by_condition <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  group_by(condition) %>%
  summarise(
    mean_acc = mean(correct, na.rm = TRUE),
    sd_acc = sd(correct, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nFINAL TEST PERFORMANCE BY CONDITION:\n")
print(final_by_condition)

# ============================================================================
# SAVE RESULTS
# ============================================================================

# Save model summaries
write_csv(study_summary, "study_position_model_summary.csv")
write_csv(test_summary, "test_position_model_summary.csv")
write_csv(between_summary, "between_list_model_summary.csv")

# Save descriptive stats
write_csv(initial_stats, "initial_descriptive_stats.csv")
write_csv(test_pos_stats, "test_position_descriptive_stats.csv")
write_csv(between_list_stats, "between_list_descriptive_stats.csv")
write_csv(final_stats, "final_test_descriptive_stats.csv")

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("Results saved to CSV files\n")