library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data - using relative path to find dfchanged.csv
dfchanged <- read_csv("../../data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create dfserial data for within-list analysis - EXACT SAME LOGIC AS ORIGINAL
dfserial=dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(response!="null")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,correct,probetype)%>%
  group_by(position,ip,position_type,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil"~"Foil - Correct rejection",
                             probetype=="TARGET_target"~"Target - Hits"))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Initial Test Position",
                                 TRUE~"Initial Study Position"))

dfserial_meandf=dfchanged%>%
  filter(task=="pretest_response")%>%
  filter(response!="null")%>%
  select(testpos,ip,correct,probetype)%>%
  group_by(testpos,ip)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(testpos)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(position_type="Initial Test Position",position=testpos,probetype="Average")%>%
  select(position,position_type,probetype,meancr,se)

dfserial_all=rbind(dfserial,dfserial_meandf)

# Create enhanced within-list plot combining study and test positions side by side
enhanced_plot <- ggplot(data=dfserial_all, aes(position,meancr,group=interaction(position_type,probetype)))+
  # Enhanced points with different shapes
  geom_point(aes(color=probetype, shape=probetype), size=4, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype), linewidth=1.8) +
  # Enhanced ribbon (exclude Average from error bands)
  geom_ribbon(data=dfserial_all %>% filter(probetype != "Average"),
              aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),alpha=0.25) +
  # Facet by position type (side by side)
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Initial Study Position (left), Initial Test Position (right)",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Initial Within-List Results",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced colors and shapes
  scale_color_manual(values=c("Average"="black", "Foil - Correct rejection"="red", "Target - Hits"="blue")) +
  scale_fill_manual(values=c("Average"="black", "Foil - Correct rejection"="red", "Target - Hits"="blue")) +
  scale_shape_manual(values=c("Average"=15, "Foil - Correct rejection"=19, "Target - Hits"=17)) +
  scale_linetype_manual(values=c("Average"="dashed", "Foil - Correct rejection"="solid", "Target - Hits"="longdash")) +
  
  # Enhanced theme
  theme_minimal() +
  theme(
    text=element_text(size=16),
    plot.title = element_text(face="bold", hjust=0.5, size=18),
    axis.text = element_text(size=14, color="black"),
    axis.title = element_text(size=16, face="bold"),
    legend.position = "bottom",
    legend.title = element_text(face="bold", size=14),
    legend.text = element_text(size=12),
    panel.border = element_rect(colour="black", fill=NA, linewidth=0.6),
    strip.text = element_text(face="bold", size=14),
    strip.background = element_rect(fill="grey90", color="black")
  ) +
  guides(fill = "none")

# Save enhanced plot
png(filename="E1_initial_within_list_enhanced.png", width=1200, height=600, res=150)
print(enhanced_plot)
dev.off()

cat("Enhanced E1 Initial Within-List plot saved to E1_initial_within_list_enhanced.png\n")