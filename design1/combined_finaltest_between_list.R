library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

###################################3333
## Constants for styling
#####################################3
# Data plot constants
DATA_BASE_FONT_SIZE <- 24
DATA_POINT_SIZE <- 8
DATA_LINE_WIDTH <- 1.5
DATA_TITLE_SIZE <- DATA_BASE_FONT_SIZE + 6
DATA_STRIP_TEXT_SIZE <- DATA_BASE_FONT_SIZE + 4
DATA_AXIS_TITLE_SIZE <- DATA_BASE_FONT_SIZE + 6

# Prediction plot constants
PRED_BASE_FONT_SIZE <- 24
PRED_POINT_SIZE <- 8
PRED_LINE_WIDTH <- 1.5
PRED_TITLE_SIZE <- PRED_BASE_FONT_SIZE + 6
PRED_STRIP_TEXT_SIZE <- PRED_BASE_FONT_SIZE + 4
PRED_AXIS_TITLE_SIZE <- PRED_BASE_FONT_SIZE + 6

###################################3333
## Data
#####################################3
# Set working directory to data_analysis folder for data plots
setwd("data_analysis")

# Load the preprocessed data for data plot
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for final test between-list analysis - EXACT COPY FROM ORIGINAL
# unique((dfserial%>%filter(probetype=="FOIL"))$prespos)
# unique(((dfserial%>%filter(probetype=="Foil - Correct rejection",position_type=="Initial Order")))$position)

dfserial=
  dfchanged%>%
  filter(task=="finalt_response")%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(prespos = case_when(probetype=="FOIL"~0,
  TRUE~prespos_itrial))%>%
  mutate(testpos=as.integer(testpos),prespos=as.integer(prespos))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,correct,condition,probetype)%>%
  group_by(position,ip,position_type,condition,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,condition,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits")))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Order",
                                 TRUE~"Initial Order"))


# For foils in Initial Study List Position, set position to 0 and calculate mean across all conditions
dfserial <- dfserial %>%
  mutate(position = as.character(position))

# Create foil data at position 0 for Initial Study List Position (averaged across all conditions)
# foil_zero_data <- dfserial %>%
#   filter(probetype == "Foil - Correct rejection" & position_type == "Initial Study List Position") %>%
#   group_by(position_type, probetype) %>%
#   summarize(meancr = mean(meancr), 
#             sd = sqrt(mean(sd^2)),  # Pooled standard deviation
#             se = sd/sqrt(n()),
#             .groups = 'drop') %>%
#   mutate(position = "0") %>%
#   # Create one row for each condition
#   crossing(condition = c("backward", "forward", "random"))

# Remove original foil data from Initial Study List Position and add the averaged version
# dfserial <- dfserial %>%
#   filter(!(probetype == "Foil - Correct rejection" & position_type == "Initial Study List Position")) %>%
#   rbind(foil_zero_data)

# dfserial_meandf=dfchanged%>%
#   filter(task=="finalt_response")%>%
#   mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
#   mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial))%>%
#   filter(response!="null")%>%
#   pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
#   select(position_type,position,ip,correct,condition,probetype)%>%
#   group_by(position_type,position,ip,condition)%>%
#   summarize(meancr1=mean(correct))%>%
#   group_by(position_type,position,condition)%>%
#   summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
#   mutate(probetype="Average")%>%
#   select(position,position_type,condition,probetype,meancr,se)%>%
#   mutate(position_type=case_when(position_type=="testpos"~"Final Order",
#                                  TRUE~"Initial Order"))%>%
#   mutate(position = as.character(position))

# dfserial_all=rbind(dfserial,dfserial_meandf)%>%
#   mutate(position_type=as.factor(position_type))%>%
#   mutate(position_type=factor(position_type,levels=c("Initial Order", "Final Order")))

