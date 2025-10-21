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

RT_MIN_MS <- 180
RT_MAX_MS <- 3000

df_rt_pl <- read_csv(file.path(DATA_DIR, "E3_AGGREGATED.csv")) %>%
  mutate(rt = as.numeric(rt))
cat("Loaded aggregated data from E3_AGGREGATED.csv\n")

# ------------------------------------------------------------
# Exp. 2 Initial Test Within List RT DATA
# ------------------------------------------------------------

PLOT_TITLE_SIZE <- 30
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 30
BASE_SIZE <- 30
POINT_SIZE <- 5
POINT_STROKE <- 1.2
LINE_WIDTH <- 1.5
PLOT_WIDTH <- 19/3*2
PLOT_HEIGHT <- 7.5
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
RT_LABEL <- "Response Time (ms)"

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  )

initial_within_test_rt <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = typecomment_in,
    testPos_appear0_initial = suppressWarnings(as.numeric(testPos_appear0_initial)),
    position = ceiling(testPos_appear0_initial / 3)
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Test Position")

initial_within_study_rt <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = typecomment_in,
    study_pos_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_pos_choice = case_when(
      type_comment %in% c(
        "Inherented Foil - Last Studied Only",
        "Inherented Foil - Last Target"
      ) & !is.na(study_pos_alternate) & study_pos_alternate > 0 ~ study_pos_alternate,
      TRUE ~ study_pos_primary
    ),
    position = ceiling(study_pos_choice / 3)
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Study Position")

initial_within_rt <- bind_rows(initial_within_test_rt, initial_within_study_rt)

initial_within_rt_plot <- ggplot(initial_within_rt) +
  geom_ribbon(
    aes(
      x = position,
      ymin = meanrt - se,
      ymax = meanrt + se,
      group = interaction(task, type_comment),
      fill = type_comment
    ),
    alpha = 0.3
  ) +
  geom_line(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      color = type_comment,
      linetype = type_comment
    )
  ) +
  geom_point(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      shape = type_comment,
      color = type_comment
    ),
    size = POINT_SIZE,
    stroke = POINT_STROKE
  ) +
  facet_grid(. ~ position_type) +
  scale_color_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",
      "Inherented Foil - Last Studied Only" = "#1A9850",
      "Inherented Foil - Last Target" = "#2166AC",
      "New Foil" = "#E08214",
      "Target" = "#2166AC"
    )
  ) +
  scale_fill_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",
      "Inherented Foil - Last Studied Only" = "#1A9850",
      "Inherented Foil - Last Target" = "#2166AC",
      "New Foil" = "#E08214",
      "Target" = "#2166AC"
    )
  ) +
  scale_linetype_manual(
    values = c(
      "Inherented Foil - Last Foil" = "dashed",
      "Inherented Foil - Last Studied Only" = "dashed",
      "Inherented Foil - Last Target" = "dashed",
      "New Foil" = "solid",
      "Target" = "solid"
    )
  ) +
  scale_shape_manual(
    values = c(
      "New Foil" = 17,
      "Target" = 15,
      "Inherented Foil - Last Foil" = 2,
      "Inherented Foil - Last Target" = 0,
      "Inherented Foil - Last Studied Only" = 1
    )
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL,
    y = RT_LABEL,
    title = "Exp. 2 Initial Test Within List RT DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1))

ggsave(
  file.path(RT_RESULTS_DIR, "E3_initial_within_rt.png"),
  initial_within_rt_plot,
  width = PLOT_WIDTH,
  height = PLOT_HEIGHT,
  dpi = PLOT_DPI,
  bg = "white"
)

# ------------------------------------------------------------
# Exp. 2 Initial Test Between List RT DATA
# ------------------------------------------------------------

PLOT_TITLE_SIZE <- 19
AXIS_TITLE_SIZE <- 25
AXIS_TEXT_SIZE <- 25
STRIP_TEXT_SIZE <- 25
BASE_SIZE <- 24
POINT_SIZE <- 4.5
LINE_WIDTH <- 1.8
PLOT_WIDTH <- 7
PLOT_HEIGHT <- 6.5
PLOT_DPI <- 300

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  )

levelsStr <- c(
  "New Foil",
  "Target",
  "Inherented Foil - Last Foil",
  "Inherented Foil - Last Target",
  "Inherented Foil - Last Studied Only"
)

initial_between_rt <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(colorskeme = typecomment_in) %>%
  group_by(task, condition, listNum_appear0_initial, colorskeme, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, listNum_appear0_initial, colorskeme) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  )

