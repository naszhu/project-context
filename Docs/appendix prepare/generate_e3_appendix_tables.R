library(readr)
library(dplyr)
library(tidyr)

# Load E3 data
df_rt_pl <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv")

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
    Table = "Table E3.1",
    Subsection = "Initial List Number",
    `Probe Type` = type_comment,
    Position = list_num,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["initial_between"]] <- initial_between
cat("Initial between-list: ", nrow(initial_between), " rows\n")

###############################################################################
# INITIAL TEST - Within List by Study Position (binned into 10 groups)
###############################################################################
cat("\n=== Processing Initial Test - Study Position ===\n")

initial_study <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(correct), !is.na(studyPos_appear0_initial)) %>%
  mutate(
    type_comment = typecomment_in,
    study_pos = as.numeric(studyPos_appear0_initial),
    # Bin into 10 groups (1-10)
    study_pos_bin = ceiling(study_pos / 3)
  ) %>%
  filter(!is.na(study_pos_bin)) %>%
  # First: get per-participant means
  group_by(subject_id, type_comment, study_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, study_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.2",
    Subsection = "Initial Study Position",
    `Probe Type` = type_comment,
    Position = study_pos_bin,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["initial_study"]] <- initial_study
cat("Initial study position: ", nrow(initial_study), " rows\n")

###############################################################################
# INITIAL TEST - Within List by Test Position (binned into 10 groups)
###############################################################################
cat("\n=== Processing Initial Test - Test Position ===\n")

initial_test <- df_rt_pl %>%
  filter(task == "initialTest_response") %>%
  filter(!is.na(correct), !is.na(testPos_appear0_initial)) %>%
  mutate(
    type_comment = typecomment_in,
    test_pos = as.numeric(testPos_appear0_initial),
    # Bin into 10 groups (1-10)
    test_pos_bin = ceiling(test_pos / 3)
  ) %>%
  filter(!is.na(test_pos_bin)) %>%
  # First: get per-participant means
  group_by(subject_id, type_comment, test_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, test_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.2",
    Subsection = "Initial Test Position",
    `Probe Type` = type_comment,
    Position = test_pos_bin,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["initial_test"]] <- initial_test
cat("Initial test position: ", nrow(initial_test), " rows\n")

###############################################################################
# FINAL TEST - By Final Test Position (binned into 10 groups)
###############################################################################
cat("\n=== Processing Final Test - Final Test Position ===\n")

final_by_final_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(testPos_final)) %>%
  mutate(
    type_comment = type_comment_fn,
    # Bin final test position into 10 groups
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
  # First: get per-participant means
  group_by(subject_id, type_comment, final_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, final_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.3",
    Subsection = "Final Test Position",
    `Probe Type` = type_comment,
    Position = final_pos_bin,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["final_by_final_pos"]] <- final_by_final_pos
cat("Final test by final position: ", nrow(final_by_final_pos), " rows\n")

###############################################################################
# FINAL TEST - By Initial Study Position (binned into 10 groups)
###############################################################################
cat("\n=== Processing Final Test - Initial Study Position ===\n")

final_by_study_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(studyPos_appear1_initial)) %>%
  mutate(
    type_comment = type_comment_fn,
    study_pos = as.numeric(studyPos_appear1_initial),
    # Bin into 10 groups
    study_pos_bin = ceiling(study_pos / 3)
  ) %>%
  filter(!is.na(study_pos_bin)) %>%
  # First: get per-participant means
  group_by(subject_id, type_comment, study_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, study_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.4",
    Subsection = "Initial Study Position",
    `Probe Type` = type_comment,
    Position = study_pos_bin,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["final_by_study_pos"]] <- final_by_study_pos
cat("Final test by initial study position: ", nrow(final_by_study_pos), " rows\n")

###############################################################################
# FINAL TEST - By Initial Test Position (binned into 10 groups)
###############################################################################
cat("\n=== Processing Final Test - Initial Test Position ===\n")

final_by_test_pos <- df_rt_pl %>%
  filter(task == "finalTest") %>%
  filter(!is.na(correct), !is.na(testPos_appear1_initial)) %>%
  mutate(
    type_comment = type_comment_fn,
    test_pos = as.numeric(testPos_appear1_initial),
    # Bin into 10 groups
    test_pos_bin = ceiling(test_pos / 3)
  ) %>%
  filter(!is.na(test_pos_bin)) %>%
  # First: get per-participant means
  group_by(subject_id, type_comment, test_pos_bin) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, test_pos_bin) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.4",
    Subsection = "Initial Test Position",
    `Probe Type` = type_comment,
    Position = test_pos_bin,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

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
  # First: get per-participant means
  group_by(subject_id, type_comment, list_num) %>%
  summarise(subj_mean = mean(correct), .groups = 'drop') %>%
  # Second: get group means and SEs
  group_by(type_comment, list_num) %>%
  summarise(
    Value = mean(subj_mean),
    `Standard Error` = sd(subj_mean) / sqrt(n()),
    .groups = 'drop'
  ) %>%
  mutate(
    Table = "Table E3.4",
    Subsection = "Initial List Number",
    `Probe Type` = type_comment,
    Position = list_num,
    Notes = ""
  ) %>%
  select(Table, Subsection, `Probe Type`, Position, Value, `Standard Error`, Notes)

all_results[["final_by_list_num"]] <- final_by_list_num
cat("Final test by initial list number: ", nrow(final_by_list_num), " rows\n")

###############################################################################
# Combine all results and save
###############################################################################
cat("\n=== Combining all results ===\n")

# Combine all tables
combined_results <- bind_rows(all_results)

# Round to 2 decimal places
combined_results <- combined_results %>%
  mutate(
    Value = round(Value, 2),
    `Standard Error` = round(`Standard Error`, 2)
  )

# Sort by table, subsection, probe type, and position
combined_results <- combined_results %>%
  arrange(Table, Subsection, `Probe Type`, Position)

# Save to CSV
output_file <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_data_e3.csv"
write_csv(combined_results, output_file)

cat("\n=== Summary ===\n")
cat("Total rows:", nrow(combined_results), "\n")
cat("Output saved to:", output_file, "\n")

# Print summary by table
cat("\nRows by table:\n")
print(combined_results %>% count(Table))

# Print sample of results
cat("\nFirst 20 rows:\n")
print(head(combined_results, 20))

