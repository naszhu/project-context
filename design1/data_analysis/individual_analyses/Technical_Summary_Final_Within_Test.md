# Technical Summary: Final Test Within-List Test Position Analysis

## Model Details
**Analysis:** Final Test Within-List Test Position Effects  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Very good (relative gradient = 0.0018)  
**Sample Size:** Final test data (subset with test position information)  
**Context:** This analysis examines final test retention as a function of original test position during the initial phase

## Item Type Definitions
- **ST (Study-Test)**: Items that were both studied AND tested during the initial phase
- **TO (Test Only)**: Items that were tested (as foils) but NOT studied during the initial phase

## Effects Tested by the Model

### 1. Main Effects

- **Test Position Linear Trend** (`test_position_lin`)
  - Tests: Does final test recognition accuracy vary linearly with original test position?
  - Result: **STRONG POSITIVE** trend (b = 22.54, SE = 2.48, z = 9.10, p < .001)
  - Interpretation: **UNEXPECTED** - Recognition in final test INCREASES for items tested later in initial phase. This reverses typical output interference patterns!

- **Test Position Quadratic Trend** (`test_position_quad`)
  - Tests: Is there a curvilinear pattern in final test accuracy as a function of original test position?
  - Result: Significant negative trend (b = -10.45, SE = 2.29, z = -4.56, p < .001)
  - Interpretation: U-shaped pattern - worse accuracy for middle test positions, better for early/late positions

- **Item Type** (`item_typeTO`)
  - Tests: Do TO items (test only) have different final test recognition than ST items (study + test)?
  - Result: **VERY STRONG** significant difference (b = -1.51, SE = 0.03, z = -45.70, p < .001)
  - Interpretation: TO items (tested as foils initially) show much worse final test recognition than ST items (studied + tested initially)

### 2. Two-Way Interactions

- **Test Position Linear × Item Type** (`test_position_lin:item_typeTO`)
  - Tests: Does the positive linear test position effect differ between ST and TO items?
  - Result: Marginally non-significant (b = 4.70, SE = 2.76, z = 1.71, p = .088)
  - Interpretation: Trend suggests TO items may show an even STRONGER positive trend than ST items (27.24 vs 22.54), though not reaching significance

- **Test Position Quadratic × Item Type** (`item_typeTO:test_position_quad`)
  - Tests: Does the U-shaped pattern differ between ST and TO items?
  - Result: Non-significant (b = -2.58, SE = 2.66, z = -0.97, p = .332)
  - Interpretation: Both item types show similar U-shaped patterns

### 3. Random Effects

- **Random Intercept** (`(1 | participant_id)`)
  - Tests: Do participants differ in baseline final test recognition accuracy?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in overall final test performance

## Model Formula Breakdown
```
accuracy ~ test_position_lin * item_type + test_position_quad * item_type + 
           (1 | participant_id)
```

**Fixed Effects:**
- `test_position_lin`: Linear trend across original test positions
- `test_position_quad`: Quadratic trend across original test positions  
- `item_typeTO`: TO vs. ST difference
- `test_position_lin:item_typeTO`: Linear trend × item type interaction
- `test_position_quad:item_typeTO`: Quadratic trend × item type interaction

**Random Effects:**
- `(1 | participant_id)`: Random intercept for each participant

## Net Effects by Item Type

### ST (Study-Test) Items - Reference Level
- **Linear trend:** b = +22.54 (p < .001) - **STRONG POSITIVE**
- **Quadratic trend:** b = -10.45 (p < .001) - U-shaped
- **Pattern:** Accuracy INCREASES across test positions with U-shape

### TO (Test Only) Items
- **Overall accuracy:** -1.51 log-odds (p < .001) - much worse than ST
- **Linear trend:** 22.54 + 4.70 = **+27.24** (interaction p = .088)
- **Quadratic trend:** -10.45 - 2.58 = -13.03 (interaction ns)
- **Pattern:** Even STRONGER positive trend, similar U-shape

