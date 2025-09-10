library(ggplot2)
library(dplyr)
library(readr)

# Load your data - you'll need to modify this path to your actual data file
# Replace this with the correct path to your data
df <- read_csv("your_data_file.csv")  # Update this path

# Data processing code extracted from the RMD file
dfchanged = df %>%
  mutate(rt = as.numeric(rt))

# Create df_initialtestbyinitial
df_initialtestbyinitial = dfchanged %>%
  filter(task == "pretest_response") %>%
  select(trialnum, ip, correct, probetype) %>%
  group_by(trialnum, ip, probetype) %>%
  summarize(meancr1 = mean(correct)) %>%
  group_by(trialnum, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n())) %>%
  mutate(trialnum = as.factor(trialnum)) %>%
  mutate(position = trialnum, position_type = "ir") %>%
  mutate(condition = "All conditions") %>%
  select(position, position_type, probetype, meancr, se, condition) %>%
  mutate(probetype = case_when(probetype == "FOIL" ~ "Foil - Correct rejection",
                               TRUE ~ paste(probetype, " - Hits"))) %>% 
  mutate(condition = as.factor(condition)) %>%
  mutate(condition = factor(condition, levels = levels(condition)[c(1,2,3)])) %>%
  group_by(trialnum) %>%
  mutate(meancr_avg = mean(meancr))

# Save the processed data to CSV
write_csv(df_initialtestbyinitial, "df_initialtestbyinitial.csv")

# Prepare the data for plotting
plot_data <- df_initialtestbyinitial %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Final Result\nFinal Test Position",
    position_type == "ir" ~ "Initial Result\nInitial List Position", 
    position_type == "prespos" ~ "Final Result\nInitial List Position"
  )) %>%
  mutate(position_type = as.factor(position_type)) %>%
  mutate(position_type = factor(position_type, levels = rev(levels(position_type)))) %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil  - Hits" ~ "foil",
    TRUE ~ "target"
  )) %>%
  mutate(conditionnow = paste(condition, " - ", position_type))

# Create the enhanced plot with different shapes and line types
enhanced_plot <- ggplot(data = plot_data, 
                       aes(position, meancr, group = interaction(position_type, conditionnow))) +
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color = probetype, shape = probetype, group = probetype), 
             size = 4, alpha = 0.9, stroke = 1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color = probetype, linetype = probetype, group = probetype), 
            size = 1.5, alpha = 0.8) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin = meancr - se, ymax = meancr + se, fill = probetype, group = probetype), 
              alpha = 0.25) +
  # Enhanced average line with distinctive style
  geom_line(data = plot_data,
            aes(x = position, y = meancr_avg),
            color = "#333333", size = 2, linetype = "dashed", alpha = 0.8) +
  
  # Enhanced styling
  labs(x = "List number in initial test",
       y = "Performance (Hits/Correct Rejection)",
       caption = "Figure 3. Enhanced - Between List Initial Test Results with Different Shapes & Line Types",
       color = "Type", fill = "Type", shape = "Type", linetype = "Type") +
  
  # Enhanced color palette with high contrast and accessibility
  scale_color_manual(values = c("foil" = "#E31A1C", "target" = "#1F78B4")) +
  scale_fill_manual(values = c("foil" = "#E31A1C", "target" = "#1F78B4")) +
  scale_shape_manual(values = c("foil" = 19, "target" = 17)) +  # filled circle vs triangle
  scale_linetype_manual(values = c("foil" = "solid", "target" = "longdash")) +
  
  # Enhanced theme with better visibility
  theme_minimal() +
  theme(
    plot.caption = element_text(hjust = 0, size = 16, face = "bold", color = "darkblue", margin = margin(t = 20)),
    plot.margin = margin(t = 15, r = 15, b = 50, l = 15),
    text = element_text(size = 16),
    axis.text = element_text(size = 14, color = "black"),
    axis.title = element_text(size = 16, face = "bold", color = "black"),
    panel.grid.major = element_line(alpha = 0.4, color = "grey80"),
    panel.grid.minor = element_line(alpha = 0.2, color = "grey90"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 14),
    legend.text = element_text(size = 13),
    legend.key.width = unit(2, "cm"),
    legend.margin = margin(t = 20),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 18, margin = margin(b = 20)),
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)
  ) +
  ggtitle("Enhanced Plot: Different Shapes, Line Types & Improved Visibility") +
  
  # Add subtle background
  theme(plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "grey98", color = NA))

# Save the enhanced plot with high quality
ggsave("enhanced_plot_figure3.png", enhanced_plot, width = 14, height = 10, dpi = 300, bg = "white")

# Display the plot
print(enhanced_plot)

# Open the saved plot file
system("xdg-open enhanced_plot_figure3.png")

cat("Enhanced plot created successfully!\n")
cat("Features added:\n")
cat("- Different point shapes: Circle (foil) vs Triangle (target)\n")
cat("- Different line types: Solid (foil) vs Long dash (target)\n")
cat("- High contrast colors for better visibility\n")
cat("- Larger point sizes and thicker lines\n")
cat("- Enhanced theme with better readability\n")
cat("- Saved as high-resolution PNG: enhanced_plot_figure3.png\n")
cat("- Plot should open automatically\n")