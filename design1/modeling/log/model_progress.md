# Model Progress

## Commit [9e67c96](https://github.com/naszhu/REM_E3_model_fixed/commit/9e67c96) (branch: `oct-6`)
**Time:** 2025-10-07 13:23:18  
**Message:**
```
fix(plot-e3): enhance prediction plots with conditional data processing

fix  plote3 with some mistakes on poitn types and so on, and y axis

- Introduced checks for the existence of final predictions before processing data for test and study positions.
- Updated the plotting logic to conditionally create prediction plots based on the availability of data, improving robustness.
- Adjusted y-axis limits and breaks for better visualization consistency across plots.

These changes aim to enhance the functionality and reliability of the prediction plots in the design3 module.
```
**Changed Files:**
- `design1/combined_all_plots.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
- `design3/modeling`  
![](../plot_archive/9e67c96_20251007_132318_plot1.png)  
![](../plot_archive/9e67c96_20251007_132318_plot2.png)  

## Commit [e1e31b3](https://github.com/naszhu/REM_E3_model_fixed/commit/e1e31b3) (branch: `oct-6`)
**Time:** 2025-10-05 15:02:04  
**Message:**
```
merge(model-e1): Merge branch 'oct-3-new-e1-model'
```
![](../plot_archive/e1e31b3_20251005_150204_plot1.png)  
![](../plot_archive/e1e31b3_20251005_150204_plot2.png)  

## Commit [3fde0f2](https://github.com/naszhu/REM_E3_model_fixed/commit/3fde0f2) (branch: `oct-3-new-e1-model`)
**Time:** 2025-10-04 00:39:32  
**Message:**
```
finetune(model-e1): update simulation parameters for improved model accuracy

- Set is_finaltest to true and adjusted n_simulations to 500 for consistent testing conditions.
- Modified nnnow from 0.85 to 0.8 to refine model dynamics.
- Updated criterion_initial calculation parameters to enhance model precision.

These changes aim to improve the reliability and performance of the model in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/3fde0f2_20251004_003932_plot1.png)  
![](../plot_archive/3fde0f2_20251004_003932_plot2.png)  

## Commit [8085570](https://github.com/naszhu/REM_E3_model_fixed/commit/8085570) (branch: `oct-3-new-e1-model`)
**Time:** 2025-10-04 00:36:17  
**Message:**
```
fix(model-e1): A working version criterion change model and fix criterion change parmaeter setting issue

- Modified criterion_initial calculation to enhance model precision.
- Adjusted recall_odds_threshold from 0.17 to 0.08 for better decision-making.
- Updated the logic in memory restoration functions to use the new criterion variable.
- Changed the generation of the normalized range in utils.jl for improved parameter handling.

These changes aim to refine the model's performance and reliability in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/utils.jl`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/8085570_20251004_003617_plot1.png)  
![](../plot_archive/8085570_20251004_003617_plot2.png)  

## Commit [bd50b55](https://github.com/naszhu/REM_E3_model_fixed/commit/bd50b55) (branch: `oct-3-new-e1-model`)
**Time:** 2025-10-03 12:43:10  
**Message:**
```
explore(model-e1): update simulation parameters and criteria

- Reduced n_simulations from 2000 to 500 for efficiency in testing.
- Introduced criterion_initial using generate_asymptotic_values for improved model accuracy.
- Adjusted recall_odds_threshold from 0.17 to 0.08 to refine decision-making thresholds.
- Updated ratio_unchanging_to_itself_init to LinRange(1, 0.46, n_lists) for better parameter handling.

These changes aim to enhance the model's performance and reliability in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/module_jl/utils.jl`  
![](../plot_archive/bd50b55_20251003_124310_plot1.png)  
![](../plot_archive/bd50b55_20251003_124310_plot2.png)  

## Commit [7143346](https://github.com/naszhu/REM_E3_model_fixed/commit/7143346) (branch: `oct-3-new-e1-model`)
**Time:** 2025-10-01 20:37:45  
**Message:**
```
explore(model-e1): ratio UC go 100%

- Updated u_star_adv from 0 to 0.4 and c_adv from 0 to 0.15 to align with E3 specifications, enhancing model performance.
- Modified v_criterion_initial from 0.4 to 0.5 to improve the model's accuracy in simulations.
- Changed ratio_unchanging_to_itself_init to LinRange(1, 1, n_lists) for better parameter handling.

These adjustments aim to refine the model's behavior and ensure it meets expected outcomes more closely.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/7143346_20251001_203745_plot1.png)  
![](../plot_archive/7143346_20251001_203745_plot2.png)  

## Commit [c8c6d39](https://github.com/naszhu/REM_E3_model_fixed/commit/c8c6d39) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 17:52:24  
**Message:**
```
explore(model-e1): a test of not using Z feature.

- Adjusted v_criterion_initial from 0.14 to 0.4 to enhance model performance.
- Changed use_Z_feature from true to false to simplify model configuration.

These modifications aim to improve the accuracy and reliability of the model's simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/c8c6d39_20251001_175224_plot1.png)  
![](../plot_archive/c8c6d39_20251001_175224_plot2.png)  

## Commit [30d655b](https://github.com/naszhu/REM_E3_model_fixed/commit/30d655b) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 17:35:36  
**Message:**
```
finetune(model-e1):making u star 0.4

- Adjusted the u_star_v constant from a calculated value to a fixed value of 0.4 to improve model performance.
- This change aims to enhance the reliability of simulations by refining the parameters used in the model.

This update ensures that the model's behavior aligns more closely with expected outcomes.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/30d655b_20251001_173536_plot1.png)  
![](../plot_archive/30d655b_20251001_173536_plot2.png)  

## Commit [8496cf7](https://github.com/naszhu/REM_E3_model_fixed/commit/8496cf7) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 10:14:00  
**Message:**
```
fix(analysis-e3): add study position for confusing foils for analysis code

- Introduced separate handling for primary and alternate study positions to improve accuracy in data representation.
- Updated the logic for determining study position based on item type, ensuring more robust data processing for Experiment 3.
- Simplified the calculation of study positions, enhancing code clarity and maintainability.

This refactor strengthens the data preparation pipeline, facilitating better analysis of study position effects.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/8496cf7_20251001_101400_plot1.png)  
![](../plot_archive/8496cf7_20251001_101400_plot2.png)  

## Commit [f49c375](https://github.com/naszhu/REM_E3_model_fixed/commit/f49c375) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 10:13:24  
**Message:**
```
feat(analysis-e3): add pairwise comparison (again) bit potential but remain, why change first term?

- Introduced a new results file detailing the statistical analysis approach and findings from Experiment 2.
- Included detailed sections on initial test performance, between-list effects, and final test results, highlighting trends in memory performance across different item types and positions.
- Enhanced clarity and accessibility of results for future reference and analysis.

This addition significantly enriches the documentation of Experiment 2, providing a thorough overview of the findings and methodologies used.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E2_Results_Complete.txt`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/f49c375_20251001_101324_plot1.png)  
![](../plot_archive/f49c375_20251001_101324_plot2.png)  

## Commit [c68c2ec](https://github.com/naszhu/REM_E3_model_fixed/commit/c68c2ec) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 10:08:55  
**Message:**
```
fix(analysis-e3): Forgot to put study position for confusing foils

- Updated the data preparation for study positions by introducing alternate study position handling and grouping logic.
- Simplified the calculation of study position groups, improving clarity and maintainability of the code.
- Ensured that the new logic accommodates different types of comments for more accurate data representation.

This refactor enhances the robustness of the data processing pipeline for Experiment 3, facilitating better analysis of study position effects.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
![](../plot_archive/c68c2ec_20251001_100855_plot1.png)  
![](../plot_archive/c68c2ec_20251001_100855_plot2.png)  

## Commit [894bf6e](https://github.com/naszhu/REM_E3_model_fixed/commit/894bf6e) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 09:35:30  
**Message:**
```
feat(analysis-e1, analysis-e3): add pairwise comparisons and results to comprehensive analysis

- Introduced initial test item type comparisons for study position, test position, and between-list analyses in the comprehensive analysis script.
- Added functionality to compute and print estimated marginal means and pairwise comparisons using the `emmeans` package.
- Enhanced the trends list to include results from initial test comparisons, improving the overall analysis of item-type effects.

This update expands the analytical capabilities by providing detailed insights into initial test performance across different conditions.
```
**Changed Files:**
- `design1/data_analysis/experiment1_analysis_output.log`  
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/894bf6e_20251001_093530_plot1.png)  
![](../plot_archive/894bf6e_20251001_093530_plot2.png)  

## Commit [6fc8b56](https://github.com/naszhu/REM_E3_model_fixed/commit/6fc8b56) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-10-01 07:35:01  
**Message:**
```
finetune(model-e1): Making recall threshold > 0 , adjust criterion and drift between list

- Adjusted v_criterion_initial from 0.11 to 0.14 and recall_odds_threshold from 0.0 to 0.17

These changes enhance the model's accuracy and reliability in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/6fc8b56_20251001_073501_plot1.png)  
![](../plot_archive/6fc8b56_20251001_073501_plot2.png)  

## Commit [24d1e37](https://github.com/naszhu/REM_E3_model_fixed/commit/24d1e37) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 15:56:33  
**Message:**
```
feat(analysis-e3): simplify model specifications in GLMMs

- Updated model formulas in the comprehensive analysis script to remove unnecessary parentheses, enhancing readability and clarity.
- Maintained the structure of the models while ensuring that the interaction terms remain intact for accurate analysis of item-type effects.

This change streamlines the model definitions, making the code easier to understand and maintain.

Refs #39
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/24d1e37_20250930_155633_plot1.png)  
![](../plot_archive/24d1e37_20250930_155633_plot2.png)  

## Commit [fd27f8c](https://github.com/naszhu/REM_E3_model_fixed/commit/fd27f8c) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 13:44:13  
**Message:**
```
refactor(analysis-e3): replace robust model fitting function with direct GLMM calls

back to HEAD~1 and simplified version

- Removed the `fit_robust_glmer` function, simplifying the model fitting process by directly using `glmer` for initial test models.
- Updated model specifications to enhance clarity and maintainability, ensuring convergence diagnostics are still included.
- This change streamlines the analysis workflow for Experiment 3 while retaining essential model fitting capabilities.

Refs #39
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/fd27f8c_20250930_134413_plot1.png)  
![](../plot_archive/fd27f8c_20250930_134413_plot2.png)  

## Commit [9622c48](https://github.com/naszhu/REM_E3_model_fixed/commit/9622c48) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 13:42:10  
**Message:**
```
refactor(analysis-e3): replace robust model fitting function with direct GLMM calls

back to HEAD~1 and simplified version

- Removed the `fit_robust_glmer` function, simplifying the model fitting process by directly using `glmer` for initial test models.
- Updated model specifications to enhance clarity and maintainability, ensuring convergence diagnostics are still included.
- This change streamlines the analysis workflow for Experiment 3 while retaining essential model fitting capabilities.

Refs #39
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/9622c48_20250930_134210_plot1.png)  
![](../plot_archive/9622c48_20250930_134210_plot2.png)  

## Commit [e488e3b](https://github.com/naszhu/REM_E3_model_fixed/commit/e488e3b) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 13:06:18  
**Message:**
```
feat(analysis-e3): implement robust model fitting function for GLMMs

- Added a new function `fit_robust_glmer` to enhance model fitting with multiple optimizers and fallback strategies for Generalized Linear Mixed Models (GLMMs).
- Updated initial test models to utilize the new robust fitting function, improving convergence handling and model reliability.
- The function includes error handling and attempts simplified random effects if all optimizers fail, ensuring better model performance.

This enhancement significantly improves the robustness of model fitting in the analysis of Experiment 3.

Refs #39
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/e488e3b_20250930_130618_plot1.png)  
![](../plot_archive/e488e3b_20250930_130618_plot2.png)  

## Commit [b924652](https://github.com/naszhu/REM_E3_model_fixed/commit/b924652) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 12:44:54  
**Message:**
```
feat(analysis-e3): add comprehensive GLMM analysis for Experiment 3

- Introduced a new R script for a comprehensive analysis of Experiment 3 using Generalized Linear Mixed Models (GLMMs).
- Implemented data preparation steps for initial and final test datasets, including polynomial term creation and data validation.
- Developed models to analyze item-type-specific trends and included convergence diagnostics.
- Added functionality for post-hoc comparisons and trend significance tests, enhancing the analysis of recognition memory performance.
- Results and summaries are saved in both RDS and CSV formats for further reporting.

This addition significantly expands the analytical capabilities for Experiment 3, providing detailed insights into item performance across different conditions.

Refs #39
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/b924652_20250930_124454_plot1.png)  
![](../plot_archive/b924652_20250930_124454_plot2.png)  

## Commit [25d024e](https://github.com/naszhu/REM_E3_model_fixed/commit/25d024e) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 12:41:50  
**Message:**
```
feat(analysis-e3): add comprehensive GLMM analysis for Experiment 3

- Introduced a new R script for a comprehensive analysis of Experiment 3 using Generalized Linear Mixed Models (GLMMs).
- Implemented data preparation steps for initial and final test datasets, including polynomial term creation and data validation.
- Developed models to analyze item-type-specific trends and included convergence diagnostics.
- Added functionality for post-hoc comparisons and trend significance tests, enhancing the analysis of recognition memory performance.
- Results and summaries are saved in both RDS and CSV formats for further reporting.

This addition significantly expands the analytical capabilities for Experiment 3, providing detailed insights into item performance across different conditions.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3_analysis_comprehensive.R`  
![](../plot_archive/25d024e_20250930_124150_plot1.png)  
![](../plot_archive/25d024e_20250930_124150_plot2.png)  

## Commit [a73cd9c](https://github.com/naszhu/REM_E3_model_fixed/commit/a73cd9c) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 12:41:31  
**Message:**
```
fix(model-e1): introduce chunk_size_final_change for probe generation

- Added chunk_size_final_change constant to improve flexibility in probe generation logic.
- Updated the probe generation function to utilize the new constant instead of hardcoded values, enhancing maintainability and readability.

This change allows for easier adjustments to chunk sizes in future iterations.

Closes #43
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
![](../plot_archive/a73cd9c_20250930_124131_plot1.png)  
![](../plot_archive/a73cd9c_20250930_124131_plot2.png)  

## Commit [ee8b2d9](https://github.com/naszhu/REM_E3_model_fixed/commit/ee8b2d9) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 10:10:46  
**Message:**
```
finetune(model-e1):  align ratio init CC with E2

- Changed is_finaltest flag to false, adjusting n_simulations from 200 to 1000.
- Modified nnnow value from 0.88 to 0.85 to refine model behavior.
- Updated ratio_unchanging_to_itself_init from 0.3 to 0.46 for improved parameter alignment in simulations.

Refs #43
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/ee8b2d9_20250930_101046_plot1.png)  
![](../plot_archive/ee8b2d9_20250930_101046_plot2.png)  

## Commit [40f2614](https://github.com/naszhu/REM_E3_model_fixed/commit/40f2614) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-30 09:58:54  
**Message:**
```
finetune(model-e1):  align ratio init CC with E2

- Changed is_finaltest flag to false, adjusting n_simulations from 200 to 1000.
- Modified nnnow value from 0.88 to 0.85 to refine model behavior.
- Updated ratio_unchanging_to_itself_init from 0.3 to 0.46 for improved parameter alignment in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/40f2614_20250930_095854_plot1.png)  
![](../plot_archive/40f2614_20250930_095854_plot2.png)  

## Commit [f2e472a](https://github.com/naszhu/REM_E3_model_fixed/commit/f2e472a) (branch: `sep-30-finetune-some-parm`)
**Time:** 2025-09-29 14:39:39  
**Message:**
```
fix(logsr-e1): preserve model progress history after git rewrite

- Modified generate_md_from_json.py to only append newest commits instead of regenerating entire file
- Restored detailed commit messages from e6869c8 that were lost after history rewrite
- Prevents future loss of valuable commit documentation when old SHAs become invalid
- Script now preserves existing markdown content and only processes new entries

The issue occurred after a repository history rewrite to remove large R data files.
The rewrite invalidated all previous commit SHAs, causing the log generation script
to fail when trying to fetch commit messages with git show, defaulting to
"Unable to retrieve full message" for all historical entries.

Closes #42
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_md_from_json.py`  
![](../plot_archive/f2e472a_20250929_143939_plot1.png)  
![](../plot_archive/f2e472a_20250929_143939_plot2.png)  

## Commit [ec7f7ab](https://github.com/naszhu/REM_E3_model_fixed/commit/ec7f7ab) (branch: `main`)
**Time:** 2025-09-29 14:39:25  
**Message:**
```
fix(log-e1): preserve model progress history after git rewrite

- Modified generate_md_from_json.py to only append newest commits instead of regenerating entire file
- Restored detailed commit messages from e6869c8 that were lost after history rewrite
- Prevents future loss of valuable commit documentation when old SHAs become invalid
- Script now preserves existing markdown content and only processes new entries

The issue occurred after a repository history rewrite to remove large R data files.
The rewrite invalidated all previous commit SHAs, causing the log generation script
to fail when trying to fetch commit messages with git show, defaulting to
"Unable to retrieve full message" for all historical entries.

Closes #42
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_md_from_json.py`  
![](../plot_archive/ec7f7ab_20250929_143925_plot1.png)  
![](../plot_archive/ec7f7ab_20250929_143925_plot2.png)  

## Commit [61b0deb](https://github.com/naszhu/REM_E3_model_fixed/commit/61b0deb) (branch: `main`)
**Time:** 2025-09-29 14:38:14  
**Message:**
```
fix(hooks): preserve model progress history after git rewrite

- Modified generate_md_from_json.py to only append newest commits instead of regenerating entire file
- Restored detailed commit messages from e6869c8 that were lost after history rewrite
- Prevents future loss of valuable commit documentation when old SHAs become invalid
- Script now preserves existing markdown content and only processes new entries

The issue occurred after a repository history rewrite to remove large R data files.
The rewrite invalidated all previous commit SHAs, causing the log generation script
to fail when trying to fetch commit messages with git show, defaulting to
"Unable to retrieve full message" for all historical entries.

Closes #42
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_md_from_json.py`  
![](../plot_archive/61b0deb_20250929_143814_plot1.png)  
![](../plot_archive/61b0deb_20250929_143814_plot2.png)  

## Commit [0cbfdb6](https://github.com/naszhu/REM_E3_model_fixed/commit/0cbfdb6) (branch: `main`)
**Time:** 2025-09-29 14:35:51  
**Message:**
```
fix(log-e1): restore the model_progress merge sep-28-analysis without large R data files
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/0cbfdb6_20250929_143551_plot1.png)  
![](../plot_archive/0cbfdb6_20250929_143551_plot2.png)  

## Commit [b46bb21](https://github.com/naszhu/REM_E3_model_fixed/commit/b46bb21) (branch: `main`)
**Time:** 2025-09-29 14:31:35  
**Message:**
```
fix(log-e1): restore the model_progress merge sep-28-analysis without large R data files
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/b46bb21_20250929_143135_plot1.png)  
![](../plot_archive/b46bb21_20250929_143135_plot2.png)  

## Commit [2c66c90](https://github.com/naszhu/REM_E3_model_fixed/commit/2c66c90) (branch: `main`)
**Time:** 2025-09-28 22:20:45  
**Message:**
```
merge(analysis-e1): Merge branch 'sep-28-analysis'
```
![](../plot_archive/2c66c90_20250928_222045_plot1.png)  
![](../plot_archive/2c66c90_20250928_222045_plot2.png)  

## Commit [e0120fc](https://github.com/naszhu/REM_E3_model_fixed/commit/e0120fc) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 21:33:57  
**Message:**
```
feat(analysis-e1): simplify final test models and enhance reporting

- Removed complex models in favor of simplified linear-only models for final test analyses to improve convergence reliability.
- Updated the comprehensive report to reflect the use of simplified models, emphasizing the importance of model selection for robust results.
- Enhanced item-type-specific comparisons and post-hoc analyses, providing clearer insights into performance hierarchies across conditions.
- Saved the updated results in a new RDS file for simplified models, ensuring better accessibility for future reporting.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_comprehensive_report.md`  
- `design1/data_analysis/experiment1_glmm_simplified.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e0120fc_20250928_213357_plot1.png)  
![](../plot_archive/e0120fc_20250928_213357_plot2.png)  

## Commit [e884ac3](https://github.com/naszhu/REM_E3_model_fixed/commit/e884ac3) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 20:57:30  
**Message:**
```
feat(anlaysis-e1-report): refine final test phase analysis with model convergence insights

