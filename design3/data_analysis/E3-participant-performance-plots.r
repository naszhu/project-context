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
TITLE_SIZE <- 25
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

# Load the aggregated data
df_rt_pl <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")
cat("Loaded aggregated data from E3_AGGREGATED.csv\n")

# 1. INITIAL TEST - Calculate overall performance for each participant
initial_participant_performance <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  group_by(subject_id) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Initial Test") %>%
  filter(overall_performance > 0.53)  # Apply same filter as E1

# 2. FINAL TEST - Calculate overall performance for each participant
final_participant_performance <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  # Handle mixed case correct values
  mutate(correct = case_when(correct == "True" ~ 1,
                            correct == "False" ~ 0,
                            TRUE ~ correct)) %>%
  group_by(subject_id) %>%
  summarize(overall_performance = mean(correct, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(overall_performance) %>%
  mutate(participant_rank = row_number(),
         test_type = "Final Test")

# Combine both datasets
all_participant_performance <- rbind(initial_participant_performance, final_participant_performance)

# Save the data for reference
write_csv(all_participant_performance, "participant_performance_data_e3.csv")
cat("Participant performance data saved to participant_performance_data_e3.csv\n")

# 3. CREATE THE PLOTS

# Create Initial Test plot
initial_plot <- ggplot(initial_participant_performance,
                      aes(x = participant_rank, y = overall_performance)) +
  geom_point(size = POINT_SIZE, alpha = POINT_ALPHA, color = POINT_COLOR) +
  # geom_line(alpha = 0.5, color = "black", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered worst to best)",
       y = "Overall Performance",
       title = "E2 Initial Test "
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
    panel.grid = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = PLOT_BACKGROUND, color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )

# Create Final Test plot
final_plot <- ggplot(final_participant_performance,
                    aes(x = participant_rank, y = overall_performance)) +
  # geom_point(size = 3, alpha = 0.7, color = "#D73027") +
  geom_point(size = POINT_SIZE, alpha = POINT_ALPHA, color = POINT_COLOR) +
  # geom_line(alpha = 0.5, color = "#D73027", linewidth = 0.8) +

  # Styling and labels
  labs(x = "Participant (ordered worst to best)",
       y = "Overall Performance",
       title = "E2 Final Test "
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
    panel.grid = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = PLOT_BACKGROUND, color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    axis.text.x = element_blank(),  # Remove participant labels for anonymity
    axis.ticks.x = element_line(color = "black")  # Keep tick marks
  )

# 4. SAVE THE PLOTS

# Save Initial Test plot
# ggsave("E3_initial_participant_performance.png", initial_plot,
#        width = 10, height = 6, dpi = 300, bg = "white")

# Save Final Test plot
# ggsave("E3_final_participant_performance.png", final_plot,
#        width = 10, height = 6, dpi = 300, bg = "white")

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  initial_plot, final_plot,
  ncol = 2,
  top = textGrob("E2 Individual Performance",
                 gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
)

# Save the combined plot
ggsave("E3_participant_performance.png", combined_plot,
       width = 13, height = 6, dpi = 300, bg = "white")

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
cat("• participant_performance_data_e3.csv - Raw data\n")
cat("• E3_participant_performance.png - Combined plot with both tests\n")