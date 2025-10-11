# ================================
# GLMMs with item-type-specific trends (interactions)
# ================================
library(tidyverse)
library(lme4)
library(broom.mixed)
library(emmeans)
library(dplyr)
library(readr)
library(purrr)
library(stringr)
library(broom.mixed)
library(emmeans)

# 0) Load
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# 1) Helper: safe poly (always returns *_lin, *_quad)
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  # Preserve NAs instead of imputing - models will handle them
  if (all(is.na(v))) {
    out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
    return(out)
  }
  
  # Center but don't scale - preserves original units
  v_center <- v - mean(v, na.rm = TRUE)
  
  # Handle special cases
  unique_vals <- unique(na.omit(v_center))
  n_unique <- length(unique_vals)
  
  if (n_unique < 2) {
    # Constant variable - return zeros
    out <- data.frame(lin = rep(0, length(v)), quad = rep(0, length(v)))
  } else if (n_unique == 2) {
    # Binary variable - use contrast coding
    lin <- as.integer(v_center == unique_vals[2])
    out <- data.frame(lin = lin, quad = rep(0, length(v)))
  } else {
    # Continuous variable - use orthogonal polynomials
    # Handle NAs by computing polynomials only on non-NA values
    nona_idx <- !is.na(v_center)
    if (sum(nona_idx) < 3) {
      # Not enough non-NA values for polynomial
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
  
  # Set proper column names
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

# 2) Initial test 
# Prepare initial test data
initial <- dfchanged %>%
  filter(task == "pretest_response", response != "null") %>%
  mutate(
    participant_id = factor(PROLIFIC_PID),
    accuracy = as.numeric(correct),
    study_position = as.numeric(prespos),
    test_position  = as.numeric(testpos),
    list_number    = as.numeric(trialnum),
    item_type = case_when(
      probetype == "TARGET_target" ~ "target",
      probetype == "TARGET_foil"   ~ "foil",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(item_type = factor(item_type, levels = c("foil","target"))) %>%
  filter(!is.na(participant_id), !is.na(item_type)) %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "list_number"))

cat("Initial test data prepared:", nrow(initial), "trials\n")

# Validate position data
validate_position_data(initial, "study_position")
validate_position_data(initial, "test_position")

# 3) Final test (trial-level)
# ------------------
# First, create the initial position data like in the reference file
df_initial <- dfchanged %>%
  filter(task == "pretest_response") %>%
  pivot_longer(cols = c(testpos, prespos), names_to = "position_type", values_to = "position") %>%
  select(position, ip, position_type, stimulus_id)

wordlists_intest <- dfchanged %>%
  filter(task == "pretest_response") %>%
  group_by(ip) %>%
  summarize(words = list(stimulus_id))

df_initial_study <- dfchanged %>%
  filter(task == "pretest_study") %>%
  left_join(wordlists_intest, by = "ip") %>%
  rowwise() %>%
  filter(!(stimulus_id %in% unlist(words))) %>% # here get study only
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

# Create a lookup table with both study and test positions for each item
initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Now create the final test data with correct initial positions
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  select(ip, correct, probetype, stimulus_id, testpos, trialnum, prespos_itrial, condition) %>%
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  mutate(
    participant_id = factor(ip),
    accuracy = as.numeric(correct),
    # define item types
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO",
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    ),
    # Within-list positions from initial test data
    study_position = case_when(item_type %in% c("ST","SO") ~ as.numeric(initial_prespos),
                               TRUE ~ NA_real_),
    test_position  = case_when(item_type %in% c("ST","TO") ~ as.numeric(initial_testpos),
                               TRUE ~ NA_real_),
    # Between-list positions (using final test positions) - ALL item types
    final_order    = as.numeric(cut_number(as.numeric(testpos), 10, labels = 1:10)),
    initial_order  = as.numeric(prespos_itrial)
  ) %>%
  # Remove rows where we couldn't determine positions
  filter(!is.na(study_position) | !is.na(test_position) | !is.na(final_order) | !is.na(initial_order)) %>%
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition)

# ------------------
# Add polynomial terms
# ------------------
final <- final %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "final_order")) %>%
  bind_cols(create_polynomial_terms(., "initial_order"))

