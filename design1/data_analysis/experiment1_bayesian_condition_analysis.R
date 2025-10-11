# ================================
# Bayesian GLMM Analysis for Condition Effects
# Focus: Final Test Between-List by Final Order
# ================================
library(tidyverse)
library(brms)
library(emmeans)
library(bayestestR)
library(dplyr)
library(readr)

# Load data
dfchanged <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis/dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# ================================
# Helper Functions (Same as original)
# ================================
create_polynomial_terms <- function(data, var_name) {
  v <- suppressWarnings(as.numeric(data[[var_name]]))
  
#   If the entire variable is missing, return NAs for both linear and quadratic terms
  if (all(is.na(v))) {
    out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    names(out) <- c(paste0(var_name, "_lin"), paste0(var_name, "_quad"))
    return(out)
  }
  

  v_center <- v - mean(v, na.rm = TRUE)   # : Center the Data
  unique_vals <- unique(na.omit(v_center)) #Check How Many Unique Values

  n_unique <- length(unique_vals)
  
  if (n_unique < 2) { #Handle Constant Variables (n_unique < 2)， If all values are the same, return zeros
    out <- data.frame(lin = rep(0, length(v)), quad = rep(0, length(v)))
  } else if (n_unique == 2) { #Handle Binary Variables (n_unique == 2)， If there are only two unique values, return a binary variable
    lin <- as.integer(v_center == unique_vals[2])
    out <- data.frame(lin = lin, quad = rep(0, length(v)))
  } else { #Handle Non-Binary Variables (n_unique > 2)， If there are more than two unique values, return a polynomial variable
    nona_idx <- !is.na(v_center)
    if (sum(nona_idx) < 3) { #Handle Missing Values (sum(nona_idx) < 3)， If there are less than three non-missing values, return NAs
      out <- data.frame(lin = rep(NA, length(v)), quad = rep(NA, length(v)))
    } else {
      poly_res <- poly(v_center[nona_idx], degree = 2, raw = FALSE, simple = TRUE) #Generate Polynomial Terms
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

# ================================
# Data Preparation
# ================================
cat("\n=== PREPARING FINAL TEST DATA ===\n")

# Create initial position data
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
  filter(!(stimulus_id %in% unlist(words))) %>%
  mutate(position = prespos, position_type = "prespos") %>%
  select(position, position_type, ip, stimulus_id)

df_initial_all <- rbind(df_initial, df_initial_study)

initial_positions <- df_initial_all %>%
  pivot_wider(names_from = position_type, values_from = position, names_prefix = "initial_") %>%
  select(ip, stimulus_id, initial_prespos, initial_testpos)

# Create final test data
final <- dfchanged %>%
  filter(task == "finalt_response", response != "null") %>%
  select(ip, correct, probetype, stimulus_id, testpos, trialnum, prespos_itrial, condition) %>%
  left_join(initial_positions, by = c("ip", "stimulus_id")) %>%
  mutate(
    participant_id = factor(ip),
    accuracy = as.numeric(correct),
    item_type = case_when(
      probetype == "TARGET_target"    ~ "ST",
      probetype == "TARGET_nontarget" ~ "SO", 
      probetype == "TARGET_foil"      ~ "TO",
      probetype == "FOIL"             ~ "foil",
      TRUE ~ NA_character_
    ),
    study_position = case_when(item_type %in% c("ST","SO") ~ as.numeric(initial_prespos),
                               TRUE ~ NA_real_),
    test_position  = case_when(item_type %in% c("ST","TO") ~ as.numeric(initial_testpos),
                               TRUE ~ NA_real_),
    final_order    = as.numeric(cut_number(as.numeric(testpos), 10, labels = 1:10)),
    initial_order  = as.numeric(prespos_itrial)
  ) %>%
  filter(!is.na(study_position) | !is.na(test_position) | !is.na(final_order) | !is.na(initial_order)) %>%
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition)

# Add polynomial terms
final <- final %>%
  bind_cols(create_polynomial_terms(., "final_order"))

cat("Final test data prepared:", nrow(final), "trials\n")
cat("Participants:", length(unique(final$participant_id)), "\n")
cat("Item types:", unique(final$item_type), "\n")
cat("Conditions:", unique(final$condition), "\n")

# ================================
# Bayesian GLMM Models
# ================================
cat("\n=== FITTING BAYESIAN MODELS ===\n")

# Set priors for better convergence
priors <- c(
  prior(normal(0, 1), class = "b"),  # Fixed effects
  prior(exponential(1), class = "sd"),  # Random effects
  prior(lkj(2), class = "cor")  # Correlation matrix
)

# Model 1: Full 3-way interactions with random slopes
cat("\n--- Fitting Model 1: Full 3-way interactions with random slopes ---\n")
m_bayes_full <- brm(
  accuracy ~ final_order_lin * item_type * condition + 
             final_order_quad * item_type * condition +
             (1 + final_order_lin | participant_id),
  data = final,
  family = bernoulli(),
  prior = priors,
  cores = 4,  # Use multiple cores
  chains = 2,  # Fewer chains for speed
  iter = 2000,  # Moderate iterations
  warmup = 1000,
  control = list(adapt_delta = 0.95, max_treedepth = 12),
  seed = 123,
  file = "bayesian_model_full.rds"
)

cat("✓ Model 1 fitted successfully\n")

# Model 2: Simplified with separate 2-way interactions (faster)
cat("\n--- Fitting Model 2: Separate 2-way interactions ---\n")
m_bayes_simple <- brm(
  accuracy ~ final_order_lin * item_type + 
             final_order_lin * condition +
             final_order_quad * item_type + 
             final_order_quad * condition +
             (1 + final_order_lin | participant_id),
  data = final,
  family = bernoulli(),
  prior = priors,
  cores = 4,
  chains = 2,
  iter = 2000,
  warmup = 1000,
  control = list(adapt_delta = 0.95),
  seed = 123,
  file = "bayesian_model_simple.rds"
)

cat("✓ Model 2 fitted successfully\n")

# ================================
# Model Diagnostics
# ================================
cat("\n=== MODEL DIAGNOSTICS ===\n")

# Check convergence
cat("\n--- Model 1 (Full) Diagnostics ---\n")
print(summary(m_bayes_full))
cat("Rhat values (should be < 1.01):\n")
print(rhat(m_bayes_full))

cat("\n--- Model 2 (Simple) Diagnostics ---\n")
print(summary(m_bayes_simple))
cat("Rhat values (should be < 1.01):\n")
print(rhat(m_bayes_simple))

# ================================
# Condition Effects Analysis
# ================================
cat("\n=== CONDITION EFFECTS ANALYSIS ===\n")

# Use the simpler model for analysis (better convergence)
model_to_use <- m_bayes_simple

# 1. Main effects
cat("\n--- Main Effects ---\n")
main_effects <- summary(model_to_use)$fixed
print(main_effects)

# 2. Condition-specific trends
cat("\n--- Condition-Specific Linear Trends ---\n")
condition_lin_trends <- emtrends(model_to_use, ~ condition | item_type, var = "final_order_lin")
print(condition_lin_trends)

cat("\n--- Condition-Specific Quadratic Trends ---\n")
condition_quad_trends <- emtrends(model_to_use, ~ condition | item_type, var = "final_order_quad")
print(condition_quad_trends)

# 3. Pairwise comparisons
cat("\n--- Pairwise Comparisons: Linear Trends ---\n")
condition_pairs_lin <- pairs(condition_lin_trends, by = "item_type")
print(condition_pairs_lin)

cat("\n--- Pairwise Comparisons: Quadratic Trends ---\n")
condition_pairs_quad <- pairs(condition_quad_trends, by = "item_type")
print(condition_pairs_quad)

# 4. Bayesian credible intervals
cat("\n--- Bayesian Credible Intervals for Condition Effects ---\n")
condition_effects <- emmeans(model_to_use, ~ condition | item_type)
print(condition_effects)

# ================================
# Bayesian Specific Analysis
# ================================
cat("\n=== BAYESIAN SPECIFIC ANALYSIS ===\n")

# Probability of direction (Bayesian equivalent of p-values)
cat("\n--- Probability of Direction for Condition Effects ---\n")
condition_direction <- p_direction(model_to_use)
print(condition_direction)

# Effect sizes (Cohen's d equivalent)
cat("\n--- Effect Sizes for Condition Effects ---\n")
condition_effectsize <- effectsize(model_to_use)
print(condition_effectsize)

# ================================
# Results Summary
# ================================
cat("\n=== RESULTS SUMMARY ===\n")

cat("\nKey Findings:\n")
cat("1. Check Rhat values - all should be < 1.01 for good convergence\n")
cat("2. Look at condition-specific trends to see if B, F, R differ\n")
cat("3. Check pairwise comparisons for specific condition differences\n")
cat("4. Probability of direction shows Bayesian 'significance'\n")
cat("5. Effect sizes show practical significance\n")

# ================================
# Save Results
# ================================
cat("\n=== SAVING RESULTS ===\n")

# Save model objects
saveRDS(m_bayes_full, "bayesian_model_full.rds")
saveRDS(m_bayes_simple, "bayesian_model_simple.rds")

# Save analysis results
results_bayesian <- list(
  model_full = m_bayes_full,
  model_simple = m_bayes_simple,
  main_effects = main_effects,
  condition_lin_trends = condition_lin_trends,
  condition_quad_trends = condition_quad_trends,
  condition_pairs_lin = condition_pairs_lin,
  condition_pairs_quad = condition_pairs_quad,
  condition_effects = condition_effects,
  condition_direction = condition_direction,
  condition_effectsize = condition_effectsize
)

saveRDS(results_bayesian, "bayesian_condition_analysis_results.rds")

cat("✓ All results saved\n")
cat("✓ Bayesian analysis complete!\n")

# ================================
# Quick Interpretation Guide
# ================================
cat("\n=== INTERPRETATION GUIDE ===\n")
cat("1. Rhat < 1.01: Good convergence\n")
cat("2. Probability of direction > 0.95: Strong evidence for effect\n")
cat("3. Credible intervals not containing 0: Effect is credible\n")
cat("4. Pairwise comparisons: Which conditions differ\n")
cat("5. Effect sizes: Practical significance\n")
cat("\nThis Bayesian analysis should be faster and more robust than the frequentist GLMM!\n")
