# library(Rmisc)
library(dplyr)
library(tidyverse)
library(tidyr)
library(readr)
library(here)
'%notin%' <- function(x,y)!('%in%'(x,y));

filepath=c("data/backup3/visualexp-forward.csv","data/backup3/visualexp-bakcward.csv","data/backup3/visualexp-random.csv",
      "data/backup2/visualexp-random.csv","data/backup/visualexp-random.csv","data/backup/visualexp-forward.csv",
      "data/backup/visualexp-bakcward.csv")
# df = readr::read_csv(filepath)
# lapply(filepath,read.csv)



df1 = read.csv(here("design1","data/backup3/visualexp-forward.csv"))%>%
  mutate(responsesum=as.integer(responsesum))
df2 = read.csv(here("design1","data/backup3/visualexp-bakcward.csv"))%>%
  mutate(responsesum=as.integer(responsesum))
df3 = read.csv(here("design1","data/backup3/visualexp-random.csv"))%>%
  mutate(responsesum=as.integer(responsesum))

df11 = read.csv(here("design1","data/backup2/visualexp-random.csv"))%>%
  mutate(responsesum=as.integer(responsesum))
df111 = read.csv(here("design1","data/backup/visualexp-random.csv"))%>%
  mutate(responsesum=as.integer(responsesum))
df22 = read.csv(here("design1","data/backup/visualexp-forward.csv"))
df33 = read.csv(here("design1","data/backup/visualexp-bakcward.csv"))

# df2222 <- 
#     c("data/backup3/visualexp-forward.csv","data/backup3/visualexp-bakcward.csv","data/backup3/visualexp-random.csv",
#       "data/backup2/visualexp-random.csv","data/backup/visualexp-random.csv","data/backup/visualexp-forward.csv",
#       "data/backup/visualexp-bakcward.csv")%>% 
#     map_df(~read_csv(.))%>%
# df44 = read.csv("data/pretest3_random/visualexp-random (2).csv")%>%
#   mutate(responsesum=as.integer(responsesum))
# df55= read.csv("data/backup2/visualexp-random.csv")%>%
#   mutate(responsesum=as.integer(responsesum))
# df3$responsesum
# df44$responsesum%>%as.factor()%>%summary()
# df3$responsesum%>%as.factor()%>%summary()

df = df1%>% full_join(df2)%>%full_join(df3)%>%
  full_join(df11)%>%full_join(df111)%>%
  full_join(df22)%>%full_join(df33)%>%
  # full_join(df44)%>%full_join(df55)%>%
    mutate(correct=case_when(correct=="true"~1,
                           correct=="false"~0,
                           TRUE~NA))%>%
filter(is_finished==1,codeversion==3)%>%
  filter(ip%notin%c("68.80.89.47"))




# 62b0ff84054c6ca32f481c65: delete f condition
# 63e5a6690eeedc20da056717: delete r condition
dfchanged = df %>%
  mutate(rt=as.numeric(rt))%>%
  filter(is_finished==1,codeversion==3) %>%
  # filter(all_accumulated_accuracy>0.67)%>%
  # filter(all_accumulated_accuracy>0.6)%>%
  filter(ip %notin% c("68.80.89.47"))%>% #myself
  filter(ip!="47.158.129.211") %>% # the very low performance , and Initial test outlier: 47.158.129.211 (52.3% initial, but 79.5% final)
  filter(!(PROLIFIC_PID=="62b0ff84054c6ca32f481c65" & condition=="f"))%>%#repeated
  filter(!(PROLIFIC_PID=="63e5a6690eeedc20da056717" & condition=="r"))%>% #repeated
   mutate(condition=case_when(condition=="b"~"backward",condition=="f"~"forward",condition=="r"~"random"))%>%
  # filter(ip%notin%c("172.58.12.116", "68.9.164.176",  "70.187.57.217", "73.104.3.163" ))%>%
  select(-c(width,height,webaudio,browser,browser_version,mobile,os,fullscreen,vsync_rate,microphone,trial_index,internal_node_id,webcam,run_id,recorded_at,source_code_version,user_agent,device,platform,platform_version,accept_language,subject_id,study_id,session_id,failed_images,failed_audio,failed_video,question_order,stimulus,referer,STUDY_ID,SESSION_ID,trial_type,starts_with("tot") ,jspsych.survey.multi.choice.response.0))%>%
  # filter(ip%notin%c("68.9.164.176","166.194.147.4","198.54.106.254","172.58.12.116","70.187.57.217","65.188.39.31")) %>% #filtered by rt
  # Exclude participants with severe performance/engagement issues (overall accuracy < 67% + additional flags)
  filter(ip != "70.132.209.70") %>%      # 51.1% accuracy, extreme low (Z=-3.20), extreme low initial (Z=-3.34)
  filter(ip != "166.182.250.23") %>%     # 51.8% accuracy, extreme low (Z=-3.12), extreme low initial (Z=-3.52)
  filter(ip != "24.125.120.89") %>%      # 52.0% accuracy, extreme low (Z=-3.09), extreme low initial (Z=-3.13)
  filter(ip != "73.30.97.36") %>%        # 53.2% accuracy, extreme low (Z=-2.97), extreme low initial, very fast RT
  filter(ip != "68.203.195.141") %>%     # 54.5% accuracy, extreme low (Z=-2.83), extreme low initial (Z=-2.96)
  filter(ip != "169.239.205.216") %>%    # 55.0% accuracy, extreme low (Z=-2.76), extreme low initial (Z=-3.27)
  filter(ip != "81.161.5.191") %>%       # 55.3% accuracy, extreme low (Z=-2.74), extreme low initial (Z=-2.59)
  filter(ip != "73.244.145.220") %>%     # 57.2% accuracy, extreme low (Z=-2.53), severe learning decline
  filter(ip != "73.58.238.227") %>%      # 58.8% accuracy, extreme RT outlier (310ms), rushing (11.7% fast), severe decline (-33.8%)
  # Exclude trials outside experiment's RT cutoffs (150-3500ms) - affects test trials only
  filter(!(task %in% c("pretest_response", "finalt_response") & (rt < 150 | rt > 3500))) %>%  # 351 trials (0.276%)
  mutate()



  # num_low_acc_participants <- df %>%
  #   group_by(ip) %>%
  #   summarize(min_acc = min(all_accumulated_accuracy, na.rm = TRUE)) %>%
  #   filter(min_acc < 0.67) %>%
  #   nrow()
  # cat(sprintf("Number of participants with all accumulated accuracy lower than 0.67: %d\n", num_low_acc_participants))

  write_csv(dfchanged, "dfchanged.csv")
  # write_csv(dfchanged, "dfchanged_raw_before_exclude.csv")
  cat("dfchanged data saved to dfchanged.csv\n")