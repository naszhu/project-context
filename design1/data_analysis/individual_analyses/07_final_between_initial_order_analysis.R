# ================================
# Final Test: Between-List Initial Order Analysis
# ================================

# Load shared setup
source("00_shared_setup.R")

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

# Add polynomial terms
final <- final %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "final_order")) %>%
  bind_cols(create_polynomial_terms(., "initial_order"))

cat("Final test data prepared:", nrow(final), "trials\n")

# Validate position data
validate_position_data(final, "initial_order")

# Fit model: Initial Order × Item Type × Condition
# Note: Simplified quadratic interactions to avoid convergence issues
m_between_initial <- glmer(
  accuracy ~ initial_order_lin * item_type * condition +
             initial_order_quad * condition +
             initial_order_quad * item_type +
    (1 | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
  na.action = na.omit
)

# Check convergence
cat("\n=== Final Between-Initial Order Model ===\n")
check_convergence_issues(m_between_initial)

# Get fixed effects summary
results <- broom.mixed::tidy(m_between_initial, effects = "fixed", conf.int = TRUE)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
initial_order_lin <- emtrends(m_between_initial, ~ item_type, var = "initial_order_lin")
initial_order_quad <- emtrends(m_between_initial, ~ item_type, var = "initial_order_quad")
print("Linear Trends:")
print(initial_order_lin)
print("Quadratic Trends:")
print(initial_order_quad)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
initial_order_emmeans <- emmeans(m_between_initial, ~ item_type)
initial_order_pairs <- pairs(initial_order_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(initial_order_emmeans))
print("\nPairwise Comparisons:")
print(initial_order_pairs)

# Condition × Position interaction analysis
cat("\n=== Condition × Initial Order Interactions ===\n")
initial_order_condition_lin <- emtrends(m_between_initial, ~ condition | item_type, var = "initial_order_lin")
initial_order_condition_quad <- emtrends(m_between_initial, ~ condition | item_type, var = "initial_order_quad")

print("Linear Trends by Condition and Item Type:")
print(initial_order_condition_lin)
print("\nQuadratic Trends by Condition and Item Type:")
print(initial_order_condition_quad)

# Test pairwise differences between conditions
cat("\n=== Pairwise Comparisons of Condition Effects ===\n")
initial_order_condition_pairs_lin <- pairs(initial_order_condition_lin, by = "item_type", adjust = "tukey")
initial_order_condition_pairs_quad <- pairs(initial_order_condition_quad, by = "item_type", adjust = "tukey")

print("Linear Trend Differences Between Conditions:")
print(initial_order_condition_pairs_lin)
print("\nQuadratic Trend Differences Between Conditions:")
print(initial_order_condition_pairs_quad)

# Save results
saveRDS(
  list(
    model = m_between_initial,
    summary = results,
    linear_trends = as.data.frame(initial_order_lin),
    quadratic_trends = as.data.frame(initial_order_quad),
    emmeans = as.data.frame(initial_order_emmeans),
    pairwise = as.data.frame(initial_order_pairs),
    condition_linear_trends = as.data.frame(initial_order_condition_lin),
    condition_quadratic_trends = as.data.frame(initial_order_condition_quad),
    condition_linear_pairs = as.data.frame(initial_order_condition_pairs_lin),
    condition_quadratic_pairs = as.data.frame(initial_order_condition_pairs_quad)
  ),
  "final_between_initial_order_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "final_between_initial") %>%
  write_csv("final_between_initial_order_summary.csv")

cat("\nSaved: final_between_initial_order_model.rds\n")
cat("Saved: final_between_initial_order_summary.csv\n")
