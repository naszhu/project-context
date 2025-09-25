library(grDevices)
options(bitmapType='cairo')

library(here)
here::i_am("design3/data_analysis/quick_plot.r")
library(ggplot2) 
library(dplyr)
library(readr)

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")

d1ta = df_rt_pl %>%
  filter(!is.na(rt),rt<3000)%>%
  filter(task=="initialTest_response")%>%
  mutate(colorskeme=typecomment_in)%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme,subject_id)%>%
         summarise(cr = mean(correct))%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme)%>%
         summarise(cr = mean(cr))%>%
  mutate(listNum_appear0_initial=as.factor(listNum_appear0_initial))

levelsStr = c("New Foil", "Target", "Inherented Foil - Last Foil",
             "Inherented Foil - Last Target", "Inherented Foil - Last Studied Only") 

p <- ggplot(data=d1ta)+
  geom_line(aes(x=listNum_appear0_initial, y= cr ,group=interaction(task,colorskeme),color= colorskeme,linetype=colorskeme))+ 
  geom_point(aes(x=listNum_appear0_initial,y=cr,group=interaction(task,colorskeme),color=colorskeme,shape=colorskeme),size =4 )+
  facet_grid(.~task)+
  scale_color_manual(
    values = c("Inherented Foil - Last Foil" = "green", "Inherented Foil - Last Studied Only" = "green", "Inherented Foil - Last Target" = "green","New Foil" = "blue","Target"=  "purple"),
    breaks = levelsStr
  )+
  scale_shape_discrete(breaks=levelsStr)+
  scale_linetype_discrete(breaks=levelsStr)

ggsave("between_list_plot.png", plot = p, width = 10, height = 6, dpi = 300)
print("Plot saved as between_list_plot.png")