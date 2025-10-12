# Average Performance Across Test Positions: Initial Test Analysis

## Abstract

Two complementary statistical approaches were used to examine whether overall recognition performance varied systematically across test positions during the initial test phase. A conditional averaging approach using marginal means from an interaction model revealed no significant overall position effect (*b* = -2.61, *p* > .05), as opposite trends for foil and target items canceled each other out statistically. However, an unconditional approach that collapsed across item types revealed significant linear (*b* = 10.19, *p* < .001) and quadratic (*b* = -11.42, *p* < .001) position effects, with overall accuracy increasing from 88.3% to 90.2% across early to middle test positions. These findings demonstrate that while overall task performance improved across positions, this improvement masked divergent item-type-specific patterns: target recognition improved significantly (*b* = 35.74, *p* < .001), whereas foil rejection deteriorated (*b* = -40.96, *p* < .001).

---

## Method

### Data and Participants
Analyses examined 38,958 trials from the initial test phase (pretest_response) after excluding responses with reaction times less than 150 ms or greater than 3,500 ms. Each trial required participants to discriminate between previously studied target items and unstudied foil items.

### Analytic Approaches

Two complementary generalized linear mixed models (GLMMs) with binomial error distributions were fitted to test for position effects on accuracy.

#### Approach 1: Conditional Averaging (Interaction Model)
The first model included item type (foil vs. target) as a moderator of position effects:

*Accuracy* ~ (*TestPosition*<sub>lin</sub> + *TestPosition*<sub>quad</sub>) × *ItemType* + (1 | *Participant*) + (0 + *TestPosition*<sub>lin</sub> | *Participant*)

This model specification allowed for:
- Item-type-specific linear and quadratic trends
- Random intercepts for each participant
- Random slopes for the linear position trend

Marginal average trends across item types were extracted using the `emtrends` function with the specification `~ 1`, which computes model-estimated means on the logit scale after collapsing across item type categories.

#### Approach 2: Unconditional Averaging (Collapsed Model)
The second model treated all trials equivalently regardless of item type:

*Accuracy* ~ *TestPosition*<sub>lin</sub> + *TestPosition*<sub>quad</sub> + (1 | *Participant*)

This simplified specification estimated overall position effects without separating foil and target patterns.

### Statistical Analysis
Both models were estimated using restricted maximum likelihood with the BOBYQA optimizer implemented in the lme4 package (version 1.1-35.1) in R. Orthogonal polynomial contrasts (linear and quadratic) were computed for test position to minimize multicollinearity. Statistical significance was assessed using Wald *z*-tests with alpha set at .05.

---

## Results

### Descriptive Statistics
Mean accuracy increased from early to middle test positions before plateating: Position 1-5 (*M* = 0.883, *n* = 7,684), Position 5-9 (*M* = 0.900, *n* = 7,816), Position 9-12 (*M* = 0.902, *n* = 7,815), Position 12-16 (*M* = 0.898, *n* = 7,822), and Position 16-20 (*M* = 0.898, *n* = 7,821).

### Approach 1: Conditional Averaging Results

When examining marginal average trends from the interaction model, neither the linear (*b* = -2.61, *SE* = 2.48, 95% CI [-7.47, 2.25]) nor quadratic (*b* = -4.91, *SE* = 3.02, 95% CI [-10.84, 1.01]) position effects were statistically significant. This null finding emerged because foil and target items exhibited opposite position trends that canceled out when averaged on the logit scale.

Decomposition of the interaction revealed highly significant item-type-specific effects. For foil items, accuracy decreased significantly across test positions, *b* = -40.96, *SE* = 2.58, *z* = -15.87, *p* < .001, 95% CI [-46.02, -35.90]. In contrast, target recognition improved significantly across positions, *b* = 35.74, *SE* = 3.11, *z* = 11.50, *p* < .001, 95% CI [29.64, 41.83]. The difference between these trends was substantial, *b* = -76.70, *SE* = 2.84, *z* = -27.02, *p* < .001, indicating a robust interaction between test position and item type.

Both item types also exhibited significant quadratic trends. Foil rejection showed positive curvature, *b* = 9.05, *SE* = 3.52, *z* = 2.57, *p* = .010, 95% CI [2.15, 15.94], whereas target recognition showed negative curvature, *b* = -18.88, *SE* = 3.35, *z* = -5.64, *p* < .001, 95% CI [-25.43, -12.32]. The difference in quadratic trends was also significant, *b* = 27.92, *SE* = 3.26, *z* = 8.57, *p* < .001.

### Approach 2: Unconditional Averaging Results

When collapsing across item types, both position effects were highly significant. The linear trend was positive, *b* = 10.19, *SE* = 2.79, *z* = 3.66, *p* < .001, indicating overall improvement in accuracy across test positions. The quadratic trend was negative, *b* = -11.42, *SE* = 2.19, *z* = -5.22, *p* < .001, indicating an inverted U-shaped function with performance peaking around the middle positions and plateauing thereafter.

---

## Discussion

The present analysis revealed a critical distinction between conditional and unconditional averaging approaches when examining position effects on recognition memory performance. The unconditional approach demonstrated that overall accuracy improved significantly across test positions, increasing approximately 2 percentage points from early (88.3%) to middle positions (90.2%). This pattern followed an inverted U-shaped trajectory, with the quadratic component suggesting diminishing returns or plateau effects after midway through the test.

