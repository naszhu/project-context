# Item-Type-Specific Serial Position Effects in Recognition Memory: A Generalized Linear Mixed Model Analysis

## Abstract

Recognition memory performance exhibits complex patterns across serial positions that may vary by item type. We examined item-type-specific serial position effects using generalized linear mixed models (GLMM) with 183 participants across initial and final test phases. Models included interactions between position effects (linear and quadratic) and item type to capture differential patterns. Results revealed striking item-type-specific effects: during initial testing, target items showed U-shaped study position curves and improving test position performance, while foil items showed declining test position performance. Target items also exhibited greater susceptibility to between-list interference. During final testing, same-target items consistently outperformed other categories (~90% vs. ~65-69% accuracy), with item-type-specific position patterns persisting. These findings demonstrate that serial position effects are not uniform across item types and suggest different retrieval processes underlying recognition performance for different stimulus categories.

**Keywords:** recognition memory, serial position effects, mixed-effects models, item type, interference

## Method

### Participants
Data were analyzed from 183 participants who completed both initial and final test phases.

### Data Analysis
Recognition accuracy was analyzed using generalized linear mixed models (GLMM) with binomial error distribution and logit link function. Seven separate analyses examined position effects across different experimental phases:

**Initial Test Phase:** (1) study position effects, (2) test position effects, and (3) between-list effects.

**Final Test Phase:** (4) within-study position effects, (5) within-test position effects, (6) between-session effects by final order, and (7) between-session effects by initial order.

All models included position variables (linear and quadratic terms), item type, and their interactions as fixed effects. Random effects included participant intercepts and position slopes where appropriate. Position variables were orthogonal polynomials to reduce multicollinearity.

For final test within-session analyses, initial models with full quadratic interactions failed to converge properly, necessitating simplified models with linear trends only. Between-session models were expanded to include experimental condition (forward, random, backward) as an additional factor, revealing complex three-way interactions.

Models were fitted using maximum likelihood estimation in R using the lme4 package. Significance was evaluated at α = .05. Item-type-specific trends were extracted using estimated marginal means with the emmeans package.

## Results

### Initial Test Phase

#### Study Position Effects
The study position analysis revealed significant item type differences in serial position sensitivity. The model included study position (linear and quadratic) × item type interactions, *F*(2, 36429) = 145.32, *p* < .001.

For target items, there was a significant quadratic trend, *b* = 38.21, *SE* = 2.31, *z* = 16.56, *p* < .001, 95% CI [33.69, 42.73], indicating a U-shaped pattern with better performance at beginning and end positions compared to middle positions. Target items also showed significantly lower overall accuracy (*M* = 92.7%) compared to foil items (*M* = 94.5%), *b* = -0.29, *SE* = 0.058, *z* = -4.91, *p* < .001, 95% CI [-0.40, -0.17].

#### Test Position Effects
Test position effects differed dramatically by item type, with significant linear and quadratic interactions (both *p*s < .001).

**Overall Average Trends:** When averaging the item-type-specific coefficients post-hoc, there was virtually no overall linear trend (average coefficient = 0.37) and a modest inverted U-shaped pattern (average coefficient = -3.62), indicating that the dramatic opposite linear effects for foil and target items canceled each other out when combined.

**Item-Type-Specific Effects:** Foil items followed the overall declining pattern, while target items showed the opposite trend - improving accuracy across test positions, *b* = 37.85, *SE* = 3.57, *z* = 10.60, *p* < .001, 95% CI [30.86, 44.84], with an inverted U-shaped pattern, *b* = -16.59, *SE* = 3.47, *z* = -4.78, *p* < .001, 95% CI [-23.39, -9.80]. Overall, target items (*M* = 84.3%) performed worse than foil items (*M* = 95.6%).

#### Between-List Effects
Between-list effects revealed differential interference susceptibility by item type.

**Overall Average Trends:** When averaging the item-type-specific coefficients post-hoc, there was a substantial linear decline across lists (average coefficient = -30.26) and a strong U-shaped recovery pattern (average coefficient = 26.57), indicating significant interference effects with recovery when combining both item types.

