library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

all_results <- read.csv("../../../all_results.csv")

df_study <- all_results %>%
    mutate(is_target = case_when(is_target == "true" ~ 1, TRUE ~ 0),
           correct = decision_isold == is_target) %>%
    group_by(study_position, is_target, simulation_number) %>%
    summarize(meanx = mean(correct), .groups = "drop") %>%
    group_by(study_position, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = as.factor(is_target),
           position_type = "Study") %>%
    rename(position = study_position) %>%
    group_by(position) %>%
    mutate(meanx_m = mean(meanx))

df_test <- all_results %>%
    mutate(is_target = case_when(is_target == "true" ~ 1, TRUE ~ 0),
           correct = decision_isold == is_target) %>%
    group_by(test_position, is_target, simulation_number) %>%
    summarize(meanx = mean(correct), .groups = "drop") %>%
    group_by(test_position, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = as.factor(is_target),
           position_type = "Test") %>%
    rename(position = test_position) %>%
    group_by(position) %>%
    mutate(meanx_m = mean(meanx))

df_combined <- rbind(df_study, df_test)

df_combined$is_target <- factor(df_combined$is_target, 
                               levels = c("0", "1"),
                               labels = c("Foil - Correct rejection", "Target - Hits"))

df_combined$position_type <- factor(df_combined$position_type,
                                   levels = c("Study", "Test"),
                                   labels = c("Initial Study Position", "Initial Test Position"))

p_within_list <- ggplot(data = df_combined, aes(x = position, y = meanx, group = is_target)) +
#     geom_ribbon(aes(ymin = meanx - 0.01, ymax = meanx + 0.01, fill = is_target), alpha = 0.3) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = 1.5) +
    geom_point(aes(color = is_target, shape = is_target), size = 6) +
    # Add black average line ONLY for test position
    geom_line(data = df_combined %>% filter(position_type == "Initial Test Position"), 
              aes(x = position, y = meanx_m), color = "black", linewidth = 2, linetype = "solid") +
    # Add black square points for the average line
    geom_point(data = df_combined %>% filter(position_type == "Initial Test Position"), 
               aes(x = position, y = meanx_m), color = "black", shape = 15, size = 4) +
    facet_grid(~ position_type, scales = "free_x") +
    scale_color_manual(values = c("Foil - Correct rejection" = "#E74C3C", 
                                 "Target - Hits" = "#27AE60"),
                      name = "Type") +
    scale_shape_manual(values = c("Foil - Correct rejection" = 16, 
                                 "Target - Hits" = 17),
                      name = "Type") +
    scale_linetype_manual(values = c("Foil - Correct rejection" = "solid", 
                                    "Target - Hits" = "dotted"),
                         name = "Type") +
    scale_y_continuous(limits = c(0.75, 1.00),
                      breaks = seq(0.75, 1.00, by = 0.05),
                      name = "Performance (Hits/Correct Rejection)") +
    scale_x_continuous(breaks = seq(0, 20, by = 5),
                      name = "Initial Study position (left column), Initial Test position (right column)") +
    labs(
        title = "E1 Initial Within List prediction",
        subtitle = ""
    ) +
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        strip.text = element_text(size = 18, face = "bold"),
        strip.background = element_rect(fill = "lightgray", color = "black"),
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

ggsave("E1_initial_within_list_prediction.png", plot = p_within_list, 
       width = 12, height = 7, dpi = 300, bg = "white")

cat("Within-list prediction plot saved as E1_initial_within_list_prediction.png\n")