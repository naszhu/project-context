library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

all_results <- read.csv("../../../all_results.csv")
DF <- read.csv("../../../DF.csv")

df_between <- DF %>% 
    mutate(meanx = case_when(is_target == "true" ~ meanx, TRUE ~ 1 - meanx)) %>%
    mutate(test_position = as.numeric(test_position)) %>%
    group_by(list_number, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = factor(is_target,
                             levels = c("false", "true"),
                             labels = c("foil", "target"))) %>%
    group_by(list_number) %>%
    mutate(meanx_m = mean(meanx))

df_between$is_target <- factor(df_between$is_target,
                              levels = c("foil", "target"),
                              labels = c("foil", "target"))

ribbon_width <- 0.008

p_between_list <- ggplot(data = df_between, aes(x = list_number, y = meanx, group = is_target)) +
    # geom_ribbon(aes(ymin = meanx - ribbon_width, ymax = meanx + ribbon_width, fill = is_target), 
                # alpha = 0.4) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = 2) +
    geom_point(aes(color = is_target, shape = is_target), size = 8) +
    geom_line(aes(x = list_number, y = meanx_m), color = "black", linewidth = 2, linetype = "dashed") +
    # geom_point(aes(x = list_number, y = meanx_m), color = "black", shape = 15, size = 8) +
    scale_color_manual(values = c("foil" = "#E74C3C", "target" = "#27AE60"),
                      name = "Type") +
    scale_fill_manual(values = c("foil" = "#E74C3C", "target" = "#27AE60"),
                     name = "Type") +
    scale_shape_manual(values = c("foil" = 16, "target" = 17),
                      name = "Type") +
    scale_linetype_manual(values = c("foil" = "solid", "target" = "dashed"),
                         name = "Type") +
    scale_y_continuous(limits = c(0.82, 0.96),
                      breaks = seq(0.82, 0.96, by = 0.02),
                      name = "Performance (Hits/Correct Rejection)") +
    scale_x_continuous(breaks = 1:10,
                      labels = as.character(1:10),
                      name = "List number in initial test") +
    labs(title = "E1 Initial Between List data",
        #  subtitle = "Figure 3. Between List Initial Test Results") +
         ) +
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.8),
        panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
        panel.grid.minor = element_line(color = "gray95", linewidth = 0.3),
        legend.position = "bottom",
        legend.title = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 14),
        text = element_text(size = 16),
        axis.title = element_text(size = 16, face = "bold"),
        axis.text = element_text(size = 14)
    )

ggsave("E1_initial_between_list_prediction.png", plot = p_between_list, 
       width = 10, height = 7, dpi = 300, bg = "white")

cat("Between-list prediction plot saved as E1_initial_between_list_prediction.png\n")