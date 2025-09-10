library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initial data
df_initial=dfchanged%>%
  # filter(trialnum!=1)%>%
  filter(task=="pretest_response")%>%
  # filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,stimulus_id)

wordlists_intest = dfchanged%>%
  filter(task=="pretest_response")%>%group_by(ip)%>%summarize(words=list(stimulus_id))

df_initial_study =
  dfchanged%>%filter(task=="pretest_study")%>%
  # filter(trialnum!=1)%>%
  left_join(wordlists_intest,by="ip")%>%
  rowwise()%>%
  filter(!(stimulus_id%in%unlist(words)))%>%#here get study only
  mutate(position=prespos,position_type="prespos")%>%
  select(position,position_type,ip,stimulus_id)
  
df_initial_all=rbind(df_initial,df_initial_study)  

df_final = dfchanged%>%
  filter(task=="finalt_response")%>%
  # filter(prespos_itrial!=1)%>%
  filter(probetype!="FOIL") %>% #foil doesn't have inital test position 
  filter(response!="null")%>%
  select(ip,correct,probetype,stimulus_id)

#now, combine initial test positions with final test correct, 
# intial test add column position_type (intial/final), position
# final test add column correct(1/0) and probetype (3 kinds of Target and foil)

df_finalwithin=
  df_final%>%left_join(df_initial_all,by=c("ip","stimulus_id"))%>%
  filter(!is.na(correct))%>%
  group_by(position,ip,position_type,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil"~"Foil, neither studied nor tested  - Correct rejection",
                             probetype=="TARGET_target"~"Target, Studied and tested - HITS",
                             probetype=="TARGET_nontarget"~"Target, Studied only - HITS"))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Initial Test Position",
                                 position_type=="prespos"~"Initial Study Position"))

# Save processed data to CSV
write_csv(df_finalwithin, "df_finalwithin.csv")
cat("df_finalwithin data saved to df_finalwithin.csv\n")

# Create the enhanced final test within-list plot
enhanced_plot <- ggplot(data=df_finalwithin,
                        aes(position,meancr,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=4, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=1.5, alpha=0.8) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=0.25) +
  # Facet by position type
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Initial Study position (left column), Initial Test position (right column)",
       y="Hit Rate",
       caption="Figure 2. Enhanced - Within Initial-List Results Seen in Final Testing",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="#D73027", 
                              "Target, Studied and tested - HITS"="#1A9850",
                              "Target, Studied only - HITS"="#2166AC")) +
  scale_fill_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="#D73027", 
                             "Target, Studied and tested - HITS"="#1A9850",
                             "Target, Studied only - HITS"="#2166AC")) +
  scale_shape_manual(values=c("Foil, neither studied nor tested  - Correct rejection"=19, 
                              "Target, Studied and tested - HITS"=17,
                              "Target, Studied only - HITS"=15)) +  # circle, triangle, square
  scale_linetype_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="solid", 
                                 "Target, Studied and tested - HITS"="longdash",
                                 "Target, Studied only - HITS"="dotted")) +
  
  # Enhanced theme with improved readability and larger legend
  theme_minimal() +
  theme(
    plot.caption = element_text(hjust = 0, size = 14, face = "bold", color = "darkblue", margin = margin(t = 20)),
    plot.margin = margin(t = 15, r = 15, b = 60, l = 15),
    text = element_text(size = 14),
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 16),   # Increased legend title size
    legend.text = element_text(size = 14),                   # Increased legend text size
    legend.key.width = unit(2.2, "cm"),                      # Make legend wider
    legend.key.height = unit(0.8, "cm"),
    legend.margin = margin(t = 25),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    legend.box.just = "center",
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.5),
    strip.text = element_text(face = "bold", size = 12)
  ) +
  guides(
    fill = "none",
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    linetype = guide_legend(nrow = 3, byrow = TRUE, title.position = "top")
  ) +
  ggtitle("E1 Final Test Within List data")

# Save the enhanced plot with reasonable dimensions (increased height for legend)
ggsave("enhanced_finaltest_within_list_plot.png", enhanced_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Also create a sample version with smaller size for quick preview
ggsave("enhanced_finaltest_within_list_plot_sample.png", enhanced_plot, width = 10, height = 6, dpi = 150, bg = "white")

# Display the plot (commented out to avoid [Image #1] display)
# print(enhanced_plot)

cat("\n=== ENHANCED FINAL TEST WITHIN-LIST PLOT CREATED SUCCESSFULLY! ===\n")
cat("Features added to your plot:\n")
cat("✓ Different point shapes: Circle (Foil), Triangle (Target-both), Square (Target-study only)\n")
cat("✓ Different line types: Solid (Foil), Long dash (Target-both), Dotted (Target-study only)\n") 
cat("✓ High contrast colors for better visibility\n")
cat("✓ Larger point sizes (4) and thicker lines (1.5)\n")
cat("✓ Enhanced theme with better readability\n")
cat("✓ Improved faceting and strip styling\n")
cat("✓ Better legend positioning and sizing\n")
cat("\nFiles created:\n")
cat("• df_finalwithin.csv - Plot data\n") 
cat("• enhanced_finaltest_within_list_plot.png - High resolution plot (12x8, 300 DPI)\n")
cat("• enhanced_finaltest_within_list_plot_sample.png - Sample size plot (10x6, 150 DPI)\n")