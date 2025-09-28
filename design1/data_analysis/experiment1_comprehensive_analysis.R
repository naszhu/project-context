# ------------------
# 1. Libraries
# ------------------
library(tidyverse)
library(lme4)
library(broom.mixed)
library(performance)

# ------------------
# 2. Data load
# ------------------
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# ------------------
# 3. Helper: polynomial + centering
# ------------------
create_poly <- function(x, degree = 2) {
  x <- as.numeric(x)
  x <- x - mean(x, na.rm = TRUE)
  poly(x, degree = degree, raw = FALSE)
}

# ------------------
# 4. Helper: run model with convergence check
# ------------------
run_model <- function(formula, data, name) {
  cat("\n========================\n")
  cat("Fitting:", name, "\n")
  m <- glmer(
    formula,
    data = data,
    family = binomial,
    control = glmerControl(optimizer = "bobyqa", calc.derivs = TRUE)
  )
  
  # Summary
  print(summary(m)$coefficients)
  
  # 收敛检查
  cat("\n--- Convergence check ---\n")
  print(check_convergence(m))
  print(check_singularity(m))
  
  return(m)
}

# ------------------
# 5. Initial test data
# ------------------
initial_data <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    accuracy = as.numeric(correct),
    study_position_c = scale(as.numeric(prespos), center = TRUE, scale = FALSE)[,1],
    test_position_c  = scale(as.numeric(testpos), center = TRUE, scale = FALSE)[,1],
    list_c = scale(as.numeric(trialnum), center = TRUE, scale = FALSE)[,1],
    item_type = ifelse(probetype == "TARGET_target", "target", "foil"),
    subject = factor(ip),
    condition = factor(condition)
  ) %>%
  filter(!is.na(accuracy), !is.na(study_position_c), !is.na(test_position_c))

cat("Initial test data prepared:", nrow(initial_data), "trials\n")

# ------------------
# 6. Final test data
# ------------------
final_data <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  mutate(
    accuracy = as.numeric(correct),
    study_position_c = scale(as.numeric(prespos), center = TRUE, scale = FALSE)[,1],
    test_position_c  = scale(as.numeric(testpos), center = TRUE, scale = FALSE)[,1],
    list_c = scale(as.numeric(prespos_itrial), center = TRUE, scale = FALSE)[,1],
    item_type = case_when(
      probetype == "TARGET_target" ~ "S&T",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil" ~ "TO",
      probetype == "FOIL" ~ "foil"
    ),
    subject = factor(ip),
    condition = factor(condition)
  ) %>%
  filter(!is.na(accuracy), !is.na(study_position_c), !is.na(test_position_c))

cat("Final test data prepared:", nrow(final_data), "trials\n")

# ------------------
# 7. Models
# ------------------

# Initial study position
m_init_studypos <- run_model(
  accuracy ~ study_position_c + I(study_position_c^2) * item_type * condition +
    (1 + study_position_c | subject),
  initial_data,
  "Initial Study Position"
)

# Initial test position
m_init_testpos <- run_model(
  accuracy ~ test_position_c + I(test_position_c^2) * item_type * condition +
    (1 + test_position_c | subject),
  initial_data,
  "Initial Test Position"
)

# Initial between-list
m_init_between <- run_model(
  accuracy ~ list_c + I(list_c^2) * item_type * condition +
    (1 + list_c | subject),
  initial_data,
  "Initial Between-List"
)

# Final study position
m_final_studypos <- run_model(
  accuracy ~ study_position_c + I(study_position_c^2) * item_type * condition +
    (1 + study_position_c | subject),
  final_data,
  "Final Study Position"
)

# Final test position
m_final_testpos <- run_model(
  accuracy ~ test_position_c + I(test_position_c^2) * item_type * condition +
    (1 + test_position_c | subject),
  final_data,
  "Final Test Position"
)

# Final initial list position
m_final_initiallist <- run_model(
  accuracy ~ list_c + I(list_c^2) * item_type * condition +
    (1 + list_c | subject),
  final_data,
  "Final Initial List Position"
)

# Final test chunk (if you chunk testpos into 10 bins)
final_data <- final_data %>%
  mutate(test_chunk = cut_number(test_position_c, 10, labels = 1:10))
m_final_testchunk <- run_model(
  accuracy ~ as.numeric(test_chunk) * item_type * condition +
    (1 | subject),
  final_data,
  "Final Test Chunk"
)

# ------------------
# 8. Save results
# ------------------
results <- list(
  init_studypos = broom.mixed::tidy(m_init_studypos, effects = "fixed", conf.int = TRUE),
  init_testpos  = broom.mixed::tidy(m_init_testpos, effects = "fixed", conf.int = TRUE),
  init_between  = broom.mixed::tidy(m_init_between, effects = "fixed", conf.int = TRUE),
  final_studypos = broom.mixed::tidy(m_final_studypos, effects = "fixed", conf.int = TRUE),
  final_testpos  = broom.mixed::tidy(m_final_testpos, effects = "fixed", conf.int = TRUE),
  final_initiallist = broom.mixed::tidy(m_final_initiallist, effects = "fixed", conf.int = TRUE),
  final_testchunk  = broom.mixed::tidy(m_final_testchunk, effects = "fixed", conf.int = TRUE)
)

saveRDS(
  list(
    models = list(
      m_init_studypos = m_init_studypos,
      m_init_testpos  = m_init_testpos,
      m_init_between  = m_init_between,
      m_final_studypos = m_final_studypos,
      m_final_testpos  = m_final_testpos,
      m_final_initiallist = m_final_initiallist,
      m_final_testchunk  = m_final_testchunk
    ),
    summaries = results
  ),
  "experiment1_glmm_full.rds"
)

cat("\nAll models finished. Results saved to experiment1_glmm_full.rds\n")
