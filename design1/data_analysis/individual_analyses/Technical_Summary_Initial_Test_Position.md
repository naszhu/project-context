# Technical Summary: Initial Test Position Analysis

## Model Details
**Analysis:** Initial Test Position Effects  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Very good (relative gradient = 0.0015)  
**Sample Size:** 38,958 trials  

## Effects Tested by the Model

### 1. Main Effects

- **Test Position Linear Trend** (`test_position_lin`)
  - Tests: Does recognition accuracy change linearly across test positions?
  - Result: Significant negative trend (b = -40.96, SE = 2.58, z = -15.87, p < .001)
  - Interpretation: Accuracy decreases from early to late test positions (output interference during testing)

- **Test Position Quadratic Trend** (`test_position_quad`)
  - Tests: Is there a curvilinear (U-shaped or inverted U-shaped) pattern across test positions?
  - Result: Significant positive trend (b = 9.05, SE = 3.52, z = 2.57, p = .010)
  - Interpretation: Modest inverted U-shaped pattern (slightly better accuracy at early/late positions)

- **Item Type** (`item_typetarget`)
  - Tests: Do target items differ from foil items in recognition accuracy?
  - Result: Significant difference (b = -0.89, SE = 0.04, z = -24.18, p < .001)
  - Interpretation: Targets recognized substantially less accurately than foils are correctly rejected

### 2. Two-Way Interactions

- **Test Position Linear × Item Type** (`test_position_lin:item_typetarget`)
  - Tests: Does the linear decline across test positions differ between target and foil items?
  - Result: **VERY STRONG** significant interaction (b = 76.70, SE = 2.84, z = 27.02, p < .001)
  - Interpretation: **CRITICAL FINDING** - The negative linear trend for foils is nearly completely reversed for targets. Foils show strong output interference (-40.96), but targets show almost no net decline (-40.96 + 76.70 = +35.74), suggesting targets may actually improve slightly across test positions.

- **Test Position Quadratic × Item Type** (`test_position_quad:item_typetarget`)
  - Tests: Does the curvilinear pattern across test positions differ between target and foil items?
  - Result: Significant negative interaction (b = -27.92, SE = 3.26, z = -8.57, p < .001)
  - Interpretation: The inverted U-shape for foils (+9.05) is reversed for targets (9.05 - 27.92 = -18.87), showing a U-shaped pattern or flatter curve for targets

### 3. Random Effects

- **Random Intercept** (`(1 | participant_id)`)
  - Tests: Do participants differ in baseline recognition accuracy?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in overall accuracy

- **Random Slope** (`(0 + test_position_lin | participant_id)`)
  - Tests: Do participants differ in their rate of change across test positions?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in susceptibility to output interference during testing

## Model Formula Breakdown
```
accuracy ~ (test_position_lin + test_position_quad) * item_type + 
           (1 | participant_id) + (0 + test_position_lin | participant_id)
```

**Fixed Effects:**
- `test_position_lin`: Linear trend across test positions
- `test_position_quad`: Quadratic trend across test positions  
- `item_typetarget`: Target vs. foil difference
- `test_position_lin:item_typetarget`: Linear trend × item type interaction
- `test_position_quad:item_typetarget`: Quadratic trend × item type interaction

**Random Effects:**
- `(1 | participant_id)`: Random intercept for each participant
- `(0 + test_position_lin | participant_id)`: Random slope for linear trend (uncorrelated with intercept)

## Net Effects by Item Type

### Foil Items (Reference Level)
- **Linear trend:** b = -40.96 (strong negative)
- **Quadratic trend:** b = +9.05 (modest inverted U-shape)
- **Pattern:** Strong output interference with declining foil rejection

### Target Items (Target = 1)
- **Linear trend:** -40.96 + 76.70 = +35.74 (positive!)
- **Quadratic trend:** 9.05 - 27.92 = -18.87 (U-shaped)
- **Pattern:** Targets show improvement or stability across test positions

## Statistical Diagnostics
- **Convergence:** Very good (relative gradient = 0.0015)
- **Model Fit:** All effects significant at p ≤ .010
- **Interaction Magnitudes:** Extremely large (z = 27.02, z = -8.57)
- **Sample Size:** 38,958 trials provides very high power

## Key Findings Summary
1. **Differential Output Interference:** Output interference is item-type specific
2. **Foil Vulnerability:** Foil rejection shows strong output interference
3. **Target Resilience:** Target recognition shows minimal or reversed output interference
4. **Curvilinear Differences:** Position effects differ in shape between item types
5. **Individual Differences:** Reliable differences in both baseline and output interference susceptibility

## Critical Theoretical Implications
The nearly complete reversal of the linear trend for targets (interaction b = 76.70) is a major finding suggesting:
- Output interference may be specific to foil rejection mechanisms
- Target traces may strengthen or become more accessible during testing (possibly via priming)
- Simple output interference models cannot explain these differential patterns




