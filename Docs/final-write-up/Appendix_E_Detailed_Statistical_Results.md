# Appendix E: Detailed Statistical Methods and Results

This appendix contains comprehensive statistical methods and complete statistical results for all analyses reported in the main text.

## Statistical Methods

### Overview of Analytic Approach

Recognition accuracy data were analyzed using a systematic approach that examined effects at multiple timescales and experimental phases. For each experiment, separate analyses were conducted for the initial test phase (study position effects, test position effects, and between-list effects) and the final test phase (within-list study position effects, within-list test position effects, and between-list effects by both initial presentation order and final test order). Each analysis tested specific theoretical questions regarding encoding, retrieval, and interference processes in recognition memory.

### Model Specification

Recognition accuracy was analyzed using generalized linear mixed-effects models (GLMMs) with a binomial error distribution and logit link function. All analyses were implemented in R (Version 4.3.1; R Core Team, 2024) using the lme4 package (Version 1.1-35.1; Bates et al., 2015). Models were fitted using the Broyden-Fletcher-Goldfarb-Shanno quasi-Newton optimization algorithm (BOBYQA; Powell, 2009). Statistical significance was evaluated at α = .05. Item-type-specific trends were estimated using the emmeans package (Version 1.8.9; Lenth, 2023), and 95% confidence intervals were computed using the Wald method.

The binomial family with logit link function was selected because the dependent variable (accuracy) was binary (correct vs. incorrect). The logit link function modeled the log-odds of a correct response as a linear combination of predictors:

logit(p) = log[p/(1 − p)] = β₀ + β₁X₁ + β₂X₂ + ... + random effects

where *p* represents the probability of a correct response and β coefficients represent fixed effects.

### Fixed Effects Structure

#### Position Effects

Position effects (study position, test position, or list number) were modeled using orthogonal polynomial contrasts to capture monotonic trends (linear terms) and curvilinear patterns (quadratic terms) across serial positions. Orthogonal polynomials were selected for three reasons: (a) they provide interpretable coefficients for linear and quadratic trends, (b) they are uncorrelated, permitting independent tests of each trend component, and (c) they are robust to unequal spacing of position values.

#### Item Type Effects

Fixed effects included position terms fully crossed with item type. Item type categories varied by analysis phase and experiment. In Experiment 1 initial tests, item types included targets (ST) and foils (TO). In Experiment 2 initial tests, item types included current-list targets (ST), current-list foils (TO), and three categories of confusing foils: targets from the prior list (ST(n)), studied-only items from the prior list (SO(n)), and foils from the prior list (TO(n)). In Experiment 1 final tests, item types included studied-tested items (ST), studied-only items (SO), tested-only items (TO), and final-test-only foils (FTO). In Experiment 2 final tests, item types included ST, SO, TO, and FTO, plus combined categories representing items appearing in multiple lists: STnST(n), SOnSO(n), and TOnTO(n).

#### Experiment 1 Final Test Order Analysis

For the final test order analysis in Experiment 1, an additional ordering-type factor was included to distinguish effects by final test position (the order in which items were tested during final testing) from effects by initial list position (the order in which lists were originally presented during the initial phase). In the forward condition, initial order equaled final order; in the backward condition, initial order was the mirror of final order (list 1 initial = list 10 final); in the random condition, initial and final orders were uncorrelated. This factorial design permitted examination of both output interference during final testing and effects of original list presentation order.

### Random Effects Structure

All models included random intercepts for participants to account for individual differences in overall performance. Following the principle of maximal random effects justified by design (Barr et al., 2013), random slopes for position effects were included when model convergence permitted.

#### Initial Test Analyses

For study position, test position, and between-list analyses, random slopes for linear position trends were successfully included. The random effects structure was specified as (1 | participant_id) + (0 + position_lin | participant_id), where the first term represents a random intercept and the second term represents an uncorrelated random slope for the linear position effect. Uncorrelated random effects were specified (indicated by "0 +" syntax) because they are more parsimonious and less prone to convergence issues, while still permitting individual differences in both baseline performance and position effects.

#### Final Test Analyses

For all final test analyses, models with random slopes failed to converge despite extended iterations (up to 500,000) and alternative optimizers, necessitating the use of random intercepts only: (1 | participant_id). This simplification was required due to the increased complexity of final test models, which included more item types and interaction terms. The final test combined order analysis in Experiment 1 (three conditions × two ordering types × four item types) was particularly complex and required random intercepts only.

#### Model Simplification Procedure

When models failed to converge, a systematic simplification procedure was followed: (a) remove correlations between random slopes, (b) remove random slopes for quadratic terms, (c) remove random slopes for linear terms, and (d) retain only random intercepts if necessary. All fixed effects were retained as specified by the experimental design and theoretical framework, regardless of random effects simplifications. This approach prioritized testing fixed effects of theoretical interest while maintaining the most complex random effects structure that permitted convergence.

### Experiment-Specific Design Considerations

#### Experiment 1

In Experiment 1, initial tests included 7–10 lists per participant (randomly assigned). Study positions ranged from 1–30 within each list, and test positions ranged from 1–20 within each list. Final test order varied by condition (forward, backward, or random). For the combined order analysis, both final test order and initial list order were modeled simultaneously, with ordering type included as a within-subject factor.

#### Experiment 2

