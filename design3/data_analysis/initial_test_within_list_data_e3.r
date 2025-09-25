library(readr)
library(dplyr)
library(ggplot2)

# Plot formatting constants
PLOT_TITLE_SIZE <- 18
AXIS_TITLE_SIZE <- 24
AXIS_TEXT_SIZE <- 18
STRIP_TEXT_SIZE <- 28
BASE_SIZE <- 24
POINT_SIZE <- 4
LINE_WIDTH <- 1
PLOT_WIDTH <- 11
PLOT_HEIGHT <- 6
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.44
Y_MAX <- 0.9
Y_BREAKS <- seq(0.4, 0.9, by = 0.1)

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold")
  )

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")


####################################### Within list by test position
d1ta_test = df_rt_pl%>%
  filter(task=="initialTest_response")%>%
    mutate(type_comment = typecomment_in, testPos_appear0_initial =
             as.numeric(testPos_appear0_initial))%>%
  mutate(testPos_appear0_initial = ceiling(testPos_appear0_initial/3))%>%
         group_by(task, condition,type_comment, testPos_appear0_initial,subject_id )%>%
  mutate(testPos_appear0_initial=as.numeric(testPos_appear0_initial))%>%
         summarise(crs = mean(correct))%>%
           group_by(task, condition,type_comment, testPos_appear0_initial )%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Test Position", position = testPos_appear0_initial)

####################################### Within list by study position
d1ta_study = df_rt_pl%>%
  filter(task=="initialTest_response")%>%
  mutate(type_comment = typecomment_in, studyPos_appear0_initial = as.numeric(studyPos_appear0_initial))%>%
  mutate(studyPos_appear0_initial = ceiling(studyPos_appear0_initial/3))%>%
         group_by(task, condition,type_comment, studyPos_appear0_initial,subject_id )%>%
  mutate(studyPos_appear0_initial=as.numeric(studyPos_appear0_initial))%>%
         summarise(crs = mean(correct))%>%
           group_by(task, condition,type_comment, studyPos_appear0_initial )%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Study Position", position = studyPos_appear0_initial)

# Combine both datasets
d1ta_combined = bind_rows(d1ta_test, d1ta_study)

# Create combined plot with facet_grid
p_combined = ggplot(data=d1ta_combined)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill=type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
  geom_point(aes(x=position,y=cr,group=interaction(task,type_comment),shape=type_comment,color=type_comment),size=POINT_SIZE)+
  facet_grid(.~position_type)+
  scale_color_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",  # warm orange-red
      "Inherented Foil - Last Studied Only" = "#1A9850",  # warm yellow-orange
      "Inherented Foil - Last Target" = "#2166AC",  # warm yellow
      "New Foil" = "#E08214",  # warm orange
      "Target" = "#2166AC"     # blue (cool, for contrast)
    )
  )+
  scale_fill_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",  # warm orange-red
      "Inherented Foil - Last Studied Only" = "#1A9850",  # warm yellow-orange
      "Inherented Foil - Last Target" = "#2166AC",  # warm yellow
      "New Foil" = "#E08214",  # warm orange
      "Target" = "#2166AC"     # blue (cool, for contrast)
    )
  )+
  scale_linetype_manual(
    values = c(
      "Inherented Foil - Last Foil" = "dashed",
      "Inherented Foil - Last Studied Only" = "dashed",
      "Inherented Foil - Last Target" = "dashed",
      "New Foil" = "solid",
      "Target" = "solid"
    )
    )+
  scale_shape_manual(
    values = c(
      "New Foil" = 17,                     # solid triangle
      "Target" = 15,                       # solid square
      "Inherented Foil - Last Foil" = 2,   # open triangle
      "Inherented Foil - Last Target" = 0, # open square
      "Inherented Foil - Last Studied Only" = 1 # open circle
    )
  )+
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Initial Test Within List DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))


ggsave("initial_test_within_list_data_e3.png", plot = p_combined, width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI)
 