- Updated the final test phase section to clarify model convergence issues and the justification for retaining complex quadratic models despite warnings.
- Enhanced the within-study and within-test position effects analyses, revealing significant quadratic trends and item-type-specific performance patterns.
- Expanded the discussion on methodological considerations, emphasizing the importance of model comparison in guiding analysis decisions.
- Improved overall clarity and structure of the report to facilitate better interpretation of findings related to recognition memory.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_report.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e884ac3_20250928_205730_plot1.png)  
![](../plot_archive/e884ac3_20250928_205730_plot2.png)  

## Commit [e31e505](https://github.com/naszhu/REM_E3_model_fixed/commit/e31e505) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 20:37:24  
**Message:**
```
feat(analysis-e1-report): update comprehensive report with refined analyses and findings

- Added details on simplified models for final test within-session analyses due to convergence issues, emphasizing the necessity of linear trends.
- Expanded between-session models to include experimental condition factors, revealing complex three-way interactions affecting performance.
- Enhanced discussion section to reflect new findings on item-type-specific trends and methodological considerations regarding model complexity.
- Improved overall clarity and structure of the report, facilitating better interpretation of results and implications for recognition memory research.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_report.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e31e505_20250928_203724_plot1.png)  
![](../plot_archive/e31e505_20250928_203724_plot2.png)  

## Commit [929ffbb](https://github.com/naszhu/REM_E3_model_fixed/commit/929ffbb) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 20:05:22  
**Message:**
```
feat(analysis-e1): implement simplified models and model comparisons

- Added simplified versions of the final within-study, within-test, between-final, and between-initial models to enhance model interpretability and reduce complexity.
- Integrated model comparison analyses using ANOVA to evaluate the significance of quadratic terms and interactions, providing insights into model fit.
- Updated results saving process to include summaries for both original and simplified models, improving accessibility for reporting.
- Enhanced convergence diagnostics and error handling during model comparisons, ensuring robust analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full_with_interactions.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/929ffbb_20250928_200522_plot1.png)  
![](../plot_archive/929ffbb_20250928_200522_plot2.png)  

## Commit [e418375](https://github.com/naszhu/REM_E3_model_fixed/commit/e418375) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 19:47:07  
**Message:**
```
feat(analysis-e1): add convergence diagnostics and data validation functions

- Introduced functions to check model convergence issues and validate position data, enhancing the robustness of the analysis.
- Implemented validation checks for unique values in position variables to ensure adequate data for polynomial term creation.
- Integrated convergence diagnostics into model fitting processes for initial and final tests, improving error handling and model reliability.
- Updated the analysis script to include these new functionalities, facilitating better interpretation of model performance and data integrity.

Refs #39
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e418375_20250928_194707_plot1.png)  
![](../plot_archive/e418375_20250928_194707_plot2.png)  

## Commit [1f55436](https://github.com/naszhu/REM_E3_model_fixed/commit/1f55436) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 19:36:25  
**Message:**
```
feat(analysis-e1): enhance final test data analysis with condition interactions and diagnostics

fixed the within-list partial problems but have convergence warining

- Updated the final test data preparation to include the 'condition' variable, improving model specifications for GLMM analyses.
- Expanded model formulas to incorporate interactions between item type and condition for both final order and initial order analyses.
- Added diagnostic analysis for within-list study position discrepancies, including effect size checks and model predictions visualization.
- Implemented a convergence check for all models, with retry mechanisms for failed convergence, enhancing robustness of the analysis workflow.
- Improved overall script organization and clarity, facilitating better interpretation of results and future updates.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full_with_interactions.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/1f55436_20250928_193625_plot1.png)  
![](../plot_archive/1f55436_20250928_193625_plot2.png)  

## Commit [72c5f36](https://github.com/naszhu/REM_E3_model_fixed/commit/72c5f36) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 17:30:18  
**Message:**
```
feat(analysis-e1-report): add comprehensive report on item-type-specific serial position effects in recognition memory

- Introduced a new markdown report detailing findings from a study on recognition memory, utilizing generalized linear mixed models (GLMM).
- Included sections on abstract, method, results, discussion, and references, summarizing key insights on item-type-specific trends and performance patterns.
- Highlighted significant findings regarding the differential effects of item types on serial position performance during initial and final testing phases.
- Provided a structured format for future updates and references, enhancing the documentation of research outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_report.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/72c5f36_20250928_173018_plot1.png)  
![](../plot_archive/72c5f36_20250928_173018_plot2.png)  

## Commit [74502d6](https://github.com/naszhu/REM_E3_model_fixed/commit/74502d6) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 17:07:15  
**Message:**
```
feat(analysis-e1):  in solving the convergency, take less terms

But might still be too much to ask?

- Implemented final GLMM models for within-list and between-list analyses, incorporating polynomial terms for study and test positions.
- Streamlined the results saving process to include comprehensive summaries and trends, improving accessibility for reporting.
- Added functionality to export model summaries and item-type trends to CSV files for better data management and interpretation.
- Enhanced overall script organization and clarity, ensuring a more efficient analysis workflow.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full_with_interactions.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/74502d6_20250928_170715_plot1.png)  
![](../plot_archive/74502d6_20250928_170715_plot2.png)  

## Commit [bdc8798](https://github.com/naszhu/REM_E3_model_fixed/commit/bdc8798) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 16:53:00  
**Message:**
```
feat(analysis-e1): enhance polynomial term creation and streamline model handling

The version that doesn't converge but more thorough (partially suggested by deepseek)

- Improved the `create_polynomial_terms` function to handle NA values more effectively and set proper column names for output.
- Added additional libraries for data manipulation and streamlined the data loading process.
- Commented out unused model fitting code to improve clarity and focus on relevant analyses.
- Enhanced the overall structure of the analysis script for better readability and maintainability.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/bdc8798_20250928_165300_plot1.png)  
![](../plot_archive/bdc8798_20250928_165300_plot2.png)  

## Commit [030a7ec](https://github.com/naszhu/REM_E3_model_fixed/commit/030a7ec) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 16:23:35  
**Message:**
```
feat(analysis-e1): introduce comprehensive analysis script for GLMM with item-type-specific trends

This v have checked that the data was correct

- Added a new script for comprehensive analysis, implementing GLMM models with item-type-specific interactions.
- Enhanced data preparation processes, including improved handling of missing values and polynomial term creation.
- Streamlined initial and final test data analysis, ensuring proper model specifications and convergence checks.
- Included visualizations for performance trends across test positions and item types, facilitating better interpretation of results.
- Saved analysis outputs in structured formats for easier access and reporting.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_comprehensive_analysis_tempsave_plotdatacheck.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/030a7ec_20250928_162335_plot1.png)  
![](../plot_archive/030a7ec_20250928_162335_plot2.png)  

## Commit [771e0ae](https://github.com/naszhu/REM_E3_model_fixed/commit/771e0ae) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 16:10:18  
**Message:**
```
feat(analysis-e1): refine comprehensive analysis with enhanced data handling and model specifications

(uncompleted)

- Updated the data loading process to use an absolute path for the dfchanged dataset, ensuring consistent access.
- Simplified the calculation of study and test positions by removing unnecessary coalescing and warnings.
- Enhanced the final test data preparation by creating initial position data and a lookup table for study and test positions.
- Improved model specifications for within-list and between-list analyses, incorporating polynomial terms and ensuring proper convergence checks.
- Streamlined the results saving process to include new summaries and trends, facilitating better interpretation of analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/771e0ae_20250928_161018_plot1.png)  
![](../plot_archive/771e0ae_20250928_161018_plot2.png)  

## Commit [e6c7f9b](https://github.com/naszhu/REM_E3_model_fixed/commit/e6c7f9b) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 15:13:36  
**Message:**
```
feat(analysis-e1): enhance comprehensive analysis with item-type-specific trends

- Updated the comprehensive analysis script to include item-type-specific interactions in GLMM models.
- Streamlined data preparation for initial and final test datasets, ensuring proper handling of missing values and participant identifiers.
- Added functionality for calculating and saving item-type-specific linear trends using emtrends.
- Refined results saving process to include new summaries and trends, improving accessibility and interpretation of analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e6c7f9b_20250928_151336_plot1.png)  
![](../plot_archive/e6c7f9b_20250928_151336_plot2.png)  

## Commit [d1b6b5a](https://github.com/naszhu/REM_E3_model_fixed/commit/d1b6b5a) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 14:28:46  
**Message:**
```
feat(analysis-e1): update comprehensive analysis script for clarity and efficiency

- Renamed sections and variables for improved readability and organization.
- Replaced helper functions for polynomial term creation and model fitting to enhance clarity and ensure proper convergence checks.
- Streamlined data preparation for initial and final test datasets, focusing on accuracy and handling of missing values.
- Updated model specifications to utilize polynomial terms and adjusted for participant identifiers.
- Results saving process refined for better accessibility and interpretation of analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/d1b6b5a_20250928_142846_plot1.png)  
![](../plot_archive/d1b6b5a_20250928_142846_plot2.png)  

## Commit [5ba78cd](https://github.com/naszhu/REM_E3_model_fixed/commit/5ba78cd) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 12:59:58  
**Message:**
```
feat(analysis-e1): streamline data analysis script and enhance model fitting

Have problems of fail to converge, and some rows are discarded need to check why and how

- Refactored the comprehensive analysis script to improve data loading and preprocessing, including renaming variables for clarity.
- Updated helper functions for polynomial term creation and model fitting, ensuring convergence checks are integrated.
- Enhanced data preparation for initial and final test datasets, focusing on accuracy and scaling of study and test positions.
- Improved model specifications for initial and final analyses, incorporating polynomial terms and adjusting for item types and conditions.
- Results are now saved in a structured format, facilitating easier access and interpretation of analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/5ba78cd_20250928_125958_plot1.png)  
![](../plot_archive/5ba78cd_20250928_125958_plot2.png)  

## Commit [7bedbec](https://github.com/naszhu/REM_E3_model_fixed/commit/7bedbec) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 12:42:27  
**Message:**
```
feat(analysis-e1): add initial and final test data analysis results and workspace

Complicated version, after fixing mistake of left_join for final test between list (won't need left join), but might not need the item term in the model either will work later

- Introduced new binary files for storing analysis results and workspace data related to Experiment 1.
- Updated the comprehensive analysis script to streamline data loading, preprocessing, and model fitting for initial and final test analyses.
- Enhanced data preparation steps, including polynomial term creation and filtering for accuracy, to improve analysis clarity and efficiency.
- These changes facilitate a more organized approach to data analysis and result storage for Experiment 1.
```
**Changed Files:**
- `design1/data_analysis/experiment1_analysis_results.rds`  
- `design1/data_analysis/experiment1_analysis_workspace.RData`  
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full.rds`  
- `design1/data_analysis/experiment1_glmm_results.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/7bedbec_20250928_124227_plot1.png)  
![](../plot_archive/7bedbec_20250928_124227_plot2.png)  

## Commit [31dc4a3](https://github.com/naszhu/REM_E3_model_fixed/commit/31dc4a3) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 12:37:55  
**Message:**
```
feat(analysis-e1): add initial and final test data analysis results and workspace

Complicated version, after fixing mistake of left_join for final test between list (won't need left join), but might not need the item term in the model either will work later

- Introduced new binary files for storing analysis results and workspace data related to Experiment 1.
- Updated the comprehensive analysis script to streamline data loading, preprocessing, and model fitting for initial and final test analyses.
- Enhanced data preparation steps, including polynomial term creation and filtering for accuracy, to improve analysis clarity and efficiency.
- These changes facilitate a more organized approach to data analysis and result storage for Experiment 1.
```
**Changed Files:**
- `design1/data_analysis/experiment1_analysis_results.rds`  
- `design1/data_analysis/experiment1_analysis_workspace.RData`  
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/experiment1_glmm_full.rds`  
- `design1/data_analysis/experiment1_glmm_results.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/31dc4a3_20250928_123755_plot1.png)  
![](../plot_archive/31dc4a3_20250928_123755_plot2.png)  

## Commit [a931107](https://github.com/naszhu/REM_E3_model_fixed/commit/a931107) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 12:30:14  
**Message:**
```
feat(analysis-e1): add initial and final test data analysis results and workspace

Complicated version, after fixing mistake of left_join for final test between list (won't need left join), but might not need the item term in the model either will work later

- Introduced new binary files for storing analysis results and workspace data related to Experiment 1.
- Updated the comprehensive analysis script to streamline data loading, preprocessing, and model fitting for initial and final test analyses.
- Enhanced data preparation steps, including polynomial term creation and filtering for accuracy, to improve analysis clarity and efficiency.
- These changes facilitate a more organized approach to data analysis and result storage for Experiment 1.
```
**Changed Files:**
- `design1/data_analysis/experiment1_analysis_results.rds`  
- `design1/data_analysis/experiment1_analysis_workspace.RData`  
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a931107_20250928_123014_plot1.png)  
![](../plot_archive/a931107_20250928_123014_plot2.png)  

## Commit [12a33ed](https://github.com/naszhu/REM_E3_model_fixed/commit/12a33ed) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 11:46:07  
**Message:**
```
feat(analysis-e1): enhance data analysis with new debug script and updated .gitignore

- Added a new debug script (debug_data.R) to facilitate data structure checks and ensure data integrity during analysis.
- Updated .gitignore to include all PNG files across directories, streamlining file management and preventing unnecessary files from being tracked.
- These changes improve the overall analysis workflow and maintain a cleaner project structure.
```
**Changed Files:**
- `.gitignore`  
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/data_analysis/E1-comprehensive-analysis.R`  
- `design1/data_analysis/E1-final-test-GLMM-analysis.R`  
- `design1/data_analysis/E1-final-test-fast-analysis.R`  
- `design1/data_analysis/E1-final-test-simplified-GLMM.R`  
- `design1/data_analysis/E1-simplified-analysis.R`  
- `design1/data_analysis/debug_data.R`  
- `design1/data_analysis/experiment1_comprehensive_analysis.R`  
- `design1/data_analysis/results/experiment1_analysis_results.RData`  
- `design1/data_analysis/results/experiment1_results_summary.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/12a33ed_20250928_114607_plot1.png)  
![](../plot_archive/12a33ed_20250928_114607_plot2.png)  

## Commit [c82f31e](https://github.com/naszhu/REM_E3_model_fixed/commit/c82f31e) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 10:52:08  
**Message:**
```
feat(analysis-e1): expand final test analysis with new scripts and detailed GLMM models

- Added new R scripts for fast and simplified GLMM analyses of final test performance, enhancing the overall analytical framework.
- Updated E1-Analysis-Report.md to reflect new findings and methodologies, including detailed sections on within-list and between-list effects.
- Removed outdated files to streamline the analysis process and improve clarity in the project structure.
- These changes provide a more comprehensive understanding of recognition performance across different exposure histories and test conditions.
```
**Changed Files:**
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/data_analysis/E1-comprehensive-analysis.R`  
- `design1/data_analysis/E1-final-test-GLMM-analysis.R`  
- `design1/data_analysis/E1-final-test-fast-analysis.R`  
- `design1/data_analysis/E1-final-test-simplified-GLMM.R`  
- `design1/data_analysis/Experiment1_Professional_Manuscript_Results.txt`  
- `design1/data_analysis/final_professional_analysis.R`  
- `design1/data_analysis/final_results_summary.txt`  
- `design1/data_analysis/overall_testpos_results.rds`  
- `design1/data_analysis/streamlined_glmm_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/c82f31e_20250928_105208_plot1.png)  
![](../plot_archive/c82f31e_20250928_105208_plot2.png)  

## Commit [de0bddb](https://github.com/naszhu/REM_E3_model_fixed/commit/de0bddb) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 09:54:56  
**Message:**
```
feat(analysis-e1): enhance final test analysis with GLMM and exposure history effects

- Updated E1-Analysis-Report.md to include GLMM analysis for final test performance, detailing effects of study position and exposure history.
- Added new sections in E1-comprehensive-analysis.R for final test exposure history effects, including separate GLMM models for each exposure type.
- Introduced a new binary file overall_testpos_results.rds to store results from the final test position analysis.
- These changes improve the depth of analysis and provide clearer insights into recognition performance trends across different conditions.
```
**Changed Files:**
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/data_analysis/E1-comprehensive-analysis.R`  
- `design1/data_analysis/overall_testpos_results.rds`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/de0bddb_20250928_095456_plot1.png)  
![](../plot_archive/de0bddb_20250928_095456_plot2.png)  

## Commit [3b9a65c](https://github.com/naszhu/REM_E3_model_fixed/commit/3b9a65c) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 09:44:51  
**Message:**
```
feat(analysis-e1): add overall performance analysis to comprehensive analysis script

- Introduced a new section in E1-comprehensive-analysis.R to analyze overall performance across test positions, including both pure and adjusted trends.
- Implemented mixed-effects logistic regression models to evaluate accuracy based on test position, item type, and condition.
- Calculated and reported descriptive statistics for early and late test positions, enhancing the depth of analysis in the report.
- Updated E1-Analysis-Report.md to reflect the new findings on overall performance trends.
```
**Changed Files:**
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/data_analysis/E1-comprehensive-analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/3b9a65c_20250928_094451_plot1.png)  
![](../plot_archive/3b9a65c_20250928_094451_plot2.png)  

## Commit [91c5cc6](https://github.com/naszhu/REM_E3_model_fixed/commit/91c5cc6) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 09:21:32  
**Message:**
```
refactor(analysis-e1): remove bold formatting for improved readability in E1 analysis report

- Simplified the text by removing bold formatting from key terms and phrases throughout the E1-Analysis-Report.md file.
- This change enhances the overall readability and presentation of the report without altering the content or meaning.
```
**Changed Files:**
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/91c5cc6_20250928_092132_plot1.png)  
![](../plot_archive/91c5cc6_20250928_092132_plot2.png)  

## Commit [9250c88](https://github.com/naszhu/REM_E3_model_fixed/commit/9250c88) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 09:16:40  
**Message:**
```
feat(analysis-e1): add comprehensive and simplified analysis scripts for Experiment 1

- Introduced two new R scripts: E1-comprehensive-analysis.R and E1-simplified-analysis.R, to perform detailed and simplified analyses of recognition memory data.
- The comprehensive script includes mixed-effects logistic regression models for within-list and between-list effects, along with detailed statistical summaries.
- The simplified script provides descriptive statistics and key model summaries for initial and final test performance, enhancing accessibility of results.
- Both scripts save results to CSV files for easy access and further analysis.
```
**Changed Files:**
- `design1/data_analysis/E1-Analysis-Report.md`  
- `design1/data_analysis/E1-comprehensive-analysis.R`  
- `design1/data_analysis/E1-simplified-analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/9250c88_20250928_091640_plot1.png)  
![](../plot_archive/9250c88_20250928_091640_plot2.png)  

## Commit [a2f6ebe](https://github.com/naszhu/REM_E3_model_fixed/commit/a2f6ebe) (branch: `sep-28-analysis`)
**Time:** 2025-09-28 09:02:05  
**Message:**
```
refactor(analysis-e1, analysis-e3): remove grid lines for improved plot aesthetics

- Updated multiple R scripts to eliminate major and minor grid lines in ggplot themes, enhancing visual clarity.
- Adjusted plot themes across various analysis scripts to create a more cohesive and minimalistic design.
- These changes aim to improve the overall presentation of visualizations in the analysis.
```
**Changed Files:**
- `design1/combined_finaltest_between_list.R`  
- `design1/combined_finaltest_within_list.R`  
- `design1/combined_initial_between_list.R`  
- `design1/combined_initial_within_list.R`  
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/data_analysis/E1-finaltest-within-list.R`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/E1-initial-within-list.R`  
- `design1/data_analysis/E1-participant-performance-plots.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
![](../plot_archive/a2f6ebe_20250928_090205_plot1.png)  
![](../plot_archive/a2f6ebe_20250928_090205_plot2.png)  

## Commit [54ee98c](https://github.com/naszhu/REM_E3_model_fixed/commit/54ee98c) (branch: `main`)
**Time:** 2025-09-28 08:46:47  
**Message:**
```
feat(analysis-e1, analysis-e3): enhance plot themes and aesthetics across multiple scripts