initial_between_rt_plot <- ggplot(initial_between_rt) +
  geom_ribbon(
    aes(
      x = listNum_appear0_initial,
      ymin = meanrt - se,
      ymax = meanrt + se,
      group = interaction(task, colorskeme),
      fill = colorskeme
    ),
    alpha = 0.3
  ) +
  geom_line(
    aes(
      x = listNum_appear0_initial,
      y = meanrt,
      group = interaction(task, colorskeme),
      color = colorskeme,
      linetype = colorskeme
    ),
    linewidth = LINE_WIDTH
  ) +
  geom_point(
    aes(
      x = listNum_appear0_initial,
      y = meanrt,
      group = interaction(task, colorskeme),
      color = colorskeme,
      shape = colorskeme
    ),
    size = POINT_SIZE,
    stroke = POINT_STROKE
  ) +
  facet_grid(. ~ task, labeller = labeller(task = c("initialTest_response" = "Initial List Number"))) +
  scale_color_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",
      "Inherented Foil - Last Studied Only" = "#1A9850",
      "Inherented Foil - Last Target" = "#2166AC",
      "New Foil" = "#E08214",
      "Target" = "#2166AC"
    ),
    breaks = levelsStr
  ) +
  scale_fill_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",
      "Inherented Foil - Last Studied Only" = "#1A9850",
      "Inherented Foil - Last Target" = "#2166AC",
      "New Foil" = "#E08214",
      "Target" = "#2166AC"
    ),
    breaks = levelsStr
  ) +
  scale_linetype_manual(
    values = c(
      "Inherented Foil - Last Foil" = "dashed",
      "Inherented Foil - Last Studied Only" = "dashed",
      "Inherented Foil - Last Target" = "dashed",
      "New Foil" = "solid",
      "Target" = "solid"
    ),
    breaks = levelsStr
  ) +
  scale_shape_manual(
    values = c(
      "New Foil" = 17,
      "Target" = 15,
      "Inherented Foil - Last Foil" = 2,
      "Inherented Foil - Last Target" = 0,
      "Inherented Foil - Last Studied Only" = 1
    ),
    breaks = levelsStr
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL,
    y = RT_LABEL,
    title = "Exp. 2 Initial Between List RT DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1))

ggsave(
  file.path(RT_RESULTS_DIR, "E3_initial_between_rt.png"),
  initial_between_rt_plot,
  width = PLOT_WIDTH,
  height = PLOT_HEIGHT,
  dpi = PLOT_DPI,
  bg = "white"
)

# ------------------------------------------------------------
# Exp. 2 Final Test Within List RT DATA
# ------------------------------------------------------------

PLOT_TITLE_SIZE <- 30
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 30
BASE_SIZE <- 24
POINT_STROKE <- 1.2
POINT_SIZE <- 5
LINE_WIDTH <- 1.5
PLOT_WIDTH <- 19/3*2
PLOT_HEIGHT <- 7.5
PLOT_DPI <- 300

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  )

levelsStr_fn <- levels(as.factor(df_rt_pl$type_comment_fn))

final_within_test_rt <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = type_comment_fn,
    testPos_appear1_initial = suppressWarnings(as.numeric(testPos_appear1_initial)),
    position = ceiling(testPos_appear1_initial / 3)
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Test Position")

final_within_study_rt <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = type_comment_fn,
    listNum_infinalOrder = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    position = ceiling(listNum_infinalOrder / 3)
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Study Position")

final_within_rt <- bind_rows(final_within_test_rt, final_within_study_rt)

final_within_rt_plot <- ggplot(final_within_rt) +
  geom_ribbon(
    aes(
      x = position,
      ymin = meanrt - se,
      ymax = meanrt + se,
      group = interaction(task, type_comment),
      fill = type_comment
    ),
    alpha = 0.3
  ) +
  geom_line(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      color = type_comment,
      linetype = type_comment
    ),
    linewidth = LINE_WIDTH
  ) +
  geom_point(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      color = type_comment,
      shape = type_comment
    ),
    size = POINT_SIZE,
    stroke = POINT_STROKE
  ) +
  facet_grid(. ~ position_type) +
  scale_color_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
  ), breaks = levelsStr_fn) +
  scale_fill_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
  ), breaks = levelsStr_fn) +
  scale_shape_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = 0,
    "Target: : started and tested at (n) ; Appear once" = 15,
    "Studied-only (n); Foil (n+1)" = 1,
    "Studied-only (n); Appear once" = 16,
    "Foil(n), Foil (n+1)" = 2,
    "Foil(n); Appear once" = 17,
    "Final Foil" = 4
  ), breaks = levelsStr_fn) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL,
    y = RT_LABEL,
    title = "Exp. 2 Final Test Within List RT DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1))

ggsave(
  file.path(RT_RESULTS_DIR, "E3_final_within_rt.png"),
  final_within_rt_plot,
  width = PLOT_WIDTH,
  height = PLOT_HEIGHT,
  dpi = PLOT_DPI,
  bg = "white"
)

