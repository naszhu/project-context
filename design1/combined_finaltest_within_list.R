library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

###################################3333
## Constants for styling - UNIFIED FORMATTING
#####################################3
# Unified constants for both plots
BASE_FONT_SIZE <- 24
POINT_SIZE <- 5
LINE_WIDTH <- 1.5
TITLE_SIZE <- BASE_FONT_SIZE + 6
STRIP_TEXT_SIZE <- BASE_FONT_SIZE + 4
AXIS_TITLE_SIZE <- BASE_FONT_SIZE + 6
AXIS_TEXT_SIZE <- BASE_FONT_SIZE
CAPTION_SIZE <- 15

# Margins and spacing
PLOT_MARGIN_TOP <- 15
PLOT_MARGIN_RIGHT <- 15
PLOT_MARGIN_BOTTOM <- 70
PLOT_MARGIN_LEFT <- 15
TITLE_MARGIN_BOTTOM <- 20
CAPTION_MARGIN_TOP <- 20

# Grid and panel styling
GRID_MAJOR_COLOR <- "grey75"
GRID_MAJOR_WIDTH <- 0.3
GRID_MINOR_COLOR <- "grey85"
GRID_MINOR_WIDTH <- 0.2
PANEL_BORDER_WIDTH <- 0.5
PANEL_BACKGROUND <- "grey98"
STRIP_BACKGROUND <- "grey90"
STRIP_BORDER_WIDTH <- 0.4

# Point styling
POINT_ALPHA <- 1
POINT_STROKE <- 1.2
LINE_ALPHA <- 1
RIBBON_ALPHA <- 0.5

# Set working directory to data_analysis folder for data plots
# setwd("data_analysis")

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
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
  # filter(probetype!="FOIL") %>% #foil doesn't have inital test position 

  filter(response!="null")%>%
  select(ip,correct,probetype,stimulus_id)

#now, combine initial test positions with final test correct, 
# intial test add column position_type (intial/final), position
# final test add column correct(1/0) and probetype (3 kinds of Target and foil)

# First, calculate FOIL performance separately (since FOIL doesn't have initial positions)
foil_performance <- df_final %>%
  filter(probetype == "FOIL") %>%
  group_by(ip, probetype) %>%
  summarize(meancr1 = mean(correct)) %>%
  group_by(probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n())) %>%
  mutate(position = 0, position_type = "both") # Use "both" to indicate it should appear in both facets

# Process non-FOIL data normally
df_finalwithin_nonfoil = df_final %>%
  filter(probetype != "FOIL") %>%
  left_join(df_initial_all, by = c("ip", "stimulus_id")) %>%
  filter(!is.na(correct)) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1 = mean(correct)) %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()))

# Combine and create duplicate FOIL rows for both facets (like pivot_longer does)
df_finalwithin = df_finalwithin_nonfoil %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil, neither studied nor tested  - Correct rejection",
    probetype == "TARGET_target" ~ "Target, Studied and tested - HITS",
    probetype == "TARGET_nontarget" ~ "Target, Studied only - HITS"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Initial Test Position",
    position_type == "prespos" ~ "Initial Study Position"
  )) %>%
  # Add FOIL data for both facets
  bind_rows(
    foil_performance %>% 
      mutate(position_type = "Initial Study Position", probetype = "FOIL") %>%
      select(position, position_type, probetype, meancr, sd, se)
  ) %>%
  bind_rows(
    foil_performance %>% 
      mutate(position_type = "Initial Test Position", probetype = "FOIL") %>%
      select(position, position_type, probetype, meancr, sd, se)
  ) %>%
  mutate(position = as.numeric(position))

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=df_finalwithin,
                        aes(position,meancr,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype), 
             size=POINT_SIZE, alpha=POINT_ALPHA, stroke=POINT_STROKE) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype), 
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Facet by position type
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Position",
       y="Hit Rate",
       title="E1 Final Test Within List DATA",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced color palette with high contrast
  scale_color_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="#E08214", 
                              "Target, Studied and tested - HITS"="#2166AC",
                              "Target, Studied only - HITS"="#1A9850",
                              "FOIL"="red" )) +
  scale_fill_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="#E08214", 
                             "Target, Studied and tested - HITS"="#2166AC",
                             "Target, Studied only - HITS"="#1A9850","FOIL"="red")) +
  scale_shape_manual(values = c(
    "Foil, neither studied nor tested  - Correct rejection" = 17,                                # solid triangle
    "Target, Studied and tested - HITS" = 15,                      # solid square
    "Target, Studied only - HITS" = 16,
    "FOIL"=8                             # solid circle
  )) +
                               # circle, triangle, square
  scale_linetype_manual(values=c("Foil, neither studied nor tested  - Correct rejection"="solid", 
                                 "Target, Studied and tested - HITS"="longdash",
                                 "Target, Studied only - HITS"="dotted","FOIL"="dotted")) +
  
  # Enhanced theme with improved readability and larger legend
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_line(color = GRID_MAJOR_COLOR, linewidth = GRID_MAJOR_WIDTH),
    panel.grid.minor = element_line(color = GRID_MINOR_COLOR, linewidth = GRID_MINOR_WIDTH),
    legend.position = "none",
    # legend.position = "bottom",
    # legend.title = element_text(face = "bold", size = BASE_FONT_SIZE + 2),   # Increased legend title size
    # legend.text = element_text(size = BASE_FONT_SIZE),                   # Increased legend text size
    # legend.key.width = unit(2.2, "cm"),                      # Make legend wider
    # legend.key.height = unit(0.8, "cm"),
    # legend.margin = margin(t = 25),
    # legend.box = "horizontal",
    # legend.direction = "horizontal",
    # legend.box.just = "center",
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    strip.background = element_rect(fill = STRIP_BACKGROUND, color = "black", linewidth = STRIP_BORDER_WIDTH),
    strip.text = element_text(face = "bold", size = STRIP_TEXT_SIZE)
  ) +
  guides(
    fill = "none",
    color = "none",
    shape = "none",
    linetype = "none"
  )

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Now switch to modeling folder for prediction plot
# setwd("../modeling/R_ploting")

