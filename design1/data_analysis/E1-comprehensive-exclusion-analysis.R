library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(gridExtra)

# Load the preprocessed data
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")

cat("=======================================================\n")
cat("COMPREHENSIVE PARTICIPANT EXCLUSION ANALYSIS\n")
cat("=======================================================\n\n")

# ========== PREPARE DATA ==========

# Get all relevant trial data (both pretest and final test)
trial_data <- dfchanged %>%
  filter(task %in% c("pretest_response", "finalt_response")) %>%
  filter(response != "null") %>%
  mutate(
    rt = as.numeric(rt),
    correct = as.numeric(correct)
  )

cat(sprintf("Total participants: %d\n", n_distinct(trial_data$ip)))
cat(sprintf("Total trials: %d\n\n", nrow(trial_data)))

# ========== EXCLUSION CRITERION 1: ACCURACY-BASED ==========

cat("\n=======================================================\n")
cat("CRITERION 1: ACCURACY-BASED EXCLUSIONS\n")
cat("=======================================================\n\n")

accuracy_by_participant <- trial_data %>%
  group_by(ip) %>%
  summarize(
    n_trials = n(),
    overall_accuracy = mean(correct, na.rm = TRUE),
    initial_accuracy = mean(correct[task == "pretest_response"], na.rm = TRUE),
    final_accuracy = mean(correct[task == "finalt_response"], na.rm = TRUE),
    .groups = 'drop'
  )

# Method 1a: Below chance performance (< 0.5)
below_chance <- accuracy_by_participant %>%
  filter(overall_accuracy < 0.5 | initial_accuracy < 0.5 | final_accuracy < 0.5)

cat("Method 1a: Below-chance performance (< 50%)\n")
if (nrow(below_chance) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(below_chance)))
  print(below_chance %>% select(ip, overall_accuracy, initial_accuracy, final_accuracy))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 1b: Extremely low performance (< 2 SD below mean)
mean_acc <- mean(accuracy_by_participant$overall_accuracy)
sd_acc <- sd(accuracy_by_participant$overall_accuracy)
threshold_2sd <- mean_acc - 2 * sd_acc

low_accuracy <- accuracy_by_participant %>%
  filter(overall_accuracy < threshold_2sd)

cat("Method 1b: Extremely low overall accuracy (> 2 SD below mean)\n")
cat(sprintf("  Threshold: %.3f (Mean: %.3f, SD: %.3f)\n",
    threshold_2sd, mean_acc, sd_acc))
if (nrow(low_accuracy) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(low_accuracy)))
  print(low_accuracy %>% select(ip, overall_accuracy))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 1c: Initial test outliers (already identified)
mean_initial <- mean(accuracy_by_participant$initial_accuracy, na.rm = TRUE)
sd_initial <- sd(accuracy_by_participant$initial_accuracy, na.rm = TRUE)
threshold_initial <- mean_initial - 2.5 * sd_initial

initial_outliers <- accuracy_by_participant %>%
  filter(initial_accuracy < threshold_initial)

cat("Method 1c: Initial test outliers (> 2.5 SD below mean)\n")
cat(sprintf("  Threshold: %.3f (Mean: %.3f, SD: %.3f)\n",
    threshold_initial, mean_initial, sd_initial))
if (nrow(initial_outliers) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(initial_outliers)))
  print(initial_outliers %>% select(ip, initial_accuracy))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# ========== EXCLUSION CRITERION 2: RT-BASED ==========

cat("\n=======================================================\n")
cat("CRITERION 2: REACTION TIME-BASED EXCLUSIONS\n")
cat("=======================================================\n\n")

rt_by_participant <- trial_data %>%
  group_by(ip) %>%
  summarize(
    n_trials = n(),
    median_rt = median(rt, na.rm = TRUE),
    mean_rt = mean(rt, na.rm = TRUE),
    sd_rt = sd(rt, na.rm = TRUE),
    min_rt = min(rt, na.rm = TRUE),
    max_rt = max(rt, na.rm = TRUE),
    prop_fast_rt = mean(rt < 200, na.rm = TRUE),  # < 200ms
    prop_slow_rt = mean(rt > 10000, na.rm = TRUE),  # > 10s
    .groups = 'drop'
  )

