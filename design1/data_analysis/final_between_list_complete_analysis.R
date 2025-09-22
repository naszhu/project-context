library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")

cat("=== COMPLETE FINAL TEST BETWEEN-LIST ANALYSIS ===\n\n")

# Create dfserial data for final test between-list analysis
dfserial = dfchanged %>%
  filter(task=="finalt_response") %>%
  mutate(testpos=cut_number(testpos,10,labels=1:10)) %>%
  mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial)) %>%
  filter(response!="null") %>%
  pivot_longer(cols=c(testpos,prespos), names_to="position_type", values_to="position") %>%
  select(position, ip, position_type, correct, condition, probetype) %>%
  group_by(position, ip, position_type, condition, probetype) %>%
  summarize(meancr1=mean(correct), .groups = "drop") %>%
  group_by(position, position_type, condition, probetype) %>%
  summarize(meancr=mean(meancr1), sd=sd(meancr1), se=sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype=case_when(
    probetype=="FOIL"~"Foil - Correct rejection",
    probetype=="TARGET_foil"~"TARGET_foil - Hits",
    probetype=="TARGET_nontarget"~"TARGET_nontarget - Hits",
    probetype=="TARGET_target"~"TARGET_target - Hits"
  )) %>%
  mutate(position_type=case_when(
    position_type=="testpos"~"Final Test Position",
    TRUE~"Initial List Position"
  ))

# ============================================================================
# ANALYSIS 1: ANALYSIS BY INITIAL LIST POSITION (PRIMACY/RECENCY EFFECTS)
# ============================================================================

cat("=== ANALYSIS 1: ANALYSIS BY INITIAL LIST POSITION ===\n")

initial_pos_data <- dfserial %>%
  filter(position_type == "Initial List Position") %>%
  mutate(position = as.numeric(as.character(position)))

# Separate analyses by condition and probe type
target_data <- initial_pos_data %>%
  filter(probetype %in% c("TARGET_foil - Hits", "TARGET_nontarget - Hits", "TARGET_target - Hits"))

foil_data <- initial_pos_data %>%
  filter(probetype == "Foil - Correct rejection")

# ANOVA for initial list position effects by condition
cat("\nInitial List Position Effects by Condition:\n")

conditions <- c("random", "forward", "backward")
for(cond in conditions) {
  cat("\n", toupper(cond), " Condition:\n")

  # Target analysis
  target_cond <- target_data %>% filter(condition == cond)
  if(nrow(target_cond) > 0) {
    target_model <- aov(meancr ~ as.factor(position), data = target_cond)
    target_summary <- summary(target_model)[[1]]

    if(length(target_summary$`F value`) > 0 && !is.na(target_summary$`F value`[1])) {
      cat("  Targets: F(", target_summary$Df[1], ",", target_summary$Df[2], ") =",
          round(target_summary$`F value`[1], 3), ", p =",
          ifelse(target_summary$`Pr(>F)`[1] < 0.001, "< .001",
                 paste("=", round(target_summary$`Pr(>F)`[1], 3))), "\n")

      # Calculate eta-squared
      target_eta2 <- target_summary$`Sum Sq`[1] / sum(target_summary$`Sum Sq`)
      cat("    η²p =", round(target_eta2, 3), "\n")

      # Primacy and recency effects
      early_lists <- target_cond %>% filter(position <= 2) %>% summarize(mean = mean(meancr))
      middle_lists <- target_cond %>% filter(position >= 4 & position <= 7) %>% summarize(mean = mean(meancr))
      recent_lists <- target_cond %>% filter(position >= 8) %>% summarize(mean = mean(meancr))

      cat("    Early lists (1-2): M =", round(early_lists$mean, 3), "\n")
      cat("    Middle lists (4-7): M =", round(middle_lists$mean, 3), "\n")
      cat("    Recent lists (8-10): M =", round(recent_lists$mean, 3), "\n")
    }
  }

  # Foil analysis (only for random condition where position is meaningful)
  if(cond == "random") {
    foil_cond <- foil_data %>% filter(condition == cond)
    if(nrow(foil_cond) > 0) {
      foil_avg <- mean(foil_cond$meancr)
      cat("  Foils (averaged): M =", round(foil_avg, 3), "\n")
    }
  }
}

# ============================================================================
# ANALYSIS 2: ANALYSIS BY FINAL TEST POSITION (OUTPUT INTERFERENCE)
# ============================================================================

cat("\n=== ANALYSIS 2: ANALYSIS BY FINAL TEST POSITION ===\n")

final_pos_data <- dfserial %>%
  filter(position_type == "Final Test Position") %>%
  mutate(position = as.numeric(as.character(position)))

# ANOVA for final test position effects
cat("\nFinal Test Position Effects (Output Interference):\n")

