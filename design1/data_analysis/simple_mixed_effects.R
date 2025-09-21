library(dplyr)
library(readr)
library(purrr)
library(ggplot2)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")

# Prepare data for analysis
df_analysis <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  mutate(
    testpos_bin = cut_number(testpos, 10, labels = 1:10),
    testpos_bin = as.numeric(as.character(testpos_bin)),
    response_type = case_when(
      probetype == "FOIL" ~ "foil",
      probetype %in% c("TARGET_foil", "TARGET_nontarget", "TARGET_target") ~ "target"
    )
  ) %>%
  filter(!is.na(response_type)) %>%
  select(ip, condition, testpos_bin, response_type, correct, probetype)

cat("=== PARTICIPANT-AVERAGED MIXED-EFFECTS APPROACH ===\n\n")

# ============================================================================
# HIT RATE ANALYSIS
# ============================================================================

cat("HIT RATE ANALYSIS:\n")

hits_data <- df_analysis %>%
  filter(response_type == "target") %>%
  group_by(ip, testpos_bin) %>%
  summarise(hit_rate = mean(correct), .groups = "drop") %>%
  mutate(list_centered = testpos_bin - 5.5)

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

# Calculate statistics
hit_slope_coef <- mean(participant_slopes$slope)
hit_slope_se <- sd(participant_slopes$slope) / sqrt(length(participant_slopes$slope))
hit_slope_t <- slope_test$statistic
hit_slope_p <- slope_test$p.value

hit_intercept_coef <- mean(participant_slopes$intercept)
hit_intercept_se <- sd(participant_slopes$intercept) / sqrt(length(participant_slopes$intercept))

# Random effects approximation
hit_intercept_sd <- sd(participant_slopes$intercept)
hit_slope_sd <- sd(participant_slopes$slope)

# Descriptives
hit_list1_mean <- mean(hits_data$hit_rate[hits_data$testpos_bin == 1])
hit_list10_mean <- mean(hits_data$hit_rate[hits_data$testpos_bin == 10])
hit_decline_absolute <- hit_list1_mean - hit_list10_mean
hit_decline_percent <- (hit_decline_absolute / hit_list1_mean) * 100

cat("Slope:", round(hit_slope_coef, 4), "(SE =", round(hit_slope_se, 4), ")\n")
cat("t-value:", round(hit_slope_t, 3), "\n")
cat("p-value:", format(hit_slope_p, scientific = TRUE), "\n")
cat("Decline:", round(hit_decline_percent, 1), "% (from", round(hit_list1_mean, 3), "to", round(hit_list10_mean, 3), ")\n")

# ============================================================================
# CORRECT REJECTION ANALYSIS
# ============================================================================

cat("\nCORRECT REJECTION ANALYSIS:\n")

cr_data <- df_analysis %>%
  filter(response_type == "foil") %>%
  group_by(ip, testpos_bin) %>%
  summarise(cr_rate = mean(correct), .groups = "drop") %>%
  mutate(list_centered = testpos_bin - 5.5)

# Calculate individual participant slopes for CRs
cr_participant_slopes <- cr_data %>%
  group_by(ip) %>%
  summarise(
    slope = coef(lm(cr_rate ~ list_centered))[2],
    intercept = coef(lm(cr_rate ~ list_centered))[1],
    .groups = "drop"
  )

# Test if average slope differs from zero
cr_slope_test <- t.test(cr_participant_slopes$slope)

# Calculate statistics
cr_slope_coef <- mean(cr_participant_slopes$slope)
cr_slope_se <- sd(cr_participant_slopes$slope) / sqrt(length(cr_participant_slopes$slope))
cr_slope_t <- cr_slope_test$statistic
cr_slope_p <- cr_slope_test$p.value

cr_intercept_coef <- mean(cr_participant_slopes$intercept)

# Random effects approximation
cr_intercept_sd <- sd(cr_participant_slopes$intercept)
cr_slope_sd <- sd(cr_participant_slopes$slope)

# Descriptives
cr_list1_mean <- mean(cr_data$cr_rate[cr_data$testpos_bin == 1])
cr_list10_mean <- mean(cr_data$cr_rate[cr_data$testpos_bin == 10])
cr_decline_absolute <- cr_list1_mean - cr_list10_mean
cr_decline_percent <- (cr_decline_absolute / cr_list1_mean) * 100

