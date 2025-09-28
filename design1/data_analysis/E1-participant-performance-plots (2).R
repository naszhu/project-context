library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# 1. INITIAL TEST - Calculate overall performance for each participant
initial_participant_performance <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Initial Test")

# 2. FINAL TEST - Calculate overall performance for each participant
final_participant_performance <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Final Test")

# Combine both datasets
all_participant_performance <- rbind(initial_participant_performance, final_participant_performance)

# Save the data for reference
write_csv(all_participant_performance, "participant_performance_data.csv")
cat("Participant performance data saved to participant_performance_data.csv\n")

# 3. CREATE THE PLOTS

# Create Initial Test plot
initial_plot <- ggplot(initial_participant_performance,
                      aes(x = participant_rank, y = overall_performance)) +
  geom_point(size = 3, alpha = 0.7, color = "#2166AC") +
  geom_line(alpha = 0.5, color = "#2166AC", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered from worst to best performance)",
       y = "Overall Performance (Proportion Correct)",
       title = "E1 Initial Test - Individual Participant Performance",
       caption = "Each point represents one participant's overall performance, ordered from lowest to highest") +

  # Set y-axis to show full range
  ylim(0, 1) +

  # Enhanced theme
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 14),
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )

# Create Final Test plot
final_plot <- ggplot(final_participant_performance,
                    aes(x = participant_rank, y = overall_performance)) +
  geom_point(size = 3, alpha = 0.7, color = "#D73027") +
  geom_line(alpha = 0.5, color = "#D73027", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered from worst to best performance)",
       y = "Overall Performance (Proportion Correct)",
       title = "E1 Final Test - Individual Participant Performance",
       caption = "Each point represents one participant's overall performance, ordered from lowest to highest") +

  # Set y-axis to show full range
  ylim(0, 1) +

  # Enhanced theme
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 14),
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )

# 4. SAVE THE PLOTS

# Save Initial Test plot
ggsave("E1_initial_participant_performance.png", initial_plot,
       width = 10, height = 6, dpi = 300, bg = "white")

# Save Final Test plot
ggsave("E1_final_participant_performance.png", final_plot,
       width = 10, height = 6, dpi = 300, bg = "white")

# 5. SUMMARY STATISTICS
cat("\n=== PARTICIPANT PERFORMANCE SUMMARY ===\n")

cat("\nInitial Test Performance:\n")
cat(sprintf("Number of participants: %d\n", nrow(initial_participant_performance)))
cat(sprintf("Mean performance: %.3f\n", mean(initial_participant_performance$overall_performance)))
cat(sprintf("SD performance: %.3f\n", sd(initial_participant_performance$overall_performance)))
cat(sprintf("Range: %.3f - %.3f\n",
    min(initial_participant_performance$overall_performance),
    max(initial_participant_performance$overall_performance)))

cat("\nFinal Test Performance:\n")
cat(sprintf("Number of participants: %d\n", nrow(final_participant_performance)))
cat(sprintf("Mean performance: %.3f\n", mean(final_participant_performance$overall_performance)))
cat(sprintf("SD performance: %.3f\n", sd(final_participant_performance$overall_performance)))
cat(sprintf("Range: %.3f - %.3f\n",
    min(final_participant_performance$overall_performance),
    max(final_participant_performance$overall_performance)))

cat("\n=== PLOTS CREATED SUCCESSFULLY! ===\n")
cat("Files created:\n")
cat("• participant_performance_data.csv - Raw data\n")
cat("• E1_initial_participant_performance.png - Initial test plot\n")
cat("• E1_final_participant_performance.png - Final test plot\n")