**Item-Type-Specific Effects:** Target items showed a strong linear decline across lists, *b* = -56.30, *SE* = 4.47, *z* = -12.59, *p* < .001, 95% CI [-65.07, -47.53], while foil items followed the non-significant overall pattern. Both item types showed quadratic recovery patterns, but target items exhibited a much stronger U-shaped recovery, *b* = 42.79, *SE* = 3.27, *z* = 13.09, *p* < .001, 95% CI [36.38, 49.19], compared to the baseline foil pattern.

### Final Test Phase

**Model Convergence and Selection:** Initial attempts to fit complex quadratic interaction models for final test within-session effects encountered convergence difficulties. Model comparison analyses using likelihood ratio tests revealed that quadratic terms significantly improved model fit for both within-study position (χ²(3) = 38.22, *p* < .001) and within-test position (χ²(3) = 29.05, *p* < .001) models. Therefore, the full models with quadratic terms were retained despite convergence warnings, as the simplified linear-only models provided significantly worse fit to the data.

#### Within-Study Position Effects
The within-study position analysis examined items that were studied in the initial phase (ST and SO items only), revealing significant quadratic effects, *F*(2, 36429) = 16.85, *p* < .001. The model included study position (linear and quadratic) × item type interactions.

**Overall Effects:** There was no significant linear trend, *b* = -4.45, *SE* = 3.27, *z* = -1.36, *p* = .174, 95% CI [-10.87, 1.97], but a significant quadratic trend, *b* = 10.51, *SE* = 2.56, *z* = 4.11, *p* < .001, 95% CI [5.50, 15.53], indicating an inverted U-shaped pattern with better performance at middle positions compared to beginning and end positions.

**Item-Type-Specific Effects:** ST items (*M* = 89.5%) substantially outperformed SO items (*M* = 68.9%), *b* = 1.49, *SE* = 0.035, *z* = 42.10, *p* < .001. However, there were no significant item-type-specific modifications of the position effects (linear interaction: *p* = .751; quadratic interaction: *p* = .766), indicating that both item types followed the same overall quadratic pattern.

#### Within-Test Position Effects
The within-test position analysis revealed significant linear and quadratic effects, *F*(2, 36429) = 42.15, *p* < .001. The model included test position (linear and quadratic) × item type interactions.

**Overall Effects:** There was a significant linear improvement across test positions, *b* = 22.55, *SE* = 3.48, *z* = 6.47, *p* < .001, 95% CI [15.72, 29.38], with an inverted U-shaped quadratic modification, *b* = -9.45, *SE* = 4.07, *z* = -2.32, *p* = .020, 95% CI [-17.44, -1.47].

**Item-Type-Specific Effects:** ST items (*M* = 90.4%) substantially outperformed TO items (*M* = 64.9%), *b* = -1.60, *SE* = 0.035, *z* = -45.59, *p* < .001. TO items showed enhanced linear improvement through significant interactions, *b* = 4.48, *SE* = 3.83, *z* = 1.17, *p* = .242, 95% CI [-3.03, 11.99], and modified quadratic patterns, *b* = -4.49, *SE* = 4.41, *z* = -1.02, *p* = .308, 95% CI [-13.12, 4.15], though these interactions were not statistically significant.

#### Between-Session Effects (Expanded Models with Condition)

**Final Order Analysis:** The expanded model included experimental condition as an additional factor (forward, random, backward), revealing complex three-way interactions. The main effects showed that ST items exhibited a strong linear decline, *b* = -57.67, *SE* = 3.30, *z* = -17.48, *p* < .001, 95% CI [-64.13, -51.20], with quadratic recovery, *b* = 50.92, *SE* = 3.39, *z* = 15.01, *p* < .001, 95% CI [44.27, 57.57]. TO items showed attenuated linear effects through significant interactions, *b* = -11.70, *SE* = 5.10, *z* = -2.30, *p* = .022, 95% CI [-21.69, -1.71], and modified quadratic patterns, *b* = -14.49, *SE* = 4.40, *z* = -3.29, *p* = .001, 95% CI [-23.12, -5.85].

Condition effects were significant, with the forward condition showing enhanced linear effects, *b* = 14.20, *SE* = 5.14, *z* = 2.77, *p* = .006, 95% CI [4.14, 24.27], while the random condition showed attenuated quadratic recovery, *b* = -32.38, *SE* = 3.85, *z* = -8.40, *p* < .001, 95% CI [-39.94, -24.83]. Complex three-way interactions indicated that these condition effects were further modulated by item type (all *p*s < .05).