- Updated ggplot themes in various analysis scripts to use minimal themes, improving visual clarity by removing grid lines.
- Adjusted font sizes and styling for axis titles, text, and legends to enhance readability.
- Introduced a new script for participant performance analysis, calculating overall performance metrics and generating visualizations for initial and final tests.
- These changes aim to provide a more cohesive and visually appealing representation of participant performance data.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/data_analysis/E1-finaltest-within-list.R`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/E1-initial-within-list.R`  
- `design1/data_analysis/E1-participant-performance-plots (2).R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
- `design3/data_analysis/E3-participant-performance-plots.r`  
![](../plot_archive/54ee98c_20250928_084647_plot1.png)  
![](../plot_archive/54ee98c_20250928_084647_plot2.png)  

## Commit [b569368](https://github.com/naszhu/REM_E3_model_fixed/commit/b569368) (branch: `main`)
**Time:** 2025-09-28 08:32:36  
**Message:**
```
feat(analysis-e3): update plot formatting constants for enhanced visualization

- Increased font sizes for plot titles, axis titles, and strip text to improve readability.
- Adjusted point sizes and line widths for better clarity in visualizations.
- Modified plot height to enhance presentation quality.
- These changes aim to provide a more visually appealing and cohesive analysis of participant performance in the E3 context.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
![](../plot_archive/b569368_20250928_083236_plot1.png)  
![](../plot_archive/b569368_20250928_083236_plot2.png)  

## Commit [ec612bd](https://github.com/naszhu/REM_E3_model_fixed/commit/ec612bd) (branch: `main`)
**Time:** 2025-09-28 08:32:26  
**Message:**
```
feat(analysis-e3): add participant performance analysis and visualization

- Introduced a new script for analyzing participant performance in initial and final tests.
- Calculated overall performance metrics for each participant and filtered results based on performance thresholds.
- Created visualizations for both tests, enhancing clarity with improved ggplot themes and styling.
- Saved performance data and generated combined plots for comprehensive analysis.
- This addition aims to provide insights into participant performance trends across different test conditions.
```
**Changed Files:**
- `design1/data_analysis/E1-participant-performance-plots.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/E3-participant-performance-plots.r`  
- `design3/modeling`  
![](../plot_archive/ec612bd_20250928_083226_plot1.png)  
![](../plot_archive/ec612bd_20250928_083226_plot2.png)  

## Commit [517d49d](https://github.com/naszhu/REM_E3_model_fixed/commit/517d49d) (branch: `main`)
**Time:** 2025-09-28 08:32:00  
**Message:**
```
feat(analysis-e3): enhance final test between list data visualization

- Introduced plot formatting constants for improved readability and maintainability of the final test between list analysis script.
- Adjusted font sizes, point sizes, and line widths to enhance the clarity of visualizations.
- Unified ggplot themes and axis scales to ensure consistent styling across plots.
- Updated the export dimensions for the final test between list plot to improve presentation quality.
- These changes aim to provide a more cohesive and visually appealing analysis of correct response rates in the final test between list context.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
![](../plot_archive/517d49d_20250928_083200_plot1.png)  
![](../plot_archive/517d49d_20250928_083200_plot2.png)  

## Commit [517d49d](https://github.com/naszhu/REM_E3_model_fixed/commit/517d49d) (branch: `main`)
**Time:** 2025-09-28 08:32:00  
**Message:**
```
feat(analysis-e3): enhance final test between list data visualization

- Introduced plot formatting constants for improved readability and maintainability of the final test between list analysis script.
- Adjusted font sizes, point sizes, and line widths to enhance the clarity of visualizations.
- Unified ggplot themes and axis scales to ensure consistent styling across plots.
- Updated the export dimensions for the final test between list plot to improve presentation quality.
- These changes aim to provide a more cohesive and visually appealing analysis of correct response rates in the final test between list context.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/combined_plot_e3.r`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
![](../plot_archive/517d49d_20250928_083200_plot1.png)  
![](../plot_archive/517d49d_20250928_083200_plot2.png)  

## Commit [43467be](https://github.com/naszhu/REM_E3_model_fixed/commit/43467be) (branch: `main`)
**Time:** 2025-09-25 14:58:46  
**Message:**
```
refactor(dataplot-e1): update subproject commit and enhance plot aesthetics in analysis scripts

- Updated the subproject commit reference for consistency.
- Introduced plot formatting constants in both initial and final test analysis scripts to improve readability and maintainability.
- Adjusted point sizes and y-axis scales for better visualization clarity.
- Unified ggplot themes across scripts to ensure consistent styling in visualizations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_within_list_data_e3.r`  
- `design3/data_analysis/initial_test_within_list_data_e3.r`  
- `design3/modeling`  
![](../plot_archive/43467be_20250925_145846_plot1.png)  
![](../plot_archive/43467be_20250925_145846_plot2.png)  

## Commit [6b98324](https://github.com/naszhu/REM_E3_model_fixed/commit/6b98324) (branch: `main`)
**Time:** 2025-09-25 13:21:15  
**Message:**
```
refactor(constants): consolidate plot formatting constants into analysis script

- Removed the dedicated plot_constants.R file and integrated the plot formatting constants directly into the initial test analysis script.
- This change enhances the accessibility of constants within the analysis context, improving code readability and maintainability.
- The constants include font sizes, point sizes, line widths, plot dimensions, and a unified ggplot theme for consistent styling across visualizations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
- `design3/plot_constants.R`  
![](../plot_archive/6b98324_20250925_132115_plot1.png)  
![](../plot_archive/6b98324_20250925_132115_plot2.png)  

## Commit [9c1af3a](https://github.com/naszhu/REM_E3_model_fixed/commit/9c1af3a) (branch: `main`)
**Time:** 2025-09-25 13:20:12  
**Message:**
```
feat(constants): add plot formatting constants for consistent styling

- Introduced a new R script to define constants for plot formatting, including font sizes, point sizes, line widths, and plot dimensions.
- Implemented a unified theme for ggplot visualizations to ensure consistent styling across all plots.
- Updated the initial test analysis script to utilize these constants, enhancing readability and maintainability of the code.
- These changes aim to improve the visual consistency and clarity of plots in the analysis.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
- `design3/plot_constants.R`  
![](../plot_archive/9c1af3a_20250925_132012_plot1.png)  
![](../plot_archive/9c1af3a_20250925_132012_plot2.png)  

## Commit [4c52ca7](https://github.com/naszhu/REM_E3_model_fixed/commit/4c52ca7) (branch: `main`)
**Time:** 2025-09-25 13:19:01  
**Message:**
```
refactor(analysis-e3): adjust y-axis scale for improved data visualization

- Updated the y-axis scale in the initial test plot to enhance clarity, changing the breaks to range from 0.4 to 0.9 and adjusting limits accordingly.
- This change aims to provide a more accurate representation of response rates in the visual analysis.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
![](../plot_archive/4c52ca7_20250925_131901_plot1.png)  
![](../plot_archive/4c52ca7_20250925_131901_plot2.png)  

## Commit [9261d2c](https://github.com/naszhu/REM_E3_model_fixed/commit/9261d2c) (branch: `main`)
**Time:** 2025-09-25 12:14:56  
**Message:**
```
merge(predplot-e1,e3): Merge branch 'sep12-analysisplot'
```
![](../plot_archive/9261d2c_20250925_121456_plot1.png)  
![](../plot_archive/9261d2c_20250925_121456_plot2.png)  

## Commit [b654343](https://github.com/naszhu/REM_E3_model_fixed/commit/b654343) (branch: `main`)
**Time:** 2025-09-11 01:37:57  
**Message:**
```
merge(predplot-e1): Merge branch 'sep-10-predplot'
```
![](../plot_archive/b654343_20250911_013757_plot1.png)  
![](../plot_archive/b654343_20250911_013757_plot2.png)  

## Commit [a34ab7a](https://github.com/naszhu/REM_E3_model_fixed/commit/a34ab7a) (branch: `sep12-analysisplot`)
**Time:** 2025-09-25 12:12:25  
**Message:**
```
feat(analysis-e1): enhance data visualization and processing in initial list analysis

- Introduced shared constants for colors, shapes, and line types to improve consistency across plots.
- Updated ggplot visualizations with enhanced aesthetics, including adjusted point sizes, line widths, and font sizes for better readability.
- Modified data loading paths for improved accessibility and streamlined data processing steps.
- Removed commented-out code to enhance script clarity and focus on active analysis.
- These changes aim to provide a more cohesive and visually appealing analysis of correct response rates across different test conditions.
```
**Changed Files:**
- `Docs/.~lock.parameter_values_aug-19.docx#`  
- `design1/combined_finaltest_between_list.R`  
- `design1/combined_initial_between_list.R`  
- `design1/combined_initial_within_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a34ab7a_20250925_121225_plot1.png)  
![](../plot_archive/a34ab7a_20250925_121225_plot2.png)  

## Commit [f802ef0](https://github.com/naszhu/REM_E3_model_fixed/commit/f802ef0) (branch: `sep12-analysisplot`)
**Time:** 2025-09-23 16:03:14  
**Message:**
```
refactor(analysis-e1): unify styling constants and enhance ggplot aesthetics

- Introduced unified styling constants for improved consistency across data and prediction plots.
- Enhanced ggplot visualizations by adjusting point sizes, line widths, and font sizes for better clarity.
- Updated data processing to handle FOIL performance separately and improved categorization of probetype and position_type.
- Streamlined the script by removing commented-out code and ensuring active data processing steps are clear.
- These changes aim to provide a more cohesive and visually appealing analysis of test results across different conditions.
```
**Changed Files:**
- `design1/combined_finaltest_within_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/f802ef0_20250923_160314_plot1.png)  
![](../plot_archive/f802ef0_20250923_160314_plot2.png)  

## Commit [a9e2a04](https://github.com/naszhu/REM_E3_model_fixed/commit/a9e2a04) (branch: `sep12-analysisplot`)
**Time:** 2025-09-23 15:03:55  
**Message:**
```
refactor(analysis-e1): unify styling constants and enhance ggplot aesthetics

- Consolidated styling constants for data and prediction plots to improve consistency and readability.
- Updated ggplot visualizations by adjusting point sizes, line widths, and font sizes for enhanced clarity.
- Changed x-axis scale from discrete to continuous for better representation of position data.
- Improved overall plot aesthetics with unified margins, grid styling, and background colors.
- These changes aim to provide a more cohesive and visually appealing analysis of test results across different conditions.
```
**Changed Files:**
- `design1/combined_finaltest_between_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a9e2a04_20250923_150355_plot1.png)  
![](../plot_archive/a9e2a04_20250923_150355_plot2.png)  

## Commit [d97d4d5](https://github.com/naszhu/REM_E3_model_fixed/commit/d97d4d5) (branch: `sep12-analysisplot`)
**Time:** 2025-09-23 14:53:00  
**Message:**
```
feat(analysis-e1): enhance data processing and visualization in final test analysis

- Added constants for styling to improve the readability and aesthetics of plots.
- Updated data processing steps to categorize positions more clearly, changing labels for better interpretability.
- Enhanced ggplot visualizations by adjusting point sizes, line widths, and font sizes for improved clarity.
- Removed commented-out code to streamline the script and focus on active data processing and visualization steps.
- These changes aim to provide a more comprehensive and visually appealing analysis of correct response rates across different test conditions.
```
**Changed Files:**
- `design1/combined_finaltest_between_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/d97d4d5_20250923_145300_plot1.png)  
![](../plot_archive/d97d4d5_20250923_145300_plot2.png)  

## Commit [e1a425f](https://github.com/naszhu/REM_E3_model_fixed/commit/e1a425f) (branch: `sep12-analysisplot`)
**Time:** 2025-09-23 13:38:46  
**Message:**
```
feat(analysis-e3): enhance visualizations and data processing in test scripts

make good visulization bigger font etc data plot

- Improved ggplot visualizations across multiple test scripts by increasing font sizes for better readability and adjusting point sizes for clarity.
- Added new data processing steps to categorize list positions in the final test analysis, enhancing the interpretability of results.
- Updated plot dimensions for exported images to ensure better presentation quality.
- These changes aim to provide a more comprehensive and visually appealing analysis of correct response rates across different test conditions.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
- `design3/data_analysis/final_test_within_list_data_e3.r`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
- `design3/data_analysis/initial_test_within_list_data_e3.r`  
![](../plot_archive/e1a425f_20250923_133846_plot1.png)  
![](../plot_archive/e1a425f_20250923_133846_plot2.png)  

## Commit [153886b](https://github.com/naszhu/REM_E3_model_fixed/commit/153886b) (branch: `sep12-analysisplot`)
**Time:** 2025-09-23 11:40:41  
**Message:**
```
feat(analysis-e1): add comprehensive GLMM analysis and results documentation

- Introduced a new R script for conducting a comprehensive generalized linear mixed model (GLMM) analysis of Experiment 1 data, focusing on recognition performance across various conditions.
- Implemented data preparation steps, including participant screening and accuracy calculations, to ensure robust statistical modeling.
- Generated detailed results documentation summarizing key findings, including exposure history effects and list order knowledge impacts, with statistical significance reported.
- Exported results to a text file for accessibility and further review, enhancing the interpretability of the analysis outcomes.
```
**Changed Files:**
- `design1/data_analysis/E1_statistical_analysis.R`  
- `design1/data_analysis/E1_statistical_results.txt`  
- `design1/data_analysis/Experiment1_Professional_Manuscript_Results.txt`  
- `design1/data_analysis/analysis_output.txt`  
- `design1/data_analysis/context_knowledge_manipulation_analysis.R`  
- `design1/data_analysis/correct_initial_analysis.R`  
- `design1/data_analysis/corrected_within_list.R`  
- `design1/data_analysis/final_between_list_complete_analysis.R`  
- `design1/data_analysis/final_professional_analysis.R`  
- `design1/data_analysis/final_results_summary.txt`  
- `design1/data_analysis/final_within_list_complete_analysis.R`  
- `design1/data_analysis/initial_within_list_complete_analysis.R`  
- `design1/data_analysis/simple_mixed_effects.R`  
- `design1/data_analysis/streamlined_glmm_analysis.R`  
- `design1/data_analysis/test_initial_models.R`  
- `design1/data_analysis/trace_data_processing.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/153886b_20250923_114041_plot1.png)  
![](../plot_archive/153886b_20250923_114041_plot2.png)  

## Commit [54c2981](https://github.com/naszhu/REM_E3_model_fixed/commit/54c2981) (branch: `sep12-analysisplot`)
**Time:** 2025-09-22 13:53:18  
**Message:**
```
feat(analysis-e3): enhance shape and color scales in test data visualizations

- Updated ggplot visualizations in final and initial test scripts to use manual shape and color scales for better clarity and distinction among categories.
- Improved the representation of different response types by defining specific shapes and colors for each category in the plots.
- These changes aim to enhance the interpretability of the results and provide a more visually informative analysis of correct response rates across various test positions.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
- `design3/data_analysis/final_test_within_list_data_e3.r`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
- `design3/data_analysis/initial_test_within_list_data_e3.r`  
![](../plot_archive/54c2981_20250922_135318_plot1.png)  
![](../plot_archive/54c2981_20250922_135318_plot2.png)  

## Commit [0cd20ad](https://github.com/naszhu/REM_E3_model_fixed/commit/0cd20ad) (branch: `sep12-analysisplot`)
**Time:** 2025-09-22 12:20:29  
**Message:**
```
feat(analysis-e1): add context knowledge manipulation analysis script

- Introduced a new R script for analyzing context knowledge manipulation, focusing on recognition performance based on exposure history, recency effects, and list order knowledge.
- Implemented data processing steps to summarize performance metrics and conduct statistical analyses, including ANOVA and effect size calculations.
- Created visualizations to illustrate the main effects and interactions, enhancing the interpretability of the results.
- Exported analysis results and plots to CSV and PNG files for further review and accessibility.
```
**Changed Files:**
- `design1/data_analysis/context_knowledge_manipulation_analysis.R`  
- `design1/data_analysis/final_between_list_complete_analysis.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/0cd20ad_20250922_122029_plot1.png)  
![](../plot_archive/0cd20ad_20250922_122029_plot2.png)  

## Commit [eabb67a](https://github.com/naszhu/REM_E3_model_fixed/commit/eabb67a) (branch: `sep12-analysisplot`)
**Time:** 2025-09-22 12:19:55  
**Message:**
```
feat(analysis-e1): add initial and final within-list analysis scripts

- Introduced new R scripts for conducting comprehensive analyses of initial and final within-list data, focusing on correct response rates by test and study positions.
- Implemented data processing steps to calculate means, standard deviations, and standard errors for correct responses, enhancing the clarity of results.
- Included detailed output for performance hierarchies and statistical significance tests, providing insights into the effects of study and test positions on recognition performance.
- Exported processed data to CSV files for further analysis and accessibility.
```
**Changed Files:**
- `design1/data_analysis/correct_initial_analysis.R`  
- `design1/data_analysis/final_between_list_complete_analysis.R`  
- `design1/data_analysis/final_within_list_complete_analysis.R`  
- `design1/data_analysis/initial_within_list_complete_analysis.R`  
- `design1/data_analysis/trace_data_processing.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/eabb67a_20250922_121955_plot1.png)  
![](../plot_archive/eabb67a_20250922_121955_plot2.png)  

## Commit [ce0ea10](https://github.com/naszhu/REM_E3_model_fixed/commit/ce0ea10) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 22:45:45  
**Message:**
```
feat(analysis-e3): add initial and final within-list analysis scripts

- Introduced new R scripts for conducting comprehensive analyses of initial and final within-list data, focusing on correct response rates by test and study positions.
- Implemented data processing steps to calculate means, standard deviations, and standard errors for correct responses, enhancing the clarity of results.
- Included detailed output for performance hierarchies and statistical significance tests, providing insights into the effects of study and test positions on recognition performance.
- Exported processed data to CSV files for further analysis and accessibility.
```
**Changed Files:**
- `design1/data_analysis/correct_initial_analysis.R`  
- `design1/data_analysis/final_between_list_complete_analysis.R`  
- `design1/data_analysis/final_within_list_complete_analysis.R`  
- `design1/data_analysis/initial_within_list_complete_analysis.R`  
- `design1/data_analysis/trace_data_processing.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/ce0ea10_20250921_224545_plot1.png)  
![](../plot_archive/ce0ea10_20250921_224545_plot2.png)  

## Commit [cf5e824](https://github.com/naszhu/REM_E3_model_fixed/commit/cf5e824) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 21:51:01  
**Message:**
```
feat(analysis-e3): refine initial and final test data analysis with enhanced summarization and visualization

- Updated summarization steps to calculate means and standard errors for correct response rates in both initial and final test analyses.
- Improved ggplot visualizations by adding ribbons for standard error and updating color and fill scales for better clarity and distinction among categories.
- These enhancements aim to provide a more comprehensive and visually informative analysis of correct response rates across different test positions.
```
**Changed Files:**
- `design1/data_analysis/E1_statistical_analysis.R`  
- `design1/data_analysis/E1_statistical_results.txt`  
- `design1/data_analysis/corrected_within_list.R`  
- `design1/data_analysis/simple_mixed_effects.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
![](../plot_archive/cf5e824_20250921_215101_plot1.png)  
![](../plot_archive/cf5e824_20250921_215101_plot2.png)  

## Commit [1a88bc4](https://github.com/naszhu/REM_E3_model_fixed/commit/1a88bc4) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 17:18:58  
**Message:**
```
feat(analysis-e3): enhance final test data analysis with improved summarization and visualization

