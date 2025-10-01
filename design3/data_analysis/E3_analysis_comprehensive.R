# ================================
# EXPERIMENT 3 COMPREHENSIVE ANALYSIS
# GLMMs with item-type-specific trends and confusing foil handling
# ================================
library(tidyverse)
library(lme4)
library(broom.mixed)
library(emmeans)
library(here)

# 0) Set working directory and load data
setwd("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data_analysis")
df_e3 <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv") %>%
  mutate(
    accuracy = case_when(
      correct == "True" ~ 1,
      correct == "False" ~ 0,
      TRUE ~ as.numeric(correct)
    )
  )
cat("Loaded E3_AGGREGATED data with", nrow(df_e3), "rows\n")

# 1) Helper: safe poly (same as Experiment 1)
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  if (all(is.na(v))) {
    out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
    return(out)
  }
  
  # Center but don't scale
  v_center <- v - mean(v, na.rm = TRUE)
  unique_vals <- unique(na.omit(v_center))
  n_unique <- length(unique_vals)
  
  if (n_unique < 2) {
    out <- data.frame(lin = rep(0, length(v)), quad = rep(0, length(v)))
  } else if (n_unique == 2) {
    lin <- as.integer(v_center == unique_vals[2])
    out <- data.frame(lin = lin, quad = rep(0, length(v)))
  } else {
    nona_idx <- !is.na(v_center)
    if (sum(nona_idx) < 3) {
      out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    } else {
      poly_res <- poly(v_center[nona_idx], degree = 2, raw = FALSE, simple = TRUE)
      lin <- rep(NA, length(v))
      quad <- rep(NA, length(v))
      lin[nona_idx] <- poly_res[,1]
      quad[nona_idx] <- poly_res[,2]
      out <- data.frame(lin = lin, quad = quad)
    }
  }
  
  names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
  return(out)
}

# Add convergence diagnostics function
check_convergence_issues <- function(model) {
  if (!is.null(model@optinfo$conv$lme4$messages)) {
    cat("Convergence warnings:\n")
    cat(paste(model@optinfo$conv$lme4$messages, collapse = "\n"), "\n")
  }
  
  if (!is.null(model@optinfo$warnings)) {
    cat("Optimization warnings:\n")
    cat(paste(model@optinfo$warnings, collapse = "\n"), "\n")
  }
  
  # Check gradient
  if (!is.null(model@optinfo$derivs)) {
    rel_grad <- with(model@optinfo$derivs, max(abs(solve(Hessian, gradient))))
    cat("Relative gradient:", rel_grad, "\n")
    if (rel_grad > 0.001) {
      cat("WARNING: Large relative gradient - model may not have converged\n")
    }
    
    # Check Hessian
    if (any(eigen(model@optinfo$derivs$Hessian)$values <= 0)) {
      cat("WARNING: Hessian matrix is not positive definite\n")
    }
  }
}

# Add data validation function
validate_position_data <- function(df, position_var) {
  pos_vals <- df[[position_var]]
  unique_vals <- length(unique(na.omit(pos_vals)))
  cat("Unique values in", position_var, ":", unique_vals, "\n")
  if (unique_vals < 3) {
    cat("WARNING: Insufficient unique values for", position_var, 
        "- polynomial terms may be invalid\n")
  }
}

# 2) Initial test data preparation with confusing foils
initial_e3 <- df_e3 %>%
  filter(task == "initialTest_response") %>%
  mutate(
    participant_id = factor(subject_id),
    item_type = factor(typecomment_in),
    study_position = as.numeric(studyPos_appear0_initial),
    test_position = as.numeric(testPos_appear0_initial),
    list_number = as.numeric(listNum_appear0_initial),
    accuracy=correct
  ) %>%
  filter(!is.na(accuracy), !is.na(item_type)) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number")) %>%
  select(
    accuracy,
    participant_id,
    item_type,
    study_position,
    test_position,
    list_number,
    study_position_lin,
    study_position_quad,
    test_position_lin,
    test_position_quad,
    list_number_lin,
    list_number_quad
  )

