# FINAL TEST — FAST ANALYSIS (aggregated data)

library(dplyr)
library(readr)
library(tidyr)
library(lme4)
library(broom.mixed)
library(purrr)

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

    # exposure history
    exposure_history = case_when(
      initial_probetype == "TARGET_target"    ~ "studied_and_tested",
      initial_probetype == "TARGET_nontarget" ~ "studied_only",
      initial_probetype == "TARGET_foil"      ~ "tested_only",
      probetype == "FOIL"                     ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(accuracy), !is.na(exposure_history))

# ------------------------------------------------------------
# DESCRIPTIVE STATISTICS BY EXPOSURE HISTORY
# ------------------------------------------------------------
cat("\n=== EXPOSURE HISTORY DESCRIPTIVES ===\n")
exposure_stats <- final_dat %>%
  group_by(exposure_history) %>%
  summarise(
    mean_accuracy = round(mean(accuracy, na.rm = TRUE), 3),
    sd_accuracy = round(sd(accuracy, na.rm = TRUE), 3),
    n = n(),
    .groups = 'drop'
  )
print(exposure_stats)

# Create position bins for analysis
bin_positions <- function(pos, n_bins = 5) {
  if(all(is.na(pos))) return(rep(NA, length(pos)))
  cut(pos, breaks = n_bins, labels = 1:n_bins, include.lowest = TRUE)
}

# ------------------------------------------------------------
# 1. WITHIN-LIST EFFECTS: INITIAL STUDY ORDER
# ------------------------------------------------------------
cat("\n=== WITHIN-LIST EFFECTS: INITIAL STUDY ORDER ===\n")

within_study_data <- final_dat %>%
  filter(!is.na(initial_prespos),
         exposure_history %in% c("studied_and_tested","studied_only","tested_only")) %>%
  mutate(
    initial_study_bin = bin_positions(initial_prespos, 5),
    initial_study_position = case_when(
      initial_prespos <= 4 ~ "early",
      initial_prespos >= 17 ~ "late",
      TRUE ~ "middle"
    )
  ) %>%
  filter(!is.na(initial_study_bin))

# Aggregate by position
within_study_summary <- within_study_data %>%
  group_by(exposure_history, initial_study_position) %>%
  summarise(
    mean_acc = round(mean(accuracy), 3),
    sd_acc = round(sd(accuracy), 3),
    n = n(),
    .groups = 'drop'
  ) %>%
  pivot_wider(names_from = initial_study_position, values_from = c(mean_acc, sd_acc, n))

print(within_study_summary)

# Linear trend test (simplified)
within_study_trend <- within_study_data %>%
  group_by(ip, exposure_history, initial_prespos) %>%
  summarise(mean_acc = mean(accuracy), .groups = 'drop') %>%
  group_by(exposure_history) %>%
  do(trend = cor.test(.$initial_prespos, .$mean_acc, method = "pearson")) %>%
  mutate(
    correlation = map_dbl(trend, ~ .$estimate),
    p_value = map_dbl(trend, ~ .$p.value)
  ) %>%
  select(-trend)

cat("\nTrend analysis (correlation with initial study position):\n")
print(within_study_trend)

# ------------------------------------------------------------
# 2. WITHIN-LIST EFFECTS: INITIAL TEST ORDER
# ------------------------------------------------------------
cat("\n=== WITHIN-LIST EFFECTS: INITIAL TEST ORDER ===\n")

within_test_data <- final_dat %>%
  filter(!is.na(initial_testpos),
         exposure_history %in% c("studied_and_tested","tested_only")) %>%
  mutate(
    initial_test_position = case_when(
      initial_testpos <= 3 ~ "early",
      initial_testpos >= 8 ~ "late",
      TRUE ~ "middle"
    )
  )

within_test_summary <- within_test_data %>%
  group_by(exposure_history, initial_test_position) %>%
  summarise(
    mean_acc = round(mean(accuracy), 3),
    sd_acc = round(sd(accuracy), 3),
    n = n(),
    .groups = 'drop'
  ) %>%
  pivot_wider(names_from = initial_test_position, values_from = c(mean_acc, sd_acc, n))

