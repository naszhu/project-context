# Model Progress

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

