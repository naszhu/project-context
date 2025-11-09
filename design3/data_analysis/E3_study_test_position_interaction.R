library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid)
library(gridExtra)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN3_DIR <- file.path(PROJECT_ROOT, "design3")
DATA_ANALYSIS_DIR <- file.path(DESIGN3_DIR, "data_analysis")
DATA_DIR <- file.path(DESIGN3_DIR, "data")

############################################################
## E3 Initial Test: Study Position vs Accuracy by Test Position
############################################################

# ===== SHARED CONSTANTS =====
# Colors for test position groups
COLOR_EARLY <- "#2166AC"  # Blue for early test position
COLOR_LATE <- "#E08214"   # Orange for late test position

# Line types
LINETYPE_EARLY <- "solid"
LINETYPE_LATE <- "longdash"

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
Y_MIN <- 0.44
Y_MAX <- 0.9
Y_BREAKS <- seq(0.4, 0.9, by = 0.1)

# X-axis breaks
X_BREAKS <- seq(0, 10, by = 1)
X_LABELS <- as.character(X_BREAKS)

# Theme settings
BASE_TEXT_SIZE <- 36
TITLE_SIZE <- BASE_FONT_SIZE + 3
SUPER_TITLE_SIZE <- TITLE_SIZE + 5
AXIS_TITLE_SIZE <- 36
AXIS_TEXT_SIZE <- 34
LEGEND_POSITION <- "bottom"

# Load the preprocessed data
df_rt_pl <- read_csv(file.path(DATA_DIR, "E3_AGGREGATED.csv"))
cat("Loaded E3_AGGREGATED data\n")

# Create data for initial test analysis
# We need both study position and test position together
df_initial_study_test <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  mutate(
    type_comment = typecomment_in,
    testPos_appear0_initial = as.numeric(testPos_appear0_initial),
    testPos_appear0_initial = ceiling(testPos_appear0_initial / 3),
    # Handle study position - some types use alternate position
    study_pos_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_pos_choice = case_when(
      type_comment %in% c(
        "Inherented Foil - Last Studied Only",
        "Inherented Foil - Last Target"
      ) & !is.na(study_pos_alternate) & study_pos_alternate > 0 ~ study_pos_alternate,
      TRUE ~ study_pos_primary
    ),
    study_pos_choice = ceiling(study_pos_choice / 3),
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    )
  ) %>%
  # Filter out missing positions
  filter(!is.na(study_pos_choice), !is.na(testPos_appear0_initial)) %>%
  # Create test position group: early (<= 5) vs late (> 5) - using median split
  mutate(
    test_position_group = case_when(
      testPos_appear0_initial <= 5 ~ "Early Test Position (≤5)",
      testPos_appear0_initial > 5 ~ "Late Test Position (>5)"
    ),
    test_position_group = factor(test_position_group,
                                levels = c("Early Test Position (≤5)", "Late Test Position (>5)"))
  ) %>%
  # Calculate accuracy by study position, test position group, and participant
  group_by(study_pos_choice, test_position_group, subject_id, type_comment) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  # Calculate mean across participants
  group_by(study_pos_choice, test_position_group, type_comment) %>%
  summarize(
    meancr = mean(meancr1),
    sd = sd(meancr1),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  # Rename for clarity
  rename(study_position = study_pos_choice) %>%
  # Map to ST/SO/TO naming convention
  mutate(
    # Assign foils without study position to position 0
    study_position = case_when(
      is.na(study_position) | study_position == 0 ~ 0,
      TRUE ~ study_position
    ),
    # Map to ST/SO/TO convention
    item_type = case_when(
      type_comment == "Target" ~ "ST",
      type_comment == "New Foil" ~ "TO",
      type_comment == "Inherented Foil - Last Foil" ~ "TO(n)",
      type_comment == "Inherented Foil - Last Target" ~ "ST(n)",
      type_comment == "Inherented Foil - Last Studied Only" ~ "SO(n)",
      TRUE ~ "other"
    ),
    # Create facet variable
    facet_group = case_when(
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO(n)") ~ "SO(n)",
      item_type %in% c("TO", "TO(n)") ~ "TO / TO(n)",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c("ST", "ST(n)", "SO(n)", "TO", "TO(n)")),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO(n)", "TO / TO(n)"))
  ) %>%
  # Filter to valid item types
  filter(item_type != "other") %>%
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
      "ST(n)" = "#4393C3",
      "SO(n)" = "#66BD63",
      "TO" = "#E08214",
      "TO(n)" = "#F4A582"
    ),
    name = "Item Type"
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "ST(n)" = "#4393C3",
      "SO(n)" = "#66BD63",
      "TO" = "#E08214",
      "TO(n)" = "#F4A582"
    ),
    name = "Item Type"
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤5)" = 15,      # solid square
      "Late Test Position (>5)" = 17        # solid triangle
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤5)" = "solid",
      "Late Test Position (>5)" = "longdash"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = ylabsname,
    title = "E3 Initial Test: Study Position vs Accuracy by Test Position",
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
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# Save initial plot
ggsave(
  file.path(DESIGN3_DIR, "E3_initial_study_test_position_interaction.png"),
  initial_plot,
  width = 24,
  height = 11,
  dpi = 300,
  bg = "white"
)

cat("Initial test plot saved as E3_initial_study_test_position_interaction.png\n")

############################################################
## E3 Final Test: Study Position vs Accuracy by Test Position
############################################################

