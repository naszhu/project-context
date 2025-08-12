# Model Progress

## Commit [85f5827](https://github.com/naszhu/REM_E3_model_fixed/commit/85f5827) (branch: `HEAD`)
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

