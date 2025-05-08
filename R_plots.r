library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
# getwd()
all_results=read.csv("all_results.csv")
DF=read.csv("DF.csv")
all_results$is_target
df1=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",size=1.5)+
    geom_point()+ylim(c(0.5,1))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )
p_in_20


df1=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",size=1.5)+
    geom_point()+ylim(c(0.5,1))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )


df2=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number,list_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,list_number)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,list_number)%>%
    mutate(meanx_m=mean(meanx))

p_in_20in10=ggplot(data=df2%>%filter(list_number==1),aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(list_number~.)

p_in_20in10

p_in_20in100=ggplot(data=df2,aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    # geom_point()+
    facet_grid(list_number~.)

p_in_20in100

df3=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(listbreak=case_when(list_number<=5~1,TRUE~2))%>%
    group_by(test_position,is_target,simulation_number,listbreak)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,listbreak)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,listbreak)%>%
    mutate(meanx_m=mean(meanx))
    
p_in_20in10_break2=ggplot(data=df3,aes(x=test_position,y=meanx,group=interaction(listbreak,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(listbreak~.)

    p_in_20in10_break2
    p_in_20in100


DF2 = DF %>% mutate(meanx = case_when(is_target=="true"~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    ylim(c(0.65,1))+
    scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )


DF2 = DF %>% mutate(meanx = case_when(is_target=="true"~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target),size=5)+
facet_grid(list_number~.)

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(Nratio_iprobe))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))
# Adding a manual legend

# mutate(meanx = case_when(is_target=="true"~ meanx, TRUE ~ 1-meanx))
p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx))+
geom_line(aes(x=list_number,y=meanx))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace in each list",y="N (number of activated trace)")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+
theme(
        plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
    plot.margin = margin(t = 10, b = 40),
    text=element_text(size=20) # Increase font size globally
)



DF3 = all_results %>% 
group_by(list_number, simulation_number, ilist_image)%>%
# summarize(meanx=mean(Nratio_iimageinlist))%>%
summarize(meanx=mean(N_imageinlist))%>%
group_by(list_number, ilist_image)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.factor(list_number))
# mutate(ilist_image=as.factor(ilist_image))
# mutate(test_position=as.factor(test_position))

p4=ggplot(data=DF3, aes(x=ilist_image,y=meanx, group=list_number))+
geom_point(aes(color=list_number))+
geom_line(aes(color=list_number))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01,size=10)+
labs(title="Ratio of activated trace for 10 lists in 10 color")+
# scale_x_continuous(name="list",breaks = rev(1:10),labels=as.character(rev(1:10)))
scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) +
theme(text = element_text(size = 30))  # Increase font size globally

df_serial=all_results%>%
    mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(study_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(study_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))

p_serial=ggplot(data=df_serial,aes(x=study_position,meanx))+
    geom_line(aes(color=is_target),size=2)+
    geom_point(size=2,aes(color=is_target))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+
    ylim(c(0.75,1))

df_rt=all_results%>%
    mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,test_position)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,test_position)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target))

testpos_rt=ggplot(data=df_rt,aes(x=test_position,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+ylim(c(0.75,1))


df_rt_list=all_results%>%
    mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,list_number)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,list_number)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target),list_number=as.factor(list_number))

list_rt=ggplot(data=df_rt_list,aes(x=list_number,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=1.5)+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )


# grid.arrange(p1,list_rt,p_in_20,testpos_rt,p_serial,p4,ncol = 2,nrow=3)
grid.arrange(p1,p_in_20,p_serial,p4,ncol = 2,nrow=2)
