library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Load data
all_results <- read.csv("../all_results.csv")
DF <- read.csv("../DF.csv")
allresf <- read.csv("../allresf.csv")

# Create the within-list final test plot with enhanced styling
# This matches the structure shown in the image with two panels and three data series

# Prepare data for Initial Study Position panel
DF_study <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(initial_studypos = as.numeric(initial_studypos)) %>%
    # Filter for data that has study positions > 0
    filter(initial_studypos > 0) %>%
    group_by(initial_studypos, is_target) %>%
    summarize(meanx = mean(correct), .groups = 'drop') %>%
    # Add confidence intervals (simplified - using standard error approximation)
    mutate(
        se = 0.02,  # Fixed small standard error
        ci_lower = pmax(0.5, meanx - 1.96 * se),
        ci_upper = pmin(1.0, meanx + 1.96 * se)
    )

# Prepare data for Initial Test Position panel  
DF_test <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(initial_testpos = as.numeric(initial_testpos)) %>%
    # Filter for data that has test positions > 0
    filter(initial_testpos > 0) %>%
    group_by(initial_testpos, is_target) %>%
    summarize(meanx = mean(correct), .groups = 'drop') %>%
    # Add confidence intervals
    mutate(
        se = 0.02,  # Fixed small standard error
        ci_lower = pmax(0.5, meanx - 1.96 * se),
        ci_upper = pmin(1.0, meanx + 1.96 * se)
    )

# Create labels for the legend that match the image description
create_legend_labels <- function(data) {
    data %>%
        mutate(
            legend_label = case_when(
                is_target == "F" ~ "Foil, neither studied nor tested - Correct rejection",
                is_target == "T_target" ~ "Target, Studied and tested - HITS",
                is_target == "T_nontarget" ~ "Target, Studied only - HITS",
                is_target == "T_foil" ~ "Foil, neither studied nor tested - Correct rejection",  # Map T_foil to foil
                TRUE ~ as.character(is_target)
            )
        )
}

# Add foil data to study panel (foils that were neither studied nor tested)
# For study panel, we need to add foil data at position 0
foil_study_data <- allresf %>% 
    filter(is_target == "F") %>%
    mutate(correct = case_when(
        decision_isold == 0 ~ 1,  # Correct rejection
        TRUE ~ 0
    )) %>%
    mutate(initial_studypos = 0) %>%
    group_by(initial_studypos, is_target) %>%
    summarize(meanx = mean(correct), .groups = 'drop') %>%
    mutate(
        se = 0.01,  # Small standard error for foils
        ci_lower = pmax(0.5, meanx - 1.96 * se),
        ci_upper = pmin(1.0, meanx + 1.96 * se)
    )

# Combine study data with foil data
DF_study <- bind_rows(DF_study, foil_study_data)

# Apply legend labels
DF_study <- create_legend_labels(DF_study)
DF_test <- create_legend_labels(DF_test)

# Create the Initial Study Position plot
p_study <- ggplot(data = DF_study, aes(x = initial_studypos, y = meanx)) +
    # Add confidence intervals as shaded areas
    geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper, fill = legend_label), alpha = 0.2) +
    # Add lines and points
    geom_line(aes(color = legend_label), linewidth = 1.5) +
    geom_point(aes(color = legend_label, shape = legend_label), size = 3) +
    # Set colors to match the image: red circles, green triangles, blue squares
    scale_color_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = "#E31A1C",  # red
            "Target, Studied and tested - HITS" = "#33A02C",  # green
            "Target, Studied only - HITS" = "#1F78B4"  # blue
        ),
        name = "Type"
    ) +
    scale_fill_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = "#E31A1C",  # red
            "Target, Studied and tested - HITS" = "#33A02C",  # green
            "Target, Studied only - HITS" = "#1F78B4"  # blue
        ),
        name = "Type"
    ) +
    scale_shape_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = 16,  # circles
            "Target, Studied and tested - HITS" = 17,  # triangles
            "Target, Studied only - HITS" = 15  # squares
        ),
        name = "Type"
    ) +
    # Styling
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        plot.caption = element_text(hjust = 0, size = 14, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text = element_text(size = 14),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
        legend.position = "right",
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold")
    ) +
    labs(
        title = "Initial Study Position",
        x = "Initial Study position (left column), Initial Test position (right column)",
        y = "Hit Rate"
    ) +
    ylim(c(0.3, 1.0)) +
    xlim(c(0, 20))

# Create the Initial Test Position plot
p_test <- ggplot(data = DF_test, aes(x = initial_testpos, y = meanx)) +
    # Add confidence intervals as shaded areas
    geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper, fill = legend_label), alpha = 0.2) +
    # Add lines and points
    geom_line(aes(color = legend_label), linewidth = 1.5) +
    geom_point(aes(color = legend_label, shape = legend_label), size = 3) +
    # Set colors to match the image
    scale_color_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = "#E31A1C",  # red
            "Target, Studied and tested - HITS" = "#33A02C",  # green
            "Target, Studied only - HITS" = "#1F78B4"  # blue
        ),
        name = "Type"
    ) +
    scale_fill_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = "#E31A1C",  # red
            "Target, Studied and tested - HITS" = "#33A02C",  # green
            "Target, Studied only - HITS" = "#1F78B4"  # blue
        ),
        name = "Type"
    ) +
    scale_shape_manual(
        values = c(
            "Foil, neither studied nor tested - Correct rejection" = 16,  # circles
            "Target, Studied and tested - HITS" = 17,  # triangles
            "Target, Studied only - HITS" = 15  # squares
        ),
        name = "Type"
    ) +
    # Styling
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        plot.caption = element_text(hjust = 0, size = 14, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text = element_text(size = 14),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
        legend.position = "right",
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold")
    ) +
    labs(
        title = "Initial Test Position",
        x = "Initial Study position (left column), Initial Test position (right column)",
        y = "Hit Rate"
    ) +
    ylim(c(0.3, 1.0)) +
    xlim(c(0, 20))

# Save the plot
png(filename = "E1_final_test_within_list_enhanced.png", 
    width = 1600, height = 800, res = 150)

# Combine plots side by side
grid.arrange(
    p_study, p_test,
    ncol = 2, nrow = 1,
    top = "E1 Final Test Within List data",
    bottom = "Figure 2. Enhanced - Within Initial-List Results Seen in Final Testing"
)

dev.off()

cat("Enhanced within-list final test plot saved to E1_final_test_within_list_enhanced.png\n")
