# Refined PhD Dissertation Outline

---

**Front Matter**

* Title Page (1 page)
* Abstract (2 pages)
* Acknowledgments (1 page)
* Table of Contents (2 pages)
* List of Figures (1 page)
* List of Tables (1 page)
* List of Abbreviations and Symbols (1 page)

**Total Front Matter:** 9 pages

---

# Chapter 1 – Introduction (Approximately 10 pages)

\## 1.1 Background and Motivation (3.5 pages)

* Historical context: evolution from early theories of memory (e.g., Atkinson & Shiffrin, 1968) to modern computational models (1 page)
* Significance of context in human memory; conceptualizing “context” beyond mere setting (0.75 pages)
* Gaps in existing literature: limitations of REM and TCM when presented with complex foil mixtures and dynamic testing paradigms (AllAssumptionsSoFar §1–2) (1.75 pages)

\## 1.2 Definitions and Core Concepts (2.5 pages)

* Content vs. Context (ASIC 2024 PPT §2–3) (0.75 pages)

  * Content: item‐specific features (perceptual, semantic) distinguishing studied items
  * Context: background features (environmental, internal, temporal) co‐occurring during encoding and retrieval
* Episodic memory (Tulving, 1972) and “context retrieval” in recognition/recall tasks (0.5 pages)
* Formal notation for memory representations:

  * Probability space (Ω, ℱ, P) in cognitive models (e.g., GCM, REM) (0.5 pages)
  * Feature spaces: embedding physical vs. abstract features; similarity functions (Shiffrin & Steyvers, 1997; Cox & Shiffrin, 2017) (0.75 pages)

\## 1.3 Research Questions and Objectives (2.0 pages)

* Overarching goal: develop a mathematically rigorous, unified account of context in storage and retrieval, validated by computational modeling and empirical data (0.5 pages)
* Sub‐questions:

  1. Extending existing models (REM, TCM) to handle highly confusable foils and dynamic context shifts (AllAssumptionsSoFar §2–3) (0.5 pages)
  2. Formal definitions and mechanisms capturing “context change” (CC) vs. “unchanging context” (UC) (0.25 pages)
  3. Creating a single model (with consistent parameter values) predicting both short‐term recognition (published work) and longer‐term context‐dependent recognition performance (context project) (0.75 pages)

\## 1.4 Dissertation Structure and Roadmap (2.0 pages)

* Chapter 2: Literature review of recognition and recall models (REM, TCM, SDT, DDM) (0.5 pages)
* Chapter 3: Formalization of modeling framework: notation, components, computational implementation, including explicit context feature definitions, drift, filtering mechanisms (0.5 pages)
* Chapter 4: Published Short‐Term Recognition Study (SLR23 model; Lai, Cao, & Shiffrin, 2024) – concise overview (0.5 pages)
* Chapter 5: Extended Recognition Experiments (Experiments 1 & 2): empirical design, results, extended‐REM modeling with CC/UC, drift, and context–content interactions (1.0 pages)
* Chapter 6: General Discussion: integration of findings, theoretical implications, future directions (0.25 pages)
* Chapter 7: Conclusions: summary of contributions, practical implications (0.25 pages)
* Appendices: mathematical derivations, parameter tables, stimuli, IRB documents (0.25 pages)

---

# Chapter 2 – Literature Review (Approximately 25 pages)

\## 2.1 Foundations of Recognition and Recall Models (7 pages)

* Atkinson–Shiffrin (1968) two‐store model; limitations for dynamic retrieval (2 pages)
* Signal‐Detection Theory (SDT) in recognition (Green & Swets, 1966; Macmillan & Creelman, 2005):

  * Equal‐variance vs. unequal‐variance assumptions; ROC analysis; d′; criterion shifts (3 pages)
* Evidence Accumulation Models:

  * Random‐walk, diffusion, LCA frameworks (Ratcliff, 1978; Vickers, 1979; Usher & McClelland, 2001) (2 pages)
  * Relation between DDM drift rates and familiarity signals (Ratcliff & McKoon, 2008); LCA as multiple accumulators (0.5 pages)
  * Brief criticism: drift vs. discrete signals in rapid STM tasks (0.5 pages)

\## 2.2 REM (Retrieving Effectively from Memory) and Extensions (6 pages)

