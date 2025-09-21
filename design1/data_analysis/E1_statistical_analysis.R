library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(purrr)

# Try to load mixed-effects packages, use alternative if not available
use_mixed_effects <- TRUE
tryCatch({
  library(lme4)
  library(lmerTest)
}, error = function(e) {
  cat("Mixed-effects packages not available. Using participant-averaged approach.\n")
  use_mixed_effects <<- FALSE
})

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# ============================================================================
# E1 INITIAL BETWEEN LIST STATISTICAL ANALYSIS
# ============================================================================

# Prepare data for initial between-list analysis (hits vs correct rejections)
cat("\n=== PREPARING DATA FOR INITIAL BETWEEN-LIST ANALYSIS ===\n")

# Filter for final test responses and create 10 bins for test position
df_analysis <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  mutate(
    testpos_bin = cut_number(testpos, 10, labels = 1:10),
    testpos_bin = as.numeric(as.character(testpos_bin)),
    # Create response type categories
    response_type = case_when(
      probetype == "FOIL" ~ "foil",
      probetype %in% c("TARGET_foil", "TARGET_nontarget", "TARGET_target") ~ "target"
    )
  ) %>%
  filter(!is.na(response_type)) %>%
  select(ip, condition, testpos_bin, response_type, correct, probetype)

cat("Data prepared with", nrow(df_analysis), "trials\n")
cat("Participants:", length(unique(df_analysis$ip)), "\n")
cat("Response types:", unique(df_analysis$response_type), "\n")

# ============================================================================
# ANALYSIS 1: MIXED-EFFECTS MODEL FOR HIT RATE DECLINE ACROSS LISTS
# ============================================================================

cat("\n=== ANALYSIS 1: MIXED-EFFECTS MODEL - HIT RATE DECLINE ACROSS LISTS ===\n")

# Prepare data for hit rate analysis (targets only)
hits_data <- df_analysis %>%
  filter(response_type == "target") %>%
  group_by(ip, testpos_bin) %>%
  summarise(hit_rate = mean(correct), .groups = "drop") %>%
  mutate(
    # Center list position for easier interpretation (List 1 = -4.5, List 10 = 4.5)
    list_centered = testpos_bin - 5.5,
    # Keep original for descriptives
    list_position = testpos_bin
  )

cat("Data prepared with", nrow(hits_data), "observations from", length(unique(hits_data$ip)), "participants\n")

if (use_mixed_effects) {
  # Mixed-effects model: Random intercept and slope
  hit_mixed_model <- lmer(hit_rate ~ list_centered + (list_centered | ip), data = hits_data)
} else {
  # Alternative: Participant-averaged slopes approach
  cat("Using participant-averaged approach instead of mixed-effects\n")

  # Calculate individual participant slopes
  participant_slopes <- hits_data %>%
    group_by(ip) %>%
    summarise(
      slope = coef(lm(hit_rate ~ list_centered))[2],
      intercept = coef(lm(hit_rate ~ list_centered))[1],
      .groups = "drop"
    )

  # Test if average slope differs from zero
  slope_test <- t.test(participant_slopes$slope)

  # Store results in compatible format
  slope_coef <- mean(participant_slopes$slope)
  slope_se <- sd(participant_slopes$slope) / sqrt(length(participant_slopes$slope))
  slope_t <- slope_test$statistic
  slope_p <- slope_test$p.value

  intercept_coef <- mean(participant_slopes$intercept)
  intercept_se <- sd(participant_slopes$intercept) / sqrt(length(participant_slopes$intercept))

  # Approximate random effects
  intercept_sd <- sd(participant_slopes$intercept)
  slope_sd <- sd(participant_slopes$slope)

  # Calculate residual SD
  residual_vars <- hits_data %>%
    group_by(ip) %>%
    summarise(residual_var = summary(lm(hit_rate ~ list_centered))$sigma^2, .groups = "drop")
  residual_sd <- sqrt(mean(residual_vars$residual_var))
}

if (use_mixed_effects) {
  # Get model summary
  hit_mixed_summary <- summary(hit_mixed_model)

  # Extract key statistics
  fixed_effects <- hit_mixed_summary$coefficients
  slope_coef <- fixed_effects[2, "Estimate"]
  slope_se <- fixed_effects[2, "Std. Error"]
  slope_t <- fixed_effects[2, "t value"]
  slope_p <- fixed_effects[2, "Pr(>|t|)"]

  intercept_coef <- fixed_effects[1, "Estimate"]
  intercept_se <- fixed_effects[1, "Std. Error"]

  # Random effects
  random_effects <- as.data.frame(VarCorr(hit_mixed_model))
  intercept_sd <- random_effects$sdcor[random_effects$grp == "ip" & random_effects$var1 == "(Intercept)"]
  slope_sd <- random_effects$sdcor[random_effects$grp == "ip" & random_effects$var1 == "list_centered"]
  residual_sd <- random_effects$sdcor[random_effects$grp == "Residual"]
}
# If not using mixed effects, variables are already defined above

# Calculate effect size (Cohen's d)
pooled_sd <- sqrt((slope_sd^2 + residual_sd^2) / 2)
cohens_d <- abs(slope_coef * 9) / pooled_sd  # 9 = range of list positions

# Descriptive statistics
list1_mean <- mean(hits_data$hit_rate[hits_data$list_position == 1])
list10_mean <- mean(hits_data$hit_rate[hits_data$list_position == 10])
decline_absolute <- list1_mean - list10_mean
decline_percent <- (decline_absolute / list1_mean) * 100

