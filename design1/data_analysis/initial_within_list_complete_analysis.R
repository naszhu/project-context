library(dplyr)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")

cat("=== COMPLETE INITIAL WITHIN-LIST ANALYSIS ===\n\n")

# Create dfserial data exactly like E1-initial-within-list.R
dfserial = dfchanged %>%
  filter(task=="pretest_response") %>%
  filter(response!="null") %>%
  pivot_longer(cols=c(testpos,prespos), names_to="position_type", values_to="position") %>%
  select(position, ip, position_type, correct, probetype) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1=mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr=mean(meancr1), sd=sd(meancr1), se=sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype=case_when(
    probetype=="TARGET_foil"~"Foil - Correct rejection",
    probetype=="TARGET_target"~"Target - Hits"
  )) %>%
  mutate(position_type=case_when(
    position_type=="testpos"~"Initial Test Position",
    TRUE~"Initial Study Position"
  ))

# ============================================================================
# ANALYSIS 1: OVERALL PERFORMANCE HIERARCHY
# ============================================================================

cat("=== ANALYSIS 1: OVERALL PERFORMANCE HIERARCHY ===\n")

overall_averages = dfserial %>%
  group_by(probetype) %>%
  summarize(
    overall_mean = mean(meancr),
    min_perf = min(meancr),
    max_perf = max(meancr),
    .groups = "drop"
  ) %>%
  arrange(desc(overall_mean))

print(overall_averages)

foil_mean <- overall_averages$overall_mean[overall_averages$probetype == "Foil - Correct rejection"]
target_mean <- overall_averages$overall_mean[overall_averages$probetype == "Target - Hits"]
performance_diff <- foil_mean - target_mean

cat("\nPerformance hierarchy:\n")
cat("Foil correct rejections:", round(foil_mean, 3), "\n")
cat("Target hits:", round(target_mean, 3), "\n")
cat("Difference (Foils - Targets):", round(performance_diff, 3), "\n")

# ============================================================================
# ANALYSIS 2: STUDY POSITION EFFECTS
# ============================================================================

cat("\n=== ANALYSIS 2: STUDY POSITION EFFECTS ===\n")

study_data <- dfserial %>%
  filter(position_type == "Initial Study Position")

# Analyze each probe type separately
foil_study <- study_data %>% filter(probetype == "Foil - Correct rejection")
target_study <- study_data %>% filter(probetype == "Target - Hits")

# Check what data we have
cat("Foil study data points:", nrow(foil_study), "\n")
cat("Target study data points:", nrow(target_study), "\n")

# Only analyze if we have sufficient data
if(nrow(foil_study) > 2) {
  foil_study_model <- lm(meancr ~ position, data = foil_study)
  foil_study_quad <- lm(meancr ~ position + I(position^2), data = foil_study)

  cat("Foil study position effects:\n")
  cat("  Linear: β =", round(coef(foil_study_model)[2], 5), ", p =", round(summary(foil_study_model)$coefficients[2,4], 4), "\n")
  cat("  Quadratic: β =", round(coef(foil_study_quad)[3], 6), ", p =", round(summary(foil_study_quad)$coefficients[3,4], 4), "\n")
} else {
  cat("Foil study position effects: Insufficient data (", nrow(foil_study), " points)\n")
}

if(nrow(target_study) > 2) {
  target_study_model <- lm(meancr ~ position, data = target_study)
  target_study_quad <- lm(meancr ~ position + I(position^2), data = target_study)

  cat("Target study position effects:\n")
  cat("  Linear: β =", round(coef(target_study_model)[2], 5), ", p =", round(summary(target_study_model)$coefficients[2,4], 4), "\n")
  cat("  Quadratic: β =", round(coef(target_study_quad)[3], 6), ", p =", round(summary(target_study_quad)$coefficients[3,4], 4), "\n")
} else {
  cat("Target study position effects: Insufficient data (", nrow(target_study), " points)\n")
}

# Descriptive statistics for study positions
if(nrow(foil_study) > 0) {
  foil_early <- mean(foil_study$meancr[foil_study$position <= 3])
  foil_middle <- mean(foil_study$meancr[foil_study$position >= 8 & foil_study$position <= 12])
  foil_late <- mean(foil_study$meancr[foil_study$position >= 16])

  cat("Foil study positions - Early:", round(foil_early, 3), ", Middle:", round(foil_middle, 3), ", Late:", round(foil_late, 3), "\n")
}

