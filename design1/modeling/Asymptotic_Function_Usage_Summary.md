# Asymptotic Utility Function Usage in E1 Model
## APA-Style Summary

**Date:** October 12, 2025
**Model:** Experiment 1 (E1) - Recognition Memory Model
**Location:** design1/modeling/

---

## Core Formula

All asymptotic functions in this model follow the general exponential utility function:

$$F_k = s + (a - s) \times (1 - e^{-rk})$$

Where:
- $F_k$ = function value at position/list $k$
- $s$ = starting value
- $a$ = asymptotic target value
- $r$ = rate parameter (controls speed of change)
- $k$ = position index (0-indexed: k = 0, 1, 2, ...)

This formula produces:
- **Exponential increase** when $a > s$ (approaching upper limit)
- **Exponential decrease** when $a < s$ (approaching lower limit)

---

## Parameters Using Asymptotic Functions

### 1. Decision Criterion - Initial Test (`criterion_initial`)

**Location:** `module_jl/constants.jl:123`

**Function:** `generate_asymptotic_values(1.0, 1.0, 1.0, 0.35, 0.75, 5.0)`

**Implementation:**
- Creates 2D matrix: [test_position × list_number]
- **Within-list decay:** $F_k = 1.0 + (1.0 - 1.0) \times (1 - e^{-5.0k})$ across 20 test positions
- **Between-list decay:** $F_k = 0.35 + (0.75 - 0.35) \times (1 - e^{-5.0k})$ across 10 lists

**Purpose:** Controls the decision threshold for old/new recognition judgments during initial testing. Higher values make "old" responses more likely.

**Rationale:** Asymptotic decay captures the natural tendency for participants to become more conservative in their "old" responses as:
- Testing progresses within each list (output interference)
- Memory accumulates across lists (proactive interference)

---

### 2. Z Feature Probability Parameters (κ values)

**Location:** `module_jl/constants.jl:297-309`

**Note:** Z features track whether items were previously tested (origin information). Currently disabled in E1 (`use_Z_feature = false`) but code structure is present for future implementation.

#### 2a. h_j Parameter (Increase Function)

**Function:** `asym_increase_shift_hj(hj_base, hj_asymptote_increase_val, hj_rate, n_lists - 1)`

**Parameters:**
- $s$ = 0.3 (hj_base)
- $a - s$ = 0.6 (hj_asymptote_increase_val)
- $r$ = 0.8 (hj_rate)
- $n$ = 9 lists

**Formula:** $h_j(k) = 0.3 + 0.6 \times (1 - e^{-0.8k})$ for k = 0 to 8

**Purpose:** Modulates Z feature storage probability increases across lists.

---

#### 2b. κu Values (Study-Only Items - Decrease Function)

**Function:** `asym_decrease_shift_fj(ku_base, fj_asymptote_decrease_val, fj_rate, n_lists - 1)`

**Parameters:**
- $s$ = 0.1 (ku_base)
- $a - s$ = -0.01 (decrease amount: fj_asymptote_decrease_val)
- $r$ = 0.26 (fj_rate)
- $n$ = 9 lists

**Formula:** $\kappa_u(k) = 0.1 - 0.01 \times (1 - e^{-0.26k})$ for k = 0 to 8

**Purpose:** Probability of correctly storing "tested before" information for study-only items (mainly targets in E1). Decreases slightly across lists.

---

#### 2c. κs Values (Studied-Only Between Lists)

**Function:** `1 - asym_decrease_shift_fj(ks_base, fj_asymptote_decrease_val, fj_rate, n_lists - 1)`

**Parameters:**
- $s$ = 0.47 (ks_base), but inverted: $1 - 0.47 = 0.53$
- Applied decrease then inverted
- $r$ = 0.26 (fj_rate)

**Formula:** $\kappa_s(k) = 1 - [0.47 - 0.01 \times (1 - e^{-0.26k})]$

**Purpose:** Probability of storing origin information for items that were studied but not yet tested during between-list intervals.

---

#### 2d. κb Values (Studied and Tested Items)

**Function:** `1 - asym_decrease_shift_fj(kb_base, fj_asymptote_decrease_val, fj_rate, n_lists - 1)`

**Parameters:**
- $s$ = 0.55 (kb_base), inverted
- $r$ = 0.26 (fj_rate)

**Formula:** $\kappa_b(k) = 1 - [0.55 - 0.01 \times (1 - e^{-0.26k})]$

**Purpose:** Probability of correctly updating origin information for items that were both studied and tested (e.g., recalled items or answered "old").

---

#### 2e. κt Values (Test-Only Items)

**Function:** `1 - asym_decrease_shift_fj(kt_base, fj_asymptote_decrease_val, fj_rate, n_lists - 1)`

**Parameters:**
- $s$ = 0.65 (kt_base), inverted
- $r$ = 0.26 (fj_rate)

**Formula:** $\kappa_t(k) = 1 - [0.65 - 0.01 \times (1 - e^{-0.26k})]$

**Purpose:** Probability of correctly storing origin information for test-only items (foils that were never studied).

---

### 3. Content Distortion Probabilities

**Location:** `module_jl/feature_updates.jl:198, 276`

**Function:** `asym_decrease(base_distortion_prob, 0.0, 5.0, max_distortion_probes)`

**Parameters:**
- $s$ = variable base probability (depends on feature type):
  - Content: 0.0 (disabled)
  - UC (Unchanging Context): 0.0 (disabled)
  - CC (Changing Context): 0.52
- $a$ = 0.0 (target asymptote)
- $r$ = 5.0 (decay rate)
- $n$ = 20 (max_distortion_probes)

