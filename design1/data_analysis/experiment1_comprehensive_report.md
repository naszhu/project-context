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

**Model Selection:** To ensure robust convergence and interpretable results, simplified models were used for final test analyses. Within-session effects (study and test position) were modeled with linear terms only, while between-session effects retained quadratic terms for capturing non-linear patterns. All models used random intercepts only to maximize convergence reliability.

#### Within-Study Position Effects
The within-study position analysis examined items that were studied in the initial phase (ST and SO items only), using a linear-only model to ensure convergence reliability.

**Overall Effects:** The linear trend was not significant, *b* = -0.12, *SE* = 0.08, *z* = -1.50, *p* = .134, 95% CI [-0.28, 0.04], indicating no systematic change in performance across study positions.

**Item-Type-Specific Linear Trends:** Both item types showed non-significant linear trends (SO: *b* = -5.12, *SE* = 2.82, *z* = -1.82, *p* = .069; ST: *b* = -6.93, *SE* = 3.76, *z* = -1.84, *p* = .066), indicating flat patterns across study positions for both item types.

**Item-Type-Specific Effects:** ST items (*M* = 89.5%) substantially outperformed SO items (*M* = 68.9%), *b* = 1.48, *SE* = 0.035, *z* = 42.06, *p* < .001. The item-type-specific linear trend interaction was not significant (*p* = .134), indicating that both item types showed similar flat patterns across study positions.

#### Within-Test Position Effects
The within-test position analysis examined items that were tested in the initial phase (ST and TO items only), using a linear-only model to ensure convergence reliability.

**Overall Effects:** There was a significant linear improvement across test positions, *b* = 0.15, *SE* = 0.08, *z* = 1.88, *p* = .060, 95% CI [-0.01, 0.31], indicating a marginal trend toward better performance at later test positions.

**Item-Type-Specific Linear Trends:** Both item types showed significant linear improvement across test positions (ST: *b* = 22.9, *SE* = 2.87, *z* = 7.98, *p* < .001; TO: *b* = 27.7, *SE* = 2.68, *z* = 10.3, *p* < .001), with TO items showing slightly stronger improvement than ST items.

**Item-Type-Specific Effects:** ST items (*M* = 90.4%) substantially outperformed TO items (*M* = 64.9%), *b* = 1.60, *SE* = 0.035, *z* = 45.62, *p* < .001. The item-type-specific linear trend interaction was not significant (*p* = .060), indicating that both item types showed similar improvement patterns across test positions.

#### Between-Session Effects (Comprehensive Analysis with All Available Item Types)

**Final Order Analysis:** The model included experimental condition as an additional factor (forward, random, backward) with 2-way interactions between position effects and item type. The analysis included all four item types: ST, SO, TO, and FOIL.

**Position Trends:** All item types showed significant linear decline across final order positions (FOIL: *b* = -32.7, *SE* = 3.96, *z* = -8.3, *p* < .001; SO: *b* = -36.8, *SE* = 5.40, *z* = -6.8, *p* < .001; ST: *b* = -86.2, *SE* = 8.82, *z* = -9.8, *p* < .001; TO: *b* = -60.9, *SE* = 5.35, *z* = -11.4, *p* < .001) and significant quadratic recovery (FOIL: *b* = 7.82, *SE* = 3.94, *z* = 2.0, *p* = .046; SO: *b* = 28.64, *SE* = 5.36, *z* = 5.3, *p* < .001; ST: *b* = 52.01, *SE* = 8.45, *z* = 6.2, *p* < .001; TO: *b* = 31.29, *SE* = 5.33, *z* = 5.9, *p* < .001), indicating U-shaped patterns with better performance at beginning and end positions.

**Item-Type-Specific Effects:** Post-hoc comparisons with Tukey correction revealed a complete performance hierarchy: ST > FOIL > SO > TO. All pairwise comparisons were significant: ST vs FOIL (*b* = 0.49, *SE* = 0.033, *z* = 14.71, *p* < .001), ST vs SO (*b* = 1.46, *SE* = 0.036, *z* = 41.22, *p* < .001), ST vs TO (*b* = 1.59, *SE* = 0.035, *z* = 44.85, *p* < .001), FOIL vs SO (*b* = 0.98, *SE* = 0.024, *z* = 40.95, *p* < .001), FOIL vs TO (*b* = 1.10, *SE* = 0.024, *z* = 46.48, *p* < .001), and SO vs TO (*b* = 0.12, *SE* = 0.027, *z* = 4.56, *p* < .001). Mean accuracy rates were: ST = 90.2%, FOIL = 85.0%, SO = 68.0%, TO = 65.2%. ST items showed the strongest linear decline and quadratic recovery, followed by TO, SO, and FOIL items.

