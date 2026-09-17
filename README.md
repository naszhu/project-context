# Project-Context

This repo holds three experiments — **design1** (E1), **design2** (E2), **design3** (E3) — plus the modeling and analysis that go with them. Each design folder has the same shape:

```
designX/
├── data/            # collected data (raw + processed)
├── data_analysis/   # R / Rmd scripts that produce the results
├── modeling/        # Julia model of the memory task (E1 & E3 only)
└── ui_experiment/   # the actual online task (jsPsych, runs in a browser)
```

If you just want to **run/replicate one experiment**, jump to that design's section below — it tells you which file is the real one to use, out of the many drafts sitting in each folder.

---

## HTML vs "core JS" — read this first

All the online tasks are built with **jsPsych** (JavaScript that runs in a browser tab — not PsychoPy, not a downloaded app).

- **HTML file** (e.g. `mine6.html`, `first4_feedback_v10.html`): a full page. Double-click it or open it in Chrome and it just runs, right off your disk.
- **"Core JS" file** (e.g. `IMPORTANT-FINALUSE-RANDOM.js`, `IMPORTANT-PILOT_RANDOM-v1.5.js`): the exact same experiment logic, but saved as a standalone `.js` file instead of being wrapped in HTML — it's literally the `<script>...</script>` part of the HTML file, copy-pasted out.

**Why bother splitting it out?** Because the platform used to run E1 and E2 online, **Cognition.run**, only accepts your experiment as raw JavaScript (you paste/upload the `.js`, and their site supplies the HTML page and the "Submit" button). So whenever a version was ready to go live, the finished script got copied out of the working HTML file into its own `.js` file with an `IMPORTANT` name, and that `.js` is what actually got deployed.

So: HTML file = for opening locally and testing. Core JS file = for uploading to Cognition.run. Same code either way — the "IMPORTANT" one is the one that collected real data.

---

## design1 (E1) — pictures, forward/backward/random list order

| What | File |
|---|---|
| Model | [`modeling/JL_V6-6_2finalize.jl`](design1/modeling/JL_V6-6_2finalize.jl), shared code in [`modeling/module_jl/`](design1/modeling/module_jl/) |
| Analysis | [`data_analysis/experiment1_comprehensive_analysis.R`](design1/data_analysis/experiment1_comprehensive_analysis.R) (current), [`R_IMPORTANT_USED_DESIGN1_tempesti_v3.rmd`](design1/data_analysis/R_IMPORTANT_USED_DESIGN1_tempesti_v3.rmd) (used with older data) |
| Task — what ran on Cognition.run | [`ui_experiment/js/IMPORTANT-FINALUSE-FOWARD.js`](design1/ui_experiment/js/IMPORTANT-FINALUSE-FOWARD.js), [`-BACKWARD.js`](design1/ui_experiment/js/IMPORTANT-FINALUSE-BACKWARD.js), [`-RANDOM.js`](design1/ui_experiment/js/IMPORTANT-FINALUSE-RANDOM.js) |
| Same thing as an HTML page you can open | [`ui_experiment/mine6.html`](design1/ui_experiment/mine6.html) (this is the forward version — the script inside it is identical to `FOWARD.js`) |

There are three list-order conditions, so there are three separate `.js` files — each one was its own Cognition.run study, with its own Prolific link. They're 99% identical; only the condition flag and the Prolific completion code differ between them. (Yes, "FOWARD" is a typo, not a different thing.)

Everything else in `ui_experiment/` (`mine.html`, `mine2.html` ... `mine5.html`, `discard*.html`) is older drafts from getting to that final version — useful for history, not for replication.

---

## design2 (E2) — word pairs, feedback, final typing test

| What | File |
|---|---|
| Model | none — E2 was never modeled here |
| Analysis | [`data_analysis/R_design2.2_analyze_v10.rmd`](design2/data_analysis/R_design2.2_analyze_v10.rmd) |
| Task | [`ui_experiment/first4_feedback_v10.html`](design2/ui_experiment/first4_feedback_v10.html), also mirrored as [`IMPORTANT_V10_NEW.js`](design2/ui_experiment/IMPORTANT_V10_NEW.js) |

Also ran on Cognition.run, same pattern as E1. `v10` is the version actually used for the main data collection; see [`IMPORTANT_README_DESIGN.txt`](design2/ui_experiment/IMPORTANT_README_DESIGN.txt) for what changed from earlier v1–v6 pilots.

---

## design3 (E3) — multi-list pictures, confusing foils

E3's task code has **two eras**, because the hosting setup changed partway through. This is the part most likely to confuse someone new to the repo, so it gets more detail.

