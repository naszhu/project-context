library(dplyr)
library(readr)
library(tidyr)
library(knitr)
library(ggplot2)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN1_DIR <- file.path(PROJECT_ROOT, "design1")
DATA_ANALYSIS_DIR <- file.path(DESIGN1_DIR, "data_analysis")

# Load the preprocessed data
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"))
cat("Loaded dfchanged data from dfchanged.csv\n")

# Apply RT filter for test trials (150-3500ms)
dfchanged <- dfchanged %>%
  filter(!(task %in% c("pretest_response", "finalt_response") & (rt < 150 | rt > 3500)))

################################################################################
# TABLE 1: E1 Final Test Between List
################################################################################

dfserial <- dfchanged %>%
  filter(task == "finalt_response") %>%
  mutate(testpos = cut_number(testpos, 10, labels = 1:10)) %>%
  mutate(prespos = case_when(probetype == "FOIL" ~ 0, TRUE ~ prespos_itrial)) %>%
  mutate(testpos = as.integer(testpos), prespos = as.integer(prespos)) %>%
  filter(response != "null") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, correct, condition, probetype) %>%
  group_by(position, ip, position_type, condition, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(position, position_type, condition, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "FOIL" ~ "Foil - Correct rejection",
    TRUE ~ paste(probetype, " - Hits")
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Final Order",
    TRUE ~ "Initial Order"
  ))

# Format for APA table
table1 <- dfserial %>%
  mutate(M_SE = sprintf("%.3f (%.3f)", meancr, se)) %>%
  select(Condition = condition, Position_Type = position_type, Position = position, 
         Probe_Type = probetype, M_SE) %>%
  pivot_wider(names_from = Position, values_from = M_SE, names_prefix = "Pos_") %>%
  arrange(Condition, Position_Type, Probe_Type)

write_csv(table1, file.path(DATA_ANALYSIS_DIR, "Table1_Final_Between_List.csv"))
cat("\nTable 1: E1 Final Test Between List saved\n")

################################################################################
# TABLE 2: E1 Final Test Within List
################################################################################

df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, stimulus_id)

wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id), .groups = "drop")

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>%
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

df_final <- dfchanged %>%
  filter(task == "finalt_response") %>%
  filter(response != "null") %>%
  select(ip, correct, probetype, stimulus_id)

# FOIL performance
foil_performance <- df_final %>%
  filter(probetype == "FOIL") %>%
  group_by(ip, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(position = 0, position_type = "both")

# Non-FOIL data
df_finalwithin_nonfoil <- df_final %>%
  filter(probetype != "FOIL") %>%
  left_join(df_initial_all, by = c("ip", "stimulus_id")) %>%
  filter(!is.na(correct)) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop")

# Nontarget performance for Initial Test Position
nontarget_performance <- df_final %>%
  filter(probetype == "TARGET_nontarget") %>%
  group_by(ip, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(position = 0, position_type = "Initial Test Position")

df_finalwithin <- df_finalwithin_nonfoil %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil, neither studied nor tested - CR",
    probetype == "TARGET_target" ~ "Target, Studied and tested - Hits",
    probetype == "TARGET_nontarget" ~ "Target, Studied only - Hits"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Initial Test Position",
    position_type == "prespos" ~ "Initial Study Position"
  )) %>%
  bind_rows(
    foil_performance %>%
      mutate(position_type = "Initial Study Position", probetype = "FOIL - CR") %>%
      select(position, position_type, probetype, meancr, sd, se)
  ) %>%
  bind_rows(
    foil_performance %>%
      mutate(position_type = "Initial Test Position", probetype = "FOIL - CR") %>%
      select(position, position_type, probetype, meancr, sd, se)
  ) %>%
  bind_rows(
    nontarget_performance %>%
      mutate(probetype = "Target, Studied only - Hits") %>%
      select(position, position_type, probetype, meancr, sd, se)
  )

