library(dplyr)
library(readr)
library(tidyr)

# Load the raw data exactly like the plotting script
dfchanged <- read_csv("dfchanged.csv")

cat("=== CORRECT INITIAL WITHIN-LIST ANALYSIS ===\n\n")

# Create dfserial data exactly like the plotting script
dfserial = dfchanged %>%
  filter(task=="pretest_response") %>%
  filter(response!="null") %>%
  pivot_longer(cols=c(testpos,prespos), names_to="position_type", values_to="position") %>%
  select(position, ip, position_type, correct, probetype) %>%
  group_by(position, ip, position_type, probetype) %>%
  summarize(meancr1=mean(correct), .groups = "drop") %>%
  group_by(position, position_type, probetype) %>%
  summarize(meancr=mean(meancr1), sd=sd(meancr1), se=sd/sqrt(n()), .groups = "drop") %>%
  mutate(probetype=case_when(
    probetype=="TARGET_foil"~"Foil - Correct rejection",
    probetype=="TARGET_target"~"Target - Hits"
  )) %>%
  mutate(position_type=case_when(
    position_type=="testpos"~"Initial Test Position",
    TRUE~"Initial Study Position"
  ))

cat("Raw data before averaging:\n")
raw_check = dfchanged %>%
  filter(task=="pretest_response") %>%
  filter(response!="null") %>%
  group_by(probetype) %>%
  summarize(
    n_trials = n(),
    mean_correct = mean(correct),
    .groups = "drop"
  )
print(raw_check)

cat("\nAfter processing - averages by probe type:\n")
averages_by_type = dfserial %>%
  group_by(probetype) %>%
  summarize(overall_mean = mean(meancr), .groups = "drop") %>%
  arrange(desc(overall_mean))
print(averages_by_type)

cat("\nSample data points from Initial Test Position:\n")
test_position_sample = dfserial %>%
  filter(position_type == "Initial Test Position") %>%
  arrange(position) %>%
  select(position, probetype, meancr) %>%
  head(20)
print(test_position_sample)

cat("\nNow I can see if foils are actually higher than targets in the INITIAL testing data!\n")