* Original REM (Shiffrin & Steyvers, 1997):

  * Representation of items as high‐dimensional feature vectors; noisy copying; similarity function (2 pages)
  * Likelihood of retrieval based on feature match/mismatch probabilities (1 page)
* Limitations of standard REM with heterogeneous foils and dynamic testing (AllAssumptionsSoFar §1) (1 page)
* Variants and extensions:

  * REM‐C (contextual REM; Raaijmakers & Shiffrin, 1981): adding simple context drift (1 page)
  * SLR21 (Nosofsky et al., 2021): exemplar‐based random‐walk (EBRW) with STM & LTM; flexibility issues (1 page)
* Necessity of extended REM: mixture of foil types in Exp 2 and beyond requires explicit CC/UC features, filtering, drift (1 page)

\## 2.3 Temporal Context and the Temporal Context Model (TCM) (4 pages)

* Cognitive motivation: recall/recognition tasks reveal recency, list length, and inter‐list interference effects (1 page)
* Howard & Kahana (2002) TCM overview:

  * Temporal context as drifting high‐dimensional vector c\_t updated at each event; c\_t = ρ c\_{t–1} + γ e\_t (1.5 pages)
  * Context–item associations via matrix M; retrieval via similarity between c\_probe and stored contexts (1 page)
* Neural basis: hippocampal temporal drift coding, “time cells” (Howard & Eichenbaum, 2013; Umbach et al., 2022) (0.5 pages)
* Limitations: inability to handle mixed‐confusability foils (AllAssumptionsSoFar §3) (0.5 pages)

\## 2.4 Context in Computational Models (CC vs. UC) (4 pages)

* Definition of Context Change (CC) features: elements varying systematically across lists (e.g., temporal features, incidental cues, CC internal state updates) (1 page)
* Unchanging Context (UC) features: features constant across lists (e.g., room, modality, global task instructions) (0.5 pages)
* Mechanisms of CC drift: discrete vs. continuous feature change; role of reinstate probability; neural correlations (1 page)
* Empirical manipulations of CC vs. UC: retrieval benefits when explicit CC cues are provided (Bauml & Trissl, 2022) and implications for Exp 1/2 (1.5 pages)

\## 2.5 Gaps, Open Questions, and Rationale for Present Work (4 pages)

* Why standard recognition models cannot fully account for context-driven performance fluctuations when foils vary within‐session (AllAssumptionsSoFar §2) (1 page)
* Need for unified model integrating:

  * STM familiarity
  * LTM event‐trace retrieval
  * CC/UC partitioning with explicit drift, filtering (1 page)
* Creating an extended REM framework: incorporating context filtering, drift, trace strengthening, and restorage during test phases (1 page)
* Rationale for focusing on REM: existing parameter parsimony, interpretability, scalability; why SLR23 is starting point (1 page)

---

# Chapter 3 – Modeling Framework: Mathematical Formalization (Approximately 25 pages)

**Part A – REM‐Based Evidence & Context Engine**

\## 3.1 Formal Preliminaries and Notation (4 pages)

* Probability space for psychological feature representations:

  * Ω = set of feature combinations; ℱ = σ‑algebra; P: ℱ → \[0,1] (1 page)
* Item representations:

  * Item i represented as vector e\_i ∈ ℝ^d (physical, semantic, content features) (0.5 pages)
  * Context representation c\_t = \[cc\_t, uc\_t]; cc\_t ∈ {0,1}^{F\_cc}, uc\_t ∈ {0,1}^{F\_uc} (0.5 pages)
  * F\_cc (e.g., 25 CC features); F\_uc (e.g., 25 UC features) per current model description (0.5 pages)
* Drift and reinstatement:

  * Context‐change transition: P(cc\_t+1\[f] = 1 | cc\_t\[f]=1) = 1 – δ\_list (typical δ\_list=0.14) (0.5 pages)
  * Drift between study and test within list: P(cc\_after\_test\[f] reinstated = cc\_study\[f]) = δ\_reinstate (e.g., 0.4) (0.5 pages)
  * UC features: uc\_t+1 = uc\_t (constant) (0.5 pages)
