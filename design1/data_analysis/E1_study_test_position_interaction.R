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
## E1 Initial Test: Study Position vs Accuracy by Test Position
############################################################

# ===== SHARED CONSTANTS =====
# Colors for test position groups
COLOR_EARLY <- "#2166AC"  # Blue for early test position
COLOR_LATE <- "#E08214"   # Orange for late test position

# Colors for item types (foil vs target)
COLOR_FOIL <- "#E08214"   # Orange for foil
COLOR_TARGET <- "#2166AC" # Blue for target

# Line types
LINETYPE_EARLY <- "solid"
LINETYPE_LATE <- "longdash"
LINETYPE_FOIL <- "dashed"
LINETYPE_TARGET <- "solid"

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
Y_BREAKS <- seq(Y_MIN, Y_MAX, by = 0.05)

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

# Load the preprocessed data - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create data for initial test analysis - following same data processing as original
# We need both study position (prespos) and test position (testpos) together
df_initial_study_test <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  select(prespos, testpos, ip, correct, probetype, rt) %>%
  filter(!(rt < 150 | rt > 3500)) %>%
  # Convert to numeric
  mutate(
    prespos = as.numeric(prespos),
    testpos = as.numeric(testpos)
  ) %>%
  # Filter out missing positions
  filter(!is.na(prespos), !is.na(testpos)) %>%
  # Create test position group: early (<= 10) vs late (> 10)
  mutate(
    test_position_group = case_when(
      testpos <= 10 ~ "Early Test Position (≤10)",
      testpos > 10 ~ "Late Test Position (>10)"
    ),
    test_position_group = factor(test_position_group, 
                                levels = c("Early Test Position (≤10)", "Late Test Position (>10)"))
  ) %>%
  # Calculate accuracy by study position, test position group, and participant
  group_by(prespos, test_position_group, ip, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  # Calculate mean across participants
  group_by(prespos, test_position_group, probetype) %>%
  summarize(
    meancr = mean(meancr1),
    sd = sd(meancr1),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  # Rename for clarity
  rename(study_position = prespos) %>%
  # Map to ST/SO/TO naming convention
  mutate(
    item_type = case_when(
      probetype == "TARGET_foil" ~ "TO",
      probetype == "TARGET_target" ~ "ST",
      TRUE ~ "other"
    ),
    # Assign foils to position 0
    study_position = case_when(
      item_type == "TO" ~ 0,
      TRUE ~ study_position
    ),
    # Create facet variable
    facet_group = case_when(
      item_type == "ST" ~ "ST",
      item_type == "TO" ~ "TO",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c("ST", "TO")),
    facet_group = factor(facet_group, levels = c("ST", "TO"))
  ) %>%
  # Filter to valid item types
  filter(item_type %in% c("ST", "TO")) %>%
  # Create combined grouping variable for ggplot
  mutate(
    group_var = interaction(test_position_group, item_type)
  )

# Create the plot for initial test
initial_plot <- ggplot(
  data = df_initial_study_test,
  aes(x = study_position, y = meancr, group = group_var)
) +
  # Points - use item_type for COLOR, test_position_group for SHAPE
  geom_point(
    aes(color = item_type, shape = test_position_group),
    size = POINT_SIZE,
    alpha = LINE_ALPHA,
    stroke = 2.5
  ) +
  # Lines - use item_type for COLOR, test_position_group for LINETYPE
  geom_line(
    aes(color = item_type, linetype = test_position_group),
    linewidth = LINE_WIDTH,
    alpha = LINE_ALPHA
  ) +
  # Error ribbons - use item_type for fill (conditional)
  {if (SHOW_ERROR_BARS) geom_ribbon(
    aes(ymin = meancr - se, ymax = meancr + se, fill = item_type),
    alpha = RIBBON_ALPHA
  )} +
  # Facet by facet_group
  facet_grid(. ~ facet_group) +
  # Scales
  scale_y_continuous(
    limits = c(Y_MIN, Y_MAX),
    breaks = Y_BREAKS,
    name = ylabsname
  ) +
  scale_x_continuous(
    breaks = X_BREAKS,
    labels = X_LABELS,
    name = xaxisname
  ) +
  scale_color_manual(
    values = c(
      "ST" = "#2166AC",
      "TO" = "#E08214"
    ),
    name = "Item Type"
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "TO" = "#E08214"
    ),
    name = "Item Type"
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤10)" = 15,      # solid square
      "Late Test Position (>10)" = 17       # solid triangle
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤10)" = "solid",
      "Late Test Position (>10)" = "longdash"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = ylabsname,
    title = "E1 Initial Test: Study Position vs Accuracy by Test Position",
    color = "Item Type",
    fill = "Item Type",
    shape = "Test Position",
    linetype = "Test Position"
  ) +
  # Theme
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
    plot.margin = margin(t = 10, r = 10, b = 100, l = 10),
    text = element_text(size = BASE_TEXT_SIZE),
    axis.title = element_text(size = AXIS_TITLE_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE),
    strip.text = element_text(size = BASE_TEXT_SIZE, face = "bold")
  ) +
  guides(
    color = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# Save initial plot
ggsave(
  file.path(DESIGN1_DIR, "E1_initial_study_test_position_interaction.png"),
  initial_plot,
  width = 20,
  height = 11,
  dpi = 300,
  bg = "white"
)

cat("Initial test plot saved as E1_initial_study_test_position_interaction.png\n")

############################################################
## E1 Final Test: Study Position vs Accuracy by Test Position
############################################################

# Create df_initial data to get study and test positions - EXACT COPY FROM ORIGINAL
df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, stimulus_id)

wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id))

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>%  # here get study only
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

# Create lookup table with both study and test positions
initial_positions <- df_initial_all %>%
  pivot_wider(
    names_from = position_type,
    values_from = position,
    names_prefix = "initial_"
  ) %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Create final test data with initial positions - following same processing as original
# First, calculate median testpos for TARGET_nontarget items (needed for splitting)
median_testpos_nontarget <- dfchanged %>%
  filter(task == "finalt_response", probetype == "TARGET_nontarget", !is.na(testpos)) %>%
  pull(testpos) %>%
  median(na.rm = TRUE)

df_final_study_test <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  select(ip, correct, probetype, stimulus_id, rt, testpos) %>%
  # Join with initial positions
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  filter(!(rt < 150 | rt > 3500)) %>%
  filter(!is.na(correct)) %>%
  # Convert to numeric
  mutate(
    initial_prespos = as.numeric(initial_prespos),
    initial_testpos = as.numeric(initial_testpos),
    testpos = as.numeric(testpos)
  ) %>%
  # Categorize item types
  mutate(
    is_target_studied_tested = (probetype == "TARGET_target"),      # Has study AND test positions
    is_target_studied_only = (probetype == "TARGET_nontarget"),    # Has study position, NO test position
    is_target_tested_only = (probetype == "TARGET_foil"),          # Has test position, NO study position
    is_foil = (probetype == "FOIL")                                 # Has neither
  ) %>%
  # Create test position group based on item type
  mutate(
    test_position_group = case_when(
      # TARGET_target: split by initial test position
      is_target_studied_tested & !is.na(initial_testpos) & initial_testpos <= 10 ~ "Early Test Position (≤10)",
      is_target_studied_tested & !is.na(initial_testpos) & initial_testpos > 10 ~ "Late Test Position (>10)",
      # TARGET_nontarget: split by FINAL test position (testpos)
      is_target_studied_only & !is.na(testpos) & testpos <= median_testpos_nontarget ~ "Early Test Position (≤10)",
      is_target_studied_only & !is.na(testpos) & testpos > median_testpos_nontarget ~ "Late Test Position (>10)",
      # TARGET_foil: split by initial test position
      is_target_tested_only & !is.na(initial_testpos) & initial_testpos <= 10 ~ "Early Test Position (≤10)",
      is_target_tested_only & !is.na(initial_testpos) & initial_testpos > 10 ~ "Late Test Position (>10)",
      # FOIL: overall (no test position)
      is_foil ~ "All Test Positions",
      TRUE ~ NA_character_
    ),
    test_position_group = factor(test_position_group,
                                levels = c("Early Test Position (≤10)", "Late Test Position (>10)", "All Test Positions"))
  ) %>%
  # Calculate separately for each item type
  {
    # TARGET_target (studied and tested): by study position and initial test position group
    target_stt_data <- filter(., is_target_studied_tested) %>%
      filter(!is.na(initial_prespos), !is.na(test_position_group)) %>%
      group_by(initial_prespos, test_position_group, ip, probetype) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(initial_prespos, test_position_group, probetype) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      rename(study_position = initial_prespos) %>%
      select(study_position, test_position_group, probetype, meancr, sd, se)
    
    # TARGET_nontarget (studied only): by study position and FINAL test position group
    target_so_data <- filter(., is_target_studied_only) %>%
      filter(!is.na(initial_prespos), !is.na(test_position_group)) %>%
      group_by(initial_prespos, test_position_group, ip, probetype) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(initial_prespos, test_position_group, probetype) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      rename(study_position = initial_prespos) %>%
      select(study_position, test_position_group, probetype, meancr, sd, se)
    
    # TARGET_foil (tested only): no study position, assign to 0, split by initial test position group
    target_to_data <- filter(., is_target_tested_only) %>%
      filter(!is.na(test_position_group)) %>%
      group_by(test_position_group, ip, probetype) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(test_position_group, probetype) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      mutate(study_position = 0) %>%
      select(study_position, test_position_group, probetype, meancr, sd, se)
    
    # FOIL (neither): no positions, assign to 0, overall performance
    foil_data <- filter(., is_foil) %>%
      group_by(ip, probetype) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(probetype) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      mutate(
        study_position = 0,
        test_position_group = "All Test Positions"
      ) %>%
      select(study_position, test_position_group, probetype, meancr, sd, se)
    
    # Combine all
    bind_rows(
      target_stt_data,
      target_so_data,
      target_to_data,
      foil_data
    )
  } %>%
  # Create item_type column with all four categories
  mutate(
    item_type = case_when(
      probetype == "TARGET_target" ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil" ~ "TO",
      probetype == "FOIL" ~ "FF",
      TRUE ~ "other"
    ),
    # Create facet variable to separate base types from confusing foils
    facet_group = case_when(
      item_type == "ST" ~ "ST",
      item_type == "SO" ~ "SO",
      item_type %in% c("TO", "FF") ~ "TO / FF",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c("ST", "SO", "TO", "FF")),
    facet_group = factor(facet_group, levels = c("ST", "SO", "TO / FF"))
  ) %>%
  # Filter to only the four item types
  filter(item_type %in% c("ST", "SO", "TO", "FF")) %>%
  # Create combined grouping variable for ggplot
  mutate(
    group_var = interaction(test_position_group, item_type)
  )

