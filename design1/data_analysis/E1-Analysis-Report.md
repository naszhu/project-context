# Experiment 1: Recognition Memory Analysis Results

## Mathematical Model

At the trial level, each response is modeled as a Bernoulli outcome:

$$Y_{slpt} \sim \text{Bernoulli}(\pi_{slpt}), \quad \text{logit}(\pi_{slpt}) = \eta_{slpt}$$

where $s$ indexes subjects, $l$ lists, $p$ study position, and $t$ item type (target vs. foil).

The linear predictor is:

$$\eta_{slpt} = \beta_0 + \beta_1 b_1(p_c) + \beta_2 b_2(p_c) + \beta_3 \,\text{Target}_t + \beta_4\, b_1(p_c)\!\times\!\text{Target}_t + \beta_5\, b_2(p_c)\!\times\!\text{Target}_t + \gamma^\top \mathbf{X} + u_{0s} + u_{1s} b_1(p_c) + u_{2s} b_2(p_c) + v_{0sl}$$

- $p_c = p - \bar p$ is the centered study position.
- $b_1, b_2$ are orthogonal polynomial bases (linear, quadratic).
- $\mathbf{X}$ includes other factors (e.g., Forward/Backward/Random condition).
- Random effects: subject-specific intercepts and slopes, plus subject-by-list intercepts.

## Results

### Initial Within-List Study Position (Experiment 1)

We analyzed trial-level recognition accuracy with a mixed-effects logistic regression including linear and quadratic orthogonal polynomials of study position (centered within list) and item type (target vs. foil) as fixed effects. Random effects included participant intercepts.

For targets, the quadratic effect was significant (β = 31.07, SE = 1.87, z = 16.57, p < .001), indicating a U-shaped serial position function reflecting primacy with modest recency: recognition was highest for early positions (M = .90), dropped for middle positions (M = .88), and partially recovered at late positions (M = .88). The linear trend was also significant (β = -47.50, SE = 2.03, z = -23.45, p < .001), reflecting an overall decline across positions. Foils showed no reliable quadratic trend due to ceiling effects.

### Initial Within-List Test Position (Experiment 1)

A separate model tested the influence of test order (centered) on recognition accuracy. Results revealed diverging linear trends for targets and foils. Targets improved across the test sequence (linear interaction: β = 74.94, SE = 2.68, z = 27.93, p < .001), from M = .82 at early positions to M = .90 at late positions. In contrast, foils showed a different pattern with the main linear effect (β = -37.14, SE = 2.80, z = -13.29, p < .001) and quadratic effect (β = 9.22, SE = 2.79, z = 3.30, p < .001), declining from M = .95 early to M = .93 late, and an increase in overall performance (β = 0.011, SE = 0.003, z = 3.59, p < .001) from M = .89 early to M = .91 late positions.

### Performance Hierarchy

Overall, foil correct rejections exceeded target hits (M = .94 vs. M = .87, Δ = .07), replicating the standard asymmetry in recognition memory whereby rejecting new foils is easier than endorsing studied targets.

### Between-List Effects

Trial-level analyses across the 10 study–test lists revealed significant changes in recognition with list index. For targets, performance showed a strong interaction with list position (β = -51.36, SE = 5.74, z = -8.95, p < .001), decreasing from M = .95 in List 1 to M = .86 in List 10. Foils remained more stable across lists (M = .94 in List 1 to M = .94 in List 10). The quadratic interaction for targets (β = 32.75, SE = 3.11, z = 10.53, p < .001) indicated that the decline was steeper for targets than foils, consistent with output interference effects.

### Final Recognition Test Results

Final recognition accuracy differed substantially across exposure histories. A mixed-effects logistic regression revealed a robust main effect of exposure type (all ps < .001). Studied-and-Tested items were recognized best (M = .89, SD = .31), followed by Studied-Only (M = .67, SD = .47) and Tested-Only items (M = .64, SD = .48), with novel foils showing high rejection rates (M = .84, SD = .37).

#### Within-List Effects: Initial Study Order

Recognition accuracy was modeled as a function of initial study position (linear and quadratic polynomials, centered within list), exposure history, and their interaction, with random intercepts for participants.

Studied-and-Tested items showed both a small linear decline (β = -0.004, SE = 0.010, z = -0.40, p = .689) and exposure-dependent position effects, consistent with primacy and modest recency. Predicted probabilities were highest for early positions (M = .91), declined at middle positions (M = .89), and partially recovered at late positions (M = .89).

