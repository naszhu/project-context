library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")

cat("=======================================================\n")
cat("OUTLIER ANALYSIS FOR PARTICIPANT 47.158.129.211\n")
cat("=======================================================\n\n")

# ========== 1. CALCULATE PERFORMANCE FOR ALL PARTICIPANTS ==========

# Initial Test Performance
initial_perf <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(
    initial_performance = mean(correct, na.rm = TRUE),
    n_trials_initial = n(),
    .groups = 'drop'
  )

# Final Test Performance
final_perf <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(
    final_performance = mean(correct, na.rm = TRUE),
    n_trials_final = n(),
    .groups = 'drop'
  )

# Combine
all_perf <- initial_perf %>%
  left_join(final_perf, by = "ip") %>%
  mutate(
    learning_gain = final_performance - initial_performance,
    is_target = ip == "47.158.129.211"
  )

# ========== 2. DESCRIPTIVE STATISTICS ==========

cat("--- Overall Statistics (All Participants) ---\n")
cat(sprintf("Total participants: %d\n\n", nrow(all_perf)))

cat("Initial Test:\n")
cat(sprintf("  Mean: %.3f (SD = %.3f)\n",
    mean(all_perf$initial_performance), sd(all_perf$initial_performance)))
cat(sprintf("  Median: %.3f\n", median(all_perf$initial_performance)))
cat(sprintf("  Range: %.3f - %.3f\n\n",
    min(all_perf$initial_performance), max(all_perf$initial_performance)))

cat("Final Test:\n")
cat(sprintf("  Mean: %.3f (SD = %.3f)\n",
    mean(all_perf$final_performance), sd(all_perf$final_performance)))
cat(sprintf("  Median: %.3f\n", median(all_perf$final_performance)))
cat(sprintf("  Range: %.3f - %.3f\n\n",
    min(all_perf$final_performance), max(all_perf$final_performance)))

cat("Learning Gain:\n")
cat(sprintf("  Mean: %.3f (SD = %.3f)\n",
    mean(all_perf$learning_gain), sd(all_perf$learning_gain)))
cat(sprintf("  Median: %.3f\n", median(all_perf$learning_gain)))
cat(sprintf("  Range: %.3f - %.3f\n\n",
    min(all_perf$learning_gain), max(all_perf$learning_gain)))

# ========== 3. TARGET PARTICIPANT PROFILE ==========

target_data <- all_perf %>% filter(ip == "47.158.129.211")

cat("--- Target Participant (47.158.129.211) ---\n")
cat(sprintf("Initial performance: %.3f\n", target_data$initial_performance))
cat(sprintf("Final performance: %.3f\n", target_data$final_performance))
cat(sprintf("Learning gain: %.3f\n\n", target_data$learning_gain))

# ========== 4. OUTLIER DETECTION METHODS ==========

cat("\n=======================================================\n")
cat("OUTLIER DETECTION RESULTS\n")
cat("=======================================================\n\n")

# Method 1: Z-score (typically |z| > 3 is outlier, > 2.5 is extreme)
z_score_initial <- (target_data$initial_performance - mean(all_perf$initial_performance)) / sd(all_perf$initial_performance)
z_score_final <- (target_data$final_performance - mean(all_perf$final_performance)) / sd(all_perf$final_performance)
z_score_gain <- (target_data$learning_gain - mean(all_perf$learning_gain)) / sd(all_perf$learning_gain)

cat("Method 1: Z-Score Analysis\n")
cat(sprintf("  Initial test z-score: %.3f %s\n", z_score_initial,
    ifelse(abs(z_score_initial) > 3, "[EXTREME OUTLIER]",
    ifelse(abs(z_score_initial) > 2.5, "[OUTLIER]", "[Normal]"))))
cat(sprintf("  Final test z-score: %.3f %s\n", z_score_final,
    ifelse(abs(z_score_final) > 3, "[EXTREME OUTLIER]",
    ifelse(abs(z_score_final) > 2.5, "[OUTLIER]", "[Normal]"))))
cat(sprintf("  Learning gain z-score: %.3f %s\n\n", z_score_gain,
    ifelse(abs(z_score_gain) > 3, "[EXTREME OUTLIER]",
    ifelse(abs(z_score_gain) > 2.5, "[OUTLIER]", "[Normal]"))))

# Method 2: IQR Method (Tukey's fences)
iqr_outlier_check <- function(value, all_values) {
  Q1 <- quantile(all_values, 0.25)
  Q3 <- quantile(all_values, 0.75)
  IQR <- Q3 - Q1
  lower_fence <- Q1 - 1.5 * IQR
  upper_fence <- Q3 + 1.5 * IQR
  extreme_lower <- Q1 - 3 * IQR
  extreme_upper <- Q3 + 3 * IQR

  if (value < extreme_lower | value > extreme_upper) {
    return(list(status = "EXTREME OUTLIER", lower = extreme_lower, upper = extreme_upper))
  } else if (value < lower_fence | value > upper_fence) {
    return(list(status = "OUTLIER", lower = lower_fence, upper = upper_fence))
  } else {
    return(list(status = "Normal", lower = lower_fence, upper = upper_fence))
  }
}

