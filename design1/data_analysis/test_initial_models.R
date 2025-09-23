library(dplyr)
library(readr)
library(lme4)
library(lmerTest)

# Load data
dfchanged <- read_csv("dfchanged.csv", show_col_types = FALSE)

cat("EXPERIMENT 1: TESTING INITIAL MODELS\n")
cat("====================================\n\n")

# Prepare initial test data
initial_data <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    accuracy = as.numeric(correct),
    subject = as.factor(ip),
    study_position = as.numeric(prespos),
    test_position = as.numeric(testpos),
    trial_number = as.numeric(trialnum),
    item_type = ifelse(probetype == "TARGET_target", "Target", "Foil")
  ) %>%
  filter(!is.na(accuracy) & !is.na(study_position) & !is.na(test_position))

cat("Data size:", nrow(initial_data), "rows\n")
cat("Number of subjects:", length(unique(initial_data$subject)), "\n\n")

# Center positions
initial_data$study_pos_c <- scale(initial_data$study_position, center = TRUE, scale = FALSE)[,1]
initial_data$test_pos_c <- scale(initial_data$test_position, center = TRUE, scale = FALSE)[,1]

# Test study position model
cat("1. STUDY POSITION MODEL\n")
cat("-----------------------\n")
study_pos_model <- glmer(accuracy ~ poly(study_pos_c, 2) * item_type +
                        (1 + study_pos_c | subject),
                        data = initial_data, family = binomial,
                        control = glmerControl(optimizer = "bobyqa"))

study_pos_coef <- summary(study_pos_model)$coefficients
print(study_pos_coef)

# Test position model
cat("\n2. TEST POSITION MODEL\n")
cat("----------------------\n")
test_pos_model <- glmer(accuracy ~ test_pos_c * item_type +
                       (1 + test_pos_c | subject),
                       data = initial_data, family = binomial,
                       control = glmerControl(optimizer = "bobyqa"))

test_pos_coef <- summary(test_pos_model)$coefficients
print(test_pos_coef)

# Between-list model
cat("\n3. BETWEEN-LIST MODEL\n")
cat("---------------------\n")
initial_data$trial_num_c <- scale(initial_data$trial_number, center = TRUE, scale = FALSE)[,1]

between_list_model <- glmer(accuracy ~ trial_num_c * item_type +
                           (1 + trial_num_c | subject),
                           data = initial_data, family = binomial,
                           control = glmerControl(optimizer = "bobyqa"))

between_list_coef <- summary(between_list_model)$coefficients
print(between_list_coef)

cat("\nAll initial models fitted successfully!\n")