library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

PROJECT_ROOT <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context"
DESIGN1_DIR <- file.path(PROJECT_ROOT, "design1")
DATA_ANALYSIS_DIR <- file.path(DESIGN1_DIR, "data_analysis")

# Load the preprocessed data
dfchanged <- read_csv(file.path(DATA_ANALYSIS_DIR, "dfchanged.csv"), show_col_types = FALSE)

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
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "FOIL" ~ "Foil",
    probetype == "TARGET_foil" ~ "T_foil",
    probetype == "TARGET_nontarget" ~ "T_nontarget",
    probetype == "TARGET_target" ~ "T_target"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Final Order",
    TRUE ~ "Initial Order"
  ))

# Create text table
output1 <- character()
output1 <- c(output1, "Table 1")
output1 <- c(output1, "E1 Final Test Between List: Hits and Correct Rejections by Condition, Position Type, and Test Order")
output1 <- c(output1, "")
output1 <- c(output1, paste(rep("_", 120), collapse = ""))
output1 <- c(output1, "")

for (cond in c("backward", "forward", "random")) {
  for (pos_type in c("Final Order", "Initial Order")) {
    output1 <- c(output1, sprintf("\n%s - %s", toupper(cond), pos_type))
    output1 <- c(output1, paste(rep("-", 120), collapse = ""))
    
    df_subset <- dfserial %>% 
      filter(condition == cond, position_type == pos_type) %>%
      arrange(probetype, position)
    
    # Header
    output1 <- c(output1, sprintf("%-15s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s", 
                                 "Probe Type", "Pos 0", "Pos 1", "Pos 2", "Pos 3", "Pos 4", 
                                 "Pos 5", "Pos 6", "Pos 7", "Pos 8", "Pos 9", "Pos 10"))
    
    for (ptype in unique(df_subset$probetype)) {
      df_row <- df_subset %>% filter(probetype == ptype) %>% arrange(position)
      
      row_vals <- rep("--", 11)
      for (i in 1:nrow(df_row)) {
        pos_idx <- df_row$position[i] + 1
        if (pos_idx <= 11 && pos_idx >= 1) {
          row_vals[pos_idx] <- sprintf("%.2f (%.2f)", df_row$M[i], df_row$SE[i])
        }
      }
      
      output1 <- c(output1, sprintf("%-15s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s",
                                   ptype, row_vals[1], row_vals[2], row_vals[3], row_vals[4], 
                                   row_vals[5], row_vals[6], row_vals[7], row_vals[8], 
                                   row_vals[9], row_vals[10], row_vals[11]))
    }
  }
}

output1 <- c(output1, "")
output1 <- c(output1, paste(rep("_", 120), collapse = ""))
output1 <- c(output1, "")
output1 <- c(output1, "Note. Values are M (SE). T_foil = studied foil items; T_nontarget = studied but not initially tested;")
output1 <- c(output1, "T_target = studied and initially tested. Pos 0 represents foils (unstudied items).")

writeLines(output1, file.path(DATA_ANALYSIS_DIR, "Table1_APA_Text.txt"))
cat("Table 1 saved\n")

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

foil_performance <- df_final %>%
  filter(probetype == "FOIL") %>%
  group_by(ip) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n())) %>%
  mutate(position = 0, position_type = "both", probetype = "FOIL")

df_finalwithin_nonfoil <- df_final %>%
  filter(probetype != "FOIL") %>%
  left_join(df_initial_all, by = c("ip", "stimulus_id")) %>%
  filter(!is.na(correct)) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n()), .groups = "drop")

nontarget_performance <- df_final %>%
  filter(probetype == "TARGET_nontarget") %>%
  group_by(ip) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n())) %>%
  mutate(position = 0, position_type = "testpos", probetype = "TARGET_nontarget")

df_finalwithin <- df_finalwithin_nonfoil %>%
  bind_rows(foil_performance %>% mutate(position_type = "prespos")) %>%
  bind_rows(foil_performance %>% mutate(position_type = "testpos")) %>%
  bind_rows(nontarget_performance) %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "T_foil",
    probetype == "TARGET_target" ~ "T_target",
    probetype == "TARGET_nontarget" ~ "T_nontarget",
    probetype == "FOIL" ~ "FOIL"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Initial Test",
    position_type == "prespos" ~ "Initial Study"
  ))

