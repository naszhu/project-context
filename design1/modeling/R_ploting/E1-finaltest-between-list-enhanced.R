library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data - using relative path
dfchanged <- read_csv("../../data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for final test between-list analysis - EXACT SAME LOGIC AS ORIGINAL
dfserial=
  dfchanged%>%
  filter(task=="finalt_response")%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,correct,condition,probetype)%>%
  group_by(position,ip,position_type,condition,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,condition,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits")))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Test List Position",
                                 TRUE~"Initial Study List Position"))

dfserial_meandf=dfchanged%>%
  filter(task=="finalt_response")%>%
  mutate(testpos=cut_number(testpos,10,labels=1:10))%>%
  mutate(testpos=as.factor(testpos),prespos=as.factor(prespos_itrial))%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position_type,position,ip,correct,condition,probetype)%>%
  group_by(position_type,position,ip,condition)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position_type,position,condition)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype="Average")%>%
  select(position,position_type,condition,probetype,meancr,se)%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Test List Position",
                                 TRUE~"Initial Study List Position"))

dfserial_all=rbind(dfserial,dfserial_meandf)%>%
  mutate(position_type=as.factor(position_type))%>%
  mutate(position_type=factor(position_type,levels=rev(levels(position_type))))

# Create enhanced final test between-list plot
enhanced_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=interaction(position_type,condition,probetype)))+
  # Enhanced points with different shapes
  geom_point(aes(color=probetype, shape=probetype), size=3, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype), linewidth=1.2) +
  # Enhanced ribbon (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),alpha=0.25) +
  # Facet by condition and position type
  facet_grid(condition~position_type) +
  
  # Enhanced styling and labels
  labs(x="Final Test Position (left), Initial Study List Position (right)",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Final Test Between-List Results",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced colors and shapes
  scale_color_manual(values=c("Average"="black", 
                              "Foil - Correct rejection"="red",
                              "TARGET_foil  - Hits"="orange",
                              "TARGET_nontarget  - Hits"="green",
                              "TARGET_target  - Hits"="blue")) +
  scale_fill_manual(values=c("Average"="black", 
                             "Foil - Correct rejection"="red",
                             "TARGET_foil  - Hits"="orange",
                             "TARGET_nontarget  - Hits"="green",
                             "TARGET_target  - Hits"="blue")) +
  scale_shape_manual(values=c("Average"=15, 
                              "Foil - Correct rejection"=19,
                              "TARGET_foil  - Hits"=18,
                              "TARGET_nontarget  - Hits"=17,
                              "TARGET_target  - Hits"=16)) +
  scale_linetype_manual(values=c("Average"="dashed", 
                                 "Foil - Correct rejection"="solid",
                                 "TARGET_foil  - Hits"="dotted",
                                 "TARGET_nontarget  - Hits"="longdash",
                                 "TARGET_target  - Hits"="twodash")) +
  
  # Enhanced theme
  theme_minimal() +
  theme(
    text=element_text(size=12),
    plot.title = element_text(face="bold", hjust=0.5, size=16),
    axis.text = element_text(size=10, color="black"),
    axis.title = element_text(size=12, face="bold"),
    legend.position = "bottom",
    legend.title = element_text(face="bold", size=10),
    legend.text = element_text(size=8),
    legend.key.width = unit(1.0, "cm"),
    legend.key.height = unit(0.4, "cm"),
    panel.border = element_rect(color="black", fill=NA, linewidth=0.5),
    strip.background = element_rect(fill="grey90", color="black"),
    strip.text = element_text(face="bold", size=10)
  ) +
  guides(fill = "none",
         color = guide_legend(nrow = 2, byrow = TRUE),
         shape = guide_legend(nrow = 2, byrow = TRUE),
         linetype = guide_legend(nrow = 2, byrow = TRUE))

# Save enhanced plot
png(filename="E1_finaltest_between_list_enhanced.png", width=1200, height=1000, res=150)
print(enhanced_plot)
dev.off()

cat("Enhanced E1 Final Test Between-List plot saved to E1_finaltest_between_list_enhanced.png\n")