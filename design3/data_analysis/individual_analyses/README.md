# Individual Analyses - Experiment 3

This folder contains individual R analysis files separated from the comprehensive analysis script. Each file performs a specific analysis and can be run independently.

## Files Overview

### 00_shared_setup.R
Common libraries and helper functions used across all analyses. This file should be sourced at the beginning of each analysis script.

### Initial Test Analyses

**01_initial_study_position_analysis.R**
- Analyzes study position effects during the initial test
- Examines how item position during study affects initial test performance
- Handles confusing foils (inherited from previous lists)
- Item types vary based on the foil inheritance patterns

**02_initial_test_position_analysis.R**
- Analyzes test position effects during the initial test
- Examines how item position during test affects initial test performance
- Item types vary based on the foil inheritance patterns

**03_initial_between_list_analysis.R**
- Analyzes between-list effects during the initial test
- Examines how list number (trial number) affects initial test performance
- Item types vary based on the foil inheritance patterns

### Final Test Analyses

**04_final_within_study_analysis.R**
- Analyzes within-list study position effects during the final test
- Examines how original study position affects final test performance
- Uses linear trends only
- Item types: ST (studied-tested), SO (studied-only), TO (tested-only), foil

**05_final_within_test_analysis.R**
- Analyzes within-list test position effects during the final test
- Examines how original test position affects final test performance
- Uses linear trends only
- Item types: ST (studied-tested), SO (studied-only), TO (tested-only), foil

**06_final_between_final_order_analysis.R**
- Analyzes between-list effects using final test order
- Examines how position in the final test affects performance
- Includes linear and quadratic trends with item type interactions
- Final test positions are binned into 10 groups (49 items each)
- Item types: ST, SO, TO, foil

**07_final_between_initial_order_analysis.R**
- Analyzes between-list effects using initial list order
- Examines how the order items appeared in initial lists affects final test performance
- Includes linear and quadratic trends with item type interactions
- Item types: ST, SO, TO, foil

## How to Run

1. Make sure you're in the `individual_analyses` folder
2. Run any analysis individually:
   ```R
   source("01_initial_study_position_analysis.R")
   ```

Each analysis will:
- Load the shared setup
- Load and prepare the necessary data
- Fit the appropriate GLMM model
- Run convergence diagnostics
- Generate summary statistics and trends
- Compute estimated marginal means and pairwise comparisons
- Save results as .rds and .csv files

## Output Files

Each analysis generates:
- `[analysis_name]_model.rds` - Full model object with all results including:
  - Fitted model object
  - Fixed effects summary
  - Linear trends (and quadratic for between-list analyses)
  - Estimated marginal means
  - Pairwise comparisons
- `[analysis_name]_summary.csv` - Fixed effects summary in CSV format

## Key Differences from Experiment 1

1. **Confusing Foils**: Experiment 3 includes inherited foils from previous lists, requiring special handling of study positions
2. **Item Types**: More complex item type categorization based on inheritance patterns
3. **Final Test Position Binning**: Final test positions are binned into 10 groups for between-list analyses
4. **Model Complexity**: Some models use linear-only trends while others include quadratic terms based on convergence considerations