In Experiment 2, initial tests included 10 lists per participant. Study positions ranged from 1–30 within each list, and test positions ranged from 1–30 within each list. Final test positions were binned into 10 temporal groups (bins 1–8: 49 items each; bins 9–10: 50 items each) to ensure sufficient observations per bin while maintaining temporal resolution. This binning procedure was necessary because the final test was exceptionally long (492 items), and modeling each position individually would have resulted in sparse data and convergence difficulties.

For certain Experiment 2 analyses, reference category selection required special consideration. Because final-test-only foils (FTO) had no list number variation, alternative reference categories were employed in some analyses. For between-list analyses, STnST(n) served as the reference category for slope comparisons in interaction terms, while FTO remained the intercept reference. This dual-reference approach permitted meaningful interpretation of both intercept differences (using FTO as baseline) and slope differences (using STnST(n) as baseline for list number effects).

### Convergence and Model Diagnostics

Model convergence was assessed using two standard criteria: (a) relative gradient < 0.001, indicating that the optimization algorithm reached a point where further iterations produced negligible improvements, and (b) positive definite Hessian matrix (matrix of second derivatives), indicating that the solution represented a local minimum rather than a saddle point.

Most models converged successfully, with relative gradients ranging from 0.0000047 to 0.0018. Two complex Experiment 1 models produced convergence warnings: the final test initial order analysis (relative gradient = 0.022) and the combined order analysis (relative gradient = 0.072). For models with convergence warnings, stability was verified by (a) testing alternative optimization settings (up to 500,000 iterations vs. default 10,000), (b) comparing results to simpler nested models to assess substantial differences, (c) employing alternative optimizers when available, and (d) examining whether parameter estimates and standard errors were in reasonable ranges.

Models with mild convergence warnings demonstrated stable parameter estimates across different optimization settings, and substantive conclusions were robust. All reported results represent the most complex models that could be successfully fitted given the design complexity.

### Post Hoc Analyses and Trend Estimation

Following model fitting, the emmeans package was used to (a) estimate marginal means (model-predicted accuracy for each item type, averaged over other factors), (b) estimate trends (linear and quadratic slopes for position effects, computed separately by item type), (c) compute contrasts (pairwise differences between item types or conditions), and (d) adjust for multiple comparisons when appropriate. For analyses involving multiple comparisons, unadjusted *p* values are reported, with notation when effects survived Bonferroni correction.

All confidence intervals were computed using the Wald method, calculated as the parameter estimate ± 1.96 × standard error.

---

## Detailed Statistical Results

Results are organized by experiment and analysis type. For each analysis, the following information is reported: (a) fixed effects estimates with coefficients, standard errors, *z* values, *p* values, and 95% confidence intervals; (b) estimated marginal means for each item type; (c) linear and quadratic trend estimates for position effects; and (d) interaction effects and contrasts where relevant.

## Experiment 1

### Initial Within-List Study Position Effects

**Linear Trends Across Study Positions.** Recognition accuracy for targets (TO) declined significantly across study positions, b = -12.73, SE = 3.27, z = -3.90, p < .001, 95% CI [-19.13, -6.33]. Items studied later in the list were remembered less accurately than items presented near the start.

**Quadratic Trends Across Study Positions.** A significant positive quadratic component emerged, b = 21.52, SE = 2.82, z = 7.62, p < .001, 95% CI [15.98, 27.05], indicating a curved serial-position function. Accuracy was highest for the earliest positions, declined most sharply through the middle of the list, and levelled off (or partially recovered) at the end—an inverted-U pattern characteristic of simultaneous primacy and recency influences.

### Initial Within-List Test Position Effects

**Overall Patterns by Test Position.** For TO pictures, a strong negative linear trend emerged, b = -40.96, SE = 2.58, z = -15.87, p < .001, 95% CI [-46.02, -35.90], indicating that correct rejection rates declined systematically and substantially across test positions. A modest positive quadratic trend also emerged for TO pictures, b = 9.05, SE = 3.52, z = 2.57, p = .010, 95% CI [2.15, 15.94], indicating a slight curvature superimposed on the linear decline.

**Picture Type Effects.** ST pictures showed substantially lower overall recognition accuracy than TO pictures, b = -0.89, SE = 0.04, z = -24.18, p < .001, 95% CI [-0.96, -0.82]. The estimated marginal means were 3.07 on the logit scale for foils (corresponding to approximately 95.6% accuracy) versus 2.24 for ST (approximately 90.4% accuracy), replicating the consistent finding that foil rejection is more accurate than target recognition.

**Two-way Interactions: Picture Type Modulation of Test Position Effects.** The Test Position × picture Type interaction showed sharply diverging patterns for ST and TO pictures. The linear interaction was large and positive, b = 76.70, SE = 2.84, z = 27.02, p < .001, 95% CI [71.13, 82.26], indicating opposite linear trends—foil rejection declined (b = -40.96) while target recognition increased (b = 35.74). The quadratic interaction was also significant and negative, b = -27.92, SE = 3.26, z = -8.57, p < .001, 95% CI [-34.31, -21.54], indicating opposite curvatures for ST and TO pictures, with relatively higher performance at early and late positions.

**Average Performance Across Test Positions.** To assess performance changes across test positions, we ran two analyses. Averaging across picture types on the logit scale showed no significant overall trends, linear: b = -2.61, SE = 2.48, 95% CI [-7.47, 2.25]; quadratic: b = -4.91, SE = 3.02, 95% CI [-10.84, 1.01]. These null effects reflected opposing picture-type trends (TO: b = -40.96; ST: b = 35.74).