cat("Initial test data prepared:", nrow(initial_e3), "trials\n")

# Validate position data
validate_position_data(initial_e3, "study_position")
validate_position_data(initial_e3, "test_position")
validate_position_data(initial_e3, "list_number")

# 3) Final test data preparation
final_e3 <- df_e3 %>%
  filter(task == "finalTest") %>%
  mutate(
    participant_id = factor(subject_id),
    item_type = factor(type_comment_fn),
    # Position variables from initial exposure
    initial_study_position = as.numeric(studyPos_appear1_initial),
    initial_test_position = as.numeric(testPos_appear1_initial),
    initial_list_number = as.numeric(listNum_appear1_initial),
    # Final test position (binned into 10 groups)
    final_test_position = case_when(
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
    ),
    accuracy=case_when(correct=="True"~1,
                           correct=="False"~0,
                           TRUE ~ correct)
  ) %>%
  filter(!is.na(accuracy), !is.na(item_type)) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "initial_study_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_test_position")) %>%
  bind_cols(create_polynomial_terms(., "initial_list_number")) %>%
  bind_cols(create_polynomial_terms(., "final_test_position"))%>%
  select(
    accuracy,
    participant_id,
    item_type,
    initial_study_position,
    initial_test_position,
    initial_list_number,
    final_test_position,
    initial_study_position_lin,
    initial_study_position_quad,
    initial_test_position_lin,
    initial_test_position_quad,
    initial_list_number_lin,
    initial_list_number_quad,
    final_test_position_lin,
    final_test_position_quad
  )

cat("Final test data prepared:", nrow(final_e3), "trials\n")

# Validate final test position data
validate_position_data(final_e3, "initial_study_position")
validate_position_data(final_e3, "initial_test_position")
validate_position_data(final_e3, "initial_list_number")
validate_position_data(final_e3, "final_test_position")

# 4) GLMM Models for Experiment 3
cat("\n=== FITTING INITIAL TEST MODELS ===\n")

# Initial test models with confusing foils
m_init_studypos_e3 <- glmer(
#   accuracy ~ (study_position_lin + study_position_quad) * item_type +
  accuracy ~ study_position_lin * item_type + study_position_quad +
    (1 | participant_id),
  data = initial_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

cat("\n=== Initial Study Position Model ===\n")
check_convergence_issues(m_init_studypos_e3)

m_init_testpos_e3 <- glmer(
  accuracy ~ test_position_lin * item_type + test_position_quad +
    (1 | participant_id),
  data = initial_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

cat("\n=== Initial Test Position Model ===\n")
check_convergence_issues(m_init_testpos_e3)

m_init_between_e3 <- glmer(
  accuracy ~ list_number_lin * item_type + list_number_quad +
    (1 | participant_id),
  data = initial_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

cat("\n=== Initial Between-List Model ===\n")
check_convergence_issues(m_init_between_e3)

# Final test models
cat("\n=== FITTING FINAL TEST MODELS ===\n")

m_final_within_study_e3 <- glmer(
  accuracy ~ initial_study_position_lin * item_type + 
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000)),
  na.action = na.omit
)

cat("✓ Created within-study model (linear only)\n")
check_convergence_issues(m_final_within_study_e3)

m_final_within_test_e3 <- glmer(
  accuracy ~ initial_test_position_lin * item_type + 
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 100000)),
  na.action = na.omit
)

cat("✓ Created within-test model (linear only)\n")
check_convergence_issues(m_final_within_test_e3)

m_final_between_initial_e3 <- glmer(
  accuracy ~ initial_list_number_lin * item_type + initial_list_number_quad * item_type +
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 200000)),
  na.action = na.omit
)

cat("✓ Created between-initial model (2-way interactions)\n")
check_convergence_issues(m_final_between_initial_e3)

