library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid)
library(gridExtra)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN1_DIR <- file.path(PROJECT_ROOT, "design1")
DATA_ANALYSIS_DIR <- file.path(DESIGN1_DIR, "data_analysis")

############################################################
## E1 Lag Plot: Test Position - Study Position
############################################################

# ===== SHARED CONSTANTS =====
ylabsname <- "Correct Response Rate"
xaxisname <- "Study Position"

# Sizes
BASE_FONT_SIZE <- 32
POINT_SIZE <- 6.5
LINE_WIDTH <- 2.2
RIBBON_ALPHA <- 0.25
LINE_ALPHA <- 0.85

# Flag to control error bars
SHOW_ERROR_BARS <- FALSE

# Y-axis limits and breaks
Y_MIN <- 0.70
Y_MAX <- 1.00
Y_BREAKS <- seq(0.7, 1.0, by = 0.05)

# X-axis breaks
X_BREAKS <- seq(0, 20, by = 5)
X_LABELS <- as.character(X_BREAKS)

# Theme settings
BASE_TEXT_SIZE <- 32
TITLE_SIZE <- BASE_FONT_SIZE + 3
SUPER_TITLE_SIZE <- TITLE_SIZE + 5
AXIS_TITLE_SIZE <- 32
AXIS_TEXT_SIZE <- 30
LEGEND_POSITION <- "bottom"

# Load the preprocessed data
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data\n")

# Create lookup table for initial positions (needed for final test lag calculation)
# Get initial test items
df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(ip, stimulus_id, prespos, testpos) %>%
  mutate(
    initial_prespos = as.numeric(prespos),
    initial_testpos = as.numeric(testpos)
  ) %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Get initial study-only items (studied but not tested in initial test)
wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id))

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>%
  mutate(
    initial_prespos = as.numeric(prespos),
    initial_testpos = NA_real_
  ) %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Combine to create lookup table
initial_positions <- bind_rows(df_initial, df_initial_study) %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

############################################################
## Lag Plot Data
############################################################