- Updated the data processing to include additional grouping and summarization steps for both test and study positions, calculating means and standard errors for correct response rates.
- Enhanced the ggplot visualization by adding a ribbon for standard error and updating color scales for better clarity and distinction between categories.
- These changes aim to provide a more comprehensive analysis of correct response rates across different positions in the final test data.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_within_list_data_e3.r`  
![](../plot_archive/1a88bc4_20250921_171858_plot1.png)  
![](../plot_archive/1a88bc4_20250921_171858_plot2.png)  

## Commit [656fbab](https://github.com/naszhu/REM_E3_model_fixed/commit/656fbab) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 17:16:38  
**Message:**
```
feat(analysis-e3): filter out specific code versions in data analysis

- Added a filter to exclude entries with codeversion equal to 1 in the data processing pipeline.
- This change aims to refine the dataset used for analysis by removing potentially irrelevant data points.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/R_design3_pilotExample.rmd`  
- `design3/data_analysis/generate_data.r`  
![](../plot_archive/656fbab_20250921_171638_plot1.png)  
![](../plot_archive/656fbab_20250921_171638_plot2.png)  

## Commit [bc2316b](https://github.com/naszhu/REM_E3_model_fixed/commit/bc2316b) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 16:35:18  
**Message:**
```
feat(analysis-e3): add final test within list data analysis script

- Introduced a new R script for analyzing final test data within lists, focusing on correct response rates by test and study positions.
- Implemented data processing and visualization using ggplot2, generating a combined plot for enhanced clarity.
- Exported the final plot as a PNG file for improved accessibility and presentation.
- Updated .gitignore to include new plot files, ensuring they are not tracked by Git.
```
**Changed Files:**
- `.gitignore`  
- `Docs/.~lock.DataPlot-d3(exp2).docx#`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_within_list_data_e3.r`  
![](../plot_archive/bc2316b_20250921_163518_plot1.png)  
![](../plot_archive/bc2316b_20250921_163518_plot2.png)  

## Commit [6841965](https://github.com/naszhu/REM_E3_model_fixed/commit/6841965) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 22:24:45  
**Message:**
```
feat(analysis-e3): add final test analysis script with combined data visualization

- Introduced a new R script for analyzing final test data between lists, including data processing for initial and final positions.
- Created a combined dataset for both positions to facilitate comprehensive visualization of correct response rates.
- Implemented ggplot2 for generating a combined plot, enhancing clarity and insight into the analysis.
- Exported the final plot as a PNG file for improved accessibility and presentation.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/final_test_between_list_data_e3.r`  
![](../plot_archive/6841965_20250921_222445_plot1.png)  
![](../plot_archive/6841965_20250921_222445_plot2.png)  

## Commit [da9bdaf](https://github.com/naszhu/REM_E3_model_fixed/commit/da9bdaf) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 21:45:02  
**Message:**
```
feat(analysis-e3): enhance initial test analysis with combined data visualization

- Refactored the initial test data processing to separate analyses by test and study positions.
- Introduced a combined dataset for both test and study positions, allowing for comprehensive visualization.
- Updated ggplot generation to create a combined plot, improving clarity and insight into correct response rates across different positions.
- Exported the updated plot as a PNG file for better accessibility and presentation.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/initial_test_within_list_data_e3.r`  
![](../plot_archive/da9bdaf_20250921_214502_plot1.png)  
![](../plot_archive/da9bdaf_20250921_214502_plot2.png)  

## Commit [54c7452](https://github.com/naszhu/REM_E3_model_fixed/commit/54c7452) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 21:36:53  
**Message:**
```
chore(all): update gitignore
```
**Changed Files:**
- `.gitignore`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/54c7452_20250921_213653_plot1.png)  
![](../plot_archive/54c7452_20250921_213653_plot2.png)  

## Commit [51f81a2](https://github.com/naszhu/REM_E3_model_fixed/commit/51f81a2) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 21:35:28  
**Message:**
```
feat(analysis-e3): add plot generation to initial test within list script

  - Remove temporary lock files for DataPlot documents
  - Add trailing whitespace to combined_initial_within_list.R
  - Add ggplot visualization and PNG export to initial_test_within_list_data_e3.r
```
**Changed Files:**
- `Docs/.~lock.DataPlot-d1(exp1).odt#`  
- `Docs/.~lock.Dataplot-e3-aug19.docx#`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/initial_test_within_list_data_e3.r`  
![](../plot_archive/51f81a2_20250921_213528_plot1.png)  
![](../plot_archive/51f81a2_20250921_213528_plot2.png)  

## Commit [b82909e](https://github.com/naszhu/REM_E3_model_fixed/commit/b82909e) (branch: `sep12-analysisplot`)
**Time:** 2025-09-21 21:29:54  
**Message:**
```
refactor(analysis-e3): comment out unused data processing steps in R script

- Commented out several data filtering and summarization lines in `R_design3_pilotExample.rmd` to improve script clarity and maintainability.
- These changes aim to streamline the analysis process by reducing clutter while preserving the original code for potential future use.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/R_design3_pilotExample.rmd`  
![](../plot_archive/b82909e_20250921_212954_plot1.png)  
![](../plot_archive/b82909e_20250921_212954_plot2.png)  

## Commit [78509d4](https://github.com/naszhu/REM_E3_model_fixed/commit/78509d4) (branch: `sep12-analysisplot`)
**Time:** 2025-09-12 23:41:17  
**Message:**
```
feat(analysis-e3): add initial test analysis scripts and visualization

- Introduced new R scripts for analyzing initial test data between lists, including `initial_test_between_list_data_e3.r` and `quick_plot.r`.
- Implemented data processing and visualization using ggplot2, enhancing the ability to generate insightful plots from aggregated data.
- Updated `.gitignore` to include new R script files, ensuring they are not tracked by Git.

These changes aim to improve the analysis capabilities for initial test data and streamline the visualization process.
```
**Changed Files:**
- `.gitignore`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/generate_data.r`  
- `design3/data_analysis/initial_test_between_list_data_e3.r`  
- `design3/data_analysis/quick_plot.r`  
![](../plot_archive/78509d4_20250912_234117_plot1.png)  
![](../plot_archive/78509d4_20250912_234117_plot2.png)  

## Commit [69e5a88](https://github.com/naszhu/REM_E3_model_fixed/commit/69e5a88) (branch: `sep12-analysisplot`)
**Time:** 2025-09-12 23:26:53  
**Message:**
```
feat(analysis-e3): add CSV export functionality to generate_data.r

- Implemented a write.csv function to export the processed data frame to a specified file path.
- This addition allows for easier data sharing and further analysis outside of the R environment.

These changes enhance the usability of the data processing script by enabling direct output of results.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/generate_data.r`  
![](../plot_archive/69e5a88_20250912_232653_plot1.png)  
![](../plot_archive/69e5a88_20250912_232653_plot2.png)  

## Commit [d7a5b5a](https://github.com/naszhu/REM_E3_model_fixed/commit/d7a5b5a) (branch: `sep12-analysisplot`)
**Time:** 2025-09-12 23:22:20  
**Message:**
```
refactor(analysis-e3): clean up generate_data.r by removing redundant summarization steps

- Removed unnecessary group_by and summarize calls that were not contributing to the final output.
- Streamlined the data processing workflow to enhance readability and maintainability of the script.
- Ensured that the essential data transformations and filtering steps remain intact for accurate analysis.

These changes aim to simplify the data analysis process and improve the overall structure of the script.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/generate_data.r`  
![](../plot_archive/d7a5b5a_20250912_232220_plot1.png)  
![](../plot_archive/d7a5b5a_20250912_232220_plot2.png)  

## Commit [42e40a9](https://github.com/naszhu/REM_E3_model_fixed/commit/42e40a9) (branch: `sep12-analysisplot`)
**Time:** 2025-09-12 23:16:36  
**Message:**
```
feat(analysis-e3): add generate_data.r script for comprehensive data processing

- Introduced a new R script to handle data generation and processing for various datasets, including IMUSE and Firestone data.
- Implemented data cleaning and transformation steps, including type alignment and handling of logical values.
- Enhanced data summarization and visualization capabilities, allowing for better insights into participant performance and accuracy.
- Streamlined the integration of multiple data sources, ensuring consistent analysis across different datasets.

These changes aim to facilitate a more robust and organized approach to data analysis within the project.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/data_analysis/generate_data.r`  
![](../plot_archive/42e40a9_20250912_231636_plot1.png)  
![](../plot_archive/42e40a9_20250912_231636_plot2.png)  

## Commit [b654343](https://github.com/naszhu/REM_E3_model_fixed/commit/b654343) (branch: `sep12-analysisplot`)
**Time:** 2025-09-11 01:37:57  
**Message:**
```
merge(predplot-e1): Merge branch 'sep-10-predplot'
```
![](../plot_archive/b654343_20250911_013757_plot1.png)  
![](../plot_archive/b654343_20250911_013757_plot2.png)  

## Commit [ad4025a](https://github.com/naszhu/REM_E3_model_fixed/commit/ad4025a) (branch: `sep-10-predplot`)
**Time:** 2025-09-11 00:22:15  
**Message:**
```
feat(model-e1): back to asymptotic final criterion shift

- Set the final test flag to true, adjusting the number of simulations accordingly.
- Replaced the original criterion generation with an asymptotic version to better model nonlinear behavior.
- Included the utils.jl file to ensure access to necessary asymptotic functions.

These changes aim to refine the modeling process for final tests and improve the accuracy of criterion calculations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/utils.jl`  
![](../plot_archive/ad4025a_20250911_002215_plot1.png)  
![](../plot_archive/ad4025a_20250911_002215_plot2.png)  

## Commit [fd10b76](https://github.com/naszhu/REM_E3_model_fixed/commit/fd10b76) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 23:49:47  
**Message:**
```
finetune(model-e1): enhance y-axis limits and streamline final test checks in scripts

Perfect initial test prediction almost

- Updated the y-axis limits and labels in the combined initial between-list plot for improved performance visualization.
- Simplified the final test checks in the shell script by removing redundant conditions and focusing on the presence of `allresf.csv`.
- Added a backup of the shell script to ensure previous functionality is preserved.

These changes aim to enhance the clarity of plot outputs and improve the efficiency of the script execution process.
```
**Changed Files:**
- `design1/combined_initial_between_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/run_combined_plots.sh`  
- `design1/run_combined_plots.sh.backup`  
![](../plot_archive/fd10b76_20250910_234947_plot1.png)  
![](../plot_archive/fd10b76_20250910_234947_plot2.png)  

## Commit [7a3018b](https://github.com/naszhu/REM_E3_model_fixed/commit/7a3018b) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 23:41:06  
**Message:**
```
explore(model-e1):A working version remove eog display command from R scripts

- Eliminated the system command to display plots using `eog` from multiple R scripts, streamlining the plot generation process.
- This change enhances the usability of the scripts by removing unnecessary dependencies on external applications for displaying plots.

These modifications aim to simplify the workflow for generating combined plots without relying on external viewers.
```
**Changed Files:**
- `design1/combined_finaltest_between_list.R`  
- `design1/combined_finaltest_within_list.R`  
- `design1/combined_initial_between_list.R`  
- `design1/combined_initial_within_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/run_combined_plots.sh`  
![](../plot_archive/7a3018b_20250910_234106_plot1.png)  
![](../plot_archive/7a3018b_20250910_234106_plot2.png)  

## Commit [0004804](https://github.com/naszhu/REM_E3_model_fixed/commit/0004804) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 23:15:07  
**Message:**
```
feat(allplot-e1): add checks for final test data in R scripts and shell scripts

- Implemented checks in the R scripts for final test between-list and within-list plots to ensure the presence of the required `allresf.csv` file before proceeding with plot generation.
- Updated the shell script to conditionally run final test plots based on the existence of `allresf.csv`, providing user feedback on the status of the final test.
- Enhanced output messages to inform users when final test plots are skipped due to missing data.

These changes improve the robustness of the plotting scripts and enhance user experience by preventing errors related to missing data files.
```
**Changed Files:**
- `design1/combined_finaltest_between_list.R`  
- `design1/combined_finaltest_within_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/run_combined_plots.sh`  
- `design1/run_simulation_and_combined_plots.sh`  
![](../plot_archive/0004804_20250910_231507_plot1.png)  
![](../plot_archive/0004804_20250910_231507_plot2.png)  

## Commit [df49f20](https://github.com/naszhu/REM_E3_model_fixed/commit/df49f20) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 23:11:01  
**Message:**
```
feat(shell-e1): add script to run parallel simulations and generate combined plots

- Introduced a new shell script that automates the execution of parallel simulations followed by the generation of combined data vs prediction plots.
- The script checks for the existence of necessary scripts and provides feedback on the success or failure of each step.
- This addition streamlines the workflow for running simulations and visualizing results, enhancing the overall analysis process.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/run_simulation_and_combined_plots.sh`  
![](../plot_archive/df49f20_20250910_231101_plot1.png)  
![](../plot_archive/df49f20_20250910_231101_plot2.png)  

## Commit [6ebdf76](https://github.com/naszhu/REM_E3_model_fixed/commit/6ebdf76) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 22:57:49  
**Message:**
```
feat(predplot-e1): update .gitignore and enhance y-axis limits for combined plot

- Added new plot files to .gitignore to keep the repository clean from generated images.
- Enhanced the y-axis limits and labels in the combined initial within-list plot for improved clarity in performance visualization.

These changes aim to streamline the repository management and improve the interpretability of the combined plot outputs.
```
**Changed Files:**
- `.gitignore`  
- `design1/combined_initial_within_list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/6ebdf76_20250910_225749_plot1.png)  
![](../plot_archive/6ebdf76_20250910_225749_plot2.png)  

## Commit [86a9220](https://github.com/naszhu/REM_E3_model_fixed/commit/86a9220) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 22:57:31  
**Message:**
```
feat(predplot-e1): add combined plot scripts for final and initial test analyses

- Introduced new R scripts for generating combined plots that display data and prediction side by side for both final and initial test analyses.
- Updated the .gitignore to include new combined plot files, ensuring a cleaner repository by excluding generated images.
- Created a shell script to automate the execution of all combined plot scripts, streamlining the workflow for generating visual outputs.

These changes aim to enhance the data visualization process and improve the accessibility of analysis results.
```
**Changed Files:**
- `.gitignore`  
- `design1/combined_finaltest_between_list.R`  
- `design1/combined_finaltest_within_list.R`  
- `design1/combined_initial_between_list.R`  
- `design1/combined_initial_within_list.R`  
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/modeling/R_ploting/E1 final t - within_list_prediction_plot.R`  
- `design1/modeling/R_ploting/E1- initial test-between_list_prediction_plot.R`  
- `design1/modeling/R_ploting/E1-finaltest-between-list-enhanced.R`  
- `design1/modeling/R_ploting/R_plots_enhanced_fixed.r`  
- `design1/modeling/R_ploting/between_list_prediction_plot.R`  
- `design1/modeling/R_ploting/final_test_between_list_prediction_plot.R`  
- `design1/modeling/R_ploting/within_list_prediction_plot.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/run_combined_plots.sh`  
![](../plot_archive/86a9220_20250910_225731_plot1.png)  
![](../plot_archive/86a9220_20250910_225731_plot2.png)  

## Commit [5bff88b](https://github.com/naszhu/REM_E3_model_fixed/commit/5bff88b) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 22:27:39  
**Message:**
```
feat(predplot-e1): enhance final test between and within list plots

- Updated the final test between-list plot aesthetics, including improved color palettes, shapes, and line types for better clarity.
- Enhanced the final test within-list plot with refined styling, including larger font sizes and better legend positioning.
- Streamlined data processing by loading preprocessed data from a single CSV file, improving efficiency.
- Saved enhanced plots in high resolution and added sample versions for quick previews.

These changes aim to improve the visual quality and accessibility of the final test analyses, ensuring clearer interpretation of results.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/modeling/R_ploting/E1_final_test_within_list_enhanced.R`  
- `design1/modeling/R_ploting/final_test_between_list_prediction_plot.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/5bff88b_20250910_222739_plot1.png)  
![](../plot_archive/5bff88b_20250910_222739_plot2.png)  

## Commit [0d425a5](https://github.com/naszhu/REM_E3_model_fixed/commit/0d425a5) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 21:15:33  
**Message:**
```
feat(predplot-e1): update plot aesthetics for final test within-list analysis

- Changed legend position from right to bottom and adjusted text sizes for improved readability.
- Updated y-axis limits to enhance data visualization, focusing on the relevant range of hit rates.
- These modifications aim to refine the visual presentation of the final test within-list plots for better clarity and interpretation.
```
**Changed Files:**
- `design1/modeling/R_ploting/E1_final_test_within_list_enhanced.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/0d425a5_20250910_211533_plot1.png)  
![](../plot_archive/0d425a5_20250910_211533_plot2.png)  

## Commit [7008ce5](https://github.com/naszhu/REM_E3_model_fixed/commit/7008ce5) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 21:12:53  
**Message:**
```
feat(predplot-e1): enhance final test between-list plot and remove unused scripts

- Updated the final test between-list plot aesthetics, including adjustments to axis labels, colors, and font sizes for improved readability.
- Replaced `geom_ribbon` with commented-out code to enhance clarity in the plot.
- Changed the method of saving plots from `png` to `ggsave` for better control over output dimensions and quality.
- Deleted unused scripts for within-list and initial analyses to streamline the project and reduce clutter.

These changes aim to improve the visual quality of the final test between-list analysis and maintain a cleaner codebase.
```
**Changed Files:**
- `.gitignore`  
- `design1/modeling/R_ploting/E1-finaltest-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-finaltest-within-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-within-list-enhanced.R`  
- `design1/modeling/R_ploting/E1_final_test_within_list_enhanced.R`  
- `design1/modeling/R_ploting/R_plots_enhanced_fixed.r`  
- `design1/modeling/R_ploting/R_plots_finalt_enhanced_fixed.r`  
- `design1/modeling/R_ploting/between_list_prediction_plot.R`  
- `design1/modeling/R_ploting/final_test_between_list_prediction_plot.R`  
- `design1/modeling/R_ploting/run_all_E1_plots.sh`  
- `design1/modeling/R_ploting/run_enhanced_plots_fixed.sh`  
- `design1/modeling/R_ploting/within_list_prediction_plot.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/7008ce5_20250910_211253_plot1.png)  
![](../plot_archive/7008ce5_20250910_211253_plot2.png)  

## Commit [e5efe59](https://github.com/naszhu/REM_E3_model_fixed/commit/e5efe59) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 19:58:42  
**Message:**
```
feat(analysis-e1): enhance final test between-list plot aesthetics and readability

- Added the 'grid' library for improved unit handling in plots.
- Increased font sizes across all plot elements for better visibility.
- Updated plot labels for clarity and adjusted legend layout.
- Enhanced theme settings to improve overall readability and presentation.
- Adjusted dimensions for saved plot images to accommodate new layout.

These changes aim to improve the visual quality and accessibility of the final test between-list analysis outputs.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/e5efe59_20250910_195842_plot1.png)  
![](../plot_archive/e5efe59_20250910_195842_plot2.png)  

## Commit [7c875c1](https://github.com/naszhu/REM_E3_model_fixed/commit/7c875c1) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 19:58:35  
**Message:**
```
feat(data-analysis): enhance final test between-list plot aesthetics and readability

- Added the 'grid' library for improved unit handling in plots.
- Increased font sizes across all plot elements for better visibility.
- Updated plot labels for clarity and adjusted legend layout.
- Enhanced theme settings to improve overall readability and presentation.
- Adjusted dimensions for saved plot images to accommodate new layout.

These changes aim to improve the visual quality and accessibility of the final test between-list analysis outputs.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/7c875c1_20250910_195835_plot1.png)  
![](../plot_archive/7c875c1_20250910_195835_plot2.png)  

## Commit [c56bf27](https://github.com/naszhu/REM_E3_model_fixed/commit/c56bf27) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 19:50:42  
**Message:**
```
feat(predplot-e1): add 4 files correponding to analysis
- Introduced new R scripts for generating enhanced plots for both initial and final test analyses, improving data visualization.
- Enhanced plot aesthetics with improved color palettes, shapes, and line types for better clarity and readability.
- Updated the shell script to automate the execution of all plot scripts, ensuring a streamlined workflow for generating visual outputs.
- Saved the generated plots in PNG format for easy access and presentation.

