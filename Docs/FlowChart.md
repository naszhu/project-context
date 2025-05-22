#1

```txt
START
  ↓
DEFINE ITEM AND CONTEXT FEATURES
  • Each picture → vector of:
      – 25 Content (T) features
      – 25 Changing‐Context (CC) features
      – 25 Unchanging‐Context (UC) features
  • Base‐rate parameters g_T = 0.4; g_CC/UC = 0.3
  ↓
STUDY PHASE (for each list)
  ↓
STORE EACH STUDIED VECTOR
  • For each feature:
      – Copy correctly with prob. c (T:0.75; CC/UC:0.75)
      – If not, assign random value (per g)
  • Storage learning rate u (T:0.06; CC/UC:0.05)
  ↓
TEST PHASE (for each test trial)
  ↓
─► STAGE 1: CONTEXT FILTERING
│   • Compute likelihood‐ratio L_ctx for each stored trace using CC+UC
│   • Activate traces with L_ctx > S₁ (e.g. 10 000)
│   ↓
└─► STAGE 2: CONTENT MATCHING
      • For each activated trace, compute L_cont using T features
      • Compute average odds O = mean(L_cont)
      ↓
DECISION
  • If O > D (≈1.0) → “OLD”
      – If max(L_cont) > S₂ (100), strengthen that trace:
          • For each T (and CC/UC) feature mismatched or missing:
              – Replace with correct value with prob. E (0.7)
      – ELSE no strengthening
  • Else → “NEW”
      – Store new test trace (same storage process as above)
  ↓
REPEAT FOR ALL TRIALS IN LIST
  ↓
ADVANCE TO NEXT LIST (2–10)
  • Lists 2–10 introduce:
      – Foil types (new, n–1 studied/tested, future foils)
      – Potential parameter adjustments across lists:
          A) Increase CC change magnitude
          B) Adjust UC storage vs. retrieval
          C) Change number of CC features stored/tested
          D) Improve CC storage quality (u, c)
  ↓
FINAL TEST (after List 10)
  • Test all 246 studied pictures + 246 brand‐new foils
  ↓
END
```