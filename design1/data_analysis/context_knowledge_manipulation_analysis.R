library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(broom)
library(effectsize)
library(purrr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data for context knowledge manipulation analysis\n")

# ================================================================================
# CONTEXT KNOWLEDGE MANIPULATION AND OVERALL EFFECTS ANALYSIS
# ================================================================================

# Create data for context knowledge manipulation analysis
# Focus on final test performance and how initial exposure history affects recognition

context_data <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  mutate(
    # Create initial exposure history categories
    exposure_history = case_when(
      probetype == "TARGET_target" ~ "Studied-and-Tested",
      probetype == "TARGET_nontarget" ~ "Studied-Only",
      probetype == "TARGET_foil" ~ "Test-Only",
      probetype == "FOIL" ~ "Novel-Foil",
      TRUE ~ "Other"
    ),
    # Create recency bins (most recent = higher numbers)
    recency_bin = cut_number(prespos_itrial, 5, labels = c("Earliest", "Early", "Middle", "Late", "Most Recent")),
    # Create list order knowledge condition
    list_order_condition = condition
  ) %>%
  select(ip, exposure_history, recency_bin, list_order_condition, correct, prespos_itrial, testpos)

# ================================================================================
# ANALYSIS 1: OVERALL RECOGNITION PERFORMANCE BY EXPOSURE HISTORY
# ================================================================================

exposure_performance <- context_data %>%
  group_by(exposure_history, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  group_by(exposure_history) %>%
  summarize(
    mean_performance = mean(performance, na.rm = TRUE),
    sd_performance = sd(performance, na.rm = TRUE),
    se_performance = sd_performance / sqrt(n()),
    n_participants = n(),
    .groups = 'drop'
  )

# Statistical comparison of exposure history effects
exposure_aov <- context_data %>%
  group_by(exposure_history, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  filter(exposure_history != "Other") %>%
  aov(performance ~ exposure_history, data = .)

exposure_aov_summary <- tidy(exposure_aov)
exposure_effect_size <- effectsize::eta_squared(exposure_aov)

# ================================================================================
# ANALYSIS 2: RECENCY EFFECTS ANALYSIS
# ================================================================================

recency_performance <- context_data %>%
  filter(exposure_history != "Novel-Foil") %>%  # Focus on previously encountered items
  group_by(recency_bin, exposure_history, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  group_by(recency_bin, exposure_history) %>%
  summarize(
    mean_performance = mean(performance, na.rm = TRUE),
    sd_performance = sd(performance, na.rm = TRUE),
    se_performance = sd_performance / sqrt(n()),
    n_participants = n(),
    .groups = 'drop'
  )

# Test for recency effect (linear trend) - simplified approach
recency_trend_data <- context_data %>%
  filter(exposure_history != "Novel-Foil") %>%
  group_by(ip, exposure_history) %>%
  summarize(performance = mean(correct, na.rm = TRUE),
            mean_recency = mean(as.numeric(recency_bin), na.rm = TRUE), .groups = 'drop')

# Create separate models for each exposure history
recency_trend_test <- data.frame()
for (hist in unique(recency_trend_data$exposure_history)) {
  subset_data <- recency_trend_data[recency_trend_data$exposure_history == hist, ]
  if (nrow(subset_data) > 3) {  # Ensure enough data points
    model <- lm(performance ~ mean_recency, data = subset_data)
    model_summary <- summary(model)

    result <- data.frame(
      exposure_history = hist,
      slope = coef(model)[2],
      p_value = model_summary$coefficients[2,4],
      r_squared = model_summary$r.squared
    )
    recency_trend_test <- rbind(recency_trend_test, result)
  }
}

# ================================================================================
# ANALYSIS 3: LIST ORDER KNOWLEDGE EFFECTS
# ================================================================================

list_order_performance <- context_data %>%
  group_by(list_order_condition, exposure_history, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  group_by(list_order_condition, exposure_history) %>%
  summarize(
    mean_performance = mean(performance, na.rm = TRUE),
    sd_performance = sd(performance, na.rm = TRUE),
    se_performance = sd_performance / sqrt(n()),
    n_participants = n(),
    .groups = 'drop'
  )

# Statistical test for list order knowledge effects
list_order_aov <- context_data %>%
  group_by(list_order_condition, exposure_history, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  filter(exposure_history != "Other") %>%
  aov(performance ~ list_order_condition * exposure_history, data = .)

list_order_aov_summary <- tidy(list_order_aov)
list_order_effect_size <- effectsize::eta_squared(list_order_aov)

# ================================================================================
# ANALYSIS 4: RECENCY × LIST ORDER INTERACTION
# ================================================================================

recency_order_interaction <- context_data %>%
  filter(exposure_history != "Novel-Foil" & exposure_history != "Other") %>%
  group_by(recency_bin, list_order_condition, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  group_by(recency_bin, list_order_condition) %>%
  summarize(
    mean_performance = mean(performance, na.rm = TRUE),
    sd_performance = sd(performance, na.rm = TRUE),
    se_performance = sd_performance / sqrt(n()),
    n_participants = n(),
    .groups = 'drop'
  )

# Test for recency × list order interaction
interaction_aov <- context_data %>%
  filter(exposure_history != "Novel-Foil" & exposure_history != "Other") %>%
  group_by(recency_bin, list_order_condition, ip) %>%
  summarize(performance = mean(correct, na.rm = TRUE), .groups = 'drop') %>%
  aov(performance ~ recency_bin * list_order_condition, data = .)

interaction_aov_summary <- tidy(interaction_aov)

# ================================================================================
# SAVE ANALYSIS RESULTS
# ================================================================================

# Save all analysis results
write_csv(exposure_performance, "exposure_history_performance.csv")
write_csv(recency_performance, "recency_effects_performance.csv")
write_csv(list_order_performance, "list_order_knowledge_performance.csv")
write_csv(recency_order_interaction, "recency_order_interaction.csv")

# Save statistical test results
write_csv(exposure_aov_summary, "exposure_history_anova.csv")
write_csv(list_order_aov_summary, "list_order_anova.csv")
write_csv(interaction_aov_summary, "recency_order_interaction_anova.csv")
write_csv(recency_trend_test, "recency_trend_analysis.csv")

# ================================================================================
# CREATE VISUALIZATION PLOTS
# ================================================================================

# Plot 1: Exposure History Main Effects
plot1 <- ggplot(exposure_performance, aes(x = exposure_history, y = mean_performance)) +
  geom_col(fill = "steelblue", alpha = 0.7) +
  geom_errorbar(aes(ymin = mean_performance - se_performance,
                    ymax = mean_performance + se_performance),
                width = 0.2) +
  geom_text(aes(label = paste0("M=", round(mean_performance, 3))),
            vjust = -0.5, size = 3.5) +
  labs(title = "Recognition Performance by Initial Exposure History",
       x = "Initial Exposure History",
       y = "Mean Recognition Performance",
       caption = "Error bars represent standard error") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot 2: Recency Effects
plot2 <- ggplot(recency_performance, aes(x = recency_bin, y = mean_performance,
                                        color = exposure_history, group = exposure_history)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1.2) +
  geom_errorbar(aes(ymin = mean_performance - se_performance,
                    ymax = mean_performance + se_performance),
                width = 0.1) +
  labs(title = "Recency Effects in Final Recognition by Exposure History",
       x = "Recency (Initial Study Position)",
       y = "Mean Recognition Performance",
       color = "Exposure History") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Plot 3: List Order Knowledge Effects
plot3 <- ggplot(list_order_performance, aes(x = list_order_condition, y = mean_performance,
                                           fill = exposure_history)) +
  geom_col(position = "dodge", alpha = 0.7) +
  geom_errorbar(aes(ymin = mean_performance - se_performance,
                    ymax = mean_performance + se_performance),
                position = position_dodge(width = 0.9), width = 0.2) +
  labs(title = "List Order Knowledge Effects on Recognition Performance",
       x = "List Order Condition",
       y = "Mean Recognition Performance",
       fill = "Exposure History") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Plot 4: Recency × List Order Interaction
plot4 <- ggplot(recency_order_interaction, aes(x = recency_bin, y = mean_performance,
                                              color = list_order_condition, group = list_order_condition)) +
  geom_point(size = 3) +
  geom_line(linewidth = 1.2) +
  geom_errorbar(aes(ymin = mean_performance - se_performance,
                    ymax = mean_performance + se_performance),
                width = 0.1) +
  labs(title = "Recency × List Order Knowledge Interaction",
       x = "Recency (Initial Study Position)",
       y = "Mean Recognition Performance",
       color = "List Order Condition") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save plots
ggsave("exposure_history_performance.png", plot1, width = 10, height = 6, dpi = 300)
ggsave("recency_effects.png", plot2, width = 10, height = 6, dpi = 300)
ggsave("list_order_knowledge_effects.png", plot3, width = 10, height = 6, dpi = 300)
ggsave("recency_order_interaction.png", plot4, width = 10, height = 6, dpi = 300)

# ================================================================================
# PRINT SUMMARY RESULTS
# ================================================================================

cat("\n========================================\n")
cat("CONTEXT KNOWLEDGE MANIPULATION ANALYSIS\n")
cat("========================================\n\n")

cat("1. EXPOSURE HISTORY MAIN EFFECTS:\n")
print(exposure_performance)
cat("\nANOVA Results:\n")
print(exposure_aov_summary)
cat(sprintf("\nEffect size (eta-squared): %.3f\n", exposure_effect_size$Eta2[1]))

cat("\n2. RECENCY EFFECTS ANALYSIS:\n")
print(recency_trend_test)

cat("\n3. LIST ORDER KNOWLEDGE EFFECTS:\n")
print(list_order_performance)
cat("\nANOVA Results:\n")
print(list_order_aov_summary)

cat("\n4. RECENCY × LIST ORDER INTERACTION:\n")
print(interaction_aov_summary)

cat("\n========================================\n")
cat("Analysis completed successfully!\n")
cat("Files created:\n")
cat("• exposure_history_performance.csv\n")
cat("• recency_effects_performance.csv\n")
cat("• list_order_knowledge_performance.csv\n")
cat("• recency_order_interaction.csv\n")
cat("• Statistical test results (CSV files)\n")
cat("• Visualization plots (PNG files)\n")
cat("========================================\n")