These changes aim to expand the data analysis capabilities and enhance the quality of visual outputs.
```
**Changed Files:**
- `design1/modeling/R_ploting/E1-finaltest-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-finaltest-within-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-within-list-enhanced.R`  
- `design1/modeling/R_ploting/run_all_E1_plots.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/c56bf27_20250910_195042_plot1.png)  
![](../plot_archive/c56bf27_20250910_195042_plot2.png)  

## Commit [a31ec90](https://github.com/naszhu/REM_E3_model_fixed/commit/a31ec90) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 19:50:28  
**Message:**
```
feat(predplot-e1): add enhanced initial and final test plots for between and within lists

- Introduced new R scripts for generating enhanced plots for both initial and final test analyses, improving data visualization.
- Enhanced plot aesthetics with improved color palettes, shapes, and line types for better clarity and readability.
- Updated the shell script to automate the execution of all plot scripts, ensuring a streamlined workflow for generating visual outputs.
- Saved the generated plots in PNG format for easy access and presentation.

These changes aim to expand the data analysis capabilities and enhance the quality of visual outputs.
```
**Changed Files:**
- `design1/modeling/R_ploting/E1-finaltest-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-finaltest-within-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-between-list-enhanced.R`  
- `design1/modeling/R_ploting/E1-initial-within-list-enhanced.R`  
- `design1/modeling/R_ploting/run_all_E1_plots.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a31ec90_20250910_195028_plot1.png)  
![](../plot_archive/a31ec90_20250910_195028_plot2.png)  

## Commit [ffac0a9](https://github.com/naszhu/REM_E3_model_fixed/commit/ffac0a9) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 19:41:48  
**Message:**
```
feat(predplot-e1): update ignore patterns for prediction plot files

- Added new patterns to exclude prediction plot files from tracking, including those in the modeling directory and enhanced prediction files.
- This update helps maintain a cleaner repository by preventing unnecessary output files from being included in version control.
```
**Changed Files:**
- `.gitignore`  
- `design1/modeling/R_ploting/R_plots_enhanced_fixed.r`  
- `design1/modeling/R_ploting/R_plots_finalt_enhanced_fixed.r`  
- `design1/modeling/R_ploting/run_enhanced_plots_fixed.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/ffac0a9_20250910_194148_plot1.png)  
![](../plot_archive/ffac0a9_20250910_194148_plot2.png)  

## Commit [ca9583f](https://github.com/naszhu/REM_E3_model_fixed/commit/ca9583f) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:52:54  
**Message:**
```
feat(analysis-e1): add final test between and within list scripts with enhanced plots

- Introduced new R scripts for final test analyses (both between and within lists) to improve data visualization.
- Updated the shell script to allow selective plot generation and streamline the process.
- Enhanced plot aesthetics and readability, including improved color palettes and legend positioning.
- Saved processed data to CSV files for further analysis.

These changes aim to expand the data analysis capabilities and enhance the quality of visual outputs.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-between-list.R`  
- `design1/data_analysis/E1-finaltest-within-list.R`  
- `design1/data_analysis/run_all_plots.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/ca9583f_20250910_185254_plot1.png)  
![](../plot_archive/ca9583f_20250910_185254_plot2.png)  

## Commit [a77b241](https://github.com/naszhu/REM_E3_model_fixed/commit/a77b241) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:34:03  
**Message:**
```
feat(predplot-e1): Within plot, streamline data processing and enhance plot generation

- Updated the data processing scripts to load preprocessed data from CSV instead of multiple CSV reads, improving efficiency.
- Introduced a new script for within-list analysis, generating enhanced plots with improved aesthetics and readability.
- Added a shell script to automate the data generation and plot creation process, ensuring a smoother workflow.
- Updated .gitignore to exclude additional generated plot files, maintaining a cleaner repository.

These changes aim to enhance the data analysis workflow and improve the quality of visual outputs.
```
**Changed Files:**
- `.gitignore`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/E1-initial-within-list.R`  
- `design1/data_analysis/R_IMPORTANT_USED_DESIGN1_tempesti_v3.rmd`  
- `design1/data_analysis/generate_data.R`  
- `design1/data_analysis/run_all_plots.sh`  
- `design1/data_analysis/run_enhanced_plot.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a77b241_20250910_183403_plot1.png)  
![](../plot_archive/a77b241_20250910_183403_plot2.png)  

## Commit [6433e23](https://github.com/naszhu/REM_E3_model_fixed/commit/6433e23) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:44:03  
**Message:**
```
feat(data-analysis): add final test within list scripts and corresponding plot files

- Introduced a new R script for final test within-list analysis to enhance data visualization.
- Updated the shell script to include the new final test plot file in the expected output list.
- These changes aim to expand the data analysis capabilities and improve the quality of visual outputs.
```
**Changed Files:**
- `design1/data_analysis/E1-finaltest-within-list.R`  
- `design1/data_analysis/run_all_plots.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/6433e23_20250910_184403_plot1.png)  
![](../plot_archive/6433e23_20250910_184403_plot2.png)  

## Commit [a77b241](https://github.com/naszhu/REM_E3_model_fixed/commit/a77b241) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:34:03  
**Message:**
```
feat(predplot-e1): Within plot, streamline data processing and enhance plot generation

- Updated the data processing scripts to load preprocessed data from CSV instead of multiple CSV reads, improving efficiency.
- Introduced a new script for within-list analysis, generating enhanced plots with improved aesthetics and readability.
- Added a shell script to automate the data generation and plot creation process, ensuring a smoother workflow.
- Updated .gitignore to exclude additional generated plot files, maintaining a cleaner repository.

These changes aim to enhance the data analysis workflow and improve the quality of visual outputs.
```
**Changed Files:**
- `.gitignore`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/E1-initial-within-list.R`  
- `design1/data_analysis/R_IMPORTANT_USED_DESIGN1_tempesti_v3.rmd`  
- `design1/data_analysis/generate_data.R`  
- `design1/data_analysis/run_all_plots.sh`  
- `design1/data_analysis/run_enhanced_plot.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/a77b241_20250910_183403_plot1.png)  
![](../plot_archive/a77b241_20250910_183403_plot2.png)  

## Commit [670700d](https://github.com/naszhu/REM_E3_model_fixed/commit/670700d) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:15:06  
**Message:**
```
feat(predplot-e1): add between-list enhanced plot files to ignore list

- Included new enhanced plot files and patterns to the .gitignore to prevent tracking of generated images.
- This update helps maintain a cleaner repository by excluding unnecessary output files.
```
**Changed Files:**
- `.gitignore`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/generate_data.R`  
- `design1/data_analysis/run_enhanced_plot.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `enhanced_plot_script.R`  
- `run_enhanced_plot.R`  
![](../plot_archive/670700d_20250910_181506_plot1.png)  
![](../plot_archive/670700d_20250910_181506_plot2.png)  

## Commit [96bea21](https://github.com/naszhu/REM_E3_model_fixed/commit/96bea21) (branch: `sep-10-predplot`)
**Time:** 2025-09-10 18:14:03  
**Message:**
```
feat(predplot): add between-list enhanced plot files to ignore list

- Included new enhanced plot files and patterns to the .gitignore to prevent tracking of generated images.
- This update helps maintain a cleaner repository by excluding unnecessary output files.
```
**Changed Files:**
- `.gitignore`  
- `design1/data_analysis/E1-initial-between-list.R`  
- `design1/data_analysis/generate_data.R`  
- `design1/data_analysis/run_enhanced_plot.sh`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `enhanced_plot_script.R`  
- `run_enhanced_plot.R`  
![](../plot_archive/96bea21_20250910_181403_plot1.png)  
![](../plot_archive/96bea21_20250910_181403_plot2.png)  

## Commit [d83b40e](https://github.com/naszhu/REM_E3_model_fixed/commit/d83b40e) (branch: `sep-10-predplot`)
**Time:** 2025-09-09 23:36:21  
**Message:**
```
merge(model-e1): Merge branch 'sep-8-final-test-within-list-issue38'
```
![](../plot_archive/d83b40e_20250909_233621_plot1.png)  
![](../plot_archive/d83b40e_20250909_233621_plot2.png)  

## Commit [bd34610](https://github.com/naszhu/REM_E3_model_fixed/commit/bd34610) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 23:21:59  
**Message:**
```
feat(model-e1): update unchanging context feature drift logic and adjust constants

- Introduced `drift_between_lists_final!` function to update list context features based on change probability.
- Commented out y-axis limits in R plots for future adjustments.
- Adjusted `criterion_final` and `final_gap_change` for improved model accuracy.
- Updated `p_ListChange_finaltest` to reflect new testing conditions.

These changes aim to enhance the modeling framework's adaptability and accuracy in simulations.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots_finalt.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
![](../plot_archive/bd34610_20250909_232159_plot1.png)  
![](../plot_archive/bd34610_20250909_232159_plot2.png)  

## Commit [b360f52](https://github.com/naszhu/REM_E3_model_fixed/commit/b360f52) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 22:27:10  
**Message:**
```
fix(model-e1): LL caluclation only for non-z content feature

- Adjusted `criterion_final` to include dynamic components based on `power_taken` for improved model accuracy.
- Refined `calculate_two_step_likelihoods` functions to ensure proper error handling when stages are not assigned correctly.
- Updated likelihood calculations to use the correct word feature ranges, enhancing the reliability of the model's predictions.

These changes aim to enhance the robustness and accuracy of the modeling framework.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/likelihood_calculations.jl`  
![](../plot_archive/b360f52_20250909_222710_plot1.png)  
![](../plot_archive/b360f52_20250909_222710_plot2.png)  

## Commit [7c7c69d](https://github.com/naszhu/REM_E3_model_fixed/commit/7c7c69d) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 22:12:30  
**Message:**
```
finetune(model-e1): final prediction update R plot scaling and adjust constants for drift study

- Commented out the y-axis scaling in R plots for potential future adjustments.
- Modified `n_driftStudyTest` from 12 to 7 to better align with study parameters.
- Increased `base_distortion_prob` from 0.15 to 0.2 to enhance initial distortion probability.
- Adjusted `criterion_final` range and `final_gap_change` for improved model accuracy.
- Updated `p_ListChange_finaltest` from 0.2 to 0.6 to reflect new testing conditions.

These changes aim to refine the modeling parameters and improve the overall simulation accuracy.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/7c7c69d_20250909_221230_plot1.png)  
![](../plot_archive/7c7c69d_20250909_221230_plot2.png)  

## Commit [8403cfc](https://github.com/naszhu/REM_E3_model_fixed/commit/8403cfc) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 20:13:46  
**Message:**
```
fix(model-e1): final test should use foil collection, rather than the distorted probes

- Updated `generate_probes` function to return both probes and a collection of foils.
- Adjusted `studied_pool` assignment to directly use the new `foil_collections`.
- Modified distortion parameters: reduced `max_distortion_probes` to 5 and increased `base_distortion_prob` to 0.15 for improved distortion behavior.
- Changed `n_driftStudyTest` from 17 to 12 to align with new study parameters.

These changes aim to refine the probe generation process and enhance the handling of foils in the simulation.

The bug was from #32
Closes #38
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
- `design1/modeling/simulation.jl`  
![](../plot_archive/8403cfc_20250909_201346_plot1.png)  
![](../plot_archive/8403cfc_20250909_201346_plot2.png)  

## Commit [cf0cd28](https://github.com/naszhu/REM_E3_model_fixed/commit/cf0cd28) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 19:40:57  
**Message:**
```
feat(model-e1): change restorage procces rules,

doesn't help much though

Current approach is to make restorage process to have restore the missing only but not replace the incorrect ones, in this way, the targets are not mis-"corrected" to the distoreted values, so should be less influenced in final test

Refs #38
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/cf0cd28_20250909_194057_plot1.png)  
![](../plot_archive/cf0cd28_20250909_194057_plot2.png)  

## Commit [05f82b1](https://github.com/naszhu/REM_E3_model_fixed/commit/05f82b1) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 01:49:32  
**Message:**
```
explore(model-e1): adjust distortion parameters and enable probe distortion

- Set is_UnchangeCtxDriftAndReinstate to true to align with E3
- Introduce is_distort_probes flag to control probe distortion behavior
- Modify v_criterion_initial from 0.14 to 0.11 for updated criteria
- Change n_driftStudyTest from 12 to 10 to reflect new study parameters
- Update base_distortion_prob from 0.15 to 0.1 for reduced initial distortion probability

These changes aim to refine the distortion mechanism and improve alignment with experimental design.

Refs #38
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/05f82b1_20250909_014932_plot1.png)  
![](../plot_archive/05f82b1_20250909_014932_plot2.png)  

## Commit [37ed24b](https://github.com/naszhu/REM_E3_model_fixed/commit/37ed24b) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 00:21:25  
**Message:**
```
debug(#38): add final test probe distribution analysis

- Add comprehensive summary of initial_testpos distribution in final test
- Reveal core issue: 280 studied-only items (pos=0) vs 6-10 tested items per position
- Show distortion is working (30-50% of position 1-20 items are distorted)
- Identify statistical dilution as cause of flat line effect
- Next: investigate distortion effect size and comparison with previous working model versions

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/37ed24b_20250909_002125_plot1.png)  
![](../plot_archive/37ed24b_20250909_002125_plot2.png)  

## Commit [b5bfb62](https://github.com/naszhu/REM_E3_model_fixed/commit/b5bfb62) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-09 00:16:01  
**Message:**
```
debug(#38): add comprehensive final test debug and clean up initial test debug

- Add DEBUG-FLAT-LINE tracking for final test performance by initial position
- Comment out previous DEBUG-DISTORTION-POS1 and DEBUG-RESTORE debug prints
- Focus debugging on understanding flat line issue in final test predictions
- Track relationship between initial_testpos and final test performance

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/b5bfb62_20250909_001601_plot1.png)  
![](../plot_archive/b5bfb62_20250909_001601_plot2.png)  

## Commit [8f4527c](https://github.com/naszhu/REM_E3_model_fixed/commit/8f4527c) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:57:29  
**Message:**
```
debug(model-e1): add final test retrieval debugging for distorted traces

Add comprehensive debugging to final test evaluation to track why distorted traces aren't affecting predictions:
- Show memory pool size and number of distorted traces available
- Track which traces pass likelihood filter during final test
- Show whether distorted traces are being matched/retrieved
- Display final decision and odds for position 1 probes

This will help identify where the disconnect is between stored distorted traces and final test performance.

Related to #38: debug final test retrieval of distorted traces

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/8f4527c_20250908_235729_plot1.png)  
![](../plot_archive/8f4527c_20250908_235729_plot2.png)  

## Commit [ef87048](https://github.com/naszhu/REM_E3_model_fixed/commit/ef87048) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:48:44  
**Message:**
```
fix(model-e1): remove double probability check in probe distortion

Fix critical bug in distortion logic that was causing very low distortion rates:
- Remove redundant outer probability check (line 453)
- Was doing: rand() < prob AND rand() < prob for each feature
- Now correctly: rand() < prob for each feature only
- This fixes distortion probability from prob² to prob as intended

With 15% probability per feature:
- Before: 0.15² = 2.25% per feature, ~42% chance of any distortion
- After: 15% per feature, ~99.7% chance of any distortion (as expected)

Related to #38: fix distortion mechanism for proper probe storage analysis

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/ef87048_20250908_234844_plot1.png)  
![](../plot_archive/ef87048_20250908_234844_plot2.png)  

## Commit [709f5cc](https://github.com/naszhu/REM_E3_model_fixed/commit/709f5cc) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:45:11  
**Message:**
```
debug(model-e1): improve debug output formatting and clarity

Enhance debug visualization for easier analysis:
- Add word.item to distortion attempt messages
- Add clear section separators for each test position 1
- Add line breaks between tests to reduce visual clutter
- Show when no trace is added to close each test section

Related to #38: make debug output more readable for distortion analysis

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/709f5cc_20250908_234511_plot1.png)  
![](../plot_archive/709f5cc_20250908_234511_plot2.png)  

## Commit [3fec04f](https://github.com/naszhu/REM_E3_model_fixed/commit/3fec04f) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:41:11  
**Message:**
```
debug(model-e1): enhance debug output for distortion analysis

Add comprehensive debug output to investigate low distortion rates:
- Add probe type (target/foil) to restore debug messages
- Add distortion attempt debug in feature_updates for position 1
- Track distortion probability checks, success/failure, and feature counts
- Help identify if issue is distortion not happening or distorted probes not being stored

Related to #38: probe distortion debugging - investigate why few distorted traces

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/3fec04f_20250908_234111_plot1.png)  
![](../plot_archive/3fec04f_20250908_234111_plot2.png)  

## Commit [cd63bc8](https://github.com/naszhu/REM_E3_model_fixed/commit/cd63bc8) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:38:45  
**Message:**
```
debug(model-e1): limit debug output to first test position only

Filter debug prints to show only traces added for test position 1:
- Add test_position parameter to restore functions
- Only print when decision_isold == 0 AND test_position == 1
- Focus on first position where distortion probability is highest
- Should show more distorted probes being stored if distortion is working

Related to #38: E1 Model final test prediction by within-list testposition

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/cd63bc8_20250908_233845_plot1.png)  
![](../plot_archive/cd63bc8_20250908_233845_plot2.png)  

## Commit [d8c8e60](https://github.com/naszhu/REM_E3_model_fixed/commit/d8c8e60) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:38:31  
**Message:**
```
debug(model-e1): narrow debug output to NEW judgments only

Filter debug print statements to only show traces added when decision_isold == 0:
- Focus on items judged as NEW in both initial and final tests
- Reduce debug noise to better identify distorted probe storage patterns
- Help isolate distorted foils that fail recognition and get stored as traces

Related to #38: probe distortion debugging

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/d8c8e60_20250908_233831_plot1.png)  
![](../plot_archive/d8c8e60_20250908_233831_plot2.png)  

## Commit [106cb09](https://github.com/naszhu/REM_E3_model_fixed/commit/106cb09) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:38:14  
**Message:**
```
debug(model-e1): probe distortion tracing for #38

Add debugging functionality to track probe distortion in initial tests:
- Add distortion markers to word.item when probes are distorted
- Add debug print statements in restore functions to trace memory storage
- Fix immutable Word struct handling by creating new instances
- Enable verification of distorted probe storage affecting final test predictions

Related to #38: E1 Model final test prediction by within-list testposition

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/106cb09_20250908_233814_plot1.png)  
![](../plot_archive/106cb09_20250908_233814_plot2.png)  

## Commit [3c20774](https://github.com/naszhu/REM_E3_model_fixed/commit/3c20774) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:09:53  
**Message:**
```
finetune(predplot-e1): final test visualization and data representation

- Added grouping and mean calculation for `val` in the R plot to improve data clarity.
- Updated color palette for better visual distinction in the plot.
- Adjusted the plot's facet grid to ensure proper ordering of conditions.
- Modified the PNG output dimensions for better aspect ratio.

These changes aim to enhance the clarity and effectiveness of the visual outputs in the R plotting script.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots_finalt.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/3c20774_20250908_230953_plot1.png)  
![](../plot_archive/3c20774_20250908_230953_plot2.png)  

## Commit [9eee436](https://github.com/naszhu/REM_E3_model_fixed/commit/9eee436) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:24:35  
**Message:**
```
debug(model-e1): probe distortion tracing for issue 38

Add debugging functionality to track probe distortion in initial tests:
- Add distortion markers to word.item when probes are distorted
- Add debug print statements in restore functions to trace memory storage
- Fix immutable Word struct handling by creating new instances
- Enable verification of distorted probe storage affecting final test predictions

Related to issue 38: E1 Model final test prediction by within-list testposition

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/9eee436_20250908_232435_plot1.png)  
![](../plot_archive/9eee436_20250908_232435_plot2.png)  

