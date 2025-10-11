
# dfchanged <- read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
# cat("Loaded dfchanged data from dfchanged.csv\n")

# dfchanged


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
# MODELING_DIR <- file.path(DESIGN1_DIR, "modeling")
# R_PLOTTING_DIR <- file.path(MODELING_DIR, "R_ploting")

############################################################
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

###################################3333
## Data
#####################################3
# Load the preprocessed data for data plot
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for final test between-list analysis - EXACT COPY FROM ORIGINAL
# unique((dfserial%>%filter(probetype=="FOIL"))$prespos)
# unique(((dfserial%>%filter(probetype=="Foil - Correct rejection",position_type=="Initial Order"))$position)

dfserial=
  dfchanged%>%
  filter(task=="finalt_response")%>%
  filter(!is.na(rt), rt >= 180, rt <= 3500)%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(prespos = case_when(probetype=="FOIL"~0,
  TRUE~prespos_itrial))%>%
  mutate(testpos=as.integer(testpos),prespos=as.integer(prespos))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,rt,condition,probetype)%>%
  group_by(position,ip,position_type,condition,probetype)%>%
  summarize(meanrt1=mean(rt, na.rm = TRUE))%>%
  group_by(position,position_type,condition,probetype)%>%
  summarize(meanrt=median(meanrt1, na.rm = TRUE),sd=sd(meanrt1, na.rm = TRUE),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits")))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Order",
                                 TRUE~"Initial Order"))


# For foils in Initial Study List Position, set position to 0 and calculate mean across all conditions
dfserial <- dfserial %>%
  mutate(position = as.integer(position))

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=dfserial, aes(position,meanrt,group=interaction(position_type,condition,probetype)))+
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
              aes(ymin=meanrt-se,ymax=meanrt+se,fill=probetype),
              alpha=RIBBON_ALPHA) +
  # Average line - COMMENTED OUT
  # geom_line(data=dfserial_all %>% filter(probetype == "Average"),
  #           aes(y=meancr), linewidth=1.5, color="black", linetype="dashed") +
  # Facet by condition and position type
  facet_grid(condition~position_type) +
  # Enhanced styling and labels
  labs(x="Test Order",
       y="Response Time (ms)",
       title="E1 Final Test Between List RT DATA",
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
data_plot_path <- file.path(DATA_ANALYSIS_DIR, "E1_final_between_rt.png")
ggsave(data_plot_path, data_plot, width = 9+3, height = 13+4, dpi = 300, bg = "white")

############################################################
## E1 Final Within 
############################################################
###########################################################
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
#   filter(!is.na(rt), rt >= 180, rt <= 3500) %>%
  filter(response!="null")%>%
  select(ip,rt,probetype,stimulus_id)

#now, combine initial test positions with final test correct,
# intial test add column position_type (intial/final), position
# final test add column correct(1/0) and probetype (3 kinds of Target and foil)

# First, calculate FOIL performance separately (since FOIL doesn't have initial positions)
foil_performance <- df_final %>%
  filter(probetype == "FOIL") %>%
  group_by(ip, probetype) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE)) %>%
  group_by(probetype) %>%
  summarize(meanrt = median(meanrt1, na.rm = TRUE), sd = sd(meanrt1, na.rm = TRUE), se = sd/sqrt(n())) %>%
  mutate(position = 0, position_type = "both") # Use "both" to indicate it should appear in both facets

# Process non-FOIL data normally
df_finalwithin_nonfoil = df_final %>%
  filter(probetype != "FOIL") %>%
  left_join(df_initial_all, by = c("ip", "stimulus_id")) %>%
  filter(!is.na(rt)) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE)) %>%
  group_by(position, position_type, probetype) %>%
  summarize(meanrt = median(meanrt1, na.rm = TRUE), sd = sd(meanrt1, na.rm = TRUE), se = sd/sqrt(n()))

