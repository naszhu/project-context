library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)

# Load the preprocessed data - using relative path
dfchanged <- read_csv("../../data_analysis/dfchanged.csv")
cat("Loaded dfchanged data from dfchanged.csv\n")

# Create df_initial data - EXACT SAME LOGIC AS ORIGINAL
df_initial=dfchanged%>%
  filter(task=="pretest_response")%>%
  pivot_longer(cols=c(testpos,prespos),names_to="position_type",values_to="position")%>%
  select(position,ip,position_type,stimulus_id)

wordlists_intest = dfchanged%>%
  filter(task=="pretest_response")%>%group_by(ip)%>%summarize(words=list(stimulus_id))

df_initial_study =
  dfchanged%>%filter(task=="pretest_study")%>%
  left_join(wordlists_intest,by="ip")%>%
  rowwise()%>%
  filter(!(stimulus_id%in%unlist(words)))%>%
  mutate(position=prespos,position_type="prespos")%>%
  select(position,position_type,ip,stimulus_id)
  
df_initial_all=rbind(df_initial,df_initial_study)  

df_final = dfchanged%>%
  filter(task=="finalt_response")%>%
  filter(probetype!="FOIL") %>%
  filter(response!="null")%>%
  select(ip,correct,probetype,stimulus_id)

# Combine initial test positions with final test correct - SAME LOGIC AS ORIGINAL
df_finalwithin=
  df_final%>%left_join(df_initial_all,by=c("ip","stimulus_id"))%>%
  filter(!is.na(correct))%>%
  group_by(position,ip,position_type,probetype)%>%
  summarize(meancr1=mean(correct))%>%
  group_by(position,position_type,probetype)%>%
  summarize(meancr=mean(meancr1),sd=sd(meancr1),se=sd/sqrt(n()))%>%
  mutate(probetype=case_when(probetype=="TARGET_foil"~"Foil - Neither studied nor tested",
                             probetype=="TARGET_target"~"Target - Studied and tested",
                             probetype=="TARGET_nontarget"~"Target - Studied only"))%>%
  mutate(position_type=case_when(position_type=="testpos"~"Initial Test Position",
                                 position_type=="prespos"~"Initial Study Position"))

# Create enhanced final test within-list plot combining study and test positions side by side
enhanced_plot <- ggplot(data=df_finalwithin, aes(position,meancr,group=interaction(position_type,probetype)))+
  # Enhanced points with different shapes
  geom_point(aes(color=probetype, shape=probetype), size=4, alpha=0.9, stroke=1.2) +
  # Enhanced lines with different line types
  geom_line(aes(color=probetype, linetype=probetype), linewidth=1.8) +
  # Enhanced ribbon with better visibility
  geom_ribbon(aes(ymin=meancr-se,ymax=meancr+se,fill=probetype),alpha=0.25) +
  # Facet by position type (side by side)
  facet_grid(.~position_type) +
  
  # Enhanced styling and labels
  labs(x="Initial Study Position (left), Initial Test Position (right)",
       y="Hit Rate",
       title="E1 Final Test Within-List Results",
       color="Type", fill="Type", shape="Type", linetype="Type") +
  
  # Enhanced colors and shapes
  scale_color_manual(values=c("Foil - Neither studied nor tested"="red", 
                              "Target - Studied and tested"="blue",
                              "Target - Studied only"="green")) +
  scale_fill_manual(values=c("Foil - Neither studied nor tested"="red", 
                             "Target - Studied and tested"="blue",
                             "Target - Studied only"="green")) +
  scale_shape_manual(values=c("Foil - Neither studied nor tested"=19, 
                              "Target - Studied and tested"=17,
                              "Target - Studied only"=15)) +
  scale_linetype_manual(values=c("Foil - Neither studied nor tested"="solid", 
                                 "Target - Studied and tested"="longdash",
                                 "Target - Studied only"="dotted")) +
  
  # Enhanced theme
  theme_minimal() +
  theme(
    text=element_text(size=14),
    plot.title = element_text(face="bold", hjust=0.5, size=18),
    axis.text = element_text(size=12, color="black"),
    axis.title = element_text(size=14, face="bold"),
    legend.position = "bottom",
    legend.title = element_text(face="bold", size=12),
    legend.text = element_text(size=10),
    legend.key.width = unit(2, "cm"),
    panel.border = element_rect(colour="black", fill=NA, linewidth=0.6),
    strip.text = element_text(face="bold", size=14),
    strip.background = element_rect(fill="grey90", color="black")
  ) +
  guides(fill = "none", 
         color = guide_legend(nrow = 3, byrow = TRUE),
         shape = guide_legend(nrow = 3, byrow = TRUE),
         linetype = guide_legend(nrow = 3, byrow = TRUE))

# Save enhanced plot
png(filename="E1_finaltest_within_list_enhanced.png", width=1200, height=700, res=150)
print(enhanced_plot)
dev.off()

cat("Enhanced E1 Final Test Within-List plot saved to E1_finaltest_within_list_enhanced.png\n")