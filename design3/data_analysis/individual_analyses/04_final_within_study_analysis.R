# ================================
# Final Test: Within-Study Position Analysis
# ================================

# Load shared setup
source("00_shared_setup.R")

# Load data
df_e3 <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv") %>%
  mutate(
    accuracy = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    )
  )
cat("Loaded E3_AGGREGATED data with", nrow(df_e3), "rows\n")

# Prepare final test data
final_e3 <- df_e3 %>%
  filter(task == "finalTest") %>%
  mutate(
    participant_id = factor(subject_id),
    item_type = factor(type_comment_fn),
    # Position variables from initial exposure
    initial_study_position = as.numeric(studyPos_appear1_initial),
    initial_test_position = as.numeric(testPos_appear1_initial),
    initial_list_number = as.numeric(listNum_appear1_initial),
    # Final test position (binned into 10 groups)
    final_test_position = case_when(
      testPos_final <= 49 ~ 1,
      testPos_final <= 98 ~ 2,
      testPos_final <= 147 ~ 3,
      testPos_final <= 196 ~ 4,
      testPos_final <= 245 ~ 5,
      testPos_final <= 294 ~ 6,
      testPos_final <= 343 ~ 7,
      testPos_final <= 392 ~ 8,
      testPos_final <= 442 ~ 9,
      testPos_final <= 492 ~ 10,
      TRUE ~ NA_real_
    ),
    accuracy = case_when(correct == "True" ~ 1,
                        correct == "False" ~ 0,
                        TRUE ~ correct)
  ) %>%
  filter(!is.na(accuracy), !is.na(item_type)) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "initial_study_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_test_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_list_number")) %>%
  bind_cols(create_polynomial_terms(., "final_test_position"))

cat("Final test data prepared:", nrow(final_e3), "trials\n")

# Validate position data
validate_position_data(final_e3, "initial_study_position")

# Fit model: Initial Study Position × Item Type (linear only)
m_final_within_study_e3 <- glmer(
  accuracy ~ initial_study_position_lin * item_type + 
  initial_study_position_quad * item_type +
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000)),
  na.action = na.omit
)

# === Final Within-Study Model ===
# Optimization warnings:
 
# Relative gradient: 0.0005252506 


# m_final_within_study <- glmer(
#  accuracy ~ study_position_lin * item_type + study_position_quad * item_type +  # Linear and quadratic
#    (1 | participant_id),                                                         # Random intercept only
#  data = final, family = binomial,
#  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#  na.action = na.omit
# )



# Check convergence
cat("\n=== Final Within-Study Model ===\n")
check_convergence_issues(m_final_within_study_e3)

# Get fixed effects summary
results <- broom.mixed::tidy(m_final_within_study_e3, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends (linear only)
cat("\n=== Item-Type-Specific Trends ===\n")
within_study_lin_trend <- emtrends(m_final_within_study_e3, ~ item_type, var = "initial_study_position_lin")
print("Linear Trends:")
print(within_study_lin_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
within_study_emmeans <- emmeans(m_final_within_study_e3, ~ item_type)
within_study_pairs <- pairs(within_study_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(within_study_emmeans))
print("\nPairwise Comparisons:")
print(within_study_pairs)

# Save results
saveRDS(
  list(
    model = m_final_within_study_e3,
    summary = results,
    linear_trends = as.data.frame(within_study_lin_trend),
    emmeans = as.data.frame(within_study_emmeans),
    pairwise = as.data.frame(within_study_pairs)
  ),
  "final_within_study_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "final_within_study") %>%
  write_csv("final_within_study_summary.csv")

cat("\nSaved: final_within_study_model.rds\n")
cat("Saved: final_within_study_summary.csv\n")
