library(readr)
library(dplyr)
library(tidyr)

# Load E3 data
df_rt_pl <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")

# Function to map initial test item types to abbreviations
map_initial_item_type <- function(type) {
  case_when(
    type == "Target" ~ "ST",
    type == "New Foil" ~ "FTO",
    type == "Inherented Foil - Last Target" ~ "STn",
    type == "Inherented Foil - Last Studied Only" ~ "SOn",
    type == "Inherented Foil - Last Foil" ~ "TOn",
    TRUE ~ type
  )
}

# Function to map final test item types to abbreviations
map_final_item_type <- function(type) {
  case_when(
    type == "Target: : started and tested at (n) ; Appear once" ~ "ST",
    type == "Target: studied and tested at (n), Foil (n+1)" ~ "STn",
    type == "Studied-only (n); Appear once" ~ "SO",
    type == "Studied-only (n); Foil (n+1)" ~ "SOn",
    type == "Foil(n); Appear once" ~ "TO",
    type == "Foil(n), Foil (n+1)" ~ "TOn",
    type == "Final Foil" ~ "FTO",
    TRUE ~ type
  )
}

# Initialize results list
all_results <- list()

###############################################################################
# INITIAL TEST - Between List (by list number)
###############################################################################
cat("\n=== Processing Initial Test - Between List ===\n")

initial_between <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(correct), !is.na(listNum_appear0_initial)) %>%
  mutate(
    type_comment = typecomment_in,
    list_num = as.numeric(listNum_appear0_initial)
  ) %>%
  # First: get per-participant means
  group_by(subject_id, type_comment, list_num) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs across participants
  group_by(type_comment, list_num) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Initial Test Between-List Effect",
    Condition = "List Number",
    `Probe Type` = map_initial_item_type(type_comment),
    Position = list_num
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["initial_between"]] <- initial_between
cat("Initial between-list: ", nrow(initial_between), " rows\n")

###############################################################################
# INITIAL TEST - Within List by Study Position
###############################################################################
cat("\n=== Processing Initial Test - Study Position ===\n")

initial_study <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(correct), !is.na(studyPos_appear0_initial)) %>%
  mutate(
    type_comment = typecomment_in,
    study_pos = as.numeric(studyPos_appear0_initial),
    study_pos_bin = ceiling(study_pos / 3)
  ) %>%
  filter(!is.na(study_pos_bin)) %>%
  group_by(subject_id, type_comment, study_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, study_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Initial Test Within-List Effect",
    Condition = "Study Position",
    `Probe Type` = map_initial_item_type(type_comment),
    Position = study_pos_bin
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["initial_study"]] <- initial_study
cat("Initial study position: ", nrow(initial_study), " rows\n")

###############################################################################
# INITIAL TEST - Within List by Test Position
###############################################################################
cat("\n=== Processing Initial Test - Test Position ===\n")

initial_test <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(correct), !is.na(testPos_appear0_initial)) %>%
  mutate(
    type_comment = typecomment_in,
    test_pos = as.numeric(testPos_appear0_initial),
    test_pos_bin = ceiling(test_pos / 3)
  ) %>%
  filter(!is.na(test_pos_bin)) %>%
  group_by(subject_id, type_comment, test_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, test_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Initial Test Within-List Effect",
    Condition = "Test Position",
    `Probe Type` = map_initial_item_type(type_comment),
    Position = test_pos_bin
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["initial_test"]] <- initial_test
cat("Initial test position: ", nrow(initial_test), " rows\n")

###############################################################################
# FINAL TEST - By Final Test Position
###############################################################################
cat("\n=== Processing Final Test - Final Test Position ===\n")