# Validate final test position data
validate_position_data(final, "study_position")
validate_position_data(final, "test_position")
validate_position_data(final, "final_order")
validate_position_data(final, "initial_order")

# 4) Models (random intercepts; item-type-specific trends via interactions)
# Initial: Study Position × Item Type
# m_init_studypos <- glmer(
#   accuracy ~ (study_position_lin + study_position_quad) * item_type +
#     (1 | participant_id) + (0 + study_position_lin | participant_id),
#   data = initial, family = binomial,
#   control = glmerControl(optimizer = "bobyqa"),
#   na.action = na.omit
# )

# # Check convergence for initial study position model
# cat("\n=== Initial Study Position Model ===\n")
# check_convergence_issues(m_init_studypos)

# # Initial: Test Position × Item Type
# m_init_testpos <- glmer(
#   accuracy ~ (test_position_lin + test_position_quad) * item_type +
#     (1 | participant_id) + (0 + test_position_lin | participant_id),
#   data = initial, family = binomial,
#   control = glmerControl(optimizer = "bobyqa"),
#   na.action = na.omit
# )

# # Check convergence for initial test position model
# cat("\n=== Initial Test Position Model ===\n")
# check_convergence_issues(m_init_testpos)

# # Initial: Between-List (List Index) × Item Type
# m_init_between <- glmer(
#   accuracy ~ (list_number_lin + list_number_quad) * item_type +
#     (1 | participant_id) + (0 + list_number_lin | participant_id),
#   data = initial, family = binomial,
#   control = glmerControl(optimizer = "bobyqa"),
#   na.action = na.omit
# )

# # Check convergence for initial between-list model
# cat("\n=== Initial Between-List Model ===\n")
# check_convergence_issues(m_init_between)

# # REMOVED COMPLEX MODELS - USING SIMPLIFIED MODELS ONLY

# # ------------------
# # FINAL TEST MODELS (SIMPLIFIED ONLY)
# # ------------------
# cat("\n=== CREATING FINAL TEST MODELS ===\n")

# Final Within-Study Model (linear and quadratic, no condition)
m_final_within_study <- glmer(
  accuracy ~ study_position_lin * item_type + study_position_quad * item_type +  # Linear and quadratic
    (1 | participant_id),                                                         # Random intercept only
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
  na.action = na.omit
)

cat("✓ Created within-study model (linear and quadratic)\n")
check_convergence_issues(m_final_within_study)

# Final Within-Test Model (linear and quadratic, no condition)
m_final_within_test <- glmer(
  accuracy ~ test_position_lin * item_type + test_position_quad * item_type +  # Linear and quadratic
    (1 | participant_id),                                                       # Random intercept only
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
  na.action = na.omit
)

cat("✓ Created within-test model (linear and quadratic)\n")
check_convergence_issues(m_final_within_test)

# Final Between-Final Model (with proper condition interactions)
# m_between_final <- glmer(
#   accuracy ~ final_order_lin * item_type * condition + final_order_quad * item_type * condition +  # Full 3-way interactions
#     (1 | participant_id),                                                    # Random intercept only
#   data = final, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# cat("✓ Created between-final model (3-way interactions)\n")
# check_convergence_issues(m_between_final)

# # Final Between-Initial Model (with proper condition interactions)
# m_between_initial <- glmer(
#   accuracy ~ initial_order_lin * item_type * condition + initial_order_quad * item_type * condition +  # Full 3-way interactions
#     (1 | participant_id),                                                       # Random intercept only
#   data = final, family = binomial,
#   control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 500000)),
#   na.action = na.omit
# )

# cat("✓ Created between-initial model (3-way interactions)\n")
# check_convergence_issues(m_between_initial)

# REMOVED MODEL COMPARISONS - USING SIMPLIFIED MODELS ONLY

# m_final_within_study <- glmer(
#   accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
#     (1 + study_position_lin + study_position_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )


# # Within-list: Test Position
# m_final_within_test <- glmer(
#   accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
#     (1 + test_position_lin + test_position_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )

