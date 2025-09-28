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
    # Between-list positions (using final test positions)
    final_order    = case_when(item_type %in% c("ST","TO") ~ as.numeric(cut_number(as.numeric(testpos), 10, labels = 1:10)), 
                               TRUE ~ NA_real_),
    initial_order  = case_when(item_type %in% c("ST","SO") ~ as.numeric(prespos_itrial),
                               TRUE ~ NA_real_)
  ) %>%
  # Remove rows where we couldn't determine positions
  filter(!is.na(study_position) | !is.na(test_position)) %>%
  select(participant_id, accuracy, item_type, study_position, test_position, final_order, initial_order, condition)

# ------------------
# Add polynomial terms
# ------------------
final <- final %>%
  bind_cols(create_polynomial_terms(., "study_position")) %>%
  bind_cols(create_polynomial_terms(., "test_position")) %>%
  bind_cols(create_polynomial_terms(., "final_order")) %>%
  bind_cols(create_polynomial_terms(., "initial_order"))


# 4) Models (random intercepts; item-type-specific trends via interactions)
# Initial: Study Position × Item Type
m_init_studypos <- glmer(
  accuracy ~ (study_position_lin + study_position_quad) * item_type +
    (1 | participant_id) + (0 + study_position_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Initial: Test Position × Item Type
m_init_testpos <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id) + (0 + test_position_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Initial: Between-List (List Index) × Item Type
m_init_between <- glmer(
  accuracy ~ (list_number_lin + list_number_quad) * item_type +
    (1 | participant_id) + (0 + list_number_lin | participant_id),
  data = initial, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Final test: Within-list study position × item type
m_final_within_study <- glmer(
  accuracy ~ (study_position_lin + study_position_quad) * item_type +
    (1 | participant_id) + (0 + study_position_lin | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Final test: Within-list test position × item type
m_final_within_test <- glmer(
  accuracy ~ (test_position_lin + test_position_quad) * item_type +
    (1 | participant_id) + (0 + test_position_lin | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa"),
  na.action = na.omit
)

# Final test: Between-list final order × item type × condition
m_between_final <- glmer(
  accuracy ~ (final_order_lin + final_order_quad) * item_type * condition +
    (1 | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 10000)),
  na.action = na.omit
)

# Final test: Between-list initial order × item type × condition
m_between_initial <- glmer(
  accuracy ~ (initial_order_lin + initial_order_quad) * item_type * condition +
    (1 | participant_id),
  data = final, family = binomial,
  control = glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 10000)),
  na.action = na.omit
)
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

# ------------------
# Diagnostic analysis for within-list study position discrepancy
# ------------------
cat("\n=== DIAGNOSTIC ANALYSIS: Within-List Study Position ===\n")

# 1. Check effect sizes for quadratic trend
convergence_code <- m_final_within_study@optinfo$convergence
if (is.null(convergence_code) || length(convergence_code) == 0) {
  cat("WARNING: Cannot determine convergence status. Effect sizes may be unreliable.\n")
} else if (convergence_code == 0) {
  quad_effect <- fixef(m_final_within_study)["study_position_quad"]
  quad_or <- exp(quad_effect)
  cat("Quadratic effect coefficient:", round(quad_effect, 4), "\n")
  cat("Quadratic effect Odds Ratio:", round(quad_or, 3), "\n")
} else {
  cat("WARNING: Model did not converge properly. Effect sizes may be unreliable.\n")
  cat("Convergence code:", convergence_code, "\n")
}

# 2. Generate model predictions for visualization
library(ggplot2)
pred_data <- expand.grid(
  study_position = seq(min(final$study_position, na.rm = TRUE), 
                       max(final$study_position, na.rm = TRUE),
                       length.out = 20),
  item_type = unique(final$item_type)
)

# Add polynomial terms for prediction
pred_data <- pred_data %>%
  bind_cols(create_polynomial_terms(., "study_position"))

# Generate predictions (only if model converged)
convergence_code <- m_final_within_study@optinfo$convergence
if (is.null(convergence_code) || length(convergence_code) == 0 || convergence_code != 0) {
  cat("Skipping prediction plot due to convergence issues.\n")
  pred_data$pred <- NA
} else {
  pred_data$pred <- predict(m_final_within_study, newdata = pred_data, type = "response")
}

# Plot model predictions vs raw data
raw_data <- final %>%
  filter(!is.na(study_position)) %>%
  group_by(study_position, item_type) %>%
  summarise(mean_acc = mean(accuracy), 
            se_acc = sd(accuracy)/sqrt(n()),
            .groups = "drop")

# Only create plot if we have valid data
if (nrow(raw_data) > 0 && !all(is.na(pred_data$pred))) {
  p1 <- ggplot(raw_data, aes(study_position, mean_acc, color = item_type)) +
    geom_point(size = 3) +
    geom_errorbar(aes(ymin = mean_acc - se_acc, ymax = mean_acc + se_acc), width = 0.1) +
    # geom_line(data = pred_data, aes(study_position, pred), linewidth = 1.5) +
    labs(title = "Study Position Effects: Raw Data vs Model Predictions",
         x = "Study Position", y = "Accuracy",
         color = "Item Type") +
    theme_bw()
  
  print(p1)
} else {
  cat("Skipping plot due to insufficient data or convergence issues.\n")
  
  # Create a simple raw data plot instead
  if (nrow(raw_data) > 0) {
    p1_simple <- ggplot(raw_data, aes(study_position, mean_acc, color = item_type)) +
      geom_point(size = 3) +
      geom_errorbar(aes(ymin = mean_acc - se_acc, ymax = mean_acc + se_acc), width = 0.1) +
      labs(title = "Study Position Effects: Raw Data Only (Model Predictions Unavailable)",
           x = "Study Position", y = "Accuracy",
           color = "Item Type") +
      theme_bw()
    
    print(p1_simple)
  }
}

# 3. Simple slopes analysis (only if model converged)
convergence_code <- m_final_within_study@optinfo$convergence
if (is.null(convergence_code) || length(convergence_code) == 0 || convergence_code != 0) {
  cat("\nSkipping advanced diagnostics due to convergence issues.\n")
  cat("Recommendation: Simplify the model structure or check for data issues.\n")
} else {
  cat("\nSimple slopes analysis:\n")
  simple_slopes <- emtrends(m_final_within_study, ~ item_type, var = "study_position_quad")
  print(simple_slopes)
  
  # 4. Model comparison (quadratic vs linear only)
  m_linear_only <- update(m_final_within_study, . ~ . - study_position_quad)
  comparison <- anova(m_final_within_study, m_linear_only)
  cat("\nModel comparison (with vs without quadratic term):\n")
  print(comparison)
  
  # 5. Check if quadratic effect is driven by specific positions
  cat("\nQuadratic trend at specific positions:\n")
  pos_effects <- emtrends(m_final_within_study, ~ study_position, var = "study_position_quad",
                         at = list(study_position = c(1, 4, 8))) 
  print(pos_effects)
}

cat("\n=== END DIAGNOSTIC ANALYSIS ===\n")

# ------------------
# Check all models for convergence and retry if needed
# ------------------
cat("\n=== MODEL CONVERGENCE CHECK ===\n")
all_models <- list(
  "Initial Study Position" = m_init_studypos,
  "Initial Test Position" = m_init_testpos, 
  "Initial Between-List" = m_init_between,
  "Final Within-Study" = m_final_within_study,
  "Final Within-Test" = m_final_within_test,
  "Final Between-Final" = m_between_final,
  "Final Between-Initial" = m_between_initial
)

for (i in seq_along(all_models)) {
  model_name <- names(all_models)[i]
  model <- all_models[[i]]
  
  convergence_code <- model@optinfo$convergence
  if (is.null(convergence_code) || length(convergence_code) == 0) {
    cat("? ", model_name, "convergence status unknown\n")
  } else if (convergence_code == 0) {
    cat("✓", model_name, "converged successfully\n")
  } else {
    cat("✗", model_name, "failed to converge (code:", convergence_code, ")\n")
    cat("  Trying alternative optimizer...\n")
    
    # Try different optimizer
    tryCatch({
      all_models[[i]] <- update(model, 
                               control = glmerControl(optimizer = "nloptwrap", 
                                                    optCtrl = list(maxfun = 20000)))
      new_convergence <- all_models[[i]]@optinfo$convergence
      if (is.null(new_convergence) || length(new_convergence) == 0) {
        cat("  ? Retry status unknown\n")
      } else if (new_convergence == 0) {
        cat("  ✓ Retry successful with nloptwrap\n")
      } else {
        cat("  ✗ Retry failed\n")
      }
    }, error = function(e) {
      cat("  ✗ Retry failed with error:", e$message, "\n")
    })
  }
}

# Update model objects
m_init_studypos <- all_models[["Initial Study Position"]]
m_init_testpos <- all_models[["Initial Test Position"]]
m_init_between <- all_models[["Initial Between-List"]]
m_final_within_study <- all_models[["Final Within-Study"]]
m_final_within_test <- all_models[["Final Within-Test"]]
m_between_final <- all_models[["Final Between-Final"]]
m_between_initial <- all_models[["Final Between-Initial"]]

cat("=== END CONVERGENCE CHECK ===\n\n")

# ------------------
# 5) Summaries (fixed effects)
# ------------------
results <- list(
  init_studypos        = broom.mixed::tidy(m_init_studypos,        effects = "fixed", conf.int = TRUE),
  init_testpos         = broom.mixed::tidy(m_init_testpos,         effects = "fixed", conf.int = TRUE),
  init_between         = broom.mixed::tidy(m_init_between,         effects = "fixed", conf.int = TRUE),
  final_within_study   = broom.mixed::tidy(m_final_within_study,   effects = "fixed", conf.int = TRUE),
  final_within_test    = broom.mixed::tidy(m_final_within_test,    effects = "fixed", conf.int = TRUE),
  final_between_final  = broom.mixed::tidy(m_between_final,        effects = "fixed", conf.int = TRUE),
  final_between_initial= broom.mixed::tidy(m_between_initial,      effects = "fixed", conf.int = TRUE)
)

# ------------------
# 6) Item-type–specific linear & quadratic trends (simple slopes)
# ------------------
trends <- list(
  # Initial test
  init_studypos_lin   = emtrends(m_init_studypos,   ~ item_type, var = "study_position_lin"),
  init_studypos_quad  = emtrends(m_init_studypos,   ~ item_type, var = "study_position_quad"),
  init_testpos_lin    = emtrends(m_init_testpos,    ~ item_type, var = "test_position_lin"),
  init_testpos_quad   = emtrends(m_init_testpos,    ~ item_type, var = "test_position_quad"),
  init_between_lin    = emtrends(m_init_between,    ~ item_type, var = "list_number_lin"),
  init_between_quad   = emtrends(m_init_between,    ~ item_type, var = "list_number_quad"),

  # Final test (within-list)
  final_within_study_lin  = emtrends(m_final_within_study, ~ item_type, var = "study_position_lin"),
  final_within_study_quad = emtrends(m_final_within_study, ~ item_type, var = "study_position_quad"),
  final_within_test_lin   = emtrends(m_final_within_test,  ~ item_type, var = "test_position_lin"),
  final_within_test_quad  = emtrends(m_final_within_test,  ~ item_type, var = "test_position_quad"),

  # Final test (between-list)
  final_between_final_lin   = emtrends(m_between_final,   ~ item_type, var = "final_order_lin"),
  final_between_final_quad  = emtrends(m_between_final,   ~ item_type, var = "final_order_quad"),
  final_between_initial_lin = emtrends(m_between_initial, ~ item_type, var = "initial_order_lin"),
  final_between_initial_quad= emtrends(m_between_initial, ~ item_type, var = "initial_order_quad")
)

# Convert emtrends results to data frames safely
trends_df <- lapply(trends, function(x) tryCatch(as.data.frame(x), error = function(e) NULL))

# ------------------
# 7) Save
# ------------------
saveRDS(
  list(
    models = list(
      m_init_studypos       = m_init_studypos,
      m_init_testpos        = m_init_testpos,
      m_init_between        = m_init_between,
      m_final_within_study  = m_final_within_study,
      m_final_within_test   = m_final_within_test,
      m_between_final       = m_between_final,
      m_between_initial     = m_between_initial
    ),
    summaries = results,
    trends    = trends_df
  ),
  "experiment1_glmm_full_with_interactions.rds"
)

# Also export flat CSV for reporting
bind_rows(
  results$init_studypos          %>% mutate(model = "init_studypos"),
  results$init_testpos           %>% mutate(model = "init_testpos"),
  results$init_between           %>% mutate(model = "init_between"),
  results$final_within_study     %>% mutate(model = "final_within_study"),
  results$final_within_test      %>% mutate(model = "final_within_test"),
  results$final_between_final    %>% mutate(model = "final_between_final"),
  results$final_between_initial  %>% mutate(model = "final_between_initial")
) %>%
  write_csv("all_model_summaries_with_interactions.csv")

# Tidy & save item-type trends (if any computed)
compact_trends <- purrr::imap_dfr(trends_df, ~{
  if (is.null(.x)) return(NULL)
  as_tibble(.x) %>% mutate(contrast = .y)
})
if (nrow(compact_trends) > 0) write_csv(compact_trends, "all_itemtype_trends.csv")

cat("Saved: experiment1_glmm_full_with_interactions.rds\n")
cat("Saved: all_model_summaries_with_interactions.csv\n")
if (exists("compact_trends") && nrow(compact_trends) > 0) cat("Saved: all_itemtype_trends.csv\n")