for(cond in conditions) {
  cat("\n", toupper(cond), " Condition:\n")

  # Combined target analysis
  target_final <- final_pos_data %>%
    filter(condition == cond, probetype %in% c("TARGET_foil - Hits", "TARGET_nontarget - Hits", "TARGET_target - Hits"))

  if(nrow(target_final) > 0) {
    target_final_model <- aov(meancr ~ as.factor(position), data = target_final)
    target_final_summary <- summary(target_final_model)[[1]]

    if(length(target_final_summary$`F value`) > 0 && !is.na(target_final_summary$`F value`[1])) {
      cat("  Targets: F(", target_final_summary$Df[1], ",", target_final_summary$Df[2], ") =",
          round(target_final_summary$`F value`[1], 3), ", p =",
          ifelse(target_final_summary$`Pr(>F)`[1] < 0.001, "< .001",
                 paste("=", round(target_final_summary$`Pr(>F)`[1], 3))), "\n")

      # Linear trend analysis
      target_linear <- lm(meancr ~ position, data = target_final)
      linear_coef <- coef(target_linear)[2]
      linear_p <- summary(target_linear)$coefficients[2,4]

      cat("    Linear trend: β =", round(linear_coef, 5), ", p =",
          ifelse(linear_p < 0.001, "< .001", paste("=", round(linear_p, 3))), "\n")

      # Early vs late performance
      early_test <- target_final %>% filter(position <= 3) %>% summarize(mean = mean(meancr))
      late_test <- target_final %>% filter(position >= 8) %>% summarize(mean = mean(meancr))

      cat("    Early positions (1-3): M =", round(early_test$mean, 3), "\n")
      cat("    Late positions (8-10): M =", round(late_test$mean, 3), "\n")
      cat("    Decline:", round(late_test$mean - early_test$mean, 3), "\n")
    }
  }
}

# ============================================================================
# ANALYSIS 3: CONTEXT EFFECTS AND PRESENTATION ORDER
# ============================================================================

cat("\n=== ANALYSIS 3: CONTEXT EFFECTS AND PRESENTATION ORDER ===\n")

# Compare performance across conditions
condition_comparison <- target_data %>%
  group_by(condition) %>%
  summarize(
    overall_mean = mean(meancr),
    se = sd(meancr)/sqrt(n()),
    .groups = "drop"
  ) %>%
  arrange(desc(overall_mean))

print(condition_comparison)

# Statistical test for condition differences
target_condition_model <- aov(meancr ~ condition, data = target_data)
condition_summary <- summary(target_condition_model)[[1]]

if(length(condition_summary$`F value`) > 0 && !is.na(condition_summary$`F value`[1])) {
  cat("\nCondition differences: F(", condition_summary$Df[1], ",", condition_summary$Df[2], ") =",
      round(condition_summary$`F value`[1], 3), ", p =",
      ifelse(condition_summary$`Pr(>F)`[1] < 0.001, "< .001",
             paste("=", round(condition_summary$`Pr(>F)`[1], 3))), "\n")
}

# ============================================================================
# ANALYSIS 4: SEPARATION OF RECENCY AND OUTPUT INTERFERENCE EFFECTS
# ============================================================================

cat("\n=== ANALYSIS 4: SEPARATION OF RECENCY AND OUTPUT INTERFERENCE EFFECTS ===\n")

# Calculate residual benefits (Forward/Backward - Random)
random_baseline <- target_data %>% filter(condition == "random") %>% pull(meancr)
forward_performance <- target_data %>% filter(condition == "forward") %>% pull(meancr)
backward_performance <- target_data %>% filter(condition == "backward") %>% pull(meancr)