# Check if final test is enabled
# if (!file.exists("../../../allresf.csv")) {
#     cat("⚠️  allresf.csv not found. This means is_finaltest = false in constants.jl\n")
#     cat("Skipping final test within-list plot generation.\n")
#     quit(save = "no", status = 0)
# }

# Load data for prediction plot - USING CORRECT MODEL DATA
all_results <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/all_results.csv")
DF <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/DF.csv")
allresf <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/allresf.csv")
cat("Loaded model prediction data from allresf.csv\n")

# Create the prediction plot using the CORRECT model data structure
DF_fbyi = allresf %>% 
  mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
  select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
  pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
  # Filter out F targets to remove foil points
  # filter(is_target != "F") %>%
  group_by(pos_factor,posSum,is_target,simulation_number)%>%
  summarize(meanx=mean(correct))%>%
  group_by(pos_factor,posSum,is_target)%>%
  summarize(meanx=mean(meanx)) %>%
  # Create proper labels for legend
  mutate(target_type = case_when(
    is_target == "T_target" ~ "Target, Studied and tested - HITS",
    is_target == "T_nontarget" ~ "Target, Studied only - HITS",
    is_target == "T_foil" ~ "Foil, neither studied nor tested - Correct rejection",
    TRUE ~ is_target
  ))

# Create the prediction plot using the CORRECT structure
prediction_plot <- ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
  geom_point(aes(color=target_type, shape=target_type), size=POINT_SIZE, alpha=POINT_ALPHA, stroke=POINT_STROKE)+
  geom_line(aes(color=target_type), linewidth=LINE_WIDTH, alpha=LINE_ALPHA)+
  facet_grid(.~pos_factor, 
             labeller = labeller(pos_factor = c("initial_studypos" = "Initial Study Position",
                                              "initial_testpos" = "Initial Test Position")))+
  labs(title="E1 Final Test Within List PREDICTION",
       x="Position",
       y="Hit Rate",
       color="Type",
       shape="Type")+
  ylim(c(0.5,1))+
  theme_bw(base_size = BASE_FONT_SIZE) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_line(color = GRID_MAJOR_COLOR, linewidth = GRID_MAJOR_WIDTH),
    panel.grid.minor = element_line(color = GRID_MINOR_COLOR, linewidth = GRID_MINOR_WIDTH),
    legend.position = "none",
    # legend.position = "bottom",
    # legend.title = element_text(face = "bold", size = BASE_FONT_SIZE + 2),
    # legend.text = element_text(size = BASE_FONT_SIZE),
    # legend.key.width = unit(2.2, "cm"),
    # legend.key.height = unit(0.8, "cm"),
    # legend.margin = margin(t = 25),
    # legend.box = "horizontal",
    # legend.direction = "horizontal",
    # legend.box.just = "center",
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    strip.background = element_rect(fill = STRIP_BACKGROUND, color = "black", linewidth = STRIP_BORDER_WIDTH),
    strip.text = element_text(face = "bold", size = STRIP_TEXT_SIZE)
  )+
  scale_color_manual(values=c(
    "Target, Studied and tested - HITS"="#2166AC",   # solid square - blue
    "Target, Studied only - HITS"="#1A9850",         # solid circle - green
    "Foil, neither studied nor tested - Correct rejection"="#E08214", # solid triangle - orange
    "F"="red"                                     # asterisk - red
  ))+
  scale_shape_manual(values=c(
    "Target, Studied and tested - HITS"=15,   # solid square
    "Target, Studied only - HITS"=16,         # solid circle
    "Foil, neither studied nor tested - Correct rejection"=17, # solid triangle
    "F"=8                                  # asterisk
  ))+
  guides(
    color = "none",
    shape = "none"
  )

# Save prediction plot
ggsave("temp_prediction_plot.png", prediction_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Go back to main directory
# setwd("../../")

# # Load the saved plots as images
# data_img <- readPNG("data_analysis/temp_data_plot.png")
# prediction_img <- readPNG("modeling/R_ploting/temp_prediction_plot.png")

# # Convert to raster grobs
# data_grob <- rasterGrob(data_img, interpolate = TRUE)
# prediction_grob <- rasterGrob(prediction_img, interpolate = TRUE)

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_plot, prediction_plot,
  ncol = 2,
  top = textGrob("E1 Final Test Within List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_final_test_within_list_combined.png", combined_plot, 
       width = 23, height = 9, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
# file.remove("data_analysis/temp_data_plot.png")
# file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined final test within-list plot saved as E1_final_test_within_list_combined.png\n")