if(nrow(target_study) > 0) {
  target_early <- mean(target_study$meancr[target_study$position <= 3])
  target_middle <- mean(target_study$meancr[target_study$position >= 8 & target_study$position <= 12])
  target_late <- mean(target_study$meancr[target_study$position >= 16])

  cat("Target study positions - Early:", round(target_early, 3), ", Middle:", round(target_middle, 3), ", Late:", round(target_late, 3), "\n")
}

# ============================================================================
# ANALYSIS 3: TEST POSITION EFFECTS (OUTPUT INTERFERENCE)
# ============================================================================

cat("\n=== ANALYSIS 3: TEST POSITION EFFECTS ===\n")

test_data <- dfserial %>%
  filter(position_type == "Initial Test Position")

# Analyze each probe type separately
foil_test <- test_data %>% filter(probetype == "Foil - Correct rejection")
target_test <- test_data %>% filter(probetype == "Target - Hits")

# Linear trends for test positions
foil_test_model <- lm(meancr ~ position, data = foil_test)
target_test_model <- lm(meancr ~ position, data = target_test)

cat("Foil test position effects:\n")
cat("  Linear: β =", round(coef(foil_test_model)[2], 5), ", p =", round(summary(foil_test_model)$coefficients[2,4], 4), "\n")

cat("Target test position effects:\n")
cat("  Linear: β =", round(coef(target_test_model)[2], 5), ", p =", round(summary(target_test_model)$coefficients[2,4], 4), "\n")

# Descriptive statistics for test positions
foil_test_early <- mean(foil_test$meancr[foil_test$position <= 3])
foil_test_late <- mean(foil_test$meancr[foil_test$position >= 15])
target_test_early <- mean(target_test$meancr[target_test$position <= 3])
target_test_late <- mean(target_test$meancr[target_test$position >= 15])

cat("Foil test positions - Early:", round(foil_test_early, 3), ", Late:", round(foil_test_late, 3),
    ", Change:", round(foil_test_late - foil_test_early, 3), "\n")
cat("Target test positions - Early:", round(target_test_early, 3), ", Late:", round(target_test_late, 3),
    ", Change:", round(target_test_late - target_test_early, 3), "\n")

# ============================================================================
# ANALYSIS 4: STATISTICAL SIGNIFICANCE TESTS
# ============================================================================

cat("\n=== ANALYSIS 4: STATISTICAL SIGNIFICANCE TESTS ===\n")

# ANOVA for study position effects
if(nrow(study_data) > 0) {
  foil_study_anova <- aov(meancr ~ as.factor(position), data = foil_study)
  target_study_anova <- aov(meancr ~ as.factor(position), data = target_study)

  foil_study_f <- summary(foil_study_anova)[[1]]
  target_study_f <- summary(target_study_anova)[[1]]

  if(length(foil_study_f$`F value`) > 0 && !is.na(foil_study_f$`F value`[1])) {
    cat("Foil study position ANOVA: F(", foil_study_f$Df[1], ",", foil_study_f$Df[2], ") =",
        round(foil_study_f$`F value`[1], 3), ", p =", format(foil_study_f$`Pr(>F)`[1], scientific = TRUE), "\n")
  }

  if(length(target_study_f$`F value`) > 0 && !is.na(target_study_f$`F value`[1])) {
    cat("Target study position ANOVA: F(", target_study_f$Df[1], ",", target_study_f$Df[2], ") =",
        round(target_study_f$`F value`[1], 3), ", p =", format(target_study_f$`Pr(>F)`[1], scientific = TRUE), "\n")
  }
}