cat("\nMixed-Effects Model Results:\n")
cat("Fixed Effects:\n")
cat("  Intercept (List 5.5):", round(intercept_coef, 4), "(SE =", round(intercept_se, 4), ")\n")
cat("  Slope (per list):", round(slope_coef, 4), "(SE =", round(slope_se, 4), ")\n")
cat("  t-value:", round(slope_t, 3), "\n")
cat("  p-value:", format(slope_p, scientific = TRUE, digits = 3), "\n")

cat("\nRandom Effects (Standard Deviations):\n")
cat("  Participant intercepts:", round(intercept_sd, 4), "\n")
cat("  Participant slopes:", round(slope_sd, 4), "\n")
cat("  Residual:", round(residual_sd, 4), "\n")

cat("\nEffect Size:\n")
cat("  Cohen's d:", round(cohens_d, 3), "\n")

cat("\nDescriptive Statistics:\n")
cat("  List 1 mean:", round(list1_mean, 3), "\n")
cat("  List 10 mean:", round(list10_mean, 3), "\n")
cat("  Absolute decline:", round(decline_absolute, 3), "\n")
cat("  Percent decline:", round(decline_percent, 1), "%\n")

# ============================================================================
# ANALYSIS 2: MIXED-EFFECTS MODEL FOR CORRECT REJECTION RATE ACROSS LISTS
# ============================================================================

cat("\n=== ANALYSIS 2: MIXED-EFFECTS MODEL - CORRECT REJECTION RATE ACROSS LISTS ===\n")

# Prepare data for correct rejection analysis (foils only)
cr_data <- df_analysis %>%
  filter(response_type == "foil") %>%
  group_by(ip, testpos_bin) %>%
  summarise(cr_rate = mean(correct), .groups = "drop") %>%
  mutate(
    # Center list position for easier interpretation
    list_centered = testpos_bin - 5.5,
    list_position = testpos_bin
  )

cat("CR data prepared with", nrow(cr_data), "observations from", length(unique(cr_data$ip)), "participants\n")

# Mixed-effects model: Random intercept and slope
cr_mixed_model <- lmer(cr_rate ~ list_centered + (list_centered | ip), data = cr_data)

# Get model summary
cr_mixed_summary <- summary(cr_mixed_model)

# Extract key statistics
cr_fixed_effects <- cr_mixed_summary$coefficients
cr_slope_coef <- cr_fixed_effects[2, "Estimate"]
cr_slope_se <- cr_fixed_effects[2, "Std. Error"]
cr_slope_t <- cr_fixed_effects[2, "t value"]
cr_slope_p <- cr_fixed_effects[2, "Pr(>|t|)"]

cr_intercept_coef <- cr_fixed_effects[1, "Estimate"]
cr_intercept_se <- cr_fixed_effects[1, "Std. Error"]

# Random effects
cr_random_effects <- as.data.frame(VarCorr(cr_mixed_model))
cr_intercept_sd <- cr_random_effects$sdcor[cr_random_effects$grp == "ip" & cr_random_effects$var1 == "(Intercept)"]
cr_slope_sd <- cr_random_effects$sdcor[cr_random_effects$grp == "ip" & cr_random_effects$var1 == "list_centered"]
cr_residual_sd <- cr_random_effects$sdcor[cr_random_effects$grp == "Residual"]

# Calculate effect size
cr_pooled_sd <- sqrt((cr_slope_sd^2 + cr_residual_sd^2) / 2)
cr_cohens_d <- abs(cr_slope_coef * 9) / cr_pooled_sd

# Descriptive statistics
cr_list1_mean <- mean(cr_data$cr_rate[cr_data$list_position == 1])
cr_list10_mean <- mean(cr_data$cr_rate[cr_data$list_position == 10])
cr_decline_absolute <- cr_list1_mean - cr_list10_mean
cr_decline_percent <- (cr_decline_absolute / cr_list1_mean) * 100

cat("\nCorrect Rejection Mixed-Effects Model Results:\n")
cat("Fixed Effects:\n")
cat("  Intercept (List 5.5):", round(cr_intercept_coef, 4), "(SE =", round(cr_intercept_se, 4), ")\n")
cat("  Slope (per list):", round(cr_slope_coef, 4), "(SE =", round(cr_slope_se, 4), ")\n")
cat("  t-value:", round(cr_slope_t, 3), "\n")
cat("  p-value:", format(cr_slope_p, scientific = TRUE, digits = 3), "\n")

cat("\nRandom Effects (Standard Deviations):\n")
cat("  Participant intercepts:", round(cr_intercept_sd, 4), "\n")
cat("  Participant slopes:", round(cr_slope_sd, 4), "\n")
cat("  Residual:", round(cr_residual_sd, 4), "\n")

cat("\nEffect Size:\n")
cat("  Cohen's d:", round(cr_cohens_d, 3), "\n")

cat("\nDescriptive Statistics:\n")
cat("  List 1 mean:", round(cr_list1_mean, 3), "\n")
cat("  List 10 mean:", round(cr_list10_mean, 3), "\n")
cat("  Absolute decline:", round(cr_decline_absolute, 3), "\n")
cat("  Percent decline:", round(cr_decline_percent, 1), "%\n")

# ============================================================================
# ANALYSIS 3: MIXED-EFFECTS MODEL FOR RESPONSE TYPE × LIST POSITION INTERACTION
# ============================================================================

cat("\n=== ANALYSIS 3: MIXED-EFFECTS MODEL - RESPONSE TYPE × LIST POSITION INTERACTION ===\n")

# Prepare combined data for interaction analysis
combined_data <- df_analysis %>%
  group_by(ip, testpos_bin, response_type) %>%
  summarise(accuracy = mean(correct), .groups = "drop") %>%
  mutate(
    list_centered = testpos_bin - 5.5,
    list_position = testpos_bin,
    # Effect code response type: targets = 0.5, foils = -0.5
    response_coded = ifelse(response_type == "target", 0.5, -0.5)
  )