When picture types were collapsed, overall accuracy rose from 88.3% (positions 1–5) to 90.2% (9–12) and plateaued near 89.8% (16–20). The model showed a positive linear trend, b = 10.19, SE = 2.79, z = 3.66, p < .001, and a negative quadratic trend, b = -11.42, SE = 2.19, z = -5.22, p < .001, indicating an inverted U-shaped pattern.

Thus, overall accuracy improved modestly (~2%), but this gain reflected opposing effects: ST improved while TO declined.

### Initial Between-List Effects

**Overall Patterns Across Lists.** For TO pictures, the linear trend was not significant, b = 0.54, SE = 2.61, z = 0.21, p = .835, 95% CI [-4.57, 5.66], indicating that correct rejection rates remained stable across lists with no systematic increase or decrease. A significant positive quadratic trend emerged (b = 11.38, SE = 2.29, z = 4.97, p < .001, 95% CI [6.89, 15.86]), indicating a reliable non-linear deviation across lists. Visual inspection (Figure 8) suggests that this deviation reflects a shallow mid-list dip rather than a pronounced inverted-U pattern. In other words, TO accuracy was relatively stable for early and late lists, with a modest reduction in the middle. The positive sign of the quadratic term could arise from orthogonal contrast coding and might not be interpreted as implying an upward (U-shaped) curvature in the raw data.

**Picture type effects.** ST pictures showed substantially lower overall recognition accuracy than TO pictures, b = -0.86, SE = 0.04, z = -23.30, p < .001, 95% CI [-0.93, -0.78]. Across all lists, TO pictures averaged 93.6% correct rejection (range: 92.2%–94.2%), while ST pictures averaged 86.2% correct recognition (range: 82.6%–94.2%), demonstrating considerably better foil rejection than target recognition.

**Two-way interactions: picture type modulation of list effects.** The strong negative interaction between List Number and picture Type, b = -55.06, SE = 2.50, z = -22.06, p < .001, 95% CI [-59.95, -50.17], shows that ST recognition significantly decreased from early to late lists (94.2% in list 1 to 82.6% in list 7), while TO recognition remained stable (92.2%–94.2% across lists).

The quadratic interaction, b = 32.66, SE = 2.38, z = 13.74, p < .001, 95% CI [28.00, 37.32], revealed a significant difference in the inverted U-shaped pattern between picture types. TO pictures showed a modest inverted U (b = 11.38), while ST exhibited a more pronounced curvilinear pattern (b = 44.04), indicating stronger primacy and recency effects for ST pictures.

### Final Within-List Study Position Effects

**Overall patterns by study position.** Across pictures, the linear trend for SO items was modest and did not reach significance, b = −5.56, SE = 3.02, z = −1.84, p = .065, 95% CI [−11.47, 0.35], indicating only a slight tendency for accuracy to dip at later study positions. A reliable positive quadratic component remained, b = 10.31, SE = 2.80, z = 3.68, p < .001, 95% CI [4.82, 15.80], reflecting the familiar primacy–recency bend.

**Picture type effects.** ST pictures showed much higher recognition accuracy than SO pictures, b = 1.43, SE = 0.03, z = 42.92, p < .001, 95% CI [1.37, 1.50]. This large difference indicates that items previously tested were remembered substantially better than those only studied, reflecting the additional exposure and retrieval opportunities for ST items. The estimated marginal means were 0.7641 logits (≈68.22% accuracy) for SO and 2.1979 logits (≈90.01% accuracy) for ST, underscoring a robust testing effect.

**Two-way interactions: picture type modulation of study position effects.** The Study Position Linear × picture Type interaction remained nonsignificant, b = −1.89, SE = 5.50, z = −0.34, p = .730, 95% CI [−12.67, 8.88], indicating similar linear trends for SO (b = −5.56) and ST (b = −7.46) items. Both declined similarly across study positions, suggesting no differential protection from retrieval practice.

### Final Within-List Test Position Effects

**Overall patterns by test position.** Across pictures, a strong positive linear trend persisted, b = 22.41, SE = 2.90, z = 7.73, p < .001, 95% CI [16.73, 28.10], indicating that recognition continued to improve for items tested later within the initial list. A negative quadratic component, b = −9.57, SE = 2.98, z = −3.21, p = .0013, 95% CI [−15.42, −3.73], captured the slowing of this improvement toward the end of the list.

**Picture type effects.** Only ST and TO pictures have initial test positions and are included in this analysis. TO pictures showed substantially lower recognition accuracy than ST pictures, b = -1.51, SE = 0.03, z = -45.70, p < .001, 95% CI [-1.58, -1.45], with observed means of 64.2% versus 88.2%. This large effect demonstrates that full initial exposure (study plus test) provides substantially greater benefit than partial exposure (test only).

**Two-way interactions: picture type modulation of test position effects.** The Linear × Picture Type interaction was nonsignificant, b = 4.43, SE = 3.71, z = 1.19, p = .233, 95% CI [−2.85, 11.71], indicating that TO pictures (slope = 26.84) and ST pictures (slope = 22.41) climbed at comparable rates. The quadratic interaction was also nonsignificant, b = −3.45, SE = 3.76, z = −0.92, p = .359, 95% CI [−10.82, 3.92], indicating that both picture types displayed similar curvature (ST quadratic = −9.57; TO quadratic = −13.03), with accuracy leveling off modestly in later test positions.

