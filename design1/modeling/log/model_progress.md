# Model Progress

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

