# Experiment 2 (E3) Appendix Tables - README

<<<<<<< HEAD
This directory contains the generated appendix tables for Experiment 2 (E3) following the same format as Experiment 1.

## Files Created

1. **`generate_e3_appendix_tables.R`** - R script that reads the E3 aggregated data and generates summary statistics (means and standard errors) for all conditions and positions.

2. **`appendix_table_data_e3.csv`** - CSV file containing all the computed statistics (328 rows total):
   - Table E3.1: Initial Test - Between List (47 rows)
   - Table E3.2: Initial Test - Within List (64 rows)
   - Table E3.3: Final Test - Between List (70 rows)
   - Table E3.4: Final Test - Within List (147 rows)

3. **`generate_e3_appendix_markdown.R`** - R script that converts the CSV data into formatted markdown tables.

4. **`appendix_table_e3.md`** - Final markdown document with formatted tables ready for publication.

## Table Descriptions

### Table E3.1: Initial Test Performance by Initial List Number
- Shows accuracy for each probe type across the 10 initial lists
- Probe types: Target, New Foil, Inherented Foil (3 types)

### Table E3.2: Initial Test Performance by Within-List Position
- **Initial Study Position**: Shows accuracy by serial position during initial study (1-30, binned into 10 groups)
- **Initial Test Position**: Shows accuracy by serial position during initial test (1-30, binned into 10 groups)

### Table E3.3: Final Test Performance by Final Test Position
- Shows accuracy by position in the final recognition test (binned into 10 groups)
- Includes all 7 probe type conditions

### Table E3.4: Final Test Performance by Initial Position and List Number
- **Initial Study Position**: Final test accuracy broken down by initial study position
- **Initial Test Position**: Final test accuracy broken down by initial test position  
- **Initial List Number**: Final test accuracy broken down by initial list number

## Probe Types in E3

### Initial Test Probe Types:
- **Target**: Items studied and tested in the initial phase
- **New Foil**: Never-presented items (foils)
- **Inherented Foil - Last Target**: Items that were targets in list n-1 and foils in list n
- **Inherented Foil - Last Studied Only**: Items studied-only in list n-1 and foils in list n
- **Inherented Foil - Last Foil**: Items that were foils in list n-1 and foils in list n

### Final Test Probe Types:
- **Target: : started and tested at (n) ; Appear once**: Items studied and tested in initial phase
- **Target: studied and tested at (n), Foil (n+1)**: Items studied/tested in n, foils in n+1
- **Studied-only (n); Appear once**: Items only studied but not tested
- **Studied-only (n); Foil (n+1)**: Items studied-only in n, foils in n+1
- **Foil(n); Appear once**: Foils that appeared once
- **Foil(n), Foil (n+1)**: Foils that appeared in consecutive lists
- **Final Foil**: Never-seen foils at final test

## Methods

All statistics computed using:
1. **Within-subject aggregation**: First computed mean accuracy for each participant within each condition
2. **Between-subject aggregation**: Then computed grand means and standard errors across participants using `M = mean(participant_means)` and `SE = sd(participant_means) / sqrt(n_participants)`

This two-step process ensures that standard errors reflect between-subject variability, which is appropriate for reporting participant-level results.

## Position Binning

- **Initial test positions**: Original positions 1-30 were binned into 10 groups using `ceiling(position/3)`
- **Final test positions**: Original positions 1-492 were binned into 10 groups using pre-defined ranges (1-49, 50-98, etc.)

## Data Source

All data is drawn from:
```
/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/data/E3_AGGREGATED.csv
```

This file contains data from all participants who met inclusion criteria (see `design3/data_analysis/generate_data.r` for exclusion details).
=======
## Overview

This directory contains the generated appendix tables for Experiment 2 (E3) with proper APA formatting and standard abbreviations for probe types.

## Files Created

1. **`generate_e3_appendix_tables_v2.R`** - R script that processes E3 data and generates summary statistics with proper item type abbreviations

2. **`appendix_table_data_e3.csv`** - CSV file containing all computed statistics (328 rows):
   - Initial Test Between-List Effect: List Number (47 rows)
   - Initial Test Within-List Effect: Study Position (14 rows)
   - Initial Test Within-List Effect: Test Position (50 rows)
   - Final Test Between-List Effect: Final Test Position (70 rows)
   - Final Test Between-List Effect: Initial List Number (61 rows)
   - Final Test Within-List Effect: Initial Study Position (43 rows)
   - Final Test Within-List Effect: Initial Test Position (43 rows)

