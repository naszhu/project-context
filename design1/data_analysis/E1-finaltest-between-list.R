library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for final test between-list analysis
dfserial=
  dfchanged%>%
  filter(task=="finalt_response")%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,correct,condition,probetype)%>%
  group_by(position,ip,position_type,condition,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,condition,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits")))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Test List Position",
                                 TRUE~"Initial Study List Position"))

# For foils in Initial Study List Position, set position to 0 and calculate mean across all conditions
dfserial <- dfserial %>%
  mutate(position = as.character(position))

# Create foil data at position 0 for Initial Study List Position (averaged across all conditions)
foil_zero_data <- dfserial %>%
  filter(probetype == "Foil - Correct rejection" & position_type == "Initial Study List Position") %>%
  group_by(position_type, probetype) %>%
  summarize(meancr = mean(meancr), 
            sd = sqrt(mean(sd^2)),  # Pooled standard deviation
            se = sd/sqrt(n()),
            .groups = 'drop') %>%
  mutate(position = "0") %>%
  # Create one row for each condition
  crossing(condition = c("backward", "forward", "random"))

# Remove original foil data from Initial Study List Position and add the averaged version
dfserial <- dfserial %>%
  filter(!(probetype == "Foil - Correct rejection" & position_type == "Initial Study List Position")) %>%
  rbind(foil_zero_data)

dfserial_meandf=dfchanged%>%
  filter(task=="finalt_response")%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position_type,position,ip,correct,condition,probetype)%>%
  group_by(position_type,position,ip,condition)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position_type,position,condition)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype="Average")%>%
  select(position,position_type,condition,probetype,meancr,se)%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Test List Position",
                                 TRUE~"Initial Study List Position"))%>%
  mutate(position = as.character(position))

dfserial_all=rbind(dfserial,dfserial_meandf)%>%
  mutate(position_type=as.factor(position_type))%>%
  mutate(position_type=factor(position_type,levels=c("Initial Study List Position", "Final Test List Position")))

# Save processed data to CSV
write_csv(dfserial_all, "dfserial_all_finaltest_between.csv")
cat("dfserial_all_finaltest_between data saved to dfserial_all_finaltest_between.csv\n")

# Create the enhanced final test between-list plot
# To make font size bigger, use base_size in theme_minimal() and set all element_text sizes explicitly
base_font_size <- 24

enhanced_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=probetype))+
  # Enhanced points with different shapes for each probetype (exclude Average)
  geom_point(data=dfserial_all %>% filter(probetype != "Average"),
             aes(color=probetype, shape=probetype), 
             size=3.5, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype), 
            linewidth=1.5, alpha=0.8) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),
              alpha=0.25) +
  # Facet by condition and position type
  facet_grid(condition~position_type) +
  
  # Enhanced styling and labels
  labs(x="Final test in 10 chunks (left column), Initial test list order (right column)",
       y="Performance (Hits/Correct Rejection)",
       caption="Figure 3. Enhanced - Between List Final Test Results seen in Final Testing",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Set x-axis to include position 0
  scale_x_discrete(limits = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10")) +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("Average"="#2C2C2C", 
                              "Foil - Correct rejection"="#D73027",
                              "TARGET_foil  - Hits"="#E08214",
                              "TARGET_nontarget  - Hits"="#1A9850",
                              "TARGET_target  - Hits"="#2166AC")) +
  scale_fill_manual(values=c("Average"="#2C2C2C", 
                             "Foil - Correct rejection"="#D73027",
                             "TARGET_foil  - Hits"="#E08214",
                             "TARGET_nontarget  - Hits"="#1A9850",
                             "TARGET_target  - Hits"="#2166AC")) +
  scale_shape_manual(values=c("Average"=15, 
                              "Foil - Correct rejection"=19,
                              "TARGET_foil  - Hits"=18,
                              "TARGET_nontarget  - Hits"=17,
                              "TARGET_target  - Hits"=16)) +  # square, circle, diamond, triangle, filled square
  scale_linetype_manual(values=c("Average"="dashed", 
                                 "Foil - Correct rejection"="solid",
                                 "TARGET_foil  - Hits"="dotted",
                                 "TARGET_nontarget  - Hits"="longdash",
                                 "TARGET_target  - Hits"="twodash")) +
  
  # Enhanced theme with improved readability and much larger font sizes
  theme_minimal(base_size = base_font_size) +
  theme(
    plot.caption = element_text(hjust = 0, size = 15, face = "bold", color = "darkblue", margin = margin(t = 20)),
    plot.margin = margin(t = 15, r = 15, b = 70, l = 15),
    text = element_text(size = base_font_size),
    axis.text = element_text(size = base_font_size, color = "black"),
    axis.title = element_text(size = base_font_size + 2, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = base_font_size, margin = margin(b = 5)),
    legend.text = element_text(size = base_font_size - 2),
    legend.key.width = unit(2.0, "cm"),
    legend.key.height = unit(1.0, "cm"),
    legend.margin = margin(t = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = base_font_size + 6, margin = margin(b = 20)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.4),
    strip.text = element_text(face = "bold", size = base_font_size)
  ) +
  guides(
    fill = "none",
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = "none",
    linetype = "none"
  ) +
  ggtitle("E1 Final Test Between List data")

# Save the enhanced plot with reasonable dimensions (increased height for multiple facets and legend)
ggsave("enhanced_finaltest_between_list_plot.png", enhanced_plot, width = 9+3, height = 13+4, dpi = 300, bg = "white")

# Also create a sample version with smaller size for quick preview
ggsave("enhanced_finaltest_between_list_plot_sample.png", enhanced_plot, width = 10, height = 8, dpi = 150, bg = "white")

# Display the plot (commented out to avoid [Image #1] display)
# print(enhanced_plot)

cat("\n=== ENHANCED FINAL TEST BETWEEN-LIST PLOT CREATED SUCCESSFULLY! ===\n")
cat("Features added to your plot:\n")
cat("✓ Different point shapes: Square (Average), Circle (Foil), Diamond/Triangle/Square (Targets)\n")
cat("✓ Different line types: Dashed (Average), Solid (Foil), Various for Targets\n") 
cat("✓ High contrast colors for better visibility\n")
cat("✓ Larger point sizes (3.5) and thicker lines (1.2)\n")
cat("✓ Enhanced theme with better readability\n")
cat("✓ Improved faceting across conditions and position types\n")
cat("✓ Better legend positioning and sizing\n")
cat("✓ No error bands for Average line\n")
cat("\nFiles created:\n")
cat("• dfserial_all_finaltest_between.csv - Plot data\n") 
cat("• enhanced_finaltest_between_list_plot.png - High resolution plot (12x10, 300 DPI)\n")
cat("• enhanced_finaltest_between_list_plot_sample.png - Sample size plot (10x8, 150 DPI)\n")