# ------------------------------------------------------------
# Exp. 2 Final Test Between List RT DATA
# ------------------------------------------------------------

PLOT_TITLE_SIZE <- 30
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 28
BASE_SIZE <- 24
POINT_SIZE <- 8
POINT_STROKE <- 1.2
LINE_WIDTH <- 1.5
PLOT_WIDTH <- 12
PLOT_HEIGHT <- (13+4)/3+1.2
PLOT_DPI <- 300

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1)
  )

levelsStr_fn <- levels(as.factor(df_rt_pl$type_comment_fn))

final_between_initial_rt <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = type_comment_fn,
    listNum_appear1_initial = suppressWarnings(as.numeric(listNum_appear1_initial)),
    type_comment = case_when(
      listNum_appear1_initial == 10 & type_comment == "Foil(n), Foil (n+1)" ~ "Foil(n); Appear once",
      listNum_appear1_initial == 10 & type_comment == "Studied-only (n); Foil (n+1)" ~ "Studied-only (n); Appear once",
      listNum_appear1_initial == 10 & type_comment == "Target: studied and tested at (n), Foil (n+1)" ~ "Target: : started and tested at (n) ; Appear once",
      TRUE ~ type_comment
    ),
    position = listNum_appear1_initial
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Initial Position")

final_between_final_rt <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  mutate(
    type_comment = type_comment_fn,
    listNum_infinalOrder = suppressWarnings(as.numeric(testPos_final)),
    listNum_infinalOrder = case_when(
      listNum_infinalOrder <= 49 ~ 1,
      listNum_infinalOrder <= 98 ~ 2,
      listNum_infinalOrder <= 147 ~ 3,
      listNum_infinalOrder <= 196 ~ 4,
      listNum_infinalOrder <= 245 ~ 5,
      listNum_infinalOrder <= 294 ~ 6,
      listNum_infinalOrder <= 343 ~ 7,
      listNum_infinalOrder <= 392 ~ 8,
      listNum_infinalOrder <= 442 ~ 9,
      listNum_infinalOrder <= 492 ~ 10,
      TRUE ~ NA_real_
    ),
    position = listNum_infinalOrder
  ) %>%
  filter(!is.na(position)) %>%
  group_by(task, condition, type_comment, position, subject_id) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  group_by(task, condition, type_comment, position) %>%
  summarize(
    meanrt = median(meanrt1, na.rm = TRUE),
    sd = sd(meanrt1, na.rm = TRUE),
    se = sd / sqrt(n()),
    .groups = "drop"
  ) %>%
  mutate(position_type = "Final Position")

final_between_rt <- bind_rows(final_between_initial_rt, final_between_final_rt)

final_between_rt_plot <- ggplot(final_between_rt) +
  geom_ribbon(
    aes(
      x = position,
      ymin = meanrt - se,
      ymax = meanrt + se,
      group = interaction(task, type_comment),
      fill = type_comment
    ),
    alpha = 0.3
  ) +
  geom_line(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      color = type_comment,
      linetype = type_comment
    ),
    linewidth = LINE_WIDTH
  ) +
  geom_point(
    aes(
      x = position,
      y = meanrt,
      group = interaction(task, type_comment),
      color = type_comment,
      shape = type_comment
    ),
    size = POINT_SIZE,
    stroke = POINT_STROKE
  ) +
  facet_grid(. ~ position_type) +
  scale_color_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
  ), breaks = levelsStr_fn) +
  scale_fill_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = "#2166AC",
    "Studied-only (n); Foil (n+1)" = "#1A9850",
    "Target: : started and tested at (n) ; Appear once" = "#2166AC",
    "Foil(n), Foil (n+1)" = "#E08214",
    "Foil(n); Appear once" = "#E08214",
    "Studied-only (n); Appear once" = "#1A9850",
    "Final Foil" = "red"
  ), breaks = levelsStr_fn) +
  scale_shape_manual(values = c(
    "Target: studied and tested at (n), Foil (n+1)" = 0,
    "Target: : started and tested at (n) ; Appear once" = 15,
    "Studied-only (n); Foil (n+1)" = 1,
    "Studied-only (n); Appear once" = 16,
    "Foil(n), Foil (n+1)" = 2,
    "Foil(n); Appear once" = 17,
    "Final Foil" = 4
  ), breaks = levelsStr_fn) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL,
    y = RT_LABEL,
    title = "Exp. 2 Final Test Between List RT DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1))

ggsave(
  file.path(RT_RESULTS_DIR, "E3_final_between_rt.png"),
  final_between_rt_plot,
  width = PLOT_WIDTH,
  height = PLOT_HEIGHT,
  dpi = PLOT_DPI,
  bg = "white"
)


