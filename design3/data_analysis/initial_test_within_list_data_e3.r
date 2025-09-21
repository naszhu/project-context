library(readr)
library(dplyr)
library(ggplot2)

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")


####################################### Within list by test position
d1ta = df_rt_pl%>% 
  filter(task=="initialTest_response")%>%
    mutate(type_comment = typecomment_in, testPos_appear0_initial =
             as.numeric(testPos_appear0_initial))%>%
  mutate(testPos_appear0_initial = ceiling(testPos_appear0_initial/3))%>%
         group_by(task, condition,type_comment, testPos_appear0_initial,subject_id )%>%
  # mutate(studyPos_appear0_initial=as.numeric(studyPos_appear0_initial))%>%
  mutate(testPos_appear0_initial=as.numeric(testPos_appear0_initial))%>% #change here to see that by study or test position
         summarise(cr = mean(correct))%>%
           group_by(task, condition,type_comment, testPos_appear0_initial )%>%
         summarise(cr = mean(cr))
  
p1=ggplot(data=d1ta)+
  geom_line(aes(x=testPos_appear0_initial, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+ 
  geom_point(aes(x=testPos_appear0_initial,y=cr,group=interaction(task,type_comment),shape=type_comment,color=type_comment))+
  facet_grid(.~task)+
  scale_color_manual(values=c("green","green","green","blue","purple"))

ggsave("initial_test_within_list_data_e3.png", plot = p1, width = 10, height = 6, dpi = 300)
 