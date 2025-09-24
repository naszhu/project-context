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

# Sizes
BASE_FONT_SIZE <- 24
POINT_SIZE <- 4.5
LINE_WIDTH <- 1.8
AVERAGE_LINE_WIDTH <- 2.2
RIBBON_ALPHA <- 0.25
LINE_ALPHA <- 0.85

# Y-axis limits and breaks
Y_MIN <- 0.82
Y_MAX <- 0.96
Y_BREAKS <- seq(Y_MIN, Y_MAX, by = 0.02)

# X-axis breaks
X_BREAKS <- 1:10
X_LABELS <- as.character(X_BREAKS)

# Theme settings
BASE_TEXT_SIZE <- 24
TITLE_SIZE <- 25
AXIS_TITLE_SIZE <- 25
AXIS_TEXT_SIZE <- 25
LEGEND_POSITION <- "none"  # Hide legends

# Set working directory to data_analysis folder for data plots
# setwd("data_analysis")

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
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

# Create the data plot with different shapes and line types
data_plot <- ggplot(data=plot_data, aes(position,meancr,group=interaction(position_type,conditionnow)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=POINT_SIZE, alpha=0.9, stroke=1.5) +
  # Enhanced lines with different line types  
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Enhanced average line with distinctive style
  geom_line(data=plot_data,
            aes(x=position,y=meancr_avg),
            color=COLOR_AVERAGE, linewidth=AVERAGE_LINE_WIDTH, linetype="dashed", alpha=0.9) +
  
  scale_y_continuous(limits = c(Y_MIN, Y_MAX),
                      breaks = Y_BREAKS,
                      name = ylabsname) +
  # Enhanced styling and labels
  labs(x="List number in initial test",
       y=ylabsname,
       title="E1 Initial Between List DATA",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("foil"=COLOR_FOIL, "target"=COLOR_TARGET)) +
  scale_fill_manual(values=c("foil"=COLOR_FOIL, "target"=COLOR_TARGET)) +
  scale_shape_manual(values=c("foil"=SHAPE_FOIL, "target"=SHAPE_TARGET)) +
  scale_linetype_manual(values=c("foil"=LINETYPE_FOIL, "target"=LINETYPE_TARGET)) +
  
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
# ggsave("temp_data_plot.png", data_plot, width = 8, height = 8, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
# setwd("../modeling/R_ploting")

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/all_results.csv")
DF <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/DF.csv")

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

# Create the prediction plot
prediction_plot <- ggplot(data = df_between, aes(x = list_number, y = meanx, group = is_target)) +
    # geom_ribbon(aes(ymin = meanx - ribbon_width, ymax = meanx + ribbon_width, fill = is_target), 
                # alpha = 0.4) +
    geom_line(aes(color = is_target, linetype = is_target), linewidth = LINE_WIDTH) +
    geom_point(aes(color = is_target, shape = is_target), size = POINT_SIZE) +
    geom_line(aes(x = list_number, y = meanx_m), color = COLOR_AVERAGE, linewidth = AVERAGE_LINE_WIDTH, linetype = "dashed") +
    # geom_point(aes(x = list_number, y = meanx_m), color = "black", shape = 15, size = 8) +
    scale_color_manual(values = c("foil" = COLOR_FOIL, "target" = COLOR_TARGET),
                      name = "Type") +
    scale_fill_manual(values = c("foil" = COLOR_FOIL, "target" = COLOR_TARGET),
                     name = "Type") +
    scale_shape_manual(values = c("foil" = SHAPE_FOIL, "target" = SHAPE_TARGET),
                      name = "Type") +
    scale_linetype_manual(values = c("foil" = LINETYPE_FOIL, "target" = LINETYPE_TARGET),
                         name = "Type") +
    scale_y_continuous(limits = c(Y_MIN, Y_MAX),
                      breaks = Y_BREAKS,
                      name = ylabsname) +
    scale_x_continuous(breaks = X_BREAKS,
                      labels = X_LABELS,
                      name = "List number in initial test") +
    labs(title = "E1 Initial Between List PREDICTION",
        #  subtitle = "Figure 3. Between List Initial Test Results") +
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
      #  width = 10, height = 7, dpi = 300, bg = "white")

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