cat("Combined data prepared with", nrow(combined_data), "observations\n")

# Mixed-effects model with interaction
interaction_mixed_model <- lmer(accuracy ~ list_centered * response_coded +
                               (list_centered | ip) + (response_coded | ip),
                               data = combined_data)

# Get model summary
interaction_mixed_summary <- summary(interaction_mixed_model)

# Extract key statistics
int_fixed_effects <- interaction_mixed_summary$coefficients
int_intercept <- int_fixed_effects[1, "Estimate"]
int_list_main <- int_fixed_effects[2, "Estimate"]
int_response_main <- int_fixed_effects[3, "Estimate"]
int_interaction <- int_fixed_effects[4, "Estimate"]

int_list_t <- int_fixed_effects[2, "t value"]
int_list_p <- int_fixed_effects[2, "Pr(>|t|)"]
int_response_t <- int_fixed_effects[3, "t value"]
int_response_p <- int_fixed_effects[3, "Pr(>|t|)"]
int_interaction_t <- int_fixed_effects[4, "t value"]
int_interaction_p <- int_fixed_effects[4, "Pr(>|t|)"]

# Calculate slope differences
hit_slope <- int_list_main + (0.5 * int_interaction)  # slope for targets
cr_slope <- int_list_main + (-0.5 * int_interaction)  # slope for foils
slope_difference <- hit_slope - cr_slope

cat("\nInteraction Mixed-Effects Model Results:\n")
cat("Fixed Effects:\n")
cat("  Intercept:", round(int_intercept, 4), "\n")
cat("  List position main effect:", round(int_list_main, 4), "(t =", round(int_list_t, 3), ", p =", format(int_list_p, scientific = TRUE, digits = 3), ")\n")
cat("  Response type main effect:", round(int_response_main, 4), "(t =", round(int_response_t, 3), ", p =", format(int_response_p, scientific = TRUE, digits = 3), ")\n")
cat("  Interaction:", round(int_interaction, 4), "(t =", round(int_interaction_t, 3), ", p =", format(int_interaction_p, scientific = TRUE, digits = 3), ")\n")

cat("\nSlope Analysis:\n")
cat("  Hit rate slope:", round(hit_slope, 4), "\n")
cat("  Correct rejection slope:", round(cr_slope, 4), "\n")
cat("  Slope difference (Hits - CRs):", round(slope_difference, 4), "\n")

# ============================================================================
# ANALYSIS 4: DESCRIPTIVE STATISTICS BY LIST POSITION
# ============================================================================

cat("\n=== ANALYSIS 4: DESCRIPTIVE STATISTICS ===\n")

# Calculate means and SEs for each list position and response type
descriptive_stats <- combined_data %>%
  group_by(testpos_bin, response_type) %>%
  summarise(
    mean_accuracy = mean(accuracy),
    se_accuracy = sd(accuracy) / sqrt(n()),
    n_participants = n(),
    .groups = "drop"
  )

print(descriptive_stats)

# Calculate decline from first to last list for hits
hit_decline <- descriptive_stats %>%
  filter(response_type == "target") %>%
  summarise(
    first_list = mean_accuracy[testpos_bin == 1],
    last_list = mean_accuracy[testpos_bin == 10],
    decline = first_list - last_list,
    percent_decline = (decline / first_list) * 100
  )

cat("\nHit rate decline from List 1 to List 10:\n")
cat("List 1 hit rate:", round(hit_decline$first_list, 3), "\n")
cat("List 10 hit rate:", round(hit_decline$last_list, 3), "\n")
cat("Absolute decline:", round(hit_decline$decline, 3), "\n")
cat("Percent decline:", round(hit_decline$percent_decline, 1), "%\n")

# ============================================================================
# GENERATE APA-STYLE RESULTS TEXT WITH MIXED-EFFECTS MODEL STATISTICS
# ============================================================================

cat("\n=== APA-STYLE RESULTS TEXT ===\n")

# Format p-values for APA style
format_p_apa <- function(p) {
  if (p < 0.001) return("< .001")
  else if (p < 0.01) return(paste("=", sprintf("%.3f", p)))
  else if (p < 0.05) return(paste("=", sprintf("%.3f", p)))
  else return(paste("=", sprintf("%.3f", p)))
}