### Era 1 — Cognition.run (what's inside `design3/ui_experiment/`)

Same setup as E1/E2: [`ui_experiment/IMPORTANT-PILOT_RANDOM-v1.5.js`](design3/ui_experiment/IMPORTANT-PILOT_RANDOM-v1.5.js) is the core JS that was uploaded to Cognition.run, and e.g. [`test_v5_Modify from 1.4.html`](design3/ui_experiment/test_v5_Modify%20from%201.4.html) is the same logic as an openable HTML page. Images were pulled live from a GitHub raw URL.

**This folder is frozen** — it stopped being touched after an early-2025 file reorganization and doesn't reflect the current live version. It still points at the old GitHub image URLs.

### Era 2 — Cloudflare Pages (a separate repo: [`EXP_host`](https://github.com/naszhu/EXP_host))

The task got rebuilt and moved to its own repo, deployed as a static site on **Cloudflare Pages**, with `main.js` / `const_exp.js` / `const_general.js` / `load.js` under `EXP_host/js/`. This is the version that's actually live and collecting data now — **not** anything inside `design3/ui_experiment/`.

**Why move at all?**

1. **GitHub raw URLs can't take real traffic.** The old setup fetched every study image from `raw.githubusercontent.com` at run time. Fine for a handful of pilot subjects, but once real Prolific traffic hit, GitHub started rate-limiting those requests — images would fail to load and participants could no longer open the experiment. Moving to Cloudflare Pages means the images are served from the same place as the experiment, so there's no rate limit to hit.
2. **Cognition.run had real limits on saving data.** It's fine for running the task, but options for exporting / storing trial-by-trial data were limited for what E3 needed. `EXP_host` instead saves data itself: each trial gets pushed through a small Render-hosted backend into a Firebase/Firestore database, and `export_firestore.py` (in that repo) pulls it back out to CSV for analysis.

So in short: **`design3/ui_experiment/` = old Cognition.run version, frozen. `EXP_host` = current version, deployed on Cloudflare Pages, saves to Firebase.** If you want to actually run or modify the live E3 task, go to the `EXP_host` repo, not `design3/ui_experiment/`.

| What | File |
|---|---|
| Model | [`modeling/E3/main_JL_E3_V0.jl`](design3/modeling/E3/main_JL_E3_V0.jl) — this is a git submodule → [REM_E3_model_fixed](https://github.com/naszhu/REM_E3_model_fixed) |
| Analysis | [`data_analysis/E3_analysis_comprehensive.R`](design3/data_analysis/E3_analysis_comprehensive.R) |
| Data column reference | [`README_DATA_STRUCTURE.md`](design3/README_DATA_STRUCTURE.md) — read this before touching E3 data, the column names are not self-explanatory |
| Task (current, live) | [`EXP_host`](https://github.com/naszhu/EXP_host) repo — `js/main.js` + `js/const_*.js`, deployed on Cloudflare Pages |
| Task (old, frozen) | `design3/ui_experiment/IMPORTANT-PILOT_RANDOM-v1.5.js` — Cognition.run version, kept for history |

---

## Version numbers vs git tags

Every experiment run writes a `codeversion` value into its data (E1 = `3`, E2 = `10`, E3 old = `1.5`, E3 current/`EXP_host` = `2.3` and counting). That's the number to match against when you're checking which analysis script goes with which dataset.

Git **tags**, separately, mark tested snapshots of the **model** code (not the jsPsych task):
- E1 model tags live in this repo — see [project-context tags](https://github.com/naszhu/project-context/tags), e.g. `version-3.5-testing-listfix`.
- E3 model tags live in the submodule — see [REM_E3_model_fixed tags](https://github.com/naszhu/REM_E3_model_fixed/tags), e.g. `v6.1-rich-base`, `v2.0`.

To check out a tagged model:
```bash
cd design3/modeling && git fetch --tags && git checkout v6.1-rich-base
```

---

## Getting the submodule

`design3/modeling/` doesn't come with the code by default — it's a link to another repo:
```bash
git submodule update --init --recursive
```

---

## Issues & commit style

Issues: [project-context](https://github.com/naszhu/project-context/issues) (general/E1), [REM_E3_model_fixed](https://github.com/naszhu/REM_E3_model_fixed/issues) (E3 model), [EXP_host](https://github.com/naszhu/EXP_host/issues) (E3 task/hosting).

Commit messages follow `type(scope): message`, e.g. `fix(model-e3): ...`, `feat(analysis-e1): ...`.
