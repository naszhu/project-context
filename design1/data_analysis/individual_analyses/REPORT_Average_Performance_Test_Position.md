# Report: Average Performance Across Test Positions
## Initial Test: Test Position Analysis

---

## Overview

This report examines whether overall performance (averaged across foil and target items) changes systematically across test positions during the initial test phase. Two complementary approaches were used to test for averaged position effects, yielding different but complementary insights.

---

## Approach 1: Marginal Averaging from Interaction Model

### Model Specification
```R
accuracy ~ (test_position_lin + test_position_quad) * item_type +
           (1 | participant_id) + (0 + test_position_lin | participant_id)
```

This model includes:
- Main effects of linear and quadratic test position trends
- Item type (foil vs. target) as a moderator
- Full interactions between position trends and item type
- Random intercepts and random slopes for linear trends

### Method
The averaged trends were extracted using `emtrends(~ 1)`, which computes the marginal average of the position effects across both item types on the logit scale.

### Results

**Averaged Linear Trend:**
- Estimate: -2.61
- SE: 2.48
- 95% CI: [-7.47, 2.25]
- **Result: NOT significant** (p > .05)

**Averaged Quadratic Trend:**
- Estimate: -4.91
- SE: 3.02
- 95% CI: [-10.84, 1.01]
- **Result: NOT significant** (p > .05)

### Interpretation
When averaging foil and target effects on the logit scale, there is no significant overall linear or quadratic position effect. This is because foil and target items show **opposite trends** that cancel each other out:

- **Foils**: Strong negative linear trend (-40.96, p < .001)
  - Performance decreases across test positions
- **Targets**: Strong positive linear trend (+35.74, p < .001)
  - Performance increases across test positions
- **Difference**: -76.70 (p < .001)

The interaction is highly significant, indicating that foil and target items are affected differently by test position.

---

## Approach 2: Overall Model Ignoring Item Type

### Model Specification
```R
accuracy ~ test_position_lin + test_position_quad + (1 | participant_id)
```

This simpler model:
- Treats all trials equally regardless of item type
- Tests for overall position effects across the entire dataset
- Does not separate foil and target patterns

### Method
A generalized linear mixed model was fitted with test position (linear and quadratic terms) as the only fixed predictors, ignoring item type distinctions.

### Results

**Descriptive Statistics (Raw Accuracy by Position Bins):**
```
Position Range    Mean Accuracy    N
1-5 (early)           88.3%      7,684
5-9                   90.0%      7,816
9-12                  90.2%      7,815
12-16                 89.8%      7,822
16-20 (late)          89.8%      7,821
```

**Model Estimates:**

**Overall Linear Trend:**
- Estimate: +10.19
- SE: 2.79
- z = 3.66
- **p < .001** ✓ SIGNIFICANT

**Overall Quadratic Trend:**
- Estimate: -11.42
- SE: 2.19
- z = -5.22
- **p < .001** ✓ SIGNIFICANT

### Interpretation
When ignoring item type and examining overall performance:

1. **Significant positive linear trend**: Performance increases across test positions overall
2. **Significant negative quadratic trend**: The relationship shows an inverted U-shape
   - Performance increases from early to middle positions
   - Then plateaus or slightly decreases toward the end

This pattern indicates that participants show overall improvement across test positions, peaking around the middle positions.

---

## Reconciling the Two Approaches

### Why Different Results?

The two approaches test fundamentally different questions:

**Approach 1 (Marginal Averaging):**
- Question: "After accounting for item-type-specific effects, is there an overall position trend?"
- Answer: No, the opposite trends for foil and target cancel out statistically
- This is the **conditional** average (averaging after separating item types)

**Approach 2 (Ignoring Item Type):**
- Question: "Across all trials, does overall performance change with position?"
- Answer: Yes, there is a significant positive trend with inverted U-shape
- This is the **unconditional** average (averaging without separating item types)

### Key Insight

The discrepancy reveals an important aspect of the data structure:

1. **Overall performance improves** across test positions (88% → 90%)
2. This improvement is **not uniform** across item types:
   - Target recognition improves strongly
   - Foil rejection deteriorates
3. The net effect is a modest overall increase, but the underlying patterns are opposite

### Statistical vs. Practical Significance

- **Statistically**: The interaction model shows that foil and target patterns differ significantly
- **Practically**: Overall accuracy does increase by ~2 percentage points, which may be meaningful
- **Theoretically**: The opposite effects suggest different mechanisms:
  - Targets benefit from practice/familiarity effects
  - Foils suffer from increased false alarms (possibly due to familiarity buildup)

---

## Conclusions

### Summary of Findings

1. **Overall performance increases across test positions** when ignoring item type
   - Linear trend: +10.19 (p < .001)
   - Quadratic trend: -11.42 (p < .001)
   - Pattern: Inverted U-shape, peaking around middle positions

2. **Marginal average trend is non-significant** when accounting for item type
   - Linear trend: -2.61 (p > .05)
   - Due to opposite effects for foil and target items

3. **Item-specific patterns are highly significant**:
   - Foils: Strong negative trend (-40.96, p < .001)
   - Targets: Strong positive trend (+35.74, p < .001)
   - Interaction: Highly significant (p < .001)

### Recommendations for Reporting

**If interested in overall task performance:**
- Report Approach 2 results
- Emphasize the 2% improvement in accuracy from early to middle positions
- Note the inverted U-shape pattern

**If interested in item-type-specific mechanisms:**
- Report Approach 1 results and the interaction model
- Emphasize the opposite patterns for foil and target items
- Discuss theoretical implications of divergent trends

**For comprehensive reporting:**
- Present both analyses
- Explain that overall improvement masks opposite item-type-specific effects
- This demonstrates the importance of testing for interactions

---

## Technical Notes

- **Data**: Initial test phase (pretest_response), excluding trials with RT < 150ms or > 3500ms
- **Sample size**: 38,958 trials across both approaches
- **Model family**: Binomial (logistic regression)
- **Random effects**: Participant-level intercepts (both models), plus random slopes for linear position trend (Approach 1)
- **Estimation**: BOBYQA optimizer in lme4 package

---

## Files Generated

- `init_testpos_model_enhanced.rds` - Full results including both averaged and item-specific trends
- `init_testpos_summary_enhanced.csv` - Fixed effects summary from interaction model
- `02_initial_test_position_analysis_ENHANCED.R` - Full analysis script with both approaches

---

**Date**: October 11, 2025
**Analysis**: Initial Test - Test Position Effects on Average Performance
