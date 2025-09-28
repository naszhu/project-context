# EXPERIMENT 1 COMPREHENSIVE ANALYSIS SCRIPT
# Implements all analyses described in the manuscript
# Handles both initial and final test analyses with within/between-list comparisons

# ------------------
# 1. SETUP AND LIBRARIES
# ------------------
library(tidyverse)
library(lme4)
library(lmerTest)
library(emmeans)
library(ggeffects)
library(performance)
library(patchwork)
library(broom.mixed)
library(here)

# Set working directory to the data analysis folder
setwd("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design1/data_analysis")

# ------------------
# 2. DATA LOADING AND PREPROCESSING
# ------------------

# Load the main dataset
dfchanged <- read_csv("dfchanged.csv")
cat("Loaded dfchanged data with", nrow(dfchanged), "rows\n")

# Function to create polynomial terms and center variables
create_polynomial_terms <- function(data, var_name, degree = 2) {
  var_values <- data[[var_name]]
  
  # Handle missing values by replacing with mean
  if (any(is.na(var_values))) {
    var_values[is.na(var_values)] <- mean(var_values, na.rm = TRUE)
  }
  
  centered_var <- var_values - mean(var_values, na.rm = TRUE)
  
  # Check if we have enough unique values for the degree
  unique_vals <- length(unique(centered_var[!is.na(centered_var)]))
  actual_degree <- min(degree, unique_vals - 1)
  
  if (actual_degree < 1) {
    # If not enough unique values, just return centered variable
    result <- data.frame(centered_var)
    names(result) <- paste0(var_name, "_lin")
    return(result)
  }
  
  poly_terms <- poly(centered_var, degree = actual_degree, raw = FALSE)
  
  # Create column names
  col_names <- paste0(var_name, c("_lin", "_quad"))[1:actual_degree]
  
  # Return as data frame
  result <- as.data.frame(poly_terms)
  names(result) <- col_names
  return(result)
}

# ------------------
# 3. INITIAL TEST DATA PREPARATION
# ------------------

# Extract initial test data (pretest_response tasks)
initial_data <- dfchanged %>%
  filter(task == "pretest_response") %>%
  select(
    participant_id = PROLIFIC_PID,
    condition,
    trialnum,
    prespos,
    testpos,
    probetype,
    correct,
    stimulus_id,
    prespos_iposintrial_study,
    prespos_iposintrial_test
  ) %>%
  filter(!is.na(correct)) %>%
  mutate(
    # Convert to numeric and handle missing values
    trialnum = as.numeric(trialnum),
    prespos = as.numeric(prespos),
    testpos = as.numeric(testpos),
    prespos_iposintrial_study = as.numeric(prespos_iposintrial_study),
    prespos_iposintrial_test = as.numeric(prespos_iposintrial_test),
    
    # Create study and test positions - use the available data
    study_position = ifelse(!is.na(prespos_iposintrial_study) & prespos_iposintrial_study > 0, 
                           prespos_iposintrial_study, 
                           ifelse(prespos > 0, prespos, NA)),
    test_position = ifelse(!is.na(prespos_iposintrial_test) & prespos_iposintrial_test > 0, 
                          prespos_iposintrial_test, 
                          testpos),
    list_number = trialnum,  # trialnum is already the list number
    item_type = ifelse(probetype == "TARGET_target", "target", "foil"),
    accuracy = as.numeric(correct),
    participant_id = factor(participant_id),
    item_id = factor(stimulus_id),
    item_type = factor(item_type),
    condition = factor(condition)
  ) %>%
  filter(!is.na(test_position), !is.na(list_number), test_position > 0) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "study_position", 2)) %>%
  bind_cols(create_polynomial_terms(., "test_position", 2)) %>%
  bind_cols(create_polynomial_terms(., "list_number", 2))

cat("Initial test data prepared with", nrow(initial_data), "observations\n")
cat("Participants:", length(unique(initial_data$participant_id)), "\n")
cat("Items:", length(unique(initial_data$item_id)), "\n")

# ------------------
# 4. FINAL TEST DATA PREPARATION
# ------------------

