
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
Y_MIN <- 0.47
Y_MAX <- 0.96
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

############ First plot - Initial position
d1taf_initial = df_rt_pl%>%
  mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  filter(task=="finalTest")%>%
  mutate(type_comment=type_comment_fn)%>%
         group_by(task, condition,type_comment, listNum_appear1_initial, subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition,type_comment, listNum_appear1_initial)%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Initial Position", position = listNum_appear1_initial)

############ Second plot - Final position
d1taf_final = df_rt_pl%>%
    mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  filter(task=="finalTest")%>%
  mutate(listNum_infinalOrder=as.numeric(testPos_final))%>%
  mutate(listNum_infinalOrder = case_when(
    listNum_infinalOrder <= 49 ~ 1,
    listNum_infinalOrder <= 98 ~ 2,
    listNum_infinalOrder <= 147 ~ 3,
    listNum_infinalOrder <= 196 ~ 4,
    listNum_infinalOrder <= 245 ~ 5,
    listNum_infinalOrder <= 294 ~ 6,
    listNum_infinalOrder <= 343 ~ 7,
    listNum_infinalOrder <= 392 ~ 8,
    listNum_infinalOrder <= 442 ~ 9,
    listNum_infinalOrder <= 492 ~ 10,
    TRUE ~ NA_real_
  ))%>%
  mutate(type_comment=type_comment_fn)%>%
         group_by(task, condition,type_comment, listNum_infinalOrder, subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition,type_comment, listNum_infinalOrder)%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(listNum_infinalOrder=as.integer(listNum_infinalOrder))%>%
  mutate(position_type = "Final Position", position = listNum_infinalOrder)

# Combine both datasets
d1taf_combined = bind_rows(d1taf_initial, d1taf_final)

# 2. identify the rows that will be dropped by geom_point()
dropped <- d1taf_combined %>%
  mutate(row_id = row_number()) %>%
  filter(
    is.na(position) |   # missing x
    is.na(cr)                     |   # missing y
    !type_comment %in% levelsStr_fn     # not covered by your manual scales
  )

cat("Rows dropped due to missing values:\n")
print(dropped)

# Create combined plot
p <- ggplot(data=d1taf_combined)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment),linewidth=1)+
  geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE)+
  facet_grid(.~position_type)+
  scale_color_manual(values=c("Target: studied and tested at (n), Foil (n+1)"="#2166AC",
            "Studied-only (n); Foil (n+1)"="#1A9850",
             "Target: : started and tested at (n) ; Appear once" ="#2166AC",
             "Foil(n), Foil (n+1)" ="#E08214",
             "Foil(n); Appear once" ="#E08214",
             "Studied-only (n); Appear once" = "#1A9850",
             "Final Foil"="red" ),breaks=levelsStr_fn )+
  scale_fill_manual(values=c("Target: studied and tested at (n), Foil (n+1)"="#2166AC",
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
  ) +
  scale_linetype_discrete(breaks=levelsStr_fn) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Final Test Between List DATA"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

ggsave("final_test_between_list_data_e3.png", plot = p, width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI)