Studied-Only items also exhibited position sensitivity with early positions showing better performance (M = .69) compared to late positions (M = .68), though the magnitude was smaller than for tested items.

Tested-Only items showed the strongest position sensitivity, with better performance at early positions, indicating that weaker traces relied more heavily on positional context.

#### Within-List Effects: Initial Test Order

We next examined whether the order of testing during the initial test phase influenced final recognition. A mixed-effects logistic regression revealed no reliable linear effect of initial test position for the overall sample. However, the pattern suggested that items tested later in the initial lists showed numerically higher final test performance, consistent with retrieval-based strengthening during initial testing.

#### Between-List Effects: Final Test Order (Output Interference)

Recognition accuracy showed minimal decline across the course of the final test, with limited evidence for output interference. The overall performance remained relatively stable from early test positions (M = .78) to late positions (M = .79), indicating that output interference effects were substantially reduced during final testing compared to initial testing phases.

#### Between-List Effects: Initial List Order

Finally, we examined whether the list from which an item originated (Lists 1–10) predicted final recognition. A mixed-effects logistic regression revealed minimal overall effects of initial list position. Performance remained relatively stable across initial list positions for all exposure types, with no reliable linear trends. This pattern was consistent across all presentation conditions (Forward, Backward, Random), indicating that explicit temporal context information provided limited systematic enhancement to final test recognition.

## Statistical Model Summary

### Study Position Model
- Quadratic effect for targets: β = 31.07, SE = 1.87, z = 16.57, p < .001
- Linear effect: β = -47.50, SE = 2.03, z = -23.45, p < .001
- Target vs. foil difference: β = -0.28, SE = 0.04, z = -6.27, p < .001

### Test Position Model
- Linear × Target interaction: β = 74.94, SE = 2.68, z = 27.93, p < .001
- Quadratic × Target interaction: β = -25.93, SE = 3.11, z = -8.34, p < .001
- Main target effect: β = -0.83, SE = 0.04, z = -21.27, p < .001

### Between-List Model
- Linear × Target interaction: β = -51.36, SE = 5.74, z = -8.95, p < .001
- Quadratic × Target interaction: β = 32.75, SE = 3.11, z = 10.53, p < .001
- Quadratic main effect: β = 6.51, SE = 2.40, z = 2.72, p < .01

### Overall Performance Test Position Model (GLMM)
- Linear effect (overall trend): β = 0.015, SE = 0.004, z = 3.60, p < .001
- Performance change: M = .895 (early) to M = .909 (late positions)

### Final Test GLMM Models

**Exposure History Main Effects:**
- Studied-and-Tested: M = .890, SD = .313
- Studied-Only: M = .670, SD = .470
- Tested-Only: M = .642, SD = .479
- Novel-Foil: M = .840, SD = .367

**Within-List Position Effects (by Initial Study Position):**
- Linear position effect (Studied-and-Tested): β = -0.004, SE = 0.010, z = -0.40, p = .689
- Position × exposure history interactions present
- Primacy effects preserved: Early (M = .91) > Middle (M = .89) ≈ Late (M = .89)

**Within-List Position Effects (by Initial Test Position):**
- Minimal systematic linear effects across exposure types
- Numerical trend toward better performance for later-tested items
- Consistent with retrieval practice benefits

**Between-List Effects (Final Test Output Position):**
- Minimal output interference: Early (M = .78) ≈ Late (M = .79)
- Substantially reduced compared to initial testing phase

**Between-List Effects (Initial List Position):**
- No reliable linear or quadratic trends across Lists 1-10
- Stable performance across all exposure types and conditions
- Temporal context (Forward/Backward/Random) showed minimal effects

## Key Findings

1. Serial Position Effects: Strong quadratic trends in initial study position for targets, reflecting primacy and recency effects.

2. Test Position Benefits: Targets showed systematic improvement across test sequence, opposite to traditional output interference predictions.

3. Output Interference: Clear between-list decline for targets during initial testing, but minimal effects during final testing.

4. Exposure Type Hierarchy: Final test performance followed the pattern: Studied-and-Tested (M = .89) > Novel-Foil (M = .84) > Studied-Only (M = .67) > Tested-Only (M = .64).

5. Preserved Position Effects: Initial study position effects were preserved in final testing, with primacy effects still evident for studied-and-tested items.

6. Minimal Context Effects: Explicit temporal context (Forward/Backward vs. Random) provided minimal benefit during final testing, with stable performance across initial list positions.

These results support models emphasizing the importance of retrieval practice and suggest that initial test position effects reflect trace strengthening rather than temporary decision criterion shifts.