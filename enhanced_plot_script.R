library(ggplot2)
library(dplyr)
library(readr)

# Load the required data from the RMD file environment
# First, we need to run the data processing from the original RMD

# Source the data processing code to get dfchanged
source_file <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/R_IMPORTANT_USED_DESIGN1_tempesti_v3.rmd"

# Since we can't directly source an RMD file, let's create the df_initialtestbyinitial data
# We'll need to load the original data first

# For now, let's create a placeholder that shows the structure we need
# The user should provide the dfchanged data or we need to extract it from the RMD

# Create the df_initialtestbyinitial dataset structure based on what we found in the RMD
# This will need the actual dfchanged data to work

create_enhanced_plot <- function(df_initialtestbyinitial) {
  
  # First, let's save the original data to CSV
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
  
  # Create the original plot
  original_plot <- ggplot(data = plot_data, 
                         aes(position, meancr, group = interaction(position_type, conditionnow))) +
    geom_point(aes(color = probetype, group = probetype)) +
    geom_line(aes(color = probetype, group = probetype)) +
    geom_ribbon(aes(ymin = meancr - se, ymax = meancr + se, fill = probetype, group = probetype), alpha = 0.3) +
    labs(x = "List number in initial test",
         y = "performance (Hits/Correct Rejection)",
         caption = "Figure 3. Between List Initial Test Results",
         color = "Type", fill = "Type") +
    scale_color_manual(values = c("#56B4E9", "#E69F00", "#009E73", "#F0E442")) +
    scale_fill_manual(values = c("#56B4E9", "#E69F00", "#009E73", "#F0E442")) +
    theme(
      plot.caption = element_text(hjust = 0, size = 14, face = "bold"),
      plot.margin = margin(t = 10, b = 40),
      text = element_text(size = 15),
      strip.text.y = element_text(angle = 0, hjust = 0.5)
    ) +
    geom_line(data = plot_data,
              aes(x = position, y = meancr_avg),
              color = "black", size = 1.2)
  
  # Create the enhanced plot with different shapes and line types
  enhanced_plot <- ggplot(data = plot_data, 
                         aes(position, meancr, group = interaction(position_type, conditionnow))) +
    # Enhanced points with different shapes for each probetype
    geom_point(aes(color = probetype, shape = probetype, group = probetype), 
               size = 3, alpha = 0.8) +
    # Enhanced lines with different line types
    geom_line(aes(color = probetype, linetype = probetype, group = probetype), 
              size = 1.2, alpha = 0.9) +
    # Enhanced ribbon with better visibility
    geom_ribbon(aes(ymin = meancr - se, ymax = meancr + se, fill = probetype, group = probetype), 
                alpha = 0.2) +
    # Enhanced average line with dashed style
    geom_line(data = plot_data,
              aes(x = position, y = meancr_avg),
              color = "black", size = 1.5, linetype = "dashed", alpha = 0.8) +
    
    # Enhanced styling
    labs(x = "List number in initial test",
         y = "Performance (Hits/Correct Rejection)",
         caption = "Figure 3. Enhanced - Between List Initial Test Results",
         color = "Type", fill = "Type", shape = "Type", linetype = "Type") +
    
    # Enhanced color palette with better contrast
    scale_color_manual(values = c("foil" = "#D55E00", "target" = "#0072B2")) +
    scale_fill_manual(values = c("foil" = "#D55E00", "target" = "#0072B2")) +
    scale_shape_manual(values = c("foil" = 16, "target" = 17)) +  # circle vs triangle
    scale_linetype_manual(values = c("foil" = "solid", "target" = "longdash")) +
    
    # Enhanced theme
    theme_minimal() +
    theme(
      plot.caption = element_text(hjust = 0, size = 14, face = "bold", color = "darkblue"),
      plot.margin = margin(t = 10, b = 40),
      text = element_text(size = 15),
      strip.text.y = element_text(angle = 0, hjust = 0.5),
      panel.grid.major = element_line(alpha = 0.3),
      panel.grid.minor = element_line(alpha = 0.1),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      axis.title = element_text(face = "bold"),
      plot.title = element_text(face = "bold", hjust = 0.5)
    ) +
    ggtitle("Enhanced Plot with Different Shapes and Line Types")
  
  # Save the enhanced plot
  ggsave("enhanced_plot_figure3.png", enhanced_plot, width = 12, height = 8, dpi = 300)
  
  # Display the plot
  print(enhanced_plot)
  
  # Also save the original for comparison
  ggsave("original_plot_figure3.png", original_plot, width = 12, height = 8, dpi = 300)
  
  return(enhanced_plot)
}

# Print instructions for the user
cat("To use this script:\n")
cat("1. Make sure your dfchanged dataset is loaded in your R environment\n")
cat("2. Run the data processing code to create df_initialtestbyinitial\n") 
cat("3. Call: create_enhanced_plot(df_initialtestbyinitial)\n")
cat("\nThe script will:\n")
cat("- Save the data to CSV\n")
cat("- Create an enhanced plot with different shapes and line types\n")
cat("- Save both original and enhanced plots as PNG files\n")
cat("- Display the enhanced plot\n")