output2 <- character()
output2 <- c(output2, "Table 2")
output2 <- c(output2, "E1 Final Test Within List: Hits and Correct Rejections by Position Type and Position")
output2 <- c(output2, "")
output2 <- c(output2, paste(rep("_", 140), collapse = ""))
output2 <- c(output2, "")

for (pos_type in c("Initial Study", "Initial Test")) {
  output2 <- c(output2, sprintf("\n%s Position", pos_type))
  output2 <- c(output2, paste(rep("-", 140), collapse = ""))
  
  df_subset <- df_finalwithin %>% 
    filter(position_type == pos_type) %>%
    arrange(probetype, position)
  
  # Get unique positions (excluding NA)
  positions <- sort(unique(df_subset$position[!is.na(df_subset$position)]))
  max_pos <- min(max(positions), 20)
  
  # Create header dynamically
  header_parts <- sprintf("Pos %d", 0:max_pos)
  header <- sprintf("%-15s", "Probe Type")
  for (h in header_parts) {
    header <- paste0(header, sprintf(" %12s", h))
  }
  output2 <- c(output2, header)
  
  for (ptype in unique(df_subset$probetype)) {
    df_row <- df_subset %>% filter(probetype == ptype) %>% arrange(position)
    
    row_vals <- rep("--", max_pos + 1)
    for (i in 1:nrow(df_row)) {
      pos_idx <- df_row$position[i] + 1
      if (pos_idx <= (max_pos + 1) && pos_idx >= 1) {
        row_vals[pos_idx] <- sprintf("%.2f (%.2f)", df_row$M[i], df_row$SE[i])
      }
    }
    
    row_str <- sprintf("%-15s", ptype)
    for (val in row_vals) {
      row_str <- paste0(row_str, sprintf(" %12s", val))
    }
    output2 <- c(output2, row_str)
  }
}

output2 <- c(output2, "")
output2 <- c(output2, paste(rep("_", 140), collapse = ""))
output2 <- c(output2, "")
output2 <- c(output2, "Note. Values are M (SE). T_foil = neither studied nor tested (studied foils); T_target = studied and tested;")
output2 <- c(output2, "T_nontarget = studied only. FOIL = unstudied items (new foils).")

writeLines(output2, file.path(DATA_ANALYSIS_DIR, "Table2_APA_Text.txt"))
cat("Table 2 saved\n")

################################################################################
# TABLE 3: E1 Initial Between List
################################################################################

df_initialtestbyinitial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(trialnum, ip, correct, probetype) %>%
  group_by(trialnum, ip, probetype) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(trialnum, probetype) %>%
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil",
    probetype == "TARGET_target" ~ "Target"
  ))

output3 <- character()
output3 <- c(output3, "Table 3")
output3 <- c(output3, "E1 Initial Between List: Hits and Correct Rejections by List Number")
output3 <- c(output3, "")
output3 <- c(output3, paste(rep("_", 100), collapse = ""))
output3 <- c(output3, "")
output3 <- c(output3, sprintf("%-15s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s",
                             "Probe Type", "List 1", "List 2", "List 3", "List 4", "List 5",
                             "List 6", "List 7", "List 8", "List 9", "List 10"))
output3 <- c(output3, paste(rep("-", 100), collapse = ""))

for (ptype in c("Foil", "Target")) {
  df_row <- df_initialtestbyinitial %>% filter(probetype == ptype) %>% arrange(trialnum)
  
  row_vals <- sprintf("%.2f (%.2f)", df_row$M, df_row$SE)
  
  output3 <- c(output3, sprintf("%-15s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s",
                               ptype, row_vals[1], row_vals[2], row_vals[3], row_vals[4], 
                               row_vals[5], row_vals[6], row_vals[7], row_vals[8], 
                               row_vals[9], row_vals[10]))
}

