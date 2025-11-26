# Experiment 3: Data Structure and Naming Conventions

## Overview

This document explains the naming conventions and data structure used in Experiment 3 (E3) data files and analysis scripts.

## Position Variable Naming Convention

### General Pattern

Position variables follow the pattern: `{type}_{appearance}_{context}`

- **type**: `studyPos` (study position) or `testPos` (test position)
- **appearance**: `appear0`, `appear1`, or `appear2`
- **context**: `initial` (initial test phase) or `final` (final test phase)

### Appearance Numbers

- **`appear0`**: Position in the CURRENT list/trial (context-dependent)
- **`appear1`**: Position when the item appeared FIRST TIME (consistent across lists)
- **`appear2`**: Position when the item appeared SECOND TIME (consistent across lists)

### Key Rules

1. **Position 1 vs Position 2**:
   - When `appear1` = 1: This is the position where the item appeared first time
   - When `appear2` = 2: This is the position where the item appeared second time
   - In initial test, position 1 and position 2 values are consistent and don't change across lists

2. **Position 0 (ending with zero)**:
   - Variables ending with `0` (e.g., `testPos_appear0_initial`) represent the position in the CURRENT list
   - The same confusing foil gets different `xxx0` values in different lists when they appear initially vs. as confusing foils

3. **Final Test Considerations**:
   - In final test, trials are collapsed - confusing foils don't show twice but only once
   - Therefore, `xxx0` doesn't make sense for final test
   - Use `xxx1` or `xxx2` instead depending on which appearance you want to reference

## Item Type Naming Convention

### Current List Items (Non-Confusing)

- **SO**: Studied-only (appears only in current list)
- **TO**: Test-only (appears only in current list)
- **ST**: Studied and tested (appears only in current list)

### Confusing Foils from Previous List (n-1)

- **SO(n-1)**: Studied-only from list n-1, appears as confusing foil in list n
- **TO(n-1)**: Test-only from list n-1, appears as confusing foil in list n
- **ST(n-1)**: Studied and tested from list n-1, appears as confusing foil in list n

### Confusing Foils Reassigned to Next List (n+1)

- **SO(n)**: Studied-only from current list n, reassigned to serve as confusing foil in list n+1
- **TO(n)**: Test-only from current list n, reassigned to serve as confusing foil in list n+1
- **ST(n)**: Studied and tested from current list n, reassigned to serve as confusing foil in list n+1

## Position Usage Rules

### Initial Test

- **Test Position**: Use `testPos_appear0_initial` (position in current trial)
- **Study Position**: 
  - For most items: Use `studyPos_appear0_initial`
  - For confusing foils (Last Studied Only, Last Target): Use `studyPos_appear1_initial` (from previous trial)

### Final Test

#### Test Position

- **For confusing foils** (e.g., "Studied-only (n); Foil (n+1)", "Target: studied and tested at (n), Foil (n+1)", "Foil(n), Foil (n+1)"):
  - Should use `testPos_appear2_initial` (when they appeared as confusing foils in initial test)
  
- **For non-confusing foils** (e.g., "Foil(n); Appear once", "Studied-only (n); Appear once", "Target: : started and tested at (n) ; Appear once"):
  - Should use `testPos_appear1_initial` (their first appearance test position)

#### Study Position

- **For all items**: Always use `studyPos_appear1_initial` (first appearance study position)
  - Confusing foils either studied the first time they appeared, or they never studied
  - Study position is always from first appearance

## Data Columns in E3_AGGREGATED.csv

### Initial Test Columns

- `testPos_appear0_initial`: Test position in current trial
- `testPos_appear1_initial`: Test position when item first appeared
- `testPos_appear2_initial`: Test position when item appeared second time (as confusing foil)
- `studyPos_appear0_initial`: Study position in current trial
- `studyPos_appear1_initial`: Study position when item first appeared
- `studyPos_appear2_initial`: Study position when item appeared second time (usually 0)
- `listNum_appear0_initial`: List number in current trial
- `listNum_appear1_initial`: List number when item first appeared
- `listNum_appear2_initial`: List number when item appeared second time

### Final Test Columns

- `testPos_final`: Test position in final test (collapsed across all lists)
- `testPos_appear1_initial`: Test position when item first appeared (in initial test)
- `testPos_appear2_initial`: Test position when item appeared second time as confusing foil (in initial test)
- `studyPos_appear1_initial`: Study position when item first appeared
- `listNum_appear1_initial`: List number when item first appeared
- `listNum_appear2_initial`: List number when item appeared second time

### Item Type Columns

- `typecomment_in`: Item type label for initial test
- `type_comment_fn`: Item type label for final test

## Common Item Type Labels

### Initial Test (`typecomment_in`)

- "Target": Regular target
- "New Foil": Regular foil
- "Inherented Foil - Last Foil": Confusing foil from previous list (was foil)
- "Inherented Foil - Last Studied Only": Confusing foil from previous list (was studied-only)
- "Inherented Foil - Last Target": Confusing foil from previous list (was target)

### Final Test (`type_comment_fn`)

- "Target: : started and tested at (n) ; Appear once": Target that appeared only once
- "Target: studied and tested at (n), Foil (n+1)": Target that was confusing foil in next list
- "Foil(n); Appear once": Foil that appeared only once
- "Foil(n), Foil (n+1)": Foil that was confusing foil in next list
- "Studied-only (n); Appear once": Studied-only that appeared only once
- "Studied-only (n); Foil (n+1)": Studied-only that was confusing foil in next list
- "Final Foil": Foil that appears only in final test

## Plotting Guidelines

### Final Test Within-List Plots

When creating final test within-list plots, two sets of plots should be created:

1. **First Row - First Appearance Test Position**:
   - Test position: Use `testPos_appear1_initial` for all items
   - Study position: Use `studyPos_appear1_initial` for all items

2. **Second Row - Confusing Foil Test Position**:
   - Test position: 
     - For confusing foils: Use `testPos_appear2_initial`
     - For non-confusing foils: Use `testPos_appear1_initial`
   - Study position: Use `studyPos_appear1_initial` for all items

This allows comparison of how confusing foils perform when plotted by their first appearance position vs. their confusing foil appearance position.

## Examples

### Example 1: Confusing Foil in Initial Test

An item appears:
- First time: List 2, Study position 5, Test position 8
- Second time (as confusing foil): List 3, Test position 12

Then:
- `studyPos_appear1_initial` = 5 (first appearance)
- `testPos_appear1_initial` = 8 (first appearance)
- `testPos_appear2_initial` = 12 (second appearance as confusing foil)
- `studyPos_appear2_initial` = 0 (didn't study second time)

### Example 2: Final Test Plotting

For a confusing foil "Studied-only (n); Foil (n+1)" in final test:
- **First row plot**: Use `testPos_appear1_initial` = 8 (first appearance)
- **Second row plot**: Use `testPos_appear2_initial` = 12 (confusing foil appearance)
- **Both rows**: Use `studyPos_appear1_initial` = 5 (always first appearance)

## References

- E3 Git Repository: https://github.com/naszhu/REM_E3_model_fixed/
- Main plotting script: `design3/combined_plot_e3.r`








