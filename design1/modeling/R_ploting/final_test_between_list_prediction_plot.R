library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Load data - use allresf.csv which has the condition column
allresf <- read.csv("../../../allresf.csv")

# Create df_allfinal data for final test between-list analysis - EXACT SAME AS ORIGINAL
DF00 <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(test_position = as.numeric(test_position)) %>%
    mutate(test_position_group = ntile(test_position, 10)) %>%
    group_by(test_position_group, is_target, condition) %>%
    summarize(meanx = mean(correct))

DF001 <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(list_number = as.numeric(list_number)) %>%
    group_by(list_number, is_target, condition) %>%
    summarize(meanx = mean(correct))

# Combine the data - EXACT SAME AS ORIGINAL
df_allfinal <- DF001 %>%
    mutate(test_position_group = list_number) %>%
    ungroup() %>%
    select(-list_number) %>%
    full_join(DF00, by = c("is_target", "condition", "test_position_group")) %>%
    mutate(initial_list_order = meanx.x, final_test_order = meanx.y) %>%
    select(-c("meanx.x", "meanx.y")) %>%
    pivot_longer(cols = c("initial_list_order", "final_test_order"), 
                 names_to = "position_kind", values_to = "val") %>%
    group_by(position_kind, test_position_group, condition) %>%
    mutate(mean_mean = mean(val[is_target != "F"], na.rm = TRUE))

# Don't filter out any foil data - keep all foil data in both columns
df_allfinal_filtered <- df_allfinal

# Create the plot with different foil representations for each column
p_final_test <- ggplot(data = df_allfinal_filtered, 
                      aes(test_position_group, val, 
                          group = interaction(position_kind, condition, is_target))) +
    # Points for all targets
    geom_point(aes(color = is_target, shape = is_target, group = is_target), size = 4.5) +
    # Lines for initial_list_order (left column - Initial Study List Position) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "initial_list_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = 1.5) +
    # Lines for final_test_order (right column - Final Test List Position) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "final_test_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = 1.5) +
    facet_grid(factor(condition, levels = c("backward", "forward", "true_random"), 
                      labels = c("backward", "forward", "random")) ~ 
               factor(position_kind, levels = c("initial_list_order", "final_test_order")), 
               labeller = labeller(position_kind = c("initial_list_order" = "Initial Study List Position", 
                                                   "final_test_order" = "Final Test List Position"))) +
    labs(x = "Final test in 10 chunks (left column), Initial test list order (right column)",
         y = "Performance (Hits/Correct Rejection)",
         title = "E1 Final Test Between List prediction",
         color = "Type", shape = "Type", linetype = "Type") +
    scale_color_manual(values = c("F" = "#D73027", "T_foil" = "#E08214", "T_nontarget" = "#1A9850", "T_target" = "#2166AC"),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_shape_manual(values = c("F" = 16, "T_foil" = 18, "T_nontarget" = 17, "T_target" = 16),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_linetype_manual(values = c("F" = "solid", "T_foil" = "dotted", "T_nontarget" = "solid", "T_target" = "dashed"),
                          labels = c("F" = "Foil - Correct rejection", 
                                   "T_foil" = "TARGET_foil - Hits",
                                   "T_nontarget" = "TARGET_nontarget - Hits", 
                                   "T_target" = "TARGET_target - Hits")) +
    theme_minimal(base_size = 24) +
    theme(
        plot.caption = element_text(hjust = 0, size = 15, face = "bold", color = "darkblue", margin = margin(t = 20)),
        plot.margin = margin(t = 15, r = 15, b = 70, l = 15),
        text = element_text(size = 24),
        axis.text = element_text(size = 24, color = "black"),
        axis.title = element_text(size = 26, face = "bold", color = "black"),
        panel.grid.major = element_line(color = "grey75", linewidth = 0.3),
        panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
        legend.position = "bottom",
        legend.title = element_text(face = "bold", size = 24, margin = margin(b = 5)),
        legend.text = element_text(size = 22),
        legend.key.width = unit(2.0, "cm"),
        legend.key.height = unit(1.0, "cm"),
        legend.margin = margin(t = 20),
        legend.box = "horizontal",
        legend.direction = "horizontal",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 30, margin = margin(b = 20)),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "grey98", color = NA),
        strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.4),
        strip.text = element_text(face = "bold", size = 24)
    ) +
    ylim(c(0.5, 1)) +
    scale_x_continuous(breaks = 1:10, labels = 1:10) +
    geom_line(aes(y = mean_mean), linewidth = 1.5, color = "black", linetype = "dashed")

# Save the plot
ggsave("E1_final_test_between_list_prediction.png", plot = p_final_test, 
       width = 12, height = 17, dpi = 300, bg = "white")

cat("Final test between-list prediction plot saved as E1_final_test_between_list_prediction.png\n")