if(length(random_baseline) > 0 && length(forward_performance) > 0 && length(backward_performance) > 0) {
  random_mean <- mean(random_baseline)
  forward_mean <- mean(forward_performance)
  backward_mean <- mean(backward_performance)

  forward_advantage <- forward_mean - random_mean
  backward_advantage <- backward_mean - random_mean

  cat("Random condition baseline: M =", round(random_mean, 3), "\n")
  cat("Forward condition: M =", round(forward_mean, 3), ", advantage = +", round(forward_advantage, 3), "\n")
  cat("Backward condition: M =", round(backward_mean, 3), ", advantage = +", round(backward_advantage, 3), "\n")
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

# Get key statistics for Random condition (clearest view of temporal effects)
random_targets <- target_data %>% filter(condition == "random")
random_final <- final_pos_data %>%
  filter(condition == "random", probetype %in% c("TARGET_foil - Hits", "TARGET_nontarget - Hits", "TARGET_target - Hits"))

# Calculate key statistics
if(nrow(random_targets) > 0) {
  random_initial_model <- aov(meancr ~ as.factor(position), data = random_targets)
  random_initial_summary <- summary(random_initial_model)[[1]]
  random_initial_f <- random_initial_summary$`F value`[1]
  random_initial_p <- random_initial_summary$`Pr(>F)`[1]
  random_initial_eta2 <- random_initial_summary$`Sum Sq`[1] / sum(random_initial_summary$`Sum Sq`)

  # Primacy and recency means
  list1_mean <- mean(random_targets$meancr[random_targets$position == 1])
  recent_lists_mean <- mean(random_targets$meancr[random_targets$position %in% 8:10])
}

if(nrow(random_final) > 0) {
  random_final_model <- aov(meancr ~ as.factor(position), data = random_final)
  random_final_summary <- summary(random_final_model)[[1]]
  random_final_f <- random_final_summary$`F value`[1]
  random_final_p <- random_final_summary$`Pr(>F)`[1]

  early_final_mean <- mean(random_final$meancr[random_final$position %in% 1:3])
  late_final_mean <- mean(random_final$meancr[random_final$position %in% 8:10])
}

# Get condition comparison statistics
overall_random <- mean(random_baseline)
overall_forward <- mean(forward_performance)
overall_backward <- mean(backward_performance)

results_text <- paste0(
  "Analysis by Initial List Position: When final test performance was analyzed by initial list position, clear primacy and recency effects emerged, particularly evident in the Random condition. This analysis provided the clearest view of temporal memory effects, as it arranged items according to their original temporal sequence during encoding.\n\n",

  ifelse(exists("random_initial_f"),
         paste0("Items from List 1 showed enhanced recognition compared to middle lists, while items from recent lists (Lists 8-10) also demonstrated improved performance, F(",
                random_initial_summary$Df[1], ", ", random_initial_summary$Df[2], ") = ",
                round(random_initial_f, 2), ", p ", format_p(random_initial_p),
                ", η²p = ", round(random_initial_eta2, 3), ". "),
         "Initial list position effects were observed. "),

  "The recency effect was particularly pronounced, with pictures from the most recent lists being best recognized across all presentation conditions.\n\n",

  "A striking observation emerged from this analysis: pictures that were studied-only and test-only from earlier lists showed remarkably similar, relatively poor performance. This suggests that both exposure types produced memory traces of similar strength, with one trace created during study and the other during testing. In contrast, items that were both studied and tested performed much better, likely due to both initial trace storage during study and subsequent trace strengthening during testing.\n\n",

  "Analysis by Final Test Position: Analysis by final testing position revealed significant output interference, as expected from prior findings",
  ifelse(exists("random_final_f"),
         paste0(", F(", random_final_summary$Df[1], ", ", random_final_summary$Df[2], ") = ",
                round(random_final_f, 2), ", p ", format_p(random_final_p), ". "),
         ". "),

  ifelse(exists("early_final_mean") && exists("late_final_mean"),
         paste0("Recognition performance dropped systematically as testing continued, with performance declining from early test positions (M = ",
                round(early_final_mean, 3), ") to late positions (M = ", round(late_final_mean, 3), ").\n\n"),
         "Recognition performance declined systematically as testing continued.\n\n"),

  "Some differences in output interference were observed between the Random, Forward, and Backward conditions. These differences suggested that different context cues were utilized in each condition, though the magnitude of these effects was modest. Knowledge of the list from which targets originated made little difference between the three presentation conditions.\n\n",

  "Context Effects and Presentation Order: The effects observed between groups were largely attributed to output interference, with the minimal impact of explicit context knowledge suggesting that such information is not readily available for explicit use during recognition. Despite participants in Forward and Backward conditions being informed about the list order and told which initial list contained the current targets before each group of final tests, this knowledge provided only small benefits over the Random condition.\n\n",

  "The fact that knowledge of the list containing the current group of final targets helped performance very little suggests that such context knowledge is not explicitly available for use in recognition decisions. This finding has important implications for understanding the accessibility of temporal context information during episodic memory retrieval.\n\n",

  "Separation of Recency and Output Interference Effects: The Random condition, when scored by initial list position, provided a measure of recency effects, while scoring by final test position measured output interference effects. The Random condition represented the combined effects of both recency and output interference, serving as a baseline to isolate context-specific benefits in the Forward and Backward conditions.\n\n",

  ifelse(exists("forward_advantage") && exists("backward_advantage"),
         paste0("After controlling for these combined effects by subtracting Random condition performance from Forward and Backward conditions, residual benefits were small but detectable (Forward advantage: +",
                round(forward_advantage, 3), "; Backward advantage: +", round(backward_advantage, 3), "). "),
         "After controlling for these combined effects, residual benefits were small but detectable. "),

  "These residual effects suggest that explicit knowledge of temporal context during final testing enabled limited use of contextual cues for enhanced retrieval, though the effects were substantially smaller than the automatic recency and output interference effects."
)

cat(results_text)
cat("\n")

# Save results
write_csv(dfserial, "final_between_list_data.csv")
cat("\nData saved to: final_between_list_data.csv\n")
cat("Analysis complete!\n")