iqr_initial <- iqr_outlier_check(target_data$initial_performance, all_perf$initial_performance)
iqr_final <- iqr_outlier_check(target_data$final_performance, all_perf$final_performance)
iqr_gain <- iqr_outlier_check(target_data$learning_gain, all_perf$learning_gain)

cat("Method 2: IQR Method (Tukey's Fences)\n")
cat(sprintf("  Initial test: %s (Fences: %.3f - %.3f)\n",
    iqr_initial$status, iqr_initial$lower, iqr_initial$upper))
cat(sprintf("  Final test: %s (Fences: %.3f - %.3f)\n",
    iqr_final$status, iqr_final$lower, iqr_final$upper))
cat(sprintf("  Learning gain: %s (Fences: %.3f - %.3f)\n\n",
    iqr_gain$status, iqr_gain$lower, iqr_gain$upper))

# Method 3: Percentile Ranking
percentile_initial <- ecdf(all_perf$initial_performance)(target_data$initial_performance) * 100
percentile_final <- ecdf(all_perf$final_performance)(target_data$final_performance) * 100
percentile_gain <- ecdf(all_perf$learning_gain)(target_data$learning_gain) * 100

cat("Method 3: Percentile Ranking\n")
cat(sprintf("  Initial test: %.1f percentile %s\n", percentile_initial,
    ifelse(percentile_initial < 5, "[Bottom 5%]", "")))
cat(sprintf("  Final test: %.1f percentile %s\n", percentile_final,
    ifelse(percentile_final < 5, "[Bottom 5%]", "")))
cat(sprintf("  Learning gain: %.1f percentile %s\n\n", percentile_gain,
    ifelse(percentile_gain < 5, "[Bottom 5%]", "")))

# Method 4: Mahalanobis Distance (multivariate outlier)
# Using only initial and final performance (learning gain is derived)
library(stats)
perf_matrix <- all_perf %>%
  select(initial_performance, final_performance) %>%
  as.matrix()
center <- colMeans(perf_matrix)
cov_matrix <- cov(perf_matrix)
target_vector <- c(target_data$initial_performance,
                   target_data$final_performance)

mahal_dist <- tryCatch({
  mahalanobis(t(target_vector), center, cov_matrix)
}, error = function(e) {
  NA
})

if (!is.na(mahal_dist)) {
  # Chi-square critical value for 2 df at p=0.001 is ~13.8, p=0.01 is ~9.2
  cat("Method 4: Mahalanobis Distance (Multivariate)\n")
  cat(sprintf("  Distance: %.3f %s\n", mahal_dist,
      ifelse(mahal_dist > 13.8, "[EXTREME OUTLIER p<0.001]",
      ifelse(mahal_dist > 9.2, "[OUTLIER p<0.01]", "[Normal]"))))
  cat(sprintf("  (Critical values: 9.2 for p<0.01, 13.8 for p<0.001)\n\n"))
  mahal_is_outlier <- mahal_dist > 9.2
} else {
  cat("Method 4: Mahalanobis Distance - Could not compute\n\n")
  mahal_is_outlier <- FALSE
}

# ========== 5. IMPACT ANALYSIS ==========

cat("\n=======================================================\n")
cat("IMPACT OF EXCLUDING THIS PARTICIPANT\n")
cat("=======================================================\n\n")

# Statistics with and without the target participant
with_target <- all_perf
without_target <- all_perf %>% filter(ip != "47.158.129.211")

compare_stats <- function(label, with_val, without_val) {
  diff <- without_val - with_val
  pct_change <- (diff / with_val) * 100
  cat(sprintf("  %s:\n", label))
  cat(sprintf("    With participant: %.4f\n", with_val))
  cat(sprintf("    Without participant: %.4f\n", without_val))
  cat(sprintf("    Change: %+.4f (%+.2f%%)\n\n", diff, pct_change))
}

cat("Initial Test:\n")
compare_stats("Mean",
              mean(with_target$initial_performance),
              mean(without_target$initial_performance))
compare_stats("SD",
              sd(with_target$initial_performance),
              sd(without_target$initial_performance))

cat("Final Test:\n")
compare_stats("Mean",
              mean(with_target$final_performance),
              mean(without_target$final_performance))
compare_stats("SD",
              sd(with_target$final_performance),
              sd(without_target$final_performance))

cat("Learning Gain:\n")
compare_stats("Mean",
              mean(with_target$learning_gain),
              mean(without_target$learning_gain))
compare_stats("SD",
              sd(with_target$learning_gain),
              sd(without_target$learning_gain))

# ========== 6. VISUAL DIAGNOSTICS ==========

# Create diagnostic plots
p1 <- ggplot(all_perf, aes(x = initial_performance)) +
  geom_histogram(bins = 15, fill = "lightblue", color = "black", alpha = 0.7) +
  geom_vline(xintercept = target_data$initial_performance,
             color = "red", linetype = "dashed", linewidth = 1.5) +
  labs(title = "Initial Test Performance Distribution",
       x = "Performance", y = "Count",
       subtitle = "Red line = target participant") +
  theme_minimal(base_size = 12)