# ------------------------------------------------------------
# Exp. 2 Individual Participant RT Analysis
# ------------------------------------------------------------

initial_participant_rt <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  group_by(subject_id) %>%
  summarize(mean_rt = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  arrange(mean_rt) %>%
  mutate(
    participant_rank = row_number(),
    test_type = "Initial Test"
  ) %>%
  filter(!is.na(mean_rt))

final_participant_rt <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(rt), rt >= RT_MIN_MS, rt <= RT_MAX_MS) %>%
  group_by(subject_id) %>%
  summarize(mean_rt = mean(rt, na.rm = TRUE), .groups = "drop") %>%
  arrange(mean_rt) %>%
  mutate(
    participant_rank = row_number(),
    test_type = "Final Test"
  ) %>%
  filter(!is.na(mean_rt))

participant_rt_data <- bind_rows(initial_participant_rt, final_participant_rt)

write_csv(
  participant_rt_data,
  file.path(RT_RESULTS_DIR, "participant_rt_data_E3.csv")
)
cat("Participant RT data saved to participant_rt_data_E3.csv\n")

initial_rt_plot <- ggplot(initial_participant_rt, aes(participant_rank, mean_rt)) +
  geom_point(size = 1, alpha = 0.7, color = "black") +
  labs(
    x = "Participant (ordered fastest to slowest)",
    y = "Mean RT (ms)",
    title = "Exp. 2 Initial Test - Individual Participant Mean RT"
  ) +
  ylim(0, NA) +
  theme_classic() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 20),
    axis.text = element_text(size = 20, color = "black"),
    axis.title = element_text(size = 20, face = "bold", color = "black"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),
    axis.ticks.x = element_line(color = "black")
  )

final_rt_plot <- ggplot(final_participant_rt, aes(participant_rank, mean_rt)) +
  geom_point(size = 1, alpha = 0.7, color = "black") +
  labs(
    x = "Participant (ordered fastest to slowest)",
    y = "Mean RT (ms)",
    title = "Exp. 2 Final Test - Individual Participant Mean RT"
  ) +
  ylim(0, NA) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 35),
    axis.text = element_text(size = 20, color = "black"),
    axis.title = element_text(size = 20, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),
    axis.ticks.x = element_line(color = "black")
  )

combined_rt_plot <- grid.arrange(
  initial_rt_plot,
  final_rt_plot,
  ncol = 2,
  top = textGrob(
    "Exp. 2 Individual Participant Mean RT",
    gp = gpar(fontsize = 28, fontface = "bold")
  )
)

ggsave(
  file.path(RT_RESULTS_DIR, "E3_participant_mean_rt.png"),
  combined_rt_plot,
  width = 13,
  height = 6,
  dpi = 300,
  bg = "white"
)

cat("\n=== PARTICIPANT MEAN RT SUMMARY ===\n")

cat("\nInitial Test Mean RT:\n")
cat(sprintf("Number of participants: %d\n", nrow(initial_participant_rt)))
cat(sprintf("Mean RT: %.2f ms\n", mean(initial_participant_rt$mean_rt)))
cat(sprintf("Median RT: %.2f ms\n", median(initial_participant_rt$mean_rt)))
cat(sprintf("SD RT: %.2f ms\n", sd(initial_participant_rt$mean_rt)))
cat(sprintf(
  "Range: %.2f - %.2f ms\n",
  min(initial_participant_rt$mean_rt),
  max(initial_participant_rt$mean_rt)
))

cat("\nFinal Test Mean RT:\n")
cat(sprintf("Number of participants: %d\n", nrow(final_participant_rt)))
cat(sprintf("Mean RT: %.2f ms\n", mean(final_participant_rt$mean_rt)))
cat(sprintf("Median RT: %.2f ms\n", median(final_participant_rt$mean_rt)))
cat(sprintf("SD RT: %.2f ms\n", sd(final_participant_rt$mean_rt)))
cat(sprintf(
  "Range: %.2f - %.2f ms\n",
  min(final_participant_rt$mean_rt),
  max(final_participant_rt$mean_rt)
))

cat("\n=== RT PLOTS CREATED SUCCESSFULLY! ===\n")
cat("Files created in rt_results folder:\n")
cat("• participant_rt_data_E3.csv - Raw RT data\n")
cat("• E3_initial_within_rt.png - Initial Within List RT plot\n")
cat("• E3_initial_between_rt.png - Initial Between List RT plot\n")
cat("• E3_final_within_rt.png - Final Within List RT plot\n")
cat("• E3_final_between_rt.png - Final Between List RT plot\n")
cat("• E3_participant_mean_rt.png - Combined participant RT plot\n")