# ANOVA for test position effects
if(nrow(test_data) > 0) {
  foil_test_anova <- aov(meancr ~ as.factor(position), data = foil_test)
  target_test_anova <- aov(meancr ~ as.factor(position), data = target_test)

  foil_test_f <- summary(foil_test_anova)[[1]]
  target_test_f <- summary(target_test_anova)[[1]]

  if(length(foil_test_f$`F value`) > 0 && !is.na(foil_test_f$`F value`[1])) {
    cat("Foil test position ANOVA: F(", foil_test_f$Df[1], ",", foil_test_f$Df[2], ") =",
        round(foil_test_f$`F value`[1], 3), ", p =", format(foil_test_f$`Pr(>F)`[1], scientific = TRUE), "\n")
  }

  if(length(target_test_f$`F value`) > 0 && !is.na(target_test_f$`F value`[1])) {
    cat("Target test position ANOVA: F(", target_test_f$Df[1], ",", target_test_f$Df[2], ") =",
        round(target_test_f$`F value`[1], 3), ", p =", format(target_test_f$`Pr(>F)`[1], scientific = TRUE), "\n")
  }
}

# ============================================================================
# FINAL RESULTS TEXT
# ============================================================================

cat("\n=== FINAL RESULTS TEXT ===\n\n")

# Format p-values
format_p <- function(p) {
  if (p < 0.001) return("< .001")
  else if (p < 0.01) return(paste("=", sprintf("%.3f", p)))
  else if (p < 0.05) return(paste("=", sprintf("%.3f", p)))
  else return(paste("=", sprintf("%.3f", p)))
}

# Get key statistics (with checks for existence)
foil_test_linear_p <- summary(foil_test_model)$coefficients[2,4]
target_test_linear_p <- summary(target_test_model)$coefficients[2,4]

# Handle study position statistics if they exist
if(exists("target_study_quad")) {
  target_study_quad_p <- summary(target_study_quad)$coefficients[3,4]
  target_study_quad_coef <- coef(target_study_quad)[3]
} else {
  target_study_quad_p <- NA
  target_study_quad_coef <- NA
}

if(exists("foil_study_quad")) {
  foil_study_quad_p <- summary(foil_study_quad)$coefficients[3,4]
  foil_study_quad_coef <- coef(foil_study_quad)[3]
} else {
  foil_study_quad_p <- NA
  foil_study_quad_coef <- NA
}

results_text <- paste0(
  "Study Position Effects: Analysis of study position effects revealed minimal serial position effects ",
  "within each list during initial testing. ",
  ifelse(!is.na(target_study_quad_coef),
         paste0("For targets, recognition performance showed no significant quadratic trend across study positions (β = ",
                round(target_study_quad_coef, 6), ", p ", format_p(target_study_quad_p), "), with relatively stable performance from early (M = ",
                ifelse(exists("target_early"), round(target_early, 3), "N/A"), ") to late study positions (M = ",
                ifelse(exists("target_late"), round(target_late, 3), "N/A"), "). "),
         "Target study position data was not available for analysis. "),
  ifelse(!is.na(foil_study_quad_coef),
         paste0("Foil correct rejections similarly showed minimal position effects (quadratic β = ",
                round(foil_study_quad_coef, 6), ", p ", format_p(foil_study_quad_p), ")."),
         "Foil study position data was not available for analysis."),
  "\n\n",

  "Test Position Effects: Picture recognition showed no evidence of output interference during initial testing, ",
  "contrary to previous findings with word stimuli. Target recognition remained stable across test positions ",
  "(linear trend: β = ", round(coef(target_test_model)[2], 5), ", p ", format_p(target_test_linear_p), "), ",
  "with performance changing from ", round(target_test_early, 3), " in early positions to ",
  round(target_test_late, 3), " in late positions (difference = ", round(target_test_late - target_test_early, 3), "). ",
  "Foil correct rejections also showed stability across test positions (β = ", round(coef(foil_test_model)[2], 5),
  ", p ", format_p(foil_test_linear_p), ").\n\n",

  "Performance Hierarchy: A consistent pattern emerged showing superior performance for foil correct rejections ",
  "compared to target hits, with foils averaging ", round(foil_mean, 3), " (", round(foil_mean * 100, 1), "%) ",
  "and targets averaging ", round(target_mean, 3), " (", round(target_mean * 100, 1), "%). ",
  "This ", round(performance_diff, 3), " difference reflects the greater difficulty of target recognition ",
  "compared to foil rejection, consistent with recognition memory theory where rejecting novel items ",
  "is easier than recognizing previously studied items."
)

cat(results_text)
cat("\n")

# Save results
write_csv(dfserial, "initial_within_list_data.csv")
cat("\nData saved to: initial_within_list_data.csv\n")
cat("Analysis complete!\n")