# Create lag plot data for initial test
df_initial_lag <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    study_position = as.numeric(prespos),
    test_position = as.numeric(testpos),
    correct = as.numeric(correct),
    # Map to ST/SO/TO naming convention
    item_type = case_when(
      probetype == "TARGET_target" ~ "ST",
      probetype == "TARGET_foil" ~ "TO",
      TRUE ~ "other"
    ),
    # Calculate lag = test position - study position
    lag = test_position - study_position
  ) %>%
  filter(item_type != "other", !is.na(lag), !is.na(study_position), !is.na(test_position)) %>%
  # Calculate accuracy by lag and participant
  group_by(lag, ip, item_type) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  # Calculate mean across participants
  group_by(lag, item_type) %>%
  summarize(
    meancr = mean(meancr1),
    sd = sd(meancr1),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(
    test_type = "Initial Test",
    facet_group = case_when(
      item_type == "ST" ~ "ST",
      item_type == "TO" ~ "TO",
      TRUE ~ "other"
    ),
    facet_group = factor(facet_group, levels = c("ST", "TO"))
  ) %>%
  filter(facet_group != "other")

# Create lag plot data for final test
# Use INITIAL test positions, not final test positions!
df_final_lag <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  mutate(
    correct = as.numeric(correct),
    # Map to ST/SO/TO naming convention (exclude FF as it has no initial positions)
    item_type = case_when(
      probetype == "TARGET_target" ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil" ~ "TO",
      TRUE ~ "other"
    ),
    # Calculate lag using INITIAL positions only
    lag = case_when(
      # ST: lag = initial_testpos - initial_prespos
      item_type == "ST" & 
      !is.na(initial_testpos) & !is.na(initial_prespos) & 
      initial_testpos > 0 & initial_prespos > 0 ~ 
      initial_testpos - initial_prespos,
      # SO: lag = initial_testpos - initial_prespos (use initial positions!)
      item_type == "SO" & 
      !is.na(initial_testpos) & !is.na(initial_prespos) & 
      initial_testpos > 0 & initial_prespos > 0 ~ 
      initial_testpos - initial_prespos,
      # TO: lag = initial_testpos - 0 (they weren't studied initially)
      item_type == "TO" & 
      !is.na(initial_testpos) & initial_testpos > 0 ~ 
      initial_testpos - 0,
      TRUE ~ NA_real_
    )
  ) %>%
  filter(item_type != "other", !is.na(lag)) %>%
  group_by(lag, ip, item_type) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(lag, item_type) %>%
  summarize(
    meancr = mean(meancr1),
    sd = sd(meancr1),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(
    test_type = "Final Test",
    facet_group = case_when(
      item_type == "ST" ~ "ST",
      item_type == "SO" ~ "SO",
      item_type == "TO" ~ "TO",
      TRUE ~ "other"
    ),
    facet_group = factor(facet_group, levels = c("ST", "SO", "TO"))
  ) %>%
  filter(facet_group != "other")

# Combine initial and final lag data
df_lag_combined <- bind_rows(df_initial_lag, df_final_lag) %>%
  mutate(
    item_type = factor(item_type, levels = c("ST", "SO", "TO")),
    test_type = factor(test_type, levels = c("Initial Test", "Final Test")),
    group_var = interaction(item_type, test_type)
  )

# Create lag plot
lag_plot <- ggplot(
  data = df_lag_combined,
  aes(x = lag, y = meancr, group = group_var)
) +
  geom_line(aes(color = item_type, linetype = test_type), linewidth = LINE_WIDTH, alpha = LINE_ALPHA) +
  geom_point(aes(color = item_type, shape = test_type), size = 2.5, alpha = LINE_ALPHA, stroke = 1.5) +
  {if (SHOW_ERROR_BARS) geom_ribbon(
    aes(ymin = meancr - se, ymax = meancr + se, fill = item_type),
    alpha = RIBBON_ALPHA
  )} +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.5) +
  facet_grid(test_type ~ facet_group) +
  scale_color_manual(
    values = c(
      "ST" = "#2166AC",
      "SO" = "#1A9850",
      "TO" = "#E08214"
    ),
    name = "Item Type"
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "SO" = "#1A9850",
      "TO" = "#E08214"
    ),
    name = "Item Type"
  ) +
  scale_shape_manual(
    values = c(
      "Initial Test" = 15,
      "Final Test" = 17
    ),
    name = "Test Type"
  ) +
  scale_linetype_manual(
    values = c(
      "Initial Test" = "solid",
      "Final Test" = "longdash"
    ),
    name = "Test Type"
  ) +
  scale_y_continuous(
    limits = c(Y_MIN, Y_MAX),
    breaks = Y_BREAKS,
    name = "Mean Accuracy"
  ) +
  scale_x_continuous(
    name = "Lag (Test Position - Study Position)"
  ) +
  labs(
    title = "E1 Lag Plot: Accuracy vs Temporal Distance Between Study and Test",
    x = "Lag (Test Position - Study Position)",
    y = "Mean Accuracy",
    color = "Item Type",
    fill = "Item Type",
    shape = "Test Type",
    linetype = "Test Type"
  ) +
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.title = element_text(hjust = 0.5, size = TITLE_SIZE, face = "bold"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = LEGEND_POSITION,
    legend.title = element_text(size = BASE_TEXT_SIZE - 4, face = "bold"),
    legend.text = element_text(size = BASE_TEXT_SIZE - 6),
    legend.key.width = unit(1.5, "cm"),
    legend.key.height = unit(0.8, "cm"),
    legend.spacing.y = unit(0.3, "cm"),
    legend.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.margin = margin(t = 10, r = 10, b = 80, l = 10),
    text = element_text(size = BASE_TEXT_SIZE),
    axis.title = element_text(size = AXIS_TITLE_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE),
    strip.text = element_text(size = BASE_TEXT_SIZE - 2, face = "bold"),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  ) +
  guides(
    color = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 1, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 1, byrow = TRUE, title.position = "top")
  )

# Save lag plot
ggsave(
  file.path(DESIGN1_DIR, "E1_study_test_position_interaction_with_lag.png"),
  lag_plot,
  width = 24,
  height = 11,
  dpi = 300,
  bg = "white"
)

cat("Lag plot saved as E1_study_test_position_interaction_with_lag.png\n")






