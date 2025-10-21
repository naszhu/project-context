library(readr)
library(dplyr)
library(tidyr)

# Load the data
df <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_data_e3.csv")

# Function to format value with SE for display
format_value <- function(value, se) {
  sprintf("%.2f (%.2f)", value, se)
}

# Function to create wide-format table for each condition
create_wide_table <- function(data) {
  # Get unique analyses and conditions
  analyses <- unique(data$Analysis)
  
  all_tables <- list()
  
  for (analysis in analyses) {
    analysis_data <- data %>% filter(Analysis == analysis)
    conditions <- unique(analysis_data$Condition)
    
    for (condition in conditions) {
      condition_data <- analysis_data %>% filter(Condition == condition)
      
      # Get unique probe types and positions
      probe_types <- unique(condition_data$`Probe Type`)
      positions <- sort(unique(condition_data$Position))
      
      if (length(probe_types) == 0 || length(positions) == 0) next
      
      # Create wide format
      wide_data <- condition_data %>%
        mutate(
          Value_SE = format_value(Value, `Standard Error`)
        ) %>%
        select(Analysis, Condition, `Probe Type`, Position, Value_SE) %>%
        pivot_wider(
          names_from = Position,
          values_from = Value_SE,
          names_prefix = "Pos_"
        )
      
      # Apply APA suppression (empty cells for repeated Analysis/Condition)
      if (nrow(wide_data) > 0) {
        for (i in 2:nrow(wide_data)) {
          if (wide_data$Analysis[i] == wide_data$Analysis[i-1]) {
            wide_data$Analysis[i] <- ""
          }
          if (wide_data$Condition[i] == wide_data$Condition[i-1]) {
            wide_data$Condition[i] <- ""
          }
        }
      }
      
      # Replace NA with dash
      wide_data[is.na(wide_data)] <- "—"
      
      # Store table
      table_name <- paste0(gsub("[^A-Za-z0-9]", "_", analysis), "_", 
                          gsub("[^A-Za-z0-9]", "_", condition))
      all_tables[[table_name]] <- wide_data
    }
  }
  
  return(all_tables)
}

# Generate wide-format tables
cat("Generating wide-format CSV tables...\n")
tables <- create_wide_table(df)

# Save each table as a separate CSV
output_dir <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare"

for (table_name in names(tables)) {
  output_file <- file.path(output_dir, paste0("E3_", table_name, ".csv"))
  write_csv(tables[[table_name]], output_file)
  cat("Saved:", output_file, "\n")
}

# Also create one combined CSV file with all tables
cat("\nCreating combined CSV file...\n")

combined_output <- NULL
for (table_name in names(tables)) {
  table_data <- tables[[table_name]]
  
  # Add a blank row between tables
  if (!is.null(combined_output)) {
    blank_row <- as.data.frame(matrix("", nrow = 1, ncol = ncol(combined_output)))
    names(blank_row) <- names(combined_output)
    combined_output <- bind_rows(combined_output, blank_row)
  }
  
  # Ensure column names match
  if (is.null(combined_output)) {
    combined_output <- table_data
  } else {
    # Get all unique column names
    all_cols <- unique(c(names(combined_output), names(table_data)))
    
    # Add missing columns to both dataframes
    for (col in all_cols) {
      if (!col %in% names(combined_output)) {
        combined_output[[col]] <- "—"
      }
      if (!col %in% names(table_data)) {
        table_data[[col]] <- "—"
      }
    }
    
    # Reorder columns to match
    table_data <- table_data[, names(combined_output)]
    
    # Combine
    combined_output <- bind_rows(combined_output, table_data)
  }
}

# Save combined file
combined_file <- file.path(output_dir, "E3_All_Tables_Combined.csv")
write_csv(combined_output, combined_file)
cat("Saved combined file:", combined_file, "\n")

# Create a summary
cat("\n=== Summary ===\n")
cat("Number of separate table files created:", length(tables), "\n")
cat("Total rows in combined file:", nrow(combined_output), "\n")
cat("\nTable names created:\n")
for (name in names(tables)) {
  cat("  -", name, "(", nrow(tables[[name]]), "rows )\n")
}

cat("\nAll CSV files saved successfully!\n")