p2 <- ggplot(all_perf, aes(x = final_performance)) +
  geom_histogram(bins = 15, fill = "lightgreen", color = "black", alpha = 0.7) +
  geom_vline(xintercept = target_data$final_performance,
             color = "red", linetype = "dashed", linewidth = 1.5) +
  labs(title = "Final Test Performance Distribution",
       x = "Performance", y = "Count",
       subtitle = "Red line = target participant") +
  theme_minimal(base_size = 12)

p3 <- ggplot(all_perf, aes(x = learning_gain)) +
  geom_histogram(bins = 15, fill = "lightyellow", color = "black", alpha = 0.7) +
  geom_vline(xintercept = target_data$learning_gain,
             color = "red", linetype = "dashed", linewidth = 1.5) +
  labs(title = "Learning Gain Distribution",
       x = "Learning Gain", y = "Count",
       subtitle = "Red line = target participant") +
  theme_minimal(base_size = 12)

p4 <- ggplot(all_perf, aes(x = initial_performance, y = final_performance)) +
  geom_point(alpha = 0.6, size = 3) +
  geom_point(data = target_data, aes(x = initial_performance, y = final_performance),
             color = "red", size = 5, shape = 17) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray") +
  labs(title = "Initial vs Final Performance",
       x = "Initial Performance", y = "Final Performance",
       subtitle = "Red triangle = target participant") +
  theme_minimal(base_size = 12)

# Save plots
library(gridExtra)
combined <- grid.arrange(p1, p2, p3, p4, ncol = 2)
ggsave("E1_outlier_diagnostic_plots.png", combined,
       width = 12, height = 10, dpi = 300, bg = "white")

cat("\n=======================================================\n")
cat("RECOMMENDATION\n")
cat("=======================================================\n\n")

# Count how many outlier flags
outlier_flags <- sum(c(
  abs(z_score_initial) > 2.5,
  abs(z_score_final) > 2.5,
  abs(z_score_gain) > 2.5,
  iqr_initial$status %in% c("OUTLIER", "EXTREME OUTLIER"),
  iqr_final$status %in% c("OUTLIER", "EXTREME OUTLIER"),
  iqr_gain$status %in% c("OUTLIER", "EXTREME OUTLIER"),
  percentile_initial < 5,
  percentile_final < 5,
  mahal_is_outlier
))

cat(sprintf("Outlier flags raised: %d out of 9 possible\n\n", outlier_flags))

if (outlier_flags >= 6) {
  cat("RECOMMENDATION: STRONG CASE for exclusion\n")
  cat("This participant shows consistent outlier patterns across multiple\n")
  cat("statistical tests and metrics. Exclusion is justified.\n")
} else if (outlier_flags >= 4) {
  cat("RECOMMENDATION: MODERATE CASE for exclusion\n")
  cat("This participant shows some outlier characteristics. Consider exclusion\n")
  cat("if there are other concerns (e.g., incomplete data, suspicious patterns).\n")
} else {
  cat("RECOMMENDATION: WEAK CASE for exclusion\n")
  cat("This participant does not show strong outlier patterns. Exclusion may\n")
  cat("not be justified based on statistical grounds alone.\n")
}

cat("\nAdditional considerations:\n")
cat("- Impact on sample size vs. impact on validity\n")
cat("- Pre-registration: was exclusion criterion specified?\n")
cat("- Theory: does low performance indicate lack of engagement?\n")
cat("- Transparency: report analyses with and without this participant\n")

cat("\n=======================================================\n")
cat("Diagnostic plots saved to: E1_outlier_diagnostic_plots.png\n")
cat("=======================================================\n")


#### results
# Key Findings:

#   This participant is an EXTREME outlier:

#   1. Initial Test Performance: 0.523 (vs. mean 0.905)
#     - Z-score: -5.158 (extreme outlier)
#     - 0.5th percentile (literally the worst performer)
#     - 5+ standard deviations below mean
#   2. Learning Gain: +0.273 (vs. mean -0.118)
#     - Z-score: +6.892 (extreme outlier)
#     - 100th percentile (highest learning gain)
#     - This massive gain suggests they may have been inattentive
#   initially
#   3. Final Test Performance: 0.795
#     - Normal (50th percentile)
#     - Caught up to average after huge improvement
#   4. Multivariate Analysis:
#     - Mahalanobis Distance: 51.946 (critical value: 13.8 for
#   p<0.001)
#     - This is an extreme multivariate outlier

#   Impact of Exclusion:

#   - Minimal effect on means (<0.3% change)
#   - Reduces variance by 7.4% (initial) and 13.9% (learning gain)
#   - Improves data quality without substantially changing
#   conclusions
#   - Only removes 1 of 183 participants (0.5% of sample)

#   Recommendation:

#   STRONG CASE for exclusion (6 out of 9 outlier flags raised)

#   This pattern suggests possible inattention/lack of engagement
#   during the initial test, followed by proper engagement in the
#   final test. Excluding this participant is statistically
#   justified and will improve data quality.