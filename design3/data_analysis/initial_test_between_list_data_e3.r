
library(readr)
library(dplyr)
library(ggplot2)

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")

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
p <- ggplot(data=d1ta)+
  geom_ribbon(aes(x=listNum_appear0_initial, ymin= cr - se, ymax= cr + se, group=interaction(task,colorskeme), fill=colorskeme), alpha=0.3)+
  geom_line(aes(x=listNum_appear0_initial, y= cr ,group=interaction(task,colorskeme),color= colorskeme,linetype=colorskeme))+
  geom_point(aes(x=listNum_appear0_initial,y=cr,group=interaction(task,colorskeme),color=colorskeme,shape=colorskeme),size =5 )+
  
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
  )+theme_bw(base_size = 24) + # Set a large base font size for all text
 
    theme(
    plot.title = element_text(size = 18, face = "bold"),
    axis.title.x = element_text(size = 24, face = "bold"),
    axis.title.y = element_text(size = 24, face = "bold"),
    axis.text.x = element_text(size = 18),
    axis.text.y = element_text(size = 18),
    legend.position = "none",
    # legend.title = element_text(size = 20, face = "bold"),
    # legend.text = element_text(size = 18),
    strip.text = element_text(size = 28, face = "bold") # Facet grid label text size
  ) +
  labs(
    x = "Position", 
    y = "Correct Response Rate", 
    title = "Initial Test Between List Data"
  ) +
  # facet_grid(.~task)+
  facet_grid(. ~ task, labeller = labeller(task = c("initialTest_response" = "Initial List Number")))+
  scale_x_continuous(breaks = seq(0, 10, by = 1))+
  # scale_x_continuous(breaks = seq(min(d1ta_combined$position, na.rm=TRUE), max(d1ta_combined$position, na.rm=TRUE), by = 1)) +
  scale_y_continuous(breaks = seq(0.4, 0.9, by = 0.1), limits = c(0.38, 0.9))


ggsave("initial_test_between_list_data_e3.png", plot = p, width = 6, height = 6, dpi = 300)
