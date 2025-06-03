# project-context  <!-- long-term memory / REM dissertation workspace -->

> **Status:** 🏗️ active development on `main` • no tagged releases yet  
> **Parent project:** Lea Lai’s Ph.D. dissertation – *Context Dynamics in Recognition Memory*  
> **Child repos:**  
> • [`REM_E3_model_fixed`](https://github.com/naszhu/REM_E3_model_fixed) – Design-3 modelling code  
> • [`EXP_host`](https://github.com/naszhu/EXP_host) – live jsPsych front-end (Cloudflare Pages)

---

## 📂 Directory map (top level)

| Folder | Purpose / notes |
|--------|-----------------|
| `design1/`, `design2/`, `design3/` | **Current** experiment iterations. Each contains:<br>• `modeling/` Julia simulation code<br>• `ui_experiment/` jsPsych task (legacy HTML bundle)<br>• `data/` raw & cleaned data (Design-specific sub-folders) |
| `data/backup/` | Common cross-design archive of *raw* CSV exports (never tracked in git-lfs yet) |
| `Docs/` | Daily research log, design notes, meeting minutes, model derivations |
| `IRB FOR ALL/` | Approved IRB protocols (redacted); *review before making public* |
| `papers/` | PDFs of directly-relevant literature (for easy citation lookup) |
| `report/` | Draft manuscript fragments & auto-generated figures |
| `TALK/` | Slides / posters |
| `design3-`, `data-design3/`, `Repeated Files/` | **Legacy / debris** – scheduled for removal |

> **Heads-up:** The *only* folders guaranteed to exist across designs are `data/` and `modeling/`.  
> Everything else follows the same nested pattern but may vary by design phase.

---

## 🧩 Child repositories

| Sub-module | What it contains |
|------------|-----------------|
| **`design3/modeling/REM_E3_model_fixed`** | Core Julia code for Experiment 3 context-filter model (active) |
| **`design3/ui_experiment/EXP_host`** | Production jsPsych task served via Cloudflare Pages<br>• ES6 modules split into `main.js`, `functions/`, etc. |

---

## 🔖 Commit style

The log uses a **Conventional Commits**-inspired prefix:

