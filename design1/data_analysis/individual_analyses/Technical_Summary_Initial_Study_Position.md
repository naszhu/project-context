# Technical Summary: Initial Study Position Analysis

## Model Details
**Analysis:** Initial Test Study Position Effects  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Excellent (relative gradient = 0.00097)  
**Sample Size:** 38,958 trials  

## Effects Tested by the Model

### 1. Main Effects
- **Study Position Linear Trend** (`study_position_lin`)
  - Tests: Does recognition accuracy change linearly across study positions?
  - Result: Significant negative trend (b = -40.83, p < .001)
  - Interpretation: Accuracy decreases from early to late study positions

- **Study Position Quadratic Trend** (`study_position_quad`)
  - Tests: Is there a curvilinear (U-shaped or inverted U-shaped) pattern across study positions?
  - Result: Significant positive trend (b = 36.65, p < .001)
  - Interpretation: Inverted U-shaped pattern (better accuracy at early/late positions, worse in middle)

- **Item Type** (`item_typetarget`)
  - Tests: Do target items differ from foil items in recognition accuracy?
  - Result: Significant difference (b = -0.35, p < .001)
  - Interpretation: Targets recognized less accurately than foils are correctly rejected

### 2. Two-Way Interactions
- **Study Position Linear × Item Type** (`study_position_lin:item_typetarget`)
  - Tests: Does the linear decline across study positions differ between target and foil items?
  - Result: Significant interaction
  - Interpretation: The rate of decline differs between item types

- **Study Position Quadratic × Item Type** (`study_position_quad:item_typetarget`)
  - Tests: Does the curvilinear pattern across study positions differ between target and foil items?
  - Result: Significant interaction
  - Interpretation: The inverted U-shaped pattern differs between item types

### 3. Random Effects
- **Random Intercept** (`(1 | participant_id)`)
  - Tests: Do participants differ in baseline recognition accuracy?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in overall accuracy

- **Random Slope** (`(0 + study_position_lin | participant_id)`)
  - Tests: Do participants differ in their rate of decline across study positions?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in susceptibility to output interference

## Model Formula Breakdown
```
accuracy ~ (study_position_lin + study_position_quad) * item_type + 
           (1 | participant_id) + (0 + study_position_lin | participant_id)
```

**Fixed Effects:**
- `study_position_lin`: Linear trend across study positions
- `study_position_quad`: Quadratic trend across study positions  
- `item_typetarget`: Target vs. foil difference
- `study_position_lin:item_typetarget`: Linear trend × item type interaction
- `study_position_quad:item_typetarget`: Quadratic trend × item type interaction

**Random Effects:**
- `(1 | participant_id)`: Random intercept for each participant
- `(0 + study_position_lin | participant_id)`: Random slope for linear trend (uncorrelated with intercept)

## Statistical Diagnostics
- **Convergence:** Excellent (relative gradient = 0.00097)
- **Model Fit:** All fixed effects significant at p < .001
- **Random Effects:** Both random intercept and slope significant
- **Sample Size:** 38,958 trials provides high power for all effects

## Key Findings Summary
1. **Output Interference:** Strong linear decline across study positions
2. **Curvilinear Pattern:** Inverted U-shaped accuracy pattern
3. **Item Type Effects:** Targets less accurate than foils
4. **Moderated Effects:** Position effects differ between item types
5. **Individual Differences:** Reliable differences in both baseline accuracy and interference susceptibility