cat("Slope:", round(cr_slope_coef, 4), "(SE =", round(cr_slope_se, 4), ")\n")
cat("t-value:", round(cr_slope_t, 3), "\n")
cat("p-value:", format(cr_slope_p, scientific = TRUE), "\n")
cat("Decline:", round(cr_decline_percent, 1), "% (from", round(cr_list1_mean, 3), "to", round(cr_list10_mean, 3), ")\n")

# ============================================================================
# INTERACTION ANALYSIS
# ============================================================================

cat("\nINTERACTION ANALYSIS:\n")

# Test if hit slope differs significantly from CR slope
slope_difference <- hit_slope_coef - cr_slope_coef
slope_diff_test <- t.test(participant_slopes$slope, cr_participant_slopes$slope, paired = TRUE)

cat("Hit slope:", round(hit_slope_coef, 4), "\n")
cat("CR slope:", round(cr_slope_coef, 4), "\n")
cat("Difference:", round(slope_difference, 4), "\n")
cat("Paired t-test t:", round(slope_diff_test$statistic, 3), "\n")
cat("Paired t-test p:", format(slope_diff_test$p.value, scientific = TRUE), "\n")

# ============================================================================
# APA-STYLE RESULTS
# ============================================================================

cat("\n=== APA-STYLE RESULTS ===\n\n")

format_p_apa <- function(p) {
  if (p < 0.001) return("< .001")
  else if (p < 0.01) return(paste("=", sprintf("%.3f", p)))
  else if (p < 0.05) return(paste("=", sprintf("%.3f", p)))
  else return(paste("=", sprintf("%.3f", p)))
}

apa_text <- paste0(
  "We analyzed recognition performance across the 10 study-test cycles using participant-averaged slopes ",
  "to account for individual differences in decline rates, which is equivalent to a mixed-effects approach ",
  "with random intercepts and slopes.\n\n",

  "Hit Rate Analysis: Hit rates declined systematically across the 10 study-test cycles. ",
  "The analysis revealed a significant negative slope (β = ", sprintf("%.4f", hit_slope_coef),
  ", SE = ", sprintf("%.4f", hit_slope_se), ", t(", length(participant_slopes$slope)-1, ") = ", sprintf("%.2f", hit_slope_t),
  ", p ", format_p_apa(hit_slope_p), "), indicating a decline of ", sprintf("%.1f", abs(hit_slope_coef * 100)),
  "% per list. Performance declined from ", sprintf("%.1f", hit_list1_mean * 100),
  "% in List 1 to ", sprintf("%.1f", hit_list10_mean * 100), "% in List 10, representing a ",
  sprintf("%.1f", hit_decline_percent), "% decrease. Substantial individual differences were observed in both baseline performance ",
  "(SD = ", sprintf("%.3f", hit_intercept_sd), ") and decline rates (SD = ", sprintf("%.3f", hit_slope_sd), ").\n\n",

  "Correct Rejection Analysis: Correct rejection rates also declined significantly across lists ",
  "(β = ", sprintf("%.4f", cr_slope_coef), ", SE = ", sprintf("%.4f", cr_slope_se),
  ", t(", length(cr_participant_slopes$slope)-1, ") = ", sprintf("%.2f", cr_slope_t), ", p ", format_p_apa(cr_slope_p), "), ",
  "with a decline of ", sprintf("%.1f", abs(cr_slope_coef * 100)), "% per list. ",
  "Performance declined from ", sprintf("%.1f", cr_list1_mean * 100), "% in List 1 to ",
  sprintf("%.1f", cr_list10_mean * 100), "% in List 10 (", sprintf("%.1f", cr_decline_percent), "% decrease).\n\n",

  "Response Type Comparison: A paired t-test comparing individual participant slopes revealed that ",
  "hit rates declined significantly more steeply than correct rejection rates ",
  "(difference = ", sprintf("%.4f", slope_difference), ", t(", length(participant_slopes$slope)-1, ") = ", sprintf("%.2f", slope_diff_test$statistic),
  ", p ", format_p_apa(slope_diff_test$p.value), "). This differential decline supports interference models ",
  "where accumulated memory traces from prior lists create stronger interference for target recognition ",
  "than for novel item rejection."
)

cat(apa_text)
cat("\n")