# Create the plot for final test
final_plot <- ggplot(
  data = df_final_study_test,
  aes(x = study_position, y = meancr, group = group_var)
) +
  # Points - use item_type for COLOR, test_position_group for SHAPE
  geom_point(
    aes(color = item_type, shape = test_position_group),
    size = POINT_SIZE,
    alpha = LINE_ALPHA,
    stroke = 2.5
  ) +
  # Lines - use item_type for COLOR, test_position_group for LINETYPE
  geom_line(
    aes(color = item_type, linetype = test_position_group),
    linewidth = LINE_WIDTH,
    alpha = LINE_ALPHA
  ) +
  # Error ribbons - use item_type for fill (conditional)
  {if (SHOW_ERROR_BARS) geom_ribbon(
    aes(ymin = meancr - se, ymax = meancr + se, fill = item_type),
    alpha = RIBBON_ALPHA
  )} +
  # Facet by facet_group to separate ST, SO, TO/FF
  facet_grid(. ~ facet_group) +
  # Scales
  scale_y_continuous(
    limits = c(0.47, 0.98),
    breaks = seq(0.5, 0.95, by = 0.1),
    name = "Hit Rate"
  ) +
  scale_x_continuous(
    breaks = X_BREAKS,
    labels = X_LABELS,
    name = xaxisname
  ) +
  scale_color_manual(
    values = c(
      "ST" = "#2166AC",
      "SO" = "#1A9850",
      "TO" = "#E08214",
      "FF" = "#D73027"
    ),
    name = "Item Type"
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "SO" = "#1A9850",
      "TO" = "#E08214",
      "FF" = "#D73027"
    ),
    name = "Item Type"
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤10)" = 15,      # solid square
      "Late Test Position (>10)" = 17,       # solid triangle
      "All Test Positions" = 4              # cross
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤10)" = "solid",
      "Late Test Position (>10)" = "longdash",
      "All Test Positions" = "dashed"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = "Hit Rate",
    title = "E1 Final Test: Study Position vs Accuracy by Test Position",
    color = "Item Type",
    fill = "Item Type",
    shape = "Test Position",
    linetype = "Test Position"
  ) +
  # Theme
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
    plot.margin = margin(t = 10, r = 10, b = 100, l = 10),
    text = element_text(size = BASE_TEXT_SIZE),
    axis.title = element_text(size = AXIS_TITLE_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE),
    strip.text = element_text(size = BASE_TEXT_SIZE - 2, face = "bold"),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  ) +
  guides(
    color = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# Save final plot
ggsave(
  file.path(DESIGN1_DIR, "E1_final_study_test_position_interaction.png"),
  final_plot,
  width = 24,
  height = 11,
  dpi = 300,
  bg = "white"
)

cat("Final test plot saved as E1_final_study_test_position_interaction.png\n")

############################################################
## Combined Plot: Initial and Final Test Side by Side
############################################################

# Create combined plot
combined_plot <- grid.arrange(
  initial_plot,
  final_plot,
  ncol = 1,
  top = textGrob(
    "E1 Study Position vs Accuracy by Test Position: Initial and Final Test",
    gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold")
  )
)

# Save combined plot
ggsave(
  file.path(DESIGN1_DIR, "E1_study_test_position_interaction_combined.png"),
  combined_plot,
  width = 24,
  height = 22,
  dpi = 300,
  bg = "white"
)

cat("Combined plot saved as E1_study_test_position_interaction_combined.png\n")