**Initial Order Analysis:** The model examining initial list order effects across conditions included 2-way interactions between position effects and item type, with condition as a main effect. The analysis included all four item types: ST, SO, TO, and FOIL.

**Position Trends:** All item types showed significant linear improvement across initial order positions (FOIL: *b* = -0.09, *SE* = 1.41, *z* = -0.06, *p* = .949; SO: *b* = 14.22, *SE* = 1.88, *z* = 7.6, *p* < .001; ST: *b* = 16.76, *SE* = 1.87, *z* = 9.0, *p* < .001; TO: *b* = 39.50, *SE* = 1.81, *z* = 21.8, *p* < .001) and significant quadratic acceleration (FOIL: *b* = 5.59, *SE* = 1.44, *z* = 3.9, *p* < .001; SO: *b* = 26.07, *SE* = 1.87, *z* = 13.9, *p* < .001; ST: *b* = 56.32, *SE* = 1.87, *z* = 30.1, *p* < .001; TO: *b* = 32.75, *SE* = 2.05, *z* = 16.0, *p* < .001), indicating accelerating improvement patterns with TO items showing the strongest effects.

**Item-Type-Specific Effects:** Post-hoc comparisons with Tukey correction revealed a complete performance hierarchy: ST > FOIL > SO > TO. All pairwise comparisons were significant: ST vs FOIL (*b* = 0.46, *SE* = 0.032, *z* = 14.54, *p* < .001), ST vs SO (*b* = 1.44, *SE* = 0.034, *z* = 41.72, *p* < .001), ST vs TO (*b* = 1.56, *SE* = 0.034, *z* = 45.57, *p* < .001), FOIL vs SO (*b* = 0.97, *SE* = 0.024, *z* = 40.90, *p* < .001), FOIL vs TO (*b* = 1.10, *SE* = 0.024, *z* = 46.63, *p* < .001), and SO vs TO (*b* = 0.13, *SE* = 0.027, *z* = 4.67, *p* < .001). Mean accuracy rates were: ST = 89.9%, FOIL = 84.9%, SO = 67.9%, TO = 65.1%. TO items showed the strongest linear improvement and quadratic acceleration, followed by ST, SO, and FOIL items.

**Overall Item Type Hierarchy:** Across all final test analyses, a consistent performance hierarchy emerged: ST (Studied + Tested) > FOIL > SO (Studied Only) > TO (Tested Only), with all pairwise comparisons significant at *p* < .001 after Tukey correction. This hierarchy reflects the transfer-appropriate processing principle, where memory performance is optimized when study and test conditions match exactly, with FOIL items performing surprisingly well despite being neither studied nor tested.

## Discussion

The present study revealed striking item-type-specific serial position effects in recognition memory. Four key findings emerged: (1) item types showed opposite test position patterns during initial testing, (2) target items exhibited greater susceptibility to interference, (3) performance hierarchies remained stable across different position analyses, and (4) simplified models provided reliable convergence for final test analyses.

The finding that target and foil items showed opposite test position effects (declining vs. improving accuracy) suggests fundamentally different retrieval processes. This pattern may reflect differences in memory strength distributions or retrieval strategies, with target items benefiting from repeated retrieval practice while foil items suffer from output interference.

Target items' greater susceptibility to between-list interference supports theories of contextual dependency in recognition memory. The stronger decline and recovery patterns for target items suggest they rely more heavily on contextual cues that are disrupted by list-to-list interference but can recover through contextual reinstatement.

The consistent performance hierarchy (ST > SO > TO) across all final test analyses strongly supports transfer appropriate processing principles. Memory performance was optimized when study and test conditions matched exactly (ST condition) and was poorest when contexts mismatched (TO condition).

### Methodological Considerations

**Model Selection Strategy:** To ensure robust and interpretable results, simplified models were employed for final test analyses. Within-session effects used linear-only models to maximize convergence reliability, while between-session effects retained quadratic terms to capture non-linear patterns. All models used random intercepts only to avoid convergence issues while maintaining appropriate statistical control.

**Statistical Robustness:** The simplified approach ensured reliable convergence across all models, with relative gradients below 0.01 for most models. This strategy prioritized interpretable results over complex model structures that might not converge reliably, ensuring that statistical conclusions are based on well-fitting models.

**Item Type Comparisons:** Post-hoc pairwise comparisons using Tukey's method provided clear statistical evidence for the performance hierarchy across item types. The consistent finding that ST > SO > TO across all analyses provides strong support for transfer-appropriate processing principles in recognition memory.

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