### Final Between-List Effects by Final Test Order and Initial List Order

**Item type effects.** Different item types showed substantially different overall recognition accuracy compared to FTO (the reference). ST items were markedly more accurate than FTO, b = 0.45, SE = 0.02, z = 18.04, p < .001, 95% CI [0.40, 0.50], with an estimated marginal mean of 2.08 logits (≈88.93% accuracy). In contrast, SO items (b = −0.95, SE = 0.02, z = −50.70, p < .001, 95% CI [−0.99, −0.91], marginal mean = 0.69 logits, ≈66.51%) and TO items (b = −1.07, SE = 0.02, z = −57.64, p < .001, 95% CI [−1.11, −1.03], marginal mean = 0.57 logits, ≈63.79%) performed worse than FTO (marginal mean = 1.64 logits, ≈83.69%).

**Condition effects.** Overall accuracy still did not differ by condition: backward vs. forward, b = 0.05, SE = 0.10, z = 0.52, p = .601, 95% CI [−0.14, 0.25]; random vs. forward, b = 0.03, SE = 0.09, z = 0.33, p = .739, 95% CI [−0.14, 0.19], confirming that presentation order modulated list-position patterns but not baseline performance.

**Ordering type effects.** The main effect of ordering type remained nonsignificant, b = −0.004, SE = 0.018, z = −0.25, p = .800, 95% CI [−0.04, 0.03], indicating no baseline accuracy difference between by final-test order and by initial-list order perspectives.

**Linear trends by list order.** For the forward condition with FTO items (reference), the linear trend was b = −38.08, SE = 6.94, z = −5.49, p < .001, 95% CI [−51.67, −24.49], indicating robust output interference. Backward testing produced a far steeper decline (interaction adds −37.51, yielding b ≈ −75.59), while the random condition's decline was intermediate (interaction adds −10.81, b ≈ −48.89). When list order was expressed by initial position, slopes reversed strongly (interaction b = 65.46, p < .001), underscoring the divergence between test order and original study order.

Final-test list order was modeled for all conditions (forward, backward, random), and initial list order entered as an additional factor in the same model. Because the forward and backward groups share perfectly correlated orders (identical or mirrored), the interaction involving list-order perspective primarily reflects the independent contrast available in the random condition, where initial and final orders are uncorrelated.

**Quadratic trends by list order.** The reference combination (FTO items in the forward condition, evaluated by final-test order) showed a reliable positive quadratic effect, b = 8.12, SE = 3.85, z = 2.11, p = .035, 95% CI [0.57, 15.67], indicating modest curvature in performance across positions.

**Two-way interactions: Linear × Condition.** Backward testing produced a much steeper decline than forward testing, b = −37.51, SE = 8.99, z = −4.17, p < .001, 95% CI [−55.14, −19.88], yielding a combined slope of approximately −75.59. The random condition showed a weaker (and nonsignificant) difference from forward testing, b = −10.81, SE = 7.70, z = −1.40, p = .161, giving a combined slope of roughly −48.89.

**Two-way interactions: Linear × Item Type.** Slopes differed sharply by item type. Relative to FTO items (slope = −38.08), ST pictures declined much more steeply, b = −31.76, SE = 9.10, z = −3.49, p < .001, 95% CI [−49.58, −13.93], for a combined slope near −69.83. TO items were somewhat steeper (b = −8.30, SE = 6.56, z = −1.27, p = .206; slope ≈ −46.38), whereas SO items declined more gently (b = 3.85, SE = 6.63, z = 0.58, p = .561; slope ≈ −34.23).

**Two-way interactions: Linear × List-Order Perspective.** Switching from final-test order to initial-list order produced a large positive shift in slope, b = 65.46, SE = 6.25, z = 10.48, p < .001, 95% CI [53.22, 77.71]. Because forward and backward sequences are fixed across perspectives, this shift mainly indexes the random condition: when arranged by final-test order, the random condition showed a pronounced negative slope (≈ −48.89), but by initial-list order it became substantially positive (≈ +16.57), indicating that later study lists yielded better final-test performance once the testing sequence was disentangled from study order.

**Two-way interactions: Quadratic × Item Type.** All item types displayed stronger positive curvature than FTO. SO items: b = 23.64, SE = 6.59, z = 3.59, p < .001, 95% CI [10.72, 36.55], combined quadratic ≈ 31.76. TO items: b = 29.59, SE = 6.54, z = 4.53, p < .001, 95% CI [16.78, 42.41], combined quadratic ≈ 37.71. ST items: b = 52.35, SE = 8.91, z = 5.87, p < .001, 95% CI [34.88, 69.82], combined quadratic ≈ 60.47. These effects signal that items with study or test exposure showed pronounced curvature relative to final-test-only foils.

## Experiment 2

### Initial Within-List Study Position Effects

**Picture type effects.** ST served as the reference category (intercept = 1.29 logit, SE = 0.05, z = 23.50, p < .001), corresponding to roughly 78% accuracy. SO(n) responses were 1.07 logits lower than targets (SE = 0.03, z = -31.87, p < .001, 95% CI [-1.14, -1.01]), yielding an estimated marginal mean of 0.22 logit (≈55% accuracy). ST(n) responses were 0.85 logits lower than targets (SE = 0.03, z = -25.18, p < .001, 95% CI [-0.92, -0.79]), with an estimated marginal mean of 0.44 logit (≈61% accuracy).

