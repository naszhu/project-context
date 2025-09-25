library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

# ===== SHARED CONSTANTS =====
# Colors
COLOR_FOIL <- "#E08214"
COLOR_TARGET <- "#1A9850"
COLOR_AVERAGE <- "#2C2C2C"

# Shapes
SHAPE_FOIL <- 17                             # solid triangle
SHAPE_TARGET <- 15                      # solid square

# Line types
LINETYPE_FOIL <- "solid"
LINETYPE_TARGET <- "longdash"

ylabsname <- "Correct Response Rate"
xaxisname <- "Position"

# Sizes
BASE_FONT_SIZE <- 28
POINT_SIZE <- 4.5
LINE_WIDTH <- 1.8
AVERAGE_LINE_WIDTH <- 2.2
RIBBON_ALPHA <- 0.25
LINE_ALPHA <- 0.85

# Y-axis limits and breaks
Y_MIN <- 0.75
Y_MAX <- 1.00
Y_BREAKS <- seq(Y_MIN, Y_MAX, by = 0.05)

# X-axis breaks
X_BREAKS <- seq(0, 20, by = 5)
X_LABELS <- as.character(X_BREAKS)

# Theme settings
BASE_TEXT_SIZE <- 28
TITLE_SIZE <- 28
AXIS_TITLE_SIZE <- 28
AXIS_TEXT_SIZE <- 28
LEGEND_POSITION <- "none"  # Hide legends

# Set working directory to data_analysis folder for data plots
# setwd("data_analysis")

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
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

# Create the data plot
data_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=POINT_SIZE, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Facet by position type
  facet_grid(.~position_type) +
      scale_y_continuous(limits = c(Y_MIN, Y_MAX),
                      breaks = Y_BREAKS,
                      name = ylabsname) +
  
  # Enhanced styling and labels
  labs(x=xaxisname,
       y=ylabsname,
       title="E1 Initial Within List DATA",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("Average"=COLOR_AVERAGE, "Foil - Correct rejection"=COLOR_FOIL, "Target - Hits"=COLOR_TARGET)) +
  scale_fill_manual(values=c("Average"=COLOR_AVERAGE, "Foil - Correct rejection"=COLOR_FOIL, "Target - Hits"=COLOR_TARGET)) +
  scale_shape_manual(values=c("Average"=SHAPE_TARGET, "Foil - Correct rejection"=SHAPE_FOIL, "Target - Hits"=SHAPE_TARGET)) +
  scale_linetype_manual(values=c("Average"="dashed", "Foil - Correct rejection"=LINETYPE_FOIL, "Target - Hits"=LINETYPE_TARGET)) +
  
  # Enhanced theme with improved readability
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
        plot.title = element_text(hjust = 0.5, size = TITLE_SIZE, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.8),
        panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
        panel.grid.minor = element_line(color = "gray95", linewidth = 0.3),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
  )

# Save data plot
# ggsave("temp_data_plot.png", data_plot, width = 10, height = 7, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
# setwd("../modeling/R_ploting")

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/all_results.csv")
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

# Create the prediction plot
prediction_plot <- ggplot(data = df_combined, aes(x = position, y = meanx, group = is_target)) +
#     geom_ribbon(aes(ymin = meanx - 0.01, ymax = meanx + 0.01, fill = is_target), alpha = 0.3) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = LINE_WIDTH) +
    geom_point(aes(color = is_target, shape = is_target), size = POINT_SIZE) +
    # Add black average line ONLY for test position
    geom_line(data = df_combined %>% filter(position_type == "Initial Test Position"), 
              aes(x = position, y = meanx_m), color = COLOR_AVERAGE, linewidth = AVERAGE_LINE_WIDTH, linetype = "solid") +
    # Add black square points for the average line
    geom_point(data = df_combined %>% filter(position_type == "Initial Test Position"), 
               aes(x = position, y = meanx_m), color = COLOR_AVERAGE, shape = 15, size = 4) +
    facet_grid(~ position_type, scales = "free_x") +
    scale_color_manual(values = c("Foil - Correct rejection" = COLOR_FOIL, 
                                 "Target - Hits" = COLOR_TARGET),
                      name = "Type") +
    scale_fill_manual(values = c("Foil - Correct rejection" = COLOR_FOIL, 
                                "Target - Hits" = COLOR_TARGET),
                     name = "Type") +
    scale_shape_manual(values = c("Foil - Correct rejection" = SHAPE_FOIL, 
                                 "Target - Hits" = SHAPE_TARGET),
                      name = "Type") +
    scale_linetype_manual(values = c("Foil - Correct rejection" = LINETYPE_FOIL, 
                                    "Target - Hits" = LINETYPE_TARGET),
                         name = "Type") +
    scale_y_continuous(limits = c(Y_MIN, Y_MAX),
                      breaks = Y_BREAKS,
                      name = ylabsname) +
    scale_x_continuous(breaks = X_BREAKS,
                      name = xaxisname) +
    labs(
        title = "E1 Initial Within List PREDICTION",
       #  subtitle = ""
    ) +
    theme_bw(base_size = BASE_FONT_SIZE) +
    theme(
        plot.title = element_text(hjust = 0.5, size = TITLE_SIZE, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold", color = "blue"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.8),
        panel.grid.major = element_line(color = "gray90", linewidth = 0.5),
        panel.grid.minor = element_line(color = "gray95", linewidth = 0.3),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
    )

# Save prediction plot
# ggsave("temp_prediction_plot.png", plot = prediction_plot, 
       # width = 12, height = 7, dpi = 300, bg = "white")

# Go back to main directory
# setwd("../../")

# Load the saved plots as images
# data_img <- readPNG("data_analysis/temp_data_plot.png")
# prediction_img <- readPNG("modeling/R_ploting/temp_prediction_plot.png")

# Convert to raster grobs
# data_grob <- rasterGrob(data_img, interpolate = TRUE)
# prediction_grob <- rasterGrob(prediction_img, interpolate = TRUE)

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_plot, prediction_plot,
  ncol = 2,
  top = textGrob("E1 Initial Within List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_initial_within_list_combined.png", combined_plot, 
       width = 22, height = 7, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
# file.remove("data_analysis/temp_data_plot.png")
# file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined initial within-list plot saved as E1_initial_within_list_combined.png\n")
