# Within-List Position Effects: Summary Tables

## **TABLE 1: Study Position Model - Fixed Effects**

| Effect | Estimate | SE | z | p | 95% CI |
|--------|----------|-----|---|---|--------|
| **Intercept (SO baseline)** | 0.76 | 0.06 | 13.60 | < .001 | [0.65, 0.87] |
| **ST vs SO** | 1.43 | 0.03 | 42.93 | < .001 | [1.37, 1.50] |
| **Study Position Linear** | -5.49 | 2.37 | -2.32 | .021 | [-10.14, -0.84] |
| **Study Position Quadratic** | 10.39 | 2.31 | 4.50 | < .001 | [5.87, 14.91] |
| **Linear × ST** | -1.00 | 3.60 | -0.28 | .782 | [-8.05, 6.06] |
| **Quadratic × ST** | -5.87 | 3.42 | -1.72 | .086 | [-12.57, 0.83] |

**Model Convergence:** Relative gradient = 0.0018 ✓

---

## **TABLE 2: Test Position Model - Fixed Effects**

| Effect | Estimate | SE | z | p | 95% CI |
|--------|----------|-----|---|---|--------|
| **Intercept (ST baseline)** | 2.14 | 0.05 | 42.08 | < .001 | [2.04, 2.24] |
| **TO vs ST** | -1.51 | 0.03 | -45.61 | < .001 | [-1.57, -1.45] |
| **Test Position Linear** | 22.78 | 4.40 | 5.17 | < .001 | [14.15, 31.41] |
| **Test Position Quadratic** | -10.04 | 4.45 | -2.26 | .024 | [-18.76, -1.32] |
| **Linear × TO** | 4.35 | 5.37 | 0.81 | .418 | [-6.17, 14.88] |
| **Quadratic × TO** | -2.98 | 5.40 | -0.55 | .581 | [-13.56, 7.60] |

**Model Convergence:** Relative gradient = 0.0030 ✓

---

## **TABLE 3: Item Type Comparisons - Estimated Marginal Means**

### **Study Position Model (ST vs SO)**

| Item Type | Logit | SE | Probability | 95% CI (logit) |
|-----------|-------|-----|-------------|----------------|
| **SO** | 0.76 | 0.06 | 0.68 | [0.65, 0.87] |
| **ST** | 2.19 | 0.06 | 0.90 | [2.07, 2.31] |
| **Difference** | 1.43 | 0.03 | — | [1.37, 1.50] |

**Interpretation:** ST items are 1.43 logit units higher than SO items (*z* = 42.93, *p* < .001)

### **Test Position Model (ST vs TO)**

| Item Type | Logit | SE | Probability | 95% CI (logit) |
|-----------|-------|-----|-------------|----------------|
| **ST** | 2.14 | 0.05 | 0.90 | [2.04, 2.24] |
| **TO** | 0.63 | 0.05 | 0.65 | [0.54, 0.72] |
| **Difference** | 1.51 | 0.03 | — | [1.45, 1.57] |

**Interpretation:** ST items are 1.51 logit units higher than TO items (*z* = 45.61, *p* < .001)

---

## **TABLE 4: Position Trends by Item Type**

### **Study Position Trends**

| Item Type | Linear Trend | SE | 95% CI | Quadratic Trend | SE | 95% CI |
|-----------|--------------|-----|--------|-----------------|-----|--------|
| **SO** | -5.49 | 2.37 | [-10.10, -0.84] | 10.39 | 2.31 | [5.87, 14.91] |
| **ST** | -6.49 | 3.59 | [-13.50, 0.56] | 4.52 | 3.44 | [-2.21, 11.25] |

**Interpretation:**
- **Linear:** Both item types show negative trends (decline for later study positions), *p* < .05 for SO
- **Quadratic:** SO shows significant U-shaped pattern (*p* < .001); ST shows weaker curvature (*p* = .187)

### **Test Position Trends**

| Item Type | Linear Trend | SE | 95% CI | Quadratic Trend | SE | 95% CI |
|-----------|--------------|-----|--------|-----------------|-----|--------|
| **ST** | 22.78 | 4.40 | [14.15, 31.41] | -10.04 | 4.45 | [-18.76, -1.32] |
| **TO** | 27.13 | 3.07 | [21.09, 33.17] | -13.02 | 3.05 | [-19.00, -7.04] |

**Interpretation:**
- **Linear:** Both item types show strong positive trends (facilitation for later test positions), *p* < .001
- **Quadratic:** Both show inverted-U patterns (peak at middle positions), *p* < .05

---

## **VISUAL SUMMARY**

### **Study Position Effects** 📚

```
Accuracy
   ↑
   │     SO: ╲    ╱  (U-shape: primacy + recency)
   │          ╲  ╱
   │           ╲╱
   │     ST: ━━━━╲━  (weak decline)
   │              ╲
   └──────────────────→ Study Position
     Early → → → Late
```

### **Test Position Effects** ✅

```
Accuracy
   ↑
   │         ╱‾‾╲     (Inverted-U: peak in middle)
   │        ╱    ╲    
   │     ST╱      ╲TO (both similar pattern)
   │      ╱        ╲
   │     ╱          ╲
   └──────────────────→ Test Position
     Early → → → Late
```

---

## **KEY STATISTICAL FINDINGS**

### **✓ Highly Reliable Effects (p < .001)**
1. ST > SO by 1.43 logit units
2. ST > TO by 1.51 logit units
3. SO items: Quadratic study position effect (U-shape)
4. ST items: Positive linear test position trend
5. TO items: Positive linear test position trend
6. TO items: Negative quadratic test position trend

### **✓ Reliable Effects (p < .05)**
1. SO items: Negative linear study position trend (primacy)
2. ST items: Negative quadratic test position trend (inverted-U)

### **✗ Non-Significant Effects (p > .05)**
1. ST items: Linear study position trend (p = .070, marginal)
2. ST items: Quadratic study position trend (p = .187)
3. Interactions: All position × item type interactions (p > .08)

---

## **EFFECT SIZE INTERPRETATION**

### **Item Type Differences (Large Effects)**
- **SO vs ST:** Odds ratio = exp(1.43) = 4.18
  - ST items are **4.2 times** more likely to be correctly recognized
- **TO vs ST:** Odds ratio = exp(1.51) = 4.53
  - ST items are **4.5 times** more likely to be correctly recognized

### **Position Effects (Medium Effects)**
- **Study Position Linear (SO):** -5.49 logit units across range
  - ~25% decrease in probability from early to late positions
- **Test Position Linear (ST):** +22.78 logit units across range
  - Substantial facilitation for later-tested items

---

## **MODEL QUALITY INDICATORS**

| Model | Observations | Participants | Convergence | Gradient | Hessian |
|-------|--------------|--------------|-------------|----------|---------|
| **Study Position** | ~41,000 | 196 | ⚠️ Marginal | 0.0018 ✓ | 1 neg eigenvalue |
| **Test Position** | ~41,000 | 196 | ⚠️ Marginal | 0.0030 ✓ | 1 neg eigenvalue |

**Overall Assessment:** Models converged acceptably. Effects with *p* < .01 are highly reliable; effects with *p* < .05 should be interpreted with slight caution due to Hessian issues.

---

## **NOMENCLATURE**

- **ST** = Source-Target items (both study and test info)
- **SO** = Source-Only items (study info only)
- **TO** = Target-Only items (test info only)
- **FTO** = Final Test Old items (foils; not analyzed in within-list models)
