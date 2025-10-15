# ================================
# Final Test: Combined Between-List Order Analysis
# ================================
# This analysis combines initial-order and final-order between-list effects
# accounting for the fact that:
# - Forward condition: initial_order = final_order (same sequential order)
# - Backward condition: initial_order = mirror of final_order (list 1 initial = list 10 final)
# - Random condition: initial_order ≠ final_order (items mixed across lists)

# Load shared setup
source("00_shared_setup.R")

# Load data
dfchanged <- read_csv("../dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# Prepare initial position data (SAME AS ORIGINAL - DO NOT MODIFY)
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

# Create a lookup table with both study and test positions (SAME AS ORIGINAL)
initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Create final test data (SAME AS ORIGINAL)
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
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition, rt) %>%
  filter(!(rt < 150 | rt > 3500))

# === NEW: Create combined dataset with ordering_type factor ===
# For forward & backward: use final_order with appropriate labeling
# For random: include both final_order and initial_order as separate rows

final_forward_backward <- final %>%
  filter(condition %in% c("forward", "backward")) %>%
  mutate(
    list_order = final_order,
    ordering_type = "by_final_order"  # Forward and backward use final_order
  )

final_random_final <- final %>%
  filter(condition == "random") %>%
  mutate(
    list_order = final_order,
    ordering_type = "by_final_order"
  )

final_random_initial <- final %>%
  filter(condition == "random") %>%
  mutate(
    list_order = initial_order,
    ordering_type = "by_initial_order"
  )

# Combine all conditions
final_combined <- bind_rows(
  final_forward_backward,
  final_random_final,
  final_random_initial
) %>%
  mutate(
    ordering_type = factor(ordering_type, levels = c("by_final_order", "by_initial_order")),
    condition = factor(condition, levels = c("forward", "backward", "random"))
  )

# Add polynomial terms for the combined list_order variable
final_combined <- final_combined %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_order"))

cat("Combined final test data prepared:", nrow(final_combined), "trials\n")
cat("Breakdown by condition and ordering_type:\n")
print(table(final_combined$condition, final_combined$ordering_type))

# Validate position data
validate_position_data(final_combined, "list_order")

# ================================
# MODEL 1: MAIN MODEL (ACTIVE)
# ================================
# This model treats condition × ordering_type as key predictors
# - For forward/backward: only by_final_order exists
# - For random: both ordering types exist and can be compared

# MODEL 2: Simpler interaction structure (if convergence issues arise)
# version left:
# m_combined <- glmer(
#   accuracy ~ list_order_lin * item_type * condition +
#              list_order_lin * item_type * ordering_type +
#              list_order_quad * item_type * condition +
#              list_order_quad * item_type +
#     (1 | participant_id),
#   data = final_combined, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# version on the right

# MODEL 2: Simpler interaction structure (if convergence issues arise)
# m_combined <- glmer(
#   accuracy ~ list_order_lin * item_type * condition +
#              list_order_lin * item_type * ordering_type +
#              list_order_quad * item_type +
#              list_order_quad * ordering_type +
#     (1 | participant_id),
#   data = final_combined, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit)


# Check convergence
cat("\n=== Combined Between-List Order Model ===\n")
check_convergence_issues(m_combined)

# Get fixed effects summary
results <- broom.mixed::tidy(m_combined, effects = "fixed", conf.int = TRUE)
print(results)

# Get item-type-specific trends
cat("\n=== Item-Type-Specific Trends ===\n")
list_order_lin <- emtrends(m_combined, ~ item_type, var = "list_order_lin")
list_order_quad <- emtrends(m_combined, ~ item_type, var = "list_order_quad")
print("Linear Trends:")
print(list_order_lin)
print("Quadratic Trends:")
print(list_order_quad)

# Get marginal means and pairwise comparisons
cat("\n=== Item Type Comparisons ===\n")
list_order_emmeans <- emmeans(m_combined, ~ item_type)
list_order_pairs <- pairs(list_order_emmeans, adjust = "tukey")
print("Estimated Marginal Means:")
print(as.data.frame(list_order_emmeans))
print("\nPairwise Comparisons:")
print(list_order_pairs)