# Add overall performance for non-tested items in Initial Test Position facet
nontarget_performance <- df_final %>%
  filter(probetype == "TARGET_nontarget") %>%
  group_by(ip, probetype) %>%
  summarize(meanrt1 = mean(rt, na.rm = TRUE)) %>%
  group_by(probetype) %>%
  summarize(meanrt = median(meanrt1, na.rm = TRUE), sd = sd(meanrt1, na.rm = TRUE), se = sd/sqrt(n())) %>%
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
      select(position, position_type, probetype, meanrt, sd, se)
  ) %>%
  bind_rows(
    foil_performance %>%
      mutate(position_type = "Initial Test Position", probetype = "FOIL") %>%
      select(position, position_type, probetype, meanrt, sd, se)
  ) %>%
  # Add non-target performance for Initial Test Position facet
  bind_rows(
    nontarget_performance %>%
      mutate(probetype = "Target, Studied only - HITS") %>%
      select(position, position_type, probetype, meanrt, sd, se)
  ) %>%
  mutate(position = as.numeric(position)) 

# Create the data plot - EXACT COPY FROM ORIGINAL
data_plot <- ggplot(data=df_finalwithin,
                        aes(position,meanrt,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype),
             size=POINT_SIZE, alpha=POINT_ALPHA, stroke=POINT_STROKE) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype),
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meanrt-se,ymax=meanrt+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Facet by position type
  facet_grid(.~position_type) +

  # Enhanced styling and labels
  labs(x="Position",
       y="Response Time (ms)",
       title="E1 Final Test Within List RT DATA",
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
ggsave(file.path(DATA_ANALYSIS_DIR, "E1_final_within_rt.png"), data_plot, width = 19/3*2, height = 7.5, dpi = 300, bg = "white")




############################################################
## E1 Initial Between
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

ylabsname <- "Response Time (ms)"

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

# Load the preprocessed data for data plot - EXACT COPY FROM ORIGINAL
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")


# Create df_initialtestbyinitial (from the RMD file) - EXACT COPY FROM ORIGINAL
df_initialtestbyinitial = dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(!is.na(rt), rt >= 180, rt <= 3500)%>%
  select(trialnum,ip,rt,probetype)%>%
  group_by(trialnum,ip,probetype)%>%
  summarize(meanrt1=mean(rt, na.rm = TRUE))%>%
  group_by(trialnum,probetype)%>%
  summarize(meanrt=median(meanrt1, na.rm = TRUE),sd=sd(meanrt1, na.rm = TRUE),se=sd/sqrt(n()))%>%
  mutate(trialnum=as.factor(trialnum))%>%
  mutate(position=trialnum,position_type="ir")%>%
  mutate(condition="All conditions")%>%
  select(position,position_type,probetype,meanrt,se,condition)%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits"))) %>%
  mutate(condition=as.factor(condition))%>%
  mutate(condition=factor(condition,levels=levels(condition)[c(1,2,3)]))%>%
  group_by(trialnum)%>%
  mutate(meanrt_avg=median(meanrt))

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
data_plot <- ggplot(data=plot_data, aes(position,meanrt,group=interaction(position_type,conditionnow)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype),
             size=POINT_SIZE, alpha=0.9, stroke=1.5) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype),
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meanrt-se,ymax=meanrt+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Enhanced average line with distinctive style
  geom_line(data=plot_data,
            aes(x=position,y=meanrt_avg),
            color=COLOR_AVERAGE, linewidth=AVERAGE_LINE_WIDTH, linetype="dashed", alpha=0.9) +

  scale_y_continuous(name = ylabsname) +
  # Enhanced styling and labels
  labs(x="List number in initial test",
       y=ylabsname,
       title="E1 Initial Between List RT DATA",
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


ggsave(file.path(DATA_ANALYSIS_DIR, "E1_initial_between_rt.png"), data_plot, width = 10, height = 9, dpi = 300, bg = "white")

############################################################
## E1 Initial Within
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

ylabsname <- "Response Time (ms)"
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
  filter(!is.na(rt), rt >= 180, rt <= 3500)%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,rt,probetype)%>%
  group_by(position,ip,position_type,probetype)%>%
  summarize(meanrt1=mean(rt, na.rm = TRUE))%>%
  group_by(position,position_type,probetype)%>%
  summarize(meanrt=median(meanrt1, na.rm = TRUE),sd=sd(meanrt1, na.rm = TRUE),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil"~"Foil - Correct rejection",
                             probetype=="TARGET_target"~"Target - Hits"))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Initial Test Position",
                                 TRUE~"Initial Study Position"))

