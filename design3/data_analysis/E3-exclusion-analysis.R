library(dplyr)
library(readr)

# Load E3 raw data
df <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv", show_col_types = FALSE)

cat("=======================================================\n")
cat("E3 PARTICIPANT EXCLUSION ANALYSIS\n")
cat("=======================================================\n\n")

# Get test trials only
trial_data <- df %>%
  filter(!is.na(rt)) %>%
  filter(!is.na(correct)) %>%
  mutate(
    rt = as.numeric(rt),
    correct = as.numeric(correct)
  )

cat(sprintf("Total participants in raw data: %d\n", n_distinct(trial_data$subject_id)))
cat(sprintf("Total test trials: %d\n\n", nrow(trial_data)))

# Calculate performance metrics
accuracy_by_participant <- trial_data %>%
  group_by(subject_id) %>%
  summarize(
    n_trials = n(),
    overall_accuracy = mean(correct, na.rm = TRUE),
    .groups = 'drop'
  )

# Calculate RT metrics
rt_by_participant <- trial_data %>%
  group_by(subject_id) %>%
  summarize(
    median_rt = median(rt, na.rm = TRUE),
    mean_rt = mean(rt, na.rm = TRUE),
    sd_rt = sd(rt, na.rm = TRUE),
    min_rt = min(rt, na.rm = TRUE),
    max_rt = max(rt, na.rm = TRUE),
    prop_fast_rt = mean(rt < 200, na.rm = TRUE),
    prop_slow_rt = mean(rt > 10000, na.rm = TRUE),
    .groups = 'drop'
  )

# Get overall statistics
mean_acc <- mean(accuracy_by_participant$overall_accuracy)
sd_acc <- sd(accuracy_by_participant$overall_accuracy)
mean_rt <- mean(rt_by_participant$median_rt)
sd_rt <- sd(rt_by_participant$median_rt)

cat("--- OVERALL STATISTICS ---\n")
cat(sprintf("Accuracy: M = %.3f, SD = %.3f\n", mean_acc, sd_acc))
cat(sprintf("Median RT: M = %.0f ms, SD = %.0f ms\n\n", mean_rt, sd_rt))

# Apply exclusion criteria
excluded <- list()

# 1. Below chance performance (< 0.5)
below_chance <- accuracy_by_participant %>%
  filter(overall_accuracy < 0.5)

if (nrow(below_chance) > 0) {
  for (i in 1:nrow(below_chance)) {
    id <- below_chance$subject_id[i]
    acc <- below_chance$overall_accuracy[i]
    excluded[[id]] <- c(excluded[[id]], sprintf("Below chance (%.1f%%)", acc * 100))
  }
}

# 2. Extremely low accuracy (> 2.5 SD below mean)
threshold_acc <- mean_acc - 2.5 * sd_acc
low_accuracy <- accuracy_by_participant %>%
  filter(overall_accuracy < threshold_acc)

if (nrow(low_accuracy) > 0) {
  for (i in 1:nrow(low_accuracy)) {
    id <- low_accuracy$subject_id[i]
    acc <- low_accuracy$overall_accuracy[i]
    z <- (acc - mean_acc) / sd_acc
    excluded[[id]] <- c(excluded[[id]], sprintf("Extreme low accuracy (%.1f%%, Z=%.2f)", acc * 100, z))
  }
}

# 3. RT outliers (> 3 SD from mean)
upper_rt <- mean_rt + 3 * sd_rt
lower_rt <- mean_rt - 3 * sd_rt

rt_outliers <- rt_by_participant %>%
  filter(median_rt > upper_rt | median_rt < lower_rt)

if (nrow(rt_outliers) > 0) {
  for (i in 1:nrow(rt_outliers)) {
    id <- rt_outliers$subject_id[i]
    rt <- rt_outliers$median_rt[i]
    z <- (rt - mean_rt) / sd_rt
    excluded[[id]] <- c(excluded[[id]], sprintf("RT outlier (%.0f ms, Z=%.2f)", rt, z))
  }
}

# 4. Too many fast responses (> 10% < 200ms)
fast_responders <- rt_by_participant %>%
  filter(prop_fast_rt > 0.1)

if (nrow(fast_responders) > 0) {
  for (i in 1:nrow(fast_responders)) {
    id <- fast_responders$subject_id[i]
    prop <- fast_responders$prop_fast_rt[i]
    excluded[[id]] <- c(excluded[[id]], sprintf("Too many fast RT (%.1f%% < 200ms)", prop * 100))
  }
}