# Method 2a: Too many fast responses (< 200ms suggests random responding)
fast_responders <- rt_by_participant %>%
  filter(prop_fast_rt > 0.1)  # > 10% of trials < 200ms

cat("Method 2a: Excessive fast responses (>10% trials < 200ms)\n")
cat("  Rationale: < 200ms is too fast for thoughtful responding\n")
if (nrow(fast_responders) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(fast_responders)))
  print(fast_responders %>% select(ip, median_rt, prop_fast_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 2b: Too many slow responses (> 10s suggests disengagement)
slow_responders <- rt_by_participant %>%
  filter(prop_slow_rt > 0.1)  # > 10% of trials > 10s

cat("Method 2b: Excessive slow responses (>10% trials > 10s)\n")
cat("  Rationale: > 10s suggests disengagement or distraction\n")
if (nrow(slow_responders) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(slow_responders)))
  print(slow_responders %>% select(ip, median_rt, prop_slow_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 2c: Extremely fast median RT (< 500ms)
very_fast <- rt_by_participant %>%
  filter(median_rt < 500)

cat("Method 2c: Extremely fast median RT (< 500ms)\n")
cat("  Rationale: Median < 500ms suggests rushing or inattention\n")
if (nrow(very_fast) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(very_fast)))
  print(very_fast %>% select(ip, median_rt, mean_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 2d: Outlier median RT (> 3 SD from mean)
mean_median_rt <- mean(rt_by_participant$median_rt)
sd_median_rt <- sd(rt_by_participant$median_rt)
upper_rt <- mean_median_rt + 3 * sd_median_rt
lower_rt <- mean_median_rt - 3 * sd_median_rt

rt_outliers <- rt_by_participant %>%
  filter(median_rt > upper_rt | median_rt < lower_rt)

cat("Method 2d: RT outliers (median RT > 3 SD from mean)\n")
cat(sprintf("  Range: %.0f - %.0f ms (Mean: %.0f, SD: %.0f)\n",
    lower_rt, upper_rt, mean_median_rt, sd_median_rt))
if (nrow(rt_outliers) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(rt_outliers)))
  print(rt_outliers %>% select(ip, median_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# ========== EXCLUSION CRITERION 3: RESPONSE PATTERNS ==========

cat("\n=======================================================\n")
cat("CRITERION 3: RESPONSE PATTERN-BASED EXCLUSIONS\n")
cat("=======================================================\n\n")

# Method 3a: Same response repeated (perseveration)
response_patterns <- trial_data %>%
  group_by(ip, task) %>%
  arrange(trialnum) %>%
  summarize(
    n_trials = n(),
    unique_responses = n_distinct(response),
    most_common_response_prop = max(table(response)) / n(),
    .groups = 'drop'
  ) %>%
  group_by(ip) %>%
  summarize(
    avg_unique_responses = mean(unique_responses),
    max_perseveration = max(most_common_response_prop),
    .groups = 'drop'
  )

perseverators <- response_patterns %>%
  filter(max_perseveration > 0.9)  # Same response > 90% of time

cat("Method 3a: Response perseveration (same response >90% of trials)\n")
cat("  Rationale: Indicates not engaging with task content\n")
if (nrow(perseverators) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(perseverators)))
  print(perseverators)
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 3b: Alternating pattern (suggesting random responding)
alternation_check <- trial_data %>%
  group_by(ip, task) %>%
  arrange(trialnum) %>%
  mutate(
    response_num = as.numeric(as.factor(response)),
    alternated = response_num != lag(response_num)
  ) %>%
  summarize(
    alternation_rate = mean(alternated, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  group_by(ip) %>%
  summarize(
    avg_alternation_rate = mean(alternation_rate),
    .groups = 'drop'
  )

# For binary/multiple choice, random alternation would be high
alternators <- alternation_check %>%
  filter(avg_alternation_rate > 0.8)  # > 80% alternation

cat("Method 3b: Excessive alternation (>80% response changes)\n")
cat("  Rationale: May indicate random responding pattern\n")
if (nrow(alternators) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(alternators)))
  print(alternators)
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# ========== EXCLUSION CRITERION 4: INCOMPLETE DATA ==========

cat("\n=======================================================\n")
cat("CRITERION 4: INCOMPLETE OR MISSING DATA\n")
cat("=======================================================\n\n")

# Method 4a: Too few trials completed
expected_trials_per_phase <- trial_data %>%
  group_by(task) %>%
  summarize(expected = max(table(ip)), .groups = 'drop')

completion_rate <- trial_data %>%
  group_by(ip, task) %>%
  summarize(n_trials = n(), .groups = 'drop') %>%
  left_join(expected_trials_per_phase, by = "task") %>%
  mutate(completion_rate = n_trials / expected)

incomplete <- completion_rate %>%
  filter(completion_rate < 0.8)  # < 80% completion

cat("Method 4a: Incomplete data (<80% of expected trials)\n")
if (nrow(incomplete) > 0) {
  cat(sprintf("  Flagged: %d participant-phase combinations\n", nrow(incomplete)))
  print(incomplete)
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 4b: Missing RT data
missing_rt <- trial_data %>%
  group_by(ip) %>%
  summarize(
    n_trials = n(),
    n_missing_rt = sum(is.na(rt)),
    prop_missing_rt = n_missing_rt / n_trials,
    .groups = 'drop'
  ) %>%
  filter(prop_missing_rt > 0.1)  # > 10% missing RT

cat("Method 4b: Excessive missing RT data (>10% of trials)\n")
if (nrow(missing_rt) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(missing_rt)))
  print(missing_rt %>% select(ip, n_trials, prop_missing_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# ========== EXCLUSION CRITERION 5: CONSISTENCY CHECKS ==========

cat("\n=======================================================\n")
cat("CRITERION 5: CONSISTENCY AND ENGAGEMENT CHECKS\n")
cat("=======================================================\n\n")

# Method 5a: Extremely variable RT (high coefficient of variation)
rt_variability <- rt_by_participant %>%
  mutate(cv_rt = sd_rt / mean_rt) %>%
  filter(cv_rt > 2)  # CV > 2 indicates extreme inconsistency

cat("Method 5a: Extreme RT variability (CV > 2)\n")
cat("  Rationale: Excessive variability may indicate disengagement\n")
if (nrow(rt_variability) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(rt_variability)))
  print(rt_variability %>% select(ip, mean_rt, sd_rt, cv_rt))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# Method 5b: No improvement or extreme decline (for learning studies)
learning_check <- accuracy_by_participant %>%
  mutate(
    learning_gain = final_accuracy - initial_accuracy,
    extreme_decline = learning_gain < -0.3
  ) %>%
  filter(extreme_decline)

cat("Method 5b: Extreme performance decline (>30% drop from initial to final)\n")
cat("  Rationale: May indicate fatigue or disengagement\n")
if (nrow(learning_check) > 0) {
  cat(sprintf("  Flagged: %d participants\n", nrow(learning_check)))
  print(learning_check %>% select(ip, initial_accuracy, final_accuracy, learning_gain))
} else {
  cat("  Flagged: 0 participants\n")
}
cat("\n")

# ========== COMBINE ALL EXCLUSION CRITERIA ==========

cat("\n=======================================================\n")
cat("SUMMARY: ALL EXCLUSION FLAGS\n")
cat("=======================================================\n\n")

# Combine all flagged IPs
all_flagged <- bind_rows(
  below_chance %>% select(ip) %>% mutate(reason = "Below chance"),
  low_accuracy %>% select(ip) %>% mutate(reason = "Low accuracy (>2 SD)"),
  initial_outliers %>% select(ip) %>% mutate(reason = "Initial test outlier"),
  fast_responders %>% select(ip) %>% mutate(reason = "Too many fast RTs"),
  slow_responders %>% select(ip) %>% mutate(reason = "Too many slow RTs"),
  very_fast %>% select(ip) %>% mutate(reason = "Very fast median RT"),
  rt_outliers %>% select(ip) %>% mutate(reason = "RT outlier"),
  perseverators %>% select(ip) %>% mutate(reason = "Response perseveration"),
  alternators %>% select(ip) %>% mutate(reason = "Excessive alternation"),
  incomplete %>% select(ip) %>% mutate(reason = "Incomplete data"),
  missing_rt %>% select(ip) %>% mutate(reason = "Missing RT data"),
  rt_variability %>% select(ip) %>% mutate(reason = "Extreme RT variability"),
  learning_check %>% select(ip) %>% mutate(reason = "Extreme decline")
) %>%
  distinct()

# Count flags per participant
flag_summary <- all_flagged %>%
  group_by(ip) %>%
  summarize(
    n_flags = n(),
    reasons = paste(reason, collapse = "; "),
    .groups = 'drop'
  ) %>%
  arrange(desc(n_flags))

# Join with performance data
flag_summary_detailed <- flag_summary %>%
  left_join(accuracy_by_participant, by = "ip") %>%
  left_join(rt_by_participant, by = "ip") %>%
  select(ip, n_flags, reasons, overall_accuracy, median_rt, everything())

cat(sprintf("Total unique participants flagged: %d out of %d (%.1f%%)\n\n",
    nrow(flag_summary), n_distinct(trial_data$ip),
    100 * nrow(flag_summary) / n_distinct(trial_data$ip)))

if (nrow(flag_summary) > 0) {
  cat("Participants with multiple flags (recommended for exclusion):\n")
  print(flag_summary_detailed %>% filter(n_flags >= 2), n = 100)

  cat("\n\nParticipants with single flag (review case-by-case):\n")
  print(flag_summary_detailed %>% filter(n_flags == 1), n = 100)

  # Save detailed report
  write_csv(flag_summary_detailed, "E1_exclusion_candidates.csv")
  cat("\n\nDetailed report saved to: E1_exclusion_candidates.csv\n")
} else {
  cat("No participants flagged for exclusion!\n")
}

# ========== VISUALIZATION ==========

cat("\n=======================================================\n")
cat("CREATING DIAGNOSTIC VISUALIZATIONS\n")
cat("=======================================================\n\n")

# Create comprehensive diagnostic plots
combined_data <- accuracy_by_participant %>%
  left_join(rt_by_participant, by = "ip") %>%
  mutate(flagged = ip %in% flag_summary$ip,
         n_flags = ifelse(flagged,
                         flag_summary$n_flags[match(ip, flag_summary$ip)],
                         0))

p1 <- ggplot(combined_data, aes(x = overall_accuracy, fill = flagged)) +
  geom_histogram(bins = 30, alpha = 0.7, color = "black") +
  scale_fill_manual(values = c("TRUE" = "red", "FALSE" = "lightblue")) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "darkred", linewidth = 1) +
  labs(title = "Overall Accuracy Distribution",
       x = "Accuracy", y = "Count",
       fill = "Flagged") +
  theme_minimal(base_size = 10)

p2 <- ggplot(combined_data, aes(x = median_rt, fill = flagged)) +
  geom_histogram(bins = 30, alpha = 0.7, color = "black") +
  scale_fill_manual(values = c("TRUE" = "red", "FALSE" = "lightgreen")) +
  labs(title = "Median RT Distribution",
       x = "Median RT (ms)", y = "Count",
       fill = "Flagged") +
  theme_minimal(base_size = 10)

p3 <- ggplot(combined_data, aes(x = overall_accuracy, y = median_rt,
                                 color = flagged, size = n_flags)) +
  geom_point(alpha = 0.6) +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "gray40")) +
  scale_size_continuous(range = c(2, 6)) +
  labs(title = "Accuracy vs RT",
       x = "Overall Accuracy", y = "Median RT (ms)",
       color = "Flagged", size = "# Flags") +
  theme_minimal(base_size = 10)

p4 <- ggplot(combined_data, aes(x = initial_accuracy, y = final_accuracy,
                                 color = flagged, size = n_flags)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray") +
  scale_color_manual(values = c("TRUE" = "red", "FALSE" = "gray40")) +
  scale_size_continuous(range = c(2, 6)) +
  labs(title = "Initial vs Final Accuracy",
       x = "Initial Accuracy", y = "Final Accuracy",
       color = "Flagged", size = "# Flags") +
  theme_minimal(base_size = 10)

combined_plot <- grid.arrange(p1, p2, p3, p4, ncol = 2,
                               top = "Comprehensive Exclusion Diagnostic Plots")

ggsave("E1_comprehensive_exclusion_diagnostics.png", combined_plot,
       width = 14, height = 12, dpi = 300, bg = "white")

cat("Diagnostic plots saved to: E1_comprehensive_exclusion_diagnostics.png\n")

# ========== FINAL RECOMMENDATIONS ==========

cat("\n=======================================================\n")
cat("FINAL RECOMMENDATIONS\n")
cat("=======================================================\n\n")

if (nrow(flag_summary) == 0) {
  cat("✓ No participants require exclusion based on standard criteria\n")
  cat("  All participants show acceptable data quality\n\n")
} else {
  # Separate by severity
  high_priority <- flag_summary_detailed %>% filter(n_flags >= 3)
  medium_priority <- flag_summary_detailed %>% filter(n_flags == 2)
  low_priority <- flag_summary_detailed %>% filter(n_flags == 1)

  cat("Exclusion Priority Levels:\n\n")

  if (nrow(high_priority) > 0) {
    cat(sprintf("HIGH PRIORITY (≥3 flags): %d participants\n", nrow(high_priority)))
    cat("  → RECOMMEND EXCLUSION\n")
    cat("  IPs:", paste(high_priority$ip, collapse = ", "), "\n\n")
  }

  if (nrow(medium_priority) > 0) {
    cat(sprintf("MEDIUM PRIORITY (2 flags): %d participants\n", nrow(medium_priority)))
    cat("  → CONSIDER EXCLUSION (review individual cases)\n")
    cat("  IPs:", paste(medium_priority$ip, collapse = ", "), "\n\n")
  }

  if (nrow(low_priority) > 0) {
    cat(sprintf("LOW PRIORITY (1 flag): %d participants\n", nrow(low_priority)))
    cat("  → LIKELY RETAIN (unless flag is severe)\n")
    cat("  Review: E1_exclusion_candidates.csv\n\n")
  }

  cat("Total recommended exclusions:", nrow(high_priority) + nrow(medium_priority), "\n")
  cat(sprintf("Final sample size: %d participants\n",
      n_distinct(trial_data$ip) - nrow(high_priority) - nrow(medium_priority)))
}

cat("\n=======================================================\n")
cat("ANALYSIS COMPLETE\n")
cat("=======================================================\n")


# ========== SPECIFIC PARTICIPANTS INVESTIGATION ==========

cat("\n\n=======================================================\n")
cat("INVESTIGATING SPECIFIC PARTICIPANTS\n")
cat("=======================================================\n\n")

target_ips <- c("172.58.12.116", "68.9.164.176", "70.187.57.217", "73.104.3.163")

# Check if these participants exist
existing <- target_ips[target_ips %in% trial_data$ip]
missing <- target_ips[!target_ips %in% trial_data$ip]

if (length(missing) > 0) {
  cat("NOT FOUND in current dataset:\n")
  for (ip in missing) cat(sprintf("  - %s\n", ip))
  cat("\nThese may have been excluded during preprocessing.\n\n")
}

if (length(existing) > 0) {
  cat(sprintf("FOUND %d participants:\n\n", length(existing)))

  # Condition info
  cat("--- CONDITIONS ---\n")
  cond_info <- dfchanged %>%
    filter(ip %in% existing) %>%
    group_by(ip, condition) %>%
    summarize(n = n(), .groups = 'drop')
  print(cond_info)
  cat("\n")

  # Performance
  cat("--- PERFORMANCE ---\n")
  perf <- accuracy_by_participant %>%
    filter(ip %in% existing) %>%
    mutate(
      initial_z = (initial_accuracy - mean_initial) / sd_initial,
      final_z = (final_accuracy - mean(accuracy_by_participant$final_accuracy)) /
                sd(accuracy_by_participant$final_accuracy),
      overall_z = (overall_accuracy - mean_acc) / sd_acc
    )
  print(perf %>% select(ip, initial_accuracy, initial_z, final_accuracy, final_z, overall_accuracy, overall_z))
  cat("\n")

  # RT
  cat("--- REACTION TIME ---\n")
  rt <- rt_by_participant %>%
    filter(ip %in% existing) %>%
    mutate(rt_z = (median_rt - mean_median_rt) / sd_median_rt)
  print(rt %>% select(ip, median_rt, rt_z, prop_fast_rt, prop_slow_rt))
  cat("\n")

  # Any flags?
  cat("--- EXCLUSION FLAGS ---\n")
  flags <- flag_summary_detailed %>% filter(ip %in% existing)
  if (nrow(flags) > 0) {
    print(flags %>% select(ip, n_flags, reasons))
  } else {
    cat("No standard exclusion flags.\n")
  }
  cat("\n")

  # Verdict
  cat("--- VERDICT ---\n")
  for (ip in existing) {
    p <- perf %>% filter(ip == !!ip)
    r <- rt %>% filter(ip == !!ip)
    issues <- c()

    if (abs(p$initial_z) > 2.5) issues <- c(issues, sprintf("initial z=%.2f", p$initial_z))
    if (abs(p$final_z) > 2.5) issues <- c(issues, sprintf("final z=%.2f", p$final_z))
    if (abs(p$overall_z) > 2.5) issues <- c(issues, sprintf("overall z=%.2f", p$overall_z))
    if (abs(r$rt_z) > 3) issues <- c(issues, sprintf("RT z=%.2f", r$rt_z))
    if (r$prop_fast_rt > 0.1) issues <- c(issues, sprintf("fast RT %.1f%%", r$prop_fast_rt*100))

    cat(sprintf("%s: ", ip))
    if (length(issues) > 0) {
      cat("EXCLUDE -", paste(issues, collapse=", "), "\n")
    } else {
      cat("RETAIN - no issues\n")
    }
  }
} else {
  cat("NONE found in current dataset.\n")
}

cat("\n=======================================================\n")


# ========== PERFORMANCE THRESHOLD ANALYSIS (< 0.67) ==========

cat("\n\n=======================================================\n")
cat("PERFORMANCE THRESHOLD ANALYSIS: < 67% ACCURACY\n")
cat("=======================================================\n\n")

# Reload data in case it changed
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv", show_col_types = FALSE)

# Recalculate trial data
trial_data_new <- dfchanged %>%
  filter(task %in% c("pretest_response", "finalt_response")) %>%
  filter(response != "null") %>%
  mutate(
    rt = as.numeric(rt),
    correct = as.numeric(correct)
  )

# Recalculate performance
accuracy_new <- trial_data_new %>%
  group_by(ip) %>%
  summarize(
    n_trials = n(),
    overall_accuracy = mean(correct, na.rm = TRUE),
    initial_accuracy = mean(correct[task == "pretest_response"], na.rm = TRUE),
    final_accuracy = mean(correct[task == "finalt_response"], na.rm = TRUE),
    .groups = 'drop'
  )

# RT metrics
rt_new <- trial_data_new %>%
  group_by(ip) %>%
  summarize(
    median_rt = median(rt, na.rm = TRUE),
    mean_rt = mean(rt, na.rm = TRUE),
    sd_rt = sd(rt, na.rm = TRUE),
    prop_fast_rt = mean(rt < 200, na.rm = TRUE),
    prop_slow_rt = mean(rt > 10000, na.rm = TRUE),
    .groups = 'drop'
  )

# Get condition info
condition_new <- dfchanged %>%
  group_by(ip) %>%
  summarize(condition = first(condition), .groups = 'drop')

# Find participants below threshold
threshold <- 0.67
below_threshold <- accuracy_new %>%
  filter(overall_accuracy < threshold) %>%
  arrange(overall_accuracy)

cat(sprintf("Total participants in dataset: %d\n", n_distinct(trial_data_new$ip)))
cat(sprintf("Participants with overall accuracy < %.2f: %d (%.1f%%)\n\n",
    threshold, nrow(below_threshold),
    100 * nrow(below_threshold) / n_distinct(trial_data_new$ip)))

if (nrow(below_threshold) > 0) {
  # Merge with RT and condition data
  detailed_below <- below_threshold %>%
    left_join(rt_new, by = "ip") %>%
    left_join(condition_new, by = "ip") %>%
    mutate(
      # Calculate z-scores
      overall_z = (overall_accuracy - mean(accuracy_new$overall_accuracy)) /
                  sd(accuracy_new$overall_accuracy),
      initial_z = (initial_accuracy - mean(accuracy_new$initial_accuracy, na.rm = TRUE)) /
                  sd(accuracy_new$initial_accuracy, na.rm = TRUE),
      final_z = (final_accuracy - mean(accuracy_new$final_accuracy, na.rm = TRUE)) /
                sd(accuracy_new$final_accuracy, na.rm = TRUE),
      rt_z = (median_rt - mean(rt_new$median_rt)) / sd(rt_new$median_rt),
      learning_gain = final_accuracy - initial_accuracy
    )

  cat("--- PARTICIPANTS BELOW THRESHOLD ---\n\n")
  print(detailed_below %>%
        select(ip, condition, overall_accuracy, overall_z, initial_accuracy,
               final_accuracy, learning_gain, median_rt, rt_z))
  cat("\n")

  # Statistical context
  cat("--- STATISTICAL CONTEXT ---\n")
  cat(sprintf("Overall accuracy - Mean: %.3f, SD: %.3f\n",
      mean(accuracy_new$overall_accuracy), sd(accuracy_new$overall_accuracy)))
  cat(sprintf("Threshold %.2f = %.2f SD below mean\n\n",
      threshold,
      (mean(accuracy_new$overall_accuracy) - threshold) / sd(accuracy_new$overall_accuracy)))

  # Detailed individual analysis
  cat("\n--- INDIVIDUAL PARTICIPANT ANALYSIS ---\n\n")

  for (i in 1:nrow(detailed_below)) {
    row <- detailed_below[i,]
    cat(sprintf("Participant %d: %s (Condition: %s)\n", i, row$ip, row$condition))
    cat(sprintf("  Overall accuracy: %.3f (Z = %.2f) %s\n",
        row$overall_accuracy, row$overall_z,
        ifelse(row$overall_z < -2.5, "[EXTREME]", ifelse(row$overall_z < -2, "[OUTLIER]", ""))))
    cat(sprintf("  Initial: %.3f (Z = %.2f), Final: %.3f (Z = %.2f)\n",
        row$initial_accuracy, row$initial_z, row$final_accuracy, row$final_z))
    cat(sprintf("  Learning gain: %.3f\n", row$learning_gain))
    cat(sprintf("  Median RT: %.0f ms (Z = %.2f) %s\n",
        row$median_rt, row$rt_z,
        ifelse(abs(row$rt_z) > 3, "[EXTREME]", ifelse(abs(row$rt_z) > 2, "[OUTLIER]", ""))))

    # Decision criteria
    issues <- c()
    if (row$overall_accuracy < 0.5) issues <- c(issues, "below chance")
    if (row$overall_z < -2.5) issues <- c(issues, "extreme low accuracy")
    if (row$initial_z < -2.5) issues <- c(issues, "extreme low initial")
    if (abs(row$rt_z) > 3) issues <- c(issues, "extreme RT outlier")
    if (row$prop_fast_rt > 0.1) issues <- c(issues, "rushing")
    if (row$learning_gain < -0.3) issues <- c(issues, "severe decline")

    if (length(issues) > 0) {
      cat("  Issues:", paste(issues, collapse = ", "), "\n")
      cat("  → RECOMMEND EXCLUSION\n\n")
    } else {
      cat("  No severe issues beyond low accuracy\n")
      cat("  → BORDERLINE (review case-by-case)\n\n")
    }
  }

  # Summary recommendations
  cat("\n=======================================================\n")
  cat("THRESHOLD-BASED EXCLUSION RECOMMENDATIONS\n")
  cat("=======================================================\n\n")

  # Categorize by severity
  strong_exclude <- detailed_below %>%
    filter(overall_accuracy < 0.5 | overall_z < -2.5 | initial_z < -2.5 |
           abs(rt_z) > 3 | prop_fast_rt > 0.1 | learning_gain < -0.3)

  weak_exclude <- detailed_below %>%
    filter(!ip %in% strong_exclude$ip)

  cat(sprintf("STRONG exclusion cases (additional issues): %d participants\n", nrow(strong_exclude)))
  if (nrow(strong_exclude) > 0) {
    cat("  IPs:", paste(strong_exclude$ip, collapse = ", "), "\n")
  }
  cat("\n")

  cat(sprintf("WEAK exclusion cases (only low accuracy): %d participants\n", nrow(weak_exclude)))
  if (nrow(weak_exclude) > 0) {
    cat("  IPs:", paste(weak_exclude$ip, collapse = ", "), "\n")
  }
  cat("\n")

  # Impact analysis
  cat("\n--- IMPACT OF EXCLUDING ALL < 0.67 ---\n\n")

  cat("If you exclude all participants < 0.67:\n")
  cat(sprintf("  Sample size: %d → %d (loss of %d, %.1f%%)\n",
      n_distinct(trial_data_new$ip),
      n_distinct(trial_data_new$ip) - nrow(below_threshold),
      nrow(below_threshold),
      100 * nrow(below_threshold) / n_distinct(trial_data_new$ip)))

  above_threshold <- accuracy_new %>% filter(overall_accuracy >= threshold)
  cat(sprintf("  Mean accuracy: %.3f → %.3f (change: +%.3f)\n",
      mean(accuracy_new$overall_accuracy),
      mean(above_threshold$overall_accuracy),
      mean(above_threshold$overall_accuracy) - mean(accuracy_new$overall_accuracy)))
  cat(sprintf("  SD accuracy: %.3f → %.3f (change: %.3f)\n",
      sd(accuracy_new$overall_accuracy),
      sd(above_threshold$overall_accuracy),
      sd(above_threshold$overall_accuracy) - sd(accuracy_new$overall_accuracy)))

  # Alternative: exclude only strong cases
  cat("\n\nIf you exclude only STRONG cases:\n")
  cat(sprintf("  Sample size: %d → %d (loss of %d, %.1f%%)\n",
      n_distinct(trial_data_new$ip),
      n_distinct(trial_data_new$ip) - nrow(strong_exclude),
      nrow(strong_exclude),
      100 * nrow(strong_exclude) / n_distinct(trial_data_new$ip)))

  # Final recommendation
  cat("\n\n=======================================================\n")
  cat("FINAL RECOMMENDATION\n")
  cat("=======================================================\n\n")

  if (nrow(strong_exclude) == nrow(below_threshold)) {
    cat("All participants < 0.67 have additional serious issues.\n")
    cat("→ RECOMMEND: Exclude all participants < 0.67\n")
  } else if (nrow(strong_exclude) > 0 && nrow(weak_exclude) > 0) {
    cat(sprintf("Only %d/%d participants < 0.67 have serious issues.\n",
        nrow(strong_exclude), nrow(below_threshold)))
    cat("→ RECOMMEND: Consider more lenient threshold or exclude only strong cases\n")
    cat(sprintf("\nAlternative threshold suggestion: %.3f (2 SD below mean)\n",
        mean(accuracy_new$overall_accuracy) - 2 * sd(accuracy_new$overall_accuracy)))
  } else {
    cat("No participants < 0.67 have serious additional issues.\n")
    cat("→ RECOMMEND: Reconsider this threshold - it may be too strict\n")
  }

} else {
  cat("No participants found below threshold of 0.67\n")
  cat("All participants have acceptable performance!\n")
}

cat("\n=======================================================\n")