m_final_between_final_e3 <- glmer(
  accuracy ~ final_test_position_lin * item_type + final_test_position_quad * item_type +
    (1 | participant_id),
  data = final_e3, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 200000)),
  na.action = na.omit
)

cat("✓ Created between-final model (2-way interactions)\n")
check_convergence_issues(m_final_between_final_e3)

# 5) Summaries (fixed effects)
results_e3 <- list(
  init_studypos = broom.mixed::tidy(m_init_studypos_e3, effects = "fixed", conf.int = TRUE),
  init_testpos = broom.mixed::tidy(m_init_testpos_e3, effects = "fixed", conf.int = TRUE),
  init_between = broom.mixed::tidy(m_init_between_e3, effects = "fixed", conf.int = TRUE),
  final_within_study = broom.mixed::tidy(m_final_within_study_e3, effects = "fixed", conf.int = TRUE),
  final_within_test = broom.mixed::tidy(m_final_within_test_e3, effects = "fixed", conf.int = TRUE),
  final_between_initial = broom.mixed::tidy(m_final_between_initial_e3, effects = "fixed", conf.int = TRUE),
  final_between_final = broom.mixed::tidy(m_final_between_final_e3, effects = "fixed", conf.int = TRUE)
)

# 6) Item-type–specific trends and post-hoc comparisons
trends_e3 <- list(
  # Initial test
  init_studypos_lin   = emtrends(m_init_studypos_e3,   ~ item_type, var = "study_position_lin"),
  init_studypos_quad  = emtrends(m_init_studypos_e3,   ~ item_type, var = "study_position_quad"),
  init_testpos_lin    = emtrends(m_init_testpos_e3,    ~ item_type, var = "test_position_lin"),
  init_testpos_quad   = emtrends(m_init_testpos_e3,    ~ item_type, var = "test_position_quad"),
  init_between_lin    = emtrends(m_init_between_e3,    ~ item_type, var = "list_number_lin"),
  init_between_quad   = emtrends(m_init_between_e3,    ~ item_type, var = "list_number_quad"),

  # Final test (within-list) - LINEAR ONLY
  final_within_study_lin  = emtrends(m_final_within_study_e3, ~ item_type, var = "initial_study_position_lin"),
  final_within_test_lin   = emtrends(m_final_within_test_e3,  ~ item_type, var = "initial_test_position_lin"),

  # Final test (between-list) - QUADRATIC INCLUDED
  final_between_final_lin   = emtrends(m_final_between_final_e3,   ~ item_type, var = "final_test_position_lin"),
  final_between_final_quad  = emtrends(m_final_between_final_e3,   ~ item_type, var = "final_test_position_quad"),
  final_between_initial_lin = emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_lin"),
  final_between_initial_quad= emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_quad")
)

# 7) COMPREHENSIVE POST-HOC TESTS FOR ITEM TYPE COMPARISONS
cat("\n=== COMPREHENSIVE POST-HOC ITEM TYPE COMPARISONS ===\n")

# INITIAL TEST COMPARISONS
cat("\n--- Initial Test Study Position Item Type Comparisons ---\n")
init_studypos_emmeans <- emmeans(m_init_studypos_e3, ~ item_type)
init_studypos_pairs <- pairs(init_studypos_emmeans, adjust = "tukey")
print(init_studypos_pairs)
init_studypos_means <- as.data.frame(init_studypos_emmeans)
print("Initial Study Position - Estimated Marginal Means:")
print(init_studypos_means)

cat("\n--- Initial Test Position Item Type Comparisons ---\n")
init_testpos_emmeans <- emmeans(m_init_testpos_e3, ~ item_type)
init_testpos_pairs <- pairs(init_testpos_emmeans, adjust = "tukey")
print(init_testpos_pairs)
init_testpos_means <- as.data.frame(init_testpos_emmeans)
print("Initial Test Position - Estimated Marginal Means:")
print(init_testpos_means)

