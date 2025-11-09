

library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
library(readr)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(grid) # for unit()
library(gridExtra)
library(png)
library(grid)


all_results=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/all_results.csv")
DF=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/DF.csv")
allresf_path <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/allresf.csv"
has_final_predictions <- FALSE
if (file.exists(allresf_path)) {
  allresf=read.csv(allresf_path)
  has_final_predictions <- TRUE
}

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")


###############################################################
#                INITIAL TEST WITHIN LIST                     #
###############################################################
# Plot formatting constants
PLOT_TITLE_SIZE <- 30
SUPER_TITLE_SIZE <- 35
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 30
BASE_SIZE <- 30
POINT_SIZE <- 6
POINT_STROKE <- 2
LINE_WIDTH <- 2
PLOT_WIDTH <- 19
PLOT_HEIGHT <- 6.5
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.44
Y_MAX <- 0.9
Y_BREAKS <- seq(0.4, 0.9, by = 0.1)



PLOT_THEME <- theme_minimal(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.5),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1),
    panel.border = element_rect(color = "black", linewidth = 0.5, fill = NA)
  )

#########################  DATA  ##############################
# (Insert code to load/process actual data for initial test within list here)
# Example:
# df_initial_within_data <- read.csv("path_to_initial_within_data.csv")
# summary(df_initial_within_data)
# (Add your data wrangling and summary code as needed)
###############################################################


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
d1ta_study = df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  mutate(
    type_comment = typecomment_in,

    # study_pos_choice = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_primary = suppressWarnings(as.numeric(studyPos_appear0_initial)),
    study_pos_alternate = suppressWarnings(as.numeric(studyPos_appear1_initial)),
    study_pos_choice = case_when(
      # the following is becuase studied only and target actaully had study position as well. Their study position were from last trial. so studypos1
      type_comment %in% c( 
        "Inherented Foil - Last Studied Only",
        "Inherented Foil - Last Target"
      ) & !is.na(study_pos_alternate) & study_pos_alternate > 0 ~ study_pos_alternate, #this assigns alternate for the two types
      TRUE ~ study_pos_primary #all others keep the original
    ),
    study_pos_choice = ceiling(study_pos_choice / 3)
  ) %>%
  group_by(task, condition, type_comment, study_pos_choice, subject_id) %>%
  summarise(crs = mean(correct)) %>%
  group_by(task, condition, type_comment, study_pos_choice) %>%
  summarise(cr = mean(crs), se = sd(crs) / sqrt(n()), .groups = "drop") %>%
  mutate(position_type = "Study Position", position = study_pos_choice)

d1ta_study %>% filter(type_comment=="Inherented Foil - Last Studied Only")%>% select(study_pos_choice)

x=df_rt_pl %>% filter(task=="initialTest_response")%>% 
filter(typecomment_in=="Inherented Foil - Last Studied Only")%>% 
select(studyPos_appear1_initial)
sum(x$studyPos_appear1_initial==1)

# Combine both datasets
d1ta_combined = bind_rows(d1ta_test, d1ta_study)

# df_rt_pl%>%filter(task=="initialTest_response")%>%filter(type_comment=="studied only, in next trial, from last trial")%>%select(studyPos_appear1_initial )
# d1ta_study %>% filter(type_comment=="studied only, in next trial, from last trial")%>% select(study_position_group)

# Create combined plot with facet_grid
p1_d = ggplot(data=d1ta_combined)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill=type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
  geom_point(aes(x=position,y=cr,group=interaction(task,type_comment),shape=type_comment,color=type_comment),size=POINT_SIZE, stroke=POINT_STROKE)+
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



#####################  PREDICTION  ############################
# (Insert code to load/process model predictions for initial test within list here)
# Example:
# df_initial_within_pred <- read.csv("path_to_initial_within_pred.csv")
# summary(df_initial_within_pred)
# (Add your prediction wrangling and plotting code as needed)
###############################################################

# Data processing for prediction plot
df1_test = all_results %>%
  mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target) %>%
  mutate(is_target=type_specific) %>%
  mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-"))) %>%
  group_by(testpos,is_target,simulation_number) %>%
  summarize(meanx=mean(correct)) %>%
  group_by(testpos,is_target) %>%
  summarize(meanx=mean(meanx)) %>%
  mutate(test_position_grouped = ceiling(testpos / 3)) %>%
  group_by(test_position_grouped, is_target) %>%
  summarise(meanx = mean(meanx)) %>%
  mutate(position_type = "Test Position", position = test_position_grouped)