# Format for APA table
table2 <- df_finalwithin %>%
  mutate(M_SE = sprintf("%.3f (%.3f)", meancr, se)) %>%
  select(Position_Type = position_type, Position = position, 
         Probe_Type = probetype, M_SE) %>%
  pivot_wider(names_from = Position, values_from = M_SE, names_prefix = "Pos_") %>%
  arrange(Position_Type, Probe_Type)

write_csv(table2, file.path(DATA_ANALYSIS_DIR, "Table2_Final_Within_List.csv"))
cat("Table 2: E1 Final Test Within List saved\n")

################################################################################
# TABLE 3: E1 Initial Between List
################################################################################

df_initialtestbyinitial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(trialnum, ip, correct, probetype) %>%
  group_by(trialnum, ip, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(trialnum, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "FOIL" ~ "Foil - Correct rejection",
    TRUE ~ paste(probetype, " - Hits")
  ))

# Format for APA table
table3 <- df_initialtestbyinitial %>%
  mutate(M_SE = sprintf("%.3f (%.3f)", meancr, se)) %>%
  select(List_Number = trialnum, Probe_Type = probetype, M_SE) %>%
  pivot_wider(names_from = List_Number, values_from = M_SE, names_prefix = "List_") %>%
  arrange(Probe_Type)

write_csv(table3, file.path(DATA_ANALYSIS_DIR, "Table3_Initial_Between_List.csv"))
cat("Table 3: E1 Initial Between List saved\n")

################################################################################
# TABLE 4: E1 Initial Within List
################################################################################

dfserial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, correct, probetype) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil - Correct rejection",
    probetype == "TARGET_target" ~ "Target - Hits"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Initial Test Position",
    TRUE ~ "Initial Study Position"
  ))

dfserial_meandf <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  select(testpos, ip, correct, probetype) %>%
  group_by(testpos, ip) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(testpos) %>%
  summarize(meancr = mean(meancr1), sd = sd(meancr1), se = sd/sqrt(n()), .groups = "drop") %>%
  mutate(position_type = "Initial Test Position", position = testpos, probetype = "Average") %>%
  select(position, position_type, probetype, meancr, sd, se)

dfserial_all <- rbind(dfserial, dfserial_meandf)

# Format for APA table
table4 <- dfserial_all %>%
  mutate(M_SE = sprintf("%.3f (%.3f)", meancr, se)) %>%
  select(Position_Type = position_type, Position = position, 
         Probe_Type = probetype, M_SE) %>%
  pivot_wider(names_from = Position, values_from = M_SE, names_prefix = "Pos_") %>%
  arrange(Position_Type, Probe_Type)

write_csv(table4, file.path(DATA_ANALYSIS_DIR, "Table4_Initial_Within_List.csv"))
cat("Table 4: E1 Initial Within List saved\n")

################################################################################
# Create a summary document
################################################################################

summary_text <- "
APA-STYLE TABLES FOR E1 DATA ANALYSIS
=====================================

All tables show Mean (Standard Error) across participants.

TABLE 1: E1 Final Test Between List
- Shows performance by condition (backward, forward, random)
- Separated by position type (Final Order vs Initial Order)
- Position 0-10 for each probe type
- Probe types: Foil-CR, TARGET_foil-Hits, TARGET_nontarget-Hits, TARGET_target-Hits

TABLE 2: E1 Final Test Within List  
- Shows performance by position type (Initial Study Position vs Initial Test Position)
- Position 0-20 for each probe type
- Probe types: FOIL-CR, Foil neither studied nor tested-CR, Target Studied and tested-Hits, Target Studied only-Hits

TABLE 3: E1 Initial Between List
- Shows performance across list numbers 1-10
- All conditions combined
- Probe types: Foil-CR, TARGET_foil-Hits

TABLE 4: E1 Initial Within List
- Shows performance by position type (Initial Study Position vs Initial Test Position)
- Position 1-20 for each probe type
- Probe types: Foil-CR, Target-Hits, Average (test position only)

Note: CR = Correct Rejection
"

writeLines(summary_text, file.path(DATA_ANALYSIS_DIR, "APA_Tables_Summary.txt"))
cat("\nAll APA-style tables generated successfully!\n")
cat("Files saved in:", DATA_ANALYSIS_DIR, "\n")

