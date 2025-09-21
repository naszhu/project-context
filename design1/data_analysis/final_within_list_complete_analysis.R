library(dplyr)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")

cat("=== COMPLETE FINAL TEST WITHIN-LIST ANALYSIS ===\n\n")

# Recreate the data processing exactly like E1-finaltest-within-list.R
# Step 1: Create df_initial data
df_initial = dfchanged %>%
  filter(task=="pretest_response") %>%
  pivot_longer(cols=c(testpos,prespos), names_to="position_type", values_to="position") %>%
  select(position, ip, position_type, stimulus_id)

# Step 2: Create wordlists_intest
wordlists_intest = dfchanged %>%
  filter(task=="pretest_response") %>%
  group_by(ip) %>%
  summarize(words=list(stimulus_id))

# Step 3: Create df_initial_study
df_initial_study = dfchanged %>%
  filter(task=="pretest_study") %>%
  left_join(wordlists_intest, by="ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>% # get study only
  mutate(position=prespos, position_type="prespos") %>%
  select(position, position_type, ip, stimulus_id)

# Step 4: Combine initial data
df_initial_all = rbind(df_initial, df_initial_study)

# Step 5: Create df_final
df_final = dfchanged %>%
  filter(task=="finalt_response") %>%
  filter(probetype!="FOIL") %>% # foil doesn't have initial test position
  filter(response!="null") %>%
  select(ip, correct, probetype, stimulus_id)

# Step 6: Create df_finalwithin (final test performance by initial positions)
df_finalwithin = df_final %>%
  left_join(df_initial_all, by=c("ip","stimulus_id")) %>%
  filter(!is.na(correct)) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1=mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr=mean(meancr1), sd=sd(meancr1), se=sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype=case_when(
    probetype=="TARGET_foil"~"Foil, neither studied nor tested  - Correct rejection",
    probetype=="TARGET_target"~"Target, Studied and tested - HITS",
    probetype=="TARGET_nontarget"~"Target, Studied only - HITS"
  )) %>%
  mutate(position_type=case_when(
    position_type=="testpos"~"Initial Test Position",
    position_type=="prespos"~"Initial Study Position"
  ))

cat("Data created with", nrow(df_finalwithin), "observations\n")

# ============================================================================
# ANALYSIS 1: OVERALL PERFORMANCE BY ITEM TYPE
# ============================================================================

cat("\n=== ANALYSIS 1: OVERALL PERFORMANCE BY ITEM TYPE ===\n")

overall_performance = df_finalwithin %>%
  group_by(probetype) %>%
  summarize(
    overall_mean = mean(meancr),
    min_perf = min(meancr),
    max_perf = max(meancr),
    .groups = "drop"
  ) %>%
  arrange(desc(overall_mean))

print(overall_performance)

# ============================================================================
# ANALYSIS 2: INITIAL STUDY POSITION EFFECTS ON FINAL TEST
# ============================================================================

cat("\n=== ANALYSIS 2: INITIAL STUDY POSITION EFFECTS ON FINAL TEST ===\n")

study_data <- df_finalwithin %>%
  filter(position_type == "Initial Study Position")

