library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN1_DIR <- file.path(PROJECT_ROOT, "design1")
DATA_ANALYSIS_DIR <- file.path(DESIGN1_DIR, "data_analysis")
MODELING_DIR <- file.path(DESIGN1_DIR, "modeling")
R_PLOTTING_DIR <- file.path(MODELING_DIR, "R_ploting")

##################################################### x#######
## E1 Final Test Between List: DATA vs PREDICTION
############################################################

###################################3333
## Constants for styling - UNIFIED FORMATTING
#####################################3
# Unified constants for both plots
BASE_FONT_SIZE <- 24
POINT_SIZE <- 8
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
RIBBON_ALPHA <- 0.25

###################################3333
## Data
#####################################3
# Load the preprocessed data for data plot
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

# Apply RT filter for test trials (150-3500ms) - done here instead of in generate_data.R
# to avoid NA issues from removing initial test items that appear in final test
dfchanged <- dfchanged %>%
  filter(!(task %in% c("pretest_response", "finalt_response") & (rt < 150 | rt > 3500)))

# Create dfserial data for final test between-list analysis - EXACT COPY FROM ORIGINAL
# unique((dfserial%>%filter(probetype=="FOIL"))$prespos)
# unique(((dfserial%>%filter(probetype=="Foil - Correct rejection",position_type=="Initial Order"))$position)

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
  mutate(position = as.integer(position))

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=dfserial, aes(position,meancr,group=interaction(position_type,condition,probetype)))+
  # Enhanced points with different shapes for each probetype (exclude Average)
  geom_point(
             aes(color=probetype, shape=probetype),
             size=POINT_SIZE, alpha=POINT_ALPHA, stroke=POINT_STROKE) +
  # Enhanced lines with different line types (exclude Average)
  geom_line(data=dfserial %>% filter(probetype != "Average"),
            aes(color=probetype, linetype=probetype),
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),
              alpha=RIBBON_ALPHA) +
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
  scale_x_continuous(breaks = 0:10, labels = 0:10) +

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
   theme_bw(base_size = BASE_FONT_SIZE) + # Set a large base font size for all text
  theme(
    plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
    plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
    text = element_text(size = BASE_FONT_SIZE),
    axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
    axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
  legend.position="none",
    # legend.position = "bottom",
    # legend.title = element_text(face = "bold", size = BASE_FONT_SIZE, margin = margin(b = 5)),
    # legend.text = element_text(size = BASE_FONT_SIZE - 2),
    # legend.key.width = unit(2.0, "cm"),
    # legend.key.height = unit(1.0, "cm"),
    # legend.margin = margin(t = 20),
    # legend.box = "horizontal",
    # legend.direction = "horizontal",
    plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
    panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
    strip.background = element_rect(fill = STRIP_BACKGROUND, color = "black", linewidth = STRIP_BORDER_WIDTH),
    strip.text = element_text(face = "bold", size = STRIP_TEXT_SIZE)
  ) +
  guides(
    fill = "none",
    color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
    shape = "none",
    linetype = "none"
  )

# Save data plot
data_plot_path <- file.path(DATA_ANALYSIS_DIR, "temp_data_plot.png")
ggsave(data_plot_path, data_plot, width = 9+3, height = 13+4, dpi = 300, bg = "white")

###################################3333
## prediction
#####################################3

# Check if final test is enabled
allresf_path <- file.path(PROJECT_ROOT, "allresf.csv")
if (!file.exists(allresf_path)) {
    cat("⚠️  allresf.csv not found. This means is_finaltest = false in constants.jl\n")
    cat("Skipping final test between-list plot generation.\n")
    quit(save = "no", status = 0)
}

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
allresf <- read.csv(allresf_path)

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
    geom_point(aes(color = is_target, shape = is_target, group = is_target), size = POINT_SIZE, alpha = POINT_ALPHA, stroke = POINT_STROKE) +
    # Lines for initial_list_order (left column - Initial Order) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "initial_list_order"),
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = LINE_WIDTH, alpha = LINE_ALPHA) +
    # Lines for final_test_order (right column - Final Order) - including foil
    geom_line(data = df_allfinal_filtered %>% filter(position_kind == "final_test_order"),
              aes(color = is_target, linetype = is_target, group = is_target), linewidth = LINE_WIDTH, alpha = LINE_ALPHA) +
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
    theme_bw(base_size = BASE_FONT_SIZE) + # Set a large base font size for all text
    theme(
        plot.caption = element_text(hjust = 0, size = CAPTION_SIZE, face = "bold", color = "darkblue", margin = margin(t = CAPTION_MARGIN_TOP)),
        plot.margin = margin(t = PLOT_MARGIN_TOP, r = PLOT_MARGIN_RIGHT, b = PLOT_MARGIN_BOTTOM, l = PLOT_MARGIN_LEFT),
        text = element_text(size = BASE_FONT_SIZE),
        axis.text = element_text(size = AXIS_TEXT_SIZE, color = "black"),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold", color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # legend.position = "bottom",
        # legend.title = element_text(face = "bold", size = BASE_FONT_SIZE, margin = margin(b = 5)),
        # legend.text = element_text(size = BASE_FONT_SIZE - 2),
        # legend.key.width = unit(2.0, "cm"),
        # legend.key.height = unit(1.0, "cm"),
        # legend.margin = margin(t = 20),
        # legend.box = "horizontal",
        # legend.direction = "horizontal",
        legend.position="none",
        plot.title = element_text(face = "bold", hjust = 0.5, size = TITLE_SIZE, margin = margin(b = TITLE_MARGIN_BOTTOM)),
        panel.border = element_rect(color = "black", fill = NA, linewidth = PANEL_BORDER_WIDTH),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = PANEL_BACKGROUND, color = NA),
        strip.background = element_rect(fill = STRIP_BACKGROUND, color = "black", linewidth = STRIP_BORDER_WIDTH),
        strip.text = element_text(face = "bold", size = STRIP_TEXT_SIZE)
    ) +
    ylim(c(0.5, 1)) +
    scale_x_continuous(breaks = 0:10, labels = 0:10) +
    # Add average line as dashed line (same as data plot) - COMMENTED OUT
    # geom_line(aes(y = mean_mean), linewidth = 1.5, color = "black", linetype = "dashed") +
    guides(
        color = guide_legend(nrow = 2, byrow = TRUE),
        shape = guide_legend(nrow = 2, byrow = TRUE),
        linetype = guide_legend(nrow = 2, byrow = TRUE)
    )