Accuracy was modeled as a function of study position (linear and quadratic orthogonal trends) and their interactions with item type. Random intercepts were included for participants. The model estimated how recognition performance at final test varied as a function of each item's serial position during study, separately for items that were both studied and tested (ST), studied-only but not tested (SO(n)), and tested-only without restudy (ST(n)).

**Item-Type Contrasts.** ST items served as the reference category (intercept = 1.29, SE = 0.05, 95% CI [1.18, 1.40]). Relative to ST items, SO(n) items showed markedly lower accuracy, b = –1.07, SE = 0.03, z = –31.87, p < .001, 95% CI [–1.14, –1.01], corresponding to about 55% accuracy. ST(n) items were also less accurate, b = –0.85, SE = 0.03, z = –25.18, p < .001, 95% CI [–0.92, –0.79], ≈ 61% accuracy.

**Linear Trends by Study Position.** A strong positive linear trend emerged for ST items, b = 13.82, SE = 2.32, 95% CI [9.28, 18.37], indicating that recognition accuracy increased across study positions. For SO(n) items, the linear trend was negative but nonsignificant, b = –5.33, SE = 3.79, 95% CI [–12.75, 2.09], suggesting little systematic change across positions.

ST(n) items showed a shallow, nonsignificant positive slope, b = 2.62, SE = 3.69, 95% CI [–4.60, 9.85].

**Quadratic Trends by Study Position.** A significant positive quadratic trend appeared for ST items, b = 24.73, SE = 2.12, 95% CI [20.60, 28.87], reflecting higher accuracy at later positions. SO(n) items showed a significant negative quadratic effect, b = –11.66, SE = 4.28, 95% CI [–20.10, –3.27], indicating poorer performance toward list ends.

ST(n) items exhibited a small, nonsignificant negative curvature, b = –5.16, SE = 3.42, 95% CI [–11.90, 1.55].

**Two-Way Interactions: Linear × Item Type** The study-position effect differed markedly by item type. Relative to ST items, SO(n) items showed a large negative interaction, b = –19.15, SE = 3.32, z = –5.78, p < .001, 95% CI [–25.65, –12.65], indicating a much shallower linear slope. ST(n) items also showed a significant negative interaction, b = –11.20, SE = 3.33, z = –3.36, p = .001, 95% CI [–17.73, –4.68], again reflecting a weaker increase across positions compared with ST items.

**Two-Way Interactions: Quadratic × Item Type.** Quadratic trends also varied significantly across item types. SO(n) items showed a large negative quadratic interaction, b = –36.39, SE = 4.51, z = –8.06, p < .001, 95% CI [–45.23, –27.55], demonstrating reduced curvature relative to ST items. ST(n) items likewise showed a strong negative quadratic interaction, b = –29.89, SE = 3.26, z = –9.17, p < .001, 95% CI [–36.27, –23.52].

### Initial Within-List Test Position Effects

**Picture type effects.** Different picture types showed substantially different overall recognition accuracy. TO pictures showed the highest accuracy, b = 0.77, SE = 0.04, z = 19.66, p < .001, 95% CI [0.69, 0.85], with an estimated marginal mean of 1.51 logit (approximately 82.0% accuracy). ST pictures also showed high accuracy, b = 0.58, SE = 0.03, z = 16.48, p < .001, 95% CI [0.51, 0.65], with a marginal mean of 1.32 logit (approximately 78.9% accuracy). In contrast, STnST(n) showed lower accuracy, b = -0.29, SE = 0.04, z = -6.63, p < .001, 95% CI [-0.38, -0.21], with a marginal mean of 0.45 logit (approximately 61.1% accuracy). SOnSO(n) showed the lowest accuracy, b = -0.52, SE = 0.04, z = -11.71, p < .001, 95% CI [-0.60, -0.43], with a marginal mean of 0.23 logit (approximately 55.7% accuracy). The reference category TO(n) had an estimated marginal mean of 0.74 logit (approximately 67.8% accuracy).

**Linear trends across test positions.** For the reference category TO(n), the linear trend was not significant, b = -8.23, SE = 7.45, z = -1.10, p = .269, 95% CI [-22.84, 6.38], suggesting minimal systematic change across test positions.

**Quadratic trends across test positions.** The quadratic trend was also not significant, b = 2.75, SE = 7.41, z = 0.37, p = .711, 95% CI [-11.77, 17.27], indicating no reliable curvilinear pattern.

**Two-way interactions: Linear × Picture Type.** Test position slopes varied dramatically by picture type. ST pictures showed a large positive interaction, b = 33.07, SE = 8.20, z = 4.03, p < .001, 95% CI [17.00, 49.14], yielding a combined positive slope of 24.84, indicating that target recognition improved as testing progressed. SO(n) showed a large negative interaction, b = -50.92, SE = 10.37, z = -4.91, p < .001, 95% CI [-71.25, -30.59], yielding a combined steep negative slope of -59.15, indicating severe output interference for these confusing foils. TO showed a moderate negative interaction, b = -16.95, SE = 9.22, z = -1.84, p = .066, 95% CI [-35.02, 1.13], yielding a combined slope of -25.18. ST(n) showed a nonsignificant negative interaction, b = -11.44, SE = 10.42, z = -1.10, p = .272, 95% CI [-31.86, 8.98].

