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

# Load the preprocessed data for data plot
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for final test between-list analysis - EXACT COPY FROM ORIGINAL
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

# Create the data plot - EXACT COPY FROM ORIGINAL
base_font_size <- 24

data_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=probetype))+
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
  )

# Save data plot
ggsave("temp_data_plot.png", data_plot, width = 9+3, height = 13+4, dpi = 300, bg = "white")

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

# Create df_allfinal data for final test between-list analysis - EXACT SAME AS ORIGINAL
DF00 <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(test_position = as.numeric(test_position)) %>%
    mutate(test_position_group = ntile(test_position, 10)) %>%
    group_by(test_position_group, is_target, condition) %>%
    summarize(meanx = mean(correct))

DF001 <- allresf %>% 
    mutate(correct = case_when(
        (decision_isold == 1) & (is_target != "F") ~ 1, 
        decision_isold == 0 & is_target == "F" ~ 1,
        TRUE ~ 0
    )) %>%
    mutate(list_number = as.numeric(list_number)) %>%
    group_by(list_number, is_target, condition) %>%
    summarize(meanx = mean(correct))

# Combine the data - EXACT SAME AS ORIGINAL
df_allfinal <- DF001 %>%
    mutate(test_position_group = list_number) %>%
    ungroup() %>%
    select(-list_number) %>%
    full_join(DF00, by = c("is_target", "condition", "test_position_group")) %>%
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
    geom_point(aes(color = is_target, shape = is_target, group = is_target), size = 4.5) +
    # Lines for initial_list_order (left column - Initial Study List Position) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "initial_list_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = 1.5) +
    # Lines for final_test_order (right column - Final Test List Position) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "final_test_order"), 
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = 1.5) +
    facet_grid(factor(condition, levels = c("backward", "forward", "true_random"), 
                      labels = c("backward", "forward", "random")) ~ 
               factor(position_kind, levels = c("initial_list_order", "final_test_order")), 
               labeller = labeller(position_kind = c("initial_list_order" = "Initial Study List Position", 
                                                   "final_test_order" = "Final Test List Position"))) +
    labs(x = "Final test in 10 chunks (left column), Initial test list order (right column)",
         y = "Performance (Hits/Correct Rejection)",
         title = "E1 Final Test Between List PREDICTION",
         color = "Type", shape = "Type", linetype = "Type") +
    scale_color_manual(values = c("F" = "#D73027", "T_foil" = "#E08214", "T_nontarget" = "#1A9850", "T_target" = "#2166AC"),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_shape_manual(values = c("F" = 16, "T_foil" = 18, "T_nontarget" = 17, "T_target" = 16),
                       labels = c("F" = "Foil - Correct rejection", 
                                "T_foil" = "TARGET_foil - Hits",
                                "T_nontarget" = "TARGET_nontarget - Hits", 
                                "T_target" = "TARGET_target - Hits")) +
    scale_linetype_manual(values = c("F" = "solid", "T_foil" = "dotted", "T_nontarget" = "solid", "T_target" = "dashed"),
                          labels = c("F" = "Foil - Correct rejection", 
                                   "T_foil" = "TARGET_foil - Hits",
                                   "T_nontarget" = "TARGET_nontarget - Hits", 
                                   "T_target" = "TARGET_target - Hits")) +
    theme_minimal(base_size = 24) +
    theme(
        plot.caption = element_text(hjust = 0, size = 15, face = "bold", color = "darkblue", margin = margin(t = 20)),
        plot.margin = margin(t = 15, r = 15, b = 70, l = 15),
        text = element_text(size = 24),
        axis.text = element_text(size = 24, color = "black"),
        axis.title = element_text(size = 26, face = "bold", color = "black"),
        panel.grid.major = element_line(color = "grey75", linewidth = 0.3),
        panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
        legend.position = "bottom",
        legend.title = element_text(face = "bold", size = 24, margin = margin(b = 5)),
        legend.text = element_text(size = 22),
        legend.key.width = unit(2.0, "cm"),
        legend.key.height = unit(1.0, "cm"),
        legend.margin = margin(t = 20),
        legend.box = "horizontal",
        legend.direction = "horizontal",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 30, margin = margin(b = 20)),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "grey98", color = NA),
        strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.4),
        strip.text = element_text(face = "bold", size = 24)
    ) +
    ylim(c(0.5, 1)) +
    scale_x_continuous(breaks = 1:10, labels = 1:10) +
    geom_line(aes(y = mean_mean), linewidth = 1.5, color = "black", linetype = "dashed") +
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
system("eog E1_final_test_between_list_combined.png &")

# Clean up temporary files
file.remove("data_analysis/temp_data_plot.png")
file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined final test between-list plot saved as E1_final_test_between_list_combined.png\n")