3. **`generate_e3_appendix_markdown_v2.R`** - R script that creates APA-formatted markdown tables (repeated values suppressed)

4. **`appendix_table_e3.md`** - Final markdown document with properly formatted tables

## Probe Type Abbreviations

### Standard Probe Types:
- **ST** = Study-Test: Items both studied and tested in the initial phase
- **SO** = Study-Only: Items studied but not tested in the initial phase  
- **TO** = Test-Only: Items presented as foils during testing
- **FTO** = Final Test Only: Never-presented items (new foils)

### Confusing Foils (with 'n' suffix):
These are items that appeared in different roles across consecutive lists (n and n+1):
- **STn** = Study-Test in list n, then foil in list n+1
- **SOn** = Study-Only in list n, then foil in list n+1
- **TOn** = Test-Only (foil) in list n, then foil in list n+1

## APA Formatting

The tables follow APA style guidelines:
- **Repeated values are suppressed**: When the same value appears in consecutive rows of the "Analysis" or "Condition" columns, it is shown only on the first occurrence
- **Compact presentation**: This reduces redundancy and makes tables easier to read
- **Clear hierarchy**: The suppression pattern makes the grouping structure immediately apparent

Example:
```
| Analysis | Condition | Probe Type | 1 | 2 | ...
|----------|-----------|------------|---|---|----
| Final Test Between-List Effect | Final Test Position | FTO | 0.76 (0.01) | 0.75 (0.02) | ...
|  |  | SO | 0.65 (0.02) | 0.65 (0.02) | ...
|  |  | ST | 0.86 (0.01) | 0.86 (0.01) | ...
```

## Analysis Types

### Initial Test
1. **Between-List Effect**: Performance across the 10 initial lists
   - Shows how learning progresses across successive lists
   
2. **Within-List Effect**: Performance by position within each initial list
   - **Study Position**: Serial position during study (1-30, binned into 10 groups)
   - **Test Position**: Serial position during initial test (1-30, binned into 10 groups)

### Final Test
3. **Between-List Effect**: Final test performance by temporal order
   - **Final Test Position**: Position in the final recognition test (binned into 10 groups)
   - **Initial List Number**: Performance by which initial list items came from (1-10)

4. **Within-List Effect**: Final test performance by initial positions
   - **Initial Study Position**: Items grouped by their study position in initial lists
   - **Initial Test Position**: Items grouped by their test position in initial lists

## Statistical Methods

All statistics computed using two-step aggregation:
1. **Within-subject aggregation**: Computed mean accuracy for each participant within each condition
2. **Between-subject aggregation**: Computed grand means and standard errors across participants
   - M = mean(participant_means)
   - SE = sd(participant_means) / sqrt(n_participants)

This approach ensures standard errors reflect between-subject variability, appropriate for participant-level inference.

## Position Binning

- **Initial test positions**: Original positions 1-30 binned into 10 groups using `ceiling(position/3)`
- **Final test positions**: Original positions 1-492 binned into 10 groups using predefined ranges:
  - Group 1: positions 1-49
  - Group 2: positions 50-98
  - Group 3: positions 99-147
  - ...and so on

## Data Source

All data drawn from:
```
design3/data/E3_AGGREGATED.csv
```

This file contains data from all participants meeting inclusion criteria (see `design3/data_analysis/generate_data.r` for exclusion details).
>>>>>>> oct-19-docs-side

## Usage

To regenerate the tables:
```bash
cd "Docs/appendix prepare"
<<<<<<< HEAD
Rscript generate_e3_appendix_tables.R
Rscript generate_e3_appendix_markdown.R
=======
Rscript generate_e3_appendix_tables_v2.R
Rscript generate_e3_appendix_markdown_v2.R
>>>>>>> oct-19-docs-side
```

## Notes

<<<<<<< HEAD
- All values in tables are reported as M (SE) format
- Position 0 represents foils (unstudied items) where applicable
- Missing cells (marked with —) indicate conditions where data is not applicable or available
- Standard errors are across-participant SEs, appropriate for inferential statistics

=======
- All values reported as M (SE) format
- Position 0 represents foils (unstudied items) where applicable
- Dash (—) indicates condition not applicable or data not available
- Tables ready for direct inclusion in manuscript appendix
>>>>>>> oct-19-docs-side