## Commit [9eee436](https://github.com/naszhu/REM_E3_model_fixed/commit/9eee436) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:24:35  
**Message:**
```
debug(model-e1): probe distortion tracing for issue 38

Add debugging functionality to track probe distortion in initial tests:
- Add distortion markers to word.item when probes are distorted
- Add debug print statements in restore functions to trace memory storage
- Fix immutable Word struct handling by creating new instances
- Enable verification of distorted probe storage affecting final test predictions

Related to issue 38: E1 Model final test prediction by within-list testposition

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/9eee436_20250908_232435_plot1.png)  
![](../plot_archive/9eee436_20250908_232435_plot2.png)  

## Commit [566af51](https://github.com/naszhu/REM_E3_model_fixed/commit/566af51) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:32:28  
**Message:**
```
debug(model-e1): narrow debug output to NEW judgments only

Filter debug print statements to only show traces added when decision_isold == 0:
- Focus on items judged as NEW in both initial and final tests
- Reduce debug noise to better identify distorted probe storage patterns
- Help isolate distorted foils that fail recognition and get stored as traces

Related to issue 38: probe distortion debugging

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/566af51_20250908_233228_plot1.png)  
![](../plot_archive/566af51_20250908_233228_plot2.png)  

## Commit [9eee436](https://github.com/naszhu/REM_E3_model_fixed/commit/9eee436) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:24:35  
**Message:**
```
debug(model-e1): probe distortion tracing for issue 38

Add debugging functionality to track probe distortion in initial tests:
- Add distortion markers to word.item when probes are distorted
- Add debug print statements in restore functions to trace memory storage
- Fix immutable Word struct handling by creating new instances
- Enable verification of distorted probe storage affecting final test predictions

Related to issue 38: E1 Model final test prediction by within-list testposition

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/9eee436_20250908_232435_plot1.png)  
![](../plot_archive/9eee436_20250908_232435_plot2.png)  

## Commit [3c20774](https://github.com/naszhu/REM_E3_model_fixed/commit/3c20774) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 23:09:53  
**Message:**
```
finetune(predplot-e1): final test visualization and data representation

- Added grouping and mean calculation for `val` in the R plot to improve data clarity.
- Updated color palette for better visual distinction in the plot.
- Adjusted the plot's facet grid to ensure proper ordering of conditions.
- Modified the PNG output dimensions for better aspect ratio.

These changes aim to enhance the clarity and effectiveness of the visual outputs in the R plotting script.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots_finalt.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/3c20774_20250908_230953_plot1.png)  
![](../plot_archive/3c20774_20250908_230953_plot2.png)  

## Commit [b9429e6](https://github.com/naszhu/REM_E3_model_fixed/commit/b9429e6) (branch: `sep-8-final-test-within-list-issue38`)
**Time:** 2025-09-08 21:42:19  
**Message:**
```
merge(model-e1): Align to v6 e3, Merge branch 'sep-7-test'
```
![](../plot_archive/b9429e6_20250908_214219_plot1.png)  
![](../plot_archive/b9429e6_20250908_214219_plot2.png)  

## Commit [769c76d](https://github.com/naszhu/REM_E3_model_fixed/commit/769c76d) (branch: `sep-7-test`)
**Time:** 2025-09-08 17:34:49  
**Message:**
```
finetune(model-e1): A good intial test: adjust ku_base, hj_rate, and hj_base for model refinement

- Increased `ku_base` from 0.05 to 0.1 to modify the starting point of T.
- Decreased `hj_rate` from 2.0 to 0.8 to refine the growth rate of the increasing function.
- Decreased `hj_base` from 0.4 to 0.3 to adjust the starting point for CF calculations.

These changes aim to enhance the model's parameters and improve its alignment with experimental data.

Closes #37 got good between-list prediction
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/769c76d_20250908_173449_plot1.png)  
![](../plot_archive/769c76d_20250908_173449_plot2.png)  

## Commit [14b9dc2](https://github.com/naszhu/REM_E3_model_fixed/commit/14b9dc2) (branch: `sep-7-test`)
**Time:** 2025-09-08 02:40:35  
**Message:**
```
fix(model-e1): bug found hj asignment was incorrect

But still doens't seem right

- Moved the inclusion of `constants.jl` to follow `utils.jl` in both `JL_V6-6_2finalize.jl` and `run_parallel.sh` for better dependency management.
- Adjusted `hj_asymptote_increase_val`, `hj_rate`, and `hj_base` in `constants.jl` to refine the model's parameters.
- Corrected a logical error in `probe_evaluation` by ensuring the random threshold check uses the correct `h_j` value.

These changes aim to enhance code organization and improve model accuracy.

Refs #37
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/module_jl/utils.jl`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/14b9dc2_20250908_024035_plot1.png)  
![](../plot_archive/14b9dc2_20250908_024035_plot2.png)  

## Commit [c92f195](https://github.com/naszhu/REM_E3_model_fixed/commit/c92f195) (branch: `sep-7-test`)
**Time:** 2025-09-08 02:29:36  
**Message:**
```
explore(model-e1): between-list target drop mangnitude explore; no hj at all :

- Increased `hj_asymptote_increase_val` from 0.43 to 0.8 to enhance the growth rate of the increasing function.
- Decreased `hj_base` from 0.4 to 0.2 to modify the starting point for CF calculations.
- Updated the Z feature logic in `probe_evaluation` to disable the random threshold check for improved decision-making clarity.

These changes aim to refine the model's constants and enhance its alignment with experimental data.

Issue #36: It is closed.  Currently with these adjustment the changes will suffice within-list prediction

Closes #36
To be solved #37
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/c92f195_20250908_022936_plot1.png)  
![](../plot_archive/c92f195_20250908_022936_plot2.png)  

## Commit [3061afe](https://github.com/naszhu/REM_E3_model_fixed/commit/3061afe) (branch: `sep-7-test`)
**Time:** 2025-09-07 19:26:29  
**Message:**
```
finetune(model-e1): small criterion reinstate rate change

- Increased `n_simulations` from 500 to 2000 for more robust testing.
- Adjusted `v_criterion_initial` from 0.05 to 0.14 to improve initial criterion calculations.
- Modified `p_reinstate_rate` from 0.2 to 0.3 for better parameter alignment.
- Enabled y-axis limits in R plotting for improved visualization of accuracy metrics.

These changes aim to enhance model performance and visualization clarity.

Refs #36
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/3061afe_20250907_192629_plot1.png)  
![](../plot_archive/3061afe_20250907_192629_plot2.png)  

## Commit [6f385e6](https://github.com/naszhu/REM_E3_model_fixed/commit/6f385e6) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:56:53  
**Message:**
```
explore(model-e1): back to reasonable copy and criterion parameters

- Commented out the y-axis limits in R plotting to allow for dynamic scaling.
- Decreased `nnnow` from 0.94 to 0.8 for better parameter alignment.
- Increased `v_criterion_initial` from 0.001 to 0.05 to enhance initial criterion calculation.

These changes aim to improve the model's accuracy and visualization clarity.

Refs #36
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/6f385e6_20250907_185653_plot1.png)  
![](../plot_archive/6f385e6_20250907_185653_plot2.png)  

## Commit [447b475](https://github.com/naszhu/REM_E3_model_fixed/commit/447b475) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:46:55  
**Message:**
```
explore(model-e1): update constants for improved model alignment

very high copy very low criterion. They are always trading off

- Increased `nnnow` from 0.70 to 0.94 to adjust parameter alignment with E3.
- Changed `v_criterion_initial` from 0.26 to 0.001 for better initial criterion calculation.
- Updated `max_distortion_probes` from 12 to 20 and reduced `base_distortion_prob` from 0.4 to 0.15 to enhance content distortion modeling.

These changes aim to refine the model's constants and improve its alignment with experimental data.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/447b475_20250907_184655_plot1.png)  
![](../plot_archive/447b475_20250907_184655_plot2.png)  

## Commit [2388a2e](https://github.com/naszhu/REM_E3_model_fixed/commit/2388a2e) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:07:44  
**Message:**
```
explore(model-e1): change back kappa value (in aligning to E3)

Next step change copy param, but before that see what this looks like

- Increased `ku_base` from 0.01 to 0.15, `ks_base` from 0.95 to 0.47, `kb_base` from 0.95 to 0.55, and `kt_base` from 0.95 to 0.65 to better align with study requirements.
- Adjusted `hj_asymptote_increase_val` from 0.1 to 0.43 and `hj_base` from 0.3 to 0.4 for enhanced starting points in CF calculations.

These changes aim to refine the model's constants and improve its alignment with experimental data.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/2388a2e_20250907_180744_plot1.png)  
![](../plot_archive/2388a2e_20250907_180744_plot2.png)  

## Commit [2f603e3](https://github.com/naszhu/REM_E3_model_fixed/commit/2f603e3) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:06:04  
**Message:**
```
explore(model-e1): try lowest ku starting value

doesn't help much, might have to change copy param

- Decreased `ku_base` from 0.07 to 0.01 to lower the starting point of T.
- Reduced `fj_asymptote_decrease_val` from 0.07 to 0.01 for better asymptotic behavior.

These changes aim to enhance the model's constants and improve its alignment with study requirements.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/2f603e3_20250907_180604_plot1.png)  
![](../plot_archive/2f603e3_20250907_180604_plot2.png)  

## Commit [c43f557](https://github.com/naszhu/REM_E3_model_fixed/commit/c43f557) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:05:05  
**Message:**
```
explore(model-e1): increase kappa for (foil params)

doesn't hlep much

- Increased  from 7 to 12 to enhance content drift modeling.
- Updated , , and  values from 0.45 to 0.95 to better align with study requirements.

These changes aim to refine the model's constants and improve overall performance.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/c43f557_20250907_180505_plot1.png)  
![](../plot_archive/c43f557_20250907_180505_plot2.png)  

## Commit [f37907f](https://github.com/naszhu/REM_E3_model_fixed/commit/f37907f) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:04:21  
**Message:**
```
explore(model-e1): increase kappa for (foil params)

doesn't hlep much

- Increased  from 7 to 12 to enhance content drift modeling.
- Updated , , and  values from 0.45 to 0.95 to better align with study requirements.

These changes aim to refine the model's constants and improve overall performance.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/f37907f_20250907_180421_plot1.png)  
![](../plot_archive/f37907f_20250907_180421_plot2.png)  

## Commit [5a925b8](https://github.com/naszhu/REM_E3_model_fixed/commit/5a925b8) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:03:11  
**Message:**
```
explore(model-e1): increase kappa for (foil params)

doesn't hlep much

- Increased  from 7 to 12 to enhance content drift modeling.
- Updated , , and  values from 0.45 to 0.95 to better align with study requirements.

These changes aim to refine the model's constants and improve overall performance.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/5a925b8_20250907_180311_plot1.png)  
![](../plot_archive/5a925b8_20250907_180311_plot2.png)  

## Commit [d9b93be](https://github.com/naszhu/REM_E3_model_fixed/commit/d9b93be) (branch: `sep-7-test`)
**Time:** 2025-09-07 18:00:48  
**Message:**
```
explore(constants): increase kappa for (foil params)

doesn't hlep much

- Increased `max_distortion_probes` from 7 to 12 to enhance content drift modeling.
- Updated `ks_base`, `kb_base`, and `kt_base` values from 0.45 to 0.95 to better align with study requirements.

These changes aim to refine the model's constants and improve overall performance.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/d9b93be_20250907_180048_plot1.png)  
![](../plot_archive/d9b93be_20250907_180048_plot2.png)  

## Commit [1acd464](https://github.com/naszhu/REM_E3_model_fixed/commit/1acd464) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:55:46  
**Message:**
```
explore(model-e1): change UC ratio - raising performance

Doesn't help much by changing this

- Updated `ratio_unchanging_to_itself_init` from 0.46 to 0.3 for better alignment with experimental conditions.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/1acd464_20250907_175546_plot1.png)  
![](../plot_archive/1acd464_20250907_175546_plot2.png)  

## Commit [537f262](https://github.com/naszhu/REM_E3_model_fixed/commit/537f262) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:52:37  
**Message:**
```
finetune(model-e1): update v_criterion_initial for improved model accuracy

- Increased `v_criterion_initial` from 0.15 to 0.18, enhancing the model's parameterization for better alignment with simulation requirements.

This change aims to refine the model's constants and improve overall performance.

Refs #36
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/537f262_20250907_175237_plot1.png)  
![](../plot_archive/537f262_20250907_175237_plot2.png)  

## Commit [33bcdb9](https://github.com/naszhu/REM_E3_model_fixed/commit/33bcdb9) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:50:46  
**Message:**
```
finetune(model-e1): update simulation parameters, increase overall performance

- Changed `is_finaltest` to false and adjusted `n_simulations` to 500 for testing purposes.
- Updated `u_star_v` to 0.04 and modified `adv_u_star_strengthen` and `adv_c_strenghten` to 0.00 for improved model behavior.
- Revised `v_criterion_initial` to 0.15 and increased `base_distortion_prob` to 0.4 for better content distortion accuracy.
- Adjusted y-axis limits in R plotting from (0, 1) to (0.825, 0.95) for enhanced visualization of accuracy metrics.

These changes aim to refine the model's constants and improve the clarity of simulation results.

Refs #36
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/33bcdb9_20250907_175046_plot1.png)  
![](../plot_archive/33bcdb9_20250907_175046_plot2.png)  

## Commit [1a066bc](https://github.com/naszhu/REM_E3_model_fixed/commit/1a066bc) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:21:37  
**Message:**
```
finetune(model-e1): intiial prediction update kappa and asymptote parameters

- Adjusted the initial value of `ku_base` from 0.15 to 0.25 to better reflect study requirements.
- Modified `fj_asymptote_decrease_val` from 0.01 to 0.1, and `hj_asymptote_increase_val` from 0.4 to 0.1 for improved model accuracy.
- Updated `hj_base` from 0.6 to 0.3 to enhance the starting point for CF calculations.
- Changed the calculation of `v_criterion_initial` to use exponentiation with `power_taken`, ensuring correct parameterization.

These changes aim to refine the model's constants for better alignment with experimental data.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/1a066bc_20250907_172137_plot1.png)  
![](../plot_archive/1a066bc_20250907_172137_plot2.png)  

## Commit [efa235b](https://github.com/naszhu/REM_E3_model_fixed/commit/efa235b) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:14:36  
**Message:**
```
feat(predplot-e1):  add sampling accuracy plots

- Updated the DataFrame structures in `simulation.jl` to include new fields `is_sampled` and `is_same_item`, improving data tracking during simulations.
- Modified the `probe_evaluation` function to store additional sampling information.
- Introduced sampling accuracy plots in R scripts, allowing for better visualization of sampling performance based on new data fields.
- Adjusted plotting logic to conditionally include sampling accuracy plots based on the presence of relevant columns.

These changes aim to improve the analysis and visualization of simulation results, enhancing the overall functionality of the modeling framework.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/R_ploting/R_plots_finalt.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/simulation.jl`  
![](../plot_archive/efa235b_20250907_171436_plot1.png)  
![](../plot_archive/efa235b_20250907_171436_plot2.png)  

## Commit [b5c8dec](https://github.com/naszhu/REM_E3_model_fixed/commit/b5c8dec) (branch: `sep-7-test`)
**Time:** 2025-09-07 17:08:16  
**Message:**
```
feat(predplot-e1):  add sampling accuracy plots

- Updated the DataFrame structures in `simulation.jl` to include new fields `is_sampled` and `is_same_item`, improving data tracking during simulations.
- Modified the `probe_evaluation` function to store additional sampling information.
- Introduced sampling accuracy plots in R scripts, allowing for better visualization of sampling performance based on new data fields.
- Adjusted plotting logic to conditionally include sampling accuracy plots based on the presence of relevant columns.

These changes aim to improve the analysis and visualization of simulation results, enhancing the overall functionality of the modeling framework.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/R_ploting/R_plots_finalt.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/simulation.jl`  
![](../plot_archive/b5c8dec_20250907_170816_plot1.png)  
![](../plot_archive/b5c8dec_20250907_170816_plot2.png)  

## Commit [de1f74d](https://github.com/naszhu/REM_E3_model_fixed/commit/de1f74d) (branch: `sep-7-test`)
**Time:** 2025-09-07 16:29:41  
**Message:**
```
fix(constants): put criterion power to 1
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/de1f74d_20250907_162941_plot1.png)  
![](../plot_archive/de1f74d_20250907_162941_plot2.png)  

## Commit [4b697f6](https://github.com/naszhu/REM_E3_model_fixed/commit/4b697f6) (branch: `sep-7-test`)
**Time:** 2025-09-07 16:18:36  
**Message:**
```
fix(rshell): The plot saving path is wrong

- Modified the script to run from the root directory, ensuring consistent path references for file operations.
- Updated file copy commands to reflect the new directory structure, improving clarity and organization.
- Adjusted R plotting commands to use the correct paths, ensuring plots are generated accurately.
- Enhanced output messages to provide better context during execution.

These changes aim to streamline the execution process and maintain consistency with the main file's structure.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/4b697f6_20250907_161836_plot1.png)  
![](../plot_archive/4b697f6_20250907_161836_plot2.png)  

## Commit [f72a1e0](https://github.com/naszhu/REM_E3_model_fixed/commit/f72a1e0) (branch: `sep-7-test`)
**Time:** 2025-09-07 16:07:16  
**Message:**
```
fix(shell): fix the bug in data processing

- Removed aggregation steps from the initial simulation results, now saving raw data directly to CSV files.
- Introduced a new aggregation step after combining results, ensuring clarity and separation of raw data and processed outputs.
- Updated the script to handle the creation of aggregated CSV files for both initial and final test results, improving data management.

These changes enhance the organization of simulation outputs and facilitate easier analysis of raw and aggregated data.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/f72a1e0_20250907_160716_plot1.png)  
![](../plot_archive/f72a1e0_20250907_160716_plot2.png)  

## Commit [635e569](https://github.com/naszhu/REM_E3_model_fixed/commit/635e569) (branch: `sep-7-test`)
**Time:** 2025-09-07 16:03:23  
**Message:**
```
fix(shell): fix the bug in data processing

- Removed aggregation steps from the initial simulation results, now saving raw data directly to CSV files.
- Introduced a new aggregation step after combining results, ensuring clarity and separation of raw data and processed outputs.
- Updated the script to handle the creation of aggregated CSV files for both initial and final test results, improving data management.

These changes enhance the organization of simulation outputs and facilitate easier analysis of raw and aggregated data.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/635e569_20250907_160323_plot1.png)  
![](../plot_archive/635e569_20250907_160323_plot2.png)  

## Commit [d3306de](https://github.com/naszhu/REM_E3_model_fixed/commit/d3306de) (branch: `main`)
**Time:** 2025-09-07 13:29:19  
**Message:**
```
merge(model-e1): align: Merge branch 'sep-4-align'
```
![](../plot_archive/d3306de_20250907_132919_plot1.png)  
![](../plot_archive/d3306de_20250907_132919_plot2.png)  

## Commit [8084edc](https://github.com/naszhu/REM_E3_model_fixed/commit/8084edc) (branch: `sep-4-align`)
**Time:** 2025-09-05 02:53:37  
**Message:**
```
finetune(model-e1): match simulation parameters

- Set `is_finaltest` to true and increased `n_simulations` to 3000 for enhanced testing.
- Adjusted the copying parameter `c` to align with new E3 specifications, lowering it to 0.70.
- Updated `p_reinstate_rate` to 0.2 and modified `n_driftStudyTest` and `n_between_listchange` for better alignment with E3 requirements.
- Reduced `base_distortion_prob` to 0.29 to improve content distortion accuracy.

These changes aim to enhance the simulation's fidelity and ensure better alignment with the E3 model specifications.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/8084edc_20250905_025337_plot1.png)  
![](../plot_archive/8084edc_20250905_025337_plot2.png)  

