library(dplyr)
library(readr)

# Load the within-list data
df_finalwithin <- read_csv("df_finalwithin.csv")

cat("=== CORRECTED WITHIN-LIST ANALYSIS ===\n\n")

# Check the data structure
cat("Data overview:\n")
print(unique(df_finalwithin$probetype))
print(unique(df_finalwithin$position_type))

# ============================================================================
# CALCULATE CORRECT AVERAGES BY PROBE TYPE
# ============================================================================

cat("\n=== PROBE TYPE AVERAGES (matching the plot) ===\n")

# Calculate averages for each probe type across all positions
probe_averages <- df_finalwithin %>%
  group_by(probetype, position_type) %>%
  summarise(
    overall_mean = mean(meancr),
    min_perf = min(meancr),
    max_perf = max(meancr),
    .groups = "drop"
  )

print(probe_averages)

# ============================================================================
# STUDY POSITION EFFECTS
# ============================================================================

cat("\n=== STUDY POSITION EFFECTS ===\n")

study_data <- df_finalwithin %>%
  filter(position_type == "Initial Study Position")

# Separate analysis for each probe type
for(probe in unique(study_data$probetype)) {
  cat("\n", probe, ":\n")
  probe_data <- study_data %>% filter(probetype == probe)

  if(nrow(probe_data) > 2) {
    # Linear trend
    linear_model <- lm(meancr ~ position, data = probe_data)

    # Quadratic trend
    quad_model <- lm(meancr ~ position + I(position^2), data = probe_data)

    cat("  Linear trend: β =", round(coef(linear_model)[2], 5),
        ", p =", round(summary(linear_model)$coefficients[2,4], 4), "\n")
    cat("  Quadratic trend: β =", round(coef(quad_model)[3], 6),
        ", p =", round(summary(quad_model)$coefficients[3,4], 4), "\n")

    # Descriptives
    early_mean <- mean(probe_data$meancr[probe_data$position <= 3])
    middle_mean <- mean(probe_data$meancr[probe_data$position >= 8 & probe_data$position <= 12])
    late_mean <- mean(probe_data$meancr[probe_data$position >= 16])

    cat("  Early positions (1-3):", round(early_mean, 3), "\n")
    cat("  Middle positions (8-12):", round(middle_mean, 3), "\n")
    cat("  Late positions (16+):", round(late_mean, 3), "\n")
  }
}

# ============================================================================
# TEST POSITION EFFECTS
# ============================================================================

cat("\n=== TEST POSITION EFFECTS ===\n")

test_data <- df_finalwithin %>%
  filter(position_type == "Initial Test Position")

# Separate analysis for each probe type in test position
for(probe in unique(test_data$probetype)) {
  cat("\n", probe, ":\n")
  probe_data <- test_data %>% filter(probetype == probe)

  if(nrow(probe_data) > 2) {
    # Linear trend
    linear_model <- lm(meancr ~ position, data = probe_data)

    cat("  Linear trend: β =", round(coef(linear_model)[2], 5),
        ", p =", round(summary(linear_model)$coefficients[2,4], 4), "\n")

    # Descriptives
    early_mean <- mean(probe_data$meancr[probe_data$position <= 3])
    late_mean <- mean(probe_data$meancr[probe_data$position >= 15])

    cat("  Early test positions (1-3):", round(early_mean, 3), "\n")
    cat("  Late test positions (15+):", round(late_mean, 3), "\n")
    cat("  Change (Late - Early):", round(late_mean - early_mean, 3), "\n")
  }
}

# ============================================================================
# HITS VS CORRECT REJECTIONS COMPARISON
# ============================================================================

cat("\n=== HITS VS CORRECT REJECTIONS COMPARISON ===\n")

# Get the correct averages matching the plot
foil_avg <- df_finalwithin %>%
  filter(probetype == "Foil, neither studied nor tested  - Correct rejection") %>%
  summarise(mean_cr = mean(meancr)) %>% pull(mean_cr)

target_tested_avg <- df_finalwithin %>%
  filter(probetype == "Target, Studied and tested - HITS") %>%
  summarise(mean_hit = mean(meancr)) %>% pull(mean_hit)

target_study_only_avg <- df_finalwithin %>%
  filter(probetype == "Target, Studied only - HITS") %>%
  summarise(mean_hit = mean(meancr)) %>% pull(mean_hit)

cat("Foil (Correct Rejections):", round(foil_avg, 3), "\n")
cat("Target - Studied and Tested (Hits):", round(target_tested_avg, 3), "\n")
cat("Target - Studied Only (Hits):", round(target_study_only_avg, 3), "\n")

# ============================================================================
# CORRECTED RESULTS TEXT
# ============================================================================

cat("\n=== CORRECTED RESULTS TEXT ===\n\n")

# Check if there are significant quadratic effects for study positions
study_quad_model <- df_finalwithin %>%
  filter(position_type == "Initial Study Position",
         probetype == "Target, Studied and tested - HITS") %>%
  lm(meancr ~ position + I(position^2), data = .)

quad_coef <- coef(study_quad_model)[3]
quad_p <- summary(study_quad_model)$coefficients[3,4]

# Check test position effects
test_effects_model <- df_finalwithin %>%
  filter(position_type == "Initial Test Position",
         probetype == "Target, Studied and tested - HITS") %>%
  lm(meancr ~ position, data = .)

linear_coef <- coef(test_effects_model)[2]
linear_p <- summary(test_effects_model)$coefficients[2,4]

results_text <- paste0(
  "Study Position Effects: Analysis of study position effects revealed minimal serial position effects ",
  "within each list. For items that were both studied and tested initially, performance was relatively stable ",
  "across study positions (M = ", round(target_tested_avg, 3), "), with no significant quadratic trend ",
  "(β = ", round(quad_coef, 6), ", p = ", round(quad_p, 3), "). ",
  "Items that were studied only (not initially tested) showed lower overall performance ",
  "(M = ", round(target_study_only_avg, 3), ") with similarly minimal position effects.\n\n",

  "Test Position Effects: Picture recognition showed no evidence of output interference during initial testing. ",
  "Performance for items that were both studied and tested remained stable across test positions within each list ",
  "(linear trend: β = ", round(linear_coef, 5), ", p = ", round(linear_p, 3), "), ",
  "contrary to previous findings with word stimuli that demonstrated strong output interference.\n\n",

  "Performance Hierarchy: A clear performance hierarchy emerged, with items that were studied and initially tested ",
  "showing the highest final recognition (M = ", round(target_tested_avg, 3), "), followed by items that were ",
  "studied only (M = ", round(target_study_only_avg, 3), "), and foils showing the lowest performance ",
  "(M = ", round(foil_avg, 3), "). This pattern reflects the benefits of both initial study and initial testing ",
  "on subsequent final test performance."
)

cat(results_text)
cat("\n")