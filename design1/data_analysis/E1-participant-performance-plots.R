library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

# ===== SHARED CONSTANTS =====
# Font sizes
BASE_FONT_SIZE <- 20
TITLE_SIZE <- 20
SUPER_TITLE_SIZE <- 28

# Plot styling
POINT_SIZE <- 1
POINT_ALPHA <- 0.7
POINT_COLOR <- "black"

# Margins and spacing
PLOT_MARGIN_TOP <- 20
PLOT_MARGIN_RIGHT <- 20
PLOT_MARGIN_BOTTOM <- 40
PLOT_MARGIN_LEFT <- 20
TITLE_MARGIN_BOTTOM <- 20

# Panel styling
PANEL_BORDER_WIDTH <- 0.5
PANEL_BACKGROUND <- "white"
PLOT_BACKGROUND <- "white"

# Y-axis limits
Y_MIN <- 0
Y_MAX <- 1

# Load the preprocessed data
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# # A tibble: 1 × 2
#   ip             overall_performance
#   <chr>                        <dbl>
# 1 47.158.129.211               0.523

# 1. INITIAL TEST - Calculate overall performance for each participant
cat("Available tasks:", unique(dfchanged$task), "\n")
cat("Number of rows with pretest_response:", sum(dfchanged$task == "pretest_response", na.rm = TRUE), "\n")

initial_participant_performance <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Initial Test")

cat("Number of participants in initial test:", nrow(initial_participant_performance), "\n")

# 2. FINAL TEST - Calculate overall performance for each participant
cat("Number of rows with finalt_response:", sum(dfchanged$task == "finalt_response", na.rm = TRUE), "\n")

final_participant_performance <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Final Test")

cat("Number of participants in final test:", nrow(final_participant_performance), "\n")

# Check if we have data before proceeding
if (nrow(initial_participant_performance) == 0 && nrow(final_participant_performance) == 0) {
  cat("ERROR: No participant data found for either test. Please check the data.\n")
  quit(save = "no", status = 1)
}

# Combine both datasets
all_participant_performance <- rbind(initial_participant_performance, final_participant_performance)

# Save the data for reference
write_csv(all_participant_performance, "participant_performance_data.csv")
cat("Participant performance data saved to participant_performance_data.csv\n")

# 3. CREATE THE PLOTS

# Create Initial Test plot (only if data exists)
if (nrow(initial_participant_performance) > 0) {
  initial_plot <- ggplot(initial_participant_performance,
                        aes(x = participant_rank, y = overall_performance)) +
  geom_point(size = POINT_SIZE, alpha = POINT_ALPHA, color = POINT_COLOR) +
  # geom_line(alpha = 0.5, color = "black", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered worst to best)",
       y = "Overall Performance",
       title = "E1 Initial Test "
       ) +

  # Set y-axis to show full range
  ylim(Y_MIN, Y_MAX) +

  # Enhanced theme
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = BASE_FONT_SIZE, color = "black"),
    axis.title = element_text(size = BASE_FONT_SIZE, color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = PLOT_BACKGROUND, color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )
} else {
  cat("No initial test data found, skipping initial plot\n")
}

# Create Final Test plot (only if data exists)
if (nrow(final_participant_performance) > 0) {
final_plot <- ggplot(final_participant_performance,
                    aes(x = participant_rank, y = overall_performance)) +
  # geom_point(size = 3, alpha = 0.7, color = "#D73027") +
  geom_point(size = POINT_SIZE, alpha = POINT_ALPHA, color = POINT_COLOR) +
  # geom_line(alpha = 0.5, color = "#D73027", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered worst to best)",
       y = "Overall Performance",
       title = "E1 Final Test "
       ) +

  # Set y-axis to show full range
  ylim(Y_MIN, Y_MAX) +

  # Enhanced theme
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = BASE_FONT_SIZE, color = "black"),
    axis.title = element_text(size = BASE_FONT_SIZE, color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = PLOT_BACKGROUND, color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )
} else {
  cat("No final test data found, skipping final plot\n")
}

# 4. SAVE THE PLOTS

# Save Initial Test plot
# ggsave("E1_initial_participant_performance.png", initial_plot,
      #  width = 10, height = 6, dpi = 300, bg = "white")

# Save Final Test plot
# ggsave("E1_final_participant_performance.png", final_plot,
      #  width = 10, height = 6, dpi = 300, bg = "white")

# Create combined plot using grid.arrange (only if we have plots)
plots_to_combine <- list()
if (exists("initial_plot")) plots_to_combine <- append(plots_to_combine, list(initial_plot))
if (exists("final_plot")) plots_to_combine <- append(plots_to_combine, list(final_plot))

if (length(plots_to_combine) > 0) {
  if (length(plots_to_combine) == 1) {
    combined_plot <- plots_to_combine[[1]]
  } else {
    combined_plot <- grid.arrange(
      plots_to_combine[[1]], plots_to_combine[[2]],
      ncol = 2,
      top = textGrob("E1 Individual Performance", 
                     gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
    )
  }
  
  # Save the combined plot
  ggsave("E1_participant_performance.png", combined_plot, 
         width = 13, height = 6, dpi = 300, bg = "white")
  cat("Combined plot saved as E1_participant_performance.png\n")
} else {
  cat("No plots to combine - no data available\n")
}


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