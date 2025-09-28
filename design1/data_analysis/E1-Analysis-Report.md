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

A separate model tested the influence of test order (centered) on recognition accuracy. Results revealed diverging linear trends for targets and foils. Targets improved across the test sequence (linear interaction: β = 74.94, SE = 2.68, z = 27.93, p < .001), from M = .82 at early positions to M = .90 at late positions. In contrast, foils showed a different pattern with the main linear effect (β = -37.14, SE = 2.80, z = -13.29, p < .001) and quadratic effect (β = 9.22, SE = 2.79, z = 3.30, p < .001), declining from M = .95 early to M = .93 late.

### Performance Hierarchy

Overall, foil correct rejections exceeded target hits (M = .94 vs. M = .87, Δ = .07), replicating the standard asymmetry in recognition memory whereby rejecting new foils is easier than endorsing studied targets.

### Between-List Effects

Trial-level analyses across the 10 study–test lists revealed significant changes in recognition with list index. For targets, performance showed a strong interaction with list position (β = -51.36, SE = 5.74, z = -8.95, p < .001), decreasing from M = .95 in List 1 to M = .86 in List 10. Foils remained more stable across lists (M = .94 in List 1 to M = .94 in List 10). The quadratic interaction for targets (β = 32.75, SE = 3.11, z = 10.53, p < .001) indicated that the decline was steeper for targets than foils, consistent with output interference effects.

### Final Recognition Test Performance

#### Within-List Final Test Results

Study Position Effects: Final recognition accuracy was analyzed as a function of initial study position and exposure history (Studied-and-Tested, Studied-Only, Tested-Only). Final test performance by exposure type showed clear hierarchical differences: Studied-and-Tested items (M = .89, SD = .31) performed best, followed by Studied-Only items (M = .67, SD = .47) and Tested-Only items (M = .64, SD = .48). For Studied-and-Tested items, recognition remained relatively stable across initial study positions, suggesting that initial study position effects observed during initial testing were not primarily due to changes in trace strength but rather to retrieval dynamics during the initial test.

Test Position Effects: Test position effects from the initial test strongly predicted final test performance, suggesting initial test position effects were due to trace strength differences. The substantial performance difference between Studied-and-Tested items and other exposure types (Δ = .22-.25) indicates that the combination of initial study and test strengthened memory traces considerably.

#### Between-List Final Test Results

Final Test Order: Output interference effects during final testing were minimal across all conditions. Performance differences between presentation conditions were small and non-significant: Forward condition (M = .79), Backward condition (M = .79), and Random condition (M = .78). These minimal effects indicate that temporal context information provided limited enhancement to recognition performance during final testing.

Initial List Position: When final test performance was analyzed by initial list position, minimal serial position effects were observed across all presentation conditions. The Random condition showed relatively stable performance across list positions (early lists M = .74, middle lists M = .71, recent lists M = .75). The Forward and Backward conditions similarly showed minimal list position effects, suggesting that explicit knowledge of list order provided limited benefit during final testing.

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

## Key Findings

1. Serial Position Effects: Strong quadratic trends in initial study position for targets, reflecting primacy and recency effects.

2. Test Position Benefits: Targets showed systematic improvement across test sequence, opposite to traditional output interference predictions.

3. Output Interference: Clear between-list decline for targets during initial testing, but minimal effects during final testing.

4. Exposure Type Hierarchy: Final test performance followed the pattern: Studied-and-Tested > Studied-Only > Tested-Only.

5. Minimal Context Effects: Explicit temporal context (Forward/Backward vs. Random) provided minimal benefit during final testing.

These results support models emphasizing the importance of retrieval practice and suggest that initial test position effects reflect trace strengthening rather than temporary decision criterion shifts.