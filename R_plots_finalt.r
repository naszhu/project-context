

library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
# getwd()
all_results=read.csv("all_results.csv")
DF=read.csv("DF.csv")
allresf=read.csv("allresf.csv")




    # head(allresf)
    DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(test_position=as.numeric(test_position))%>%
    mutate(test_position_group=ntile(test_position,10))%>%
    group_by(test_position_group,is_target,condition)%>%
    summarize(meanx=mean(correct))

    p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)


    
    DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(list_number=as.numeric(list_number))%>%
    group_by(list_number,is_target,condition)%>%
    summarize(meanx=mean(correct))



    p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p10, p101,p1,p3 ,p_in_20,p_in_20in10,ncol = 2,nrow=3)
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)

    
    df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%ungroup()%>%select(-list_number)%>%
    full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
    mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
    select(-c("meanx.x","meanx.y"))%>%
    pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")


    pf1=ggplot(data=df_allfinal, aes(test_position_group,val,group=interaction(position_kind,condition,is_target)))+
        geom_point(aes(color=is_target,group=is_target))+
        geom_line(aes(color=is_target,group=is_target),size=1.5)+
        facet_grid(condition~position_kind)+
        labs(x="Final test position cut in 10 chunks (left column), Initial test list order (right column)",
            y="prediction (Hits/Correct Rejection)",
            caption="Figure 3. Between List Final Test Results seen in Final Testing",
            color="Type",fill="Type")+
        scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40),
            text=element_text(size=30) # Increase font size globally
        )+
        ylim(c(0.5,1))

        DFff = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(initial_studypos = as.numeric(initial_studypos))%>%
    # mutate(test_position_group=ntile(test_position,10))%>%
    group_by(initial_studypos,is_target,condition)%>%
    summarize(meanx=mean(correct))

    pf3=ggplot(data=DFff, aes(x=initial_studypos,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=2)+
    theme(
            plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20) # Increase font size globally
    )+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))


    DFff2 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(initial_testpos = as.numeric(initial_testpos))%>%
    # mutate(test_position_group=ntile(test_position,10))%>%
    group_by(initial_testpos,is_target,condition)%>%
    summarize(meanx=mean(correct))

    pf4=ggplot(data=DFff2, aes(x=initial_testpos,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target),size=2)+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)
        # grid.arrange(p4,p1,p_serial,p_in_20,p10,p101,ncol = 2,nrow=3)

    # DF001

    DF_fbyi = allresf %>% 
        mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
        select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
        pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
        # mutate(list_number=as.numeric(list_number))%>%
        group_by(pos_factor,posSum,is_target,simulation_number)%>%
        summarize(meanx=mean(correct))%>%
        group_by(pos_factor,posSum,is_target)%>%
        summarize(meanx=mean(meanx))
        # filter(condition!="true_random")
    # DF_fbyi

    pf4= ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
        geom_point(aes(color=is_target))+
        geom_line(aes(color=is_target),size=2)+
        facet_grid(.~pos_factor)+
        labs(title="Final test by initial test position")+
        ylim(c(0.5,1))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40),
            text=element_text(size=30) # Increase font size globally
        )+
        scale_color_manual(values=c("grey","red","blue","green"))
    # pf3
    # # pf4
    # ensure_device(3)
    # dev.set(3)  # Target window for Plot 1

 
png(filename="plot2.png", width=1100, height=1200)
# grid.arrange(p1,list_rt,p_in_20,testpos_rt,p_serial,p4,ncol = 2,nrow=3)
    grid.arrange(pf1, pf4,ncol = 1,nrow=2)
dev.off()
       # if `feh` is installed
    #    system("feh plot2.png &", wait = FALSE)
# system2("feh", args = "plot2.png", wait = FALSE)
# system("feh --force-aliasing --no-jump-on-resort --start-at=plot2.png plot1.png &", wait = FALSE)
