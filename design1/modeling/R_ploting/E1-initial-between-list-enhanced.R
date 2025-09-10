library(dplyr)
library(ggplot2)
library(readr)

# Load the preprocessed data - using relative path
dfchanged <- read_csv("../../data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initialtestbyinitial - EXACT SAME LOGIC AS ORIGINAL
df_initialtestbyinitial = dfchanged%>%
  filter(task=="pretest_response")%>%
  select(trialnum,ip,correct,probetype)%>%
  group_by(trialnum,ip,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(trialnum,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(trialnum=as.factor(trialnum))%>%
  mutate(position=trialnum,position_type="ir")%>%
  mutate(condition="All conditions")%>%
  select(position,position_type,probetype,meancr,se,condition)%>%
  mutate(probetype=case_when(probetype=="FOIL"~"Foil - Correct rejection",
                             TRUE~paste(probetype," - Hits"))) %>% 
  mutate(condition=as.factor(condition))%>%
  mutate(condition=factor(condition,levels=levels(condition)[c(1,2,3)]))%>%
  group_by(trialnum)%>%
  mutate(meancr_avg=mean(meancr))

# Create enhanced plot data - SAME TRANSFORMATIONS AS ORIGINAL
plot_data <- df_initialtestbyinitial%>%
  mutate(position_type=case_when(position_type=="testpos"~"Final Result\nFinal Test Position",
                                 position_type=="ir"~"Initial Result\nInitial List Position",
                                 position_type=="prespos"~"Final Result\nInitial List Position"))%>%
  mutate(position_type=as.factor(position_type))%>%
  mutate(position_type=factor(position_type,levels=rev(levels(position_type))))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil  - Hits"~ "foil",
                             TRUE ~ "target"))%>%
  mutate(conditionnow=paste(condition," - ",position_type))

# Create enhanced between-list plot
enhanced_plot <- ggplot(data=plot_data, aes(position,meancr,group=interaction(position_type,conditionnow,probetype)))+
  # Enhanced points with different shapes
  geom_point(aes(color=probetype, shape=probetype), size=5, alpha=0.9, stroke=1.5) +
  # Enhanced lines with different line types  
  geom_line(aes(color=probetype, linetype=probetype), linewidth=2) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),alpha=0.25) +
  # Enhanced average line
  geom_line(data=plot_data, aes(x=position,y=meancr_avg),
            color="black", linewidth=2.5, linetype="dashed", alpha=0.9) +
  
  # Enhanced styling and labels
  labs(x="List Number in Initial Test",
       y="Performance (Hits/Correct Rejection)",
       title="E1 Initial Between-List Results",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced colors and shapes
  scale_color_manual(values=c("foil"="red", "target"="blue")) +
  scale_fill_manual(values=c("foil"="red", "target"="blue")) +
  scale_shape_manual(values=c("foil"=19, "target"=17)) +
  scale_linetype_manual(values=c("foil"="solid", "target"="longdash")) +
  
  # Enhanced theme
  theme_minimal() +
  theme(
    text=element_text(size=18),
    plot.title = element_text(face="bold", hjust=0.5, size=20),
    axis.text = element_text(size=16, color="black"),
    axis.title = element_text(size=18, face="bold"),
    legend.position = "bottom",
    legend.title = element_text(face="bold", size=16),
    legend.text = element_text(size=14),
    panel.border = element_rect(color="black", fill=NA, linewidth=0.8),
    panel.grid.major = element_line(color="grey75", linewidth=0.5),
    panel.grid.minor = element_line(color="grey85", linewidth=0.3)
  ) +
  guides(fill = "none")

# Save enhanced plot
png(filename="E1_initial_between_list_enhanced.png", width=1000, height=700, res=150)
print(enhanced_plot)
dev.off()

cat("Enhanced E1 Initial Between-List plot saved to E1_initial_between_list_enhanced.png\n")