
library(readr)
library(dplyr)
library(ggplot2)

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
         summarise(cr = mean(correct))%>%
         group_by(task, condition,type_comment, listNum_appear1_initial)%>%
         summarise(cr = mean(cr))%>%
  mutate(position_type = "Initial Position", position = listNum_appear1_initial)

############ Second plot - Final position
d1taf_final = df_rt_pl%>%
    mutate(correct=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct))%>%
  filter(task=="finalTest")%>%
  mutate(type_comment=type_comment_fn)%>%
         group_by(task, condition,type_comment, listNum_infinalOrder, subject_id)%>%
         summarise(cr = mean(correct))%>%
         group_by(task, condition,type_comment, listNum_infinalOrder)%>%
         summarise(cr = mean(cr))%>%
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
p=ggplot(data=d1taf_combined)+
  geom_line(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,linetype=type_comment),size=1)+
  geom_point(aes(x=position, y= cr ,group=interaction(task,type_comment ),color= type_comment,shape=type_comment),size=4)+
  facet_grid(.~position_type)+
  scale_color_manual(values=c("Target: studied and tested at (n), Foil (n+1)"="purple","Studied-only (n); Foil (n+1)"="green",
             "Target: : started and tested at (n) ; Appear once" ="purple",
             "Foil(n), Foil (n+1)" ="blue",
             "Foil(n); Appear once" ="blue",
             "Studied-only (n); Appear once" = "green",
             "Final Foil"="red" ),breaks=levelsStr_fn )+
  scale_shape_discrete(breaks=levelsStr_fn)+
  scale_linetype_discrete(breaks=levelsStr_fn)+
  labs(x = "Position", y = "Correct Response Rate", title = "Final Test by Position")

ggsave("final_test_between_list_data_e3.png", plot = p, width = 10, height = 4, dpi = 300)
