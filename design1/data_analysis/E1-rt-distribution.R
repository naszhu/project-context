library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid)
library(gridExtra)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN1_DIR <- file.path(PROJECT_ROOT, "design1")
DATA_ANALYSIS_DIR <- file.path(DESIGN1_DIR, "data_analysis")
RT_RESULTS_DIR <- file.path(DATA_ANALYSIS_DIR, "rt_results")

# Create rt_results directory if it doesn't exist
if (!dir.exists(RT_RESULTS_DIR)) {
  dir.create(RT_RESULTS_DIR, recursive = TRUE)
  cat("Created rt_results directory\n")
}

############################################################
## Constants for styling - UNIFIED FORMATTING
############################################################
BASE_FONT_SIZE <- 24
TITLE_SIZE <- BASE_FONT_SIZE + 6
STRIP_TEXT_SIZE <- BASE_FONT_SIZE + 4
AXIS_TITLE_SIZE <- BASE_FONT_SIZE + 6
AXIS_TEXT_SIZE <- BASE_FONT_SIZE
CAPTION_SIZE <- 15

# Margins and spacing
PLOT_MARGIN_TOP <- 15
PLOT_MARGIN_RIGHT <- 15
PLOT_MARGIN_BOTTOM <- 70
PLOT_MARGIN_LEFT <- 15
TITLE_MARGIN_BOTTOM <- 20
CAPTION_MARGIN_TOP <- 20

# Grid and panel styling
PANEL_BORDER_WIDTH <- 0.5
PANEL_BACKGROUND <- "white"
STRIP_BACKGROUND <- "white"
STRIP_BORDER_WIDTH <- 1

# Density plot styling
DENSITY_ALPHA <- 0.6
DENSITY_LINE_WIDTH <- 1.5

# Colors (matching the original file)
COLOR_FOIL <- "#E08214"
COLOR_TARGET <- "#2166AC"
COLOR_TARGET_FOIL <- "#E08214"
COLOR_TARGET_NONTARGET <- "#1A9850"
COLOR_TARGET_TARGET <- "#2166AC"
COLOR_FOIL_REJECTION <- "#D73027"

############################################################
## Load Data
############################################################
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

############################################################
## E1 Initial Test Accuracy Distribution
############################################################

# Prepare initial test data - Calculate PARTICIPANT MEANS first
df_initial_acc <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  mutate(correct = as.numeric(correct)) %>%
  filter(!is.na(correct)) %>%
  # Rename probetype to match plotting conventions
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil - Correct rejection",
    probetype == "TARGET_target" ~ "Target - Hits",
    probetype == "FOIL" ~ "Foil - Correct rejection",
    TRUE ~ probetype
  )) %>%
  filter(!is.na(probetype)) %>%
  # GROUP BY PARTICIPANT AND PROBETYPE, THEN CALCULATE MEAN ACCURACY
  group_by(ip, probetype) %>%
  summarize(
    mean_accuracy = mean(correct, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nInitial Test Accuracy Distribution Data:\n")
cat(sprintf("Total participants: %d\n", length(unique(df_initial_acc$ip))))
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_initial_acc)))
cat(sprintf("Probetype breakdown:\n"))
print(table(df_initial_acc$probetype))

# Create initial test distribution plot - using participant mean accuracy
initial_dist_plot <- ggplot(df_initial_acc, aes(x = mean_accuracy, fill = probetype, color = probetype)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "E1 Initial Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Foil - Correct rejection" = COLOR_FOIL_REJECTION,
    "Target - Hits" = COLOR_TARGET
  )) +
  scale_color_manual(values = c(
    "Foil - Correct rejection" = COLOR_FOIL_REJECTION,
    "Target - Hits" = COLOR_TARGET
  )) +
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = BASE_FONT_SIZE, margin = margin(b = 5)),
    legend.text = element_text(size = BASE_FONT_SIZE - 2),
    legend.key.width = unit(2.0, "cm"),
    legend.key.height = unit(1.0, "cm"),
    legend.margin = margin(t = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save initial test distribution plot
ggsave(file.path(RT_RESULTS_DIR, "E1_initial_accuracy_distribution.png"), 
       initial_dist_plot, width = 12, height = 8, dpi = 300, bg = "white")
cat("Saved E1_initial_accuracy_distribution.png\n")

############################################################
## E1 Final Test Accuracy Distribution
############################################################

# Prepare final test data - Calculate PARTICIPANT MEANS first
df_final_acc <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  mutate(correct = as.numeric(correct)) %>%
  filter(!is.na(correct)) %>%
  # Rename probetype to match plotting conventions
  mutate(probetype = case_when(
    probetype == "FOIL" ~ "Foil - Correct rejection",
    probetype == "TARGET_foil" ~ "TARGET_foil - Hits",
    probetype == "TARGET_nontarget" ~ "TARGET_nontarget - Hits",
    probetype == "TARGET_target" ~ "TARGET_target - Hits",
    TRUE ~ probetype
  )) %>%
  filter(!is.na(probetype)) %>%
  # GROUP BY PARTICIPANT AND PROBETYPE, THEN CALCULATE MEAN ACCURACY
  group_by(ip, probetype) %>%
  summarize(
    mean_accuracy = mean(correct, na.rm = TRUE),
    .groups = 'drop'
  )

cat("\nFinal Test Accuracy Distribution Data:\n")
cat(sprintf("Total participants: %d\n", length(unique(df_final_acc$ip))))
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_final_acc)))
cat(sprintf("Probetype breakdown:\n"))
print(table(df_final_acc$probetype))