# # Between-list: Final Order
# m_between_final <- glmer(
#   accuracy ~ final_order_lin * item_type + final_order_quad * item_type +
#     (1 + final_order_lin + final_order_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )

# # Between-list: Initial Order
# m_between_initial <- glmer(
#   accuracy ~ initial_order_lin * item_type + initial_order_quad * item_type +
#     (1 + initial_order_lin + initial_order_quad || participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa")
# )



###################################################33

# # Within-list: Study Position
# m_final_within_study <- glmer(
#   accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
#     (1 | participant_id) + (0 + study_position_lin | participant_id) + (0 + study_position_quad | participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
#   na.action = na.omit
# )

# # Within-list: Test Position
# m_final_within_test <- glmer(
#   accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
#     (1 | participant_id) + (0 + test_position_lin | participant_id) + (0 + test_position_quad | participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
#   na.action = na.omit
# )

# # Between-list: Final Order
# m_between_final <- glmer(
#   accuracy ~ final_order_lin * item_type + final_order_quad * item_type +
#     (1 | participant_id) + (0 + final_order_lin | participant_id) + (0 + final_order_quad | participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
#   na.action = na.omit
# )

# # Between-list: Initial Order
# m_between_initial <- glmer(
#   accuracy ~ initial_order_lin * item_type + initial_order_quad * item_type +
#     (1 | participant_id) + (0 + initial_order_lin | participant_id) + (0 + initial_order_quad | participant_id),
#   data = final, family = binomial, control = glmerControl(optimizer="bobyqa"),
#   na.action = na.omit
# )
# Final: Test Chunk (same as test_position model; kept for symmetry if you use chunking)
# m_final_testchunk <- m_final_testpos

# REMOVED DIAGNOSTIC ANALYSIS - USING SIMPLIFIED MODELS ONLY

# REMOVED COMPLEX CONVERGENCE CHECK - USING SIMPLIFIED MODELS ONLY

# ------------------
# 5) Summaries (fixed effects)
# ------------------
results <- list(
  # Initial test models
  # init_studypos        = broom.mixed::tidy(m_init_studypos,        effects = "fixed", conf.int = TRUE),
  # init_testpos         = broom.mixed::tidy(m_init_testpos,         effects = "fixed", conf.int = TRUE),
  # init_between         = broom.mixed::tidy(m_init_between,         effects = "fixed", conf.int = TRUE),
  
  # Final test models - within-list
  final_within_study   = broom.mixed::tidy(m_final_within_study,   effects = "fixed", conf.int = TRUE),
  final_within_test    = broom.mixed::tidy(m_final_within_test,    effects = "fixed", conf.int = TRUE)
  # final_between_final  = broom.mixed::tidy(m_between_final,        effects = "fixed", conf.int = TRUE),
  # final_between_initial= broom.mixed::tidy(m_between_initial,      effects = "fixed", conf.int = TRUE)
)

# ------------------
# 6) Item-type–specific trends and post-hoc comparisons
# ------------------
trends <- list(
  # Initial test
  # init_studypos_lin   = emtrends(m_init_studypos,   ~ item_type, var = "study_position_lin"),
  # init_studypos_quad  = emtrends(m_init_studypos,   ~ item_type, var = "study_position_quad"),
  # init_testpos_lin    = emtrends(m_init_testpos,    ~ item_type, var = "test_position_lin"),
  # init_testpos_quad   = emtrends(m_init_testpos,    ~ item_type, var = "test_position_quad"),
  # init_between_lin    = emtrends(m_init_between,    ~ item_type, var = "list_number_lin"),
  # init_between_quad   = emtrends(m_init_between,    ~ item_type, var = "list_number_quad"),

  # Final test (within-list) - LINEAR AND QUADRATIC
  final_within_study_lin  = emtrends(m_final_within_study, ~ item_type, var = "study_position_lin"),
  final_within_study_quad = emtrends(m_final_within_study, ~ item_type, var = "study_position_quad"),
  final_within_test_lin   = emtrends(m_final_within_test,  ~ item_type, var = "test_position_lin"),
  final_within_test_quad  = emtrends(m_final_within_test,  ~ item_type, var = "test_position_quad")

  # Final test (between-list) - QUADRATIC INCLUDED
  # final_between_final_lin   = emtrends(m_between_final,   ~ item_type, var = "final_order_lin"),
  # final_between_final_quad  = emtrends(m_between_final,   ~ item_type, var = "final_order_quad")
  # final_between_initial_lin = emtrends(m_between_initial, ~ item_type, var = "initial_order_lin"),
  # final_between_initial_quad= emtrends(m_between_initial, ~ item_type, var = "initial_order_quad")
)