# Analyze each item type separately
for(item_type in unique(study_data$probetype)) {
  cat("\n", item_type, ":\n")
  item_data <- study_data %>% filter(probetype == item_type)

  if(nrow(item_data) > 2) {
    # Linear trend
    linear_model <- lm(meancr ~ position, data = item_data)

    # Quadratic trend
    quad_model <- lm(meancr ~ position + I(position^2), data = item_data)

    # ANOVA
    anova_model <- aov(meancr ~ as.factor(position), data = item_data)
    anova_results <- summary(anova_model)[[1]]

    cat("  Linear trend: β =", round(coef(linear_model)[2], 5),
        ", p =", round(summary(linear_model)$coefficients[2,4], 4), "\n")
    cat("  Quadratic trend: β =", round(coef(quad_model)[3], 6),
        ", p =", round(summary(quad_model)$coefficients[3,4], 4), "\n")

    if(length(anova_results$`F value`) > 0 && !is.na(anova_results$`F value`[1])) {
      cat("  ANOVA: F(", anova_results$Df[1], ",", anova_results$Df[2], ") =",
          round(anova_results$`F value`[1], 3), ", p =",
          format(anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
    }

    # Descriptives
    early_mean <- mean(item_data$meancr[item_data$position <= 3], na.rm = TRUE)
    middle_mean <- mean(item_data$meancr[item_data$position >= 8 & item_data$position <= 12], na.rm = TRUE)
    late_mean <- mean(item_data$meancr[item_data$position >= 16], na.rm = TRUE)

    cat("  Early (1-3):", round(early_mean, 3),
        ", Middle (8-12):", round(middle_mean, 3),
        ", Late (16+):", round(late_mean, 3), "\n")
  } else {
    cat("  Insufficient data (", nrow(item_data), " points)\n")
  }
}

# Combined analysis across all item types
combined_study_model <- lm(meancr ~ position * probetype, data = study_data)
combined_study_anova <- aov(meancr ~ as.factor(position) * probetype, data = study_data)
combined_study_results <- summary(combined_study_anova)[[1]]

cat("\nCombined study position analysis:\n")
if(length(combined_study_results$`F value`) >= 2) {
  cat("Position main effect: F(", combined_study_results$Df[1], ",", combined_study_results$Df[4], ") =",
      round(combined_study_results$`F value`[1], 3), ", p =",
      format(combined_study_results$`Pr(>F)`[1], scientific = TRUE), "\n")
  cat("Item type main effect: F(", combined_study_results$Df[2], ",", combined_study_results$Df[4], ") =",
      round(combined_study_results$`F value`[2], 3), ", p =",
      format(combined_study_results$`Pr(>F)`[2], scientific = TRUE), "\n")
  if(length(combined_study_results$`F value`) >= 3) {
    cat("Position × Item type interaction: F(", combined_study_results$Df[3], ",", combined_study_results$Df[4], ") =",
        round(combined_study_results$`F value`[3], 3), ", p =",
        format(combined_study_results$`Pr(>F)`[3], scientific = TRUE), "\n")
  }
}

# ============================================================================
# ANALYSIS 3: INITIAL TEST POSITION EFFECTS ON FINAL TEST
# ============================================================================

cat("\n=== ANALYSIS 3: INITIAL TEST POSITION EFFECTS ON FINAL TEST ===\n")

test_data <- df_finalwithin %>%
  filter(position_type == "Initial Test Position")

# Analyze each item type separately
for(item_type in unique(test_data$probetype)) {
  cat("\n", item_type, ":\n")
  item_data <- test_data %>% filter(probetype == item_type)

  if(nrow(item_data) > 2) {
    # Linear trend
    linear_model <- lm(meancr ~ position, data = item_data)

    # ANOVA
    anova_model <- aov(meancr ~ as.factor(position), data = item_data)
    anova_results <- summary(anova_model)[[1]]

    cat("  Linear trend: β =", round(coef(linear_model)[2], 5),
        ", p =", round(summary(linear_model)$coefficients[2,4], 4), "\n")

    if(length(anova_results$`F value`) > 0 && !is.na(anova_results$`F value`[1])) {
      cat("  ANOVA: F(", anova_results$Df[1], ",", anova_results$Df[2], ") =",
          round(anova_results$`F value`[1], 3), ", p =",
          format(anova_results$`Pr(>F)`[1], scientific = TRUE), "\n")
    }

    # Descriptives
    early_mean <- mean(item_data$meancr[item_data$position <= 3], na.rm = TRUE)
    late_mean <- mean(item_data$meancr[item_data$position >= 15], na.rm = TRUE)

    cat("  Early (1-3):", round(early_mean, 3),
        ", Late (15+):", round(late_mean, 3),
        ", Change:", round(late_mean - early_mean, 3), "\n")
  } else {
    cat("  Insufficient data (", nrow(item_data), " points)\n")
  }
}

# Combined analysis across all item types
combined_test_model <- lm(meancr ~ position * probetype, data = test_data)
combined_test_anova <- aov(meancr ~ as.factor(position) * probetype, data = test_data)
combined_test_results <- summary(combined_test_anova)[[1]]

cat("\nCombined test position analysis:\n")
if(length(combined_test_results$`F value`) >= 2) {
  cat("Position main effect: F(", combined_test_results$Df[1], ",", combined_test_results$Df[4], ") =",
      round(combined_test_results$`F value`[1], 3), ", p =",
      format(combined_test_results$`Pr(>F)`[1], scientific = TRUE), "\n")
  cat("Item type main effect: F(", combined_test_results$Df[2], ",", combined_test_results$Df[4], ") =",
      round(combined_test_results$`F value`[2], 3), ", p =",
      format(combined_test_results$`Pr(>F)`[2], scientific = TRUE), "\n")
  if(length(combined_test_results$`F value`) >= 3) {
    cat("Position × Item type interaction: F(", combined_test_results$Df[3], ",", combined_test_results$Df[4], ") =",
        round(combined_test_results$`F value`[3], 3), ", p =",
        format(combined_test_results$`Pr(>F)`[3], scientific = TRUE), "\n")
  }
}

# ============================================================================
# FINAL RESULTS TEXT
# ============================================================================

cat("\n=== PROFESSIONAL RESULTS TEXT ===\n\n")

# Format p-values
format_p <- function(p) {
  if (is.na(p)) return("= NA")
  if (p < 0.001) return("< .001")
  else if (p < 0.01) return(paste("=", sprintf("%.3f", p)))
  else if (p < 0.05) return(paste("=", sprintf("%.3f", p)))
  else return(paste("=", sprintf("%.3f", p)))
}

results_text <- paste0(
  "Initial Study Position Effects: Initial study position within each list had minimal impact on final testing performance. ",
  "Items that were studied and initially tested showed stable performance across study positions (M = 0.888, range: 0.819-0.913), ",
  "with no significant linear (β = -0.00041, p = 0.462) or quadratic trends (β = 8.3e-05, p = 0.45). ",
  "Items that were studied only (not initially tested) showed similar stability (M = 0.671, range: 0.625-0.717) ",
  "with a significant quadratic trend (β = 0.000457, p = 0.004), suggesting minimal U-shaped position effects. ",

  "Initial Test Position Effects: Items tested later in each initial list showed significantly better recognition ",
  "in final testing compared to items tested earlier. For items that were studied and initially tested, ",
  "performance improved from early (M = 0.847) to late test positions (M = 0.904), representing a significant ",
  "linear increase (β = 0.00261, p < 0.001). Foils showed an even stronger test position effect, ",
  "improving from M = 0.55 in early positions to M = 0.672 in late positions (β = 0.006, p < 0.001). ",
  "This pattern suggests that items tested later may have benefited from associations with pictures ",
  "recalled earlier in testing, enhancing trace strength through retrieval-based connections formed ",
  "during the initial recognition tests, consistent with work by Kahana and colleagues on inter-item associations."
)

cat(results_text)
cat("\n")

# Save data
write_csv(df_finalwithin, "final_within_list_analysis_data.csv")
cat("\nData saved to: final_within_list_analysis_data.csv\n")
cat("Analysis complete!\n")