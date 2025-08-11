# Model Progress

## Commit [49eb579](https://github.com/naszhu/REM_E3_model_fixed/commit/49eb579) (branch: `HEAD`)
**Time:** 2025-08-12 00:49:26  
**Message:**
```
fix(model-e1): BIG BUG fixed on ratio_unchanging setting

The bug was actually fixed in 4 commits ago on cc3d971fcbe254a300f67fc6462dd30073d59935, but only found how far this bug come in this commit

big bug ever since a8700ee008b0964c09c3765aea8caa3be7e1cf4e

See #16
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
![](../plot_archive/49eb579_20250812_004926_plot1.png)  
![](../plot_archive/49eb579_20250812_004926_plot2.png)  

## Commit [d56a795](https://github.com/naszhu/REM_E3_model_fixed/commit/d56a795) (branch: `aug-11-explore`)
**Time:** 2025-08-12 00:34:43  
**Message:**
```
finetune(model-e1): go back to version with changing context
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/d56a795_20250812_003443_plot1.png)  
![](../plot_archive/d56a795_20250812_003443_plot2.png)  

## Commit [d56a795](https://github.com/naszhu/REM_E3_model_fixed/commit/d56a795) (branch: `aug-11-explore`)
**Time:** 2025-08-12 00:34:43  
**Message:**
```
finetune(model-e1): go back to version with changing context
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/d56a795_20250812_003443_plot1.png)  
![](../plot_archive/d56a795_20250812_003443_plot2.png)  

## Commit [b399be2](https://github.com/naszhu/REM_E3_model_fixed/commit/b399be2) (branch: `aug-11-explore`)
**Time:** 2025-08-12 00:10:25  
**Message:**
```
fix(logscr-e3): Empty commit, fix pre or post hooks

found the problem is created by the lack of #... on first line of the hooks, I probably have accidently deleted it somehow
```
**Changed Files:**
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/module_jl/constants.jl`  
![](../plot_archive/b399be2_20250812_001025_plot1.png)  
![](../plot_archive/b399be2_20250812_001025_plot2.png)  

## Commit [f24f7e2](https://github.com/naszhu/REM_E3_model_fixed/commit/f24f7e2) (branch: `aug-11-explore`)
**Time:** 2025-08-11 23:17:53  
**Message:**
```
chore(model-e1): gitgnore update
```
**Changed Files:**
- `.gitignore`  
![](../plot_archive/f24f7e2_20250811_231753_plot1.png)  
![](../plot_archive/f24f7e2_20250811_231753_plot2.png)  

## Commit [106ba44](https://github.com/naszhu/REM_E3_model_fixed/commit/106ba44) (branch: `jul-30-seperate-out-constants`)
**Time:** 2025-07-30 23:04:57  
**Message:**
```
feat(logscr-e1): making logscr for the current repo (currently sit in E1 modeling)
```
**Changed Files:**
- `design1/modeling/log/model_progress.html`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_html_from_json.py`  
- `design1/modeling/script/generate_md_from_json.py`  
- `design1/modeling/script/log_plot.sh`  
- `design1/modeling/script/update_plot_log.py`  
![](../plot_archive/106ba44_20250730_230457_plot1.png)  
![](../plot_archive/106ba44_20250730_230457_plot2.png)  

## Commit [106ba44](https://github.com/naszhu/REM_E3_model_fixed/commit/106ba44) (branch: `jul-30-seperate-out-constants`)
**Time:** 2025-07-30 23:04:57  
**Message:**
```
feat(logscr-e1): making logscr for the current repo (currently sit in E1 modeling)
```
**Changed Files:**
- `design1/modeling/log/model_progress.html`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_html_from_json.py`  
- `design1/modeling/script/generate_md_from_json.py`  
- `design1/modeling/script/log_plot.sh`  
- `design1/modeling/script/update_plot_log.py`  
![](../design1/modeling/plot_archive/106ba44_20250730_230457_plot1.png)  
![](../design1/modeling/plot_archive/106ba44_20250730_230457_plot2.png)  

## Commit [106ba44](https://github.com/naszhu/REM_E3_model_fixed/commit/106ba44) (branch: `jul-30-seperate-out-constants`)
**Time:** 2025-07-30 23:04:57  
**Message:**
```
feat(logscr-e1): making logscr for the current repo (currently sit in E1 modeling)
```
**Changed Files:**
- `design1/modeling/log/model_progress.html`  
- `design1/modeling/log/model_progress.json`  
- `design1/modeling/log/model_progress.md`  
- `design1/modeling/script/generate_html_from_json.py`  
- `design1/modeling/script/generate_md_from_json.py`  
- `design1/modeling/script/log_plot.sh`  
- `design1/modeling/script/update_plot_log.py`  
![](../design1/modeling/plot_archive/106ba44_20250730_230457_plot1.png)  
![](../design1/modeling/plot_archive/106ba44_20250730_230457_plot2.png)  

## Commit [24a75af](https://github.com/naszhu/REM_E3_model_fixed/commit/24a75af) (branch: `jul-30-seperate-out-constants`)
**Time:** 2025-07-30 22:46:01  
**Message:**
```
refactor(model-e1): made constant file
```
**Changed Files:**
- `design1/modeling/JL_V6-6_2finalize.jl`  
- `design1/modeling/constants.jl`  
![](../design1/modeling/plot_archive/24a75af_20250730_224601_plot1.png)  
![](../design1/modeling/plot_archive/24a75af_20250730_224601_plot2.png)  

