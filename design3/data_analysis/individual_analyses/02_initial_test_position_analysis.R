# ================================
# Initial Test: Test Position Analysis
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

# Prepare initial test data with confusing foils
initial_e3 <- df_e3 %>%
  filter(task == "initialTest_response") %>%
  mutate(
    participant_id = factor(subject_id),
    item_type = factor(typecomment_in),
    study_position_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_position_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_position = case_when(
      item_type %in% c("Inherented Foil - Last Studied Only", "Inherented Foil - Last Target") &
        !is.na(study_position_alternate) & study_position_alternate > 0 ~ study_position_alternate,
      TRUE ~ study_position_primary
    ),
    test_position = as.numeric(testPos_appear0_initial),
    list_number = as.numeric(listNum_appear0_initial),
    accuracy = correct
  ) %>%
  filter(!is.na(accuracy), !is.na(item_type)) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))

cat("Initial test data prepared:", nrow(initial_e3), "trials\n")

# Validate position data
validate_position_data(initial_e3, "test_position")

# Fit model: Test Position × Item Type
m_init_testpos_e3 <- glmer(
  accuracy ~ test_position_lin * item_type +
  test_position_quad * item_type + 
    (1 | participant_id) ,
  data = initial_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa",,
    check.conv.grad = list(action = "ignore", tol = 0.002)
  ),
  na.action = na.omit
)


# === Initial Test Position Model ===
# Optimization warnings:
 
# Relative gradient: 0.002186941 
# m_init_testpos <- glmer(
#  accuracy ~ (test_position_lin + test_position_quad) * item_type +
#    (1 | participant_id) + (0 + test_position_lin | participant_id),
#  data = initial_e3, family = binomial,
#  control = glmerControl(optimizer = "bobyqa"),
#  na.action = na.omit
# )


# Check convergence
cat("\n=== Initial Test Position Model ===\n")
check_convergence_issues(m_init_testpos_e3)

# Get fixed effects summary
results <- broom.mixed::tidy(m_init_testpos_e3, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
testpos_lin_trend <- emtrends(m_init_testpos_e3, ~ item_type, var = "test_position_lin")
testpos_quad_trend <- emtrends(m_init_testpos_e3, ~ item_type, var = "test_position_quad")
print("Linear Trends:")
print(testpos_lin_trend)
print("Quadratic Trends:")
print(testpos_quad_trend)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
testpos_emmeans <- emmeans(m_init_testpos_e3, ~ item_type)
testpos_pairs <- pairs(testpos_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(testpos_emmeans))
print("\nPairwise Comparisons:")
print(testpos_pairs)

# Save results
saveRDS(
  list(
    model = m_init_testpos_e3,
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