# ggplot(dfserial,aes(position,meancr,group=interaction(position_type,condition,probetype)))+geom_point(aes(color=probetype),size=10)+facet_grid(condition~position_type)+geom_line(aes(color=probetype,group=interaction(position_type,condition,probetype)))

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=dfserial, aes(position,meancr,group=interaction(position_type,condition,probetype)))+
  # Enhanced points with different shapes for each probetype (exclude Average)
  geom_point(
             aes(color=probetype, shape=probetype), 
             size=DATA_POINT_SIZE, alpha=1, stroke=1.2) +
  # Enhanced lines with different line types (exclude Average)
  geom_line(data=dfserial %>% filter(probetype != "Average"),
            aes(color=probetype, linetype=probetype), 
            linewidth=DATA_LINE_WIDTH, alpha=1) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),
              alpha=0.25) +
  # Average line - COMMENTED OUT
  # geom_line(data=dfserial_all %>% filter(probetype == "Average"), 
  #           aes(y=meancr), linewidth=1.5, color="black", linetype="dashed") +
  # Facet by condition and position type
  facet_grid(condition~position_type) +
  # Enhanced styling and labels
  labs(x="Test Order",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Final Test Between List DATA",
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
  scale_shape_manual(values=c("Average"=15, #doens't matter because avereage is hidden here
                              "Foil - Correct rejection"=8,   # star for foil-correctrejection (F)
                              "TARGET_foil  - Hits"=17,                                # solid triangle
                              "TARGET_nontarget  - Hits"=16,  # solid circle
                              "TARGET_target  - Hits"=15  # solid square
                              )) +  # square, star, diamond, triangle, filled square
  scale_linetype_manual(values=c("Average"="dashed", 
                                 "Foil - Correct rejection"="solid",
                                 "TARGET_foil  - Hits"="dotted",
                                 "TARGET_nontarget  - Hits"="longdash",
                                 "TARGET_target  - Hits"="twodash")) +
  
  # Enhanced theme with improved readability and much larger font sizes
   theme_bw(base_size = DATA_BASE_FONT_SIZE) + # Set a large base font size for all text
  theme(
    plot.caption = element_text(hjust = 0, size = 15, face = "bold", color = "darkblue", margin = margin(t = 20)),
    plot.margin = margin(t = 15, r = 15, b = 70, l = 15),
    text = element_text(size = DATA_BASE_FONT_SIZE),
    axis.text = element_text(size = DATA_BASE_FONT_SIZE, color = "black"),
    axis.title = element_text(size = DATA_AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_line(color = "grey75", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
  legend.position="none",
    # legend.position = "bottom",
    # legend.title = element_text(face = "bold", size = DATA_BASE_FONT_SIZE, margin = margin(b = 5)),
    # legend.text = element_text(size = DATA_BASE_FONT_SIZE - 2),
    # legend.key.width = unit(2.0, "cm"),
    # legend.key.height = unit(1.0, "cm"),
    # legend.margin = margin(t = 20),
    # legend.box = "horizontal",
    # legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = DATA_TITLE_SIZE, margin = margin(b = 20)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.4),
    strip.text = element_text(face = "bold", size = DATA_STRIP_TEXT_SIZE)
  ) +
  guides(
    fill = "none",
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = "none",
    linetype = "none"
  )

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 9+3, height = 13+4, dpi = 300, bg = "white")

###################################3333
## prediction
#####################################3

# Now switch to modeling folder for prediction plot
setwd("../modeling/R_ploting")

# Check if final test is enabled
if (!file.exists("../../../allresf.csv")) {
    cat("⚠️  allresf.csv not found. This means is_finaltest = false in constants.jl\n")
    cat("Skipping final test between-list plot generation.\n")
    quit(save = "no", status = 0)
}

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
allresf <- read.csv("../../../allresf.csv")

# Create df_allfinal data for final test between-list analysis - MATCH DATA CALCULATION EXACTLY
# Use simulation_number as participant_id (each simulation is a participant)
DF00_indiv <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(test_position = as.numeric(test_position)) %>%
    mutate(test_position_group = ntile(test_position, 10)) %>%
    # Map condition names to match data
    mutate(condition = case_when(
        condition == "true_random" ~ "random",
        TRUE ~ condition
    )) %>%
    # Use simulation_number as participant_id (each simulation is a participant)
    group_by(test_position_group, is_target, condition, simulation_number) %>%
    summarize(meancr1 = mean(correct), .groups = 'drop') %>%
    # Now calculate mean across "participants" (exactly like data)
    group_by(test_position_group, is_target, condition) %>%
    summarize(meanx = mean(meancr1), .groups = 'drop')

DF001_indiv <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(list_number = as.numeric(list_number)) %>%
    # Map condition names to match data
    mutate(condition = case_when(
        condition == "true_random" ~ "random",
        TRUE ~ condition
    )) %>%
    # Use simulation_number as participant_id (each simulation is a participant)
    group_by(list_number, is_target, condition, simulation_number) %>%
    summarize(meancr1 = mean(correct), .groups = 'drop') %>%
    # Now calculate mean across "participants" (exactly like data)
    group_by(list_number, is_target, condition) %>%
    summarize(meanx = mean(meancr1), .groups = 'drop')

# Combine the data - EXACT SAME AS ORIGINAL
df_allfinal <- DF001_indiv %>%
    mutate(test_position_group = list_number) %>%
    ungroup() %>%
    select(-list_number) %>%
    full_join(DF00_indiv, by = c("is_target", "condition", "test_position_group")) %>%
    mutate(initial_list_order = meanx.x, final_test_order = meanx.y) %>%
    select(-c("meanx.x", "meanx.y")) %>%
    pivot_longer(cols = c("initial_list_order", "final_test_order"), 
                 names_to = "position_kind", values_to = "val") %>%
    group_by(position_kind, test_position_group, condition) %>%
    mutate(mean_mean = mean(val[is_target != "F"], na.rm = TRUE))

# Don't filter out any foil data - keep all foil data in both columns
df_allfinal_filtered <- df_allfinal

# Create the prediction plot - EXACT COPY FROM ORIGINAL
prediction_plot <- ggplot(data = df_allfinal_filtered, 
                      aes(test_position_group, val, 
                          group = interaction(position_kind, condition, is_target))) +
    # Points for all targets
    geom_point(aes(color = is_target, shape = is_target, group = is_target), size = PRED_POINT_SIZE) +
    # Lines for initial_list_order (left column - Initial Order) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "initial_list_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = PRED_LINE_WIDTH) +
    # Lines for final_test_order (right column - Final Order) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "final_test_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = PRED_LINE_WIDTH) +
    facet_grid(condition ~ position_kind, 
               labeller = labeller(condition = c("backward" = "backward", 
                                                "forward" = "forward", 
                                                "true_random" = "random"),
                                 position_kind = c("initial_list_order" = "Initial Order", 
                                                  "final_test_order" = "Final Order"))) +
    labs(x = "Test Order",
         y = "Performance (Hits/Correct Rejection)",
         title = "E1 Final Test Between List PREDICTION",
         color = "Type", shape = "Type", linetype = "Type") +
    scale_color_manual(values = c("F" = "#D73027", "T_foil" = "#E08214", "T_nontarget" = "#1A9850", "T_target" = "#2166AC"),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_shape_manual(values = c(
        "F" = 8,            # star
        "T_foil" = 17,      # solid triangle
        "T_nontarget" = 16, # solid circle
        "T_target" = 15     # solid square
    ),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_linetype_manual(values = c("F" = "solid", "T_foil" = "dotted", "T_nontarget" = "solid", "T_target" = "dashed"),
                          labels = c("F" = "Foil - Correct rejection", 
                                   "T_foil" = "TARGET_foil - Hits",
                                   "T_nontarget" = "TARGET_nontarget - Hits", 
                                   "T_target" = "TARGET_target - Hits")) +
    theme_bw(base_size = PRED_BASE_FONT_SIZE) + # Set a large base font size for all text
    theme(
        plot.caption = element_text(hjust = 0, size = 15, face = "bold", color = "darkblue", margin = margin(t = 20)),
        plot.margin = margin(t = 15, r = 15, b = 70, l = 15),
        text = element_text(size = PRED_BASE_FONT_SIZE),
        axis.text = element_text(size = PRED_BASE_FONT_SIZE, color = "black"),
        axis.title = element_text(size = PRED_AXIS_TITLE_SIZE, face = "bold", color = "black"),
        panel.grid.major = element_line(color = "grey75", linewidth = 0.3),
        panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
        # legend.position = "bottom",
        # legend.title = element_text(face = "bold", size = 24, margin = margin(b = 5)),
        # legend.text = element_text(size = 22),
        # legend.key.width = unit(2.0, "cm"),
        # legend.key.height = unit(1.0, "cm"),
        # legend.margin = margin(t = 20),
        # legend.box = "horizontal",
        # legend.direction = "horizontal",
        legend.position="none",
        plot.title = element_text(face = "bold", hjust = 0.5, size = PRED_TITLE_SIZE, margin = margin(b = 20)),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "grey98", color = NA),
        strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.4),
        strip.text = element_text(face = "bold", size = PRED_STRIP_TEXT_SIZE)
    ) +
    ylim(c(0.5, 1)) +
    scale_x_continuous(breaks = 1:10, labels = 1:10) +
    # Add average line as dashed line (same as data plot) - COMMENTED OUT
    # geom_line(aes(y = mean_mean), linewidth = 1.5, color = "black", linetype = "dashed") +
    guides(
        color = guide_legend(nrow = 2, byrow = TRUE),
        shape = guide_legend(nrow = 2, byrow = TRUE),
        linetype = guide_legend(nrow = 2, byrow = TRUE)
    )

# Save prediction plot
ggsave("temp_prediction_plot.png", plot = prediction_plot, 
       width = 12, height = 17, dpi = 300, bg = "white")

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
  top = textGrob("E1 Final Test Between List: DATA vs PREDICTION", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave("E1_final_test_between_list_combined.png", combined_plot, 
       width = 24, height = 17, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
file.remove("data_analysis/temp_data_plot.png")
file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined final test between-list plot saved as E1_final_test_between_list_combined.png\n")