# Get all final test item types
levelsStr_fn <- levels(as.factor(df_rt_pl$type_comment_fn))
cat("Final test item types:", paste(levelsStr_fn, collapse = ", "), "\n")

# Calculate median test position for splitting (needed for items without initial test positions)
# Use items that actually have test positions
median_testpos_final <- df_rt_pl %>%
  filter(task == "finalTest", !is.na(testPos_appear1_initial)) %>%
  mutate(testPos_appear1_initial = ceiling(as.numeric(testPos_appear1_initial) / 3)) %>%
  filter(testPos_appear1_initial > 0) %>%
  pull(testPos_appear1_initial) %>%
  median(na.rm = TRUE)

# If median is still 0 or NA, use a fixed split point
if (is.na(median_testpos_final) || median_testpos_final == 0) {
  median_testpos_final <- 5  # Use middle of 0-10 range
}

cat("Median test position (grouped):", median_testpos_final, "\n")

# Create final test data
df_final_study_test <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  mutate(
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    ),
    type_comment = type_comment_fn,
    testPos_appear1_initial = ceiling(as.numeric(testPos_appear1_initial) / 3),
    studyPos_appear1_initial = ceiling(as.numeric(studyPos_appear1_initial) / 3)
  ) %>%
  # Categorize item types based on whether they have study/test positions
  mutate(
    has_study_pos = !is.na(studyPos_appear1_initial) & studyPos_appear1_initial > 0,
    has_test_pos = !is.na(testPos_appear1_initial) & testPos_appear1_initial > 0,
    is_final_foil = (type_comment == "Final Foil")
  ) %>%
  # Create test position group based on item type
  mutate(
    test_position_group = case_when(
      # Items with initial test position: split by initial test position
      has_test_pos & testPos_appear1_initial > 0 & testPos_appear1_initial <= median_testpos_final ~ "Early Test Position (≤5)",
      has_test_pos & testPos_appear1_initial > 0 & testPos_appear1_initial > median_testpos_final ~ "Late Test Position (>5)",
      # Final Foil: overall (no test position)
      is_final_foil ~ "All Test Positions",
      # Items without test position but with study position: split by final test position if available
      !has_test_pos & !is.na(testPos_final) ~ {
        final_pos_grouped <- case_when(
          testPos_final <= 49 ~ 1,
          testPos_final <= 98 ~ 2,
          testPos_final <= 147 ~ 3,
          testPos_final <= 196 ~ 4,
          testPos_final <= 245 ~ 5,
          testPos_final <= 294 ~ 6,
          testPos_final <= 343 ~ 7,
          testPos_final <= 392 ~ 8,
          testPos_final <= 442 ~ 9,
          testPos_final <= 492 ~ 10,
          TRUE ~ NA_real_
        )
        if_else(!is.na(final_pos_grouped) & final_pos_grouped <= 5, "Early Test Position (≤5)", "Late Test Position (>5)")
      },
      TRUE ~ "All Test Positions"
    ),
    test_position_group = factor(test_position_group,
                                levels = c("Early Test Position (≤5)", "Late Test Position (>5)", "All Test Positions"))
  ) %>%
  # Calculate separately for each item type
  {
    # Items with study position: by study position and test position group
    items_with_study <- filter(., has_study_pos) %>%
      filter(!is.na(test_position_group)) %>%
      group_by(studyPos_appear1_initial, test_position_group, subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(studyPos_appear1_initial, test_position_group, type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      rename(study_position = studyPos_appear1_initial) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # Items without study position (Final Foil): assign to position 0
    items_without_study <- filter(., !has_study_pos | is_final_foil) %>%
      filter(!is.na(test_position_group)) %>%
      group_by(test_position_group, subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(test_position_group, type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      mutate(study_position = 0) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # Combine all
    bind_rows(items_with_study, items_without_study)
  } %>%
  # Create simplified item_type column for grouping
  mutate(
    item_type = case_when(
      type_comment == "Target: studied and tested at (n), Foil (n+1)" ~ "ST(n)",
      type_comment == "Target: : started and tested at (n) ; Appear once" ~ "ST",
      type_comment == "Studied-only (n); Foil (n+1)" ~ "SO(n)",
      type_comment == "Studied-only (n); Appear once" ~ "SO",
      type_comment == "Foil(n), Foil (n+1)" ~ "TO(n)",
      type_comment == "Foil(n); Appear once" ~ "TO",
      type_comment == "Final Foil" ~ "FF",
      TRUE ~ "other"
    ),
    # Create facet variable to separate base types from confusing foils
    facet_group = case_when(
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO", "SO(n)") ~ "SO / SO(n)",
      item_type %in% c("TO", "TO(n)", "FF") ~ "TO / TO(n) / FF",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c(
      "ST", "ST(n)",
      "SO", "SO(n)",
      "TO", "TO(n)",
      "FF"
    )),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO / SO(n)", "TO / TO(n) / FF"))
  ) %>%
  # Filter to valid item types
  filter(item_type != "other") %>%
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
  # Facet by facet_group to separate ST/ST(n), SO/SO(n), TO/TO(n)/FF
  facet_grid(. ~ facet_group) +
  # Scales
  scale_y_continuous(
    limits = c(0.45, 1.0),
    breaks = seq(0.5, 1.0, by = 0.1),
    name = "Hit Rate"
  ) +
  scale_x_continuous(
    breaks = X_BREAKS,
    labels = X_LABELS,
    name = xaxisname
  ) +
  scale_color_manual(
    values = c(
      "ST" = "#2166AC",        # Blue for Studied & Tested
      "ST(n)" = "#4393C3",     # Lighter blue for ST(n)
      "SO" = "#1A9850",       # Green for Studied Only
      "SO(n)" = "#66BD63",     # Lighter green for SO(n)
      "TO" = "#E08214",        # Orange for Test Only
      "TO(n)" = "#F4A582",     # Lighter orange for TO(n)
      "FF" = "#D73027"         # Red for Final Foil
    ),
    name = "Item Type",
    labels = c(
      "ST" = "ST (Studied & Tested)",
      "ST(n)" = "ST(n) (Confusing Foil)",
      "SO" = "SO (Studied Only)",
      "SO(n)" = "SO(n) (Confusing Foil)",
      "TO" = "TO (Test Only)",
      "TO(n)" = "TO(n) (Confusing Foil)",
      "FF" = "FF (Final Foil)"
    )
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "ST(n)" = "#4393C3",
      "SO" = "#1A9850",
      "SO(n)" = "#66BD63",
      "TO" = "#E08214",
      "TO(n)" = "#F4A582",
      "FF" = "#D73027"
    ),
    name = "Item Type",
    labels = c(
      "ST" = "ST (Studied & Tested)",
      "ST(n)" = "ST(n) (Confusing Foil)",
      "SO" = "SO (Studied Only)",
      "SO(n)" = "SO(n) (Confusing Foil)",
      "TO" = "TO (Test Only)",
      "TO(n)" = "TO(n) (Confusing Foil)",
      "FF" = "FF (Final Foil)"
    )
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤5)" = 15,      # solid square
      "Late Test Position (>5)" = 17,       # solid triangle
      "All Test Positions" = 4              # cross
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤5)" = "solid",
      "Late Test Position (>5)" = "longdash",
      "All Test Positions" = "dashed"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = "Hit Rate",
    title = "E3 Final Test: Study Position vs Accuracy by Test Position",
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
    color = guide_legend(nrow = 4, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 4, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# Save final plot
ggsave(
  file.path(DESIGN3_DIR, "E3_final_study_test_position_interaction.png"),
  final_plot,
  width = 24,
  height = 11,
  dpi = 300,
  bg = "white"
)

cat("Final test plot saved as E3_final_study_test_position_interaction.png\n")

############################################################
## Combined Plot: Initial and Final Test Side by Side
############################################################

# Create combined plot
combined_plot <- grid.arrange(
  initial_plot,
  final_plot,
  ncol = 1,
  top = textGrob(
    "E3 Study Position vs Accuracy by Test Position: Initial and Final Test",
    gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold")
  )
)

# Save combined plot
ggsave(
  file.path(DESIGN3_DIR, "E3_study_test_position_interaction_combined.png"),
  combined_plot,
  width = 24,
  height = 22,
  dpi = 300,
  bg = "white"
)

cat("Combined plot saved as E3_study_test_position_interaction_combined.png\n")

############################################################
## Alternative: E3 with 30 Test Positions (Not Grouped)
############################################################

# Create data for initial test analysis with UNGROUPED positions (both study and test)
df_initial_study_test_30 <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  mutate(
    type_comment = typecomment_in,
    testPos_appear0_initial = as.numeric(testPos_appear0_initial),
    # DON'T group test positions - keep original 1-30 scale
    # Handle study position - some types use alternate position
    study_pos_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_pos_choice = case_when(
      type_comment %in% c(
        "Inherented Foil - Last Studied Only",
        "Inherented Foil - Last Target"
      ) & !is.na(study_pos_alternate) & study_pos_alternate > 0 ~ study_pos_alternate,
      TRUE ~ study_pos_primary
    ),
    # DON'T group study positions - keep original 1-30 scale
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    )
  ) %>%
  # Filter out missing positions
  filter(!is.na(study_pos_choice), !is.na(testPos_appear0_initial)) %>%
  # Create test position group: early (<= 15) vs late (> 15) - split at half of 30
  mutate(
    test_position_group = case_when(
      testPos_appear0_initial <= 15 ~ "Early Test Position (≤15)",
      testPos_appear0_initial > 15 ~ "Late Test Position (>15)"
    ),
    test_position_group = factor(test_position_group,
                                levels = c("Early Test Position (≤15)", "Late Test Position (>15)"))
  ) %>%
  # Calculate accuracy by study position, test position group, and participant
  group_by(study_pos_choice, test_position_group, subject_id, type_comment) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  # Calculate mean across participants
  group_by(study_pos_choice, test_position_group, type_comment) %>%
  summarize(
    meancr = mean(meancr1),
    sd = sd(meancr1),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  # Rename for clarity
  rename(study_position = study_pos_choice) %>%
  # Map to ST/SO/TO naming convention
  mutate(
    # Assign foils without study position to position 0
    study_position = case_when(
      is.na(study_position) | study_position == 0 ~ 0,
      TRUE ~ study_position
    ),
    # Map to ST/SO/TO convention
    item_type = case_when(
      type_comment == "Target" ~ "ST",
      type_comment == "New Foil" ~ "TO",
      type_comment == "Inherented Foil - Last Foil" ~ "TO(n)",
      type_comment == "Inherented Foil - Last Target" ~ "ST(n)",
      type_comment == "Inherented Foil - Last Studied Only" ~ "SO(n)",
      TRUE ~ "other"
    ),
    # Create facet variable
    facet_group = case_when(
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO(n)") ~ "SO(n)",
      item_type %in% c("TO", "TO(n)") ~ "TO / TO(n)",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c("ST", "ST(n)", "SO(n)", "TO", "TO(n)")),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO(n)", "TO / TO(n)"))
  ) %>%
  # Filter to valid item types
  filter(item_type != "other") %>%
  # Create combined grouping variable for ggplot
  mutate(
    group_var = interaction(test_position_group, item_type),
    # Create color variable that combines item type and test position for better visibility
    color_var = interaction(item_type, test_position_group)
  )

# Create the plot for initial test (30 positions version)
initial_plot_30 <- ggplot(
  data = df_initial_study_test_30,
  aes(x = study_position, y = meancr, group = group_var)
) +
  # Points - use color_var for COLOR, test_position_group for SHAPE
  geom_point(
    aes(color = color_var, shape = test_position_group),
    size = 2.5,
    alpha = LINE_ALPHA,
    stroke = 1.5
  ) +
  # Lines - use color_var for COLOR, test_position_group for LINETYPE
  geom_line(
    aes(color = color_var, linetype = test_position_group),
    linewidth = LINE_WIDTH,
    alpha = LINE_ALPHA
  ) +
  # Error ribbons - use color_var for fill (conditional)
  {if (SHOW_ERROR_BARS) geom_ribbon(
    aes(ymin = meancr - se, ymax = meancr + se, fill = color_var),
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
    breaks = seq(0, 30, by = 5),
    labels = as.character(seq(0, 30, by = 5)),
    name = xaxisname
  ) +
  scale_color_manual(
    values = c(
      # ST - Early (darker) and Late (lighter)
      "ST.Early Test Position (≤15)" = "#2166AC",
      "ST.Late Test Position (>15)" = "#6BAED6",
      # ST(n) - Early (darker) and Late (lighter)
      "ST(n).Early Test Position (≤15)" = "#4393C3",
      "ST(n).Late Test Position (>15)" = "#92C5DE",
      # SO(n) - Early (darker) and Late (lighter)
      "SO(n).Early Test Position (≤15)" = "#66BD63",
      "SO(n).Late Test Position (>15)" = "#A6D96A",
      # TO - Early (darker) and Late (lighter)
      "TO.Early Test Position (≤15)" = "#E08214",
      "TO.Late Test Position (>15)" = "#FDB863",
      # TO(n) - Early (darker) and Late (lighter)
      "TO(n).Early Test Position (≤15)" = "#F4A582",
      "TO(n).Late Test Position (>15)" = "#FDDBC7"
    ),
    name = "Item Type & Test Position",
    labels = c(
      "ST.Early Test Position (≤15)" = "ST - Early",
      "ST.Late Test Position (>15)" = "ST - Late",
      "ST(n).Early Test Position (≤15)" = "ST(n) - Early",
      "ST(n).Late Test Position (>15)" = "ST(n) - Late",
      "SO(n).Early Test Position (≤15)" = "SO(n) - Early",
      "SO(n).Late Test Position (>15)" = "SO(n) - Late",
      "TO.Early Test Position (≤15)" = "TO - Early",
      "TO.Late Test Position (>15)" = "TO - Late",
      "TO(n).Early Test Position (≤15)" = "TO(n) - Early",
      "TO(n).Late Test Position (>15)" = "TO(n) - Late"
    )
  ) +
  scale_fill_manual(
    values = c(
      "ST.Early Test Position (≤15)" = "#2166AC",
      "ST.Late Test Position (>15)" = "#6BAED6",
      "ST(n).Early Test Position (≤15)" = "#4393C3",
      "ST(n).Late Test Position (>15)" = "#92C5DE",
      "SO(n).Early Test Position (≤15)" = "#66BD63",
      "SO(n).Late Test Position (>15)" = "#A6D96A",
      "TO.Early Test Position (≤15)" = "#E08214",
      "TO.Late Test Position (>15)" = "#FDB863",
      "TO(n).Early Test Position (≤15)" = "#F4A582",
      "TO(n).Late Test Position (>15)" = "#FDDBC7"
    ),
    name = "Item Type & Test Position",
    labels = c(
      "ST.Early Test Position (≤15)" = "ST - Early",
      "ST.Late Test Position (>15)" = "ST - Late",
      "ST(n).Early Test Position (≤15)" = "ST(n) - Early",
      "ST(n).Late Test Position (>15)" = "ST(n) - Late",
      "SO(n).Early Test Position (≤15)" = "SO(n) - Early",
      "SO(n).Late Test Position (>15)" = "SO(n) - Late",
      "TO.Early Test Position (≤15)" = "TO - Early",
      "TO.Late Test Position (>15)" = "TO - Late",
      "TO(n).Early Test Position (≤15)" = "TO(n) - Early",
      "TO(n).Late Test Position (>15)" = "TO(n) - Late"
    )
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤15)" = 15,      # solid square
      "Late Test Position (>15)" = 17        # solid triangle
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤15)" = "solid",
      "Late Test Position (>15)" = "longdash"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = ylabsname,
    title = "E3 Initial Test: Study Position vs Accuracy by Test Position (30 Positions)",
    color = "Item Type & Test Position",
    fill = "Item Type & Test Position",
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
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# For final test, we'll use the same grouping approach but with ungrouped test positions
# Calculate median test position for splitting (using ungrouped positions)
median_testpos_final_30 <- df_rt_pl %>%
  filter(task == "finalTest", !is.na(testPos_appear1_initial)) %>%
  mutate(testPos_appear1_initial = as.numeric(testPos_appear1_initial)) %>%
  filter(testPos_appear1_initial > 0) %>%
  pull(testPos_appear1_initial) %>%
  median(na.rm = TRUE)

# If median is still 0 or NA, use a fixed split point (15 for 30 positions)
if (is.na(median_testpos_final_30) || median_testpos_final_30 == 0) {
  median_testpos_final_30 <- 15  # Use middle of 1-30 range
}

cat("Median test position (ungrouped):", median_testpos_final_30, "\n")

# Create final test data with UNGROUPED test positions
df_final_study_test_30 <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  mutate(
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    ),
    type_comment = type_comment_fn,
    testPos_appear1_initial = as.numeric(testPos_appear1_initial),  # Don't group
    studyPos_appear1_initial = as.numeric(studyPos_appear1_initial)  # Don't group study positions either
  ) %>%
  # Categorize item types based on whether they have study/test positions
  mutate(
    has_study_pos = !is.na(studyPos_appear1_initial) & studyPos_appear1_initial > 0,
    has_test_pos = !is.na(testPos_appear1_initial) & testPos_appear1_initial > 0,
    is_final_foil = (type_comment == "Final Foil")
  ) %>%
  # Create test position group based on item type (using ungrouped positions)
  mutate(
    test_position_group = case_when(
      # Items with initial test position: split by initial test position (ungrouped)
      has_test_pos & testPos_appear1_initial > 0 & testPos_appear1_initial <= median_testpos_final_30 ~ "Early Test Position (≤15)",
      has_test_pos & testPos_appear1_initial > 0 & testPos_appear1_initial > median_testpos_final_30 ~ "Late Test Position (>15)",
      # Items without initial test position: split by final test position
      !has_test_pos & !is.na(testPos_final) & as.numeric(testPos_final) <= 245 ~ "Early Test Position (≤15)",
      !has_test_pos & !is.na(testPos_final) & as.numeric(testPos_final) > 245 ~ "Late Test Position (>15)",
      # Final foils: overall
      is_final_foil ~ "All Test Positions",
      TRUE ~ NA_character_
    ),
    test_position_group = factor(test_position_group,
                                levels = c("Early Test Position (≤15)", "Late Test Position (>15)", "All Test Positions"))
  ) %>%
  # Calculate separately for each item type
  {
    # TARGET_target (studied and tested): by study position and initial test position group
    target_stt_data <- filter(., has_study_pos & has_test_pos & !is_final_foil) %>%
      filter(!is.na(studyPos_appear1_initial), !is.na(test_position_group)) %>%
      group_by(studyPos_appear1_initial, test_position_group, subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(studyPos_appear1_initial, test_position_group, type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      rename(study_position = studyPos_appear1_initial) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # TARGET_nontarget (studied only): by study position and FINAL test position group
    target_so_data <- filter(., has_study_pos & !has_test_pos & !is_final_foil) %>%
      filter(!is.na(studyPos_appear1_initial), !is.na(test_position_group)) %>%
      group_by(studyPos_appear1_initial, test_position_group, subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(studyPos_appear1_initial, test_position_group, type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      rename(study_position = studyPos_appear1_initial) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # TARGET_foil (tested only): by initial test position group (no study position)
    target_to_data <- filter(., !has_study_pos & has_test_pos & !is_final_foil) %>%
      filter(!is.na(test_position_group)) %>%
      group_by(test_position_group, subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(test_position_group, type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      mutate(study_position = 0) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # Final foils: overall performance
    foil_data <- filter(., is_final_foil) %>%
      group_by(subject_id, type_comment) %>%
      summarize(meancr1 = mean(correct), .groups = "drop") %>%
      group_by(type_comment) %>%
      summarize(
        meancr = mean(meancr1),
        sd = sd(meancr1),
        se = sd / sqrt(n()),
        .groups = "drop"
      ) %>%
      mutate(
        test_position_group = "All Test Positions",
        study_position = 0
      ) %>%
      select(study_position, test_position_group, type_comment, meancr, sd, se)
    
    # Combine all
    bind_rows(target_stt_data, target_so_data, target_to_data, foil_data)
  } %>%
  # Create simplified item_type column for grouping
  mutate(
    item_type = case_when(
      type_comment == "Target: studied and tested at (n), Foil (n+1)" ~ "ST(n)",
      type_comment == "Target: : started and tested at (n) ; Appear once" ~ "ST",
      type_comment == "Studied-only (n); Foil (n+1)" ~ "SO(n)",
      type_comment == "Studied-only (n); Appear once" ~ "SO",
      type_comment == "Foil(n), Foil (n+1)" ~ "TO(n)",
      type_comment == "Foil(n); Appear once" ~ "TO",
      type_comment == "Final Foil" ~ "FF",
      TRUE ~ "other"
    ),
    # Create facet variable to separate base types from confusing foils
    facet_group = case_when(
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO", "SO(n)") ~ "SO / SO(n)",
      item_type %in% c("TO", "TO(n)", "FF") ~ "TO / TO(n) / FF",
      TRUE ~ "other"
    ),
    item_type = factor(item_type, levels = c("ST", "ST(n)", "SO", "SO(n)", "TO", "TO(n)", "FF")),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO / SO(n)", "TO / TO(n) / FF"))
  ) %>%
  # Filter to valid item types
  filter(item_type != "other") %>%
  # Create combined grouping variable for ggplot
  mutate(
    group_var = interaction(test_position_group, item_type),
    # Create color variable that combines item type and test position for better visibility
    color_var = interaction(item_type, test_position_group)
  )

# Create the plot for final test (30 positions version)
final_plot_30 <- ggplot(
  data = df_final_study_test_30,
  aes(x = study_position, y = meancr, group = group_var)
) +
  # Points - use color_var for COLOR, test_position_group for SHAPE
  geom_point(
    aes(color = color_var, shape = test_position_group),
    size = 2.5,
    alpha = LINE_ALPHA,
    stroke = 1.5
  ) +
  # Lines - use color_var for COLOR, test_position_group for LINETYPE
  geom_line(
    aes(color = color_var, linetype = test_position_group),
    linewidth = LINE_WIDTH,
    alpha = LINE_ALPHA
  ) +
  # Error ribbons - use color_var for fill (conditional)
  {if (SHOW_ERROR_BARS) geom_ribbon(
    aes(ymin = meancr - se, ymax = meancr + se, fill = color_var),
    alpha = RIBBON_ALPHA
  )} +
  # Facet by facet_group to separate ST/ST(n), SO/SO(n), TO/TO(n)/FF
  facet_grid(. ~ facet_group) +
  # Scales
  scale_y_continuous(
    limits = c(0.45, 1.0),
    breaks = seq(0.5, 1.0, by = 0.1),
    name = "Hit Rate"
  ) +
  scale_x_continuous(
    breaks = seq(0, 30, by = 5),
    labels = as.character(seq(0, 30, by = 5)),
    name = xaxisname
  ) +
  scale_color_manual(
    values = c(
      # ST - Early (darker) and Late (lighter)
      "ST.Early Test Position (≤15)" = "#2166AC",
      "ST.Late Test Position (>15)" = "#6BAED6",
      # ST(n) - Early (darker) and Late (lighter)
      "ST(n).Early Test Position (≤15)" = "#4393C3",
      "ST(n).Late Test Position (>15)" = "#92C5DE",
      # SO - Early (darker) and Late (lighter)
      "SO.Early Test Position (≤15)" = "#1A9850",
      "SO.Late Test Position (>15)" = "#66BD63",
      # SO(n) - Early (darker) and Late (lighter)
      "SO(n).Early Test Position (≤15)" = "#66BD63",
      "SO(n).Late Test Position (>15)" = "#A6D96A",
      # TO - Early (darker) and Late (lighter)
      "TO.Early Test Position (≤15)" = "#E08214",
      "TO.Late Test Position (>15)" = "#FDB863",
      # TO(n) - Early (darker) and Late (lighter)
      "TO(n).Early Test Position (≤15)" = "#F4A582",
      "TO(n).Late Test Position (>15)" = "#FDDBC7",
      # FF - All test positions
      "FF.All Test Positions" = "#D73027"
    ),
    name = "Item Type & Test Position"
  ) +
  scale_fill_manual(
    values = c(
      "ST.Early Test Position (≤15)" = "#2166AC",
      "ST.Late Test Position (>15)" = "#6BAED6",
      "ST(n).Early Test Position (≤15)" = "#4393C3",
      "ST(n).Late Test Position (>15)" = "#92C5DE",
      "SO.Early Test Position (≤15)" = "#1A9850",
      "SO.Late Test Position (>15)" = "#66BD63",
      "SO(n).Early Test Position (≤15)" = "#66BD63",
      "SO(n).Late Test Position (>15)" = "#A6D96A",
      "TO.Early Test Position (≤15)" = "#E08214",
      "TO.Late Test Position (>15)" = "#FDB863",
      "TO(n).Early Test Position (≤15)" = "#F4A582",
      "TO(n).Late Test Position (>15)" = "#FDDBC7",
      "FF.All Test Positions" = "#D73027"
    ),
    name = "Item Type & Test Position"
  ) +
  scale_shape_manual(
    values = c(
      "Early Test Position (≤15)" = 15,      # solid square
      "Late Test Position (>15)" = 17,       # solid triangle
      "All Test Positions" = 4              # cross
    ),
    name = "Test Position"
  ) +
  scale_linetype_manual(
    values = c(
      "Early Test Position (≤15)" = "solid",
      "Late Test Position (>15)" = "longdash",
      "All Test Positions" = "dashed"
    ),
    name = "Test Position"
  ) +
  # Labels
  labs(
    x = xaxisname,
    y = "Hit Rate",
    title = "E3 Final Test: Study Position vs Accuracy by Test Position (30 Positions)",
    color = "Item Type & Test Position",
    fill = "Item Type & Test Position",
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
    color = guide_legend(nrow = 4, byrow = TRUE, title.position = "top"),
    fill = guide_legend(nrow = 4, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 2, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 2, byrow = TRUE, title.position = "top")
  )

# Create combined plot (30 positions version)
combined_plot_30 <- grid.arrange(
  initial_plot_30,
  final_plot_30,
  ncol = 1,
  top = textGrob(
    "E3 Study Position vs Accuracy by Test Position: Initial and Final Test (30 Test Positions)",
    gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold")
  )
)

# Save combined plot (30 positions version)
ggsave(
  file.path(DESIGN3_DIR, "E3_study_test_position_interaction_combined_30positions.png"),
  combined_plot_30,
  width = 24,
  height = 22,
  dpi = 300,
  bg = "white"
)

cat("Combined plot (30 positions) saved as E3_study_test_position_interaction_combined_30positions.png\n")

############################################################
## Lag Plot: Test Position - Study Position
############################################################

# Create lag plot data for initial test
df_initial_lag <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  mutate(
    type_comment = typecomment_in,
    testPos_appear0_initial = as.numeric(testPos_appear0_initial),
    # Handle study position - some types use alternate position
    study_pos_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_pos_choice = case_when(
      type_comment %in% c(
        "Inherented Foil - Last Studied Only",
        "Inherented Foil - Last Target"
      ) & !is.na(study_pos_alternate) & study_pos_alternate > 0 ~ study_pos_alternate,
      TRUE ~ study_pos_primary
    ),
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    ),
    # Map to ST/SO/TO naming convention first (needed for lag calculation)
    item_type = case_when(
      type_comment == "Target" ~ "ST",
      type_comment == "New Foil" ~ "TO",
      type_comment == "Inherented Foil - Last Foil" ~ "TO(n)",
      type_comment == "Inherented Foil - Last Target" ~ "ST(n)",
      type_comment == "Inherented Foil - Last Studied Only" ~ "SO(n)",
      TRUE ~ "other"
    ),
    # Get test position - for confusing foils (ST(n), SO(n), TO(n)), use testPos_appear2_initial
    # (when they served as confusing foils), for others use testPos_appear0_initial
    testPos_appear2_initial = as.numeric(testPos_appear2_initial),
    test_pos_for_lag = case_when(
      item_type %in% c("ST(n)", "SO(n)", "TO(n)") & 
      !is.na(testPos_appear2_initial) & testPos_appear2_initial > 0 ~ testPos_appear2_initial,
      TRUE ~ testPos_appear0_initial
    ),
    # Calculate lag = test position - study position (using ungrouped positions)
    # For confusing foils: lag = testPos_appear2_initial (when they served as confusing foils) - studyPos_appear1_initial (when they initially appeared)
    # For non-confusing items: lag = testPos_appear0_initial - study_pos_choice
    lag = test_pos_for_lag - study_pos_choice
  ) %>%
  filter(item_type != "other", !is.na(lag), !is.na(study_pos_choice), !is.na(test_pos_for_lag)) %>%
  # Calculate accuracy by lag and participant
  group_by(lag, subject_id, item_type) %>%
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
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO(n)") ~ "SO / SO(n)",  # Use same facet name as final test for consistency
      item_type %in% c("TO", "TO(n)") ~ "TO / TO(n)",
      TRUE ~ "other"
    ),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO / SO(n)", "TO / TO(n)"))
  ) %>%
  filter(facet_group != "other")

# Create lag plot data for final test
# Use INITIAL test positions, not final test positions!
df_final_lag <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  mutate(
    correct = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    ),
    type_comment = type_comment_fn,
    testPos_appear1_initial = as.numeric(testPos_appear1_initial),
    testPos_appear2_initial = as.numeric(testPos_appear2_initial),
    studyPos_appear1_initial = as.numeric(studyPos_appear1_initial),
    testPos_final = as.numeric(testPos_final),
    item_type = case_when(
      type_comment == "Target: studied and tested at (n), Foil (n+1)" ~ "ST(n)",
      type_comment == "Target: : started and tested at (n) ; Appear once" ~ "ST",
      type_comment == "Studied-only (n); Foil (n+1)" ~ "SO(n)",
      type_comment == "Studied-only (n); Appear once" ~ "SO",
      type_comment == "Foil(n), Foil (n+1)" ~ "TO(n)",
      type_comment == "Foil(n); Appear once" ~ "TO",
      TRUE ~ "other"
    ),
    # Calculate lag using correct test positions
    # For confusing foils (ST(n), SO(n), TO(n)), use testPos_appear2_initial (when they served as confusing foils)
    # For non-confusing items (ST, TO), use testPos_appear1_initial (their initial test position)
    # For SO items: they don't have initial test positions (studied-only), so treat testPos = 0
    # Lag = 0 - studyPos_appear1_initial = -studyPos_appear1_initial
    lag = case_when(
      # ST: lag = initial_testpos - initial_studypos (both from initial test)
      item_type == "ST" & 
      !is.na(testPos_appear1_initial) & !is.na(studyPos_appear1_initial) & 
      testPos_appear1_initial > 0 & studyPos_appear1_initial > 0 ~ 
      testPos_appear1_initial - studyPos_appear1_initial,
      # ST(n): lag = confusing_foil_testpos - initial_studypos
      # testPos_appear2_initial is when they served as confusing foils
      item_type == "ST(n)" & 
      !is.na(testPos_appear2_initial) & !is.na(studyPos_appear1_initial) & 
      testPos_appear2_initial > 0 & studyPos_appear1_initial > 0 ~ 
      testPos_appear2_initial - studyPos_appear1_initial,
      # SO: lag = 0 - initial_studypos (they weren't tested initially, so testPos = 0)
      item_type == "SO" & 
      !is.na(studyPos_appear1_initial) & studyPos_appear1_initial > 0 ~ 
      0 - studyPos_appear1_initial,
      # SO(n): lag = confusing_foil_testpos - initial_studypos
      # testPos_appear2_initial is when they served as confusing foils
      item_type == "SO(n)" & 
      !is.na(testPos_appear2_initial) & !is.na(studyPos_appear1_initial) & 
      testPos_appear2_initial > 0 & studyPos_appear1_initial > 0 ~ 
      testPos_appear2_initial - studyPos_appear1_initial,
      # TO: lag = initial_testpos - 0 (they weren't studied initially)
      item_type == "TO" & 
      !is.na(testPos_appear1_initial) & testPos_appear1_initial > 0 ~ 
      testPos_appear1_initial - 0,
      # TO(n): lag = confusing_foil_testpos - 0 (they weren't studied initially)
      # testPos_appear2_initial is when they served as confusing foils
      item_type == "TO(n)" & 
      !is.na(testPos_appear2_initial) & testPos_appear2_initial > 0 ~ 
      testPos_appear2_initial - 0,
      TRUE ~ NA_real_
    )
  ) %>%
  filter(item_type != "other", !is.na(lag)) %>%
  group_by(lag, subject_id, item_type) %>%
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
      item_type %in% c("ST", "ST(n)") ~ "ST / ST(n)",
      item_type %in% c("SO", "SO(n)") ~ "SO / SO(n)",  # Include both SO and SO(n)
      item_type %in% c("TO", "TO(n)") ~ "TO / TO(n)",
      TRUE ~ "other"
    ),
    facet_group = factor(facet_group, levels = c("ST / ST(n)", "SO / SO(n)", "TO / TO(n)"))
  ) %>%
  filter(facet_group != "other")

# Combine initial and final lag data
df_lag_combined <- bind_rows(df_initial_lag, df_final_lag) %>%
  mutate(
    item_type = factor(item_type, levels = c("ST", "ST(n)", "SO", "SO(n)", "TO", "TO(n)")),
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
      "ST(n)" = "#4393C3",
      "SO" = "#1A9850",
      "SO(n)" = "#66BD63",
      "TO" = "#E08214",
      "TO(n)" = "#F4A582"
    ),
    name = "Item Type",
    labels = c(
      "ST" = "ST (Studied & Tested)",
      "ST(n)" = "ST(n) (Studied & Tested, Confusing Foil)",
      "SO" = "SO (Studied Only)",
      "SO(n)" = "SO(n) (Studied Only, Confusing Foil)",
      "TO" = "TO (Test Only)",
      "TO(n)" = "TO(n) (Test Only, Confusing Foil)"
    )
  ) +
  scale_fill_manual(
    values = c(
      "ST" = "#2166AC",
      "ST(n)" = "#4393C3",
      "SO" = "#1A9850",
      "SO(n)" = "#66BD63",
      "TO" = "#E08214",
      "TO(n)" = "#F4A582"
    ),
    name = "Item Type",
    labels = c(
      "ST" = "ST (Studied & Tested)",
      "ST(n)" = "ST(n) (Studied & Tested, Confusing Foil)",
      "SO" = "SO (Studied Only)",
      "SO(n)" = "SO(n) (Studied Only, Confusing Foil)",
      "TO" = "TO (Test Only)",
      "TO(n)" = "TO(n) (Test Only, Confusing Foil)"
    )
  ) +
  scale_shape_manual(
    values = c(
      "Initial Test" = 15,
      "Final Test" = 17
    ),
    guide = "none"  # Hide shape legend
  ) +
  scale_linetype_manual(
    values = c(
      "Initial Test" = "solid",
      "Final Test" = "solid"  # Both use solid lines
    ),
    guide = "none"  # Hide linetype legend
  ) +
  scale_y_continuous(
    limits = c(0.25, 1.0),  # Lower limit to show all data points (min is ~0.33)
    breaks = seq(0.2, 1.0, by = 0.1),
    name = "Mean Accuracy"
  ) +
  scale_x_continuous(
    name = "Lag (Test Position - Study Position)"
  ) +
  labs(
    title = "E3 Lag Plot: Accuracy vs Temporal Distance Between Study and Test",
    x = "Lag (Test Position - Study Position)",
    y = "Mean Accuracy",
    color = "Item Type",
    fill = "Item Type"
  ) +
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.title = element_text(hjust = 0.5, size = TITLE_SIZE, face = "bold"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = LEGEND_POSITION,
    legend.title = element_text(size = BASE_TEXT_SIZE - 4, face = "bold"),  # Reduced for 3-row legend
    legend.text = element_text(size = BASE_TEXT_SIZE - 6),  # Reduced for 3-row legend
    legend.key.width = unit(1.5, "cm"),  # Reduced for 3-row legend
    legend.key.height = unit(0.7, "cm"),  # Reduced for 3-row legend
    legend.spacing.x = unit(0.3, "cm"),  # Reduced for 3-row legend
    legend.spacing.y = unit(0.2, "cm"),  # Reduced for 3-row legend
    legend.margin = margin(t = 10, r = 10, b = 10, l = 10),  # Reduced for 3-row legend
    plot.margin = margin(t = 15, r = 15, b = 120, l = 15),  # Increased bottom margin for 3-row legend
    text = element_text(size = BASE_TEXT_SIZE),
    axis.title = element_text(size = AXIS_TITLE_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE),
    strip.text = element_text(size = BASE_TEXT_SIZE, face = "bold"),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  ) +
  guides(
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top", override.aes = list(size = 2.5)),  # 3 rows, reduced size
    fill = guide_legend(nrow = 3, byrow = TRUE, title.position = "top")  # 3 rows
  )

# Save lag plot
ggsave(
  file.path(DESIGN3_DIR, "E3_study_test_position_interaction_with_lag.png"),
  lag_plot,
  width = 26,
  height = 18,  # Increased height for 3-row legend
  dpi = 300,
  bg = "white"
)

cat("Lag plot saved as E3_study_test_position_interaction_with_lag.png\n")

