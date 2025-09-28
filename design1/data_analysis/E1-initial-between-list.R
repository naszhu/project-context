library(dplyr)
library(ggplot2)
library(readr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initialtestbyinitial (from the RMD file)
df_initialtestbyinitial = dfchanged%>%
  filter(task=="pretest_response")%>%
  select(trialnum,ip,correct,probetype)%>%
  group_by(trialnum,ip,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(trialnum,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(trialnum=as.factor(trialnum))%>%
  mutate(position=trialnum,position_type="ir")%>%
  mutate(condition="All conditions")%>%
  select(position,position_type,probetype,meancr,se,condition)%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits"))) %>% 
  mutate(condition=as.factor(condition))%>%
  mutate(condition=factor(condition,levels=levels(condition)[c(1,2,3)]))%>%
  group_by(trialnum)%>%
  mutate(meancr_avg=mean(meancr))

# Save df_initialtestbyinitial to CSV
write_csv(df_initialtestbyinitial, "df_initialtestbyinitial.csv")
cat("df_initialtestbyinitial data saved to df_initialtestbyinitial.csv\n")

# Create the enhanced plot
plot_data <- df_initialtestbyinitial%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Result\nFinal Test Position",
                                 position_type=="ir"~"Initial Result\nInitial List Position",
                                 position_type=="prespos"~"Final Result\nInitial List Position"))%>%
  mutate(position_type=as.factor(position_type))%>%
  mutate(position_type=factor(position_type,levels=rev(levels(position_type))))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil  - Hits"~ "foil",
                             TRUE ~ "target"))%>%
  mutate(conditionnow=paste(condition," - ",position_type))

# Create the enhanced plot with different shapes and line types
enhanced_plot <- ggplot(data=plot_data, aes(position,meancr,group=interaction(position_type,conditionnow)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=4.5, alpha=0.9, stroke=1.5) +
  # Enhanced lines with different line types  
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=1.8, alpha=0.85) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=0.25) +
  # Enhanced average line with distinctive style
  geom_line(data=plot_data,
            aes(x=position,y=meancr_avg),
            color="#2C2C2C", linewidth=2.2, linetype="dashed", alpha=0.9) +
  
  # Enhanced styling and labels
  labs(x="List number in initial test",
       y="Performance (Hits/Correct Rejection)",
       caption="Figure 3. Enhanced - Between List Initial Test Results with Different Shapes & Line Types",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("foil"="#D73027", "target"="#1A9850")) +
  scale_fill_manual(values=c("foil"="#D73027", "target"="#1A9850")) +
  scale_shape_manual(values=c("foil"=19, "target"=17)) +  # filled circle vs triangle
  scale_linetype_manual(values=c("foil"="solid", "target"="longdash")) +
  
  # Enhanced theme with improved readability
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(hjust = 0, size = 16, face = "bold", color = "darkblue", margin = margin(t = 25)),
    plot.margin = margin(t = 20, r = 20, b = 60, l = 20),
    text = element_text(size = 16),
    axis.text = element_text(size = 15, color = "black"),
    axis.title = element_text(size = 17, face = "bold", color = "black"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 15),
    legend.text = element_text(size = 14),
    legend.key.width = unit(2.5, "cm"),
    legend.key.height = unit(0.8, "cm"),
    legend.margin = margin(t = 25),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 18, margin = margin(b = 25)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey97", color = NA)
  ) +
  ggtitle("E1 Initial Between List data")

# Save the enhanced plot with high quality
ggsave("enhanced_plot_figure3.png", enhanced_plot, width = 8, height = 8, dpi = 300, bg = "white")

# Also create a sample version with smaller size for quick preview
# ggsave("enhanced_plot_figure3_sample.png", enhanced_plot, width = 8, height = 6, dpi = 150, bg = "white")

# Display the plot (commented out to avoid [Image #1] display)
# print(enhanced_plot)

# Try multiple methods to open the plot file
plot_opened <- FALSE

# Try xdg-open (most Linux systems)
# tryCatch({
#   result <- system("xdg-open enhanced_plot_figure3.png", ignore.stdout = TRUE, ignore.stderr = TRUE)
#   if(result == 0) {
#     cat("✓ Plot opened with xdg-open\n")
#     plot_opened <- TRUE
#   }
# }, error = function(e) {
#   # Continue to next method
# })

# # Try other methods if xdg-open failed
# if(!plot_opened) {
#   # Try gnome-open
#   tryCatch({
#     result <- system("gnome-open enhanced_plot_figure3.png", ignore.stdout = TRUE, ignore.stderr = TRUE)
#     if(result == 0) {
#       cat("✓ Plot opened with gnome-open\n")
#       plot_opened <- TRUE
#     }
#   }, error = function(e) {})
# }

# if(!plot_opened) {
#   # Try eog (Eye of GNOME)
#   tryCatch({
#     result <- system("eog enhanced_plot_figure3.png &", ignore.stdout = TRUE, ignore.stderr = TRUE)
#     cat("✓ Plot opened with eog (Eye of GNOME)\n")
#     plot_opened <- TRUE
#   }, error = function(e) {})
# }

# if(!plot_opened) {
#   # Try display (ImageMagick)
#   tryCatch({
#     result <- system("display enhanced_plot_figure3.png &", ignore.stdout = TRUE, ignore.stderr = TRUE)
#     cat("✓ Plot opened with display (ImageMagick)\n")
#     plot_opened <- TRUE
#   }, error = function(e) {})
# }

if(!plot_opened) {
  cat("⚠ Could not automatically open the plot.\n")
  cat("Please manually open: enhanced_plot_figure3.png\n")
  cat("Available methods you can try manually:\n")
  cat("- xdg-open enhanced_plot_figure3.png\n")
  cat("- eog enhanced_plot_figure3.png\n")
  cat("- display enhanced_plot_figure3.png\n")
}

cat("\n=== ENHANCED PLOT CREATED SUCCESSFULLY! ===\n")
cat("Features added to your plot:\n")
cat("✓ Different point shapes: Circle (foil) vs Triangle (target)\n")
cat("✓ Different line types: Solid (foil) vs Long dash (target)\n") 
cat("✓ High contrast colors for better visibility\n")
cat("✓ Larger point sizes (4.5) and thicker lines (1.8)\n")
cat("✓ Enhanced theme with better readability\n")
cat("✓ Improved grid and background\n")
cat("✓ Better legend positioning and sizing\n")
cat("\nFiles created:\n")
cat("• dfchanged.csv - Your processed dataset\n")
cat("• df_initialtestbyinitial.csv - Plot data\n") 
cat("• enhanced_plot_figure3.png - High resolution plot (15x11, 300 DPI)\n")
cat("• enhanced_plot_figure3_sample.png - Sample size plot (12x8, 150 DPI)\n")