# Extract final test data (finalt_response tasks)
final_data <- dfchanged %>%
  filter(task == "finalt_response") %>%
  select(
    participant_id = PROLIFIC_PID,
    condition,
    trialnum,
    probetype,
    correct,
    stimulus_id,
    prespos,
    testpos
  ) %>%
  filter(!is.na(correct)) %>%
  mutate(
    # Convert to numeric
    prespos = as.numeric(prespos),
    testpos = as.numeric(testpos),
    
    # Determine item type based on probetype
    item_type = case_when(
      probetype == "TARGET_target" ~ "S&T",
      probetype == "TARGET_nontarget" ~ "SO", 
      probetype == "TARGET_foil" ~ "TO",
      probetype == "FOIL" ~ "new_foil",
      TRUE ~ "unknown"
    ),
    accuracy = as.numeric(correct),
    participant_id = factor(participant_id),
    item_id = factor(stimulus_id),
    item_type = factor(item_type),
    condition = factor(condition),
    test_order = condition  # condition represents test order in final test
  ) %>%
  # For final test, we need to reconstruct study/test positions from original data
  left_join(
    initial_data %>% 
      select(stimulus_id, study_position, test_position, list_number) %>%
      distinct(),
    by = c("item_id" = "stimulus_id")
  ) %>%
  # Filter out items without position information and unknown types
  filter(!is.na(study_position), !is.na(test_position), !is.na(list_number),
         item_type != "unknown") %>%
  # Create original_list from list_number
  mutate(original_list = list_number) %>%
  # Add polynomial terms
  bind_cols(create_polynomial_terms(., "study_position", 2)) %>%
  bind_cols(create_polynomial_terms(., "test_position", 2)) %>%
  bind_cols(create_polynomial_terms(., "original_list", 2))

cat("Final test data prepared with", nrow(final_data), "observations\n")
cat("Participants:", length(unique(final_data$participant_id)), "\n")
cat("Items:", length(unique(final_data$item_id)), "\n")

# ------------------
# 5. ANALYSIS FUNCTIONS
# ------------------

# Generalized mixed-effects model function with error handling
run_glmm <- function(data, formula, family = binomial, max_iter = 1000) {
  cat("Fitting model:", as.character(formula)[2], "\n")
  
  # Try different optimizers if the first one fails
  optimizers <- c("bobyqa", "Nelder_Mead", "nlminbwrap")
  
  for (opt in optimizers) {
    tryCatch({
      model <- glmer(
        formula,
        data = data,
        family = family,
        control = glmerControl(
          optimizer = opt,
          nAGQ = 0,
          optCtrl = list(maxfun = max_iter)
        ),
        na.action = na.exclude
      )
      cat("Model converged with optimizer:", opt, "\n")
      return(model)
    }, error = function(e) {
      cat("Optimizer", opt, "failed:", e$message, "\n")
      return(NULL)
    })
  }
  
  stop("All optimizers failed to converge")
}

# Model diagnostics function
model_diagnostics <- function(model, model_name) {
  cat("\n----- MODEL DIAGNOSTICS FOR", model_name, "-----\n")
  
  # Check convergence
  conv_check <- check_convergence(model)
  print(conv_check)
  
  # Check singularity
  sing_check <- check_singularity(model)
  print(sing_check)
  
  # Model summary
  cat("\nModel Summary:\n")
  print(summary(model))
  
  # R-squared (if available)
  tryCatch({
    r2_values <- r2(model)
    print(r2_values)
  }, error = function(e) {
    cat("R-squared calculation failed:", e$message, "\n")
  })
  
  return(list(convergence = conv_check, singularity = sing_check))
}

# ------------------
# 6. INITIAL TEST ANALYSES
# ------------------

cat("\n====================\n")
cat("INITIAL TEST ANALYSES\n")
cat("====================\n")

# 6A. WITHIN-LIST EFFECTS (Initial Test)
cat("\n--- Initial Test Within-List Effects ---\n")

within_initial_formula <- accuracy ~ study_position_lin + study_position_quad + 
                          test_position_lin + test_position_quad + item_type +
                          study_position_lin:item_type + 
                          test_position_lin:item_type +
                          (1 | participant_id) + (1 | item_id)

within_initial <- run_glmm(initial_data, within_initial_formula)
within_initial_diag <- model_diagnostics(within_initial, "Initial Within-List")