output3 <- c(output3, paste(rep("_", 100), collapse = ""))
output3 <- c(output3, "")
output3 <- c(output3, "Note. Values are M (SE). All conditions combined. Foil = studied foil items (correct rejections);")
output3 <- c(output3, "Target = studied target items (hits).")

writeLines(output3, file.path(DATA_ANALYSIS_DIR, "Table3_APA_Text.txt"))
cat("Table 3 saved\n")

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
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n()), .groups = "drop") %>%
  mutate(probetype = case_when(
    probetype == "TARGET_foil" ~ "Foil",
    probetype == "TARGET_target" ~ "Target"
  )) %>%
  mutate(position_type = case_when(
    position_type == "testpos" ~ "Initial Test",
    TRUE ~ "Initial Study"
  ))

dfserial_meandf <- dfchanged %>%
  filter(task == "pretest_response") %>%
  filter(response != "null") %>%
  select(testpos, ip, correct) %>%
  group_by(testpos, ip) %>%
  summarize(meancr1 = mean(correct), .groups = "drop") %>%
  group_by(testpos) %>%
  summarize(M = mean(meancr1), SE = sd(meancr1)/sqrt(n()), .groups = "drop") %>%
  mutate(position_type = "Initial Test", position = testpos, probetype = "Average") %>%
  select(position, position_type, probetype, M, SE)

dfserial_all <- rbind(dfserial, dfserial_meandf)

output4 <- character()
output4 <- c(output4, "Table 4")
output4 <- c(output4, "E1 Initial Within List: Hits and Correct Rejections by Position Type and Position")
output4 <- c(output4, "")
output4 <- c(output4, paste(rep("_", 140), collapse = ""))
output4 <- c(output4, "")

for (pos_type in c("Initial Study", "Initial Test")) {
  output4 <- c(output4, sprintf("\n%s Position", pos_type))
  output4 <- c(output4, paste(rep("-", 140), collapse = ""))
  
  df_subset <- dfserial_all %>% 
    filter(position_type == pos_type) %>%
    arrange(probetype, position)
  
  # Get max position
  positions <- sort(unique(df_subset$position[!is.na(df_subset$position)]))
  if (pos_type == "Initial Study") {
    max_pos <- max(positions)
  } else {
    max_pos <- 20
  }
  
  # Create header
  header_parts <- c("Pos 0")
  if (max_pos >= 1) {
    for (i in 1:max_pos) {
      header_parts <- c(header_parts, sprintf("Pos %d", i))
    }
  }
  
  header <- sprintf("%-15s", "Probe Type")
  for (h in header_parts) {
    header <- paste0(header, sprintf(" %11s", h))
  }
  output4 <- c(output4, header)
  
  for (ptype in unique(df_subset$probetype)) {
    df_row <- df_subset %>% filter(probetype == ptype) %>% arrange(position)
    
    row_vals <- rep("--", length(header_parts))
    for (i in 1:nrow(df_row)) {
      pos_idx <- df_row$position[i] + 1
      if (pos_idx <= length(header_parts) && pos_idx >= 1) {
        row_vals[pos_idx] <- sprintf("%.2f (%.2f)", df_row$M[i], df_row$SE[i])
      }
    }
    
    row_str <- sprintf("%-15s", ptype)
    for (val in row_vals) {
      row_str <- paste0(row_str, sprintf(" %11s", val))
    }
    output4 <- c(output4, row_str)
  }
}

output4 <- c(output4, "")
output4 <- c(output4, paste(rep("_", 140), collapse = ""))
output4 <- c(output4, "")
output4 <- c(output4, "Note. Values are M (SE). Foil = studied foil items (correct rejections); Target = studied target")
output4 <- c(output4, "items (hits). Average shown for Initial Test Position only (mean across foil and target).")

writeLines(output4, file.path(DATA_ANALYSIS_DIR, "Table4_APA_Text.txt"))
cat("Table 4 saved\n")

cat("\n✓ All APA text tables generated successfully!\n")
cat("Files saved in:", DATA_ANALYSIS_DIR, "\n")