* Trace representations:

  * Short‐term trace: T^{STM}\_{i,k,h} = (e\_i^C , cc\_k , uc ), quality m\_h = h^{–ϕ} + κ (1 page)
  * Long‐term event trace: stored similarly with cc\_noise for test‐drift; scaling by δ-based copying parameter (0.5 pages)
  * Knowledge trace in CM (excluded in Exp 1/2): e\_i^C → response mapping (0.5 pages)

\## 3.2 Similarity Functions and Activation Computation (5 pages)

* Two‐stage retrieval assumption:

  * Stage 1: low‐level perceptual features only; activate STM traces only; similarity s\_1(e\_probe, e\_trace) = σ^1\_{match} (if C match) / σ^1\_{mismatch} otherwise (1 page)
  * Stage 2: content + high‐level features; activate STM & LTM event traces; s\_2(e\_probe, e\_trace) = σ^2\_{match} (if C) / σ^2\_{mismatch}(context same/different, foil type) (1 page)
* Parameterization of σ^1 and σ^2 values:

  * σ^1\_{match}, σ^1\_{mismatch} fixed across conditions; σ^2\_{match} fixed; σ^2\_{mismatch} allowed to differ by pair type (AN–AN, repeated‐foil vs. novel‐foil, cc‐mismatch severity) (1 page)
* Activation of a Single Trace j for Probe i (Familiarity):

  * STM activation: a^{STM}*{ij} = m*{h\_j} · s\_1 (Stage 1) or s\_2 (Stage 2 when available) (1 page)
  * LTM activation: a^{LTM}\_{ij} = θ · I\[context\_passes\_filter(cc\_probe, cc\_trace)] (θ ≥ 0; probability to activate passed traces) (1 page)

\## 3.3 Context Filtering Mechanism (3 pages)

* Filter F(cc\_probe, cc\_trace): compute Hamming distance or overlap of CC features; if distance > τ\_filter, set activation = 0 (1 page)
* Threshold τ\_filter controls strictness of CC match; typical value \~0.3 normalized distance (1 page)
* Justification: suppress activation of traces from prior lists when CC divergence is high; formal relation to TCM gating and neural coding (1 page)

\## 3.4 Trace Update During Testing (4 pages)

* Restorage policy:

  * On “OLD” (correct target) response: retrieve best‐matching event trace; strengthen content features (restore mismatched bits probabilistically by copying parameter C\_target=1 for Exp 1; C\_target≈1 for Exp 2 initial test) (1 page)
  * On “NEW” (foil) response: create new trace T\_new = (e\_probe^C , cc\_probe\_after, uc ) with copying parameter C\_foil (e.g., 0.04) (1 page)
* Quality update:

  * Short‐term trace strength decays by m\_h = h^{−ϕ} + κ; new test‐created trace assigned quality = baseline (e.g., 1) but then decays from subsequent lags (0.5 pages)
  * LTM event trace copy fidelity for each feature = C (e.g., 0.8 for content, 0.3 for context, as in current model description) (0.5 pages)
* Interaction with context drift:

  * After each test, cc\_probe\_after = drift(cc\_current, δ\_drift=0.14) (0.5 pages)
  * Reinstate to study context with probability δ\_reinstate=0.4 (apply to CC features of stored trace) (0.5 pages)

**Part B – EBRW Decision Process**

\## 3.5 Evidence‑Accumulation (EBRW) Implementation (4 pages)

* Decision variable process:

  * Step probability p\_{TS}(i) = \[∑*{j∈match} (a^{STM}*{ij} + a^{LTM}*{ij}) + δ*{CM}(i)] / \[∑*{j} (a^{STM}*{ij} + 2a^{LTM}*{ij}) + δ*{CM}(i) + ξ ] (1 page)
  * For Exp 1/2 (no CM learning), set δ\_{CM}(i) = 0; AN: no LTM matches; repeated foils (Exp 2) have LTM if filter passes (1 page)
* Step boundaries: Θ\_{OLD} and Θ\_{NEW} fixed (e.g., 3.6, –1.5); evidence initiates at 0 and steps ±1 (0.5 pages)
* Response time:

  * N\_S = # steps to boundary; each step time τ\_step ≈ 91 ms; RT\_RW = N\_S · τ\_step + τ\_0 (τ\_0 varies by group) (1 page)
* Glitches:

  * P(glitch) = ζ ≈ 0.04; if glitch, RT\_glitch \~ Exp(1/μ\_g), μ\_g ≈ 1399 ms; response random with p=0.5 (0.5 pages)