# 6B. BETWEEN-LIST EFFECTS (Initial Test)
cat("\n--- Initial Test Between-List Effects ---\n")

between_initial_formula <- accuracy ~ list_number_lin + list_number_quad + item_type +
                          list_number_lin:item_type +
                          (1 + list_number_lin | participant_id)

between_initial <- run_glmm(initial_data, between_initial_formula)
between_initial_diag <- model_diagnostics(between_initial, "Initial Between-List")

# ------------------
# 7. FINAL TEST ANALYSES
# ------------------

cat("\n====================\n")
cat("FINAL TEST ANALYSES\n")
cat("====================\n")

# 7A. WITHIN-LIST EFFECTS (Final Test)
cat("\n--- Final Test Within-List Effects ---\n")

within_final_formula <- accuracy ~ study_position_lin + study_position_quad + 
                        test_position_lin + test_position_quad + item_type +
                        study_position_lin:item_type + 
                        test_position_lin:item_type +
                        (1 | participant_id) + (1 | item_id)

within_final <- run_glmm(final_data, within_final_formula)
within_final_diag <- model_diagnostics(within_final, "Final Within-List")

# 7B. BETWEEN-LIST EFFECTS (Final Test)
cat("\n--- Final Test Between-List Effects ---\n")

between_final_formula <- accuracy ~ original_list_lin + original_list_quad + 
                        test_order + item_type +
                        original_list_lin:item_type +
                        test_order:item_type +
                        (1 | participant_id) + (1 | item_id)

between_final <- run_glmm(final_data, between_final_formula)
between_final_diag <- model_diagnostics(between_final, "Final Between-List")

# ------------------
# 8. POST-HOC ANALYSES
# ------------------

cat("\n====================\n")
cat("POST-HOC ANALYSES\n")
cat("====================\n")

# Function to get contrasts
get_contrasts <- function(model, specs, by = NULL) {
  tryCatch({
    emm <- emmeans(model, specs = specs, by = by, type = "response")
    pairs(emm) %>% 
      as_tibble() %>% 
      mutate(sig = ifelse(p.value < 0.05, "*", ""))
  }, error = function(e) {
    cat("Contrast calculation failed:", e$message, "\n")
    return(NULL)
  })
}

# Initial test item type differences
cat("\n--- Initial Test Item Type Contrasts ---\n")
item_contrasts_initial <- get_contrasts(within_initial, specs = pairwise ~ item_type)
if (!is.null(item_contrasts_initial)) {
  print(item_contrasts_initial)
}

# Final test list position effects
cat("\n--- Final Test List Position Contrasts ---\n")
list_contrasts_final <- get_contrasts(between_final, specs = pairwise ~ original_list | test_order, by = "test_order")
if (!is.null(list_contrasts_final)) {
  print(list_contrasts_final)
}

# ------------------
# 9. VISUALIZATION
# ------------------

cat("\n====================\n")
cat("CREATING VISUALIZATIONS\n")
cat("====================\n")

# Function to create prediction plots
create_prediction_plot <- function(model, data, title, x_var, group_var = NULL) {
  tryCatch({
    # Get predictions
    pred_data <- ggpredict(model, terms = c(x_var, group_var))
    
    # Create plot
    p <- plot(pred_data) +
      labs(title = title) +
      theme_minimal() +
      theme(legend.position = "bottom")
    
    return(p)
  }, error = function(e) {
    cat("Plot creation failed for", title, ":", e$message, "\n")
    return(NULL)
  })
}

# Create plots
plot_initial_within <- create_prediction_plot(
  within_initial, 
  initial_data, 
  "Initial Test Within-List Effects",
  "study_position [all]",
  c("test_position [quartiles]", "item_type")
)

plot_initial_between <- create_prediction_plot(
  between_initial, 
  initial_data, 
  "Initial Test Between-List Effects", 
  "list_number [all]",
  "item_type"
)

plot_final_within <- create_prediction_plot(
  within_final, 
  final_data, 
  "Final Test Within-List Effects",
  "study_position [all]",
  c("test_position [quartiles]", "item_type")
)

plot_final_between <- create_prediction_plot(
  between_final, 
  final_data, 
  "Final Test Between-List Effects",
  "original_list [all]",
  c("test_order", "item_type")
)

