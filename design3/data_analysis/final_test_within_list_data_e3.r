
library(readr)
library(dplyr)
library(ggplot2)

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
    geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=5)+
  facet_grid(.~position_type)+
  ylim(c(0.5,1))+
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
  labs(x = "Position", y = "Correct Response Rate", title = "Final Test Within List by Position")

ggsave("final_test_within_list_data_e3.png", plot = p, width = 12, height = 5, dpi = 300)
