library(readr)
library(dplyr)
library(tidyr)

# Load the CSV data
df <- read_csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_data_e3.csv")

# Function to format value with SE
format_value <- function(value, se) {
  sprintf("%.2f (%.2f)", value, se)
}

# Function to create a markdown table
create_md_table <- function(data, subsection_name) {
  # Get unique probe types and positions
  probe_types <- unique(data$`Probe Type`)
  positions <- sort(unique(data$Position))
  
  # Initialize output
  output <- paste0("### ", subsection_name, "\n\n")
  
  # Create header
  header <- "| Probe Type |"
  for (pos in positions) {
    header <- paste0(header, " ", pos, " |")
  }
  output <- paste0(output, header, "\n")
  
  # Create separator
  sep <- "|------------|"
  for (pos in positions) {
    sep <- paste0(sep, "---------------|")
  }
  output <- paste0(output, sep, "\n")
  
  # Create rows for each probe type
  for (pt in probe_types) {
    row_data <- data %>% 
      filter(`Probe Type` == pt) %>%
      arrange(Position)
    
    row <- paste0("| ", pt, " |")
    
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
  return(output)
}

# Start building the markdown document
md_output <- "# Appendix - Experiment 2 (E3) Tables\n\n"
md_output <- paste0(md_output, "*Accuracy and Standard Errors by Condition and Position*\n\n")

###############################################################################
# Table E3.1: Initial Test - Between List
###############################################################################
cat("Generating Table E3.1...\n")
md_output <- paste0(md_output, "## Table E3.1\n")
md_output <- paste0(md_output, "*Initial Test Performance by Initial List Number*\n\n")

table_e31_data <- df %>% filter(Table == "Table E3.1")
md_output <- paste0(md_output, create_md_table(table_e31_data, "Initial List Number"))

md_output <- paste0(md_output, "*Note.* Values are *M* (*SE*). Initial list number represents the serial position (1-10) of the list in the initial test phase.\n\n")

###############################################################################
# Table E3.2: Initial Test - Within List
###############################################################################
cat("Generating Table E3.2...\n")
md_output <- paste0(md_output, "## Table E3.2\n")
md_output <- paste0(md_output, "*Initial Test Performance by Within-List Position*\n\n")

# Study Position
table_e32_study <- df %>% 
  filter(Table == "Table E3.2", Subsection == "Initial Study Position")
md_output <- paste0(md_output, create_md_table(table_e32_study, "Initial Study Position"))

# Test Position
table_e32_test <- df %>% 
  filter(Table == "Table E3.2", Subsection == "Initial Test Position")
md_output <- paste0(md_output, create_md_table(table_e32_test, "Initial Test Position"))

md_output <- paste0(md_output, "*Note.* Values are *M* (*SE*). Study position represents the serial position of items during initial study (1-30, binned into 10 groups). Test position represents the serial position during initial test (1-30, binned into 10 groups). Position 0 represents foils (unstudied items).\n\n")

###############################################################################
# Table E3.3: Final Test - Between List
###############################################################################
cat("Generating Table E3.3...\n")
md_output <- paste0(md_output, "## Table E3.3\n")
md_output <- paste0(md_output, "*Final Test Performance by Final Test Position*\n\n")

table_e33_data <- df %>% filter(Table == "Table E3.3")
md_output <- paste0(md_output, create_md_table(table_e33_data, "Final Test Position"))

md_output <- paste0(md_output, "*Note.* Values are *M* (*SE*). Final test position represents the serial position (binned into 10 groups) in the final recognition test.\n\n")

###############################################################################
# Table E3.4: Final Test - Within List
###############################################################################
cat("Generating Table E3.4...\n")
md_output <- paste0(md_output, "## Table E3.4\n")
md_output <- paste0(md_output, "*Final Test Performance by Initial Position and List Number*\n\n")

# Initial Study Position
table_e34_study <- df %>% 
  filter(Table == "Table E3.4", Subsection == "Initial Study Position")
if (nrow(table_e34_study) > 0) {
  md_output <- paste0(md_output, create_md_table(table_e34_study, "Initial Study Position"))
}

# Initial Test Position  
table_e34_test <- df %>% 
  filter(Table == "Table E3.4", Subsection == "Initial Test Position")
if (nrow(table_e34_test) > 0) {
  md_output <- paste0(md_output, create_md_table(table_e34_test, "Initial Test Position"))
}

# Initial List Number
table_e34_list <- df %>% 
  filter(Table == "Table E3.4", Subsection == "Initial List Number")
if (nrow(table_e34_list) > 0) {
  md_output <- paste0(md_output, create_md_table(table_e34_list, "Initial List Number"))
}

md_output <- paste0(md_output, "*Note.* Values are *M* (*SE*). These tables show final test performance broken down by the initial positions and list numbers from the initial test phase.\n\n")

###############################################################################
# Probe type legend
###############################################################################
md_output <- paste0(md_output, "## Probe Type Legend\n\n")
md_output <- paste0(md_output, "- **Target**: Items studied and tested in the initial phase\n")
md_output <- paste0(md_output, "- **New Foil**: Never-presented items (foils)\n")
md_output <- paste0(md_output, "- **Inherented Foil - Last Target**: Items that were targets in list n-1 and foils in list n\n")
md_output <- paste0(md_output, "- **Inherented Foil - Last Studied Only**: Items studied-only in list n-1 and foils in list n\n")
md_output <- paste0(md_output, "- **Inherented Foil - Last Foil**: Items that were foils in list n-1 and foils in list n\n")

# Save markdown file
output_file <- "/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/Docs/appendix prepare/appendix_table_e3.md"
writeLines(md_output, output_file)

cat("\n=== Complete ===\n")
cat("Markdown file saved to:", output_file, "\n")