**Two-way interactions: Quadratic × Picture Type.** ST pictures showed a strong negative quadratic interaction, b = -33.14, SE = 8.17, z = -4.06, p < .001, 95% CI [-49.16, -17.13], yielding a combined quadratic of -30.40, indicating a U-shaped pattern. Other quadratic interactions were nonsignificant: ST(n): b = 12.61, p = .223; SO(n): b = 9.97, p = .336; TO: b = -1.75, p = .849.

### Initial Between-List Effects

**Picture type effects.** Item types differed sharply in overall accuracy relative to confusing foils that were foils on the prior list (TO(n), intercept: b = 0.69, SE = 0.07, z = 10.22, p < .001, 95% CI [0.55, 0.82], ≈66.5% CRs). Regular new foils (TO) were far easier to reject (b = 0.82, SE = 0.04, z = 20.62, p < .001, 95% CI [0.74, 0.89]), yielding an estimated marginal mean of 1.50 logits (≈81.8% CRs). Current-list targets (ST) were also recognized well (b = 0.65, SE = 0.04, z = 18.31, p < .001, 95% CI [0.58, 0.71]; 1.33 logits, ≈79.1% hits). ST(n) showed depressed accuracy (b = –0.33, SE = 0.04, z = –7.39, p < .001, 95% CI [–0.42, –0.24]; 0.36 logits, ≈58.9%). SO(n) produced the lowest accuracy (b = –0.52, SE = 0.04, z = –11.75, p < .001, 95% CI [–0.61, –0.43]; 0.17 logits, ≈54.1%).

**Linear trends across lists.** For TO(n) foils, accuracy improved markedly across successive lists (b = 71.16, SE = 2.80, z = 25.37, p < .001, 95% CI [65.67, 76.66]), indicating that participants rapidly adapted to the prevalence of confusing foils. Trends diverged by item type. ST(n) climbed even more steeply (interaction: b = 24.76, SE = 2.19, z = 11.30, p < .001, 95% CI [20.46, 29.05]; combined slope ≈95.92), whereas SO(n) rose somewhat less (interaction: b = –5.71, SE = 2.02, z = –2.83, p = .005, 95% CI [–9.66, –1.75]; combined slope ≈65.46). In contrast, current-list items declined: TO new foils showed a large negative shift (interaction: b = –79.95, SE = 2.12, z = –37.72, p < .001, 95% CI [–84.11, –75.80]; combined slope ≈ –8.79), and ST targets dropped sharply (interaction: b = –124.75, SE = 2.02, z = –61.86, p < .001, 95% CI [–128.70, –120.80]; combined slope ≈ –53.59). These patterns reflect simultaneous gains in rejecting confusing foils and growing output interference for current-list items.

**Quadratic trends across lists.** Accuracy for TO(n) foils showed a reliable downward bend across later lists (b = –17.97, SE = 1.70, z = –10.56, p < .001, 95% CI [–21.30, –14.63]). ST(n) amplified this curvature (interaction: b = –22.55, SE = 2.82, z = –7.997, p < .001, 95% CI [–28.08, –17.03]; combined quadratic ≈ –40.52), whereas SO(n) tracked the same curvature (interaction: ns). Current-list items bent in the opposite direction: TO foils showed a modest positive quadratic (interaction: b = 21.23, SE = 2.25, z = 9.42, p < .001, 95% CI [16.81, 25.65]; combined ≈ 3.26), and ST targets displayed a pronounced positive bend (interaction: b = 47.64, SE = 2.20, z = 21.65, p < .001, 95% CI [43.33, 51.95]; combined ≈ 29.67), indicating that their decline was strongest at the beginning and end of the list sequence.

Together, these results reveal a pronounced shift in decision dynamics across lists: participants rapidly adopted a "recall to reject" strategy for confusing foils (ST(n), SO(n), TO(n)), while current-list targets bore the brunt of the trade-off—showing an increasing risk of mistaken rejection that produces the crossover of slopes highlighted in Figure 13.1.

### Final Within-List Study Position Effects

**Overall patterns by study position.** For the reference item type SO(n) (baseline logit 0.56, ≈63.57% accuracy), a modest negative linear trend emerged, b = −5.48, SE = 2.25, z = −2.43, p = .015, 95% CI [−9.89, −1.06], indicating that recognition accuracy dropped slightly for items studied later within each list. A positive quadratic component remained, b = 8.68, SE = 2.42, z = 3.59, p < .001, 95% CI [3.94, 13.42], reflecting a gentle primacy–recency bend.

**Picture type effects.** Relative to the reference, SO(n) pictures showed higher accuracy, b = 0.99, SE = 0.05, z = 21.18, p < .001, 95% CI [0.90, 1.08], yielding an estimated marginal mean of 1.54 logits (≈82.42% accuracy). ST pictures were even more accurate, b = 1.13, SE = 0.03, z = 39.13, p < .001, 95% CI [1.08, 1.19], with a marginal mean of 1.69 logits (≈84.41%). ST(n) pictures achieved the highest accuracy, b = 1.80, SE = 0.06, z = 31.02, p < .001, 95% CI [1.68, 1.91], corresponding to 2.35 logits (≈91.32).

**Exposure effect.** Comparing items with matched exposure histories, ST pictures (studied and tested once; 1.69 logits, 84.41%) outperformed the reference single-study baseline by 1.13 logits. ST(n) pictures (retested as confusing foils) added another 0.67 logits over ST, highlighting the cumulative benefit of repeated retrieval. SOn pictures (studied-only items later serving as confusing foils) also surpassed the baseline by 0.99 logits, showing substantial gains even without the final test's immediate retrieval.