# ------------------
# 7) COMPREHENSIVE POST-HOC TESTS FOR ITEM TYPE COMPARISONS
# ------------------
cat("\n=== COMPREHENSIVE POST-HOC ITEM TYPE COMPARISONS ===\n")

# INITIAL TEST COMPARISONS
# cat("\n--- Initial Test Study Position Item Type Comparisons ---\n")
# init_studypos_emmeans <- emmeans(m_init_studypos, ~ item_type)
# init_studypos_pairs <- pairs(init_studypos_emmeans, adjust = "tukey")
# print(init_studypos_pairs)
# init_studypos_means <- as.data.frame(init_studypos_emmeans)
# print("Initial Study Position - Estimated Marginal Means:")
# print(init_studypos_means)

# cat("\n--- Initial Test Position Item Type Comparisons ---\n")
# init_testpos_emmeans <- emmeans(m_init_testpos, ~ item_type)
# init_testpos_pairs <- pairs(init_testpos_emmeans, adjust = "tukey")
# print(init_testpos_pairs)
# init_testpos_means <- as.data.frame(init_testpos_emmeans)
# print("Initial Test Position - Estimated Marginal Means:")
# print(init_testpos_means)

# cat("\n--- Initial Test Between-List Item Type Comparisons ---\n")
# init_between_emmeans <- emmeans(m_init_between, ~ item_type)
# init_between_pairs <- pairs(init_between_emmeans, adjust = "tukey")
# print(init_between_pairs)
# init_between_means <- as.data.frame(init_between_emmeans)
# print("Initial Between-List - Estimated Marginal Means:")
# print(init_between_means)

# FINAL TEST COMPARISONS
# Check what item types are actually in each model
cat("\n--- Item Types in Each Analysis ---\n")
cat("Within-Study Analysis - Item types:\n")
within_study_types <- unique(final$item_type[!is.na(final$study_position)])
print(within_study_types)

cat("\nWithin-Test Analysis - Item types:\n")
within_test_types <- unique(final$item_type[!is.na(final$test_position)])
print(within_test_types)

# cat("Final Order Analysis - Item types:\n")
# final_order_types <- unique(final$item_type[!is.na(final$final_order)])
# print(final_order_types)

# cat("\nInitial Order Analysis - Item types:\n")
# initial_order_types <- unique(final$item_type[!is.na(final$initial_order)])
# print(initial_order_types)

# Final test within-list models - get estimated marginal means for all item types
cat("\n--- Final Test Within-Study Item Type Comparisons ---\n")
within_study_emmeans <- emmeans(m_final_within_study, ~ item_type)
within_study_pairs <- pairs(within_study_emmeans, adjust = "tukey")
print(within_study_pairs)

# Get individual means for within-study
within_study_means <- as.data.frame(within_study_emmeans)
print("Within-Study - Estimated Marginal Means:")
print(within_study_means)

cat("\n--- Final Test Within-Test Item Type Comparisons ---\n")
within_test_emmeans <- emmeans(m_final_within_test, ~ item_type)
within_test_pairs <- pairs(within_test_emmeans, adjust = "tukey")
print(within_test_pairs)

# Get individual means for within-test
within_test_means <- as.data.frame(within_test_emmeans)
print("Within-Test - Estimated Marginal Means:")
print(within_test_means)

# cat("\n--- Final Test Between-List (Initial Order) Item Type Comparisons ---\n")
# initial_order_emmeans <- emmeans(m_between_initial, ~ item_type)
# initial_order_pairs <- pairs(initial_order_emmeans, adjust = "tukey")
# print(initial_order_pairs)