df1_study = all_results %>%
  mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target) %>%
  mutate(is_target=type_specific) %>%
  mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-"))) %>%
  group_by(studypos,is_target,simulation_number) %>%
  summarize(meanx=mean(correct)) %>%
  group_by(studypos,is_target) %>%
  summarize(meanx=mean(meanx)) %>%
  mutate(study_position_grouped = ceiling(studypos / 3)) %>%
  group_by(study_position_grouped, is_target) %>%
  summarise(meanx = mean(meanx)) %>%
  mutate(position_type = "Study Position", position = study_position_grouped)

# Combine both datasets
df1_combined = bind_rows(df1_test, df1_study)

# Create combined plot with facet_grid
p1_p = ggplot(data=df1_combined, aes(x=position, y=meanx, group=is_target)) +
  geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
  geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE, stroke=POINT_STROKE) +
  facet_grid(.~position_type) +
  scale_color_manual(
    values = c("F" = "#E08214",           # orange for new foil
              "Fb-Fn" = "#E08214",        # orange for confusing foil foil
              "Fb-SOn" = "#1A9850",       # green for confusing foil studied only
              "Fb-Tn" = "#2166AC",        # blue for confusing foil target
              "T" = "#2166AC")            # blue for target
  ) +
  scale_shape_manual(
    values = c("F" = 17,                  # solid triangle
              "Fb-Fn" = 2,                # open triangle
              "Fb-SOn" = 1,               # open circle
              "Fb-Tn" = 0,                # open square
              "T" = 15                    # solid square
              )                    
  ) +
  scale_linetype_manual(
    values = c("F" = "solid",
              "Fb-Fn" = "dashed",
              "Fb-SOn" = "dashed",
              "Fb-Tn" = "dashed",
              "T" = "solid")
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Initial Test Within List PREDICTION"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))



# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  p1_d, p1_p,
  ncol = 2,
  top = textGrob("E2 Initial Within List: DATA vs PREDICTION",
                 gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
)

ggsave("E3_initial_within_list_combined.png", combined_plot, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = 300, bg = "white")


###############################################################
###############################################################
###############################################################
#                INITIAL TEST BETWEEN LIST                    #
###############################################################
###############################################################
###############################################################


# Plot formatting constants
PLOT_TITLE_SIZE <- 30
SUPER_TITLE_SIZE <- 35
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 30
BASE_SIZE <- 30
POINT_SIZE <- 8
LINE_WIDTH <- 2
PLOT_WIDTH <- 16
PLOT_HEIGHT <- 8
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.38
Y_MAX <- 0.93
Y_BREAKS <- seq(0.4, 0.9, by = 0.1)


PLOT_THEME <- theme_minimal(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.5),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1),
    panel.border = element_rect(color = "black", linewidth = 0.5, fill = NA)
  )


#########################  DATA  ##############################
# (Insert code to load/process actual data for initial test between list here)
# Example:
# df_initial_between_data <- read.csv("path_to_initial_between_data.csv")
# summary(df_initial_between_data)
# (Add your data wrangling and summary code as needed)
###############################################################

d1ta = df_rt_pl %>%
  # filter(subject_id%in%c("67dc712c511053c8d90e2c29","67eac4d6bf3d1c4df7bd65df","67ed4e79983b8a8ba5517548"))%>%
# d1ta = df_pl3%>%
  # filter(listNum_appear0_initial!=1 )%>%
# d1ta = df_pl2%>% 
  filter(!is.na(rt),rt<3000)%>%
  filter(task=="initialTest_response")%>%
  # mutate(colorskeme=type_comment)%>%
  mutate(colorskeme=typecomment_in)%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme,subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme)%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')
  # mutate(type_comment=as.factor(type_comment))
  
#   [1] "Inherented Foil - Last Foil"       
# [2] "Inherented Foil - Last Studied Only"
# [3] "Inherented Foil - Last Target"      
# [4] "New Foil"                           
# [5] "Target"
levelsStr = c("New Foil", "Target", "Inherented Foil - Last Foil" ,
             "Inherented Foil - Last Target" ,"Inherented Foil - Last Studied Only") 

