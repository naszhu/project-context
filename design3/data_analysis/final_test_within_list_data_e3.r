
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
Y_MIN <- 0.5
Y_MAX <- 1.0
Y_BREAKS <- seq(0.5, 1.0, by = 0.1)

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


levelsStr_fn = levels(as.factor(df_rt_pl$type_comment_fn))

################33 Within plot 1 - Test position
d1taf_test = df_rt_pl%>%
    mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  mutate(type_comment=type_comment_fn)%>%
  mutate(testPos_appear1_initial=as.numeric(testPos_appear1_initial),testPos_appear1_initial=ceiling(testPos_appear1_initial/3))%>%
  filter(task=="finalTest")%>%
   group_by(task, condition,type_comment, testPos_appear1_initial, subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition,type_comment, testPos_appear1_initial )%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Test Position", position = testPos_appear1_initial)

##############################
###########3 Within plot 2 - Study position
d1taf_study = df_rt_pl%>%
  filter(task=="finalTest")%>%
  mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  mutate(type_comment=type_comment_fn)%>%
    mutate( listNum_infinalOrder=as.numeric(studyPos_appear1_initial),listNum_infinalOrder=ceiling(listNum_infinalOrder/3))%>%
     group_by(task, condition,type_comment, listNum_infinalOrder, subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition,type_comment, listNum_infinalOrder)%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Study Position", position = listNum_infinalOrder)

# Combine both datasets
d1taf_combined = bind_rows(d1taf_test, d1taf_study)

# Create combined plot
p = ggplot(data=d1taf_combined)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
    geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE)+
  facet_grid(.~position_type)+
  scale_color_manual(values=c(
            "Target: studied and tested at (n), Foil (n+1)"="#2166AC",
            "Studied-only (n); Foil (n+1)"="#1A9850",
             "Target: : started and tested at (n) ; Appear once" ="#2166AC",
             "Foil(n), Foil (n+1)" ="#E08214",
             "Foil(n); Appear once" ="#E08214",
             "Studied-only (n); Appear once" = "#1A9850",
             "Final Foil"="red" ),breaks=levelsStr_fn )+
  scale_fill_manual(values=c(
            "Target: studied and tested at (n), Foil (n+1)"="#2166AC",
            "Studied-only (n); Foil (n+1)"="#1A9850",
             "Target: : started and tested at (n) ; Appear once" ="#2166AC",
             "Foil(n), Foil (n+1)" ="#E08214",
             "Foil(n); Appear once" ="#E08214",
             "Studied-only (n); Appear once" = "#1A9850",
             "Final Foil"="red" ),breaks=levelsStr_fn )+
  scale_shape_manual(
    values = c(
      "Target: studied and tested at (n), Foil (n+1)" = 0,      # open square
      "Target: : started and tested at (n) ; Appear once" = 15,  # solid square
      "Studied-only (n); Foil (n+1)" = 1,                      # open circle
      "Studied-only (n); Appear once" = 16,  # solid circle
      "Foil(n), Foil (n+1)" = 2,                      # open triangle
      "Foil(n); Appear once" = 17,                                # solid triangle
      "Final Foil" = 8                                           # star
    ),
    breaks = levelsStr_fn
  )+
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Final Test Within List DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

ggsave("final_test_within_list_data_e3.png", plot = p, width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI)