# Save prediction plot
prediction_plot_path <- file.path(R_PLOTTING_DIR, "temp_prediction_plot.png")
ggsave(prediction_plot_path, plot = prediction_plot,
       width = 12, height = 17, dpi = 300, bg = "white")

# Load the saved plots as images
data_img <- readPNG(data_plot_path)
prediction_img <- readPNG(prediction_plot_path)

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
ggsave(file.path(DESIGN1_DIR, "E1_final_test_between_list_combined.png"), combined_plot,
       width = 24, height = 17, dpi = 300, bg = "white")

# Clean up temporary files
file.remove(data_plot_path)
file.remove(prediction_plot_path)

cat("Combined final test between-list plot saved as E1_final_test_between_list_combined.png\n")

############################################################
## E1 Final Test Within List: DATA vs PREDICTION
############################################################

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

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
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

# Add overall performance for non-tested items in Initial Test Position facet
nontarget_performance <- df_final %>%
  filter(probetype == "TARGET_nontarget") %>%
  group_by(ip, probetype) %>%
  summarize(meancr1 = mean(correct)) %>%
  group_by(probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n())) %>%
  mutate(position = 0, position_type = "Initial Test Position")

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
  # Add non-target performance for Initial Test Position facet
  bind_rows(
    nontarget_performance %>%
      mutate(probetype = "Target, Studied only - HITS") %>%
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
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
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
ggsave(file.path(DESIGN1_DIR, "temp_data_plot.png"), data_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Load data for prediction plot - USING CORRECT MODEL DATA
all_results <- read.csv(file.path(PROJECT_ROOT, "all_results.csv"))
DF <- read.csv(file.path(PROJECT_ROOT, "DF.csv"))
allresf <- read.csv(file.path(PROJECT_ROOT, "allresf.csv"))
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
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
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
ggsave(file.path(DESIGN1_DIR, "temp_prediction_plot.png"), prediction_plot, width = 10, height = 9, dpi = 300, bg = "white")

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_plot, prediction_plot,
  ncol = 2,
  top = textGrob("E1 Final Test Within List: DATA vs PREDICTION",
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave(file.path(DESIGN1_DIR, "E1_final_test_within_list_combined.png"), combined_plot,
       width = 23, height = 9, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
# file.remove("data_analysis/temp_data_plot.png")
# file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined final test within-list plot saved as E1_final_test_within_list_combined.png\n")

############################################################
## E1 Initial Between List: DATA vs PREDICTION
############################################################

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
Y_MIN <- 0.8
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

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initialtestbyinitial (from the RMD file) - EXACT COPY FROM ORIGINAL
df_initialtestbyinitial = dfchanged%>%
  filter(task=="pretest_response", response != "null")%>%
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
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
  )

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv(file.path(PROJECT_ROOT, "all_results.csv"))
DF <- read.csv(file.path(PROJECT_ROOT, "DF.csv"))

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
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
    )

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_plot, prediction_plot,
  ncol = 2,
  top = textGrob("E1 Initial Between List: DATA vs PREDICTION",
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave(file.path(DESIGN1_DIR, "E1_initial_between_list_combined.png"), combined_plot,
       width = 18, height = 8, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
file.remove(file.path(DATA_ANALYSIS_DIR, "temp_data_plot.png"))
file.remove(file.path(R_PLOTTING_DIR, "temp_prediction_plot.png"))

cat("Combined initial between-list plot saved as E1_initial_between_list_combined.png\n")

############################################################
## E1 Initial Within List: DATA vs PREDICTION
############################################################

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

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
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
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
  )

# Load data for prediction plot - EXACT COPY FROM ORIGINAL
all_results <- read.csv(file.path(PROJECT_ROOT, "all_results.csv"))
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
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = LEGEND_POSITION,
        text = element_text(size = BASE_TEXT_SIZE),
        axis.title = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
        axis.text = element_text(size = AXIS_TEXT_SIZE)
    )

# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  data_plot, prediction_plot,
  ncol = 2,
  top = textGrob("E1 Initial Within List: DATA vs PREDICTION",
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave(file.path(DESIGN1_DIR, "E1_initial_within_list_combined.png"), combined_plot,
       width = 22, height = 7, dpi = 300, bg = "white")

# Display the plot using eog

# Clean up temporary files
# file.remove("data_analysis/temp_data_plot.png")
# file.remove("modeling/R_ploting/temp_prediction_plot.png")

cat("Combined initial within-list plot saved as E1_initial_within_list_combined.png\n")

