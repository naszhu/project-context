# Technical Summary: Initial Between-List Analysis

## Model Details
**Analysis:** Initial Test Between-List Effects (List Number)  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Excellent (relative gradient = 0.00039)  
**Sample Size:** 38,958 trials  

## Effects Tested by the Model

### 1. Main Effects

- **List Number Linear Trend** (`list_number_lin`)
  - Tests: Does recognition accuracy change linearly across lists?
  - Result: Non-significant (b = 0.54, SE = 2.61, z = 0.21, p = .835)
  - Interpretation: No linear trend for foil items across lists

- **List Number Quadratic Trend** (`list_number_quad`)
  - Tests: Is there a curvilinear (U-shaped or inverted U-shaped) pattern across lists?
  - Result: Significant positive trend (b = 11.38, SE = 2.29, z = 4.97, p < .001)
  - Interpretation: Inverted U-shaped pattern - better accuracy for early/late lists, worse for middle lists (primacy and recency effects)

- **Item Type** (`item_typetarget`)
  - Tests: Do target items differ from foil items in recognition accuracy?
  - Result: Significant difference (b = -0.86, SE = 0.04, z = -23.30, p < .001)
  - Interpretation: Targets recognized substantially less accurately than foils are correctly rejected

### 2. Two-Way Interactions

- **List Number Linear × Item Type** (`list_number_lin:item_typetarget`)
  - Tests: Does the linear trend across lists differ between target and foil items?
  - Result: **VERY STRONG** significant negative interaction (b = -55.06, SE = 2.50, z = -22.06, p < .001)
  - Interpretation: **CRITICAL FINDING** - While foils show no linear trend (b = 0.54, ns), targets show a strong negative linear trend (0.54 - 55.06 = -54.52), indicating substantial proactive interference for targets but not foils.

- **List Number Quadratic × Item Type** (`list_number_quad:item_typetarget`)
  - Tests: Does the curvilinear pattern across lists differ between target and foil items?
  - Result: Significant positive interaction (b = 32.66, SE = 2.38, z = 13.74, p < .001)
  - Interpretation: The inverted U-shape is much stronger for targets (11.38 + 32.66 = 44.04) than for foils (11.38), indicating more pronounced primacy/recency effects for targets

### 3. Random Effects

- **Random Intercept** (`(1 | participant_id)`)
  - Tests: Do participants differ in baseline recognition accuracy?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in overall accuracy

- **Random Slope** (`(0 + list_number_lin | participant_id)`)
  - Tests: Do participants differ in their rate of change across lists?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in susceptibility to proactive interference across lists

## Model Formula Breakdown
```
accuracy ~ (list_number_lin + list_number_quad) * item_type + 
           (1 | participant_id) + (0 + list_number_lin | participant_id)
```

**Fixed Effects:**
- `list_number_lin`: Linear trend across lists
- `list_number_quad`: Quadratic trend across lists  
- `item_typetarget`: Target vs. foil difference
- `list_number_lin:item_typetarget`: Linear trend × item type interaction
- `list_number_quad:item_typetarget`: Quadratic trend × item type interaction

**Random Effects:**
- `(1 | participant_id)`: Random intercept for each participant
- `(0 + list_number_lin | participant_id)`: Random slope for linear trend (uncorrelated with intercept)

## Net Effects by Item Type

### Foil Items (Reference Level)
- **Linear trend:** b = 0.54 (ns) - no systematic change across lists
- **Quadratic trend:** b = 11.38 (p < .001) - modest inverted U-shape
- **Pattern:** Stable foil rejection with slight primacy/recency effects

### Target Items (Target = 1)
- **Linear trend:** 0.54 - 55.06 = **-54.52** (p < .001) - strong negative trend
- **Quadratic trend:** 11.38 + 32.66 = **44.04** (p < .001) - pronounced inverted U-shape
- **Pattern:** Systematic decline with strong primacy and recency effects

## Statistical Diagnostics
- **Convergence:** Excellent (relative gradient = 0.00039)
- **Model Fit:** Main quadratic effect and both interactions significant at p < .001
- **Interaction Magnitudes:** Very large (z = -22.06, z = 13.74)
- **Sample Size:** 38,958 trials provides very high power
- **Linear Main Effect:** Non-significant, indicating differential effects are entirely driven by interactions

## Key Findings Summary
1. **Item-Type-Specific Proactive Interference:** Targets show strong proactive interference across lists (b = -54.52), foils do not
2. **Differential Primacy/Recency:** Both show inverted U-shapes, but targets show 4× stronger effect (44.04 vs 11.38)
3. **Foil Stability:** Foil rejection is remarkably stable across lists
4. **Target Vulnerability:** Target recognition is highly sensitive to list position
5. **Individual Differences:** Reliable differences in both baseline and interference susceptibility

## Critical Theoretical Implications

### Proactive Interference is Item-Type-Specific
The massive interaction (b = -55.06, z = -22.06) demonstrates that proactive interference across lists:
- **Strongly affects** target recognition
- **Does not affect** foil rejection

This suggests:
- Target traces accumulate interference from other lists
- Foil rejection operates independently across lists
- Memory interference operates differently for "old" vs "new" decisions

### Primacy and Recency Effects are Stronger for Targets
The large positive quadratic interaction (b = 32.66, z = 13.74) shows:
- Targets benefit much more from being in first/last lists
- This partially offsets (but doesn't eliminate) the linear decline
- List-level organizational effects are stronger for studied items

### Memory Organization
The results suggest memory is organized at the list level, with:
- Special encoding/retrieval for list extremes (primacy/recency)
- Accumulation of proactive interference for targets
- List-independent foil rejection processes


