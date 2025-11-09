# ================================
# Initial Test: Study Position Analysis
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
  filter(item_type == "target") %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number")) %>%
  filter(!(rt < 150 | rt > 3500))

cat("Initial test data prepared:", nrow(initial), "trials\n")

# Validate position data
validate_position_data(initial, "study_position")

# Fit model: Study Position effects for studied (target) items only
m_init_studypos <- glmer(
  accuracy ~ study_position_lin + study_position_quad +
    (1 | participant_id) + (0 + study_position_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Check convergence
cat("\n=== Initial Study Position Model ===\n")
check_convergence_issues(m_init_studypos)

# Get fixed effects summary
results <- broom.mixed::tidy(m_init_studypos, effects = "fixed", conf.int = TRUE)

# Get overall trend estimates
cat("\n=== Overall Study Position Trends (Targets) ===\n")
studypos_lin_trend <- emtrends(m_init_studypos, ~ 1, var = "study_position_lin")
studypos_quad_trend <- emtrends(m_init_studypos, ~ 1, var = "study_position_quad")
print("Linear Trend:")
print(studypos_lin_trend)
print("Quadratic Trend:")
print(studypos_quad_trend)

# Get overall marginal mean
cat("\n=== Overall Accuracy (Targets) ===\n")
studypos_emmean <- emmeans(m_init_studypos, ~ 1)
print(as.data.frame(studypos_emmean))

# Save results
saveRDS(
  list(
    model = m_init_studypos,
    summary = results,
    linear_trend = as.data.frame(studypos_lin_trend),
    quadratic_trend = as.data.frame(studypos_quad_trend),
    emmean = as.data.frame(studypos_emmean)
  ),
  "init_studypos_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "init_studypos") %>%
  write_csv("init_studypos_summary.csv")

cat("\nSaved: init_studypos_model.rds\n")
cat("Saved: init_studypos_summary.csv\n")
