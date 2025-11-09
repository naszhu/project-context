# Revised Initial Within-List Study Position Effects Section

## Issues Identified from Comments:

1. **"reference" terminology** - Comment: "unnecessarily confusing terminology"
   - Location: "Target pictures showed lower accuracy compared to the reference (foil)"
   - Fix: Replace "the reference (foil)" with just "foil"

2. **"studied later in the list" for foils** - Comment: "TESTED later? (a foil was not studied in the list)"
   - Location: "indicating that pictures studied later in the list showed substantially lower recognition accuracy"
   - Issue: Foils were never studied, only tested. Cannot say "studied later" for foils.
   - Fix: Need to clarify what study_position means for foils, or reframe the interpretation

3. **Quadratic trends explanation** - Comment: "I am not seeing what you mean"
   - Location: The entire quadratic trends paragraph
   - Issue: Explanation is unclear and potentially contradictory
   - Fix: Clarify how linear and quadratic trends combine

---

## Initial Within-List Study Position Effects (Updated Analysis)

Study position often yields classic serial-position patterns, a pattern that returned in Experiment 1 (see Figure 7.1.a, left panel). Although modelling these effects was not a primary objective, we summarise them here for completeness. Because only studied items possess meaningful study positions, the updated analysis focused exclusively on target trials. We fit a binomial GLMM with logit link including fixed effects for the linear and quadratic study-position terms, plus random intercepts and participant-specific slopes for the linear trend.

### Results

- **Baseline accuracy.** The intercept was 2.21 logit, 95% CI [2.05, 2.37], corresponding to approximately 90.0% recognition accuracy for items from the centred study position.

- **Linear trend.** Recognition accuracy declined significantly across study positions, b = -12.73, SE = 3.27, z = -3.90, p < .001, 95% CI [-19.13, -6.33]. Items studied later in the list were remembered less accurately than items presented near the start.

- **Quadratic trend.** A significant positive quadratic component emerged, b = 21.52, SE = 2.82, z = 7.62, p < .001, 95% CI [15.98, 27.05], indicating a curved serial-position function. Accuracy was highest for the earliest positions, declined most sharply through the middle of the list, and levelled off (or partially recovered) at the end—an inverted-U pattern characteristic of simultaneous primacy and recency influences.

Together, these trends confirm robust serial-position effects during the initial study phase: strong primacy/recency benefits accompanied by disproportionately poor performance for middle-list items. Random intercepts and slopes (not shown) indicate reliable individual differences both in overall accuracy and in sensitivity to study-position effects.