\## 3.6 Parameter Estimation and Optimization (3 pages)

* Global vs. condition‐specific:

  * Global: ξ, Θ\_{OLD}, Θ\_{NEW}, τ\_step, ζ, μ\_g, θ, ϕ, κ, σ^1\_{match}, σ^1\_{mismatch}, σ^2\_{match}, C (copy‐fidelity content), C\_ctx (copy‐fidelity context), δ\_drift, δ\_reinstate (1 page)
  * Condition-specific: τ\_0 per group; σ^2\_{mismatch} values per pair type; τ\_filter; C\_foil; LTM weight θ repeated‐foil vs. novel‐foil; Δq (strengthening increment) for Exp 2 vs. Exp 1; P(cc\_match) values per condition (1 page)
* Objective function:

  * Weighted SSE: accuracy (weight 2) vs. RT (in seconds) difference; foils weighted higher (×4) than targets/Lag points due to data volume imbalance (0.5 pages)
  * Optimization using Julia + IPOPT (JuMP) with constraints to ensure parameter bounds (e.g., 0≤C≤1, 0≤δ≤1) (0.5 pages)

\## 3.7 Model Validation and Diagnostics (2 pages)

* Goodness‐of‐fit: predicted vs. observed accuracy & median RT curves (Figs. Exp 1 & 2) (1 page)
* Sensitivity analysis: parameter trade‐offs (e.g., τ\_filter vs. θ), local minimum exploration, cross‐validation by holding out one list or one group (1 page)

---

# Chapter 4 – Short‑Term Recognition: Published Work (SLR23 Model) (Approximately 15 pages)

> **Note:** Condensed to give more emphasis to Chapter 5.

\## 4.1 Overview and Rationale (1.5 pages)

* Research goal: unified account of short‑term recognition (accuracy & RT) across VM, CM, AN, mixed conditions; set sizes 2–9; target lags (0.75 pages)
* Key novelty: STM + LTM + knowledge trace integration; two‑stage retrieval; single‐model fits 13 groups & 376 conditions (Lai, Cao, & Shiffrin, 2024) (0.75 pages)

\## 4.2 Experimental Paradigm and Conditions (2 pages)

* Probe‐recognition task with picture stimuli; set sizes; study & test phases; side mapping; feedback (1 page)
* Conditions (AN, VM, CM pure; mixed variants); data collected (accuracy & median correct RT); side‐mapping nuance (1 page)

\## 4.3 SLR23 Model Implementation (Summary from Ch. 3) (3 pages)

* Two‐stage retrieval, activation summation, step probability formula (1 page)
* Parameterization (Table 2) and estimated values (1 page)
* Main fit outcomes (briefly): set‐size, CM > AN > VM ordering, target‐lag recency (1 page)

\## 4.4 Results: Model vs. Data (Highlights) (5 pages)

* Set‐Size Effects; CM/AN/VM ordering; target lag; quantitative fit assessment (selected figures) (3 pages)
* Discussion of theoretical implications; limitations; positioning as foundation for Chapters 5 & 6 (2 pages)

---

# Chapter 5 – Extended Recognition Experiments (Experiments 1 & 2) (Approximately 40 pages)

> **Emphasized as main dissertation contribution.**

\## 5.1 Research Objectives and Hypotheses (4 pages)

* Objective A: quantify how CC drift across ten study–test lists modulates recognition accuracy & RT for targets & foils, leveraging explicit CC/UC features (1 page)
* Objective B: assess within‐list effects (primacy, recency, output interference) and between‐list effects (inter‐list interference) when foils are either novel (Exp 1) or repeated (misleading, Exp 2) (1 page)
* Objective C: test final‐test context manipulations (random, forward, backward) and determine reliance on CC vs. UC cues (1 page)
* Hypotheses (expanded):

  1. Within‐list: H\_c early > CR early; as testing continues H\_c declines due to output interference + strengthening; sharper in Exp 2 due to misleading repeated foils (1st half of list stream) (0.5 pages)
  2. Between‐list: Exp 1 mild decline H\_k; Exp 2 steeper decline due to misleading foils + CC drift; CR\_k stable in Exp 1, dip in Exp 2 (0.5 pages)
  3. Final‐test: random yields combined recency+OI; forward/backward isolate recency and OI; CC cues boost retrieval of list‐specific items (0.5 pages)
  4. Extended REM with drift, filtering, trace strengthening, restorage predicts Exp 1 & 2 data with consistent parameters except Δq and θ differences (0.5 pages)

