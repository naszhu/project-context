# Debug script to check data structure
library(tidyverse)

# Load data
dfchanged <- read_csv("dfchanged.csv")

# Extract initial test data
initial_data <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(
    participant_id = PROLIFIC_PID,
    condition,
    trialnum,
    prespos,
    testpos,
    probetype,
    correct,
    stimulus_id,
    prespos_iposintrial_study,
    prespos_iposintrial_test
  ) %>%
  filter(!is.na(correct)) %>%
  mutate(
    # Convert to numeric and handle missing values
    trialnum = as.numeric(trialnum),
    prespos = as.numeric(prespos),
    testpos = as.numeric(testpos),
    prespos_iposintrial_study = as.numeric(prespos_iposintrial_study),
    prespos_iposintrial_test = as.numeric(prespos_iposintrial_test),
    
    # Create study and test positions - use the available data
    study_position = ifelse(!is.na(prespos_iposintrial_study) & prespos_iposintrial_study > 0, 
                           prespos_iposintrial_study, 
                           ifelse(prespos > 0, prespos, NA)),
    test_position = ifelse(!is.na(prespos_iposintrial_test) & prespos_iposintrial_test > 0, 
                          prespos_iposintrial_test, 
                          testpos),
    list_number = trialnum,  # trialnum is already the list number
    item_type = ifelse(probetype == "TARGET_target", "target", "foil"),
    accuracy = as.numeric(correct),
    participant_id = factor(participant_id),
    item_id = factor(stimulus_id),
    item_type = factor(item_type),
    condition = factor(condition)
  ) %>%
  filter(!is.na(test_position), !is.na(list_number), test_position > 0)

# Check data structure
cat("Initial data structure:\n")
cat("Rows:", nrow(initial_data), "\n")
cat("Participants:", length(unique(initial_data$participant_id)), "\n")
cat("Items:", length(unique(initial_data$item_id)), "\n")
cat("Item types:", table(initial_data$item_type), "\n")
cat("Conditions:", table(initial_data$condition), "\n")

# Check for missing values
cat("\nMissing values:\n")
cat("study_position:", sum(is.na(initial_data$study_position)), "\n")
cat("test_position:", sum(is.na(initial_data$test_position)), "\n")
cat("list_number:", sum(is.na(initial_data$list_number)), "\n")
cat("accuracy:", sum(is.na(initial_data$accuracy)), "\n")

# Check factor levels
cat("\nFactor levels:\n")
cat("participant_id levels:", nlevels(initial_data$participant_id), "\n")
cat("item_id levels:", nlevels(initial_data$item_id), "\n")
cat("item_type levels:", nlevels(initial_data$item_type), "\n")
cat("condition levels:", nlevels(initial_data$condition), "\n")

# Check position ranges
cat("\nPosition ranges:\n")
cat("study_position range:", range(initial_data$study_position, na.rm = TRUE), "\n")
cat("test_position range:", range(initial_data$test_position, na.rm = TRUE), "\n")
cat("list_number range:", range(initial_data$list_number, na.rm = TRUE), "\n")

# Check accuracy distribution
cat("\nAccuracy distribution:\n")
cat("Mean accuracy:", mean(initial_data$accuracy, na.rm = TRUE), "\n")
cat("Accuracy by item_type:\n")
print(tapply(initial_data$accuracy, initial_data$item_type, mean, na.rm = TRUE))
