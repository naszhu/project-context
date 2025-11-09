# ================================
# Final Test: Within-Test Position Analysis
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
    item_type_raw = type_comment_fn,
    # Position variables from initial exposure
    initial_study_position = as.numeric(studyPos_appear1_initial),
    initial_test_position_primary = suppressWarnings(as.numeric(testPos_appear1_initial)),
    initial_test_position_confusing = suppressWarnings(as.numeric(testPos_appear2_initial)),
    is_confusing_foil = item_type_raw %in% c(
      "Target: studied and tested at (n), Foil (n+1)",
      "Studied-only (n); Foil (n+1)",
      "Foil(n), Foil (n+1)"
    ),
    initial_test_position = case_when(
      is_confusing_foil & !is.na(initial_test_position_confusing) & initial_test_position_confusing > 0 ~
        initial_test_position_confusing,
      TRUE ~ initial_test_position_primary
    ),
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
    accuracy = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ correct
    ),
    item_type = case_when(
      item_type_raw == "Target: : started and tested at (n) ; Appear once" ~ "ST",
      item_type_raw == "Target: studied and tested at (n), Foil (n+1)" ~ "ST(n)",
      item_type_raw == "Foil(n); Appear once" ~ "TO",
      item_type_raw == "Foil(n), Foil (n+1)" ~ "TO(n)",
      item_type_raw == "Studied-only (n); Foil (n+1)" ~ "SO(n)",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(
    !item_type_raw %in% c(
      "Final Foil",
      "Studied-only (n); Appear once"
    )
  ) %>%
  filter(
    !is.na(accuracy),
    !is.na(item_type),
    !is.na(initial_test_position),
    initial_test_position > 0
  ) %>%
  mutate(
    item_type = factor(item_type, levels = c("ST", "ST(n)", "TO", "TO(n)", "SO(n)"))
  ) %>%
  select(
    participant_id,
    item_type,
    accuracy,
    initial_study_position,
    initial_test_position,
    initial_list_number,
    final_test_position
  ) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "initial_study_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_test_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_list_number")) %>%
  bind_cols(create_polynomial_terms(., "final_test_position"))

cat("Final test data prepared:", nrow(final_e3), "trials\n")

# Validate position data
validate_position_data(final_e3, "initial_test_position")

# Fit model: Initial Test Position × Item Type (linear only)
m_final_within_test_e3 <- glmer(
  accuracy ~ initial_test_position_lin * item_type + 
  initial_test_position_quad * item_type +
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000)),
  na.action = na.omit
)

# === Final Within-Test Model ===
# Optimization warnings:
 
# Relative gradient: 0.006185551 
# WARNING: Large relative gradient - model may not have converged

# Check convergence
cat("\n=== Final Within-Test Model ===\n")
check_convergence_issues(m_final_within_test_e3)

# Get fixed effects summary
results <- broom.mixed::tidy(m_final_within_test_e3, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends (linear only)
cat("\n=== Item-Type-Specific Trends ===\n")
within_test_lin_trend <- emtrends(m_final_within_test_e3, ~ item_type, var = "initial_test_position_lin")
print("Linear Trends:")
print(within_test_lin_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
within_test_emmeans <- emmeans(m_final_within_test_e3, ~ item_type)
within_test_pairs <- pairs(within_test_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(within_test_emmeans))
print("\nPairwise Comparisons:")
print(within_test_pairs)

# Save results
saveRDS(
  list(
    model = m_final_within_test_e3,
    summary = results,
    linear_trends = as.data.frame(within_test_lin_trend),
    emmeans = as.data.frame(within_test_emmeans),
    pairwise = as.data.frame(within_test_pairs)
  ),
  "final_within_test_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "final_within_test") %>%
  write_csv("final_within_test_summary.csv")

cat("\nSaved: final_within_test_model.rds\n")
cat("Saved: final_within_test_summary.csv\n")
