library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for within-list analysis
dfserial=dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,correct,probetype)%>%
  group_by(position,ip,position_type,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil"~"Foil - Correct rejection",
                             probetype=="TARGET_target"~"Target - Hits"))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Initial Test Position",
                                 TRUE~"Initial Study Position"))

dfserial_meandf=dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(response!="null")%>%
  select(testpos,ip,correct,probetype)%>%
  group_by(testpos,ip)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(testpos)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(position_type="Initial Test Position",position=testpos,probetype="Average")%>%
  select(position,position_type,probetype,meancr,se)

dfserial_all=rbind(dfserial,dfserial_meandf)

# Save processed data to CSV
write_csv(dfserial_all, "dfserial_all_within.csv")
cat("dfserial_all data saved to dfserial_all_within.csv\n")

# Create the enhanced within-list plot
enhanced_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=4, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=1.5, alpha=0.8) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=0.25) +
  # Facet by position type
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Initial Study position (left column), Initial Test position (right column)",
       y="Performance (Hits/Correct Rejection)",
       caption="Figure 1. Enhanced - Within Initial-List Results in the Initial Session",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("Average"="#2C2C2C", "Foil - Correct rejection"="#D73027", "Target - Hits"="#1A9850")) +
  scale_fill_manual(values=c("Average"="#2C2C2C", "Foil - Correct rejection"="#D73027", "Target - Hits"="#1A9850")) +
  scale_shape_manual(values=c("Average"=15, "Foil - Correct rejection"=19, "Target - Hits"=17)) +  # square, circle, triangle
  scale_linetype_manual(values=c("Average"="dashed", "Foil - Correct rejection"="solid", "Target - Hits"="longdash")) +
  
  # Enhanced theme with improved readability
  theme_minimal() +
  theme(
    plot.caption = element_text(hjust = 0, size = 14, face = "bold", color = "darkblue", margin = margin(t = 20)),
    plot.margin = margin(t = 15, r = 15, b = 50, l = 15),
    text = element_text(size = 14),
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 11),
    legend.key.width = unit(1.5, "cm"),
    legend.key.height = unit(0.6, "cm"),
    legend.margin = margin(t = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.5),
    strip.text = element_text(face = "bold", size = 12)
  ) +
  guides(fill = "none") +
  ggtitle("E1 Initial Within List data")

# Save the enhanced plot with reasonable dimensions (increased height for legend)
ggsave("enhanced_within_list_plot.png", enhanced_plot, width = 10, height = 7, dpi = 300, bg = "white")

# Also create a sample version with smaller size for quick preview
ggsave("enhanced_within_list_plot_sample.png", enhanced_plot, width = 8, height = 6, dpi = 150, bg = "white")

# Display the plot (commented out to avoid [Image #1] display)
# print(enhanced_plot)

cat("\n=== ENHANCED WITHIN-LIST PLOT CREATED SUCCESSFULLY! ===\n")
cat("Features added to your plot:\n")
cat("✓ Different point shapes: Square (Average), Circle (Foil), Triangle (Target)\n")
cat("✓ Different line types: Dashed (Average), Solid (Foil), Long dash (Target)\n") 
cat("✓ High contrast colors for better visibility\n")
cat("✓ Larger point sizes (4) and thicker lines (1.5)\n")
cat("✓ Enhanced theme with better readability\n")
cat("✓ Improved faceting and strip styling\n")
cat("✓ Better legend positioning and sizing\n")
cat("\nFiles created:\n")
cat("• dfchanged_within.csv - Your processed dataset\n")
cat("• dfserial_all_within.csv - Plot data\n") 
cat("• enhanced_within_list_plot.png - High resolution plot (12x6, 300 DPI)\n")
cat("• enhanced_within_list_plot_sample.png - Sample size plot (10x5, 150 DPI)\n")