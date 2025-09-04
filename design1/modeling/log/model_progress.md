# Model Progress

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

