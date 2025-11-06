library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid)
library(gridExtra)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN3_DIR <- file.path(PROJECT_ROOT, "design3")
DATA_DIR <- file.path(DESIGN3_DIR, "data")
DATA_ANALYSIS_DIR <- file.path(DESIGN3_DIR, "data_analysis")
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

############################################################
## Load Data
############################################################
df_rt_pl <- read_csv(file.path(DATA_DIR, "E3_AGGREGATED.csv")) %>%
  mutate(rt = as.numeric(rt))
cat("Loaded aggregated data from E3_AGGREGATED.csv\n")

############################################################
## E3 Initial Test Accuracy Distribution
############################################################

# Prepare initial test data - Calculate PARTICIPANT MEANS first
df_initial_acc <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  mutate(correct = as.numeric(correct)) %>%
  filter(!is.na(correct)) %>%
  filter(!is.na(typecomment_in)) %>%
  # GROUP BY PARTICIPANT AND PROBETYPE, THEN CALCULATE MEAN ACCURACY
  group_by(subject_id, typecomment_in) %>%
  summarize(
    mean_accuracy = mean(correct, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  rename(probetype = typecomment_in)

cat("\nInitial Test Accuracy Distribution Data:\n")
cat(sprintf("Total participants: %d\n", length(unique(df_initial_acc$subject_id))))
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_initial_acc)))
cat(sprintf("Probetype breakdown:\n"))
print(table(df_initial_acc$probetype))

# Create initial test distribution plot - using participant mean accuracy
initial_dist_plot <- ggplot(df_initial_acc, aes(x = mean_accuracy, fill = probetype, color = probetype)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "Exp. 2 Initial Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Inherented Foil - Last Foil" = "#E08214",
    "Inherented Foil - Last Studied Only" = "#1A9850",
    "Inherented Foil - Last Target" = "#2166AC",
    "New Foil" = "#E08214",
    "Target" = "#2166AC"
  )) +
  scale_color_manual(values = c(
    "Inherented Foil - Last Foil" = "#E08214",
    "Inherented Foil - Last Studied Only" = "#1A9850",
    "Inherented Foil - Last Target" = "#2166AC",
    "New Foil" = "#E08214",
    "Target" = "#2166AC"
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
ggsave(file.path(RT_RESULTS_DIR, "E3_initial_accuracy_distribution.png"), 
       initial_dist_plot, width = 12, height = 8, dpi = 300, bg = "white")
cat("Saved E3_initial_accuracy_distribution.png\n")

############################################################
## E3 Final Test Accuracy Distribution
############################################################

# Prepare final test data - Calculate PARTICIPANT MEANS first
df_final_acc <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  mutate(correct = case_when(
    correct == "True" ~ 1,
    correct == "False" ~ 0,
    TRUE ~ as.numeric(correct)
  )) %>%
  filter(!is.na(correct)) %>%
  filter(!is.na(type_comment_fn)) %>%
  # GROUP BY PARTICIPANT AND PROBETYPE, THEN CALCULATE MEAN ACCURACY
  group_by(subject_id, type_comment_fn) %>%
  summarize(
    mean_accuracy = mean(correct, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  rename(probetype = type_comment_fn)

cat("\nFinal Test Accuracy Distribution Data:\n")
cat(sprintf("Total participants: %d\n", length(unique(df_final_acc$subject_id))))
cat(sprintf("Participant-probetype combinations: %d\n", nrow(df_final_acc)))
cat(sprintf("Probetype breakdown:\n"))
print(table(df_final_acc$probetype))

# Create final test distribution plot - using participant mean accuracy
final_dist_plot <- ggplot(df_final_acc, aes(x = mean_accuracy, fill = probetype, color = probetype)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "Exp. 2 Final Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
  )) +
  scale_color_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
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
ggsave(file.path(RT_RESULTS_DIR, "E3_final_accuracy_distribution.png"), 
       final_dist_plot, width = 12, height = 8, dpi = 300, bg = "white")
cat("Saved E3_final_accuracy_distribution.png\n")

############################################################
## Combined Initial and Final Test Accuracy Distribution
############################################################

# Combine data for comparison - using participant mean accuracy
df_combined_acc <- rbind(
  df_initial_acc %>% 
    mutate(test_type = "Initial Test") %>% 
    mutate(probetype_simple = case_when(
      probetype == "Target" ~ "Target",
      probetype == "New Foil" ~ "Foil",
      probetype == "Inherented Foil - Last Foil" ~ "Foil",
      probetype == "Inherented Foil - Last Target" ~ "Foil",
      probetype == "Inherented Foil - Last Studied Only" ~ "Foil",
      TRUE ~ probetype
    )) %>%
    select(mean_accuracy, test_type, probetype_simple),
  df_final_acc %>% 
    mutate(test_type = "Final Test") %>% 
    mutate(probetype_simple = case_when(
      probetype == "Target: studied and tested at (n), Foil (n+1)" ~ "Target",
      probetype == "Target: : started and tested at (n) ; Appear once" ~ "Target",
      probetype == "Studied-only (n); Foil (n+1)" ~ "Target",
      probetype == "Studied-only (n); Appear once" ~ "Target",
      probetype == "Foil(n), Foil (n+1)" ~ "Foil",
      probetype == "Foil(n); Appear once" ~ "Foil",
      probetype == "Final Foil" ~ "Foil",
      TRUE ~ probetype
    )) %>%
    select(mean_accuracy, test_type, probetype_simple)
)

# Create combined distribution plot - using participant mean accuracy
combined_dist_plot <- ggplot(df_combined_acc, aes(x = mean_accuracy, fill = probetype_simple, color = probetype_simple)) +
  geom_density(alpha = DENSITY_ALPHA, linewidth = DENSITY_LINE_WIDTH) +
  facet_grid(. ~ test_type) +
  labs(
    x = "Accuracy",
    y = "Density",
    title = "Exp. 2 Initial vs Final Test Accuracy Distribution",
    fill = "Type",
    color = "Type"
  ) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_fill_manual(values = c(
    "Foil" = "#E08214",
    "Target" = "#2166AC"
  )) +
  scale_color_manual(values = c(
    "Foil" = "#E08214",
    "Target" = "#2166AC"
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
ggsave(file.path(RT_RESULTS_DIR, "E3_combined_accuracy_distribution.png"), 
       combined_dist_plot, width = 16, height = 8, dpi = 300, bg = "white")
cat("Saved E3_combined_accuracy_distribution.png\n")

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
cat("• E3_initial_accuracy_distribution.png - Initial Test Accuracy Distribution\n")
cat("• E3_final_accuracy_distribution.png - Final Test Accuracy Distribution\n")
cat("• E3_combined_accuracy_distribution.png - Combined Initial vs Final Test Accuracy Distribution\n")