############# Between list results
#######################################################
p2_d <- ggplot(data=d1ta)+
  geom_ribbon(aes(x=listNum_appear0_initial, ymin= cr - se, ymax= cr + se, group=interaction(task,colorskeme), fill=colorskeme), alpha=0.3)+
  geom_line(aes(x=listNum_appear0_initial, y= cr ,group=interaction(task,colorskeme),color= colorskeme,linetype=colorskeme),linewidth=LINE_WIDTH)+
  geom_point(aes(x=listNum_appear0_initial,y=cr,group=interaction(task,colorskeme),color=colorskeme,shape=colorskeme),size = POINT_SIZE, stroke=POINT_STROKE)+
  
  scale_color_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",  # warm orange-red
      "Inherented Foil - Last Studied Only" = "#1A9850",  # warm yellow-orange
      "Inherented Foil - Last Target" = "#2166AC",  # warm yellow
      "New Foil" = "#E08214",  # warm orange
      "Target" = "#2166AC"     # blue (cool, for contrast)
    ),
    breaks = levelsStr # change order in legend
  )+
  scale_fill_manual(
    values = c(
      "Inherented Foil - Last Foil" = "#E08214",  # warm orange-red
      "Inherented Foil - Last Studied Only" = "#1A9850",  # warm yellow-orange
      "Inherented Foil - Last Target" = "#2166AC",  # warm yellow
      "New Foil" = "#E08214",  # warm orange
      "Target" = "#2166AC"     # blue (cool, for contrast)
    ),
    breaks = levelsStr # change order in legend
  )+
  scale_linetype_manual(
    values = c(
      "Inherented Foil - Last Foil" = "dashed",
      "Inherented Foil - Last Studied Only" = "dashed",
      "Inherented Foil - Last Target" = "dashed",
      "New Foil" = "solid",
      "Target" = "solid"
    ),
    breaks = levelsStr
  )+
  scale_shape_manual(
    values = c(
      "New Foil" = 17,                     # solid triangle
      "Target" = 15,                       # solid square
      "Inherented Foil - Last Foil" = 2,   # open triangle
      "Inherented Foil - Last Target" = 0, # open square
      "Inherented Foil - Last Studied Only" = 1 # open circle
    ),
    breaks = levelsStr
  ) + PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Initial Test Between List Data"
  ) +
  # facet_grid(.~task)+
  facet_grid(. ~ task, labeller = labeller(task = c("initialTest_response" = "Initial List Number")))+
  scale_x_continuous(breaks = seq(0, 10, by = 1))+
  # scale_x_continuous(breaks = seq(min(d1ta_combined$position, na.rm=TRUE), max(d1ta_combined$position, na.rm=TRUE), by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))






#####################  initial test between PREDICTION  ############################
# (Insert code to load/process model predictions for initial test between list here)
# Example:
# df_initial_between_pred <- read.csv("path_to_initial_between_pred.csv")
# summary(df_initial_between_pred)
# (Add your prediction wrangling and plotting code as needed)
###############################################################



DF2 = all_results %>% 
mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
# mutate(correct=decision_isold==is_targe)%>%
# mutate(test_position=as.numeric(test_position))%>%
mutate(is_target=type_specific)%>%
mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-")))%>%
group_by(list_number,is_target,simulation_number)%>%
summarize(meanx=mean(correct))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))%>%mutate(task="Initial List Number")

p2_p = ggplot(data = DF2, aes(x = list_number, y = meanx, group = is_target)) +
  geom_point(aes(color = is_target, shape = is_target), size = POINT_SIZE, stroke = POINT_STROKE) +
  geom_line(aes(color = is_target, linetype = is_target), linewidth = LINE_WIDTH) +
  scale_x_continuous(
    name = POSITION_LABEL,
    breaks = 1:10,
    labels = as.character(1:10)
  ) +
  scale_color_manual(
    values = c(
      "F" = "#E08214",
      "Fb-Fn" = "#E08214", 
      "Fb-SOn" = "#1A9850",
      "Fb-Tn" = "#2166AC",
      "T" = "#2166AC"
    )
  ) +
  scale_shape_manual(
    values = c(
      "F" = 17,          # solid triangle
      "Fb-Fn" = 2,       # open triangle
      "Fb-SOn" = 1,      # open circle
      "Fb-Tn" = 0,       # open square
      "T" = 15           # solid square
    )
  ) +
  scale_linetype_manual(
    values = c(
      "F" = "solid",
      "Fb-Fn" = "dashed",
      "Fb-SOn" = "dashed", 
      "Fb-Tn" = "dashed",
      "T" = "solid"
    )
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Initial Test Between List PREDICTION"
  ) +
  facet_grid(. ~ task, labeller = labeller(task = c("initialTest_response" = "Initial List Number"))) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))
# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  p2_d, p2_p,
  ncol = 2,
  top = textGrob("E2 Initial Between List: DATA vs PREDICTION",
                 gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
)

# Save the combined plot
ggsave("E3_initial_between_list_combined.png", combined_plot, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = 300, bg = "white")