cat("\n--- Initial Test Between-List Item Type Comparisons ---\n")
init_between_emmeans <- emmeans(m_init_between_e3, ~ item_type)
init_between_pairs <- pairs(init_between_emmeans, adjust = "tukey")
print(init_between_pairs)
init_between_means <- as.data.frame(init_between_emmeans)
print("Initial Between-List - Estimated Marginal Means:")
print(init_between_means)

# FINAL TEST COMPARISONS
# Check what item types are actually in each model
cat("\n--- Item Types in Each Analysis ---\n")
cat("Final Position Analysis - Item types:\n")
final_position_types <- unique(final_e3$item_type[!is.na(final_e3$final_test_position)])
print(final_position_types)

cat("\nInitial List Analysis - Item types:\n")
initial_list_types <- unique(final_e3$item_type[!is.na(final_e3$initial_list_number)])
print(initial_list_types)

cat("\nWithin-Study Analysis - Item types:\n")
within_study_types <- unique(final_e3$item_type[!is.na(final_e3$initial_study_position)])
print(within_study_types)

cat("\nWithin-Test Analysis - Item types:\n")
within_test_types <- unique(final_e3$item_type[!is.na(final_e3$initial_test_position)])
print(within_test_types)

# Final test between-list models - get estimated marginal means for all item types
cat("\n--- Final Test Between-List (Final Position) Item Type Comparisons ---\n")
final_position_emmeans <- emmeans(m_final_between_final_e3, ~ item_type)
final_position_pairs <- pairs(final_position_emmeans, adjust = "tukey")
print(final_position_pairs)

# Get individual means for final position
final_position_means <- as.data.frame(final_position_emmeans)
print("Final Position - Estimated Marginal Means:")
print(final_position_means)

cat("\n--- Final Test Between-List (Initial List) Item Type Comparisons ---\n")
initial_list_emmeans <- emmeans(m_final_between_initial_e3, ~ item_type)
initial_list_pairs <- pairs(initial_list_emmeans, adjust = "tukey")
print(initial_list_pairs)

# Get individual means for initial list
initial_list_means <- as.data.frame(initial_list_emmeans)
print("Initial List - Estimated Marginal Means:")
print(initial_list_means)

# Within-list models - get estimated marginal means
cat("\n--- Final Test Within-Study Item Type Comparisons ---\n")
within_study_emmeans <- emmeans(m_final_within_study_e3, ~ item_type)
within_study_pairs <- pairs(within_study_emmeans, adjust = "tukey")
print(within_study_pairs)

# Get individual means for within-study
within_study_means <- as.data.frame(within_study_emmeans)
print("Within-Study - Estimated Marginal Means:")
print(within_study_means)

cat("\n--- Final Test Within-Test Item Type Comparisons ---\n")
within_test_emmeans <- emmeans(m_final_within_test_e3, ~ item_type)
within_test_pairs <- pairs(within_test_emmeans, adjust = "tukey")
print(within_test_pairs)

# Get individual means for within-test
within_test_means <- as.data.frame(within_test_emmeans)
print("Within-Test - Estimated Marginal Means:")
print(within_test_means)

# Add these to trends for saving
# Initial test pairwise comparisons
trends_e3$init_studypos_emmeans <- init_studypos_emmeans
trends_e3$init_studypos_pairs <- init_studypos_pairs
trends_e3$init_testpos_emmeans <- init_testpos_emmeans
trends_e3$init_testpos_pairs <- init_testpos_pairs
trends_e3$init_between_emmeans <- init_between_emmeans
trends_e3$init_between_pairs <- init_between_pairs

# Final test pairwise comparisons
trends_e3$final_position_emmeans <- final_position_emmeans
trends_e3$final_position_pairs <- final_position_pairs
trends_e3$initial_list_emmeans <- initial_list_emmeans
trends_e3$initial_list_pairs <- initial_list_pairs
trends_e3$within_study_emmeans <- within_study_emmeans
trends_e3$within_study_pairs <- within_study_pairs
trends_e3$within_test_emmeans <- within_test_emmeans
trends_e3$within_test_pairs <- within_test_pairs