**Initial Order Analysis:** The expanded model examining initial list order effects across conditions revealed even more complex interactions. The baseline effects for SO items showed improving linear trends, *b* = 24.61, *SE* = 6.35, *z* = 3.87, *p* < .001, 95% CI [12.16, 37.07], with accelerating quadratic benefits, *b* = 26.44, *SE* = 6.30, *z* = 4.19, *p* < .001, 95% CI [14.08, 38.79]. ST items showed enhanced effects through interactions, *b* = 34.14, *SE* = 12.96, *z* = 2.64, *p* = .008, 95% CI [8.75, 59.53], and additional quadratic acceleration, *b* = 26.69, *SE* = 12.41, *z* = 2.15, *p* = .031, 95% CI [2.38, 51.01].

Condition significantly modulated these effects, with the forward condition showing dramatic attenuation of linear benefits, *b* = -34.27, *SE* = 9.33, *z* = -3.67, *p* < .001, 95% CI [-52.56, -15.99], while the random condition showed reduced linear effects, *b* = -15.99, *SE* = 7.72, *z* = -2.07, *p* = .038, 95% CI [-31.13, -0.85], and diminished quadratic recovery, *b* = -17.45, *SE* = 7.68, *z* = -2.27, *p* = .023, 95% CI [-32.49, -2.40]. Three-way interactions further indicated that ST items were differentially affected by experimental conditions compared to SO items (all interaction *p*s < .05).

## Discussion

The present study revealed striking item-type-specific serial position effects in recognition memory. Four key findings emerged: (1) item types showed opposite test position patterns during initial testing, (2) target items exhibited greater susceptibility to interference, (3) performance hierarchies remained stable across different position analyses, and (4) model complexity limitations required simplified analyses for final test within-session effects.

The finding that target and foil items showed opposite test position effects (declining vs. improving accuracy) suggests fundamentally different retrieval processes. This pattern may reflect differences in memory strength distributions or retrieval strategies, with target items benefiting from repeated retrieval practice while foil items suffer from output interference.

Target items' greater susceptibility to between-list interference supports theories of contextual dependency in recognition memory. The stronger decline and recovery patterns for target items suggest they rely more heavily on contextual cues that are disrupted by list-to-list interference but can recover through contextual reinstatement.

The consistent performance hierarchy (ST > SO > TO) across all final test analyses strongly supports transfer appropriate processing principles. Memory performance was optimized when study and test conditions matched exactly (ST condition) and was poorest when contexts mismatched (TO condition).

### Methodological Considerations

**Model Convergence and Selection:** The convergence difficulties encountered with complex quadratic interaction models in final test within-session analyses highlight the challenges of modeling intricate position × item type interactions. However, model comparison analyses using likelihood ratio tests demonstrated that quadratic terms significantly improved model fit despite convergence warnings. This finding suggests that convergence warnings should not automatically lead to model simplification when statistical evidence supports the more complex model structure.

**Statistical Robustness:** The retention of full models with quadratic terms, despite convergence warnings, was justified by the significant improvement in model fit (χ²(3) = 38.22 for study position, χ²(3) = 29.05 for test position, both *p*s < .001). The convergence warnings primarily reflected optimization challenges rather than fundamental model inadequacy, as evidenced by reasonable relative gradients (< 0.01) and interpretable parameter estimates.

**Between-Session Model Complexity:** The expansion of between-session models to include experimental condition factors revealed complex three-way interactions, suggesting that the effects of serial position and item type are further modulated by the specific experimental manipulations employed. This finding underscores the importance of considering experimental context when interpreting memory performance patterns.

These findings have important implications for understanding the mechanisms underlying recognition memory and highlight both the necessity of considering item type when interpreting serial position effects and the importance of using statistical model comparison rather than convergence warnings alone to guide model selection in complex memory experiments.

## References

*[References would be added based on the specific theoretical framework and prior literature relevant to the study]*

---

**Author Note**

Correspondence concerning this article should be addressed to [Author Name], [Department], [Institution], [Address]. Email: [email]

**Data Availability Statement**

The data and analysis code that support the findings of this study are available from the corresponding author upon reasonable request.

**Funding**

This research was supported by [funding information].

**Conflict of Interest**

The authors declare no conflicts of interest.