\## 5.2 Experimental Design and Procedure (8 pages)

* Participants: n ≈ XXX undergraduates; sampling, compensation, IRB; final groups: Random, Forward, Backward; demographic details (1 page)
* Stimuli: 210 unique picture set; foil conditions: Exp 1 novel; Exp 2 repeated (80%) vs. novel (20%); final‐test probe composition; counterbalancing logic (1 page)
* Apparatus & software: MATLAB Psychophysics Toolbox; display size & positions; response keys; side‐mapping specifics (1 page)

\### 5.2.1 Within‐Session Procedure (Exp 1 & Exp 2 initial 10 lists) (3 pages)

* 10 blocks (Lists 1–10):

  * Study phase (20 pictures @1 s, ISI = 0.1 s; 500 ms fixation) (0.5 pages)
  * Context drift within list: apply δ\_drift=0.14 after each trial; reinstatement at block‐level δ\_reinstate=0.4 (description; 0.5 pages)
  * Distractor: 10 s arithmetic task (0.25 pages)
  * Test phase: 20 trials: 10 targets (current list) + 10 foils

    * Exp 1: foils always novel
    * Exp 2: 80% repeated from previous trial (context‐similar but confusion risk), 20% novel (1 page)
    * Probe: until response (Old = “F” key; New = “J” key); feedback (1 s); ITI = 0.5 s; CC filter not engaged until after Stage 1 activation (0.25 pages)
  * Side mapping: half trials left vs. right; participants not informed of foil type probabilities (0.5 pages)

\### 5.2.2 Final Testing (Exp 1 vs. Exp 2) (2 pages)

* 2 min break; instructions: identify previously seen (OLD) vs. new (NEW); emphasize context cues differently per group (0.5 pages)
* Final‐test probe list: 210 targets (7 from each of 10 lists per category: studied‐only, tested‐only, studied+tested) + 210 entirely new foils; CC similarity across lists \~10% vs. UC (0.5 pages)
* Group procedures:

  * Random: random order of final targets+foils; no context label (0.25 pages)
  * Forward: blocks by list 1→10; label list number; participants told current list’s CC cue (0.25 pages)
  * Backward: blocks by list 10→1; label list number (0.25 pages)
* Final‐test context dynamics: cc\_probe starts as last list’s cc; drifting by δ\_final\_f = 0.02 per test; apply UC weight 0.9, CC weight 0.1 for filter and activation calculations (0.5 pages)

\## 5.3 Data Analysis: Within‐List Metrics (5 pages)
\### 5.3.1 Accuracy (2 pages)

* Hit rate H\_{k,h}: proportion correct by list k, position h; compute primacy (h small) & recency (h large) curves; plot by list & foil type (Exp 1 vs. 2) (1 page)
* Correct rejection rate CR\_{k,t}: proportion correct by test trial t; measure output interference (compare early vs. late test positions across lists) (1 page)

\### 5.3.2 Response Time (3 pages)

* Median correct RT for hits H\_{k,h} and CR\_{k,t}
* Outlier trimming: exclude RT < 180 ms or > 1300 ms for Exp 2 (\~15% data); similar thresholds for Exp 1 (\~10%) (0.5 pages)
* Preliminary within‐list findings:

  * Exp 1: primacy, recency, stable CR vs. h (0.5 pages)
  * Exp 2: recency similar, but CR\_{k,t} slower for repeated foils early; drift & filter contribute (1 page)
* Statistical tests:

  * Mixed‐effects logistic models for accuracy by k, h, foil type (0.5 pages)
  * Mixed‐effects linear models for log(RT) by k, h, foil type (0.5 pages)

\## 5.4 Data Analysis: Between‑List Metrics (5 pages)
\### 5.4.1 Hit Rate Across Lists (H\_k) (1 page)

* Exp 1: mild decline H\_k from k=1→10 (\~7% drop); model as function of CC drift only
* Exp 2: steeper decline H\_k due to 80% repeated foils – quantify confusion effect (compare slopes) 
* Regression of H\_k \~ k × Experiment (Exp1 vs. Exp2); report βs, CI

