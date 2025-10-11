# Technical Summary: Final Test Between-List Final Order Analysis

## Model Details
**Analysis:** Final Test Between-List Final Order Effects (Output Interference DURING Final Test)  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Excellent (relative gradient = 0.0000047)  
**Sample Size:** Full final test dataset  
**Context:** This examines output interference as participants progress through the final test itself

## Key Distinction
- **Initial Order Analysis:** How initial list order affects final test performance
- **Final Order Analysis (THIS):** How position WITHIN the final test affects performance

## Item Type Definitions
- **Foil**: New items never seen before (reference level)
- **SO (Study Only)**: Studied but not tested initially
- **ST (Study-Test)**: Both studied and tested initially  
- **TO (Test Only)**: Tested as foils initially (not studied)

## Condition Definitions
- **Backward**: Final test lists in REVERSE order of initial phase (reference level)
- **Forward**: Final test lists in SAME order as initial phase
- **Random**: Final test lists in RANDOM order

## Effects Tested by the Model

### 1. Main Effects

- **Final Order Linear Trend** (`final_order_lin`)
  - Tests: Does accuracy decline as final test progresses?
  - Result: **STRONG NEGATIVE** (b = -46.72, SE = 7.90, z = -5.92, p < .001)
  - Interpretation: Classic output interference DURING final test for foils in backward condition

- **Final Order Quadratic Trend** (`final_order_quad`)
  - Tests: Is there a curvilinear pattern as final test progresses?
  - Result: Non-significant (b = 10.96, p = .162)
  - Interpretation: No reliable curvilinear pattern for foils

- **Item Type Effects**
  - **SO:** b = -0.95 (z = -20.57, p < .001) - worse than foils
  - **ST:** b = +0.56 (z = 8.57, p < .001) - better than foils (testing effect!)
  - **TO:** b = -0.99 (z = -21.04, p < .001) - worse than foils

- **Condition Effects**
  - **Forward:** b = -0.13 (p = .187, ns)
  - **Random:** b = +0.03 (p = .717, ns)

### 2. Two-Way Interactions

**Final Order Linear × Item Type:**
- **SO:** b = +6.48 (p = .633, ns) - similar to foils
- **ST:** b = -55.08 (z = -2.70, p = .007) - STRONGER output interference
- **TO:** b = -76.00 (z = -5.45, p < .001) - MUCH STRONGER output interference

**Final Order Linear × Condition:**
- **Forward:** b = +2.52 (p = .818, ns)
- **Random:** b = +23.31 (z = 2.43, p = .015) - reduces output interference

**Final Order Quadratic × Item Type:**
- **SO:** b = +36.90 (z = 2.75, p = .006)
- **ST:** b = +74.75 (z = 3.85, p < .001)
- **TO:** b = +57.05 (z = 4.17, p < .001)
All show inverted U-shapes

**Final Order Quadratic × Condition:**
- **Forward:** b = +1.29 (p = .905, ns)
- **Random:** b = -8.30 (p = .384, ns)

### 3. 🚨 THREE-WAY INTERACTIONS

**Final Order Linear × Item Type × Condition**

**Forward Condition:**
- **SO × forward × linear:** b = +15.09 (p = .428, ns)
- **ST × forward × linear:** b = +19.93 (p = .470, ns)
- **TO × forward × linear:** b = +114.59 (z = 5.96, p < .001) 🚨🚨🚨

**Random Condition:**
- **SO × random × linear:** b = -27.20 (p = .098, ns)
- **ST × random × linear:** b = -9.22 (p = .701, ns)
- **TO × random × linear:** b = +40.34 (z = 2.42, p = .016)

**Final Order Quadratic × Item Type × Condition**

**Forward Condition:**
- **TO × forward × quadratic:** b = -53.94 (z = -2.84, p = .005)

**Random Condition:**
- **ST × random × quadratic:** b = -46.05 (z = -2.00, p = .046)
- **TO × random × quadratic:** b = -32.69 (z = -1.98, p = .047)

## Net Linear Trends: Critical Analysis

### By Condition and Item Type

| Item Type | Backward | Forward | Random | Backward→Forward Δ |
|-----------|----------|---------|--------|--------------------|
| **Foil**  | -46.72   | -44.20  | -23.41 | +2.52 (ns) |
| **SO**    | -40.24   | -22.63  | -44.13 | +17.61 |
| **ST**    | -101.80  | -79.35  | -87.71 | +22.45 |
| **TO**    | -122.72  | **-5.61** | -59.07 | **+117.11 ***** 🚨 |

### Key Observations:

1. **ALL CONDITIONS show NEGATIVE trends** (output interference during final test)
   - Unlike initial order analysis (which showed positive trends in backward)
   - Output interference operates as final test progresses

2. **BACKWARD CONDITION:** Strongest output interference
   - TO items show extreme OI (-122.72)
   - ST items show strong OI (-101.80)

3. **FORWARD CONDITION:** Dramatically REDUCES OI for TO items
   - TO items: -122.72 → -5.61 (117.11 unit reduction!)
   - Most dramatic effect in this analysis

4. **RANDOM CONDITION:** Moderate reduction in OI overall
   - Main effect (b = +23.31) reduces baseline OI
   - But TO items still show moderate OI (-59.07)

