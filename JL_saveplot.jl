
@rput DF
@rput all_results
R"""
library(ggplot2)
library(dplyr)
library(gridExtra)

DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
ylim(c(0.5,1))+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))


DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
facet_grid(list_number~.)

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(nactivated))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))

# mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))
p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx))+
geom_line(aes(x=list_number,y=meanx))+
geom_text(aes(label = round(meanx)),nudge_y = 10)+
labs(title="Number of activated trace in each list",y="N (number of activated trace)")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))
DF3

all_results$nactivated
# DF3 = all_results %>% 
# group_by(list_number, simulation_number, is_target, test_position)%>%
# summarize(meanx=mean(nactivated))%>%
# group_by(list_number, is_target, test_position)%>%
# summarize(meanx=mean(meanx))%>%
# mutate(list_number=as.integer(list_number))

# # mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))
# p4=ggplot(data=DF3, aes(x=test_position,y=meanx,group=is_target))+
# geom_point(aes(color=is_target))+
# geom_line(aes(color=is_target))+
# labs(title="Number of activated trace in each list",y="N (number of activated trace)")+
# scale_x_continuous(name="list number",breaks = 1:20,labels=as.character(1:20))+
# facet_grid(list_number~.)# ylim(c(50,100))

# grid.arrange(p1, p2,p3,p4, ncol = 2,nrow=2)
# as.character(1:10)
# summary(DF3$list_number)
# class(DF3$list_number)
# # all_results$nactivated%>%summary()
# # ylim(0.5,1)

# Define the function
# f <- function(x) {
#   return(x - (x-10)^2 + 2)
# }

# # Generate x values
# x_values <- seq(-10, 10, by = 0.1)

# # Generate y values
# y_values <- f(x_values)

# # Create a data frame
# data <- data.frame(x = x_values, y = y_values)

# # Plot
# ggplot(data, aes(x = x, y = y)) +
#   geom_line() +
#   labs(title = "Plot of f(x) = x + x^2 + 2")
"""

    # @by([:list_number, :is_target, :test_position, :condition, :simulation_number], :meanx = mean(:decision_isold))
    # @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))

if is_finaltest
    @rput allresf
    R"""
    library(ggplot
    library(dplyr)
    library(gridExtra)
    # DF2 = DFf %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ meanx))%>%
    # mutate(test_position=as.numeric(test_position))%>%
    # mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
    # group_by(test_position_in_chunks,is_target,condition)%>%
    # summarize(meanx = mean(meanx))

    DF22 = allresf %>% 
    mutate(test_position=as.numeric(test_position)) %>%
    mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
    group_by(test_position_in_chunks,is_target,condition,simulation_number)%>%
    mutate(meanx = mean(decision_isold))%>%
    group_by(test_position_in_chunks,is_target,condition)%>%
    mutate(meanx = case_when(is_target!="F"~ meanx, TRUE ~ 1-meanx))%>%
    summarize(meanx = mean(meanx))
    # head(DF2)
    p1=ggplot(data=DF22, aes(x=test_position_in_chunks,y=meanx,group=is_target))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    facet_grid(condition~.)+
    scale_x_discrete(guide = guide_axis(angle = 45))+
    labs(x="final test position in chunks",y="prob correct", title="accuracy prediction")+
    # ylim(c(0.9,1))
    ylim(c(0,1))


    DF22rt = allresf %>% 
    mutate(test_position=as.numeric(test_position)) %>%
    mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
    group_by(test_position_in_chunks,is_target,condition,simulation_number)%>%
    mutate(meanx = mean(rt))%>%
    group_by(test_position_in_chunks,is_target,condition)%>%
    # mutate(meanx = case_when(is_target!="F"~ meanx, TRUE ~ 1-meanx))%>%
    summarize(meanx = mean(meanx))
    # head(DF2)
    p2=ggplot(data=DF22rt, aes(x=test_position_in_chunks,y=meanx,group=is_target))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    facet_grid(condition~.)+
    scale_x_discrete(guide = guide_axis(angle = 45))+
    labs(x="final test position in chunks",y="mean RT", title="mean RT prediction")

    grid.arrange(p1, p2, ncol = 2)

    # DF22 = allresf %>% 
    # mutate(test_position=as.numeric(test_position))%>%
    # mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
    # group_by(test_position_in_chunks,is_target,condition,simulation_number)%>%
    # mutate(meanx = mean(decision_isold))%>%
    # group_by(test_position_in_chunks,condition)%>%
    # mutate(meanx = case_when(is_target!="F"~ meanx, TRUE ~ 1-meanx))%>%
    # summarize(meanx = mean(meanx))
    # # head(DF2)
    # ggplot(data=DF22, aes(x=test_position_in_chunks,y=meanx,group=condition))+
    # geom_point(aes(color=condition))+
    # geom_line(aes(color=condition))+
    # # facet_grid(condition~.)+
    # ylim(0.76,0.9)+
    # scale_x_discrete(guide = guide_axis(angle = 45))

    # ylim(0.5,1)

    """
end