**Two-way interactions on linear trend:** Relative to the reference slope, the study-position decline was slightly more negative for SOn (interaction: b = −6.38, SE = 3.55, z = −1.80, p = .072) and slightly more positive for ST (b = 4.29, SE = 3.07, z = 1.40, p = .162) and ST(n) (b = 5.86, SE = 3.22, z = 1.82, p = .069). Although these contrasts did not reach conventional significance, they suggest that repeated testing moderated the decline more than single study-only exposures.

**Two-way interactions on quadratic trend.** None of the quadratic contrasts were significant: SOn (b = 3.76, SE = 3.40, p = .269), ST (b = −5.51, SE = 3.40, p = .106), and ST(n) (b = 8.35, SE = 4.21, p = .047, marginal). Thus, the modest positive curvature was broadly similar across item types, with only ST(n) hinting at additional nonlinear variation.

### Final Within-List Test Position Effects

**Test position effects by picture type.** ST pictures showed a robust positive linear trend, b = 19.03, SE = 2.73, z = 6.97, p < .001, 95% CI [13.68, 24.39], with an estimated marginal mean of 1.69 logits (≈84.4% accuracy). ST(n) pictures exhibited a smaller, non-significant increase across test positions, b = 7.74, SE = 5.01, z = 1.54, p = .123, 95% CI [−2.07, 17.60], yet retained the highest marginal mean at 2.35 logits (≈91.3% accuracy). TO pictures showed a significant positive trend, b = 10.43, SE = 3.98, z = 2.62, p = .009, 95% CI [2.63, 18.23], with a marginal mean of 0.37 logits (≈59.2% accuracy). TO(n) pictures yielded a similar slope, b = 10.09, SE = 5.03, z = 2.01, p = .044, 95% CI [0.22, 20.00], and a marginal mean of 1.29 logits (≈78.5% accuracy). SO(n) pictures also improved across later test positions, b = 10.87, SE = 4.35, z = 2.50, p = .012, 95% CI [2.34, 19.40], with a marginal mean of 1.61 logits (≈83.3% accuracy).

**Quadratic effects varied less sharply.** ST pictures showed a modest negative quadratic component, b = −5.70, SE = 2.81, z = −2.03, p = .042, 95% CI [−11.20, −0.20], indicating a gentle downward bend for items tested near list endpoints. Quadratic adjustments for ST(n) (b = −0.56, SE = 4.13, p = .891), TO (b = 3.71, SE = 4.77, p = .437), and TO(n) (b = 2.64, SE = 4.75, p = .579) did not differ reliably from the ST baseline. SO(n) showed a numerically steeper negative curvature (b = −9.52, SE = 5.83, p = .103), but this contrast also fell short of significance.

**Two-way interactions on the linear trend.** Relative to ST pictures (baseline slope = 19.03), ST(n) slopes were markedly flatter (interaction: b = −11.29, SE = 4.08, z = −2.77, p = .006, 95% CI [−19.28, −3.30]). TO slopes were likewise reduced (interaction: b = −8.60, SE = 3.91, z = −2.20, p = .028, 95% CI [−16.26, −0.94]), as were SO(n) slopes (interaction: b = −8.16, SE = 4.52, z = −1.81, p = .071). The TO(n) interaction trended negative but was not significant (b = −8.95, SE = 4.96, z = −1.80, p = .071). These contrasts underscore that ST items benefitted most consistently from later test positions, whereas the other item types showed more moderate gains.

### Final Between-List Effects by Final Test Position

**Picture type effects.** Different picture types showed substantially different overall recognition accuracy compared to FTO (the reference category). STnST(n) pictures showed the highest accuracy, b = 1.19, SE = 0.05, z = 21.60, p < .001, 95% CI [1.08, 1.29], with an estimated marginal mean of 2.25 logit (approximately 90.5% accuracy). ST pictures showed high accuracy, b = 0.55, SE = 0.02, z = 22.74, p < .001, 95% CI [0.51, 0.60], with a marginal mean of 1.62 logit (approximately 83.5% accuracy). SOnSO(n) pictures showed intermediate accuracy, b = 0.42, SE = 0.04, z = 9.63, p < .001, 95% CI [0.33, 0.50], with a marginal mean of 1.49 logit (approximately 81.6% accuracy). TOnTO(n) pictures showed similar accuracy, b = 0.18, SE = 0.04, z = 4.36, p < .001, 95% CI [0.10, 0.26], with a marginal mean of 1.25 logit (approximately 77.7% accuracy). In contrast, SO pictures showed lower accuracy, b = -0.53, SE = 0.02, z = -25.74, p < .001, 95% CI [-0.57, -0.49], with a marginal mean of 0.54 logit (approximately 63.1% accuracy). TO pictures showed the lowest accuracy, b = -0.70, SE = 0.03, z = -21.64, p < .001, 95% CI [-0.76, -0.64], with a marginal mean of 0.37 logit (approximately 59.1% accuracy). The estimated marginal mean for FTO was 1.07 logit (approximately 74.4% accuracy).

**Linear trends across final test positions.** For the reference category (FTO), a substantial negative linear trend emerged, b = -34.42, SE = 1.47, z = -23.49, p < .001, 95% CI [-37.29, -31.55], indicating that FTO recognition accuracy declined systematically as the final test progressed.