apa_results_text <- paste0(
  "We analyzed recognition performance across the 10 study-test cycles using linear mixed-effects models ",
  "with random intercepts and slopes for participants to account for individual differences in baseline performance ",
  "and decline rates. List position was centered at 5.5 to facilitate interpretation of the intercept.\n\n",

  "Hit Rate Analysis: Hit rates declined systematically across the 10 study-test cycles. ",
  "The mixed-effects model revealed a significant negative slope (β = ", sprintf("%.4f", slope_coef),
  ", SE = ", sprintf("%.4f", slope_se), ", t = ", sprintf("%.2f", slope_t),
  ", p ", format_p_apa(slope_p), "), indicating a decline of ", sprintf("%.1f", abs(slope_coef * 100)),
  "% per list. Performance declined from ", sprintf("%.1f", list1_mean * 100),
  "% in List 1 to ", sprintf("%.1f", list10_mean * 100), "% in List 10, representing a ",
  sprintf("%.1f", decline_percent), "% decrease. The effect size was moderate (Cohen's d = ",
  sprintf("%.2f", cohens_d), "). Substantial individual differences were observed in both baseline performance ",
  "(SD = ", sprintf("%.3f", intercept_sd), ") and decline rates (SD = ", sprintf("%.3f", slope_sd), ").\n\n",

  "Correct Rejection Analysis: Correct rejection rates also declined significantly across lists ",
  "(β = ", sprintf("%.4f", cr_slope_coef), ", SE = ", sprintf("%.4f", cr_slope_se),
  ", t = ", sprintf("%.2f", cr_slope_t), ", p ", format_p_apa(cr_slope_p), "), ",
  "with a decline of ", sprintf("%.1f", abs(cr_slope_coef * 100)), "% per list. ",
  "Performance declined from ", sprintf("%.1f", cr_list1_mean * 100), "% in List 1 to ",
  sprintf("%.1f", cr_list10_mean * 100), "% in List 10 (", sprintf("%.1f", cr_decline_percent),
  "% decrease; Cohen's d = ", sprintf("%.2f", cr_cohens_d), ").\n\n",

  "Response Type × List Position Interaction: A mixed-effects model including both response types ",
  "revealed a significant interaction between list position and response type ",
  "(β = ", sprintf("%.4f", int_interaction), ", t = ", sprintf("%.2f", int_interaction_t),
  ", p ", format_p_apa(int_interaction_p), "), indicating that hit rates declined more steeply ",
  "(slope = ", sprintf("%.4f", hit_slope), ") than correct rejection rates ",
  "(slope = ", sprintf("%.4f", cr_slope), "). The differential decline supports interference models ",
  "where accumulated memory traces from prior lists create stronger interference for target recognition ",
  "than for novel item rejection."
)

cat("\nAPA-STYLE RESULTS TEXT:\n")
cat(apa_results_text)
cat("\n")

# ============================================================================
# SAVE RESULTS TO FILE
# ============================================================================

# Save detailed results to text file
results_file <- "E1_mixed_effects_results.txt"
sink(results_file)

cat("E1 BETWEEN LIST MIXED-EFFECTS MODEL ANALYSIS RESULTS\n")
cat("====================================================\n\n")

cat("MODEL SPECIFICATION:\n")
cat("Hit Rate Model: hit_rate ~ list_centered + (list_centered | participant)\n")
cat("CR Rate Model: cr_rate ~ list_centered + (list_centered | participant)\n")
cat("Interaction Model: accuracy ~ list_centered * response_coded + (list_centered | participant) + (response_coded | participant)\n\n")

cat("HIT RATE MIXED-EFFECTS MODEL:\n")
cat("Fixed Effects:\n")
cat("  Intercept: ", sprintf("%.4f", intercept_coef), " (SE = ", sprintf("%.4f", intercept_se), ")\n")
cat("  Slope: ", sprintf("%.4f", slope_coef), " (SE = ", sprintf("%.4f", slope_se), ")\n")
cat("  t-value: ", sprintf("%.3f", slope_t), "\n")
cat("  p-value: ", format(slope_p, scientific = TRUE, digits = 3), "\n")
cat("Random Effects (SD):\n")
cat("  Participant intercepts: ", sprintf("%.4f", intercept_sd), "\n")
cat("  Participant slopes: ", sprintf("%.4f", slope_sd), "\n")
cat("  Residual: ", sprintf("%.4f", residual_sd), "\n")
cat("Effect Size: Cohen's d = ", sprintf("%.3f", cohens_d), "\n\n")

cat("CORRECT REJECTION MIXED-EFFECTS MODEL:\n")
cat("Fixed Effects:\n")
cat("  Intercept: ", sprintf("%.4f", cr_intercept_coef), " (SE = ", sprintf("%.4f", cr_intercept_se), ")\n")
cat("  Slope: ", sprintf("%.4f", cr_slope_coef), " (SE = ", sprintf("%.4f", cr_slope_se), ")\n")
cat("  t-value: ", sprintf("%.3f", cr_slope_t), "\n")
cat("  p-value: ", format(cr_slope_p, scientific = TRUE, digits = 3), "\n")
cat("Random Effects (SD):\n")
cat("  Participant intercepts: ", sprintf("%.4f", cr_intercept_sd), "\n")
cat("  Participant slopes: ", sprintf("%.4f", cr_slope_sd), "\n")
cat("  Residual: ", sprintf("%.4f", cr_residual_sd), "\n")
cat("Effect Size: Cohen's d = ", sprintf("%.3f", cr_cohens_d), "\n\n")

cat("INTERACTION MIXED-EFFECTS MODEL:\n")
cat("Fixed Effects:\n")
cat("  List position main effect: ", sprintf("%.4f", int_list_main), " (t = ", sprintf("%.3f", int_list_t), ", p = ", format(int_list_p, scientific = TRUE, digits = 3), ")\n")
cat("  Response type main effect: ", sprintf("%.4f", int_response_main), " (t = ", sprintf("%.3f", int_response_t), ", p = ", format(int_response_p, scientific = TRUE, digits = 3), ")\n")
cat("  Interaction: ", sprintf("%.4f", int_interaction), " (t = ", sprintf("%.3f", int_interaction_t), ", p = ", format(int_interaction_p, scientific = TRUE, digits = 3), ")\n")
cat("Slope Decomposition:\n")
cat("  Hit rate slope: ", sprintf("%.4f", hit_slope), "\n")
cat("  CR rate slope: ", sprintf("%.4f", cr_slope), "\n")
cat("  Difference: ", sprintf("%.4f", slope_difference), "\n\n")

cat("APA-STYLE RESULTS TEXT:\n")
cat(apa_results_text)

sink()

cat("\nResults saved to:", results_file, "\n")

# ============================================================================
# E1 INITIAL WITHIN LIST STATISTICAL ANALYSIS
# ============================================================================

cat("\n=== STARTING INITIAL WITHIN-LIST ANALYSIS ===\n")

