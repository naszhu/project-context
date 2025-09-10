library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

all_results=read.csv("../../../all_results.csv")
DF=read.csv("../../../DF.csv")
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
    geom_line(aes(color=is_target),linewidth=2)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",linewidth=2.5)+
    geom_point(size=3)+ylim(c(0.5,1))+
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )+
    labs(title="Recognition Accuracy by Test Position", x="Test Position", y="Mean Accuracy")

df1=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target),linewidth=2)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",linewidth=2.5)+
    geom_point(size=3) +
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )+
    labs(title="Recognition Accuracy by Test Position", x="Test Position", y="Mean Accuracy")

df2=all_results%>%mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number,list_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,list_number)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,list_number)%>%
    mutate(meanx_m=mean(meanx))

p_in_20in10=ggplot(data=df2%>%filter(list_number==1),aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target),linewidth=1.5)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",linewidth=2)+
    geom_point(size=2)+
    facet_grid(list_number~.)+
    theme_minimal()+
    theme(text=element_text(size=16), panel.border = element_rect(colour="black", fill=NA, linewidth=0.5))

p_in_20in100=ggplot(data=df2,aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target),linewidth=1.2)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",linewidth=1.5)+
    facet_grid(list_number~.)+
    theme_minimal()+
    theme(text=element_text(size=12), panel.border = element_rect(colour="black", fill=NA, linewidth=0.3))+
    labs(title="Recognition by Test Position - All Lists", x="Test Position", y="Mean Accuracy")

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
    geom_line(aes(color=is_target),linewidth=2)+
    geom_line(aes(x=test_position,y=meanx_m),color="black",linewidth=2.5)+
    geom_point(size=3)+
    facet_grid(listbreak~.)+
    theme_minimal()+
    theme(text=element_text(size=16), panel.border = element_rect(colour="black", fill=NA, linewidth=0.5))+
    labs(title="Recognition by Test Position - List Groups", x="Test Position", y="Mean Accuracy")

DF2 = DF %>% mutate(meanx = case_when(is_target=="true"~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))

p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
    geom_point(aes(color=is_target), size=4)+
    geom_line(aes(color=is_target),linewidth=2.5)+
    ylim(c(0.825,0.95))+
    scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+
    labs(title="Accuracy by list number in inital test ", x="List Number", y="Mean Accuracy")+
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )

DF2 = DF %>% mutate(meanx = case_when(is_target=="true"~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))

p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target), size=2)+
geom_line(aes(color=is_target),linewidth=2)+
facet_grid(list_number~.)+
theme_minimal()+
theme(text=element_text(size=12), panel.border = element_rect(colour="black", fill=NA, linewidth=0.3))+
labs(title="Accuracy by Test Position - Each List", x="Test Position", y="Mean Accuracy")

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(Nratio_iprobe))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))

p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx), size=4, color="darkgreen")+
geom_line(aes(x=list_number,y=meanx), linewidth=2.5, color="darkgreen")+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01, size=5)+
labs(title="Ratio of activated trace in each list",y="N (number of activated trace)", x="List Number")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+
theme_minimal()+
theme(
        plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
    plot.margin = margin(t = 10, b = 40),
    text=element_text(size=20),
    panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
)

DF3 = all_results %>% 
group_by(list_number, simulation_number, ilist_image)%>%
summarize(meanx=mean(N_imageinlist))%>%
group_by(list_number, ilist_image)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.factor(list_number))

p4=ggplot(data=DF3, aes(x=ilist_image,y=meanx, group=list_number))+
geom_point(aes(color=list_number), size=3)+
geom_line(aes(color=list_number), linewidth=1.5)+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01,size=3)+
labs(title="Ratio of activated trace for 10 lists in 10 color")+
scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) +
theme_minimal() +
theme(text = element_text(size = 16), panel.border = element_rect(colour="black", fill=NA, linewidth=0.5))

df_serial=all_results%>%
    mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(study_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(study_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))

p_serial=ggplot(data=df_serial,aes(x=study_position,meanx))+
    geom_line(aes(color=is_target),linewidth=2.5)+
    geom_point(size=3,aes(color=is_target))+
    theme_minimal()+
    theme(
            plot.caption = element_text(hjust = 0, size = 16, face = "bold"),
        plot.margin = margin(t = 10, b = 40),
        text=element_text(size=20),
        panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
    )+
    ylim(c(0.75,1))+
    labs(title="Serial Position Effect", x="Study Position", y="Mean Accuracy")

if("is_sampled" %in% colnames(all_results) && "is_same_item" %in% colnames(all_results)) {
    sampling_data <- all_results %>%
        filter(is_sampled == "true", is_target == "true", decision_isold == 1) %>%
        mutate(is_same_item_num = case_when(is_same_item == "true" ~ 1, TRUE ~ 0)) %>%
        group_by(simulation_number, test_position, list_number) %>%
        summarize(prob_correct = mean(is_same_item_num)) %>%
        group_by(test_position, list_number) %>%
        summarize(prob_correct = mean(prob_correct)) %>%
        group_by(list_number) %>%
        summarize(prob_correct = mean(prob_correct))
    
    sampling_accuracy_plot <- ggplot(sampling_data, aes(x = list_number, y = prob_correct)) +
        geom_line(linewidth = 2.5, color="darkgreen") +
        geom_point(size=4, color="darkgreen") +
        labs(
            title = "Probability of Correct Sampling When Item is Sampled",
            x = "List Number",
            y = "Probability of Correct Sampling"
        ) +
        scale_x_continuous(breaks = 1:10) +
        scale_y_continuous(limits = c(0.75, 0.80), breaks = seq(0.75, 0.80, by = 0.01)) +
        theme_minimal() +
        theme(
            plot.title = element_text(face = "bold", size = 18),
            text = element_text(size = 16),
            panel.border = element_rect(colour="black", fill=NA, linewidth=0.5)
        )
    
    png(filename="plot1_enhanced.png", width=1600, height=1200, res=150)
    grid.arrange(p1, p_in_20, p_serial, sampling_accuracy_plot, ncol = 2, nrow = 2)
    dev.off()
} else {
    png(filename="plot1_enhanced.png", width=800, height=1800, res=150)
    grid.arrange(p1, p_in_20, p_serial, ncol = 1, nrow = 3)
    dev.off()
}

cat("Enhanced plots saved to plot1_enhanced.png\n")