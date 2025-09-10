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
    geom_point(aes(color = is_target, group = is_target)) +
    # Lines for final_test_order (left column) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "final_test_order"), 
              aes(color = is_target, group = is_target), size = 1.5) +
    # Lines for initial_list_order (right column) - excluding foil (foil will be dots only)
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "initial_list_order" & is_target != "F"), 
              aes(color = is_target, group = is_target), size = 1.5) +
    facet_grid(factor(condition, levels = c("true_random", "backward", "forward")) ~ position_kind) +
    labs(x = "Final test position cut in 10 chunks (left column), Initial test list order (right column)",
         y = "prediction (Hits/Correct Rejection)",
         title = "E1 Final Test Between List data",
         color = "Type", fill = "Type") +
    scale_color_manual(values = c("blue", "yellow", "orange", "green")) +
    theme(
        plot.caption = element_text(hjust = 0, size = 14, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text = element_text(size = 30)
    ) +
    ylim(c(0.5, 1)) +
    geom_line(aes(y = mean_mean), size = 1.5, color = "black") +
    geom_point(aes(y = mean_mean), color = "black", shape = 15, size = 3)

# Save the plot
ggsave("E1_final_test_between_list_prediction.png", plot = p_final_test, 
       width = 12, height = 10, dpi = 300, bg = "white")

cat("Final test between-list prediction plot saved as E1_final_test_between_list_prediction.png\n")