###############################################################
###############################################################
###############################################################
#                FINAL TEST WITHIN LIST                       #
###############################################################
###############################################################
###############################################################

# Plot formatting constants
PLOT_TITLE_SIZE <- 35
SUPER_TITLE_SIZE <- 40
AXIS_TITLE_SIZE <- 35
AXIS_TEXT_SIZE <- 35
STRIP_TEXT_SIZE <- 35
BASE_SIZE <- 35
POINT_STROKE <- 2
POINT_SIZE <- 7
LINE_WIDTH <- 2
PLOT_WIDTH <- 11
PLOT_HEIGHT <- 6
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.45
Y_MAX <- 1.0
Y_BREAKS <- seq(0.45, 1.0, by = 0.1)

PLOT_THEME <- theme_minimal(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.5),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1),
    panel.border = element_rect(color = "black", linewidth = 0.5, fill = NA)
  )

#########################  DATA FINAL TEST WITHIN LIST  ##############################
# (Insert code to load/process actual data for final test within list here)
# Example:
# df_final_within_data <- read.csv("path_to_final_within_data.csv")
# summary(df_final_within_data)
# (Add your data wrangling and summary code as needed)
###############################################################



levelsStr_fn = levels(as.factor(df_rt_pl$type_comment_fn))

# Identify confusing foil types (those with "(n+1)" in the name)
confusing_foil_types = c(
  "Target: studied and tested at (n), Foil (n+1)",
  "Studied-only (n); Foil (n+1)",
  "Foil(n), Foil (n+1)"
)

#################### ROW 1: First Appearance Test Position ####################
# Within plot 1 - Test position (using first appearance: testPos_appear1_initial)
d1taf_test_row1 = df_rt_pl%>%
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
  mutate(position_type = "Test Position", position = testPos_appear1_initial, row_type = "First Appearance")

# Within plot 2 - Study position (always use first appearance: studyPos_appear1_initial)
d1taf_study_row1 = df_rt_pl%>%
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
  mutate(position_type = "Study Position", position = listNum_infinalOrder, row_type = "First Appearance")

# Combine both datasets for row 1
d1taf_combined_row1 = bind_rows(d1taf_test_row1, d1taf_study_row1)

# Create original single-row plot (using row 1 data)
p3_d = ggplot(data=d1taf_combined_row1)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
    geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE, stroke=POINT_STROKE)+
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
      "Final Foil" = 4                                           # cross
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

# Create combined plot for row 1 (for new 4-plot version)
p3_d_row1 = ggplot(data=d1taf_combined_row1)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
    geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE, stroke=POINT_STROKE)+
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
      "Final Foil" = 4                                           # cross
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

#################### ROW 2: Confusing Foil Test Position ####################
# For confusing foils: use testPos_appear2_initial (when they appeared as confusing foils)
# For non-confusing foils: use testPos_appear1_initial (first appearance)
d1taf_test_row2 = df_rt_pl%>%
    mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  mutate(type_comment=type_comment_fn)%>%
  mutate(
    testPos_appear1_num = as.numeric(testPos_appear1_initial),
    testPos_appear2_num = as.numeric(testPos_appear2_initial),
    # For confusing foils, use testPos_appear2_initial; for others, use testPos_appear1_initial.
    # Final-test-only and non-confusing studied-only items should still appear in the plot at position 0.
    testPos_choice_raw = case_when(
      type_comment %in% c("Final Foil", "Studied-only (n); Appear once") ~ 0,
      type_comment %in% confusing_foil_types & !is.na(testPos_appear2_num) & testPos_appear2_num > 0 ~ testPos_appear2_num,
      !is.na(testPos_appear1_num) & testPos_appear1_num > 0 ~ testPos_appear1_num,
      TRUE ~ 0
    ),
    testPos_choice = if_else(testPos_choice_raw > 0, ceiling(testPos_choice_raw / 3), 0)
  )%>%
  filter(task=="finalTest", !is.na(testPos_choice))%>%
   group_by(task, condition,type_comment, testPos_choice, subject_id)%>%
         summarise(crs = mean(correct))%>%
         group_by(task, condition,type_comment, testPos_choice )%>%
         summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop')%>%
  mutate(position_type = "Test Position", position = testPos_choice, row_type = "Confusing Foil Test Position")

# Study position (always use first appearance: studyPos_appear1_initial)
d1taf_study_row2 = df_rt_pl%>%
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
  mutate(position_type = "Study Position", position = listNum_infinalOrder, row_type = "Confusing Foil Test Position")

