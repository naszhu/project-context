library(readr)
library(dplyr)
library(tidyr)

# Load the CSV data
df <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_data_e3.csv")

# Function to format value with SE
format_value <- function(value, se) {
  sprintf("%.2f (%.2f)", value, se)
}

# Function to create APA-style table (suppress repeated values in columns)
create_apa_table <- function(data) {
  # Get unique analyses and conditions
  analyses <- unique(data$Analysis)
  
  output <- ""
  
  for (analysis in analyses) {
    analysis_data <- data %>% filter(Analysis == analysis)
    conditions <- unique(analysis_data$Condition)
    
    # Add analysis header
    output <- paste0(output, "## ", analysis, "\n\n")
    
    for (condition in conditions) {
      condition_data <- analysis_data %>% filter(Condition == condition)
      
      # Get unique probe types and positions
      probe_types <- unique(condition_data$`Probe Type`)
      positions <- sort(unique(condition_data$Position))
      
      # Skip if no data
      if (length(probe_types) == 0 || length(positions) == 0) next
      
      # Create table header with condition as subtitle
      output <- paste0(output, "### ", condition, "\n\n")
      
      # Create header row
      header <- "| Analysis | Condition | Probe Type |"
      for (pos in positions) {
        header <- paste0(header, " ", pos, " |")
      }
      output <- paste0(output, header, "\n")
      
      # Create separator
      sep <- "|----------|-----------|------------|"
      for (pos in positions) {
        sep <- paste0(sep, "---------------|")
      }
      output <- paste0(output, sep, "\n")
      
      # Track previous values for APA-style suppression
      prev_analysis <- ""
      prev_condition <- ""
      
      # Create rows for each probe type
      for (pt in probe_types) {
        row_data <- condition_data %>% 
          filter(`Probe Type` == pt) %>%
          arrange(Position)
        
        if (nrow(row_data) == 0) next
        
        # Get first row for this probe type
        first_row <- row_data[1,]
        
        # Apply APA suppression rule
        analysis_cell <- if (first_row$Analysis == prev_analysis) "" else first_row$Analysis
        condition_cell <- if (first_row$Condition == prev_condition) "" else first_row$Condition
        
        # Update previous values
        prev_analysis <- first_row$Analysis
        prev_condition <- first_row$Condition
        
        # Build row
        row <- paste0("| ", analysis_cell, " | ", condition_cell, " | ", pt, " |")
        
        for (pos in positions) {
          cell_data <- row_data %>% filter(Position == pos)
          if (nrow(cell_data) > 0) {
            row <- paste0(row, " ", format_value(cell_data$Value[1], cell_data$`Standard Error`[1]), " |")
          } else {
            row <- paste0(row, " — |")
          }
        }
        output <- paste0(output, row, "\n")
      }
      
      output <- paste0(output, "\n")
    }
  }
  
  return(output)
}

# Start building the markdown document
md_output <- "# Appendix - Experiment 2 (E3) Tables\n\n"
md_output <- paste0(md_output, "*Hits and Correct Rejections by Analysis Type, Condition, and Position*\n\n")

# Create APA-style tables
cat("Generating APA-style tables...\n")
md_output <- paste0(md_output, create_apa_table(df))

###############################################################################
# Add notes and legend
###############################################################################
md_output <- paste0(md_output, "*Note.* Values are *M* (*SE*). Standard errors reflect between-participant variability. ")
md_output <- paste0(md_output, "Position values represent serial positions within lists or test sequences, binned into groups where applicable. ")
md_output <- paste0(md_output, "Dash (—) indicates condition not applicable or data not available.\n\n")

md_output <- paste0(md_output, "## Probe Type Abbreviations\n\n")
md_output <- paste0(md_output, "**Initial and Final Test Probe Types:**\n\n")
md_output <- paste0(md_output, "- **ST** = Study-Test: Items both studied and tested in the initial phase\n")
md_output <- paste0(md_output, "- **SO** = Study-Only: Items studied but not tested in the initial phase\n")
md_output <- paste0(md_output, "- **TO** = Test-Only: Items presented as foils during testing\n")
md_output <- paste0(md_output, "- **STn** = Study-Test in list *n*, then foil in list *n*+1 (confusing foil)\n")
md_output <- paste0(md_output, "- **SOn** = Study-Only in list *n*, then foil in list *n*+1 (confusing foil)\n")
md_output <- paste0(md_output, "- **TOn** = Test-Only (foil) in list *n*, then foil in list *n*+1 (confusing foil)\n")
md_output <- paste0(md_output, "- **FTO** = Final Test Only: Never-presented items (new foils)\n\n")

md_output <- paste0(md_output, "**Note on Confusing Foils:** Items marked with '*n*' suffix (STn, SOn, TOn) are \"confusing foils\" ")
md_output <- paste0(md_output, "that appeared in different roles across consecutive lists, potentially creating proactive interference.\n\n")

md_output <- paste0(md_output, "## Analysis Types\n\n")
md_output <- paste0(md_output, "- **Initial Test Between-List Effect**: Performance across the 10 initial lists\n")
md_output <- paste0(md_output, "- **Initial Test Within-List Effect**: Performance by position within each initial list\n")
md_output <- paste0(md_output, "- **Final Test Between-List Effect**: Final test performance by test order position\n")
md_output <- paste0(md_output, "- **Final Test Within-List Effect**: Final test performance by initial list positions\n")

# Save markdown file
output_file <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_e3.md"
writeLines(md_output, output_file)

cat("\n=== Complete ===\n")
cat("Markdown file saved to:", output_file, "\n")

