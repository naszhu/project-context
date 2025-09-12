
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
         summarise(cr = mean(correct))%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme)%>%
         summarise(cr = mean(cr))%>%
  mutate(listNum_appear0_initial=as.factor(listNum_appear0_initial))
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
  geom_line(aes(x=listNum_appear0_initial, y= cr ,group=interaction(task,colorskeme),color= colorskeme,linetype=colorskeme))+ 
  geom_point(aes(x=listNum_appear0_initial,y=cr,group=interaction(task,colorskeme),color=colorskeme,shape=colorskeme),size =4 )+
  facet_grid(.~task)+
  scale_color_manual(
  values = c("Inherented Foil - Last Foil" = "green", "Inherented Foil - Last Studied Only" = "green", "Inherented Foil - Last Target" = "green","New Foil" = "blue","Target"=  "purple"),
  breaks =  levelsStr# change order in legend
)+
  scale_shape_discrete(breaks=levelsStr)+
  scale_linetype_discrete(breaks=levelsStr)

ggsave("initial_test_between_list_data_e3.png", plot = p, width = 10, height = 6, dpi = 300)