\### 5.4.2 CR Rate Across Lists (CR\_k) (1 page)

* Exp 1: stable CR\_k (\~>90%)
* Exp 2: dip in CR\_k at k=2 due to repeated foils, then gradual recovery as filter learns to ignore prior traces 
* Regression of CR\_k \~ k × Exp; statistical test

\### 5.4.3 Slopes and Statistical Tests (1 page)

* Compare slopes of H\_k vs. k across experiments (t‐test on slope parameters)
* ANOVA: List × Experiment on H\_k and CR\_k; interaction reveals confusability effect

\### 5.4.4 Within‑List vs. Between‑List Interaction (2 pages)

* Multilevel logistic regression: P(Old|target, k, h, list\_type) & P(New|foil, k, t, foil\_type)
* Key predictors: h (position), k (list), foil\_type (Exp 1 novel vs. Exp 2 repeated), context drift index (proportional to k)
* Interaction terms: foil\_type × k, foil\_type × h; interpret CC usage evidence
* Interim summary: Exp 2 shows CC drift + filter learning improves CR over lists, whereas Exp 1 driven by CC drift only 

\## 5.5 Extended REM Modeling of Experiments 1 & 2 (Approx. 15 pages)

\### 5.5.1 Model Extensions Beyond SLR23 (Ch. 3) (3 pages)

* Explicit CC/UC partitioning in context vector c = \[cc, uc]; dimensions as per current model description (25 CC, 25 UC)
* Context drift:

  * Between lists: cc\_{k+1} = ρ × cc\_k + ε\_k, where ε\_k ∼ Bernoulli(δ\_list) for each CC feature (δ\_list=0.14)
  * Within‐list (study→test): cc\_after\_test = drift(cc\_current, δ\_drift=0.14); then reinstate to study context with prob δ\_reinstate=0.4
  * Final test drift: cc\_final\_i+1 = drift(cc\_final\_i, δ\_final\_f=0.02)
* Context filtering: F(cc\_probe, cc\_trace) = 1 if HammingDistance(cc\_probe, cc\_trace) ≤ τ\_filter (τ\_filter ≈ 0.3), else 0
* Trace strengthening & restorage during test:

  * On OLD: retrieve best‐matching event trace; strengthen content features: for each content feature f, if probe\[f] = 1 and trace\[f] = 0, restore with prob C\_target (Exp 1 C\_target=1; Exp 2 initial C\_target=1); weaken CC features based on cc\_noise σ^2\_ctx
  * On NEW: create new trace with content = probe content; CC = cc\_after\_test; store with prob C\_foil (Exp 1 C\_foil=0.04; Exp 2 initial test C\_foil=0.04)
* UV (unchanging context) weighting:

  * During extended recognition, LTM activation weight limited by UC match (uc always matches); CC match decided by filter
  * Final test: UC weight = 0.9; CC weight = 0.1 in similarity computations to capture final test reliance on UC

\### 5.5.2 Model Equations for Exp 1 & Exp 2 (3 pages)

* At study (list k, position h): store T^{STM}\_{i,k,h} = (e\_i^C, cc\_k, uc); quality m\_h = h^{−ϕ} + κ
* At test (Exp 1/Exp 2 initial 10 lists):

  * Probe context = cc\_k\_current; cc\_k\_current obtained via drift after last trial or initial list cc\_1
  * Stage 1 activation (STM): a^{STM1}*{ij} = m*{h\_j} · σ^1 (match/mismatch content)
  * If not reached boundary, Stage 2 activation (STM + LTM):

    * a^{STM2}*{ij} = m*{h\_j} · σ^2 (match/mismatch content + UC match always true)
    * a^{LTM}\_{ij} = θ × F(cc\_probe, cc\_trace\_j) × I\[trace stored ≤ current k–1]
  * p\_{TS}(i) = \[∑ a^{STM2}*{ij} + ∑ a^{LTM}*{ij}] / \[∑ a^{STM2}*{ij} + 2∑ a^{LTM}*{ij} + ξ]
  * No δ\_{CM} term (no CM learning)