However, the conditional approach, which estimated marginal means after accounting for item-type-specific effects, yielded no significant overall position trend. This apparent contradiction arose because foil and target items exhibited opposing position effects that canceled when statistically averaged on the logit scale. Specifically, target recognition benefited substantially from increasing test position, whereas foil rejection deteriorated at a comparable rate.

### Theoretical Implications

The divergent position effects for foil and target items suggest distinct underlying mechanisms. The improvement in target recognition across positions may reflect practice effects, strengthened memory traces through repeated retrieval attempts, or increasing confidence in recognition decisions (Jacoby, 1991). Conversely, the deterioration in foil rejection could indicate increasing false alarm rates due to familiarity buildup (Roediger & McDermott, 1995) or criterion shifts favoring "old" responses as the test progresses (Stretch & Wixted, 1998).

These opposing trends align with signal detection theory predictions that test position may differentially affect memory strength (d') versus response bias (c) parameters (Macmillan & Creelman, 2005). Future research should decompose accuracy into signal detection components to determine whether position effects reflect changes in discriminability, response criterion, or both.

### Methodological Considerations

This analysis highlights the importance of testing for interactions before interpreting main effects. The unconditional averaging approach provided a valid description of overall performance changes across positions and would be appropriate when the research question concerns aggregate task performance. However, the conditional approach revealed theoretically meaningful patterns that would be obscured by simple collapsing across item types.

Researchers examining position effects in recognition memory paradigms should consider both approaches when foil and target items may be differentially affected by position. The interaction model provides greater sensitivity to detect opposing patterns, whereas the collapsed model offers a more straightforward characterization of overall performance trends.

### Limitations

Both models assumed linear and quadratic functional forms for position effects. While these polynomial terms captured the observed patterns adequately, alternative functional forms (e.g., logarithmic, exponential) were not tested. Additionally, the random effects structure was simplified to ensure model convergence; more complex random effects (e.g., random quadratic slopes, random item effects) might better characterize individual differences in position effects.

---

## Conclusion

Overall recognition accuracy improved significantly across test positions when collapsing across item types, exhibiting an inverted U-shaped trajectory. However, this aggregate pattern masked opposite item-type-specific effects: target recognition improved substantially, whereas foil rejection deteriorated at a comparable rate. These findings underscore the value of interaction models for detecting divergent patterns that may cancel out in aggregate analyses and suggest that test position affects memory strength and response bias differentially for studied and unstudied items.

---

## References

Jacoby, L. L. (1991). A process dissociation framework: Separating automatic from intentional uses of memory. *Journal of Memory and Language, 30*(5), 513-541. https://doi.org/10.1016/0749-596X(91)90025-F

Macmillan, N. A., & Creelman, C. D. (2005). *Detection theory: A user's guide* (2nd ed.). Lawrence Erlbaum Associates.

Roediger, H. L., III, & McDermott, K. B. (1995). Creating false memories: Remembering words not presented in lists. *Journal of Experimental Psychology: Learning, Memory, and Cognition, 21*(4), 803-814. https://doi.org/10.1037/0278-7393.21.4.803

Stretch, V., & Wixted, J. T. (1998). On the difference between strength-based and frequency-based mirror effects in recognition memory. *Journal of Experimental Psychology: Learning, Memory, and Cognition, 24*(6), 1379-1396. https://doi.org/10.1037/0278-7393.24.6.1379

---

## Author Note

Analysis conducted October 11, 2025. Complete analysis scripts and supplementary materials available at: `/home/lea/Insync/.../individual_analyses/`

Correspondence concerning this analysis should be addressed to [contact information].

---

## Tables and Figures

### Table 1
*Descriptive Statistics: Mean Accuracy by Test Position Range*

| Position Range | *M* | *SD* | *n* |
|---|---|---|---|
| 1-5 (Early) | 0.883 | — | 7,684 |
| 5-9 | 0.900 | — | 7,816 |
| 9-12 | 0.902 | — | 7,815 |
| 12-16 | 0.898 | — | 7,822 |
| 16-20 (Late) | 0.898 | — | 7,821 |

*Note.* Position ranges represent quintile bins of test position. Standard deviations not computed for aggregated means.

### Table 2
*Fixed Effects Estimates from Interaction Model (Approach 1)*

| Predictor | *b* | *SE* | 95% CI | *z* | *p* |
|---|---|---|---|---|---|
| Intercept (Foil) | 3.03 | 0.08 | [2.88, 3.19] | 38.44 | < .001 |
| Position<sub>lin</sub> | -40.96 | 2.58 | [-46.02, -35.90] | -15.87 | < .001 |
| Position<sub>quad</sub> | 9.05 | 3.52 | [2.15, 15.94] | 2.57 | .010 |
| Item Type (Target) | -0.89 | 0.04 | [-0.96, -0.82] | -24.18 | < .001 |
| Position<sub>lin</sub> × Item Type | 76.70 | 2.84 | [71.13, 82.26] | 27.02 | < .001 |
| Position<sub>quad</sub> × Item Type | -27.92 | 3.26 | [-34.31, -21.54] | -8.57 | < .001 |

*Note.* Position terms are orthogonal polynomial contrasts. Foil is the reference level for item type.

### Table 3
*Fixed Effects Estimates from Collapsed Model (Approach 2)*

| Predictor | *b* | *SE* | *z* | *p* |
|---|---|---|---|---|
| Intercept | 2.49 | 0.07 | 33.87 | < .001 |
| Position<sub>lin</sub> | 10.19 | 2.79 | 3.66 | < .001 |
| Position<sub>quad</sub> | -11.42 | 2.19 | -5.22 | < .001 |

*Note.* Model collapses across item types.
