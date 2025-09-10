library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

all_results=read.csv("../../../all_results.csv")
DF=read.csv("../../../DF.csv")
allresf=read.csv("../../../allresf.csv")

DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(test_position=as.numeric(test_position))%>%
mutate(test_position_group=ntile(test_position,10))%>%
group_by(test_position_group,is_target,condition)%>%
summarize(meanx=mean(correct))

p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target), size=3)+
geom_line(aes(color=is_target), linewidth=1.5)+
scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
facet_grid(condition~.)+
theme_minimal()+
theme(text=element_text(size=16), panel.border = element_rect(colour="black", fill=NA, linewidth=0.5))+
labs(title="Test Position Group Analysis", x="Test Position Group", y="Mean Accuracy")

DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(list_number=as.numeric(list_number))%>%
group_by(list_number,is_target,condition)%>%
summarize(meanx=mean(correct))

p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target), size=3)+
geom_line(aes(color=is_target), linewidth=1.5)+
scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
facet_grid(condition~.)+
theme_minimal()+
theme(text=element_text(size=16), panel.border = element_rect(colour="black", fill=NA, linewidth=0.5))+
labs(title="List Number Analysis", x="List Number", y="Mean Accuracy")

df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%ungroup()%>%select(-list_number)%>%
full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
select(-c("meanx.x","meanx.y"))%>%
pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")%>%
group_by(position_kind,test_position_group,condition)%>%
mutate(mean_mean=mean(val))

pf1=ggplot(data=df_allfinal, aes(test_position_group,val,group=interaction(position_kind,condition,is_target)))+
    geom_point(aes(color=is_target,group=is_target), size=3)+
    geom_line(aes(color=is_target,group=is_target),linewidth=2)+
    facet_grid(factor(condition, levels=c("true_random", "backward", "forward"))~position_kind)+
    labs(x="Final test position cut in 10 chunks (left column), Initial test list order (right column)",
        y="prediction (Hits/Correct Rejection)",
        caption="Figure 3. Between List Final Test Results seen in Final Testing",
        color="Type",fill="Type")+
    scale_color_manual(values=c("blue","yellow","orange","green"))+
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=18),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )+
    ylim(c(0.5,1))+
    geom_line(aes(y=mean_mean),linewidth=2,color="black")

DFff = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(initial_studypos = as.numeric(initial_studypos))%>%
group_by(initial_studypos,is_target,condition)%>%
summarize(meanx=mean(correct))

pf3=ggplot(data=DFff, aes(x=initial_studypos,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target), size=3)+
geom_line(aes(color=is_target),linewidth=2)+
theme_minimal()+
theme(
        plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
    plot.margin = margin(t = 10, b = 40),
    text=element_text(size=16),
    panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
)+
labs(title="Initial Study Position Analysis", x="Initial Study Position", y="Mean Accuracy")+
facet_grid(condition~.)

DFff2 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(initial_testpos = as.numeric(initial_testpos))%>%
group_by(initial_testpos,is_target,condition)%>%
summarize(meanx=mean(correct))

pf4=ggplot(data=DFff2, aes(x=initial_testpos,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target), size=3)+
geom_line(aes(color=is_target),linewidth=2)+
theme_minimal()+
theme(
    text=element_text(size=16),
    panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
)+
labs(title="Initial Test Position Analysis", x="Initial Test Position", y="Mean Accuracy")+
facet_grid(condition~.)

DF_fbyi = allresf %>% 
    mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
    pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
    group_by(pos_factor,posSum,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(pos_factor,posSum,is_target)%>%
    summarize(meanx=mean(meanx))

pf4= ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
    geom_point(aes(color=is_target), size=3)+
    geom_line(aes(color=is_target),linewidth=2)+
    facet_grid(.~pos_factor)+
    labs(title="Final test by initial test position")+
    ylim(c(0.5,1))+
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=18),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )+
    scale_color_manual(values=c("grey","red","blue","green"))

png(filename="plot2_enhanced.png", width=1600, height=1200, res=150)
grid.arrange(pf1, pf4, ncol = 1, nrow = 2)
dev.off()

cat("Enhanced plots saved to plot2_enhanced.png\n")