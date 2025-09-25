# Plot formatting constants for consistent styling across all plots

# Font sizes
PLOT_TITLE_SIZE <- 18
AXIS_TITLE_SIZE <- 24
AXIS_TEXT_SIZE <- 18
STRIP_TEXT_SIZE <- 28
BASE_SIZE <- 24

# Point and line sizes
POINT_SIZE <- 4
LINE_WIDTH <- 1

# Plot dimensions
PLOT_WIDTH <- 6
PLOT_HEIGHT <- 6
PLOT_DPI <- 300

# Theme settings
PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold")
  )

# Common labels
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"