**Quadratic trends across final test positions.** A significant positive quadratic trend emerged across all picture types, b = 3.85, SE = 1.45, z = 2.65, p = .008, 95% CI [1.00, 6.69], indicating a modest inverted-U pattern. This indicates that pictures tested at middle positions showed slightly higher accuracy than those tested at early or late positions, superimposed on the overall negative linear decline. Note: Data sparsity prevented including a quadratic × picture type interaction. The quadratic effect is averaged across picture types.

**Two-way interactions: Linear trends by picture type.** The Final Test Position × picture Type interaction revealed divergent output interference patterns relative to FTO (baseline slope = -34.42). SOnSO(n) pictures showed a large negative interaction, b = -53.75, SE = 1.05, z = -51.31, p < .001, 95% CI [-55.80, -51.69], yielding a steeper combined negative trend of -88.17 (baseline -34.42 + (-53.75)). TOnTO(n) pictures also showed a large negative interaction, b = -41.83, SE = 1.27, z = -33.04, p < .001, 95% CI [-44.31, -39.35], yielding a combined trend of -76.25. ST pictures showed a moderate negative interaction, b = -29.47, SE = 1.52, z = -19.33, p < .001, 95% CI [-32.46, -26.49], yielding a combined trend of -63.90. TO pictures showed a moderate negative interaction, b = -20.46, SE = 1.18, z = -17.30, p < .001, 95% CI [-22.78, -18.14], yielding a combined trend of -54.88. STnST(n) pictures showed a moderate negative interaction, b = -18.25, SE = 1.44, z = -12.64, p < .001, 95% CI [-21.08, -15.42], yielding a combined trend of -52.67. These negative interactions indicate that all studied/tested picture types showed steeper output interference declines than FTO. In contrast, SO pictures showed a positive interaction, b = 7.86, SE = 1.41, z = 5.56, p < .001, 95% CI [5.09, 10.63], yielding a less steep combined negative trend of -26.57 (baseline -34.42 + 7.86). This indicates that SO pictures showed the smallest decline across final test positions, suggesting reduced vulnerability to output interference compared to other picture types.

### Final Between-List Effects by Initial List Order

**Picture type effects.** Relative to TO(n) (intercept = 1.3915 logits, ≈80.08% accuracy), TO items were less accurate, b = −0.9984, SE = 0.0530, z = −18.82, p < .001 (marginal mean 0.3932 logits, ≈59.70%). SO items also underperformed, b = −0.8461, SE = 0.0468, z = −18.07, p < .001 (marginal mean 0.5454 logits, ≈63.31%). In contrast, SO(n) items exceeded the baseline, b = 0.2481, SE = 0.0632, z = 3.93, p < .001 (marginal mean 1.6396 logits, ≈83.75%). ST items showed b = 0.2760, SE = 0.0485, z = 5.69, p < .001 (marginal mean 1.6676 logits, ≈84.12%), and ST(n) items reached b = 1.0080, SE = 0.0727, z = 13.87, p < .001 (marginal mean 2.3995 logits, ≈91.68%).

**Exposure effect.** Items repeated across lists (SO(n), ST(n), TO(n)) averaged ≈1.81 logits (≈86.5%), outperforming single-list items (SO, ST, TO; ≈0.87 logits, ≈70.4%) by about 16.1 percentage points, highlighting a strong repeated-exposure benefit.

**Linear trends across lists.** TO(n) displayed a large positive slope, b = 28.51, SE = 1.64, z = 17.41, p < .001. TO showed an even steeper rise (interaction b = 13.77; combined ≈ 42.28), whereas SO (interaction b = −8.37; combined ≈ 20.14), SO(n) (b = −7.71; ≈ 20.80), ST (b = −0.28; ≈ 28.23), and ST(n) (b = −3.05; ≈ 25.47) retained positive, though varied, slopes—indicating better retention for items from later initial lists across all types.

**Quadratic trends across lists.** A significant positive quadratic trend emerged across all picture types, b = 25.56, SE = 1.26, z = 20.32, p < .001, 95% CI [23.10, 28.03], indicating a reliable inverted-U pattern. This indicates that pictures from middle lists showed higher final test accuracy than those from early or late lists, reflecting primacy and recency deficits in long-term retention. Note: Data sparsity prevented including a quadratic × picture type interaction. The quadratic effect is averaged across picture types.

**Two-way interactions: Linear trends by picture type.** Relative to the TO(n) baseline (slope = 28.51), TO showed a strong positive interaction, b = 13.77, SE = 2.47, z = 5.58, p < .001, yielding a combined slope of roughly 42.28, indicating that later initial lists boosted recognition sharply when foils appeared only once. SO displayed a significant negative interaction, b = −8.37, SE = 2.30, z = −3.63, p < .001, producing a shallower slope of about 20.14. SO(n) similarly showed a negative interaction, b = −7.71, SE = 2.36, z = −3.27, p = .001, giving a combined slope near 20.80. ST and ST(n) interactions were small and nonsignificant (b = −0.28, p = .913; b = −3.05, p = .282, respectively), leaving their slopes close to the baseline (28.23 and 25.47). Together, these contrasts indicate that repeated-exposure foils (TO, TO(n)) gained the most from later lists, while studied-only items (SO, SO(n)) benefited less, and ST/ST(n) items maintained robust positive trends regardless of list position.