print(within_test_summary)

within_test_trend <- within_test_data %>%
  group_by(ip, exposure_history, initial_testpos) %>%
  summarise(mean_acc = mean(accuracy), .groups = 'drop') %>%
  group_by(exposure_history) %>%
  do(trend = cor.test(.$initial_testpos, .$mean_acc, method = "pearson")) %>%
  mutate(
    correlation = map_dbl(trend, ~ .$estimate),
    p_value = map_dbl(trend, ~ .$p.value)
  ) %>%
  select(-trend)

cat("\nTrend analysis (correlation with initial test position):\n")
print(within_test_trend)

# ------------------------------------------------------------
# 3. BETWEEN-LIST EFFECTS: FINAL TEST ORDER
# ------------------------------------------------------------
cat("\n=== BETWEEN-LIST EFFECTS: FINAL TEST ORDER ===\n")

between_final_data <- final_dat %>%
  mutate(
    final_test_position = case_when(
      testpos <= quantile(testpos, 0.33, na.rm = TRUE) ~ "early",
      testpos >= quantile(testpos, 0.67, na.rm = TRUE) ~ "late",
      TRUE ~ "middle"
    )
  )

between_final_summary <- between_final_data %>%
  group_by(exposure_history, final_test_position) %>%
  summarise(
    mean_acc = round(mean(accuracy), 3),
    sd_acc = round(sd(accuracy), 3),
    n = n(),
    .groups = 'drop'
  ) %>%
  pivot_wider(names_from = final_test_position, values_from = c(mean_acc, sd_acc, n))

print(between_final_summary)

between_final_trend <- between_final_data %>%
  group_by(ip, exposure_history, testpos) %>%
  summarise(mean_acc = mean(accuracy), .groups = 'drop') %>%
  group_by(exposure_history) %>%
  do(trend = cor.test(.$testpos, .$mean_acc, method = "pearson")) %>%
  mutate(
    correlation = map_dbl(trend, ~ .$estimate),
    p_value = map_dbl(trend, ~ .$p.value)
  ) %>%
  select(-trend)

cat("\nTrend analysis (correlation with final test position):\n")
print(between_final_trend)

# ------------------------------------------------------------
# 4. BETWEEN-LIST EFFECTS: INITIAL LIST ORDER
# ------------------------------------------------------------
cat("\n=== BETWEEN-LIST EFFECTS: INITIAL LIST ORDER ===\n")

between_list_data <- final_dat %>%
  filter(!is.na(initial_list_index)) %>%
  mutate(
    list_position = case_when(
      initial_list_index <= 3 ~ "early_lists",
      initial_list_index >= 8 ~ "late_lists",
      TRUE ~ "middle_lists"
    )
  )

between_list_summary <- between_list_data %>%
  group_by(exposure_history, condition, list_position) %>%
  summarise(
    mean_acc = round(mean(accuracy), 3),
    sd_acc = round(sd(accuracy), 3),
    n = n(),
    .groups = 'drop'
  ) %>%
  pivot_wider(names_from = list_position, values_from = c(mean_acc, sd_acc, n))

print(between_list_summary)

between_list_trend <- between_list_data %>%
  group_by(ip, exposure_history, condition, initial_list_index) %>%
  summarise(mean_acc = mean(accuracy), .groups = 'drop') %>%
  group_by(exposure_history, condition) %>%
  do(trend = cor.test(.$initial_list_index, .$mean_acc, method = "pearson")) %>%
  mutate(
    correlation = map_dbl(trend, ~ .$estimate),
    p_value = map_dbl(trend, ~ .$p.value)
  ) %>%
  select(-trend)

cat("\nTrend analysis (correlation with initial list order by condition):\n")
print(between_list_trend)

cat("\n=== ANALYSIS COMPLETE ===\n")
cat("Summary statistics calculated for all final test analyses.\n")