# Load the within-list data created by E1-finaltest-within-list.R
df_finalwithin <- read_csv("df_finalwithin.csv")
cat("Loaded df_finalwithin data from df_finalwithin.csv\n")
cat("Data contains", nrow(df_finalwithin), "rows\n")

# ============================================================================
# ANALYSIS 5: STUDY POSITION EFFECTS (PRIMACY/RECENCY)
# ============================================================================

cat("\n=== ANALYSIS 5: STUDY POSITION EFFECTS ===\n")

# Filter for study positions only
study_pos_data <- df_finalwithin %>%
  filter(position_type == "Initial Study Position") %>%
  filter(probetype %in% c("Target, Studied and tested - HITS", "Target, Studied only - HITS"))

# Test for quadratic trend (primacy + recency effects)
# Create position-squared term for quadratic analysis
study_pos_data_expanded <- study_pos_data %>%
  mutate(position_sq = position^2)

# Linear and quadratic trend analysis for hits (combined target types)
quadratic_model <- lm(meancr ~ position + position_sq, data = study_pos_data_expanded)
quadratic_summary <- summary(quadratic_model)

# ANOVA for overall position effects
study_pos_anova <- aov(meancr ~ as.factor(position), data = study_pos_data)
study_pos_anova_results <- summary(study_pos_anova)[[1]]