# Get individual means for initial order
# initial_order_means <- as.data.frame(initial_order_emmeans)
# print("Initial Order - Estimated Marginal Means:")
# print(initial_order_means)

# cat("\n--- Final Test Between-List (Final Order) Item Type Comparisons ---\n")
# final_order_emmeans <- emmeans(m_between_final, ~ item_type)
# final_order_pairs <- pairs(final_order_emmeans, adjust = "tukey")
# print(final_order_pairs)

# Get individual means for final order
# final_order_means <- as.data.frame(final_order_emmeans)
# print("Final Order - Estimated Marginal Means:")
# print(final_order_means)

# Add these to trends for saving
# Initial test pairwise comparisons
# trends$init_studypos_emmeans <- init_studypos_emmeans
# trends$init_studypos_pairs <- init_studypos_pairs
# trends$init_testpos_emmeans <- init_testpos_emmeans
# trends$init_testpos_pairs <- init_testpos_pairs
# trends$init_between_emmeans <- init_between_emmeans
# trends$init_between_pairs <- init_between_pairs

# Final test pairwise comparisons - within-list
trends$within_study_emmeans <- within_study_emmeans
trends$within_study_pairs <- within_study_pairs
trends$within_test_emmeans <- within_test_emmeans
trends$within_test_pairs <- within_test_pairs
# trends$final_order_emmeans <- final_order_emmeans
# trends$final_order_pairs <- final_order_pairs
# trends$initial_order_emmeans <- initial_order_emmeans
# trends$initial_order_pairs <- initial_order_pairs

# ------------------
# 8) LINEAR AND QUADRATIC TREND SIGNIFICANCE TESTS
# ------------------
cat("\n=== LINEAR AND QUADRATIC TREND SIGNIFICANCE ===\n")

# Within-Study Analysis - Linear and Quadratic Trends
cat("\n--- Within-Study Analysis - Position Trends ---\n")
within_study_lin_trend <- emtrends(m_final_within_study, ~ item_type, var = "study_position_lin")
within_study_quad_trend <- emtrends(m_final_within_study, ~ item_type, var = "study_position_quad")
print("Linear Trends:")
print(within_study_lin_trend)
print("Quadratic Trends:")
print(within_study_quad_trend)

# Within-Test Analysis - Linear and Quadratic Trends
cat("\n--- Within-Test Analysis - Position Trends ---\n")
within_test_lin_trend <- emtrends(m_final_within_test, ~ item_type, var = "test_position_lin")
within_test_quad_trend <- emtrends(m_final_within_test, ~ item_type, var = "test_position_quad")
print("Linear Trends:")
print(within_test_lin_trend)
print("Quadratic Trends:")
print(within_test_quad_trend)

# Final Order Analysis - Linear and Quadratic Trends
# cat("\n--- Final Order Analysis - Position Trends ---\n")
# final_order_lin_trend <- emtrends(m_between_final, ~ item_type, var = "final_order_lin")
# final_order_quad_trend <- emtrends(m_between_final, ~ item_type, var = "final_order_quad")
# print("Linear Trends:")
# print(final_order_lin_trend)
# print("Quadratic Trends:")
# print(final_order_quad_trend)

# Initial Order Analysis - Linear and Quadratic Trends
# cat("\n--- Initial Order Analysis - Position Trends ---\n")
# initial_order_lin_trend <- emtrends(m_between_initial, ~ item_type, var = "initial_order_lin")
# initial_order_quad_trend <- emtrends(m_between_initial, ~ item_type, var = "initial_order_quad")
# print("Linear Trends:")
# print(initial_order_lin_trend)
# print("Quadratic Trends:")
# print(initial_order_quad_trend)

cat("\n=== END TREND SIGNIFICANCE TESTS ===\n")

# ------------------
# 9) CONDITION × POSITION INTERACTION ANALYSIS
# ------------------
# NOTE: Within-list models do not include condition interactions
# Uncomment this section when using between-list models with condition

# cat("\n=== CONDITION × POSITION INTERACTION ANALYSIS ===\n")

# # Test whether conditions show different OI patterns
# cat("\n--- Testing Condition × Final Order Interactions ---\n")