* On response:

  * If response = OLD:

    * Retrieve best trace j\*, strengthen content features by updating trace\_j\*^C\[f] = 1 if probe^C\[f]=1; update cc\_trace\_j\* by drift/instate; store new event trace if necessary
  * If response = NEW:

    * Create new trace T\_new = (e\_probe^C, cc\_after\_test, uc) with quality m\_0 = 1; store with prob C\_foil
* Between lists: cc\_{k+1} = drift(cc\_k, δ\_list)

\### 5.5.3 Parameter Estimation (2 pages)

* Global fixed parameters:

  * ϕ ≈ 1.7; κ ≈ 0.21; θ ≈ 0.52; ξ ≈ 0.54; Θ\_{OLD}=3.6; Θ\_{NEW}=–1.5; τ\_step=91 ms; ζ=0.04; μ\_g=1399 ms; C\_content=0.8; C\_ctx=0.3; δ\_list=0.14; δ\_drift=0.14; δ\_reinstate=0.4; δ\_final\_f=0.02
* Condition-specific (Exp 1 vs. Exp 2 initial vs. final):

  * τ\_0 per group (Exp 1 groups: MIX4, CM, VM; Exp 2 groups: MIX4, MIX8, CM, VM, AN)
  * σ^2\_{mismatch} values for AN–AN, repeated‐foil–trace, novel‐foil–trace, cc‐mismatch levels
  * τ\_filter ≈ 0.3; Δq (content strengthening increment) ≈ 0.05 for Exp 2 after several lists; ≈ 0 for Exp 1
  * C\_foil (Exp 1 = 0.04; Exp 2 initial = 0.04; Exp 2 final = 0.04)
  * UC weight final = 0.9; CC weight final = 0.1
* Fitting procedure: weighted SSE (accuracy ×2 vs. RT ×1; foil points ×4 vs. target points) via Julia+JuMP

\### 5.5.4 Model Predictions vs. Observed Data (7 pages)

* Within‐List predictions:

  * Exp 1: H\_{k,h} recency, CR\_{k,t} stable; match observed curves (Fig. 5.1) (1 page)
  * Exp 2: H\_{k,h} recency; CR\_{k,t} initially low & slow, improves across lists as filter learns; model captures both (Fig. 5.2) (1 page)
  * RT predictions: Exp 1 minimal CC effect; Exp 2 slower CR for repeated foils early, speedup later; model matches median RT (Fig. 5.3) (1 page)
* Between‐List predictions:

  * Exp 1: H\_k mild decline; CR\_k stable; model drift‐only matches slopes (Fig. 5.4) (1 page)
  * Exp 2: H\_k steep decline; CR\_k dip & recovery; filter + drift replicate pattern (Fig. 5.5) (1 page)
* Final‐Test predictions:

  * Random: combined recency+OI; model using UC weight 0.9, CC weight 0.1, δ\_final\_f=0.02 matches d′ vs. list position (Fig. 5.6) (1 page)
  * Forward: model uses CC cues from labeled list; predicts higher d′ for early lists, diminishing recency effect (Fig. 5.7) (1 page)
  * Backward: reverse order; model predicts pronounced recency first, OI later; matches data (Fig. 5.8) (1 page)
* Residual analyses: RMSE for accuracy \~3%; for RT \~50 ms; discuss minor misfits (1 page)

\### 5.5.5 Parameter Interpretations and Theoretical Insights (3 pages)

* Estimated ρ ≈ 0.8 (moderate CC drift per list); δ\_list, δ\_drift confirm neural time‐code magnitude (0.5 pages)
* τ\_filter ≈ 0.3: initial strict filtering reduces repeated foil confusion; relaxes as CC similarity reduces confusability (0.5 pages)
* Δq ≈ 0.05 (Exp 2): trace strengthening accounts for output interference; absent in Exp 1 (0.5 pages)
* LTM weight θ: balanced to allow moderate activation of matching event traces; higher for repeated foils in Exp 2 (0.5 pages)
* UC vs. CC weighting in final test: UC=0.9, CC=0.1 indicates reliance on stable context in long‐term retrieval; theoretical implications for context reinstatement (0.5 pages)
* Summary: extended REM captures Exp 1 & Exp 2 patterns with minimal parameter changes; demonstrates sufficiency of CC/UC framework (0.5 pages)

---

# Chapter 6 – General Discussion and Integration (Approximately 15 pages)