final_by_final_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(testPos_final)) %>%
  mutate(
    type_comment = type_comment_fn,
    final_pos_bin = case_when(
      testPos_final <= 49 ~ 1,
      testPos_final <= 98 ~ 2,
      testPos_final <= 147 ~ 3,
      testPos_final <= 196 ~ 4,
      testPos_final <= 245 ~ 5,
      testPos_final <= 294 ~ 6,
      testPos_final <= 343 ~ 7,
      testPos_final <= 392 ~ 8,
      testPos_final <= 442 ~ 9,
      testPos_final <= 492 ~ 10,
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(final_pos_bin)) %>%
  group_by(subject_id, type_comment, final_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, final_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Final Test Between-List Effect",
    Condition = "Final Test Position",
    `Probe Type` = map_final_item_type(type_comment),
    Position = final_pos_bin
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["final_by_final_pos"]] <- final_by_final_pos
cat("Final test by final position: ", nrow(final_by_final_pos), " rows\n")

###############################################################################
# FINAL TEST - By Initial Study Position
###############################################################################
cat("\n=== Processing Final Test - Initial Study Position ===\n")

final_by_study_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(studyPos_appear1_initial)) %>%
  mutate(
    type_comment = type_comment_fn,
    study_pos = as.numeric(studyPos_appear1_initial),
    study_pos_bin = ceiling(study_pos / 3)
  ) %>%
  filter(!is.na(study_pos_bin)) %>%
  group_by(subject_id, type_comment, study_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, study_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Final Test Within-List Effect",
    Condition = "Initial Study Position",
    `Probe Type` = map_final_item_type(type_comment),
    Position = study_pos_bin
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["final_by_study_pos"]] <- final_by_study_pos
cat("Final test by initial study position: ", nrow(final_by_study_pos), " rows\n")

###############################################################################
# FINAL TEST - By Initial Test Position
###############################################################################
cat("\n=== Processing Final Test - Initial Test Position ===\n")

final_by_test_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(testPos_appear1_initial)) %>%
  mutate(
    type_comment = type_comment_fn,
    test_pos = as.numeric(testPos_appear1_initial),
    test_pos_bin = ceiling(test_pos / 3)
  ) %>%
  filter(!is.na(test_pos_bin)) %>%
  group_by(subject_id, type_comment, test_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, test_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Final Test Within-List Effect",
    Condition = "Initial Test Position",
    `Probe Type` = map_final_item_type(type_comment),
    Position = test_pos_bin
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["final_by_test_pos"]] <- final_by_test_pos
cat("Final test by initial test position: ", nrow(final_by_test_pos), " rows\n")

###############################################################################
# FINAL TEST - By Initial List Number
###############################################################################
cat("\n=== Processing Final Test - Initial List Number ===\n")

final_by_list_num <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(listNum_appear1_initial)) %>%
  mutate(
    type_comment = type_comment_fn,
    list_num = as.numeric(listNum_appear1_initial)
  ) %>%
  group_by(subject_id, type_comment, list_num) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  group_by(type_comment, list_num) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Analysis = "Final Test Between-List Effect",
    Condition = "Initial List Number",
    `Probe Type` = map_final_item_type(type_comment),
    Position = list_num
  ) %>%
  select(Analysis, Condition, `Probe Type`, Position, Value, `Standard Error`)

all_results[["final_by_list_num"]] <- final_by_list_num
cat("Final test by initial list number: ", nrow(final_by_list_num), " rows\n")

###############################################################################
# Combine all results and save
###############################################################################
cat("\n=== Combining all results ===\n")

combined_results <- bind_rows(all_results)

# Round to 2 decimal places
combined_results <- combined_results %>%
  mutate(
    Value = round(Value, 2),
    `Standard Error` = round(`Standard Error`, 2)
  )

# Sort properly
combined_results <- combined_results %>%
  arrange(Analysis, Condition, `Probe Type`, Position)

# Save to CSV
output_file <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_data_e3.csv"
write_csv(combined_results, output_file)

cat("\n=== Summary ===\n")
cat("Total rows:", nrow(combined_results), "\n")
cat("Output saved to:", output_file, "\n")

# Print summary
cat("\nRows by analysis:\n")
print(combined_results %>% count(Analysis, Condition))

cat("\nFirst 20 rows:\n")
print(head(combined_results, 20))