## Commit [2c527a0](https://github.com/naszhu/REM_E3_model_fixed/commit/2c527a0) (branch: `sep-4-align`)
**Time:** 2025-09-05 02:43:29  
**Message:**
```
fix(model-e1): refine Z feature calculations and update restoration logic

The previous one was wrong

- Consolidated the calculation of κ parameters in `constants.jl`, ensuring they are computed after loading necessary modules.
- Enhanced the Z feature update functions in `feature_updates.jl` to align with E3 specifications, improving the accuracy of memory recall processes.
- Updated the logic in `memory_restorage.jl` to handle Z feature updates during strengthening, reflecting the new probabilistic approaches.
- Removed redundant utility functions from `utils.jl`, streamlining the codebase and improving maintainability.

These changes aim to enhance the integration and functionality of Z features within the memory model, ensuring better alignment with E3 rules.

Refs #31, naszhu/REM_E3_model_fixed#64
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/utils.jl`  
- `design1/modeling/run_parallel.sh`  
- `design1/modeling/simulation.jl`  
- `design3/modeling`  
![](../plot_archive/2c527a0_20250905_024329_plot1.png)  
![](../plot_archive/2c527a0_20250905_024329_plot2.png)  

## Commit [31bdab1](https://github.com/naszhu/REM_E3_model_fixed/commit/31bdab1) (branch: `sep-4-align`)
**Time:** 2025-09-05 01:28:49  
**Message:**
```
feat(model-e1): update Z feature implementation and parameter calculations

- Rearranged the loading order of utility and constant files in `JL_V6-6_2finalize.jl` and `run_parallel.sh` to ensure proper initialization of Z feature parameters.
- Introduced new functions in `utils.jl` for managing Z feature values, enhancing the alignment with E3 rules for memory simulations.
- Updated the logic for Z feature updates during restoration and probe generation to reflect E3 specifications, improving the accuracy of memory recall processes.
- Adjusted the R plotting script to modify the y-axis limits for better visualization of accuracy metrics.

These changes aim to refine the Z feature integration and enhance the overall functionality of the memory model.

Refs #31, naszhu/REM_E3_model_fixed#64
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
- `design1/modeling/module_jl/utils.jl`  
- `design1/modeling/run_parallel.sh`  
- `design1/modeling/simulation.jl`  
- `design3/modeling`  
![](../plot_archive/31bdab1_20250905_012849_plot1.png)  
![](../plot_archive/31bdab1_20250905_012849_plot2.png)  

## Commit [503f3ba](https://github.com/naszhu/REM_E3_model_fixed/commit/503f3ba) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:30:27  
**Message:**
```
refactor(constants): relocate Z feature parameter calculations for improved organization

- Moved the calculation of κu and h_j parameters to the constants.jl file after all includes are loaded, enhancing the clarity of parameter initialization.
- Updated the base distortion probability from 0.29 to 0.35 to better align with model requirements.

These changes aim to streamline the parameter setup process and improve the overall structure of the code.

Refs #31
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/503f3ba_20250904_223027_plot1.png)  
![](../plot_archive/503f3ba_20250904_223027_plot2.png)  

## Commit [0f1458d](https://github.com/naszhu/REM_E3_model_fixed/commit/0f1458d) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:21:05  
**Message:**
```
refactor(constants): move utility function to utils and clean up code

- Removed the `asym_increase_shift` function from `constants.jl` and relocated it to `utils.jl` for better organization of utility functions.
- This change aims to enhance code clarity and maintainability by consolidating utility functions in a dedicated file.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/utils.jl`  
![](../plot_archive/0f1458d_20250904_222105_plot1.png)  
![](../plot_archive/0f1458d_20250904_222105_plot2.png)  

## Commit [f1b0155](https://github.com/naszhu/REM_E3_model_fixed/commit/f1b0155) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:20:24  
**Message:**
```
chore(.gitignore): add entries for parallel execution temporary directories

- Updated .gitignore to include directories for temporary files and results generated during parallel execution, ensuring a cleaner repository by ignoring unnecessary files.

This change aims to streamline the development process by preventing clutter from temporary execution artifacts.
```
**Changed Files:**
- `.gitignore`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/f1b0155_20250904_222024_plot1.png)  
![](../plot_archive/f1b0155_20250904_222024_plot2.png)  

## Commit [1ca3cb4](https://github.com/naszhu/REM_E3_model_fixed/commit/1ca3cb4) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:17:04  
**Message:**
```
feat(shell-e1): add parallel execution script for enhanced simulation performance

- Introduced a new script `run_parallel.sh` to facilitate multi-process execution of the E1 model simulations, significantly improving runtime efficiency.
- The script manages process creation, result collection, and combines outputs into CSV files, mirroring the results of the original `JL_V6-6_2finalize.jl` script.
- Added functionality for progress monitoring and debugging, ensuring clarity during execution.
- Integrated R plotting commands to generate visual outputs post-simulation, maintaining consistency with previous outputs.

These enhancements aim to optimize simulation performance and streamline the workflow for model testing and analysis.

Refs #34
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/run_parallel.sh`  
![](../plot_archive/1ca3cb4_20250904_221704_plot1.png)  
![](../plot_archive/1ca3cb4_20250904_221704_plot2.png)  

## Commit [b3e5188](https://github.com/naszhu/REM_E3_model_fixed/commit/b3e5188) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:03:30  
**Message:**
```
feat(model-e1): enhance content distortion and parameter integration

- Added new advantage parameters `u_star_adv` and `c_adv` to align with E3 specifications.
- Refactored context copying parameters to use `fill` instead of `LinRange` for consistency.
- Introduced content distortion functions with linear decay in probability for probe features, enhancing the model's ability to simulate content drift between study and test phases.
- Updated probe generation logic to apply content distortion based on new parameters, improving the realism of memory simulations.

These changes aim to refine the modeling framework by integrating advanced distortion mechanisms and ensuring parameter consistency across the system.

Closes #32
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
![](../plot_archive/b3e5188_20250904_220330_plot1.png)  
![](../plot_archive/b3e5188_20250904_220330_plot2.png)  

## Commit [8470ac7](https://github.com/naszhu/REM_E3_model_fixed/commit/8470ac7) (branch: `sep-4-align`)
**Time:** 2025-09-04 22:03:23  
**Message:**
```
feat(model-e1): enhance content distortion and parameter integration

- Added new advantage parameters `u_star_adv` and `c_adv` to align with E3 specifications.
- Refactored context copying parameters to use `fill` instead of `LinRange` for consistency.
- Introduced content distortion functions with linear decay in probability for probe features, enhancing the model's ability to simulate content drift between study and test phases.
- Updated probe generation logic to apply content distortion based on new parameters, improving the realism of memory simulations.

These changes aim to refine the modeling framework by integrating advanced distortion mechanisms and ensuring parameter consistency across the system.

Closes #32
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/probe_generation.jl`  
![](../plot_archive/8470ac7_20250904_220323_plot1.png)  
![](../plot_archive/8470ac7_20250904_220323_plot2.png)  

## Commit [15d8c4a](https://github.com/naszhu/REM_E3_model_fixed/commit/15d8c4a) (branch: `sep-4-align`)
**Time:** 2025-09-04 21:37:32  
**Message:**
```
feat(model-e1): refactor feature restoration functions for clarity and functionality

- Renamed `add_features_from_empty!` to `add_feature_during_restore!` for better clarity in purpose.
- Introduced `strengthen_features!` function to enhance feature restoration logic during memory processes.
- Updated calls to the new function names in `restore_intest` and `restore_intest_final` for consistency.
- Improved handling of context and content features, ensuring proper integration of parameters during restoration.

These changes aim to streamline the feature restoration process and improve the overall functionality of the memory restoration logic.

Refs #33, #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/15d8c4a_20250904_213732_plot1.png)  
![](../plot_archive/15d8c4a_20250904_213732_plot2.png)  

## Commit [dad2933](https://github.com/naszhu/REM_E3_model_fixed/commit/dad2933) (branch: `sep-4-align`)
**Time:** 2025-09-04 21:13:35  
**Message:**
```
feat(model-e1): implement Z feature parameters and update restoration logic

The first working version but haven't checked through yet
- Introduced Z feature parameters and logic for E1, including κu values and associated functions for feature updates during study and restoration.
- Updated the restore_features! function to handle Z features specifically, ensuring proper integration into the memory restoration process.
- Enhanced the probe evaluation logic to incorporate Z feature decisions, improving the model's accuracy in distinguishing between old and new items.
- Adjusted the memory storage to accommodate Z features, ensuring compatibility with existing structures.

These changes aim to enhance the modeling framework by integrating new features that improve recall accuracy and overall performance in simulations.

Refs #31
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_generation.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/memory_storage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/module_jl/utils.jl`  
- `design3/modeling`  
![](../plot_archive/dad2933_20250904_211335_plot1.png)  
![](../plot_archive/dad2933_20250904_211335_plot2.png)  

## Commit [853d96c](https://github.com/naszhu/REM_E3_model_fixed/commit/853d96c) (branch: `sep-4-align`)
**Time:** 2025-09-04 00:57:22  
**Message:**
```
docs(model-e1): correct command syntax in R script execution

- Removed an extraneous 'git' from the command that runs the R script for plotting.
- Ensured the command syntax is clean and functional for proper execution.

This change aims to enhance the reliability of the script execution process in the modeling workflow.
```
**Changed Files:**
- `.vscode/settings.json`  
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/853d96c_20250904_005722_plot1.png)  
![](../plot_archive/853d96c_20250904_005722_plot2.png)  

## Commit [1476220](https://github.com/naszhu/REM_E3_model_fixed/commit/1476220) (branch: `main`)
**Time:** 2025-08-26 01:37:32  
**Message:**
```
feat(vscode): add settings for Solarized Dark theme

- Introduced a new settings file for Visual Studio Code to set the color theme to Solarized Dark.

This addition aims to enhance the development environment's visual appeal and user experience.
```
**Changed Files:**
- `.vscode/settings.json`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/1476220_20250826_013732_plot1.png)  
![](../plot_archive/1476220_20250826_013732_plot2.png)  

## Commit [f20ed39](https://github.com/naszhu/REM_E3_model_fixed/commit/f20ed39) (branch: `main`)
**Time:** 2025-08-23 00:34:25  
**Message:**
```
docs(all): add meeting log for August 21

- Introduced a new document detailing discussions and insights from the meeting held on August 21.
- The log covers key topics such as parameter separation, recall mechanisms, and the importance of origin information in trace sampling.

This addition aims to enhance project documentation and provide clarity on decision-making processes discussed during the meeting.
```
**Changed Files:**
- `Docs/meetinglog_aug_21.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/f20ed39_20250823_003425_plot1.png)  
![](../plot_archive/f20ed39_20250823_003425_plot2.png)  

## Commit [5626141](https://github.com/naszhu/REM_E3_model_fixed/commit/5626141) (branch: `main`)
**Time:** 2025-08-23 00:34:00  
**Message:**
```
docs(all): add meeting log for August 21

- Introduced a new document detailing discussions and insights from the meeting held on August 21.
- The log covers key topics such as parameter separation, recall mechanisms, and the importance of origin information in trace sampling.

This addition aims to enhance project documentation and provide clarity on decision-making processes discussed during the meeting.
```
**Changed Files:**
- `Docs/meetinglog_aug_21.md`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/5626141_20250823_003400_plot1.png)  
![](../plot_archive/5626141_20250823_003400_plot2.png)  

## Commit [2e48543](https://github.com/naszhu/REM_E3_model_fixed/commit/2e48543) (branch: `main`)
**Time:** 2025-08-19 09:46:57  
**Message:**
```
merge(model-e1)Update documentation and parameters for E1 and E3 models

- Updated the DataPlot documents with new timestamps and added new documents for Dataplot-e1-aug19 and Dataplot-e2-aug12.
- Introduced a new HTML document for research parameters, detailing the comparison between E1 and E3 models.
- Adjusted simulation parameters in the modeling scripts to enhance accuracy and consistency across tests.
- Added new HTML files for parameter comparisons and research documentation to improve project clarity and resource availability.

These changes aim to enhance the documentation and improve the modeling framework for better simulation outcomes.
```
![](../plot_archive/2e48543_20250819_094657_plot1.png)  
![](../plot_archive/2e48543_20250819_094657_plot2.png)  

## Commit [24fbb28](https://github.com/naszhu/REM_E3_model_fixed/commit/24fbb28) (branch: `main`)
**Time:** 2025-08-15 23:11:23  
**Message:**
```
finetune(model-e3): modify simulation parameters for final test

- Set `is_finaltest` to true and adjusted `n_simulations` to 300 for final testing.
- Disabled `adv_u_star_strengthen` and `adv_c_strenghten` by setting them to 0.
- Updated `p_ListChange_finaltest` to a new value of 0.2 to refine test conditions.

These changes aim to enhance the accuracy and reliability of the final test simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/24fbb28_20250815_231123_plot1.png)  
![](../plot_archive/24fbb28_20250815_231123_plot2.png)  

## Commit [0b14341](https://github.com/naszhu/REM_E3_model_fixed/commit/0b14341) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 22:00:22  
**Message:**
```
doc(model-e1,e3): parameter chart
```
**Changed Files:**
- `design1/docs/E1_vs_E3_parameter_comparison.html`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/docs/Research Parameters - Updated from Code.html`  
![](../plot_archive/0b14341_20250817_220022_plot1.png)  
![](../plot_archive/0b14341_20250817_220022_plot2.png)  

## Commit [62e2966](https://github.com/naszhu/REM_E3_model_fixed/commit/62e2966) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 22:00:02  
**Message:**
```
doc(model-e3): new document for Dataplot-e2-aug12

- Introduced a new binary document file for Dataplot-e2-aug12 to support ongoing analysis and documentation efforts.

This addition aims to enhance the project's documentation resources.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design3/docs/Dataplot-e2-aug12 (1).docx`  
![](../plot_archive/62e2966_20250817_220002_plot1.png)  
![](../plot_archive/62e2966_20250817_220002_plot2.png)  

## Commit [4aebceb](https://github.com/naszhu/REM_E3_model_fixed/commit/4aebceb) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 21:47:34  
**Message:**
```
finetune(model-e1): 2000 simulation

- Increased `n_simulations` from 400 to 2000 to enhance testing robustness.
- Adjusted `n_lists` from 4 to 10 to allow for more comprehensive data analysis.
- Modified `c` parameter from 0.86 to 0.895 for better context copying behavior.
- Decreased `v_criterion_initial` from 0.73 to 0.65 to align with model expectations.
- Updated z-value increase parameters for targets and foils to refine classification accuracy.

These changes aim to improve the model's performance and accuracy in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/4aebceb_20250817_214734_plot1.png)  
![](../plot_archive/4aebceb_20250817_214734_plot2.png)  

## Commit [00bf5a8](https://github.com/naszhu/REM_E3_model_fixed/commit/00bf5a8) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 21:21:12  
**Message:**
```
finetune(model-e1): continue fine tune bewteen-list
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/00bf5a8_20250817_212112_plot1.png)  
![](../plot_archive/00bf5a8_20250817_212112_plot2.png)  

## Commit [2760ebc](https://github.com/naszhu/REM_E3_model_fixed/commit/2760ebc) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 21:11:51  
**Message:**
```
finetune(model-e1): a good start of between-list list 1

- Adjusted `adv_u_star_strengthen` to 0.06 and `adv_c_strenghten` to 0.1 to enhance feature restoration logic.
- Corrected `c` parameter to 0.8 for consistency in copying behavior.
- Updated `v_criterion_initial` to 0.78 for better alignment with model expectations.
- Increased `n_driftStudyTest` from 9 to 10 to refine testing conditions.

These changes aim to improve the model's performance and accuracy in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/2760ebc_20250817_211151_plot1.png)  
![](../plot_archive/2760ebc_20250817_211151_plot2.png)  

## Commit [8041eef](https://github.com/naszhu/REM_E3_model_fixed/commit/8041eef) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 21:11:03  
**Message:**
```
finetune(model-e1): a good start of between-list list 1

- Adjusted `adv_u_star_strengthen` to 0.06 and `adv_c_strenghten` to 0.1 to enhance feature restoration logic.
- Corrected `c` parameter to 0.8 for consistency in copying behavior.
- Updated `v_criterion_initial` to 0.78 for better alignment with model expectations.
- Increased `n_driftStudyTest` from 9 to 10 to refine testing conditions.

These changes aim to improve the model's performance and accuracy in simulations.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/8041eef_20250817_211103_plot1.png)  
![](../plot_archive/8041eef_20250817_211103_plot2.png)  

## Commit [deb6cc2](https://github.com/naszhu/REM_E3_model_fixed/commit/deb6cc2) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 18:30:45  
**Message:**
```
finetune(model-e1): 23 tune, between-list prediction (while keep u_star)

- Set `is_finaltest` to false and reduced `n_simulations` to 800 for more efficient testing.
- Decreased `n_lists` from 10 to 4 to streamline the simulation process.
- Updated `v_criterion_initial` to 0.87 for better alignment with model expectations.
- Modified base probabilities for targets and foils to enhance recall accuracy.
- Adjusted z-value increase parameters to refine target and foil classifications.

These changes aim to enhance the model's performance and accuracy in simulations.

-  NEXT STEP: chagne u_star

Refs #23 decrease target tunning
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/deb6cc2_20250817_183045_plot1.png)  
![](../plot_archive/deb6cc2_20250817_183045_plot2.png)  

## Commit [60f945c](https://github.com/naszhu/REM_E3_model_fixed/commit/60f945c) (branch: `HEAD`)
**Time:** 2025-08-17 18:13:47  
**Message:**
```
finetune(model-e3): 23 tune, between-list prediction (while keep u_star)

- Set `is_finaltest` to false and reduced `n_simulations` to 800 for more efficient testing.
- Decreased `n_lists` from 10 to 4 to streamline the simulation process.
- Updated `v_criterion_initial` to 0.87 for better alignment with model expectations.
- Modified base probabilities for targets and foils to enhance recall accuracy.
- Adjusted z-value increase parameters to refine target and foil classifications.

These changes aim to enhance the model's performance and accuracy in simulations.

-  NEXT STEP: chagne u_star

Refs #23 decrease target tunning
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/60f945c_20250817_181347_plot1.png)  
![](../plot_archive/60f945c_20250817_181347_plot2.png)  

## Commit [2abbe3a](https://github.com/naszhu/REM_E3_model_fixed/commit/2abbe3a) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 17:40:20  
**Message:**
```
fix(model-e3): adjust 1/11 odds calculation for likelihood ratios

fix(probe_evaluation)
- Updated odds calculation in both `probe_evaluation` and `probe_evaluation2` functions to raise the sum of likelihood ratios to the power of `power_taken`.
- This change aims to enhance the accuracy of the odds computation in the evaluation process.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/2abbe3a_20250817_174020_plot1.png)  
![](../plot_archive/2abbe3a_20250817_174020_plot2.png)  

## Commit [fc6a15d](https://github.com/naszhu/REM_E3_model_fixed/commit/fc6a15d) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 17:05:03  
**Message:**
```
finetune(model-e1): tune base start of product z, and it does work

It worked in making T down, partially solve #23 issue

finetune(R_plots): adjust y-axis limits for accuracy visualization

- Updated y-axis limits in R plotting script from (0.825, 0.95) to (0.425, 0.95) to better reflect data range.
- Commented out the previous ylim setting for clarity.

finetune(constants): modify simulation parameters for consistency

- Reduced `n_simulations` from 300 to 200 for final tests to streamline performance.
- Increased `how_much_z_T` from 0.12 to 0.5 to enhance target z-value adjustments.

These changes aim to improve the accuracy and efficiency of the model's simulations and visualizations.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/fc6a15d_20250817_170503_plot1.png)  
![](../plot_archive/fc6a15d_20250817_170503_plot2.png)  

## Commit [8bf5112](https://github.com/naszhu/REM_E3_model_fixed/commit/8bf5112) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-17 16:58:53  
**Message:**
```
feat(model-e1): list of  origin recall logic

- Updated decision-making process to utilize list origin recall instead of familiarity for final test probes.
- Introduced z-value calculations for target and foil classifications to enhance accuracy in determining probe origins.
- Adjusted decision thresholds based on recall odds, improving the model's predictive capabilities in the final evaluation phase.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/8bf5112_20250817_165853_plot1.png)  
![](../plot_archive/8bf5112_20250817_165853_plot2.png)  

## Commit [b3aeed9](https://github.com/naszhu/REM_E3_model_fixed/commit/b3aeed9) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-16 18:57:41  
**Message:**
```
feat(model-e1): add list origin parameters and remove RT dependencies