# Condition × Ordering Type × Position interaction analysis
cat("\n=== Condition × Ordering Type × List Order Interactions ===\n")
list_order_condition_ordering_lin <- emtrends(m_combined, ~ condition * ordering_type | item_type, var = "list_order_lin")
list_order_condition_ordering_quad <- emtrends(m_combined, ~ condition * ordering_type | item_type, var = "list_order_quad")

print("Linear Trends by Condition, Ordering Type, and Item Type:")
print(list_order_condition_ordering_lin)
print("\nQuadratic Trends by Condition, Ordering Type, and Item Type:")
print(list_order_condition_ordering_quad)

# Test pairwise differences
cat("\n=== Pairwise Comparisons of Condition × Ordering Type Effects ===\n")
list_order_pairs_lin <- pairs(list_order_condition_ordering_lin, by = "item_type", adjust = "tukey")
list_order_pairs_quad <- pairs(list_order_condition_ordering_quad, by = "item_type", adjust = "tukey")

print("Linear Trend Differences:")
print(list_order_pairs_lin)
print("\nQuadratic Trend Differences:")
print(list_order_pairs_quad)

# Key comparison: Random by_final vs by_initial within each item type
cat("\n=== Random Condition: Final Order vs Initial Order ===\n")
random_ordering_lin <- emtrends(m_combined, ~ ordering_type | item_type,
                                var = "list_order_lin",
                                at = list(condition = "random"))
random_ordering_quad <- emtrends(m_combined, ~ ordering_type | item_type,
                                 var = "list_order_quad",
                                 at = list(condition = "random"))
print("Linear Trends for Random Condition by Ordering Type:")
print(random_ordering_lin)
print("\nQuadratic Trends for Random Condition by Ordering Type:")
print(random_ordering_quad)

# Save results
saveRDS(
  list(
    model = m_combined,
    summary = results,
    linear_trends = as.data.frame(list_order_lin),
    quadratic_trends = as.data.frame(list_order_quad),
    emmeans = as.data.frame(list_order_emmeans),
    pairwise = as.data.frame(list_order_pairs),
    condition_ordering_linear_trends = as.data.frame(list_order_condition_ordering_lin),
    condition_ordering_quadratic_trends = as.data.frame(list_order_condition_ordering_quad),
    condition_ordering_linear_pairs = as.data.frame(list_order_pairs_lin),
    condition_ordering_quadratic_pairs = as.data.frame(list_order_pairs_quad),
    random_ordering_linear = as.data.frame(random_ordering_lin),
    random_ordering_quadratic = as.data.frame(random_ordering_quad)
  ),
  "final_between_combined_order_model.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "final_between_combined") %>%
  write_csv("final_between_combined_order_summary.csv")

cat("\nSaved: final_between_combined_order_model.rds\n")
cat("Saved: final_between_combined_order_summary.csv\n")


# ================================
# ALTERNATIVE MODELS (COMMENTED)
# ================================

# # MODEL 2: Simpler interaction structure (if convergence issues arise)
# m_combined_simple <- glmer(
#   accuracy ~ list_order_lin * item_type * condition +
#              list_order_lin * item_type * ordering_type +
#              list_order_quad * item_type * condition +
#              list_order_quad * item_type +
#     (1 | participant_id),
#   data = final_combined, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# # MODEL 3: Even simpler - no 4-way interaction for linear
# m_combined_simpler <- glmer(
#   accuracy ~ list_order_lin * item_type * condition +
#              list_order_lin * ordering_type +
#              list_order_quad * item_type * condition +
#              list_order_quad * ordering_type +
#     (1 | participant_id),
#   data = final_combined, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# # MODEL 4: Minimal interaction - focus on condition and ordering_type main effects
# m_combined_minimal <- glmer(
#   accuracy ~ list_order_lin * item_type +
#              list_order_lin * condition +
#              list_order_lin * ordering_type +
#              list_order_quad * item_type +
#              list_order_quad * condition +
#     (1 | participant_id),
#   data = final_combined, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# # MODEL 5: Separate analysis for random condition only (to specifically test ordering effect)
# final_random_only <- final_combined %>%
#   filter(condition == "random")
#
# m_random_ordering <- glmer(
#   accuracy ~ list_order_lin * item_type * ordering_type +
#              list_order_quad * item_type * ordering_type +
#     (1 | participant_id),
#   data = final_random_only, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )
