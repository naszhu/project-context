# ================================
# Final Test: Between-List Final Order Analysis (FAST VERSION FOR TESTING)
# ================================

# Load shared setup
source("00_shared_setup.R")

# ========================================
# SPEED-UP OPTIONS (SET TO FALSE FOR FULL ANALYSIS)
# ========================================
TEST_MODE <- TRUE  # Set to FALSE for full analysis
SAMPLE_FRACTION <- 0.2  # Use 20% of data (increase for more data)
SIMPLIFIED_MODEL <- TRUE  # Use simpler model structure
REDUCE_ITERATIONS <- TRUE  # Reduce max iterations

# Load data
dfchanged <- read_csv("../dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# Prepare initial position data
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

# Create a lookup table with both study and test positions
initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Create final test data
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  select(ip, correct, probetype, stimulus_id, testpos, trialnum, prespos_itrial, condition, rt) %>%
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
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition, rt)%>%
  filter(!(rt < 150 | rt > 3500))

# SPEED-UP: Sample data if in test mode
if (TEST_MODE) {
  set.seed(123)  # For reproducibility
  n_samples <- round(nrow(final) * SAMPLE_FRACTION)
  final <- final %>% slice_sample(n = n_samples)
  cat("TEST MODE: Using", nrow(final), "rows (", SAMPLE_FRACTION*100, "% of data)\n")
}

# Add polynomial terms
final <- final %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "final_order")) %>%
  bind_cols(create_polynomial_terms(., "initial_order"))

cat("Final test data prepared:", nrow(final), "trials\n")

# Validate position data
validate_position_data(final, "final_order")

# Set max iterations
max_iterations <- if(REDUCE_ITERATIONS) 50000 else 500000

# Fit model: Choose simplified or full model
if (SIMPLIFIED_MODEL) {
  cat("\nFitting SIMPLIFIED model (faster)...\n")
  # Simpler model: remove 3-way interaction, keep 2-way
  m_between_final <- glmer(
    accuracy ~ final_order_lin * item_type + final_order_lin * condition +
      final_order_quad * item_type +
      (1 | participant_id),
    data = final, family = binomial,
    control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = max_iterations)),
    na.action = na.omit
  )
} else {
  cat("\nFitting FULL model (slower)...\n")
  # Full model with 3-way interactions
  m_between_final <- glmer(
    accuracy ~ final_order_lin * item_type * condition + final_order_quad * item_type * condition +
      final_order_quad * item_type +
      (1 | participant_id),
    data = final, family = binomial,
    control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = max_iterations)),
    na.action = na.omit
  )
}

# Check convergence
cat("\n=== Final Between-Final Order Model ===\n")
check_convergence_issues(m_between_final)

# Get fixed effects summary
results <- broom.mixed::tidy(m_between_final, effects = "fixed", conf.int = TRUE)
print(results)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
final_order_lin <- emtrends(m_between_final, ~ item_type, var = "final_order_lin")
final_order_quad <- emtrends(m_between_final, ~ item_type, var = "final_order_quad")
print("Linear Trends:")
print(final_order_lin)
print("Quadratic Trends:")
print(final_order_quad)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
final_order_emmeans <- emmeans(m_between_final, ~ item_type)
final_order_pairs <- pairs(final_order_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(final_order_emmeans))
print("\nPairwise Comparisons:")
print(final_order_pairs)

if (TEST_MODE) {
  cat("\n========================================\n")
  cat("TEST MODE COMPLETE!\n")
  cat("To run full analysis:\n")
  cat("1. Set TEST_MODE <- FALSE\n")
  cat("2. Set SIMPLIFIED_MODEL <- FALSE (optional)\n")
  cat("3. Set REDUCE_ITERATIONS <- FALSE (optional)\n")
  cat("========================================\n")
}

cat("\nModel fitting complete!\n")
