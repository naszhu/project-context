# ================================
# Data Exploration and Validation
# Check if analysis makes sense
# ================================
library(tidyverse)
library(readr)

# Load data
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# ================================
# Helper Function (Same as Bayesian analysis)
# ================================
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  if (all(is.na(v))) {
    out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
    return(out)
  }
  
  v_center <- v - mean(v, na.rm = TRUE)
  unique_vals <- unique(na.omit(v_center))
  n_unique <- length(unique_vals)
  
  if (n_unique < 2) {
    out <- data.frame(lin = rep(0, length(v)), quad = rep(0, length(v)))
  } else if (n_unique == 2) {
    lin <- as.integer(v_center == unique_vals[2])
    out <- data.frame(lin = lin, quad = rep(0, length(v)))
  } else {
    nona_idx <- !is.na(v_center)
    if (sum(nona_idx) < 3) {
      out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    } else {
      poly_res <- poly(v_center[nona_idx], degree = 2, raw = FALSE, simple = TRUE)
      lin <- rep(NA, length(v))
      quad <- rep(NA, length(v))
      lin[nona_idx] <- poly_res[,1]
      quad[nona_idx] <- poly_res[,2]
      out <- data.frame(lin = lin, quad = quad)
    }
  }
  
  names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
  return(out)
}

# ================================
# 1. Overall Data Structure
# ================================
cat("\n=== OVERALL DATA STRUCTURE ===\n")

cat("Total rows in dataset:", nrow(dfchanged), "\n")
cat("Total columns in dataset:", ncol(dfchanged), "\n")
cat("Column names:\n")
print(names(dfchanged))

cat("\nTask types in dataset:\n")
print(table(dfchanged$task, useNA = "ifany"))

cat("\nConditions in dataset:\n")
print(table(dfchanged$condition, useNA = "ifany"))

cat("\nProbe types in dataset:\n")
print(table(dfchanged$probetype, useNA = "ifany"))

# ================================
# 2. Final Test Data Availability
# ================================
cat("\n=== FINAL TEST DATA AVAILABILITY ===\n")

final_test_data <- dfchanged %>%
  filter(task == "finalt_response")

cat("Final test responses:", nrow(final_test_data), "\n")
cat("Final test participants:", length(unique(final_test_data$ip)), "\n")

cat("\nFinal test by condition:\n")
print(table(final_test_data$condition, useNA = "ifany"))

cat("\nFinal test by probe type:\n")
print(table(final_test_data$probetype, useNA = "ifany"))

cat("\nFinal test by condition and probe type:\n")
print(table(final_test_data$condition, final_test_data$probetype, useNA = "ifany"))

# ================================
# 3. Data Preparation Check
# ================================
cat("\n=== DATA PREPARATION CHECK ===\n")

# Create initial position data (same as analysis)
df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, stimulus_id)

wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id))

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>%
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

cat("Initial positions found for", nrow(initial_positions), "items\n")

# Create final test data (same as analysis)
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  select(ip, correct, probetype, stimulus_id, testpos, trialnum, prespos_itrial, condition) %>%
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  mutate(
    participant_id = factor(ip),
    accuracy = as.numeric(correct),
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO", 
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    ),
    study_position = case_when(item_type %in% c("ST","SO") ~ as.numeric(initial_prespos),
                               TRUE ~ NA_real_),
    test_position  = case_when(item_type %in% c("ST","TO") ~ as.numeric(initial_testpos),
                               TRUE ~ NA_real_),
    final_order    = as.numeric(cut_number(as.numeric(testpos), 10, labels = 1:10)),
    initial_order  = as.numeric(prespos_itrial)
  ) %>%
  filter(!is.na(study_position) | !is.na(test_position) | !is.na(final_order) | !is.na(initial_order)) %>%
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition)

cat("\nFinal analysis dataset:\n")
cat("Total observations:", nrow(final), "\n")
cat("Participants:", length(unique(final$participant_id)), "\n")

# ================================
# 4. Key Variables Check
# ================================
cat("\n=== KEY VARIABLES CHECK ===\n")

cat("\nItem types in final dataset:\n")
print(table(final$item_type, useNA = "ifany"))

cat("\nConditions in final dataset:\n")
print(table(final$condition, useNA = "ifany"))

cat("\nItem types by condition:\n")
print(table(final$condition, final$item_type, useNA = "ifany"))

cat("\nFinal order distribution:\n")
print(table(final$final_order, useNA = "ifany"))

