# ================================
# Final Test: Between-List (Initial Order) Analysis
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
    listNum_appear1_initial = as.numeric(listNum_appear1_initial),
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
    mutate(item_type = case_when(
    initial_list_number == 10 & item_type == "Foil(n), Foil (n+1)" ~ "Foil(n); Appear once",
    initial_list_number == 10 & item_type == "Studied-only (n); Foil (n+1)" ~ "Studied-only (n); Appear once",
    initial_list_number == 10 & item_type == "Target: studied and tested at (n), Foil (n+1)" ~ "Target: : started and tested at (n) ; Appear once",
    TRUE ~ item_type
  )) %>%
  filter(item_type != "Final Foil") %>%
  filter(!is.na(accuracy), !is.na(item_type)) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "initial_study_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_test_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_list_number")) %>%
  bind_cols(create_polynomial_terms(., "final_test_position"))

cat("Final test data prepared:", nrow(final_e3), "trials\n")

# ggplot(final_e3%>%
#   group_by(initial_list_number, item_type,participant_id)%>%
#   summarize(mean_accuracy = mean(accuracy))%>%
#   group_by(initial_list_number, item_type)%>%
#   summarize(mean_accuracy = mean(mean_accuracy)), 
  
#     aes(x = initial_list_number, y = mean_accuracy, color = item_type)) +
# geom_point(size=5) +geom_line(size=2)
# # Validate position data
validate_position_data(final_e3, "initial_list_number")

# Fit model: Initial List Number × Item Type (with quadratic)
m_final_between_initial_e3 <- glmer(
  accuracy ~ initial_list_number_lin * item_type + 
  initial_list_number_quad +
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 200000)),
  na.action = na.omit
)

# === Final Between-List (Initial Order) Model ===
# Convergence warnings:
# Model failed to converge with max|grad| = 0.00587791 (tol = 0.002, component 1) 
# Optimization warnings:
 
# Relative gradient: 0.003833191 

# Check convergence
cat("\n=== Final Between-List (Initial Order) Model ===\n")
check_convergence_issues(m_final_between_initial_e3)

# Get fixed effects summary
results <- broom.mixed::tidy(m_final_between_initial_e3, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
initial_list_lin_trend <- emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_lin")
initial_list_quad_trend <- emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_quad")
print("Linear Trends:")
print(initial_list_lin_trend)
print("Quadratic Trends:")
print(initial_list_quad_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
initial_list_emmeans <- emmeans(m_final_between_initial_e3, ~ item_type)
initial_list_pairs <- pairs(initial_list_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(initial_list_emmeans))
print("\nPairwise Comparisons:")
print(initial_list_pairs)

# Save results
saveRDS(
  list(
    model = m_final_between_initial_e3,
    summary = results,
    linear_trends = as.data.frame(initial_list_lin_trend),
    quadratic_trends = as.data.frame(initial_list_quad_trend),
    emmeans = as.data.frame(initial_list_emmeans),
    pairwise = as.data.frame(initial_list_pairs)
  ),
  "final_between_initial_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "final_between_initial") %>%
  write_csv("final_between_initial_summary.csv")

cat("\nSaved: final_between_initial_model.rds\n")
cat("Saved: final_between_initial_summary.csv\n")
