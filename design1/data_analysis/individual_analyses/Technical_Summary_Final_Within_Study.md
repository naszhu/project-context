# Technical Summary: Final Test Within-List Study Position Analysis

## Model Details
**Analysis:** Final Test Within-List Study Position Effects  
**Model Type:** Generalized Linear Mixed-Effects Model (GLMM)  
**Family:** Binomial with logit link  
**Convergence:** Very good (relative gradient = 0.0013)  
**Sample Size:** Final test data (subset with study position information)  
**Context:** This analysis examines retention in the final test as a function of original study position during the initial phase

## Item Type Definitions
- **SO (Study Only)**: Items that were studied but NOT tested during the initial phase
- **ST (Study-Test)**: Items that were both studied AND tested during the initial phase

## Effects Tested by the Model

### 1. Main Effects

- **Study Position Linear Trend** (`study_position_lin`)
  - Tests: Does final test recognition accuracy vary linearly with original study position?
  - Result: Significant negative trend (b = -5.48, SE = 2.63, z = -2.09, p = .037)
  - Interpretation: For SO items, recognition in final test decreases for items studied later in lists (within-list output interference or encoding position effects)

- **Study Position Quadratic Trend** (`study_position_quad`)
  - Tests: Is there a curvilinear pattern in final test accuracy as a function of original study position?
  - Result: Significant positive trend (b = 10.39, SE = 2.48, z = 4.18, p < .001)
  - Interpretation: Inverted U-shaped pattern - better final test recognition for items studied at early/late positions, worse for middle positions (primacy and recency effects persist into final test)

- **Item Type** (`item_typeST`)
  - Tests: Do ST items (studied + tested) have better final test recognition than SO items (studied only)?
  - Result: **VERY STRONG** significant difference (b = 1.43, SE = 0.03, z = 42.92, p < .001)
  - Interpretation: **ROBUST TESTING EFFECT** - Items tested during initial phase show dramatically better retention in final test

### 2. Two-Way Interactions

- **Study Position Linear × Item Type** (`study_position_lin:item_typeST`)
  - Tests: Does the linear study position effect differ between SO and ST items?
  - Result: Non-significant (b = -1.46, SE = 3.77, z = -0.39, p = .699)
  - Interpretation: The rate of decline across study positions is similar for both item types. Testing benefit is uniform across positions.

- **Study Position Quadratic × Item Type** (`item_typeST:study_position_quad`)
  - Tests: Does the curvilinear study position effect differ between SO and ST items?
  - Result: Non-significant (b = -5.15, SE = 3.47, z = -1.49, p = .137)
  - Interpretation: The inverted U-shaped pattern is similar for both item types. Primacy/recency effects operate similarly regardless of testing.

### 3. Random Effects

- **Random Intercept** (`(1 | participant_id)`)
  - Tests: Do participants differ in baseline final test recognition accuracy?
  - Result: Significant individual differences
  - Interpretation: Participants show reliable differences in overall final test performance

## Model Formula Breakdown
```
accuracy ~ study_position_lin * item_type + study_position_quad * item_type + 
           (1 | participant_id)
```

**Fixed Effects:**
- `study_position_lin`: Linear trend across original study positions
- `study_position_quad`: Quadratic trend across original study positions  
- `item_typeST`: ST vs. SO difference (testing effect)
- `study_position_lin:item_typeST`: Linear trend × item type interaction
- `study_position_quad:item_typeST`: Quadratic trend × item type interaction

**Random Effects:**
- `(1 | participant_id)`: Random intercept for each participant

## Net Effects by Item Type

### SO (Study Only) Items - Reference Level
- **Linear trend:** b = -5.48 (p = .037) - modest negative
- **Quadratic trend:** b = 10.39 (p < .001) - inverted U-shape
- **Pattern:** Shows within-list position effects with primacy/recency advantages

### ST (Study-Test) Items
- **Overall accuracy:** +1.43 log-odds (p < .001) - **MASSIVE TESTING EFFECT**
- **Linear trend:** -5.48 - 1.46 = -6.94 (interaction ns)
- **Quadratic trend:** 10.39 - 5.15 = 5.24 (interaction ns)
- **Pattern:** Similar position effects but elevated overall accuracy

## Statistical Diagnostics
- **Convergence:** Very good (relative gradient = 0.0013)
- **Model Fit:** Main effects all significant; interactions non-significant
- **Testing Effect Magnitude:** Extremely large (z = 42.92, b = 1.43)
- **Position Effect Magnitudes:** Moderate (linear: z = -2.09; quadratic: z = 4.18)

## Key Findings Summary

### 1. Robust Testing Effect
- **Magnitude:** b = 1.43 (z = 42.92, p < .001)
- **Interpretation:** One of the strongest effects in the entire study
- **Translation:** Items tested during initial phase show dramatically better final test recognition
- **Implication:** Retrieval practice has powerful long-term retention benefits

### 2. Within-List Position Effects Persist
- **Linear decline:** Items studied later show worse final test recognition
- **Primacy/recency:** Items studied at list extremes show better final test recognition
- **Persistence:** These encoding-phase position effects survive into long-term memory

### 3. Additive Testing Effect
- **Non-significant interactions** indicate the testing effect is additive, not multiplicative
- **Implication:** Testing benefits items equally regardless of study position
- **Theoretical:** Testing and position effects operate through independent mechanisms

### 4. Long-Term List Organization
- The inverted U-shape in final test (b = 10.39) shows that list-level contextual information persists
- Within-list organization established during encoding affects retrieval days/weeks later

## Critical Theoretical Implications

### Testing Effect Independence
The lack of significant interactions (both p > .13) indicates:
- Testing effect operates independently of study position
- Testing provides uniform benefit across all list positions
- Testing and encoding position effects are additive, not interactive

### Memory for Context
The persistence of position effects into final test demonstrates:
- List-level contextual information is encoded and retained
- Position within a list is part of the memory trace
- Long-term memory preserves list structure information

### Educational Implications
The robust testing effect (b = 1.43) combined with position independence suggests:
- Retrieval practice benefits all items equally
- Testing is effective regardless of when items appeared in study materials
- Testing effects are not limited to items in "special" positions

## Comparison to Initial Test Analyses

### Similarity: Position Effects Exist
Like initial test, study position affects accuracy (though magnitudes differ)

### Difference: No Item-Type Interactions
Unlike initial test (which showed massive interactions between position and item type), final test shows uniform testing effects across positions

### Implication: Different Mechanisms
Position × item type interactions in initial test reflect immediate testing dynamics (output interference, accessibility). Their absence in final test suggests these immediate effects don't persist into long-term memory, while the testing benefit itself does persist uniformly.
