# Individual Analyses

This folder contains individual R analysis files separated from the comprehensive analysis script. Each file performs a specific analysis and can be run independently.

## Files Overview

### 00_shared_setup.R
Common libraries and helper functions used across all analyses. This file should be sourced at the beginning of each analysis script.

### Initial Test Analyses

**01_initial_study_position_analysis.R**
- Analyzes study position effects during the initial test
- Examines how item position during study affects initial test performance
- Item types: target vs. foil

**02_initial_test_position_analysis.R**
- Analyzes test position effects during the initial test
- Examines how item position during test affects initial test performance
- Item types: target vs. foil

**03_initial_between_list_analysis.R**
- Analyzes between-list effects during the initial test
- Examines how list number (trial number) affects initial test performance
- Item types: target vs. foil

### Final Test Analyses

**04_final_within_study_analysis.R**
- Analyzes within-list study position effects during the final test
- Examines how original study position affects final test performance
- Item types: ST (studied-tested), SO (studied-only), TO (tested-only), foil

**05_final_within_test_analysis.R**
- Analyzes within-list test position effects during the final test
- Examines how original test position affects final test performance
- Item types: ST (studied-tested), SO (studied-only), TO (tested-only), foil

**06_final_between_final_order_analysis.R**
- Analyzes between-list effects using final test order
- Examines how position in the final test affects performance
- Includes condition × position interactions
- Item types: ST, SO, TO, foil

**07_final_between_initial_order_analysis.R**
- Analyzes between-list effects using initial list order
- Examines how the order items appeared in initial lists affects final test performance
- Includes condition × position interactions
- Item types: ST, SO, TO, foil

## How to Run

1. Make sure you're in the `individual_analyses` folder
2. Run any analysis individually:
   ```R
   source("01_initial_study_position_analysis.R")
   ```

Each analysis will:
- Load the shared setup
- Prepare the necessary data
- Fit the appropriate GLMM model
- Run convergence diagnostics
- Generate summary statistics and trends
- Save results as .rds and .csv files

## Output Files

Each analysis generates:
- `[analysis_name]_model.rds` - Full model object with all results
- `[analysis_name]_summary.csv` - Fixed effects summary in CSV format

The .rds files contain:
- Fitted model object
- Fixed effects summary
- Linear and quadratic trends
- Estimated marginal means
- Pairwise comparisons
- Condition interactions (for final test between-list analyses)
