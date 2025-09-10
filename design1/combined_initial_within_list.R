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

# Create dfserial data for within-list analysis - EXACT COPY FROM ORIGINAL
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

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=interaction(position_type)))+
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
      scale_y_continuous(limits = c(0.75, 1.00),
                      breaks = seq(0.75, 1.00, by = 0.05),
                      name = "Performance (Hits/Correct Rejection)") +
  
  # Enhanced styling and labels
  labs(x="Initial Study position (left column), Initial Test position (right column)",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Initial Within List DATA",
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
    panel.grid.major = element_line(color = "grey75", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
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
  guides(fill = "none")

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 10, height = 7, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
setwd("../modeling/R_ploting")

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv("../../../all_results.csv")

df_study <- all_results %>%
    mutate(is_target = case_when(is_target == "true" ~ 1, TRUE ~ 0),
           correct = decision_isold == is_target) %>%
    group_by(study_position, is_target, simulation_number) %>%
    summarize(meanx = mean(correct), .groups = "drop") %>%
    group_by(study_position, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = as.factor(is_target),
           position_type = "Study") %>%
    rename(position = study_position) %>%
    group_by(position) %>%
    mutate(meanx_m = mean(meanx))

df_test <- all_results %>%
    mutate(is_target = case_when(is_target == "true" ~ 1, TRUE ~ 0),
           correct = decision_isold == is_target) %>%
    group_by(test_position, is_target, simulation_number) %>%
    summarize(meanx = mean(correct), .groups = "drop") %>%
    group_by(test_position, is_target) %>%
    summarize(meanx = mean(meanx), .groups = "drop") %>%
    mutate(is_target = as.factor(is_target),
           position_type = "Test") %>%
    rename(position = test_position) %>%
    group_by(position) %>%
    mutate(meanx_m = mean(meanx))

df_combined <- rbind(df_study, df_test)

df_combined$is_target <- factor(df_combined$is_target, 
                               levels = c("0", "1"),
                               labels = c("Foil - Correct rejection", "Target - Hits"))

df_combined$position_type <- factor(df_combined$position_type,
                                   levels = c("Study", "Test"),
                                   labels = c("Initial Study Position", "Initial Test Position"))

# Create the prediction plot - EXACT COPY FROM ORIGINAL
prediction_plot <- ggplot(data = df_combined, aes(x = position, y = meanx, group = is_target)) +
#     geom_ribbon(aes(ymin = meanx - 0.01, ymax = meanx + 0.01, fill = is_target), alpha = 0.3) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = 1.5) +
    geom_point(aes(color = is_target, shape = is_target), size = 6) +
    # Add black average line ONLY for test position
    geom_line(data = df_combined %>% filter(position_type == "Initial Test Position"), 
              aes(x = position, y = meanx_m), color = "black", linewidth = 2, linetype = "solid") +
    # Add black square points for the average line
    geom_point(data = df_combined %>% filter(position_type == "Initial Test Position"), 
               aes(x = position, y = meanx_m), color = "black", shape = 15, size = 4) +
    facet_grid(~ position_type, scales = "free_x") +
    scale_color_manual(values = c("Foil - Correct rejection" = "#E74C3C", 
                                 "Target - Hits" = "#27AE60"),
                      name = "Type") +
    scale_fill_manual(values = c("Foil - Correct rejection" = "#E74C3C", 
                                "Target - Hits" = "#27AE60"),
                     name = "Type") +
    scale_shape_manual(values = c("Foil - Correct rejection" = 16, 
                                 "Target - Hits" = 17),
                      name = "Type") +
    scale_linetype_manual(values = c("Foil - Correct rejection" = "solid", 
                                    "Target - Hits" = "dotted"),
                         name = "Type") +
    scale_y_continuous(limits = c(0.75, 1.00),
                      breaks = seq(0.75, 1.00, by = 0.05),
                      name = "Performance (Hits/Correct Rejection)") +
    scale_x_continuous(breaks = seq(0, 20, by = 5),
                      name = "Initial Study position (left column), Initial Test position (right column)") +
    labs(
        title = "E1 Initial Within List PREDICTION",
        subtitle = ""
    ) +
    theme_minimal() +
    theme(
        plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        strip.text = element_text(size = 18, face = "bold"),
        strip.background = element_rect(fill = "lightgray", color = "black"),
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
       width = 12, height = 7, dpi = 300, bg = "white")

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
  top = textGrob("E1 Initial Within List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_initial_within_list_combined.png", combined_plot, 
       width = 22, height = 7, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
file.remove("data_analysis/temp_data_plot.png")
file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined initial within-list plot saved as E1_initial_within_list_combined.png\n")