## Statistical Diagnostics
- **Convergence:** Very good (relative gradient = 0.0018)
- **Model Fit:** All main effects significant at p < .001
- **Effect Magnitudes:** Very large (z = 9.10, z = -4.56, z = -45.70)
- **Marginal Interaction:** Linear × item type approaching significance (p = .088)

## Key Findings Summary

### 1. 🚨 REVERSED OUTPUT INTERFERENCE PATTERN
- **Expected:** Negative linear trend (output interference)
- **Observed:** POSITIVE linear trend (b = 22.54, z = 9.10, p < .001)
- **Interpretation:** Final test shows OPPOSITE pattern from initial test
- **Implication:** Long-term memory retrieval operates differently than immediate retrieval

### 2. U-Shaped Pattern
- Middle test positions show worse final test recognition
- Early/late positions show advantages
- Suggests multiple mechanisms operating

### 3. Massive Prior Exposure Effect
- ST items vastly outperform TO items (b = -1.51, z = -45.70)
- Even minimal prior exposure (being a foil) provides benefit
- Full exposure (study + test) provides much greater benefit

### 4. Marginal Differential Trend (p = .088)
- TO items trend toward stronger positive slope
- Weaker items may benefit more from practice effects
- Interaction doesn't reach significance but suggests compensation mechanism

## Critical Theoretical Implications

### Output Interference Reversal
**The positive linear trend is a MAJOR finding:**
- **Initial test:** Negative trends (output interference operates)
- **Final test:** Positive trends (practice/adaptation dominates)

This suggests:
1. **Long-term memory is less vulnerable to output interference**
2. **Practice effects dominate in delayed testing**
3. **Different retrieval mechanisms for immediate vs. delayed testing**

### Why the Reversal?
Possible explanations:
1. **Consolidation:** Items tested later may have had more time for memory consolidation before initial test ended
2. **Practice Effects:** Participants improve at the recognition task as they progress through final test
3. **Strategic Adaptation:** Criterion shifts or strategy changes during final test
4. **Reduced Interference:** Long-term traces are less vulnerable to output interference than immediate traces
5. **Retrieval Practice Benefits:** Items tested later in initial phase may benefit from the retrieval practice of earlier items

### Multiple Mechanisms Operating
The combination of:
- Positive linear trend (+22.54)
- Negative quadratic trend (-10.45)

Indicates:
- **Overall improvement** across test (practice/warm-up)
- **Within-test interference** affecting middle positions
- These operate simultaneously and additively

## Comparison to Initial Test Analyses

### Initial Test Test Position (from earlier analysis)
- **Linear trend (foils):** b = -40.96 (strong negative)
- **Linear trend (targets):** b = +35.74 (positive via interaction)
- **Pattern:** Strong output interference for foils, reversal for targets

### Final Test Test Position (current analysis)
- **Linear trend (ST):** b = +22.54 (positive)
- **Linear trend (TO):** b = +27.24 (even more positive)
- **Pattern:** BOTH show positive trends

### Key Difference
- **Initial test:** Item-type-specific output interference (differential patterns)
- **Final test:** Universal positive trends (both item types improve)

### Implication
- Immediate testing shows output interference vulnerability
- Delayed testing shows practice effects dominance
- This is a fundamental difference in retrieval dynamics

## Research Implications

### 1. Test Timing Matters
Output interference may be primarily an **immediate retrieval phenomenon**, with long-term retrieval showing different dynamics.

### 2. Practice Effects in Recognition
Even passive recognition testing produces practice effects that accumulate across the test, improving performance.

### 3. Prior Exposure Gradient
The results show a clear gradient of prior exposure effects:
- **No exposure (foils):** Baseline
- **Minimal exposure (TO - tested as foils):** Intermediate
- **Full exposure (ST - studied + tested):** Best

### 4. Memory Consolidation Benefits
Items tested later in initial phase may benefit from:
- More time between initial exposure and final test
- Retrieval-induced strengthening of related items
- Progressive consolidation during initial test phase