\## 6.1 Synthesis of Empirical and Modeling Findings (4 pages)

* Short‑Term Recognition (Ch. 4 recap): SLR23’s parsimonious account; necessary but not sufficient for Exp 1/2 (0.5 pages)
* Extended Recognition (Ch. 5 recap): CC drift + filtering, trace strengthening, restorage effects critical for Exp 1 vs. Exp 2 differences (1 page)
* Parameter consistency: core parameters (ϕ, κ, θ, ξ, ρ, δ\_list, δ\_drift, δ\_reinstate) unchanged across Exp 1 & 2; condition‐specific Δq, τ\_filter account for foil confusability (1 page)
* Cross‐study insights: role of repeated foils (misleading) in driving filter learning; CC vs. UC weighting differences by task phase (initial vs. final) (1.5 pages)

\## 6.2 Theoretical Implications for Contextual Memory (4 pages)

* Unification of REM and TCM:

  * REM’s familiarity mechanisms integrate with TCM‐style context drift; CC filter as gating function (1 page)
  * Temporal coding in hippocampus (“time cells”) supports CC feature concept; δ\_list \~ observed neural drift rates (1 page)
* Formalization of context:

  * c\_t^{CC} = ρ^t c\_0 + ∑\_{i=1}^t ρ^{t−i} ε\_i; UC constant; filter threshold implements selective reinstatement (1 page)
* Context reinstatement vs. distinctiveness:

  * Final‐test forward/backward show proactive retrieval of discrete cc\_k; random shows combined recency+OI; model demonstration (Fig. 6.2) (1 page)

\## 6.3 Mathematical and Computational Insights (3 pages)

* Role of probability spaces & similarity functions:

  * Integration of P over context mismatch yields retrieval noise index; metric properties of similarity ensure coherent activation (1 page)
* Evidence accumulation vs. threshold models:

  * EBRW random‐walk captures RT distributions; threshold recall for cued recall tasks (future work) (0.5 pages)
* Parameter interactions & identifiability:

  * Trade‐offs: τ\_filter vs. θ; Δq vs. τ\_filter; stability of ϕ, κ indicates decoupling of CC drift vs. STM decay (0.5 pages)
* Computational efficiency & scalability:

  * Julia implementation runtime (<1 hr on 28‐core PC); potential GPU acceleration for large arrays; high‐dimensional CC features feasible (1 page)

\## 6.4 Limitations and Future Directions (4 pages)

* Limitations:

  * Only matching event traces contribute LTM activation; partial overlaps (graded similarity) not modeled (1 page)
  * Hard threshold CC filter; consider graded weighting (Gaussian kernel or logistic) (1 page)
  * No modeling of cued‐recall (Chapter 7 outlines future work); integration with recall processes deferred (1 page)
* Extensions:

  * Incorporate neural recordings (EEG, intracranial) to estimate δ\_list, δ\_drift directly (0.5 pages)
  * Adapt model for continuous, real‐world events (narrative memory); hierarchical CC structures (0.5 pages)
  * Investigate individual differences (working memory capacity, strategy use) within extended REM (0.5 pages)
* Practical applications:

  * Educational: optimize spacing & testing schedules leveraging CC drift & testing effects; cue design (0.25 pages)
  * Legal: construct lineups maximizing foil distinctiveness along CC dimensions; forensic context manipulations (0.25 pages)

---

# Chapter 7 – Conclusions (Approximately 10 pages)

\## 7.1 Summary of Contributions (3 pages)

* Developed unified, rigorous context framework within extended REM for storage & retrieval (STM, LTM, CC/UC) (1 page)
* SLR23 model: parsimonious fit to 376 short‐term recognition conditions; extended REM captures varied foil types (1 page)
* Combined recognition experiments (Exp 1 & Exp 2): empirical validation & extended REM modeling demonstrate CC filter necessity (1 page)

\## 7.2 Theoretical Implications (3 pages)

* Context as dynamic CC features + static UC features; explicit drift & filtering essential for real‐world memory tasks (1 page)
* Memory retrieval as multiplex process: rapid STM activation vs. slower LTM event retrieval + testing‐driven restorage (1 page)
* Extended REM subsumes aspects of TCM (temporal drift) & evidence accumulation; unified approach to episodic recogni