# Combine both datasets for row 2
d1taf_combined_row2 = bind_rows(d1taf_test_row2, d1taf_study_row2)

# Create combined plot for row 2
p3_d_row2 = ggplot(data=d1taf_combined_row2)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
    geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE, stroke=POINT_STROKE)+
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
      "Final Foil" = 4                                           # cross
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



#####################  PREDICTION FINAL TEST WITHIN LIST  ############################
# (Insert code to load/process model predictions for final test within list here)
# Example:
# df_final_within_pred <- read.csv("path_to_final_within_pred.csv")
# summary(df_final_within_pred)
# (Add your prediction wrangling and plotting code as needed)
###############################################################


if (has_final_predictions) {
  #################### ROW 1: First Appearance Test Position - PREDICTION ####################
  # Data processing for prediction plot - Test Position (using first appearance)
  df1_test_row1 = allresf %>% 
    mutate(correct = case_when( 
      (decision_isold==1) & (is_target=="true") ~ 1, 
      decision_isold==0 & is_target=="false" ~ 1,
      TRUE ~ 0)) %>%
    mutate(is_target = sub('"[^"]*$', '', type_specific)) %>%
    mutate(test_position_grouped = ceiling(as.numeric(initial_testpos) / 3)) %>%
    group_by(test_position_grouped, is_target, simulation_number) %>%
    summarize(meanx = mean(correct)) %>%
    group_by(test_position_grouped, is_target) %>%
    summarize(meanx = mean(meanx)) %>%
    mutate(position_type = "Test Position", position = test_position_grouped, row_type = "First Appearance")

  # Data processing for prediction plot - Study Position  
  df1_study_row1 = allresf %>% 
    mutate(correct = case_when( 
      (decision_isold==1) & (is_target=="true") ~ 1, 
      decision_isold==0 & is_target=="false" ~ 1,
      TRUE ~ 0)) %>%
    mutate(is_target = sub('"[^"]*$', '', type_specific)) %>%
    mutate(study_position_grouped = ceiling(as.numeric(initial_studypos) / 3)) %>%
    group_by(study_position_grouped, is_target, simulation_number) %>%
    summarize(meanx = mean(correct)) %>%
    group_by(study_position_grouped, is_target) %>%
    summarize(meanx = mean(meanx)) %>%
    mutate(position_type = "Study Position", position = study_position_grouped, row_type = "First Appearance")

  # Combine both datasets for row 1
  df1_combined_row1 = bind_rows(df1_test_row1, df1_study_row1)

  # Create original single-row prediction plot (using row 1 data)
  pf3_p = ggplot(data=df1_combined_row1, aes(x=position, y=meanx, group=is_target)) +
    geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
    geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE, stroke=POINT_STROKE) +
    facet_grid(.~position_type) +
    scale_color_manual(
      values = c("F" = "#E08214",
                "FF" = "red",
                "Fn_p1" = "#E08214",
                "SO" = "#1A9850",
                "SOn_p1" = "#1A9850",
                "T" = "#2166AC",
                "Tn_p1" = "#2166AC")
    ) +
    scale_shape_manual(
      values = c("F" = 17,
                "FF" = 4,
                "Fn_p1" = 2,
                "SO" = 16,
                "SOn_p1" = 1,
                "T" = 15, #solid square
                "Tn_p1" = 0) #open square
    ) +
    scale_linetype_manual(
      values = c("F" = "solid",
                "FF" = "solid",
                "Fn_p1" = "dashed",
                "SO" = "dashed",
                "SOn_p1" = "dashed",
                "T" = "solid",
                "Tn_p1" = "dashed")
    ) +
    PLOT_THEME +
    labs(
      x = POSITION_LABEL, 
      y = CORRECT_RATE_LABEL, 
      title = "Final Test Within List PREDICTION"
    ) +
    scale_x_continuous(breaks = seq(0, 10, by = 1)) +
    scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

  # Create combined plot with facet_grid for row 1 (for new 4-plot version)
  pf3_p_row1 = ggplot(data=df1_combined_row1, aes(x=position, y=meanx, group=is_target)) +
    geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
    geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE, stroke=POINT_STROKE) +
    facet_grid(.~position_type) +
    scale_color_manual(
      values = c("F" = "#E08214",
                "FF" = "red",
                "Fn_p1" = "#E08214",
                "SO" = "#1A9850",
                "SOn_p1" = "#1A9850",
                "T" = "#2166AC",
                "Tn_p1" = "#2166AC")
    ) +
    scale_shape_manual(
      values = c("F" = 17,
                "FF" = 4,
                "Fn_p1" = 2,
                "SO" = 16,
                "SOn_p1" = 1,
                "T" = 15, #solid square
                "Tn_p1" = 0) #open square
    ) +
    scale_linetype_manual(
      values = c("F" = "solid",
                "FF" = "solid",
                "Fn_p1" = "dashed",
                "SO" = "dashed",
                "SOn_p1" = "dashed",
                "T" = "solid",
                "Tn_p1" = "dashed")
    ) +
    PLOT_THEME +
    labs(
      x = POSITION_LABEL, 
      y = CORRECT_RATE_LABEL, 
      title = "Final Test Within List PREDICTION"
    ) +
    scale_x_continuous(breaks = seq(0, 10, by = 1)) +
    scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

  #################### ROW 2: Confusing Foil Test Position - PREDICTION ####################
  # Data processing for prediction plot - Test Position (using confusing foil position for confusing foils when available)
  df1_test_row2 = allresf %>% 
    mutate(correct = case_when( 
      (decision_isold==1) & (is_target=="true") ~ 1, 
      decision_isold==0 & is_target=="false" ~ 1,
      TRUE ~ 0)) %>%
    mutate(
      is_target = sub('"[^"]*$', '', type_specific),
      initial_testpos_numeric = suppressWarnings(as.numeric(initial_testpos)),
      confusing_testpos_numeric = suppressWarnings(as.numeric(confusing_testpos)),
      test_position_choice = case_when(
        is_target %in% c("Fn_p1", "SOn_p1", "Tn_p1", "Fn", "SOn", "Tn") &
          !is.na(confusing_testpos_numeric) & confusing_testpos_numeric > 0 ~ confusing_testpos_numeric,
        TRUE ~ initial_testpos_numeric
      ),
      test_position_grouped = ceiling(test_position_choice / 3)
    ) %>%
    group_by(test_position_grouped, is_target, simulation_number) %>%
    summarize(meanx = mean(correct)) %>%
    group_by(test_position_grouped, is_target) %>%
    summarize(meanx = mean(meanx)) %>%
    mutate(position_type = "Test Position", position = test_position_grouped, row_type = "Confusing Foil Test Position")

  # Data processing for prediction plot - Study Position (always first appearance)
  df1_study_row2 = allresf %>% 
    mutate(correct = case_when( 
      (decision_isold==1) & (is_target=="true") ~ 1, 
      decision_isold==0 & is_target=="false" ~ 1,
      TRUE ~ 0)) %>%
    mutate(is_target = sub('"[^"]*$', '', type_specific)) %>%
    mutate(study_position_grouped = ceiling(as.numeric(initial_studypos) / 3)) %>%
    group_by(study_position_grouped, is_target, simulation_number) %>%
    summarize(meanx = mean(correct)) %>%
    group_by(study_position_grouped, is_target) %>%
    summarize(meanx = mean(meanx)) %>%
    mutate(position_type = "Study Position", position = study_position_grouped, row_type = "Confusing Foil Test Position")

  # Combine both datasets for row 2
  df1_combined_row2 = bind_rows(df1_test_row2, df1_study_row2)

  # Create combined plot with facet_grid for row 2
  pf3_p_row2 = ggplot(data=df1_combined_row2, aes(x=position, y=meanx, group=is_target)) +
    geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
    geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE, stroke=POINT_STROKE) +
    facet_grid(.~position_type) +
    scale_color_manual(
      values = c("F" = "#E08214",
                "FF" = "red",
                "Fn_p1" = "#E08214",
                "SO" = "#1A9850",
                "SOn_p1" = "#1A9850",
                "T" = "#2166AC",
                "Tn_p1" = "#2166AC")
    ) +
    scale_shape_manual(
      values = c("F" = 17,
                "FF" = 4,
                "Fn_p1" = 2,
                "SO" = 16,
                "SOn_p1" = 1,
                "T" = 15, #solid square
                "Tn_p1" = 0) #open square
    ) +
    scale_linetype_manual(
      values = c("F" = "solid",
                "FF" = "solid",
                "Fn_p1" = "dashed",
                "SO" = "dashed",
                "SOn_p1" = "dashed",
                "T" = "solid",
                "Tn_p1" = "dashed")
    ) +
    PLOT_THEME +
    labs(
      x = POSITION_LABEL, 
      y = CORRECT_RATE_LABEL, 
      title = "Final Test Within List PREDICTION"
    ) +
    scale_x_continuous(breaks = seq(0, 10, by = 1)) +
    scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

  # Create original combined plot using grid.arrange (1 row x 2 columns)
  combined_plot_original <- grid.arrange(
    p3_d, pf3_p,
    ncol = 2,
    top = textGrob("E3 Final Test Within List: DATA vs PREDICTION",
                   gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
  )

  # Save the original combined plot
  ggsave("E3_final_test_within_list_combined.png", combined_plot_original, 
         width = 24, height = 8, dpi = 300, bg = "white")

  # Create new combined plot using grid.arrange - 2 rows x 2 columns
  combined_plot_new <- grid.arrange(
    p3_d_row1, pf3_p_row1,
    p3_d_row2, pf3_p_row2,
    ncol = 2, nrow = 2,
    top = textGrob("E3 Final Test Within List: DATA vs PREDICTION (First Appearance vs Confusing Foil Position)",
                   gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
  )

  # Save the new combined plot with 4 plots
  ggsave("E3_final_test_within_list_combined_4plots.png", combined_plot_new, 
         width = 24, height = 16, dpi = 300, bg = "white")
} else {
  cat("Final test not predicted\n")
  
  # Save original data plot
  ggsave("E3_final_test_within_list_combined.png", p3_d, 
         width = 12, height = 6, dpi = 300, bg = "white")
  
  # Even without predictions, create a 2-row plot with just data
  combined_plot_data <- grid.arrange(
    p3_d_row1,
    p3_d_row2,
    ncol = 1, nrow = 2,
    top = textGrob("E3 Final Test Within List: DATA",
                   gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
  )
  
  ggsave("E3_final_test_within_list_combined_4plots.png", combined_plot_data, 
         width = 12, height = 16, dpi = 300, bg = "white")
}


###############################################################
###############################################################
###############################################################
#                FINAL TEST BETWEEN LIST                      #
###############################################################
###############################################################
###############################################################


if (has_final_predictions) {
# Plot formatting constants
PLOT_TITLE_SIZE <- 30
SUPER_TITLE_SIZE <- 35
AXIS_TITLE_SIZE <- 30
AXIS_TEXT_SIZE <- 30
STRIP_TEXT_SIZE <- 35
BASE_SIZE <- 25
POINT_SIZE <- 6
POINT_STROKE <- 2
LINE_WIDTH <- 2
PLOT_WIDTH <- 11
PLOT_HEIGHT <- 6.5
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.47
Y_MAX <- 0.96
Y_BREAKS <- seq(0.5, 1.0, by = 0.1)

PLOT_THEME <- theme_minimal(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.5),
    strip.background = element_rect(fill = "white", color = "black", linewidth = 1),
    panel.border = element_rect(color = "black", linewidth = 0.5, fill = NA)
  )

#########################  DATA FINAL TEST BETWEEN LIST   ##############################
# (Insert code to load/process actual data for final test between list here)
# Example:
# df_final_between_data <- read.csv("path_to_final_between_data.csv")
# summary(df_final_between_data)
# (Add your data wrangling and summary code as needed)
###############################################################


levelsStr_fn = levels(as.factor(df_rt_pl$type_comment_fn))

############ First plot - Initial position
d1taf_initial = df_rt_pl%>%
  mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct)) %>%
  filter(task=="finalTest") %>%
  mutate(type_comment=type_comment_fn) %>%
  # If initial position is 10, change type_comment for the specified types
  mutate(type_comment = case_when(
    listNum_appear1_initial == 10 & type_comment == "Foil(n), Foil (n+1)" ~ "Foil(n); Appear once",
    listNum_appear1_initial == 10 & type_comment == "Studied-only (n); Foil (n+1)" ~ "Studied-only (n); Appear once",
    listNum_appear1_initial == 10 & type_comment == "Target: studied and tested at (n), Foil (n+1)" ~ "Target: : started and tested at (n) ; Appear once",
    TRUE ~ type_comment
  )) %>%
  group_by(task, condition, type_comment, listNum_appear1_initial, subject_id) %>%
  summarise(crs = mean(correct)) %>%
  group_by(task, condition, type_comment, listNum_appear1_initial) %>%
  summarise(cr = mean(crs), se = sd(crs)/sqrt(n()), .groups = 'drop') %>%
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
p4_d <- ggplot(data=d1taf_combined)+
  geom_ribbon(aes(x=position, ymin= cr - se, ymax= cr + se, group=interaction(task,type_comment), fill= type_comment), alpha=0.3)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment),linewidth=1)+
  geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=POINT_SIZE, stroke=POINT_STROKE)+
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
      "Final Foil" = 4                                           # cross
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



