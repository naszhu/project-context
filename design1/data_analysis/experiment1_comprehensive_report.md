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

Models were fitted using maximum likelihood estimation in R using the lme4 package. Significance was evaluated at α = .05. Item-type-specific trends were extracted using estimated marginal means with the emmeans package.

## Results

### Initial Test Phase

#### Study Position Effects
The study position analysis revealed significant item type differences in serial position sensitivity. The model included study position (linear and quadratic) × item type interactions, *F*(2, 36429) = 145.32, *p* < .001.

For target items, there was a significant quadratic trend, *b* = 38.21, *SE* = 2.31, *z* = 16.56, *p* < .001, 95% CI [33.69, 42.73], indicating a U-shaped pattern with better performance at beginning and end positions compared to middle positions. Target items also showed significantly lower overall accuracy (*M* = 92.7%) compared to foil items (*M* = 94.5%), *b* = -0.29, *SE* = 0.058, *z* = -4.91, *p* < .001, 95% CI [-0.40, -0.17].

#### Test Position Effects
Test position effects differed dramatically by item type, with significant linear and quadratic interactions (both *p*s < .001). Foil items showed declining accuracy across test positions, *b* = -37.10, *SE* = 3.52, *z* = -10.55, *p* < .001, 95% CI [-43.99, -30.21], with a modest U-shaped recovery, *b* = 9.34, *SE* = 3.05, *z* = 3.06, *p* = .002, 95% CI [3.36, 15.32].

In contrast, target items showed improving accuracy across test positions, *b* = 37.85, *SE* = 3.57, *z* = 10.60, *p* < .001, 95% CI [30.86, 44.84], with an inverted U-shaped pattern, *b* = -16.59, *SE* = 3.47, *z* = -4.78, *p* < .001, 95% CI [-23.39, -9.80]. Overall, target items (*M* = 84.3%) performed worse than foil items (*M* = 95.6%).

#### Between-List Effects
Between-list effects revealed differential interference susceptibility by item type. Target items showed a strong linear decline across lists, *b* = -56.30, *SE* = 4.47, *z* = -12.59, *p* < .001, 95% CI [-65.07, -47.53], while foil items showed no significant linear trend, *b* = -4.21, *SE* = 3.59, *z* = -1.17, *p* = .241, 95% CI [-11.25, 2.83].

Both item types showed quadratic recovery patterns, but target items exhibited a stronger U-shaped recovery, *b* = 42.79, *SE* = 3.27, *z* = 13.09, *p* < .001, 95% CI [36.38, 49.19], compared to foil items, *b* = 10.36, *SE* = 2.82, *z* = 3.67, *p* < .001, 95% CI [4.83, 15.89].

### Final Test Phase

#### Within-Study Position Effects
Within-study position effects in the final test showed minimal linear trends for both same-object (SO) and same-target (ST) items (both *p*s > .17). However, both item types exhibited significant quadratic trends indicating U-shaped performance patterns: SO items, *b* = 10.51, *SE* = 2.56, *z* = 4.11, *p* < .001, 95% CI [5.50, 15.53]; ST items, *b* = 9.42, *SE* = 3.49, *z* = 2.70, *p* = .007, 95% CI [2.58, 16.26].

ST items (*M* = 89.8%) substantially outperformed SO items (*M* = 69.0%), *b* = 1.49, *SE* = 0.035, *z* = 42.10, *p* < .001.

#### Within-Test Position Effects
Within-test position effects revealed improving accuracy for both ST and target-object (TO) items. ST items showed a linear improvement, *b* = 22.55, *SE* = 3.48, *z* = 6.47, *p* < .001, 95% CI [15.72, 29.38], with an inverted U-shaped pattern, *b* = -9.45, *SE* = 4.07, *z* = -2.32, *p* = .020, 95% CI [-17.44, -1.47].

TO items showed a similar but stronger linear improvement, *b* = 27.03, *SE* = 3.08, *z* = 8.78, *p* < .001, 95% CI [21.00, 33.06], with a more pronounced inverted U-shape, *b* = -13.94, *SE* = 2.88, *z* = -4.85, *p* < .001, 95% CI [-19.58, -8.31]. ST items (*M* = 90.4%) substantially outperformed TO items (*M* = 64.9%).

#### Between-Session Effects

**Final Order Analysis:** Both ST and TO items showed declining performance across final test positions with U-shaped recovery patterns. ST items exhibited a steeper decline, *b* = -52.41, *SE* = 3.02, *z* = -17.33, *p* < .001, 95% CI [-58.34, -46.49], and stronger recovery, *b* = 33.18, *SE* = 3.01, *z* = 11.03, *p* < .001, 95% CI [27.29, 39.08], compared to TO items (linear: *b* = -38.06, *SE* = 3.37; quadratic: *b* = 19.72, *SE* = 2.83, both *p*s < .001).

**Initial Order Analysis:** Analysis by initial list order revealed improving performance patterns. SO items showed a linear improvement, *b* = 10.81, *SE* = 3.63, *z* = 2.98, *p* = .003, 95% CI [3.69, 17.92], with accelerating benefits, *b* = 18.37, *SE* = 2.56, *z* = 7.17, *p* < .001, 95% CI [13.35, 23.39]. ST items showed similar but stronger effects (linear: *b* = 14.35, *SE* = 4.47; quadratic: *b* = 38.43, *SE* = 4.33, both *p*s < .005).

## Discussion

The present study revealed striking item-type-specific serial position effects in recognition memory. Three key findings emerged: (1) item types showed opposite test position patterns during initial testing, (2) target items exhibited greater susceptibility to interference, and (3) performance hierarchies remained stable across different position analyses.

The finding that target and foil items showed opposite test position effects (declining vs. improving accuracy) suggests fundamentally different retrieval processes. This pattern may reflect differences in memory strength distributions or retrieval strategies, with target items benefiting from repeated retrieval practice while foil items suffer from output interference.

Target items' greater susceptibility to between-list interference supports theories of contextual dependency in recognition memory. The stronger decline and recovery patterns for target items suggest they rely more heavily on contextual cues that are disrupted by list-to-list interference but can recover through contextual reinstatement.

The consistent performance hierarchy (ST > SO > TO) across all final test analyses strongly supports transfer appropriate processing principles. Memory performance was optimized when study and test conditions matched exactly (ST condition) and was poorest when contexts mismatched (TO condition).

These findings have important implications for understanding the mechanisms underlying recognition memory and highlight the necessity of considering item type when interpreting serial position effects in memory experiments.

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