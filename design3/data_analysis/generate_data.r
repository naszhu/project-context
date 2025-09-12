library(grDevices)
options(bitmapType='cairo')

library(here)
here::i_am("design3/data_analysis/generate_data.r")
print(here())
library(ggplot2) 
library(forcats) # for fct_relevel
# library()
library(dplyr)
# library(gridExtrau
library(tidyr)


# Use here() package for consistent path handling regardless of working directory
df_pl1 = read.csv(here("design3","data", "IMUSE-V1.3andHigher,n48.csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))%>%mutate(codeversion=1.3)
# df_pl2$codeversion
df_pl2 = read.csv(here("design3","data", "IMUSE-V1toV2,n30.csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))

df_pl3 = read.csv(here("design3","data", "IMUSE-v1.4n20.csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))

df_pltest2 = read.csv(here("design3","data", "IMUSE-V5_second 12.csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))

df_pltest3 = read.csv(here("design3","data", "IMUSE-V5_first35.csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))
df_pltest4 = read.csv(here("design3","data", "IMUSE-V5_third .csv"))%>%mutate(correct=case_when(correct=="true"~1,correct=="false"~0,TRUE~ NA))%>%
  mutate(listNum_appear0_initial = as.numeric(listNum_appear0_initial))
df_pltest=rbind(df_pltest2,df_pltest3 )
df_pl=rbind(df_pl1,df_pl2,df_pl3,df_pltest2,df_pltest3,df_pltest4)
# df_pl=rbind(df_pltest2,df_pltest3,df_pltest4)

# ============================================================
## Add firestone data

# library(jsonlite)
file_name <- "test1.overall_export_metadata"
full_file_path <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Prj_tmp/data/participants_finished_final_trials_finished.csv"

dreal = read.csv(full_file_path) #%>%filter(subject_id%in%c("67dc712c511053c8d90e2c29","67eac4d6bf3d1c4df7bd65df","67ed4e79983b8a8ba5517548") )
common_cols <- intersect(names(df_pl), names(dreal))

print(paste("Common columns:", paste(common_cols, collapse=", ")))

target_classes <- lapply(df_pl[common_cols], function(col) class(col)[1])


f2_aligned <- dreal %>%
  mutate(across(all_of(common_cols), ~ {

    col_name <- cur_column()
    target_class <- target_classes[[col_name]]
    current_col_data <- .x
    switch(target_class,
           "character" = as.character(current_col_data),
           "numeric"   = as.numeric(current_col_data),
           "integer"   = as.integer(current_col_data),
           "logical"   = as.logical(current_col_data),
           "factor"    = factor(current_col_data), #
           current_col_data
           )
  }))
f2_aligned%>%group_by(subject_id)%>%
  summarize(n=n())

# df_pl_combine = bind_rows(df_pl, dreal)


df_pl_combine%>%filter(subject_id=="thisis_cool")%>%arrange(trial_index) 
df_pl_combine%>%group_by(subject_id)%>%
  summarize(n=n(),
    ac=mean(all_accumulated_accuracy),
            isf=mean(is_finished))

df_pl_combine%>%filter(subject_id%in%c("67dc712c511053c8d90e2c29","67eac4d6bf3d1c4df7bd65df","67ed4e79983b8a8ba5517548"))

dreal%>%group_by(subject_id)%>%
  summarize(n=n())
  


# ============================================================
## Add firestone data


file_name <- "test1.overall_export_metadata"
full_file_path <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Prj_tmp/data/participants_finished_final_trials_finished.csv"
full_file_path_er <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Prj_tmp/data/participants_trials_backup_ealier.csv"
full_file_path_backup <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Prj_tmp/data/participants_trials_backup_backup.csv"

# dreal_earlier = read.csv(full_file_path_er)%>% 
# the following are the 4 people who finished  the experiment in data file dreal_er, and they used the firebase version of only backup trials (i.e., not finished triales), they did not have the all_accumulated_accuracy attached as whole column, so need to assign manually
##############3 participants_trials_backup_ealier.csv
passlist = c("673ccb0691efe91cd015dcf7","67dc712c511053c8d90e2c29","67eac4d6bf3d1c4df7bd65df","67ed4e79983b8a8ba5517548") 
acc_accuray=c(0.5631313,0.5643939,0.6742424,0.8674242)
dreal_er = read.csv(full_file_path_er)%>% 
  mutate(is_finished=case_when(subject_id%in%passlist ~ 1,
                               TRUE ~ is_finished))%>%
  mutate(all_accumulated_accuracy=case_when(subject_id=="673ccb0691efe91cd015dcf7" ~ acc_accuray[1],
                                            subject_id=="67dc712c511053c8d90e2c29" ~ acc_accuray[2],
                                            subject_id=="67eac4d6bf3d1c4df7bd65df" ~ acc_accuray[3],
                                            subject_id=="67ed4e79983b8a8ba5517548" ~ acc_accuray[4],
                                            TRUE ~ all_accumulated_accuracy))%>%
  filter(is_finished==1)

dreal_er%>%group_by(subject_id)%>%
  summarize(n=n(),isf=mean(is_finished),acc=mean(all_accumulated_accuracy))
# dreal_er%>%filter(!is.na(all_accumulated_accuracy))%>%select(subject_id,all_accumulated_accuracy)

################# participants_trials_backup_backup.csv
# passlist2=c("5f9389fafdbecb173b329cca", "5fb39a485655aa025926ad30", "6307f3c967020d1202332b77", 
#   "63268ad93b6ecc1acf782a21", "63c1d184883ce15537788b40", "65c118f1cd19001157ace3a0", 
#   "66cfb3d040139a5cfd914312", "66e8661e0c5e57cda7bf2d39", "673a27fe372ce97a95aecf5c", 
#   "6741ce8667002c96f0362d34", "6751acc5dc78128951a34f1f", "67558204d75dd7351fe9d17e", 
#   "678c0d73fea9aaf55cd880be", "67c1a72590fcbf99458bb1f2", "67dc0e92b55a4d630f52e765", 
#   "67e069199f5b036960b0cc5f", "67e2fdf2d328f1e3dd7045b6", "67e8446d006a6c155f71bd2d", 
#   "67e9875c5b9b26c19a3bdf88", "67eaf90db55644f3c56fffa9", "67eb2ab3bd8cba1852857e2d", 
#   "67edb211a7c1d23c1535d6b2", "67eefac7eaf3702ddd603092", "67f05ce092cdcc0392692398", 
#   "67fff6438bb63725ca004b27")

mm=read.csv(full_file_path_backup)%>%filter(is_finished==1)%>%
  group_by(subject_id)%>%
  summarize(n=n(),isf=mean(is_finished),acc=mean(all_accumulated_accuracy))
passlist2=mm$subject_id
mm_allacc=read.csv(full_file_path_backup)%>%filter(!is.na(all_accumulated_accuracy))%>%
  select(subject_id,all_accumulated_accuracy)

dreal_backup = read.csv(full_file_path_backup)%>% #%>%filter(is_finished==1)%>%
  mutate(is_finished=case_when(subject_id%in%passlist2 ~ 1,
                               TRUE ~ is_finished))%>%
  filter(is_finished==1)%>%arrange(subject_id)%>%
  select(-all_accumulated_accuracy)%>%
  left_join(mm_allacc,by="subject_id")

dreal_backup%>%group_by(subject_id)%>%
  summarize(n=n(),isf=mean(is_finished),acc=mean(all_accumulated_accuracy))

dreal_backup 
dreal0 = read.csv(full_file_path)


dreal = full_join(dreal0,dreal_er)


# keep a copy of the original
dreal_orig <- dreal

# align classes, but only map "true"/"false" strings when target is logical
f2_aligned <- dreal %>%
  mutate(across(all_of(common_cols), ~{
    col <- cur_column()
    tgt <- target_classes[[col]]
    x   <- .

    # if original is character, detect "true"/"false"
    if (is.character(x)) {
      xl <- tolower(x)
      bool_idx <- xl %in% c("true","false","t","f")
      if (any(bool_idx)) {
        if (tgt %in% c("numeric","integer")) {
          # map to "1"/"0" for numeric/integer
          x[bool_idx] <- ifelse(xl[bool_idx] %in% c("true","t"), "1", "0")
        } else if (tgt == "logical") {
          # map to logical TRUE/FALSE
          x[bool_idx] <- xl[bool_idx]
        } else if (tgt == "character") {
          # just lowercase for character
          x[bool_idx] <- xl[bool_idx]
        }
      }
    }

    # convert to target class
    switch(tgt,
      character = as.character(x),
      numeric   = as.numeric(x),
      integer   = as.integer(x),
      logical   = as.logical(x),
      factor    = factor(x),
      x
    )
  }))

# 2) which cols changed class?
orig_cls <- sapply(dreal_orig[common_cols], class)
new_cls  <- sapply(f2_aligned[common_cols], class)
changed  <- common_cols[orig_cls != new_cls]
cat("Columns with changed classes:\n")
print(data.frame(column = changed, before = orig_cls[changed], after = new_cls[changed]))

# 3) sample before/after values
for (col in changed) {
  cat("\n---", col, "---\n")
  print(tibble(
    row    = 1:5,
    before = dreal_orig[[col]][1:5],
    after  = f2_aligned[[col]][1:5]
  ))
}

# 4) print levels of all factor‐able cols in df_pl, dreal_orig, and f2_aligned
factor_cols <- intersect(common_cols, names(target_classes)[target_classes == "factor"])
for (col in factor_cols) {
  cat("\n=== Levels for column:", col, "===\n")
  cat("df_pl:\n");      print(levels(as.factor(df_pl[[col]])))
  cat("dreal_orig:\n"); print(levels(as.factor(dreal_orig[[col]])))
  cat("f2_aligned:\n"); print(levels(as.factor(f2_aligned[[col]])))
}

# 5) summary as before
f2_aligned %>%
  group_by(subject_id) %>%
  summarise(n = n())


combined_df = full_join(df_pl,f2_aligned)

f2_aligned %>% 
  filter(is_finished==1)%>%
  group_by(subject_id)%>%
  summarize(n=n(), all_accumulated_accuracy= mean(all_accumulated_accuracy))

read.csv(full_file_path)%>%filter(subject_id=="680ebf035ab59d342f31726e")
 
# [1] "680ebf035ab59d342f31726e" "67dc712c511053c8d90e2c29"
# [3] "67ed4e79983b8a8ba5517548" "67eac4d6bf3d1c4df7bd65df"
# dreal = full_join(dreal0,dreal_er)%>%full_join(dreal_backup)
# dreal_er%>%
combined_df%>%
  select(subject_id,is_finished)%>%
  filter(subject_id=="67eac4d6bf3d1c4df7bd65df")

combined_df%>%
  filter(is_finished==1)%>%
  group_by(subject_id)%>%
  summarize(n=n())
  # filter(subject_id=="67dc0e92b55a4d630f52e765")


# data clean

levels(as.factor(df_pl$task ))

df_rt_pl =
  combined_df %>% filter(task%in% c("initialTest_response","finalTest")) %>% 
  filter(is_finished==1)%>%
  mutate(rt=as.numeric(rt))%>%
  filter(subject_id!="67ecdf3dcb59c5e0f274ad2d")%>%
  filter(! subject_id%in%c("6751acc5dc78128951a34f1f","67f909f80373c9f5af736a5a"))%>% #accuracy too low
    filter(subject_id!="")%>%
  filter(!is.na(rt),rt<3000)%>%
  # filter(id!=)%>%
    # select(id_picName,codeversion,task,subject_id,  rt, condition, stimulusConditions, stimulusConditionName_nPlusOneTrial, listNum_appear0_initial,correct,type_comment,listNum_infinalOrder,listNum_appear1_initial,listNum_appear2_initial, anRepeatedItem, testPos_final,testPos_appear0_initial,testPos_appear1_initial,testPos_appear2_initial,studyPos_appear0_initial,studyPos_appear1_initial,studyPos_appear2_initial ,is_finished,all_accumulated_accuracy, type_code_studiedCurr,type_code_testiedCurr,type_code_testiedNext,is_currentObjAppear1,current_assignmentTypesWithinList,listNum_infinalOrder, stimulusConditions, correct_appear2,correct_appear1)%>%
    mutate(type_comment_fn=case_when(
                                stimulusConditions=="B"~
                                  "Target: : started and tested at (n) ; Appear once",
                                stimulusConditions == "Cn"~
                                  "Studied-only (n); Foil (n+1)",
                                stimulusConditions =="Dn" ~ 
                                  "Target: studied and tested at (n), Foil (n+1)",
                                stimulusConditions=="A"~
                                  "Studied-only (n); Appear once",
                                stimulusConditions=="Fnn"~
                                  "Foil(n), Foil (n+1)",
                                stimulusConditions=="Fn"~
                                  "Foil(n); Appear once",
                                stimulusConditions=="FF" ~
                                  "Final Foil"))%>%
      mutate(typecomment_in = case_when(current_assignmentTypesWithinList =="T_target" & is_currentObjAppear1=="true" ~"Target",
                                is_currentObjAppear1=="false" & type_comment=="current target, in next trial, from last trial"  ~ "Inherented Foil - Last Target",
                                                                is_currentObjAppear1=="false" & type_comment=="studied only, in next trial, from last trial"  ~ "Inherented Foil - Last Studied Only",
                                                                is_currentObjAppear1=="false" & type_comment=="tested only, in next trial, from last trial"  ~ "Inherented Foil - Last Foil",
                                
                                  current_assignmentTypesWithinList =="T_foil"  ~"New Foil"))
  # mutate(type_comment=case_when(type_comment=="current target, in next trial" ~ "Target: studied and tested at (n), Foil (n+1)",
  #                               type_comment=="current target, not in next trial"~
  #                                 "Target: : started and tested at (n) ; Appear once",
  #                               type_comment == "studied only, in next trial"~
  #                                 "Studied-only (n); Foil (n+1)",
  #                               type_comment=="studied only, not in trial"~
  #                                 "Studied-only (n); Appear once",
  #                               type_comment=="tested only, in next trial"~
  #                                 "Foil(n), Foil (n+1)",
  #                               type_comment=="tested only, not in next trial"~
  #                                 "Foil(n); Appear once",
  #                               type_comment=="final Foil" ~ "Final Foil"))



# df_rt_pl_final =
  # df_pl %>% filter(task%in% c("finalTest")) %>% 
    # select(subject_id,  rt, condition, stimulusConditions, stimulusConditionName_nPlusOneTrial, listNum_appear0_initial,correct)

now=df_pl%>%filter(task=="detailSeenImages")
now$response

# ss=df_pl%>%filter(task=="surveyatend",subject_id=="6100434d983910e711b3a504")
# ss$response

df_pl%>%filter(subject_id=="67f909f80373c9f5af736a5a")

# show all accumulated accuracy
df_pl %>% group_by(subject_id)%>%filter(is_finished==1)%>%
  summarise(accmean=mean(all_accumulated_accuracy))

# show endsurvey Question answer
df_pl%>%filter(task=="surveyatend")%>%select(subject_id,response,accumulated_accuracy)

#present if they have seen images before
df_pl%>%filter(task%in%c("survey_HaveSeenImages","detailSeenImages"))%>%select(subject_id,HaveSeenImages,response,accumulated_accuracy)

#show if they once exited from full screen
df_pl %>% 
  filter(is_finished==1,subject_id!="",trial_index>=5,trial_index<1100)%>%
  group_by(subject_id)%>%
  summarize(wd = mean(width), ht=mean(height),is_changedfullscreen=mean(is_changedfullscreen))

df_pl%>%filter(subject_id=="6732ca9052a3b5780ec6068a")%>%select(width,height,trial_index)

#trial 1261 somehow detect different window size
df_pl%>%filter(subject_id=="6732ca9052a3b5780ec6068a")%>%select(width,height,trial_index, task,stimulus)%>%
  filter(height!=1080)
names(df_pl)

#see how many trials have rt>3500 in inital test
# 0.009826912 rate of NA response
#0.009826912 for that pass rt of 3500s
# 0.004913456 for that pass rt 3000

dhowmany = df_rt_pl%>%filter(task=="initialTest_response")%>%
  filter(!is.na(rt),rt>3000)
  # filter(is.na(rt))
dhowmany
dhowmany_base = df_rt_pl%>%filter(task=="initialTest_response")
dhowmany_base

length(dhowmany$task)/length(dhowmany_base$task)

df_pl%>%filter(subject_id=="67dc0e92b55a4d630f52e765")

d1ta = df_rt_pl%>%
  # filter(listNum_appear0_initial!=1 )%>%
# d1ta = df_pl2%>% 
  # filter(!is.na(rt),rt<3000)%>%
  mutate(colorskeme = case_when(current_assignmentTypesWithinList =="T_target" & is_currentObjAppear1=="true" ~"Target studied from current list",
                                is_currentObjAppear1=="false"  ~ paste("Foil from last trial",type_comment),
                                  current_assignmentTypesWithinList =="T_foil"  ~"Foil current list"))%>%
  filter(task=="initialTest_response")%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme,subject_id)%>%
         summarise(cr = mean(correct))%>%
         group_by(task, condition, listNum_appear0_initial,colorskeme)%>%
         summarise(cr = mean(cr))%>%
  mutate(listNum_appear0_initial=as.factor(listNum_appear0_initial))
  # mutate(type_comment=as.factor(type_comment))
  
  
ggplot(data=d1ta)+
  geom_line(aes(x=listNum_appear0_initial, y= cr ,group=interaction(task,colorskeme),color= colorskeme,linetype=colorskeme))+ 
  geom_point(aes(x=listNum_appear0_initial,y=cr,group=interaction(task,colorskeme),color=colorskeme,shape=colorskeme),size =4 )+
  facet_grid(.~task)+
  scale_color_manual(values=c("blue","green","green","green","purple")) 

df_pl %>% filter(subject_id=="67acacf033444654db29a196")

# df_pl_combine%>%filter(codeversion==2)

df_rt_pl%>%group_by(subject_id)%>%
  summarize(n=n(), acc=mean(all_accumulated_accuracy))%>%
  arrange(acc)

combined_df%>%filter(subject_id=="6751acc5dc78128951a34f1f")%>%select(is_finished)
# c("6751acc5dc78128951a34f1f","67f909f80373c9f5af736a5a") #final acc =0.2...