# 5. Check for empty subject IDs
empty_ids <- trial_data %>%
  filter(subject_id == "" | is.na(subject_id)) %>%
  select(subject_id) %>%
  distinct()

if (nrow(empty_ids) > 0) {
  excluded[["EMPTY_ID"]] <- c("Empty subject ID")
}

# 6. Previously identified exclusions
previously_excluded <- c("67ecdf3dcb59c5e0f274ad2d", "6751acc5dc78128951a34f1f", "67f909f80373c9f5af736a5a")

for (id in previously_excluded) {
  if (id %in% accuracy_by_participant$subject_id) {
    perf_data <- accuracy_by_participant %>% filter(subject_id == id)
    rt_data <- rt_by_participant %>% filter(subject_id == id)

    if (!id %in% names(excluded)) {
      excluded[[id]] <- c(sprintf("Previously identified (%.1f%% accuracy)", perf_data$overall_accuracy * 100))
    }
  }
}

# Print exclusion report
cat("\n=======================================================\n")
cat("EXCLUSION REPORT\n")
cat("=======================================================\n\n")

if (length(excluded) > 0) {
  cat(sprintf("Total participants to exclude: %d\n\n", length(excluded)))

  for (id in names(excluded)) {
    reasons <- excluded[[id]]
    cat(sprintf("Participant: %s\n", id))

    # Get detailed stats
    if (id != "EMPTY_ID" && id %in% accuracy_by_participant$subject_id) {
      perf <- accuracy_by_participant %>% filter(subject_id == id)
      rt <- rt_by_participant %>% filter(subject_id == id)

      cat(sprintf("  Accuracy: %.3f (%.1f%%)\n", perf$overall_accuracy, perf$overall_accuracy * 100))
      cat(sprintf("  Median RT: %.0f ms\n", rt$median_rt))
      cat(sprintf("  Trials: %d\n", perf$n_trials))
    }

    cat("  Reasons:\n")
    for (reason in unique(reasons)) {
      cat(sprintf("    - %s\n", reason))
    }
    cat("\n")
  }
} else {
  cat("No participants meet exclusion criteria!\n")
}

# RT trial-level analysis
cat("\n=======================================================\n")
cat("TRIAL-LEVEL RT EXCLUSIONS\n")
cat("=======================================================\n\n")

rt_cutoff_low <- 150
rt_cutoff_high <- 3500

trials_below <- sum(trial_data$rt < rt_cutoff_low, na.rm = TRUE)
trials_above <- sum(trial_data$rt > rt_cutoff_high, na.rm = TRUE)
total_excluded_trials <- trials_below + trials_above

cat(sprintf("RT < %d ms: %d trials (%.2f%%)\n",
    rt_cutoff_low, trials_below, 100 * trials_below / nrow(trial_data)))
cat(sprintf("RT > %d ms: %d trials (%.2f%%)\n",
    rt_cutoff_high, trials_above, 100 * trials_above / nrow(trial_data)))
cat(sprintf("Total trials to exclude: %d (%.2f%%)\n\n",
    total_excluded_trials, 100 * total_excluded_trials / nrow(trial_data)))

# Summary statistics
cat("\n=======================================================\n")
cat("SUMMARY\n")
cat("=======================================================\n\n")

cat(sprintf("Initial sample: %d participants\n", n_distinct(trial_data$subject_id)))
cat(sprintf("Participants to exclude: %d (%.1f%%)\n",
    length(excluded), 100 * length(excluded) / n_distinct(trial_data$subject_id)))
cat(sprintf("Final sample: %d participants\n\n",
    n_distinct(trial_data$subject_id) - length(excluded)))

cat(sprintf("Initial trials: %d\n", nrow(trial_data)))
cat(sprintf("Trials to exclude: %d (%.2f%%)\n",
    total_excluded_trials, 100 * total_excluded_trials / nrow(trial_data)))
cat(sprintf("Final valid trials: %d\n\n", nrow(trial_data) - total_excluded_trials))

# Save exclusion list
exclusion_list <- data.frame(
  subject_id = names(excluded),
  reasons = sapply(excluded, function(x) paste(x, collapse = "; "))
)

write_csv(exclusion_list, "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data_analysis/E3_exclusion_list.csv")
cat("Exclusion list saved to: E3_exclusion_list.csv\n")

cat("\n=======================================================\n")
cat("ANALYSIS COMPLETE\n")
cat("=======================================================\n")