**Formula:** $P_{distort}(k) = base\_prob + (0.0 - base\_prob) \times (1 - e^{-5.0k})$

**Purpose:** Controls how memory features drift/distort between study and test. Distortion probability is highest for early test positions and asymptotically approaches 0 as testing progresses.

**Rationale:** Early items tested have had more time for memory traces to drift from original encoded values. Later items are tested more recently and have less drift.

---

## Parameters Using Linear Functions (NOT Asymptotic)

### 1. Context Composition Ratios - Initial Test

**Location:** `module_jl/constants.jl:199-200`

**Implementation:**
- `ratio_unchanging_to_itself_init = LinRange(1, 0.46, n_lists)`
- `ratio_changing_to_itself_init = LinRange(1, 1, n_lists)`

**Formula:** Linear interpolation from start to end value

**Purpose:** Controls how much of the original unchanged/changed context features are used during initial testing across lists.

**Rationale:** Linear decay was chosen for simplicity rather than theoretical reasons. Could potentially be replaced with asymptotic function.

---

### 2. Decision Criterion - Final Test (`criterion_final`)

**Location:** `module_jl/constants.jl:225`

**Implementation:**
- `criterion_final = LinRange((0.09+0.18)^power_taken, 0.27+0.07^power_taken, 10)`
- **Note:** Commented asymptotic version exists but is not used (lines 227-228)

**Formula:** Linear interpolation from 0.27 to 0.34 across 10 values

**Purpose:** Controls decision threshold for final recognition test across list positions.

**Rationale:** Linear function chosen for final test (vs. asymptotic for initial test) because:
- Final test covers longer time period (all studied items)
- May have different strategic demands
- Commented code shows asymptotic version was considered but not adopted

---

### 3. Context Composition Ratios - Final Test

**Location:** `module_jl/constants.jl:232-233`

**Implementation:**
- `ratio_unchanging_to_itself_final = LinRange(1.0, 1.0, n_lists)` (constant)
- `ratio_changing_to_itself_final = LinRange(0.15, 0.15, n_lists)` (constant)

**Formula:** Constant values (LinRange with identical start/end)

**Purpose:** Context reconstruction parameters for final test.

**Rationale:** Final test uses fixed ratios rather than changing values across lists.

---

## Summary Statistics

### Asymptotic Functions Used:
1. **criterion_initial** - 2D matrix (20 × 10) = 200 values
2. **h_j** - 9 values (lists 2-10)
3. **κu, κs, κb, κt** - 4 parameters × 9 values = 36 values
4. **Distortion probabilities** - 20 values (per feature type)

**Total asymptotic parameters: ~265 values**

### Linear Functions Used:
1. **ratio_unchanging_to_itself_init** - 10 values
2. **ratio_changing_to_itself_init** - 10 values (constant = 1)
3. **criterion_final** - 10 values
4. **ratio_unchanging_to_itself_final** - 10 values (constant = 1)
5. **ratio_changing_to_itself_final** - 10 values (constant = 0.15)

**Total linear parameters: 50 values**

---

## Theoretical Rationale for Asymptotic vs. Linear

### Why Asymptotic Functions Are Used:

1. **Memory Interference Processes:** Interference effects (both proactive and output) show diminishing returns - early interference is strongest, later additions have decreasing impact.

2. **Learning Dynamics:** Participants' strategic adjustments to task demands follow learning curves that naturally exhibit exponential properties.

3. **Biological Plausibility:** Neural processes underlying memory encoding and retrieval often follow exponential time courses.

4. **E3 Alignment:** Maintaining consistency with Experiment 3 model architecture for cross-experiment comparisons.

### Why Linear Functions Are Retained:

1. **Simplicity:** Some parameters (especially those held constant) don't require exponential modeling.

2. **Computational Efficiency:** Linear interpolation is faster and sufficient when theoretical predictions don't strongly favor nonlinear dynamics.

3. **Empirical Fit:** Some parameters may fit data equally well with linear vs. asymptotic functions, so simpler form is preferred (parsimony).

---

## Recommendations

### Parameters That Could Transition to Asymptotic:

1. **criterion_final** - Commented code already exists (line 227). Consider enabling if model fit improves or if theoretical predictions favor nonlinear strategy changes across final test.

2. **ratio_unchanging_to_itself_init** - Context reconstruction might follow exponential dynamics as participants adapt testing strategies.

### Parameters That Should Remain Linear:

1. **ratio_changing_to_itself_final** - Currently constant (0.15). No theoretical reason to add complexity.

2. **ratio_unchanging_to_itself_final** - Currently constant (1.0). No theoretical reason to add complexity.

---

## Implementation Notes

All asymptotic functions use the core `_asym_core()` kernel in `utils.jl:31-34`:

```julia
function _asym_core(start::Float64, change::Float64, rate::Float64, n::Int; direction::Int=1)
    return [start + direction * change * (1 - exp(-rate * k)) for k in 0:n-1]
end
```

Where `direction` parameter controls increase (+1) or decrease (-1), maintaining consistent formula structure across all implementations.

---

## References

**Model Files:**
- `design1/modeling/module_jl/utils.jl` - Core asymptotic function implementations
- `design1/modeling/module_jl/constants.jl` - Parameter definitions
- `design1/modeling/module_jl/feature_updates.jl` - Distortion probability applications
- `design1/modeling/JL_V6-6_2finalize.jl` - Main simulation file

**Related Documentation:**
- E3 Model (Experiment 3) - Reference implementation for Z feature κ parameters
- Issue #50 - Context distortion implementation
- Issue #64 - Z feature alignment with E3

---

**Document Prepared By:** Claude Code Assistant
**Last Updated:** October 12, 2025