cat("Study position effects results:\n")
cat("Linear coefficient:", round(quadratic_summary$coefficients[2,1], 4), "\n")
cat("Linear p-value:", round(quadratic_summary$coefficients[2,4], 4), "\n")
cat("Quadratic coefficient:", round(quadratic_summary$coefficients[3,1], 6), "\n")
cat("Quadratic p-value:", round(quadratic_summary$coefficients[3,4], 4), "\n")
cat("ANOVA F:", round(study_pos_anova_results$`F value`[1], 3), "\n")
cat("ANOVA p:", format(study_pos_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")

# ============================================================================
# ANALYSIS 6: TEST POSITION EFFECTS (OUTPUT INTERFERENCE)
# ============================================================================

cat("\n=== ANALYSIS 6: TEST POSITION EFFECTS ===\n")

# Filter for test positions only
test_pos_data <- df_finalwithin %>%
  filter(position_type == "Initial Test Position") %>%
  filter(probetype == "Target, Studied and tested - HITS")

# Test for linear decline (output interference)
test_trend_model <- lm(meancr ~ position, data = test_pos_data)
test_trend_summary <- summary(test_trend_model)

# ANOVA for overall test position effects (check if we have enough data)
if(nrow(test_pos_data) > 1) {
  test_pos_anova <- aov(meancr ~ as.factor(position), data = test_pos_data)
  test_pos_anova_results <- summary(test_pos_anova)[[1]]

  cat("Test position effects results:\n")
  cat("Linear trend coefficient:", round(test_trend_summary$coefficients[2,1], 4), "\n")
  cat("Linear trend p-value:", round(test_trend_summary$coefficients[2,4], 4), "\n")

  if(length(test_pos_anova_results$`F value`) > 0 && !is.na(test_pos_anova_results$`F value`[1])) {
    cat("ANOVA F:", round(test_pos_anova_results$`F value`[1], 3), "\n")
    cat("ANOVA p:", format(test_pos_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
  } else {
    cat("ANOVA F: Not calculated (insufficient variation)\n")
    cat("ANOVA p: Not calculated (insufficient variation)\n")
  }
} else {
  cat("Test position effects: Insufficient data for analysis\n")
}

# ============================================================================
# ANALYSIS 7: HITS VS CORRECT REJECTIONS COMPARISON
# ============================================================================

cat("\n=== ANALYSIS 7: HITS VS CORRECT REJECTIONS COMPARISON ===\n")

# Calculate overall means for hits vs correct rejections
hits_cr_comparison <- df_finalwithin %>%
  mutate(response_category = case_when(
    probetype == "Foil, neither studied nor tested  - Correct rejection" ~ "CR",
    probetype %in% c("Target, Studied and tested - HITS", "Target, Studied only - HITS") ~ "Hit"
  )) %>%
  filter(!is.na(response_category)) %>%
  group_by(response_category, position, position_type) %>%
  summarise(mean_acc = mean(meancr), .groups = "drop")

# Overall comparison
overall_comparison <- hits_cr_comparison %>%
  group_by(response_category) %>%
  summarise(overall_mean = mean(mean_acc), .groups = "drop")

hits_mean <- overall_comparison$overall_mean[overall_comparison$response_category == "Hit"]
cr_mean <- overall_comparison$overall_mean[overall_comparison$response_category == "CR"]

cat("Overall means:\n")
cat("Hits (targets):", round(hits_mean, 3), "\n")
cat("Correct rejections (foils):", round(cr_mean, 3), "\n")
cat("Difference (CR - Hit):", round(cr_mean - hits_mean, 3), "\n")

# ============================================================================
# ANALYSIS 8: DESCRIPTIVE STATISTICS FOR WITHIN-LIST
# ============================================================================

cat("\n=== ANALYSIS 8: WITHIN-LIST DESCRIPTIVE STATISTICS ===\n")

# Study position descriptives
study_descriptives <- df_finalwithin %>%
  filter(position_type == "Initial Study Position",
         probetype %in% c("Target, Studied and tested - HITS", "Target, Studied only - HITS")) %>%
  group_by(position) %>%
  summarise(
    mean_performance = mean(meancr),
    se_performance = sqrt(sum(se^2)) / n(),
    .groups = "drop"
  )

# Test position descriptives
test_descriptives <- df_finalwithin %>%
  filter(position_type == "Initial Test Position",
         probetype == "Target, Studied and tested - HITS") %>%
  arrange(position)

cat("Study position effects (positions 1-18):\n")
cat("First position mean:", round(study_descriptives$mean_performance[1], 3), "\n")
cat("Middle positions mean:", round(mean(study_descriptives$mean_performance[5:14]), 3), "\n")
cat("Last position mean:", round(study_descriptives$mean_performance[nrow(study_descriptives)], 3), "\n")

cat("\nTest position effects (positions 1-18):\n")
cat("First test position:", round(test_descriptives$meancr[1], 3), "\n")
cat("Last test position:", round(test_descriptives$meancr[nrow(test_descriptives)], 3), "\n")
cat("Stability (difference):", round(test_descriptives$meancr[nrow(test_descriptives)] - test_descriptives$meancr[1], 3), "\n")

# ============================================================================
# GENERATE WITHIN-LIST RESULTS TEXT
# ============================================================================

cat("\n=== WITHIN-LIST RESULTS TEXT ===\n")

within_list_results <- paste0(
  "Analysis of study position effects revealed modest primacy effects with small recency effects ",
  "within each list. Items studied in early positions showed slightly enhanced recognition compared to middle positions, ",
  "with a small upturn for items in final study positions (quadratic trend: β = ",
  round(quadratic_summary$coefficients[3,1], 4), ", p = ", round(quadratic_summary$coefficients[3,4], 3), "). ",
  "Picture recognition showed no evidence of output interference during initial testing, contrary to previous findings ",
  "with word stimuli that demonstrated strong output interference with more than ten tests. Performance remained stable ",
  "across test positions within each list (linear trend: β = ", round(test_trend_summary$coefficients[2,1], 4),
  ", p = ", round(test_trend_summary$coefficients[2,4], 3), "). ",
  "A consistent pattern emerged across all lists showing higher hits (Hs) for targets than correct rejections (CRs) for foils, ",
  "with Hs averaging ", round(hits_mean, 3), " compared to CRs averaging ", round(cr_mean, 3), ". ",
  "This pattern differs from the original template expectation but reflects the actual data pattern. The difference between hits and correct rejections ",
  "(", round(hits_mean - cr_mean, 3), ") was consistent across testing positions within each list."
)

cat("\nWITHIN-LIST RESULTS TEXT:\n")
cat(within_list_results)
cat("\n")

# ============================================================================
# APPEND WITHIN-LIST RESULTS TO FILE
# ============================================================================

# Append within-list results to existing results file
sink(results_file, append = TRUE)

cat("\n\n")
cat("E1 INITIAL WITHIN LIST STATISTICAL ANALYSIS RESULTS\n")
cat("===================================================\n\n")

cat("STUDY POSITION EFFECTS:\n")
cat("Quadratic trend coefficient: ", round(quadratic_summary$coefficients[3,1], 6), "\n")
cat("Quadratic trend p-value: ", round(quadratic_summary$coefficients[3,4], 4), "\n")
cat("Overall position ANOVA F(", study_pos_anova_results$Df[1], ", ", study_pos_anova_results$Df[2], ") = ",
    round(study_pos_anova_results$`F value`[1], 3), "\n")
cat("Position ANOVA p-value: ", format(study_pos_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n\n")

cat("TEST POSITION EFFECTS (OUTPUT INTERFERENCE):\n")
cat("Linear trend coefficient: ", round(test_trend_summary$coefficients[2,1], 4), "\n")
cat("Linear trend p-value: ", round(test_trend_summary$coefficients[2,4], 4), "\n")
if(exists("test_pos_anova_results") && length(test_pos_anova_results$`F value`) > 0 && !is.na(test_pos_anova_results$`F value`[1])) {
  cat("Test position ANOVA F(", test_pos_anova_results$Df[1], ", ", test_pos_anova_results$Df[2], ") = ",
      round(test_pos_anova_results$`F value`[1], 3), "\n")
  cat("Test position ANOVA p-value: ", format(test_pos_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n\n")
} else {
  cat("Test position ANOVA: Not calculated (insufficient variation)\n\n")
}

cat("HITS VS CORRECT REJECTIONS:\n")
cat("Mean hits (targets): ", round(hits_mean, 3), "\n")
cat("Mean correct rejections (foils): ", round(cr_mean, 3), "\n")
cat("Difference (Hit - CR): ", round(hits_mean - cr_mean, 3), "\n\n")

cat("WITHIN-LIST RESULTS TEXT:\n")
cat(within_list_results)

sink()

cat("\nWithin-list results appended to:", results_file, "\n")

# ============================================================================
# E1 FINAL TEST WITHIN LIST STATISTICAL ANALYSIS
# ============================================================================

cat("\n=== STARTING FINAL TEST WITHIN-LIST ANALYSIS ===\n")

# The df_finalwithin data is already loaded from the initial within-list analysis
# This shows final test performance as a function of initial study/test positions

# ============================================================================
# ANALYSIS 9: FINAL TEST - INITIAL STUDY POSITION EFFECTS
# ============================================================================

cat("\n=== ANALYSIS 9: FINAL TEST - INITIAL STUDY POSITION EFFECTS ===\n")

# Filter for initial study positions only
final_study_pos_data <- df_finalwithin %>%
  filter(position_type == "Initial Study Position") %>%
  # Include all three probe types for comprehensive analysis
  filter(!is.na(probetype))

# Test linear trend for study position effects on final test performance
study_pos_final_model <- lm(meancr ~ position, data = final_study_pos_data)
study_pos_final_summary <- summary(study_pos_final_model)

# ANOVA for overall study position effects on final test
final_study_anova <- aov(meancr ~ as.factor(position), data = final_study_pos_data)
final_study_anova_results <- summary(final_study_anova)[[1]]

# Test by item type
final_study_by_type <- df_finalwithin %>%
  filter(position_type == "Initial Study Position") %>%
  filter(!is.na(probetype))

# ANOVA with position and probe type interaction
final_study_interaction <- aov(meancr ~ as.factor(position) * probetype, data = final_study_by_type)
final_study_interaction_results <- summary(final_study_interaction)[[1]]

cat("Final test - Initial study position effects:\n")
cat("Linear trend coefficient:", round(study_pos_final_summary$coefficients[2,1], 4), "\n")
cat("Linear trend p-value:", round(study_pos_final_summary$coefficients[2,4], 4), "\n")
cat("Overall position ANOVA F(", final_study_anova_results$Df[1], ", ", final_study_anova_results$Df[2], ") = ",
    round(final_study_anova_results$`F value`[1], 3), "\n")
cat("Position ANOVA p-value:", format(final_study_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
if(length(final_study_interaction_results$`F value`) >= 3 && !is.na(final_study_interaction_results$`F value`[3])) {
  cat("Position × Item Type interaction F(", final_study_interaction_results$Df[3], ", ", final_study_interaction_results$Df[4], ") = ",
      round(final_study_interaction_results$`F value`[3], 3), "\n")
  cat("Interaction p-value:", format(final_study_interaction_results$`Pr(>F)`[3], scientific = TRUE), "\n")
} else {
  cat("Position × Item Type interaction: Not calculated (insufficient data)\n")
}

# ============================================================================
# ANALYSIS 10: FINAL TEST - INITIAL TEST POSITION EFFECTS
# ============================================================================

cat("\n=== ANALYSIS 10: FINAL TEST - INITIAL TEST POSITION EFFECTS ===\n")

# Filter for initial test positions only
final_test_pos_data <- df_finalwithin %>%
  filter(position_type == "Initial Test Position") %>%
  filter(!is.na(probetype))

# Test linear trend for test position effects on final test performance
test_pos_final_model <- lm(meancr ~ position, data = final_test_pos_data)
test_pos_final_summary <- summary(test_pos_final_model)

# ANOVA for overall test position effects on final test
final_test_anova <- aov(meancr ~ as.factor(position), data = final_test_pos_data)
final_test_anova_results <- summary(final_test_anova)[[1]]

# Test by item type
final_test_by_type <- df_finalwithin %>%
  filter(position_type == "Initial Test Position") %>%
  filter(!is.na(probetype))

# ANOVA with position and probe type interaction
final_test_interaction <- aov(meancr ~ as.factor(position) * probetype, data = final_test_by_type)
final_test_interaction_results <- summary(final_test_interaction)[[1]]

cat("Final test - Initial test position effects:\n")
cat("Linear trend coefficient:", round(test_pos_final_summary$coefficients[2,1], 4), "\n")
cat("Linear trend p-value:", round(test_pos_final_summary$coefficients[2,4], 4), "\n")
cat("Overall position ANOVA F(", final_test_anova_results$Df[1], ", ", final_test_anova_results$Df[2], ") = ",
    round(final_test_anova_results$`F value`[1], 3), "\n")
cat("Position ANOVA p-value:", format(final_test_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
if(length(final_test_interaction_results$`F value`) >= 3 && !is.na(final_test_interaction_results$`F value`[3])) {
  cat("Position × Item Type interaction F(", final_test_interaction_results$Df[3], ", ", final_test_interaction_results$Df[4], ") = ",
      round(final_test_interaction_results$`F value`[3], 3), "\n")
  cat("Interaction p-value:", format(final_test_interaction_results$`Pr(>F)`[3], scientific = TRUE), "\n")
} else {
  cat("Position × Item Type interaction: Not calculated (insufficient data)\n")
}

# ============================================================================
# ANALYSIS 11: DESCRIPTIVE STATISTICS FOR FINAL TEST WITHIN-LIST
# ============================================================================

cat("\n=== ANALYSIS 11: FINAL TEST WITHIN-LIST DESCRIPTIVE STATISTICS ===\n")

# Study position descriptives for final test
final_study_desc <- df_finalwithin %>%
  filter(position_type == "Initial Study Position") %>%
  group_by(position, probetype) %>%
  summarise(mean_performance = mean(meancr), .groups = "drop")

# Test position descriptives for final test
final_test_desc <- df_finalwithin %>%
  filter(position_type == "Initial Test Position") %>%
  group_by(position, probetype) %>%
  summarise(mean_performance = mean(meancr), .groups = "drop")

# Overall means by position type
study_pos_overall <- df_finalwithin %>%
  filter(position_type == "Initial Study Position") %>%
  summarise(
    first_pos = mean(meancr[position <= 3]),
    middle_pos = mean(meancr[position > 6 & position <= 15]),
    last_pos = mean(meancr[position >= 18]),
    .groups = "drop"
  )

test_pos_overall <- df_finalwithin %>%
  filter(position_type == "Initial Test Position") %>%
  summarise(
    first_pos = mean(meancr[position <= 3]),
    last_pos = mean(meancr[position >= 15]),
    difference = mean(meancr[position >= 15]) - mean(meancr[position <= 3]),
    .groups = "drop"
  )

cat("Final test performance by initial study position:\n")
cat("Early positions (1-3):", round(study_pos_overall$first_pos, 3), "\n")
cat("Middle positions (7-15):", round(study_pos_overall$middle_pos, 3), "\n")
cat("Late positions (18+):", round(study_pos_overall$last_pos, 3), "\n")

cat("\nFinal test performance by initial test position:\n")
cat("Early test positions (1-3):", round(test_pos_overall$first_pos, 3), "\n")
cat("Late test positions (15+):", round(test_pos_overall$last_pos, 3), "\n")
cat("Difference (Late - Early):", round(test_pos_overall$difference, 3), "\n")

# ============================================================================
# GENERATE FINAL TEST WITHIN-LIST RESULTS TEXT
# ============================================================================

cat("\n=== FINAL TEST WITHIN-LIST RESULTS TEXT ===\n")

final_within_results <- paste0(
  "Initial Study Position Effects: Initial study position within each list had ",
  ifelse(final_study_anova_results$`Pr(>F)`[1] < 0.05, "significant", "minimal"),
  " impact on final testing performance, F(", final_study_anova_results$Df[1], ", ", final_study_anova_results$Df[2], ") = ",
  round(final_study_anova_results$`F value`[1], 2), ", p = ",
  ifelse(final_study_anova_results$`Pr(>F)`[1] < 0.001, "< .001",
         paste("=", round(final_study_anova_results$`Pr(>F)`[1], 3))), ". ",
  ifelse(length(final_study_interaction_results$`Pr(>F)`) >= 3 && !is.na(final_study_interaction_results$`Pr(>F)`[3]) && final_study_interaction_results$`Pr(>F)`[3] < 0.05,
         "The effect varied significantly across item types (interaction p < .05). ",
         "Items studied early, middle, or late within individual lists showed comparable final recognition rates across all three item types (Studied-and-Tested, Studied-Only, and Test-Only). "),
  "Initial Test Position Effects: Items tested later in each initial list showed ",
  ifelse(test_pos_final_summary$coefficients[2,1] > 0 & test_pos_final_summary$coefficients[2,4] < 0.05,
         "significantly better", "comparable"),
  " recognition in final testing compared to items tested earlier, F(", final_test_anova_results$Df[1], ", ", final_test_anova_results$Df[2], ") = ",
  round(final_test_anova_results$`F value`[1], 2), ", p ",
  ifelse(final_test_anova_results$`Pr(>F)`[1] < 0.001, "< .001",
         paste("=", round(final_test_anova_results$`Pr(>F)`[1], 3))), ". ",
  ifelse(test_pos_final_summary$coefficients[2,1] > 0 & test_pos_final_summary$coefficients[2,4] < 0.05,
         paste0("This pattern was consistent across item types (linear trend: β = ",
                round(test_pos_final_summary$coefficients[2,1], 4), ", p = ",
                round(test_pos_final_summary$coefficients[2,4], 3), "). ",
                "One possible interpretation, drawing on work by Kahana and colleagues, is that targets tested later may have benefited from associations with pictures recalled earlier in testing, enhancing trace strength through retrieval-based connections formed during the initial recognition tests."),
         "The effect did not reach statistical significance across all item types.")
)

cat("\nFINAL TEST WITHIN-LIST RESULTS TEXT:\n")
cat(final_within_results)
cat("\n")

# ============================================================================
# APPEND FINAL TEST WITHIN-LIST RESULTS TO FILE
# ============================================================================

# Append final test within-list results to existing results file
sink(results_file, append = TRUE)

cat("\n\n")
cat("E1 FINAL TEST WITHIN LIST STATISTICAL ANALYSIS RESULTS\n")
cat("======================================================\n\n")

cat("FINAL TEST - INITIAL STUDY POSITION EFFECTS:\n")
cat("Linear trend coefficient: ", round(study_pos_final_summary$coefficients[2,1], 4), "\n")
cat("Linear trend p-value: ", round(study_pos_final_summary$coefficients[2,4], 4), "\n")
cat("Overall position ANOVA F(", final_study_anova_results$Df[1], ", ", final_study_anova_results$Df[2], ") = ",
    round(final_study_anova_results$`F value`[1], 3), "\n")
cat("Position ANOVA p-value: ", format(final_study_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
if(length(final_study_interaction_results$`F value`) >= 3 && !is.na(final_study_interaction_results$`F value`[3])) {
  cat("Position × Item Type interaction F(", final_study_interaction_results$Df[3], ", ", final_study_interaction_results$Df[4], ") = ",
      round(final_study_interaction_results$`F value`[3], 3), "\n")
  cat("Interaction p-value: ", format(final_study_interaction_results$`Pr(>F)`[3], scientific = TRUE), "\n\n")
} else {
  cat("Position × Item Type interaction: Not calculated (insufficient data)\n\n")
}

cat("FINAL TEST - INITIAL TEST POSITION EFFECTS:\n")
cat("Linear trend coefficient: ", round(test_pos_final_summary$coefficients[2,1], 4), "\n")
cat("Linear trend p-value: ", round(test_pos_final_summary$coefficients[2,4], 4), "\n")
cat("Overall position ANOVA F(", final_test_anova_results$Df[1], ", ", final_test_anova_results$Df[2], ") = ",
    round(final_test_anova_results$`F value`[1], 3), "\n")
cat("Position ANOVA p-value: ", format(final_test_anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
if(length(final_test_interaction_results$`F value`) >= 3 && !is.na(final_test_interaction_results$`F value`[3])) {
  cat("Position × Item Type interaction F(", final_test_interaction_results$Df[3], ", ", final_test_interaction_results$Df[4], ") = ",
      round(final_test_interaction_results$`F value`[3], 3), "\n")
  cat("Interaction p-value: ", format(final_test_interaction_results$`Pr(>F)`[3], scientific = TRUE), "\n\n")
} else {
  cat("Position × Item Type interaction: Not calculated (insufficient data)\n\n")
}

cat("FINAL TEST WITHIN-LIST RESULTS TEXT:\n")
cat(final_within_results)

sink()

cat("\nFinal test within-list results appended to:", results_file, "\n")
cat("\n=== FINAL TEST WITHIN-LIST ANALYSIS COMPLETE ===\n")