# ================================
# Initial Test: Test Position Analysis (ENHANCED)
# Tests both item-specific AND averaged trends
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
print(results)

# ================================================================
# AVERAGED TRENDS (Marginal across both foil and target)
# ================================================================
cat("\n========================================\n")
cat("AVERAGED PERFORMANCE TRENDS (Marginal across item types)\n")
cat("========================================\n")

# Method 1: Using emtrends to get marginal average trend
cat("\n--- Method 1: Marginal Average Trends (using emtrends) ---\n")
avg_lin_trend <- emtrends(m_init_testpos, ~ 1, var = "test_position_lin")
avg_quad_trend <- emtrends(m_init_testpos, ~ 1, var = "test_position_quad")

cat("\nLinear Trend (averaged across foil and target):\n")
print(summary(avg_lin_trend))
cat("\nInterpretation: This is the average linear trend across both item types.\n")
cat("If this is significantly different from 0, there's an overall position effect.\n")

cat("\nQuadratic Trend (averaged across foil and target):\n")
print(summary(avg_quad_trend))
cat("\nInterpretation: This tests for curvature in the average position effect.\n")

# Method 2: Test main effects directly from model
cat("\n--- Method 2: Main Effects from Model (same as Method 1) ---\n")
main_effects <- results %>%
  filter(term %in% c("test_position_lin", "test_position_quad"))
print(main_effects)
cat("\nNote: These main effects represent the averaged trend across item types.\n")
cat("p-values test whether the averaged trend is significantly different from 0.\n")

# ================================================================
# ITEM-TYPE-SPECIFIC TRENDS
# ================================================================
cat("\n========================================\n")
cat("ITEM-TYPE-SPECIFIC TRENDS\n")
cat("========================================\n")

testpos_lin_trend <- emtrends(m_init_testpos, ~ item_type, var = "test_position_lin")
testpos_quad_trend <- emtrends(m_init_testpos, ~ item_type, var = "test_position_quad")
cat("\nLinear Trends by Item Type:\n")
print(testpos_lin_trend)
cat("\nQuadratic Trends by Item Type:\n")
print(testpos_quad_trend)

# Test if trends differ between item types
cat("\n--- Do trends differ between foil and target? ---\n")
lin_contrast <- pairs(testpos_lin_trend)
quad_contrast <- pairs(testpos_quad_trend)
cat("\nLinear Trend Difference (target - foil):\n")
print(lin_contrast)
cat("\nQuadratic Trend Difference (target - foil):\n")
print(quad_contrast)

# ================================================================
# INTERACTION EFFECTS
# ================================================================
cat("\n========================================\n")
cat("INTERACTION EFFECTS\n")
cat("========================================\n")

interaction_effects <- results %>%
  filter(grepl(":", term))
print(interaction_effects)
cat("\nInterpretation: These test whether the position trends differ by item type.\n")
cat("Significant interaction = foil and target have different position effects.\n")

# ================================================================
# OVERALL MARGINAL MEANS
# ================================================================
cat("\n========================================\n")
cat("OVERALL PERFORMANCE (Marginal Means)\n")
cat("========================================\n")

# Get marginal means and pairwise comparisons
testpos_emmeans <- emmeans(m_init_testpos, ~ item_type)
testpos_pairs <- pairs(testpos_emmeans, adjust = "tukey")
cat("\nEstimated Marginal Means by Item Type:\n")
print(as.data.frame(testpos_emmeans))
cat("\nPairwise Comparisons:\n")
print(testpos_pairs)

# ================================================================
# SUMMARY INTERPRETATION
# ================================================================
cat("\n========================================\n")
cat("INTERPRETATION GUIDE\n")
cat("========================================\n")
cat("\n1. AVERAGED TRENDS (Main Effects):\n")
cat("   - test_position_lin: Is there an overall linear position effect?\n")
cat("   - test_position_quad: Is there an overall quadratic (U-shaped) effect?\n")
cat("\n2. ITEM-SPECIFIC TRENDS:\n")
cat("   - Separate trends for foil and target items\n")
cat("\n3. INTERACTIONS:\n")
cat("   - test_position_lin:item_type: Do foil/target have different linear trends?\n")
cat("   - test_position_quad:item_type: Do foil/target have different quadratic trends?\n")
cat("\n4. If you want the AVERAGED trend across positions:\n")
cat("   - Look at main effects (Method 2 above)\n")
cat("   - These represent the average effect of position on performance\n")
cat("========================================\n")

# Save results (now including averaged trends)
saveRDS(
  list(
    model = m_init_testpos,
    summary = results,
    # Averaged trends
    avg_linear_trend = as.data.frame(avg_lin_trend),
    avg_quadratic_trend = as.data.frame(avg_quad_trend),
    # Item-specific trends
    linear_trends = as.data.frame(testpos_lin_trend),
    quadratic_trends = as.data.frame(testpos_quad_trend),
    # Comparisons
    linear_contrast = as.data.frame(lin_contrast),
    quadratic_contrast = as.data.frame(quad_contrast),
    emmeans = as.data.frame(testpos_emmeans),
    pairwise = as.data.frame(testpos_pairs)
  ),
  "init_testpos_model_enhanced.rds"
)

# Export summary as CSV
results %>%
  mutate(model = "init_testpos") %>%
  write_csv("init_testpos_summary_enhanced.csv")

cat("\nSaved: init_testpos_model_enhanced.rds\n")
cat("Saved: init_testpos_summary_enhanced.csv\n")
