# ================================
# Initial Test: Test Position Analysis
# ================================

# Load shared setup
source("00_shared_setup.R")

# Load data
dfchanged <- read_csv("../dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# Prepare initial test data
initial <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = as.numeric(prespos),
    test_position  = as.numeric(testpos),
    list_number    = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(item_type = factor(item_type, levels = c("foil","target"))) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))%>%
  filter(!(rt < 150 | rt > 3500))

cat("Initial test data prepared:", nrow(initial), "trials\n")

# Validate position data
validate_position_data(initial, "test_position")

# Fit model: Test Position × Item Type
m_init_testpos <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id) + (0 + test_position_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Check convergence
cat("\n=== Initial Test Position Model ===\n")
check_convergence_issues(m_init_testpos)

# Get fixed effects summary
results <- broom.mixed::tidy(m_init_testpos, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
testpos_lin_trend <- emtrends(m_init_testpos, ~ item_type, var = "test_position_lin")
testpos_quad_trend <- emtrends(m_init_testpos, ~ item_type, var = "test_position_quad")
print("Linear Trends:")
print(testpos_lin_trend)
print("Quadratic Trends:")
print(testpos_quad_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
testpos_emmeans <- emmeans(m_init_testpos, ~ item_type)
testpos_pairs <- pairs(testpos_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(testpos_emmeans))
print("\nPairwise Comparisons:")
print(testpos_pairs)

# Save results
saveRDS(
  list(
    model = m_init_testpos,
    summary = results,
    linear_trends = as.data.frame(testpos_lin_trend),
    quadratic_trends = as.data.frame(testpos_quad_trend),
    emmeans = as.data.frame(testpos_emmeans),
    pairwise = as.data.frame(testpos_pairs)
  ),
  "init_testpos_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "init_testpos") %>%
  write_csv("init_testpos_summary.csv")

cat("\nSaved: init_testpos_model.rds\n")
cat("Saved: init_testpos_summary.csv\n")