# # Get condition-specific trends for final order
# final_order_condition_lin <- emtrends(m_between_final, ~ condition | item_type, var = "final_order_lin")
# final_order_condition_quad <- emtrends(m_between_final, ~ condition | item_type, var = "final_order_quad")

# print("Linear Trends by Condition and Item Type:")
# print(final_order_condition_lin)

# print("Quadratic Trends by Condition and Item Type:")
# print(final_order_condition_quad)

# # Test pairwise differences between conditions for each item type
# cat("\n--- Pairwise Comparisons of Condition Effects ---\n")
# final_order_condition_pairs_lin <- pairs(final_order_condition_lin, by = "item_type", adjust = "tukey")
# final_order_condition_pairs_quad <- pairs(final_order_condition_quad, by = "item_type", adjust = "tukey")

# print("Linear Trend Differences Between Conditions (by Item Type):")
# print(final_order_condition_pairs_lin)

# print("Quadratic Trend Differences Between Conditions (by Item Type):")
# print(final_order_condition_pairs_quad)

# # Test whether conditions show different OI patterns for initial order
# cat("\n--- Testing Condition × Initial Order Interactions ---\n")

# initial_order_condition_lin <- emtrends(m_between_initial, ~ condition | item_type, var = "initial_order_lin")
# initial_order_condition_quad <- emtrends(m_between_initial, ~ condition | item_type, var = "initial_order_quad")

# print("Initial Order Linear Trends by Condition and Item Type:")
# print(initial_order_condition_lin)

# print("Initial Order Quadratic Trends by Condition and Item Type:")
# print(initial_order_condition_quad)

# # Add these to trends for saving
# trends$final_order_condition_lin <- final_order_condition_lin
# trends$final_order_condition_quad <- final_order_condition_quad
# trends$final_order_condition_pairs_lin <- final_order_condition_pairs_lin
# trends$final_order_condition_pairs_quad <- final_order_condition_pairs_quad
# trends$initial_order_condition_lin <- initial_order_condition_lin
# trends$initial_order_condition_quad <- initial_order_condition_quad

# cat("\n=== END CONDITION × POSITION INTERACTION ANALYSIS ===\n")

# Convert emtrends results to data frames safely
trends_df <- lapply(trends, function(x) tryCatch(as.data.frame(x), error = function(e) NULL))

# ------------------
# 8) Save
# ------------------
saveRDS(
  list(
    models = list(
      # m_init_studypos       = m_init_studypos,
      # m_init_testpos        = m_init_testpos,
      # m_init_between        = m_init_between,
      m_final_within_study  = m_final_within_study,
      m_final_within_test   = m_final_within_test
      # m_between_final       = m_between_final,
      # m_between_initial     = m_between_initial
    ),
    summaries = results,
    trends    = trends_df
  ),
  "experiment1_glmm_within_list_models.rds"
)

# Also export flat CSV for reporting
bind_rows(
  # Initial test models
  # results$init_studypos          %>% mutate(model = "init_studypos"),
  # results$init_testpos           %>% mutate(model = "init_testpos"),
  # results$init_between           %>% mutate(model = "init_between"),
  
  # Final test models - within-list
  results$final_within_study     %>% mutate(model = "final_within_study"),
  results$final_within_test      %>% mutate(model = "final_within_test")
  # results$final_between_final    %>% mutate(model = "final_between_final"),
  # results$final_between_initial  %>% mutate(model = "final_between_initial")
) %>%
  write_csv("all_model_summaries_within_list.csv")

# Tidy & save item-type trends (if any computed)
compact_trends <- purrr::imap_dfr(trends_df, ~{
  if (is.null(.x)) return(NULL)
  as_tibble(.x) %>% mutate(contrast = .y)
})
if (nrow(compact_trends) > 0) write_csv(compact_trends, "all_itemtype_trends_within_list.csv")

cat("Saved: experiment1_glmm_within_list_models.rds\n")
cat("Saved: all_model_summaries_within_list.csv\n")
if (exists("compact_trends") && nrow(compact_trends) > 0) cat("Saved: all_itemtype_trends_within_list.csv\n")