# ================================
# 5. Sample Size Check
# ================================
cat("\n=== SAMPLE SIZE CHECK ===\n")

# Check sample sizes for each combination
sample_sizes <- final %>%
  group_by(condition, item_type) %>%
  summarize(
    n_obs = n(),
    n_participants = n_distinct(participant_id),
    mean_accuracy = mean(accuracy, na.rm = TRUE),
    .groups = 'drop'
  )

print(sample_sizes)

# Check if we have enough data for each final_order position
position_check <- final %>%
  group_by(condition, item_type, final_order) %>%
  summarize(
    n_obs = n(),
    mean_accuracy = mean(accuracy, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  filter(n_obs < 5)  # Flag positions with very few observations

cat("\nPositions with < 5 observations (potential issues):\n")
if (nrow(position_check) > 0) {
  print(position_check)
} else {
  cat("All positions have >= 5 observations\n")
}

# ================================
# 6. Polynomial Terms Check
# ================================
cat("\n=== POLYNOMIAL TERMS CHECK ===\n")

# Add polynomial terms
final_with_poly <- final %>%
  bind_cols(create_polynomial_terms(., "final_order"))

cat("Polynomial terms added successfully\n")

cat("Final order linear term range:", range(final_with_poly$final_order_lin, na.rm = TRUE), "\n")
cat("Final order quadratic term range:", range(final_with_poly$final_order_quad, na.rm = TRUE), "\n")

cat("Missing values in polynomial terms:\n")
cat("Linear term NAs:", sum(is.na(final_with_poly$final_order_lin)), "\n")
cat("Quadratic term NAs:", sum(is.na(final_with_poly$final_order_quad)), "\n")

# ================================
# 7. Accuracy Distribution Check
# ================================
cat("\n=== ACCURACY DISTRIBUTION CHECK ===\n")

accuracy_summary <- final %>%
  group_by(condition, item_type) %>%
  summarize(
    mean_accuracy = mean(accuracy, na.rm = TRUE),
    sd_accuracy = sd(accuracy, na.rm = TRUE),
    min_accuracy = min(accuracy, na.rm = TRUE),
    max_accuracy = max(accuracy, na.rm = TRUE),
    .groups = 'drop'
  )

print(accuracy_summary)

# Check for extreme values
extreme_accuracy <- final %>%
  group_by(condition, item_type) %>%
  summarize(
    perfect_performance = sum(accuracy == 1, na.rm = TRUE) / n(),
    zero_performance = sum(accuracy == 0, na.rm = TRUE) / n(),
    .groups = 'drop'
  )

cat("\nExtreme performance patterns:\n")
print(extreme_accuracy)

# ================================
# 8. Analysis Feasibility Assessment
# ================================
cat("\n=== ANALYSIS FEASIBILITY ASSESSMENT ===\n")

# Check minimum sample sizes
min_samples <- sample_sizes %>%
  group_by(condition) %>%
  summarize(min_obs = min(n_obs), min_participants = min(n_participants), .groups = 'drop')

cat("\nMinimum sample sizes by condition:\n")
print(min_samples)

# Check if we have sufficient data for 3-way interactions
interaction_check <- final %>%
  group_by(condition, item_type, final_order) %>%
  summarize(n_obs = n(), .groups = 'drop') %>%
  summarize(
    min_cell_size = min(n_obs),
    mean_cell_size = mean(n_obs),
    cells_with_data = sum(n_obs > 0),
    total_possible_cells = n()
  )

cat("\nInteraction term feasibility:\n")
print(interaction_check)

# ================================
# 9. Recommendations
# ================================
cat("\n=== RECOMMENDATIONS ===\n")

if (min(sample_sizes$n_obs) < 10) {
  cat("⚠️  WARNING: Some condition × item_type combinations have < 10 observations\n")
  cat("   Consider collapsing some categories or using simpler models\n")
}

if (interaction_check$min_cell_size < 3) {
  cat("⚠️  WARNING: Some 3-way interaction cells have < 3 observations\n")
  cat("   Consider using 2-way interactions instead of 3-way\n")
}

if (min(min_samples$min_participants) < 5) {
  cat("⚠️  WARNING: Some conditions have < 5 participants\n")
  cat("   Consider including all participants or checking data quality\n")
}

cat("\n✅ Data exploration complete!\n")
cat("Check the output above to ensure your analysis is feasible.\n")