- Add E1 list origin parameters (z_time_p_val_E1) for targets and foils
- Implement asym_increase_shift function for gradual parameter evolution
- Remove all RT-related parameters and calculations (Brt, Pi, rt fields)
- Fix DataFrame structure to match new data format (diff instead of diff_rt)
- Update R plotting script to handle column name changes
- Resolve dependency chain issues for clean E1 model execution

Theoretical rationale: E1 participants need list origin focus (not discrimination)
as memory accumulates across lists, even without confusing foils like E3.
```
**Changed Files:**
- `design1/modeling/R_ploting/R_plots.r`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
- `design1/modeling/simulation.jl`  
![](../plot_archive/b3aeed9_20250816_185741_plot1.png)  
![](../plot_archive/b3aeed9_20250816_185741_plot2.png)  

## Commit [358fa11](https://github.com/naszhu/REM_E3_model_fixed/commit/358fa11) (branch: `aug-15-issue23-targetdrop`)
**Time:** 2025-08-15 23:11:38  
**Message:**
```
merge(model-e3): merge aug-12-explore-more-alignment branch

- Incorporates strengthening advance parameters exploration
- Includes final test parameter adjustments and simulation improvements
- Merges commits addressing issue #22 within-list prediction improvements
- Consolidates E3 model refinements and feature restoration logic updates

This merge brings together parameter tuning work and simulation enhancements for the E3 model.
```
![](../plot_archive/358fa11_20250815_231138_plot1.png)  
![](../plot_archive/358fa11_20250815_231138_plot2.png)  

## Commit [58f69f1](https://github.com/naszhu/REM_E3_model_fixed/commit/58f69f1) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-15 22:55:00  
**Message:**
```
refactor(model-e1): introduce strengthening advance parameters

- Added new parameters `adv_u_star_strengthen` and `adv_c_strenghten` to improve feature restoration logic.
- Updated target feature assignment to incorporate these new parameters, enhancing simulation accuracy.

These changes aim to refine the model's predictive capabilities and strengthen the feature restoration process.
```
**Changed Files:**
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/58f69f1_20250815_225500_plot1.png)  
![](../plot_archive/58f69f1_20250815_225500_plot2.png)  

## Commit [52c351e](https://github.com/naszhu/REM_E3_model_fixed/commit/52c351e) (branch: `HEAD`)
**Time:** 2025-08-15 22:52:20  
**Message:**
```
explore(model-e1): solve 22, within-list: update ratio parameters and restore feature logic

- Reintroduced ratio parameters for initial and final tests
- Adjusted v_criterion_initial from 0.001^power_taken to 0.01^power_taken
- Modified recall_odds_threshold to 0.0^power_taken
- Updated feature restoration logic for target feature assignment

These changes improve simulation consistency and accuracy.

Refs #22: taking out strenghtening advantage makes good within-list prediction
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
![](../plot_archive/52c351e_20250815_225220_plot1.png)  
![](../plot_archive/52c351e_20250815_225220_plot2.png)  

## Commit [979774a](https://github.com/naszhu/REM_E3_model_fixed/commit/979774a) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-15 22:34:31  
**Message:**
```
feat(simulation): restore progress prints for simulation monitoring
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/simulation.jl`  
![](../plot_archive/979774a_20250815_223431_plot1.png)  
![](../plot_archive/979774a_20250815_223431_plot2.png)  

## Commit [59a0bf5](https://github.com/naszhu/REM_E3_model_fixed/commit/59a0bf5) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-13 00:22:39  
**Message:**
```
fix(constants): update v_criterion_initial and recall_odds_threshold for final test OI

- Changed v_criterion_initial from 0.25^power_taken to 0.001^power_taken to align with E3 standards.
- Adjusted recall_odds_threshold from 0.3^power_taken to 0.0001^power_taken for better threshold calibration.

Doesn't really create OI in final test though
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/59a0bf5_20250813_002239_plot1.png)  
![](../plot_archive/59a0bf5_20250813_002239_plot2.png)  

## Commit [9de0593](https://github.com/naszhu/REM_E3_model_fixed/commit/9de0593) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 23:42:02  
**Message:**
```
fix(model-e1): correct critical sampling and strengthening bugs in E1 modeling

CRITICAL FIXES:
- sampling_method: false → true (enables probabilistic sampling instead of argmax)
- is_strengthen_contextandcontent: false → true (enables trace strengthening during training)

ADDITIONAL CHANGES:
- n_simulations: 500 → 1000 (doubled simulation count)
- p_reinstate_context: 1.0 → 0.8 (reduced reinstatement threshold)
- n_between_listchange: 25 → 18 (reduced between-list change steps)
- final_gap_change: 0.1 → 0.16 (increased final test gap)
- ratio_unchanging_to_itself_final: [0.5,0.5] → [1,1] (full unchanging context in final)
- ratio_changing_to_itself_final: [0.1,0.1] → [0.3,0.3] (increased changing context in final)

COMMENTS ADDED:
- Added note about p_reinstate_context needing to be 1 for E3
- Added note about final_gap_change being 0.16 in E3
- Added note about p_ListChange_finaltest being 0.8 in E3 but undecided

These bugs prevented proper model functionality - no strengthening occurred and wrong sampling method was used.

Closes #21
Refs Align #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
![](../plot_archive/9de0593_20250812_234202_plot1.png)  
![](../plot_archive/9de0593_20250812_234202_plot2.png)  

## Commit [6e9b623](https://github.com/naszhu/REM_E3_model_fixed/commit/6e9b623) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 23:06:09  
**Message:**
```
finetune(model-E3): update ratio and drift study parameters for improved simulation accuracy

- Adjusted ratio_unchanging_to_itself_init from 0.4 to 0.46 to enhance model performance.
- Increased n_driftStudyTest from 9 to 12 to better reflect testing conditions.

These changes aim to refine the simulation parameters for more accurate results in the modeling framework.

Refs #13
```
**Changed Files:**
- `Docs/DataPlot-d3(exp2).docx`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/6e9b623_20250812_230609_plot1.png)  
![](../plot_archive/6e9b623_20250812_230609_plot2.png)  

## Commit [578ae0e](https://github.com/naszhu/REM_E3_model_fixed/commit/578ae0e) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 23:04:08  
**Message:**
```
finetune(model-e1): resolve performance issue by adjusting c parameter - closes #20, references #13

- Performance was too high for within-list test positions
- Solved by adjusting copying parameter (c) instead of complex parameter tuning
- Most parameters now aligned between E1 and E3
- Major milestone in E1/E3 parameter alignment achieved
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/578ae0e_20250812_230408_plot1.png)  
![](../plot_archive/578ae0e_20250812_230408_plot2.png)  

## Commit [f9211a6](https://github.com/naszhu/REM_E3_model_fixed/commit/f9211a6) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 23:03:39  
**Message:**
```
fix(model-e1): resolve performance issue by adjusting c parameter - closes #20, references #13

- Performance was too high for within-list test positions
- Solved by adjusting copying parameter (c) instead of complex parameter tuning
- Most parameters now aligned between E1 and E3
- Major milestone in E1/E3 parameter alignment achieved
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/f9211a6_20250812_230339_plot1.png)  
![](../plot_archive/f9211a6_20250812_230339_plot2.png)  

## Commit [558ff88](https://github.com/naszhu/REM_E3_model_fixed/commit/558ff88) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 23:03:27  
**Message:**
```
fix(model-e1): resolve performance issue by adjusting c parameter - closes #20, references #13

- Performance was too high for within-list test positions
- Solved by adjusting copying parameter (c) instead of complex parameter tuning
- Most parameters now aligned between E1 and E3
- Major milestone in E1/E3 parameter alignment achieved
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/558ff88_20250812_230327_plot1.png)  
![](../plot_archive/558ff88_20250812_230327_plot2.png)  

## Commit [c8aed92](https://github.com/naszhu/REM_E3_model_fixed/commit/c8aed92) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 22:58:01  
**Message:**
```
fix(E1): resolve performance issue by adjusting c parameter - closes #20, references #13

- Performance was too high for within-list test positions
- Solved by adjusting copying parameter (c) instead of complex parameter tuning
- Most parameters now aligned between E1 and E3
- Major milestone in E1/E3 parameter alignment achieved
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/c8aed92_20250812_225801_plot1.png)  
![](../plot_archive/c8aed92_20250812_225801_plot2.png)  

## Commit [f399c73](https://github.com/naszhu/REM_E3_model_fixed/commit/f399c73) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 22:19:09  
**Message:**
```
feat(model-E3): Integrate E3 model logic into design1 framework

Major update integrating E3 experiment model architecture with design1 data structures:

- Add E3-specific parameters: recall_to_addtrace_threshold, is_strengthen_contextandcontent
- Add context copying parameters: c_context_c, c_context_un for changing/unchanging context
- Add final test chunk parameters: total_probe_L1, total_probe_Ln, nItemPerUnit_final
- Create feature_updates.jl with helper functions: add_features_from_empty! and restore_features!
- Update memory_restorage.jl to use E3 decision criteria and logic flow
- Fix parameter consistency: c_storeintest now properly defined as array
- Maintain design1 data structures while integrating E3 model logic
- Update probe_evaluation.jl to use new function signatures
- Fix bounds errors from inconsistent array/scalar parameter usage

This update enables design1 to run E3 model simulations while preserving existing architecture.

Ref #13
Create tech-debt #18
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/f399c73_20250812_221909_plot1.png)  
![](../plot_archive/f399c73_20250812_221909_plot2.png)  

## Commit [45a23c5](https://github.com/naszhu/REM_E3_model_fixed/commit/45a23c5) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 21:52:22  
**Message:**
```
feat(model-E3): Integrate E3 model logic into design1 framework

Major update integrating E3 experiment model architecture with design1 data structures:

- Add E3-specific parameters: recall_to_addtrace_threshold, is_strengthen_contextandcontent
- Add context copying parameters: c_context_c, c_context_un for changing/unchanging context
- Add final test chunk parameters: total_probe_L1, total_probe_Ln, nItemPerUnit_final
- Create feature_updates.jl with helper functions: add_features_from_empty! and restore_features!
- Update memory_restorage.jl to use E3 decision criteria and logic flow
- Fix parameter consistency: c_storeintest now properly defined as array
- Maintain design1 data structures while integrating E3 model logic
- Update probe_evaluation.jl to use new function signatures
- Fix bounds errors from inconsistent array/scalar parameter usage

This update enables design1 to run E3 model simulations while preserving existing architecture.

Closes #13
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/feature_updates.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/45a23c5_20250812_215222_plot1.png)  
![](../plot_archive/45a23c5_20250812_215222_plot2.png)  

## Commit [83a82ba](https://github.com/naszhu/REM_E3_model_fixed/commit/83a82ba) (branch: `aug-12-explore-more-alignment`)
**Time:** 2025-08-12 20:55:06  
**Message:**
```
merge(model-e1): aug-11-explore: align E1 modeling with E3 structure and enhance simulation parameters

This merge brings in significant improvements to the E1 modeling system:

- Aligns E1 modeling structure with E3 approach for consistency

- Reorganizes constants.jl into logical blocks for better maintainability

- Updates simulation parameters for drift study and reinstatement rates

- Fixes critical bug in ratio_unchanging setting

- Enhances probe evaluation and memory restorage modules

- Updates gitignore and removes temporary files

The changes improve model consistency between experiments and fix

several simulation parameter issues that were affecting model performance.
```
![](../plot_archive/83a82ba_20250812_205506_plot1.png)  
![](../plot_archive/83a82ba_20250812_205506_plot2.png)  

## Commit [c341998](https://github.com/naszhu/REM_E3_model_fixed/commit/c341998) (branch: `main`)
**Time:** 2025-08-12 20:54:38  
**Message:**
```
merge aug-11-explore: align E1 modeling with E3 structure and enhance simulation parameters

This merge brings in significant improvements to the E1 modeling system:

- Aligns E1 modeling structure with E3 approach for consistency

- Reorganizes constants.jl into logical blocks for better maintainability

- Updates simulation parameters for drift study and reinstatement rates

- Fixes critical bug in ratio_unchanging setting

- Enhances probe evaluation and memory restorage modules

- Updates gitignore and removes temporary files

The changes improve model consistency between experiments and fix

several simulation parameter issues that were affecting model performance.
```
![](../plot_archive/c341998_20250812_205438_plot1.png)  
![](../plot_archive/c341998_20250812_205438_plot2.png)  

## Commit [199daf1](https://github.com/naszhu/REM_E3_model_fixed/commit/199daf1) (branch: `aug-11-explore`)
**Time:** 2025-08-12 19:49:13  
**Message:**
```
refactor(model-e1): reorganize constants and enhance simulation parameters

- Reorganized constants.jl into logical sections for better clarity and maintainability.
- Introduced new simulation control flags and adjusted parameters for final tests.
- Updated criterion_final to use power-based calculations for consistency.
- Refined ratio parameters for initial and final tests to improve simulation accuracy.
- Added debug output for probability calculations to aid in analysis.

Aligns with previous work on modeling structure and parameter consistency.
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/199daf1_20250812_194913_plot1.png)  
![](../plot_archive/199daf1_20250812_194913_plot2.png)  

## Commit [24e022d](https://github.com/naszhu/REM_E3_model_fixed/commit/24e022d) (branch: `aug-11-explore`)
**Time:** 2025-08-12 19:26:51  
**Message:**
```
feat(model-e1): align E1 modeling with E3 structure and sampling approach

- Add sampling_method flag for probabilistic vs deterministic image selection
- Implement power-based sampling probabilities (1/11 power) for likelihood ratios
- Update criterion_initial to 2D array supporting [test_position, list_number] indexing
- Modify restore_intest function signature to use sampling probabilities
- Adjust recall_odds_threshold from 100 to 0.3^power_taken to match E3
- Fix function parameters and variable references throughout codebase

Aligns #13

Note: Previous recall_odds_threshold of 100 was extremely high, making it nearly
impossible for items to pass the recall threshold. New value of 0.3^power_taken
(≈0.3^0.091 ≈ 0.97) is much more reasonable and aligns with E3 modeling.
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design1/modeling/module_jl/memory_restorage.jl`  
- `design1/modeling/module_jl/probe_evaluation.jl`  
![](../plot_archive/24e022d_20250812_192651_plot1.png)  
![](../plot_archive/24e022d_20250812_192651_plot2.png)  

## Commit [f6f6937](https://github.com/naszhu/REM_E3_model_fixed/commit/f6f6937) (branch: `aug-11-explore`)
**Time:** 2025-08-12 19:09:46  
**Message:**
```
fix(constants): update u_star_context initialization to use variable for consistency

- Changed u_star_context to initialize with u_star_v instead of a fixed value.
- This adjustment aims to enhance consistency across parameter definitions.

Align work #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/f6f6937_20250812_190946_plot1.png)  
![](../plot_archive/f6f6937_20250812_190946_plot2.png)  

## Commit [ecf592a](https://github.com/naszhu/REM_E3_model_fixed/commit/ecf592a) (branch: `aug-11-explore`)
**Time:** 2025-08-12 19:04:12  
**Message:**
```
fix(constants): update u_star_context initialization to use variable for consistency

- Changed u_star_context to initialize with u_star_v instead of a fixed value.
- This adjustment aims to enhance consistency across parameter definitions.

Align work #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/ecf592a_20250812_190412_plot1.png)  
![](../plot_archive/ecf592a_20250812_190412_plot2.png)  

## Commit [85f5827](https://github.com/naszhu/REM_E3_model_fixed/commit/85f5827) (branch: `aug-11-explore`)
**Time:** 2025-08-12 19:03:00  
**Message:**
```
refactor(model-e3): reorganize constants.jl into logical blocks and move debug output

- Group related parameters into clear sections with descriptive headers
- Move probability calculations and debug println statements to end of file
- Preserve all dependency relationships between constants
- Improve code readability and maintainability
- Remove debug output from parameter definition sections
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/85f5827_20250812_190300_plot1.png)  
![](../plot_archive/85f5827_20250812_190300_plot2.png)  

## Commit [55670c6](https://github.com/naszhu/REM_E3_model_fixed/commit/55670c6) (branch: `aug-11-explore`)
**Time:** 2025-08-12 18:59:14  
**Message:**
```
feat(model-e1): update constants and calculations for u_star

- Worked pretty weell it seems

- Introduced n_units_time constant for step tracking.
- Adjusted u_star initialization to use a consistent value of 0.066.
- Added print statement to display the actual u_star after n_units_time steps.

Align work #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/55670c6_20250812_185914_plot1.png)  
![](../plot_archive/55670c6_20250812_185914_plot2.png)  

## Commit [df4251a](https://github.com/naszhu/REM_E3_model_fixed/commit/df4251a) (branch: `aug-11-explore`)
**Time:** 2025-08-12 18:55:31  
**Message:**
```
feat(model-e1):finetune and align work, update constants for drift study and reinstatement rates

- Supprisingly worked well

- Adjusted n_driftStudyTest from 7 to 11 for better testing conditions.
- Modified p_reinstate_rate from 0.2 to 0.1 to refine reinstatement probability.

Align work:
- Changed g_word from 0.4 to 0.3 to align with new geometric base rate.

Align work #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/df4251a_20250812_185531_plot1.png)  
![](../plot_archive/df4251a_20250812_185531_plot2.png)  

## Commit [f789ce9](https://github.com/naszhu/REM_E3_model_fixed/commit/f789ce9) (branch: `aug-11-explore`)
**Time:** 2025-08-12 18:52:24  
**Message:**
```
fix(model-e1): update constants for drift study and reinstatement rates

- Supprisingly worked well

- Adjusted n_driftStudyTest from 7 to 11 for better testing conditions.
- Modified p_reinstate_rate from 0.2 to 0.1 to refine reinstatement probability.

Align work:
- Changed g_word from 0.4 to 0.3 to align with new geometric base rate.

Align work #13
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
- `design3/modeling`  
![](../plot_archive/f789ce9_20250812_185224_plot1.png)  
![](../plot_archive/f789ce9_20250812_185224_plot2.png)  

## Commit [eaacb71](https://github.com/naszhu/REM_E3_model_fixed/commit/eaacb71) (branch: `aug-11-explore`)
**Time:** 2025-08-12 18:17:54  
**Message:**
```
chore(model-e1): redo, changed nothing
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/eaacb71_20250812_181754_plot1.png)  
![](../plot_archive/eaacb71_20250812_181754_plot2.png)  

## Commit [d595a12](https://github.com/naszhu/REM_E3_model_fixed/commit/d595a12) (branch: `aug-11-explore`)
**Time:** 2025-08-12 18:16:19  
**Message:**
```
chore(model-e1): redo, changed nothing
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/d595a12_20250812_181619_plot1.png)  
![](../plot_archive/d595a12_20250812_181619_plot2.png)  

## Commit [4ddd721](https://github.com/naszhu/REM_E3_model_fixed/commit/4ddd721) (branch: `aug-11-explore`)
**Time:** 2025-08-12 00:53:34  
**Message:**
```
finetune(model-e1): change criterion, worked for between-list a bit but not within

-  the trend is reverse, why? Target not going down but foil is

Deal with residuls of bug on issue #16
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/4ddd721_20250812_005334_plot1.png)  
![](../plot_archive/4ddd721_20250812_005334_plot2.png)  

## Commit [4ddd721](https://github.com/naszhu/REM_E3_model_fixed/commit/4ddd721) (branch: `aug-11-explore`)
**Time:** 2025-08-12 00:53:34  
**Message:**
```
finetune(model-e1): change criterion, worked for between-list a bit but not within

-  the trend is reverse, why? Target not going down but foil is

Deal with residuls of bug on issue #16
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/4ddd721_20250812_005334_plot1.png)  
![](../plot_archive/4ddd721_20250812_005334_plot2.png)  

