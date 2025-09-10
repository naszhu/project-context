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

# Create df_initialtestbyinitial (from the RMD file) - EXACT COPY FROM ORIGINAL
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

# Create the data plot - EXACT COPY FROM ORIGINAL
plot_data <- df_initialtestbyinitial%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Result\nFinal Test Position",
                                 position_type=="ir"~"Initial Result\nInitial List Position",
                                 position_type=="prespos"~"Final Result\nInitial List Position"))%>%
  mutate(position_type=as.factor(position_type))%>%
  mutate(position_type=factor(position_type,levels=rev(levels(position_type))))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil  - Hits"~ "foil",
                             TRUE ~ "target"))%>%
  mutate(conditionnow=paste(condition," - ",position_type))

# Create the data plot with different shapes and line types - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=plot_data, aes(position,meancr,group=interaction(position_type,conditionnow)))+
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
  
  scale_y_continuous(limits = c(0.82, 0.96),
                      breaks = seq(0.82, 0.96, by = 0.02),
                      name = "Performance (Hits/Correct Rejection)") +
  # Enhanced styling and labels
  labs(x="List number in initial test",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Initial Between List DATA",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("foil"="#D73027", "target"="#1A9850")) +
  scale_fill_manual(values=c("foil"="#D73027", "target"="#1A9850")) +
  scale_shape_manual(values=c("foil"=19, "target"=17)) +  # filled circle vs triangle
  scale_linetype_manual(values=c("foil"="solid", "target"="longdash")) +
  
  # Enhanced theme with improved readability
  theme_minimal() +
  theme(
    plot.caption = element_text(hjust = 0, size = 16, face = "bold", color = "darkblue", margin = margin(t = 25)),
    plot.margin = margin(t = 20, r = 20, b = 60, l = 20),
    text = element_text(size = 16),
    axis.text = element_text(size = 15, color = "black"),
    axis.title = element_text(size = 17, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.5),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.3),
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
  )

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 8, height = 8, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
setwd("../modeling/R_ploting")

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv("../../../all_results.csv")
DF <- read.csv("../../../DF.csv")

df_between <- DF %>% 
    mutate(meanx = case_when(is_target == "true" ~ meanx, TRUE ~ 1 - meanx)) %>%
    mutate(test_position = as.numeric(test_position)) %>%
    group_by(list_number, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = factor(is_target,
                             levels = c("false", "true"),
                             labels = c("foil", "target"))) %>%
    group_by(list_number) %>%
    mutate(meanx_m = mean(meanx))

df_between$is_target <- factor(df_between$is_target,
                              levels = c("foil", "target"),
                              labels = c("foil", "target"))

ribbon_width <- 0.008

# Create the prediction plot - EXACT COPY FROM ORIGINAL
prediction_plot <- ggplot(data = df_between, aes(x = list_number, y = meanx, group = is_target)) +
    # geom_ribbon(aes(ymin = meanx - ribbon_width, ymax = meanx + ribbon_width, fill = is_target), 
                # alpha = 0.4) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = 2) +
    geom_point(aes(color = is_target, shape = is_target), size = 8) +
    geom_line(aes(x = list_number, y = meanx_m), color = "black", linewidth = 2, linetype = "dashed") +
    # geom_point(aes(x = list_number, y = meanx_m), color = "black", shape = 15, size = 8) +
    scale_color_manual(values = c("foil" = "#E74C3C", "target" = "#27AE60"),
                      name = "Type") +
    scale_fill_manual(values = c("foil" = "#E74C3C", "target" = "#27AE60"),
                     name = "Type") +
    scale_shape_manual(values = c("foil" = 16, "target" = 17),
                      name = "Type") +
    scale_linetype_manual(values = c("foil" = "solid", "target" = "dashed"),
                         name = "Type") +
    scale_y_continuous(limits = c(0.82, 0.96),
                      breaks = seq(0.82, 0.96, by = 0.02),
                      name = "Performance (Hits/Correct Rejection)") +
    scale_x_continuous(breaks = 1:10,
                      labels = as.character(1:10),
                      name = "List number in initial test") +
    labs(title = "E1 Initial Between List PREDICTION",
        #  subtitle = "Figure 3. Between List Initial Test Results") +
         ) +
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.8),
        panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
        panel.grid.minor = element_line(color = "gray95", linewidth = 0.3),
        legend.position = "bottom",
        legend.title = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 14),
        text = element_text(size = 16),
        axis.title = element_text(size = 16, face = "bold"),
        axis.text = element_text(size = 14)
    )

# Save prediction plot
ggsave("temp_prediction_plot.png", plot = prediction_plot, 
       width = 10, height = 7, dpi = 300, bg = "white")

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
  top = textGrob("E1 Initial Between List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_initial_between_list_combined.png", combined_plot, 
       width = 18, height = 8, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
file.remove("data_analysis/temp_data_plot.png")
file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined initial between-list plot saved as E1_initial_between_list_combined.png\n")
