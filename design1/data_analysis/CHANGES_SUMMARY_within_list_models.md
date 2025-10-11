# Summary of Changes to experiment1_comprehensive_analysis.R

## **Changes Made**

### **1. Activated Within-List Models**

#### **Model 1: `m_final_within_study`** ✅ NOW ACTIVE
```r
accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
           (1 | participant_id)
```

**What it tests:**
- Linear and quadratic trends across study positions within lists
- Whether these trends differ by item type (ST, SO, foil)
- **NO condition effects** (as requested)

**Item types included:** ST, SO, foil

---

#### **Model 2: `m_final_within_test`** ✅ NOW ACTIVE
```r
accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
           (1 | participant_id)
```

**What it tests:**
- Linear and quadratic trends across test positions within lists (within-list OI)
- Whether these trends differ by item type (ST, TO, foil)
- **NO condition effects** (as requested)

**Item types included:** ST, TO, foil

---

### **2. Deactivated Between-List Model**

#### **Model: `m_between_final`** ❌ NOW COMMENTED
```r
# accuracy ~ final_order_lin * item_type * condition + 
#            final_order_quad * item_type * condition +
#            (1 | participant_id)
```

**Why commented:** To focus on within-list effects only

---

## **Updated Analysis Sections**

### **✅ Active Analyses:**

1. **Model Fitting:**
   - Within-study position model (linear + quadratic)
   - Within-test position model (linear + quadratic)

2. **Results Output:**
   - Model summaries for both within-list models
   - Item type comparisons for both models

3. **Trend Analysis:**
   - Linear trends by item type (within-study)
   - Quadratic trends by item type (within-study)
   - Linear trends by item type (within-test)
   - Quadratic trends by item type (within-test)

4. **Post-hoc Tests:**
   - Pairwise item type comparisons
   - Estimated marginal means

### **❌ Commented Out:**

1. **Between-list models** (final_order, initial_order)
2. **Condition × position interactions** (not applicable for within-list)
3. **Initial test models** (not needed for current analysis)

---

## **Output Files Changed**

### **New Output Files:**
- `experiment1_glmm_within_list_models.rds` (replaces previous RDS)
- `all_model_summaries_within_list.csv` (replaces previous CSV)
- `all_itemtype_trends_within_list.csv` (replaces previous CSV)

### **Old Output Files (no longer created):**
- `experiment1_glmm_with_condition_interactions.rds`
- `all_model_summaries_with_condition_interactions.csv`
- `all_itemtype_trends_with_condition_interactions.csv`

---

## **Model Specifications Summary**

| Model | Status | Formula | Item Types | Interactions |
|-------|--------|---------|------------|--------------|
| `m_final_within_study` | ✅ Active | `study_position (lin+quad) × item_type` | ST, SO, foil | 2-way |
| `m_final_within_test` | ✅ Active | `test_position (lin+quad) × item_type` | ST, TO, foil | 2-way |
| `m_between_final` | ❌ Commented | `final_order × item_type × condition` | All | 3-way |
| `m_between_initial` | ❌ Commented | `initial_order × item_type × condition` | All | 3-way |
| Initial test models | ❌ Commented | Various | target, foil | 2-way |

---

## **Key Differences from Previous Version**

### **What Changed:**
1. **Added quadratic terms** to within-list models (was linear only)
2. **Activated within-list models** (were commented)
3. **Deactivated between-list models** (was active)
4. **Removed condition interactions** from active analyses (as requested)

### **What Stayed the Same:**
1. Random effects structure: `(1 | participant_id)` only
2. Optimizer: `bobyqa` with `maxfun = 500000`
3. Polynomial term creation method (orthogonal)
4. Data preparation steps

---

## **Research Questions Addressed**

### **Current Analysis (Within-List):**
1. Do items show **primacy/recency effects** based on study position?
2. Do items show **within-list OI** based on test position?
3. Do these effects **differ by item type** (ST/SO/TO vs foil)?
4. Are effects **linear or curvilinear**?

### **Previous Analysis (Between-List):**
1. Do conditions (B/F/R) show different **between-list OI patterns**?
2. Do condition effects **vary by item type**?
3. Are there **3-way interactions** between condition, position, and item type?

---

## **To Revert to Between-List Analysis:**

Simply:
1. Comment out `m_final_within_study` and `m_final_within_test` models
2. Uncomment `m_between_final` model
3. Uncomment the condition × position interaction section
4. Update results, trends, and save sections accordingly

---

## **Convergence Expectations**

**Within-list models should converge better than between-list because:**
- Simpler structure (2-way vs 3-way interactions)
- No condition variable (fewer parameters)
- More observations per cell

**Expected relative gradient:** < 0.01 (better than the 0.029 from between-list model)

---

## **Next Steps**

1. **Run the analysis:** `Rscript experiment1_comprehensive_analysis.R`
2. **Check convergence:** Look for relative gradient in output
3. **Examine results:** Review model summaries and trends
4. **Interpret:** Focus on item type differences in primacy/recency and within-list OI