dfserial_meandf=dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(!is.na(rt), rt >= 180, rt <= 3500)%>%
  filter(response!="null")%>%
  select(testpos,ip,rt,probetype)%>%
  group_by(testpos,ip)%>%
  summarize(meanrt1=mean(rt, na.rm = TRUE))%>%
  group_by(testpos)%>%
  summarize(meanrt=median(meanrt1, na.rm = TRUE),sd=sd(meanrt1, na.rm = TRUE),se=sd/sqrt(n()))%>%
  mutate(position_type="Initial Test Position",position=testpos,probetype="Average")%>%
  select(position,position_type,probetype,meanrt,se)

dfserial_all=rbind(dfserial,dfserial_meandf)

# Create the data plot
data_plot <- ggplot(data=dfserial_all, aes(position,meanrt,group=interaction(position_type)))+
  # Enhanced points with different shapes for each probetype
  geom_point(aes(color=probetype, shape=probetype, group=probetype),
             size=POINT_SIZE, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype, group=probetype),
            linewidth=LINE_WIDTH, alpha=LINE_ALPHA) +
  # Enhanced ribbon with better visibility (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meanrt-se,ymax=meanrt+se,fill=probetype,group=probetype),
              alpha=RIBBON_ALPHA) +
  # Facet by position type
  facet_grid(.~position_type) +
      scale_y_continuous(name = ylabsname) +

  # Enhanced styling and labels
  labs(x=xaxisname,
       y=ylabsname,
       title="E1 Initial Within List RT DATA",
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


ggsave(file.path(DATA_ANALYSIS_DIR, "E1_initial_within_rt.png"), data_plot, width = 19/3*2, height = 6.5, dpi = 300, bg = "white")


############################################################
## E1 Individual Participant RT Analysis
############################################################



# ---- Individual Participant RT Analysis Plot ----

# Load the preprocessed data (if not already loaded)
# dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
# cat("Loaded dfchanged data from dfchanged.csv\n")

# 1. INITIAL TEST - Calculate mean RT for each participant
initial_participant_rt <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(mean_rt = mean(rt, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(mean_rt) %>%
  mutate(participant_rank = row_number(),
         test_type = "Initial Test") %>%
  filter(!is.na(mean_rt))

# 2. FINAL TEST - Calculate mean RT for each participant
final_participant_rt <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  group_by(ip) %>%
  summarize(mean_rt = mean(rt, na.rm = TRUE),
            .groups = 'drop') %>%
  arrange(mean_rt) %>%
  mutate(participant_rank = row_number(),
         test_type = "Final Test") %>%
  filter(!is.na(mean_rt))

# Combine both datasets
all_participant_rt <- rbind(initial_participant_rt, final_participant_rt)

# Save the data for reference
write_csv(all_participant_rt, file.path(DATA_ANALYSIS_DIR, "participant_rt_data.csv"))
cat("Participant RT data saved to participant_rt_data.csv\n")

# Identify the highest mean RTs for each test
print_highest_participants <- function(df, label, n_highest = 5) {
  highest <- df %>%
    slice_max(mean_rt, n = n_highest, with_ties = TRUE) %>%
    arrange(desc(mean_rt)) %>%
    mutate(mean_rt = round(mean_rt, 3))

  cat(sprintf("\n%s highest mean RT participants:\n", label))
  print(highest %>% select(ip, participant_rank, mean_rt))
}

print_highest_participants(initial_participant_rt, "Initial test", n_highest = 5)
print_highest_participants(final_participant_rt, "Final test", n_highest = 5)

# 3. CREATE THE PLOTS

# Create Initial Test RT plot
initial_rt_plot <- ggplot(initial_participant_rt,
                      aes(x = participant_rank, y = mean_rt)) +
  geom_point(size = 1, alpha = 0.7, color="black") +
  labs(x = "Participant (ordered fastest to slowest)",
       y = "Median RT (s)",
       title = "E1 Initial Test - Individual Participant Median RT") +
  ylim(0, NA) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 20),
    axis.text = element_text(size = 20, color = "black"),
    axis.title = element_text(size = 20, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),
    axis.ticks.x = element_line(color = "black")
  )

# Create Final Test RT plot
final_rt_plot <- ggplot(final_participant_rt,
                    aes(x = participant_rank, y = mean_rt)) +
  geom_point(size = 1, alpha = 0.7, color="black") +
  labs(x = "Participant (ordered fastest to slowest)",
       y = "Median RT (s)",
       title = "E1 Final Test - Individual Participant Median RT") +
  ylim(0, NA) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16, margin = margin(b = 20)),
    plot.caption = element_text(hjust = 0, size = 12, color = "darkblue", margin = margin(t = 15)),
    plot.margin = margin(t = 20, r = 20, b = 40, l = 20),
    text = element_text(size = 35),
    axis.text = element_text(size = 20, color = "black"),
    axis.title = element_text(size = 20, face = "bold", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "grey98", color = NA),
    axis.text.x = element_blank(),
    axis.ticks.x = element_line(color = "black")
  )

