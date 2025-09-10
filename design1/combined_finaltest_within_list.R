library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

# Set working directory to data_analysis folder for data plots
setwd("data_analysis")

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initial data - EXACT COPY FROM ORIGINAL
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

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=df_finalwithin,
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
       title="E1 Final Test Within List DATA",
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
  )

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
setwd("../modeling/R_ploting")

# Check if final test is enabled
if (!file.exists("../../../allresf.csv")) {
    cat("⚠️  allresf.csv not found. This means is_finaltest = false in constants.jl\n")
    cat("Skipping final test within-list plot generation.\n")
    quit(save = "no", status = 0)
}

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
dfchanged <- read.csv("../../data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from data_analysis/dfchanged.csv\n")

# Create the within-list final test plot with enhanced styling - EXACT COPY FROM ORIGINAL
# This matches the structure shown in the image with two panels and three data series

# Create df_initial data (exactly as in your script)
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

# Create the prediction plot - EXACT COPY FROM ORIGINAL
prediction_plot <- ggplot(data=df_finalwithin,
                        aes(position,meancr,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=4, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=1.5, alpha=0.8) +
  # Enhanced ribbon with better visibility
#   geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
            #   alpha=0.25) +
  # Facet by position type
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Initial Study position (left column), Initial Test position (right column)",
       y="Hit Rate",
       title="E1 Final Test Within List PREDICTION",
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
  ylim(c(0.5, 0.95))

# Save prediction plot
ggsave("temp_prediction_plot.png", prediction_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Go back to main directory
setwd("../../")

# Load the saved plots as images
data_img <- readPNG("data_analysis/temp_data_plot.png")
prediction_img <- readPNG("modeling/R_ploting/temp_prediction_plot.png")

# Convert to raster grobs
data_grob <- rasterGrob(data_img, interpolate = TRUE)
prediction_grob <- rasterGrob(prediction_img, interpolate = TRUE)

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_grob, prediction_grob,
  ncol = 2,
  top = textGrob("E1 Final Test Within List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_final_test_within_list_combined.png", combined_plot, 
       width = 20, height = 9, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
file.remove("data_analysis/temp_data_plot.png")
file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined final test within-list plot saved as E1_final_test_within_list_combined.png\n")