#####################  PREDICTION FINAL TEST BETWEEN LIST   ############################
# (Insert code to load/process model predictions for final test between list here)
# Example:
# df_final_between_pred <- read.csv("path_to_final_between_pred.csv")
# summary(df_final_between_pred)
# (Add your prediction wrangling and plotting code as needed)
###############################################################


    # head(allresf)
    DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target=="true") ~ 1,
    decision_isold==0 & is_target=="false" ~1,TRUE ~ 0))%>%
    
     mutate(is_target=type_general)%>%
    mutate(test_position=as.numeric(test_position))%>%
    mutate(test_position_group=ntile(test_position,10))%>%
    group_by(test_position_group,is_target,condition)%>%
    summarize(meanx=mean(correct))


    DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target=="true") ~ 1, 
    decision_isold==0 & is_target=="false" ~1,TRUE ~ 0))%>%
    mutate(is_target=type_general)%>%
    mutate(list_number=as.numeric(list_number))%>%
    mutate(is_target = case_when(list_number==10 & is_target%in%c("Tn","SOn","Fn") ~  substr(is_target, 1, nchar(is_target) - 1),
    TRUE ~ is_target))%>%
    group_by(list_number,is_target,condition)%>%
    summarize(meanx=mean(correct))


# assume your data has a factor called “type_comment” with exactly these 7 levels
my.ltys <- c(
  "Tn"  = "longdash",  # 1. Target: studied & tested at (n), Foil (n+1)
  "SOn" = "dotted",    # 2. Studied-only (n); Foil (n+1)
  "T"   = "dotdash",   # 3. Target: started & tested at (n); Appear once
  "Fn"  = "dashed",    # 4. Foil (n), Foil (n+1)
  "F"   = "solid",     # 5. Foil (n); Appear once
  "SO"  = "dashed",    # 6. Studied-only (n); Appear once
  "FF"  = "solid"      # 7. Final Foil
)