# 8) LINEAR AND QUADRATIC TREND SIGNIFICANCE TESTS
cat("\n=== LINEAR AND QUADRATIC TREND SIGNIFICANCE ===\n")

# Final Position Analysis - Linear and Quadratic Trends
cat("\n--- Final Position Analysis - Position Trends ---\n")
final_position_lin_trend <- emtrends(m_final_between_final_e3, ~ item_type, var = "final_test_position_lin")
final_position_quad_trend <- emtrends(m_final_between_final_e3, ~ item_type, var = "final_test_position_quad")
print("Linear Trends:")
print(final_position_lin_trend)
print("Quadratic Trends:")
print(final_position_quad_trend)

# Initial List Analysis - Linear and Quadratic Trends
cat("\n--- Initial List Analysis - Position Trends ---\n")
initial_list_lin_trend <- emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_lin")
initial_list_quad_trend <- emtrends(m_final_between_initial_e3, ~ item_type, var = "initial_list_number_quad")
print("Linear Trends:")
print(initial_list_lin_trend)
print("Quadratic Trends:")
print(initial_list_quad_trend)

# Within-Study Analysis - Linear Trends Only
cat("\n--- Within-Study Analysis - Linear Trends ---\n")
within_study_lin_trend <- emtrends(m_final_within_study_e3, ~ item_type, var = "initial_study_position_lin")
print("Linear Trends:")
print(within_study_lin_trend)

# Within-Test Analysis - Linear Trends Only
cat("\n--- Within-Test Analysis - Linear Trends ---\n")
within_test_lin_trend <- emtrends(m_final_within_test_e3, ~ item_type, var = "initial_test_position_lin")
print("Linear Trends:")
print(within_test_lin_trend)

cat("\n=== END TREND SIGNIFICANCE TESTS ===\n")

# Convert emtrends results to data frames safely
trends_e3_df <- lapply(trends_e3, function(x) tryCatch(as.data.frame(x), error = function(e) NULL))

# 9) Save comprehensive results
saveRDS(
  list(
    models = list(
      m_init_studypos_e3 = m_init_studypos_e3,
      m_init_testpos_e3 = m_init_testpos_e3,
      m_init_between_e3 = m_init_between_e3,
      m_final_within_study_e3 = m_final_within_study_e3,
      m_final_within_test_e3 = m_final_within_test_e3,
      m_final_between_initial_e3 = m_final_between_initial_e3,
      m_final_between_final_e3 = m_final_between_final_e3
    ),
    summaries = results_e3,
    trends    = trends_e3_df
  ),
  "experiment3_glmm_results.rds"
)

# Also export flat CSV for reporting
bind_rows(
  results_e3$init_studypos %>% mutate(model = "init_studypos"),
  results_e3$init_testpos %>% mutate(model = "init_testpos"),
  results_e3$init_between %>% mutate(model = "init_between"),
  results_e3$final_within_study %>% mutate(model = "final_within_study"),
  results_e3$final_within_test %>% mutate(model = "final_within_test"),
  results_e3$final_between_initial %>% mutate(model = "final_between_initial"),
  results_e3$final_between_final %>% mutate(model = "final_between_final")
) %>%
  write_csv("experiment3_model_summaries.csv")

# Tidy & save item-type trends (if any computed)
compact_trends_e3 <- purrr::imap_dfr(trends_e3_df, ~{
  if (is.null(.x)) return(NULL)
  as_tibble(.x) %>% mutate(contrast = .y)
})
if (nrow(compact_trends_e3) > 0) write_csv(compact_trends_e3, "experiment3_itemtype_trends.csv")

cat("\nExperiment 3 analysis complete. Results saved to:\n")
cat("Saved: experiment3_glmm_results.rds\n")
cat("Saved: experiment3_model_summaries.csv\n")
if (exists("compact_trends_e3") && nrow(compact_trends_e3) > 0) cat("Saved: experiment3_itemtype_trends.csv\n")