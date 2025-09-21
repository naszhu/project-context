library(readr)
library(dplyr)
library(ggplot2)

df_rt_pl=read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")


####################################### Within list by test position
d1ta_test = df_rt_pl%>%
  filter(task=="initialTest_response")%>%
    mutate(type_comment = typecomment_in, testPos_appear0_initial =
             as.numeric(testPos_appear0_initial))%>%
  mutate(testPos_appear0_initial = ceiling(testPos_appear0_initial/3))%>%
         group_by(task, condition,type_comment, testPos_appear0_initial,subject_id )%>%
  mutate(testPos_appear0_initial=as.numeric(testPos_appear0_initial))%>%
         summarise(cr = mean(correct))%>%
           group_by(task, condition,type_comment, testPos_appear0_initial )%>%
         summarise(cr = mean(cr))%>%
  mutate(position_type = "Test Position", position = testPos_appear0_initial)

####################################### Within list by study position
d1ta_study = df_rt_pl%>%
  filter(task=="initialTest_response")%>%
  mutate(type_comment = typecomment_in, studyPos_appear0_initial = as.numeric(studyPos_appear0_initial))%>%
  mutate(studyPos_appear0_initial = ceiling(studyPos_appear0_initial/3))%>%
         group_by(task, condition,type_comment, studyPos_appear0_initial,subject_id )%>%
  mutate(studyPos_appear0_initial=as.numeric(studyPos_appear0_initial))%>%
         summarise(cr = mean(correct))%>%
           group_by(task, condition,type_comment, studyPos_appear0_initial )%>%
         summarise(cr = mean(cr))%>%
  mutate(position_type = "Study Position", position = studyPos_appear0_initial)

# Combine both datasets
d1ta_combined = bind_rows(d1ta_test, d1ta_study)

# Create combined plot with facet_grid
p_combined = ggplot(data=d1ta_combined)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment))+
  geom_point(aes(x=position,y=cr,group=interaction(task,type_comment),shape=type_comment,color=type_comment),size=2)+
  facet_grid(.~position_type)+
  scale_color_manual(values=c("green","green","green","blue","purple"))+
  labs(x = "Position", y = "Correct Response Rate")

ggsave("initial_test_within_list_data_e3.png", plot = p_combined, width = 12, height = 5, dpi = 300)
 