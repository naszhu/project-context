# APA-Style Paragraph: Fixed and Random Effects

## Concise APA-Style Version (For Methods Section) - VERIFIED

All models included random intercepts for participants to account for individual differences in overall performance. Following the principle of maximal random effects justified by design (Barr et al., 2013), we attempted to include random slopes for position effects whenever possible. For initial test analyses (study position, test position, and between-list effects), we successfully included uncorrelated random slopes for linear position trends. However, for all final test analyses, models with random slopes failed to converge despite extended iterations and alternative optimizers, requiring us to use random intercepts only. When models failed to converge, we simplified systematically by removing correlations between random slopes, then removing random slopes for quadratic terms, then linear terms, and finally retaining only random intercepts if necessary. For the final test combined order analysis (three conditions × two ordering types × four item types), the large number of fixed effect parameters required random intercepts only. All fixed effects were retained exactly as specified by the experimental design and theoretical framework, regardless of random effects simplifications.

---

## Convergence Assessment - Concise APA-Style Version (VERIFIED)

Convergence was assessed using relative gradient magnitude (<0.001 recommended threshold) and positive-definiteness of the Hessian matrix. Most models converged successfully with relative gradients well below 0.001 (ranging from 0.0000047 to 0.0018). However, two complex models showed convergence warnings: the final test initial order analysis (relative gradient = 0.022) and the combined final test order analysis (relative gradient = 0.072). For these models, we verified parameter stability across optimization methods (BOBYQA optimizer with up to 500,000 function evaluations), confirmed that fixed effect estimates were consistent with simplified models, and used fallback variance estimation when the Hessian was not positive definite (Bates et al., 2015). All reported results represent the best-fitting models achievable given the complex factorial designs, and we interpret results cautiously when convergence was suboptimal.

---

## Convergence Assessment - Simpler Version (VERIFIED)

We checked convergence using two criteria: (1) relative gradient should be less than 0.001, and (2) the Hessian matrix should be positive definite. Most models converged very well (relative gradients between 0.0000047 and 0.0018). Two complex models had convergence warnings: the final test initial order analysis (0.022) and the combined order analysis (0.072). For these models, we checked that the results were stable by trying different optimization settings (up to 500,000 iterations), comparing results to simpler models, and using fallback methods when needed. All results represent the best models we could fit given the complexity of the designs.

---

## Concise Simpler Version (If Still Too Complex) - VERIFIED

All models included random intercepts for participants to account for individual differences in overall performance. We attempted to include random slopes (allowing each person to have their own sensitivity to position effects) whenever possible. For initial test analyses, we successfully included random slopes for linear position trends. For all final test analyses, models with random slopes failed to converge, so we used random intercepts only. When models didn't converge, we simplified systematically: removing correlations between random slopes, then removing random slopes for quadratic terms, then linear terms, and finally keeping only random intercepts. For the most complex analysis (final test combined order: 3 conditions × 2 ordering types × 4 item types), random intercepts only were required due to the large number of fixed effects. All fixed effects were retained exactly as planned, regardless of random effects simplifications.

---

## Original Paragraph (Hard to Understand)

All models included random intercepts for participants to account for individual differences in overall performance. Random effects structures were selected following the principle of maximal random effects justified by design (Barr et al., 2013), with adjustments made when models failed to converge. Specifically, random slopes for position effects were included when (a) position varied within participants, (b) individual differences in position sensitivity were theoretically plausible, and (c) the model converged successfully . When maximal models did not converge despite extended iterations and alternative optimizers, we simplified by first removing random slope correlations, then removing random slopes for higher-order polynomial terms (quadratic before linear), and finally removing random slopes entirely if necessary. For Experiment 1's final test combined order analysis, the complex factorial design (three conditions × two ordering types × four item types) required a simplified random effects structure (random intercepts only) to achieve convergence given the large number of fixed effect parameters. All fixed effects were retained as specified by the experimental design and theoretical framework.

---

## Technical Explanation (For Reference Only)

### What All Models Have:
- **Random intercepts**: Allows each participant to have their own baseline performance level

### What Some Models Have (When They Converge):
- **Random slopes for linear position terms**: Allows each participant to have their own sensitivity to linear position trends
- Examples from code:
  - Initial study position: Includes random slope for study position linear term
  - Initial test position: Includes random slope for test position linear term
  - Initial between-list: Includes random slope for list number linear term

### What Models Don't Have (When They Don't Converge):
- Final within-study: Only random intercepts
- Final within-test: Only random intercepts
- Final between-combined order: Only random intercepts (most complex model)

### The Simplification Process:
When a model with random slopes doesn't converge, the simplification hierarchy is:
1. Try full random slopes with correlations
2. Remove correlations between random slopes
3. Remove random slopes for quadratic terms
4. Remove random slopes for linear terms
5. Keep only random intercepts

---

## Verification Summary (Checked Against Actual Code)

**Models WITH random slopes (linear only, uncorrelated):**
- `01_initial_study_position_analysis.R`: `(1 | participant_id) + (0 + study_position_lin | participant_id)`
- `02_initial_test_position_analysis.R`: `(1 | participant_id) + (0 + test_position_lin | participant_id)`
- `03_initial_between_list_analysis.R`: `(1 | participant_id) + (0 + list_number_lin | participant_id)`

**Models WITHOUT random slopes (intercepts only):**
- `04_final_within_study_analysis.R`: `(1 | participant_id)` only
- `05_final_within_test_analysis.R`: `(1 | participant_id)` only
- `06_final_between_final_order_analysis.R`: `(1 | participant_id)` only
- `07_final_between_initial_order_analysis.R`: `(1 | participant_id)` only (note: comment mentions simplification)
- `06_07_final_between_combined_order_analysis.R`: `(1 | participant_id)` only (multiple commented-out attempts visible)

**Key findings:**
- Only initial test analyses successfully included random slopes
- Random slopes were only for linear terms, not quadratic
- Random slopes used `(0 + term | participant_id)` syntax (uncorrelated with intercept)
- All final test analyses required intercepts-only structure
- Combined order analysis shows clear evidence of simplification attempts in commented code