# Create final test distribution plot - using participant mean accuracy
final_dist_plot <- ggplot(df_final_acc, aes(x = mean_accuracy, fill = probetype, color = probetype)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "E1 Final Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Foil - Correct rejection" = COLOR_FOIL_REJECTION,
    "TARGET_foil - Hits" = COLOR_TARGET_FOIL,
    "TARGET_nontarget - Hits" = COLOR_TARGET_NONTARGET,
    "TARGET_target - Hits" = COLOR_TARGET_TARGET
  )) +
  scale_color_manual(values = c(
    "Foil - Correct rejection" = COLOR_FOIL_REJECTION,
    "TARGET_foil - Hits" = COLOR_TARGET_FOIL,
    "TARGET_nontarget - Hits" = COLOR_TARGET_NONTARGET,
    "TARGET_target - Hits" = COLOR_TARGET_TARGET
  )) +
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = BASE_FONT_SIZE, margin = margin(b = 5)),
    legend.text = element_text(size = BASE_FONT_SIZE - 2),
    legend.key.width = unit(2.0, "cm"),
    legend.key.height = unit(1.0, "cm"),
    legend.margin = margin(t = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save final test distribution plot
ggsave(file.path(RT_RESULTS_DIR, "E1_final_accuracy_distribution.png"), 
       final_dist_plot, width = 12, height = 8, dpi = 300, bg = "white")
cat("Saved E1_final_accuracy_distribution.png\n")

############################################################
## Combined Initial and Final Test Accuracy Distribution
############################################################

# Combine data for comparison - using participant mean accuracy
df_combined_acc <- rbind(
  df_initial_acc %>% mutate(test_type = "Initial Test") %>% select(mean_accuracy, test_type, probetype),
  df_final_acc %>% mutate(test_type = "Final Test") %>% select(mean_accuracy, test_type, probetype)
)

# Simplify probetype for combined plot (merge similar types)
df_combined_acc <- df_combined_acc %>%
  mutate(probetype_simple = case_when(
    probetype == "Foil - Correct rejection" ~ "Foil",
    probetype == "Target - Hits" ~ "Target",
    probetype == "TARGET_foil - Hits" ~ "Target",
    probetype == "TARGET_nontarget - Hits" ~ "Target",
    probetype == "TARGET_target - Hits" ~ "Target",
    TRUE ~ probetype
  ))

# Create combined distribution plot - using participant mean accuracy
combined_dist_plot <- ggplot(df_combined_acc, aes(x = mean_accuracy, fill = probetype_simple, color = probetype_simple)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  facet_grid(. ~ test_type) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "E1 Initial vs Final Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Foil" = COLOR_FOIL_REJECTION,
    "Target" = COLOR_TARGET
  )) +
  scale_color_manual(values = c(
    "Foil" = COLOR_FOIL_REJECTION,
    "Target" = COLOR_TARGET
  )) +
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = BASE_FONT_SIZE, margin = margin(b = 5)),
    legend.text = element_text(size = BASE_FONT_SIZE - 2),
    legend.key.width = unit(2.0, "cm"),
    legend.key.height = unit(1.0, "cm"),
    legend.margin = margin(t = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = "black", linewidth = STRIP_BORDER_WIDTH),
    strip.text = element_text(face = "bold", size = STRIP_TEXT_SIZE)
  )

# Save combined distribution plot
ggsave(file.path(RT_RESULTS_DIR, "E1_combined_accuracy_distribution.png"), 
       combined_dist_plot, width = 16, height = 8, dpi = 300, bg = "white")
cat("Saved E1_combined_accuracy_distribution.png\n")

############################################################
## Summary Statistics
############################################################
cat("\n=== ACCURACY DISTRIBUTION SUMMARY STATISTICS ===\n")

cat("\nInitial Test Accuracy:\n")
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_initial_acc)))
cat(sprintf("Mean Accuracy: %.3f\n", mean(df_initial_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Median Accuracy: %.3f\n", median(df_initial_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("SD Accuracy: %.3f\n", sd(df_initial_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Min Accuracy: %.3f\n", min(df_initial_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Max Accuracy: %.3f\n", max(df_initial_acc$mean_accuracy, na.rm = TRUE)))

cat("\nFinal Test Accuracy:\n")
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_final_acc)))
cat(sprintf("Mean Accuracy: %.3f\n", mean(df_final_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Median Accuracy: %.3f\n", median(df_final_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("SD Accuracy: %.3f\n", sd(df_final_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Min Accuracy: %.3f\n", min(df_final_acc$mean_accuracy, na.rm = TRUE)))
cat(sprintf("Max Accuracy: %.3f\n", max(df_final_acc$mean_accuracy, na.rm = TRUE)))

cat("\n=== ACCURACY DISTRIBUTION PLOTS CREATED SUCCESSFULLY! ===\n")
cat("Files created in rt_results folder:\n")
cat("• E1_initial_accuracy_distribution.png - Initial Test Accuracy Distribution\n")
cat("• E1_final_accuracy_distribution.png - Final Test Accuracy Distribution\n")
cat("• E1_combined_accuracy_distribution.png - Combined Initial vs Final Test Accuracy Distribution\n")

