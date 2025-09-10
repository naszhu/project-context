


library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
# getwd()
all_results=read.csv("../../../all_results.csv")
DF=read.csv("../../../DF.csv")
allresf=read.csv("../../../allresf.csv")


 DF_fbyi = allresf %>% 
        mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
        select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
        pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
        # Filter out F targets to remove foil points
        filter(is_target != "F") %>%
        # mutate(list_number=as.numeric(list_number))%>%
        group_by(pos_factor,posSum,is_target,simulation_number)%>%
        summarize(meanx=mean(correct))%>%
        group_by(pos_factor,posSum,is_target)%>%
        summarize(meanx=mean(meanx)) %>%
        # Create proper labels for legend
        mutate(target_type = case_when(
          is_target == "T_target" ~ "Target, Studied and tested - HITS",
          is_target == "T_nontarget" ~ "Target, Studied only - HITS",
          is_target == "T_foil" ~ "Foil, neither studied nor tested - Correct rejection",
          TRUE ~ is_target
        ))

 pf4= ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
        geom_point(aes(color=target_type, shape=target_type), size=5)+
        geom_line(aes(color=target_type), size=2.5)+
        facet_grid(.~pos_factor, 
                   labeller = labeller(pos_factor = c("initial_studypos" = "Initial Study position (left column)",
                                                    "initial_testpos" = "Initial Test position (right column)")))+
        labs(title="E1 Final Test Within List DATA",
             x="Position",
             y="Hit Rate",
             color="Type",
             shape="Type")+
        ylim(c(0.5,1))+
        theme_minimal() +
        theme(
          plot.title = element_text(face = "bold", hjust = 0.5, size = 18, margin = margin(b = 20)),
          plot.caption = element_text(hjust = 0, size = 16, face = "bold", color = "darkblue", margin = margin(t = 20)),
          plot.margin = margin(t = 15, r = 15, b = 60, l = 15),
          text = element_text(size = 16),
          axis.text = element_text(size = 14, color = "black"),
          axis.title = element_text(size = 16, face = "bold", color = "black"),
          panel.grid.major = element_line(color = "grey75", linewidth = 0.4),
          panel.grid.minor = element_line(color = "grey85", linewidth = 0.2),
          legend.position = "bottom",
          legend.title = element_text(face = "bold", size = 18),
          legend.text = element_text(size = 16),
          legend.key.width = unit(2.2, "cm"),
          legend.key.height = unit(0.8, "cm"),
          legend.margin = margin(t = 25),
          legend.box = "horizontal",
          legend.direction = "horizontal",
          legend.box.just = "center",
          panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6),
          plot.background = element_rect(fill = "white", color = NA),
          panel.background = element_rect(fill = "grey98", color = NA),
          strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.5),
          strip.text = element_text(face = "bold", size = 14)
        )+
        scale_color_manual(values=c("Target, Studied and tested - HITS"="#1A9850",
                                   "Target, Studied only - HITS"="#2166AC",
                                   "Foil, neither studied nor tested - Correct rejection"="#D73027"))+
        scale_shape_manual(values=c("Target, Studied and tested - HITS"=17,
                                   "Target, Studied only - HITS"=15,
                                   "Foil, neither studied nor tested - Correct rejection"=19))+
        guides(
          color = guide_legend(nrow = 3, byrow = TRUE, title.position = "top"),
          shape = guide_legend(nrow = 3, byrow = TRUE, title.position = "top")
        )


png(filename="E1_final_within_list_prediction_plot.png", width=800, height=1200)
print(pf4)
dev.off()
