# ================================
# Shared Setup: Libraries and Helper Functions
# ================================
# Source this file at the beginning of each individual analysis

library(tidyverse)
library(lme4)
library(broom.mixed)
library(emmeans)
library(dplyr)
library(readr)
library(purrr)
library(stringr)

# Helper: safe poly (always returns *_lin, *_quad)
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

cat("Shared setup loaded successfully\n")