# 4. SAVE THE PLOTS

# Save Initial Test RT plot
# ggsave(file.path(DATA_ANALYSIS_DIR, "E1_initial_participant_rt.png"), initial_rt_plot,
    #    width = 10, height = 6, dpi = 300, bg = "white")

# Save Final Test RT plot
# ggsave(file.path(DATA_ANALYSIS_DIR, "E1_final_participant_rt.png"), final_rt_plot,
    #    width = 10, height = 6, dpi = 300, bg = "white")

# Create combined plot using grid.arrange
combined_rt_plot <- grid.arrange(
  initial_rt_plot, final_rt_plot,
  ncol = 2,
  top = textGrob("E1 Individual Participant Median RT", 
                 gp = gpar(fontsize = 28, fontface = "bold"))
)

# Save the combined plot
ggsave(file.path(DATA_ANALYSIS_DIR, "E1_participant_mean_rt.png"), combined_rt_plot, 
       width = 13, height = 6, dpi = 300, bg = "white")

# 5. SUMMARY STATISTICS
cat("\n=== PARTICIPANT MEAN RT SUMMARY ===\n")

cat("\nInitial Test Median RT:\n")
cat(sprintf("Number of participants: %d\n", nrow(initial_participant_rt)))
cat(sprintf("Median RT: %.3f s\n", mean(initial_participant_rt$mean_rt)))
cat(sprintf("Median RT: %.3f s\n", median(initial_participant_rt$mean_rt)))
cat(sprintf("SD RT: %.3f s\n", sd(initial_participant_rt$mean_rt)))
cat(sprintf("Range: %.3f - %.3f s\n",
    min(initial_participant_rt$mean_rt),
    max(initial_participant_rt$mean_rt)))

cat("\nFinal Test Median RT:\n")
cat(sprintf("Number of participants: %d\n", nrow(final_participant_rt)))
cat(sprintf("Median RT: %.3f s\n", mean(final_participant_rt$mean_rt)))
cat(sprintf("Median RT: %.3f s\n", median(final_participant_rt$mean_rt)))
cat(sprintf("SD RT: %.3f s\n", sd(final_participant_rt$mean_rt)))
cat(sprintf("Range: %.3f - %.3f s\n",
    min(final_participant_rt$mean_rt),
    max(final_participant_rt$mean_rt)))

cat("\n=== RT PLOTS CREATED SUCCESSFULLY! ===\n")
cat("Files created:\n")
cat("• participant_rt_data.csv - Raw RT data\n")
# cat("• E1_initial_participant_rt.png - Initial test RT plot\n")
# cat("• E1_final_participant_rt.png - Final test RT plot\n")
cat("• E1_participant_mean_rt.png - Combined RT plot\n")