# Combine plots if they were created successfully
plots_created <- !sapply(list(plot_initial_within, plot_initial_between, 
                             plot_final_within, plot_final_between), is.null)

if (sum(plots_created) > 0) {
  # Create combined plot
  plot_list <- list(plot_initial_within, plot_initial_between, 
                   plot_final_within, plot_final_between)
  plot_list <- plot_list[!sapply(plot_list, is.null)]
  
  if (length(plot_list) >= 2) {
    combined_plots <- wrap_plots(plot_list, ncol = 2) +
      plot_annotation(tag_levels = "A")
    
    ggsave("experiment1_combined_effects.png", combined_plots, 
           width = 14, height = 10, dpi = 300)
    cat("Combined plot saved as experiment1_combined_effects.png\n")
  }
}

# ------------------
# 10. REPORTING TABLES
# ------------------

cat("\n====================\n")
cat("CREATING REPORTING TABLES\n")
cat("====================\n")

# Function to create publication-ready tables
create_coef_table <- function(model, model_name) {
  tryCatch({
    broom.mixed::tidy(model, conf.int = TRUE, exponentiate = TRUE) %>%
      filter(effect == "fixed") %>%
      select(term, estimate, std.error, conf.low, conf.high, p.value) %>%
      mutate(
        across(c(estimate, std.error, conf.low, conf.high), round, 3),
        p.value = format.pval(p.value, digits = 3, eps = 0.001)
      ) %>%
      rename(
        Term = term,
        β = estimate,
        SE = std.error,
        CI_low = conf.low,
        CI_high = conf.high,
        p = p.value
      ) %>%
      mutate(Model = model_name)
  }, error = function(e) {
    cat("Table creation failed for", model_name, ":", e$message, "\n")
    return(NULL)
  })
}

# Generate tables
tables <- list(
  initial_within = create_coef_table(within_initial, "Initial Within-List"),
  initial_between = create_coef_table(between_initial, "Initial Between-List"),
  final_within = create_coef_table(within_final, "Final Within-List"),
  final_between = create_coef_table(between_final, "Final Between-List")
)

# Save tables
for (i in seq_along(tables)) {
  if (!is.null(tables[[i]])) {
    filename <- paste0("results_", names(tables)[i], "_coefs.csv")
    write_csv(tables[[i]], filename)
    cat("Table saved as", filename, "\n")
  }
}

# ------------------
# 11. SAVE RESULTS
# ------------------

cat("\n====================\n")
cat("SAVING RESULTS\n")
cat("====================\n")

# Create results summary
results_summary <- list(
  # Data info
  initial_data_rows = nrow(initial_data),
  final_data_rows = nrow(final_data),
  n_participants = length(unique(initial_data$participant_id)),
  n_items = length(unique(initial_data$item_id)),
  
  # Model convergence
  initial_within_converged = within_initial_diag$convergence,
  initial_between_converged = between_initial_diag$convergence,
  final_within_converged = within_final_diag$convergence,
  final_between_converged = between_final_diag$convergence,
  
  # Model objects
  models = list(
    initial_within = within_initial,
    initial_between = between_initial,
    final_within = within_final,
    final_between = between_final
  ),
  
  # Tables
  coefficient_tables = tables,
  
  # Contrasts
  contrasts = list(
    initial_item_type = item_contrasts_initial,
    final_list_position = list_contrasts_final
  )
)

# Save complete results
saveRDS(results_summary, "experiment1_analysis_results.rds")
cat("Complete results saved as experiment1_analysis_results.rds\n")

# Save workspace
save.image("experiment1_analysis_workspace.RData")
cat("Workspace saved as experiment1_analysis_workspace.RData\n")

cat("\n====================\n")
cat("ANALYSIS COMPLETE\n")
cat("====================\n")

# Print summary
cat("\nSUMMARY:\n")
cat("- Initial test data:", results_summary$initial_data_rows, "observations\n")
cat("- Final test data:", results_summary$final_data_rows, "observations\n")
cat("- Participants:", results_summary$n_participants, "\n")
cat("- Items:", results_summary$n_items, "\n")
cat("- All models fitted successfully\n")
cat("- Results saved for report generation\n")