## Statistical Diagnostics
- **Convergence:** Excellent (relative gradient = 0.0000047) ✓✓✓
- **Critical Three-Way:** Very robust (z = 5.96 for TO × forward)
- **Effect Sizes:** Very large (117.11 unit swing for TO items)
- **Model Complexity:** Full three-way interactions converged successfully

## Key Findings Summary

### 1. Output Interference Operates During Final Test
ALL conditions show negative trends, indicating output interference accumulates as participants progress through the lengthy final test.

### 2. 🚨 TO Items: MASSIVE Condition Effect
**TO × Forward interaction (b = 114.59, z = 5.96, p < .001)**
- Backward: Severe OI (-122.72)
- Forward: Minimal OI (-5.61)
- **117.11 unit reduction!**

This is one of the LARGEST effects in the entire study!

### 3. Prior Test Experience INCREASES OI Vulnerability
Items tested initially (ST, TO) show STRONGER output interference during final testing:
- **Foil:** -46.72 (baseline)
- **ST:** -101.80 (2.2× stronger)
- **TO:** -122.72 (2.6× stronger in backward)

### 4. Random Presentation is Protective
The random condition reduces output interference (b = +23.31), showing that disrupting systematic temporal order helps.

### 5. Different Mechanisms for Initial vs Final Order
**Initial Order Analysis:**
- Forward = increases interference
- Backward = shows facilitation

**Final Order Analysis (THIS):**
- All show output interference
- Forward REDUCES interference for TO items
- Opposite pattern!

## Critical Theoretical Implications

### Two Types of Output Interference

**Type 1: Initial Order Effects** (from initial order analysis)
- How initial list order affects final test performance
- Forward reinstates context → interference
- Backward violates context → facilitation

**Type 2: Final Test Order Effects** (THIS analysis)
- How position within final test affects performance
- Output interference accumulates during final test
- Forward presentation HELPS TO items (opposite of Type 1!)

### Why TO Items Benefit from Forward in Final Test

**Hypothesis:** TO items (initially tested as foils) may benefit from forward presentation during final test because:
1. **Context Reinstatement:** Forward order reinstates the original "foil" context
2. **Distinctiveness:** In forward condition, TO items appear in same temporal position, enhancing retrieval
3. **Reduced Interference:** Reinstating original context reduces interference from other items

This is OPPOSITE to the initial order effect, suggesting different mechanisms operate for:
- "When was it studied?" (initial order)
- "When does it appear in final test?" (final order)

### Prior Testing Sensitizes Items to OI

ST and TO items show 2-3× stronger output interference than foils during final testing, suggesting:
- Prior test experience changes memory representation
- Items become more vulnerable to subsequent testing interference
- Testing creates interconnections that increase interference

### Random Order is Protective

The random condition's protective effect (b = +23.31) demonstrates:
- Disrupting temporal relationships reduces output interference
- Systematic order creates interference opportunities
- Randomization can improve performance

## Comparison Across Analyses

### Within-List Test Position (Earlier Analysis)
- **Pattern:** POSITIVE trends (practice effects)
- **Context:** Position within INITIAL test
- **Finding:** Practice effects dominate

### Initial Order (Earlier Analysis)
- **Pattern:** Condition-dependent (backward +, forward -)
- **Context:** Which INITIAL list items came from
- **Finding:** Context reinstatement drives effects

### Final Order (THIS Analysis)
- **Pattern:** NEGATIVE trends (output interference)
- **Context:** Position within FINAL test
- **Finding:** OI during final test, but TO items protected in forward

### Integration
These three analyses reveal:
1. **Immediate testing:** Output interference operates (initial test)
2. **Delayed testing:** Practice effects can dominate (within-list)
3. **List-level effects:** Context reinstatement matters (initial order)
4. **Final test dynamics:** OI operates, but context helps some items (final order)

## Research Implications

### 1. Multiple OI Mechanisms
At least two distinct output interference mechanisms:
- **List-level OI:** Based on initial list order
- **Test-level OI:** Based on position within test

### 2. TO Items Are Special
TO items show opposite patterns for initial vs final order effects:
- Initial order forward = more interference
- Final order forward = LESS interference
This suggests unique processing for items initially encountered as foils

### 3. Test Design Implications
- Test order matters for final test performance
- Random presentation can reduce output interference
- Forward presentation has complex effects depending on item type

### 4. Prior Testing Has Lasting Effects
Items tested initially show stronger output interference in delayed testing, suggesting:
- Testing creates lasting changes in memory representation
- These changes increase vulnerability to later interference
- Testing effects are not purely beneficial

## 🎯 Bottom Line
This analysis reveals:
1. **Output interference operates DURING final test**
2. **TO items show 117.11 unit condition effect** (largest in this analysis)
3. **Forward presentation HELPS TO items** (opposite of initial order effect)
4. **Random presentation reduces OI overall**
5. **Different mechanisms for "initial order" vs "final test order" effects**

The TO × forward interaction (b = 114.59, z = 5.96) is a critical finding showing that context reinstatement during final testing can REDUCE output interference for items initially encountered as foils!