my.shps <- c(
  "Tn"                = NA,    # no point glyph
  "SOn"          = 22,    # square (filled/colourable)
  "T"    = 8,     # asterisk/star
  "Fn"              = 24,    # filled triangle-up
  "F"      = 15,    # filled square
  "SO"     = 3,     # plus
  "FF"            = 16     # filled circle
)
    
    #assuming this list number is first-appear list number
    df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%
    ungroup()%>%select(-list_number)%>%
    full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
    mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
    select(-c("meanx.x","meanx.y"))%>%
    pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")%>%
    mutate(position_kind = case_when(
      position_kind == "final_test_order" ~ "Final Position",
      position_kind == "initial_list_order" ~ "Initial Position",
      TRUE ~ position_kind
    ))


# Create combined plot with facet_grid
# Create combined plot with facet_grid
pf4_p = ggplot(data=df_allfinal, aes(test_position_group, val, group=interaction(position_kind, is_target))) +
  geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
  geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE, stroke=POINT_STROKE) +
  facet_grid(. ~ position_kind) +
  scale_color_manual(
    values = c("Tn" = "#2166AC",            # blue for target
              "SOn" = "#1A9850",            # green for studied only
              "T" = "#2166AC",              # blue for target
              "Fn" = "#E08214",             # orange for foil
              "F" = "#E08214",              # orange for foil
              "SO" = "#1A9850",             # green for studied only
              "FF" = "red")                 # red for final foil
  ) +
  scale_shape_manual(
    values = c("Tn" = 0,                    # open square
              "SOn" = 1,                    # open circle
              "T" = 15,                     # solid square
              "Fn" = 2,                     # open triangle
              "F" = 17,                     # solid triangle
              "SO" = 16,                    # solid circle
              "FF" = 4)                     # cross
  ) +
  scale_linetype_manual(
    values = c("Tn" = "dashed",
              "SOn" = "dashed",
              "T" = "solid",
              "Fn" = "dashed",
              "F" = "solid",
              "SO" = "dashed",
              "FF" = "solid")
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Final Test Between List PREDICTION"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))


# Create combined plot using grid.arrange
combined_plot <- grid.arrange(
  p4_d, pf4_p,
  ncol = 2,
  top = textGrob("E2 Final Test Between List: DATA vs PREDICTION",
                 gp = gpar(fontsize = SUPER_TITLE_SIZE, fontface = "bold"))
)}

# Save the combined plot
if (has_final_predictions) {
ggsave("E3_final_test_between_list_combined.png", combined_plot, 
       width = 24, height = 7, dpi = 300, bg = "white")
} else {
  cat("Final test not predicted: skipping final between-list prediction plots.\n")
}
 