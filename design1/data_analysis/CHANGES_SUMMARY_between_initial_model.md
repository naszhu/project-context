# Summary of Changes: Switched to Between-Initial Model

## **Changes Made**

### **1. Deactivated Within-List Models**

#### **Model: `m_final_within_study`** ❌ NOW COMMENTED
```r
# accuracy ~ study_position_lin * item_type + study_position_quad * item_type +
#            (1 | participant_id)
```

#### **Model: `m_final_within_test`** ❌ NOW COMMENTED  
```r
# accuracy ~ test_position_lin * item_type + test_position_quad * item_type +
#            (1 | participant_id)
```

---

### **2. Activated Between-List Initial Order Model**

#### **Model: `m_between_initial`** ✅ NOW ACTIVE
```r
accuracy ~ initial_order_lin * item_type * condition + 
           initial_order_quad * item_type * condition +
           (1 | participant_id)
```

**What it tests:**
- Linear and quadratic trends across initial test order (between-list positions)
- Whether these trends differ by item type (ST, SO, TO, FTO)
- **3-way interactions with condition** (Backward, Forward, Random)
- Whether condition effects on initial order vary by item type

**Item types included:** ST, SO, TO, FTO (all 4 item types)

---

## **Model Formula Breakdown**

### **Main Effects:**
- `initial_order_lin` - Overall linear trend across initial test order
- `initial_order_quad` - Overall quadratic trend across initial test order  
- `item_type` - Differences between ST, SO, TO, FTO
- `condition` - Differences between Backward, Forward, Random

### **2-Way Interactions:**
- `initial_order_lin × item_type` - Does OI linear trend differ by item type?
- `initial_order_lin × condition` - Does OI linear trend differ by condition?
- `initial_order_quad × item_type` - Does OI quadratic trend differ by item type?
- `initial_order_quad × condition` - Does OI quadratic trend differ by condition?
- `item_type × condition` - Do conditions differ in overall accuracy by item type?

### **3-Way Interactions:**
- `initial_order_lin × item_type × condition` - Do condition effects on linear OI vary by item type?
- `initial_order_quad × item_type × condition` - Do condition effects on quadratic OI vary by item type?

---

## **Updated Analysis Sections**

### **✅ Active Analyses:**

1. **Model Fitting:**
   - Between-initial model (full 3-way interactions with condition)

2. **Results Output:**
   - Model summary for between-initial model
   - Item type comparisons (all 4 types: ST, SO, TO, FTO)

3. **Trend Analysis:**
   - Linear trends by item type
   - Quadratic trends by item type
   - Condition-specific trends by item type
   - Pairwise condition comparisons

4. **Post-hoc Tests:**
   - Pairwise item type comparisons
   - Estimated marginal means
   - Condition × position interactions

### **❌ Commented Out:**

1. **Within-list models** (study position, test position)
2. **Between-final model** (final test order)  
3. **Initial test models** (not needed for current analysis)

---

## **Output Files Changed**

### **New Output Files:**
- `experiment1_glmm_between_initial_model.rds`
- `all_model_summaries_between_initial.csv`
- `all_itemtype_trends_between_initial.csv`

### **Old Output Files (no longer created):**
- `experiment1_glmm_within_list_models.rds`
- `all_model_summaries_within_list.csv`
- `all_itemtype_trends_within_list.csv`

---

## **Model Specifications Summary**

| Model | Status | Formula | Item Types | Interactions | Condition |
|-------|--------|---------|------------|--------------|-----------|
| `m_between_initial` | ✅ Active | `initial_order (lin+quad) × item_type × condition` | ST, SO, TO, FTO | 3-way | Yes |
| `m_between_final` | ❌ Commented | `final_order × item_type × condition` | All | 3-way | Yes |
| `m_final_within_study` | ❌ Commented | `study_position × item_type` | ST, SO | 2-way | No |
| `m_final_within_test` | ❌ Commented | `test_position × item_type` | ST, TO | 2-way | No |

---

## **Research Questions Addressed**

### **Current Analysis (Between-Initial):**
1. Does final test performance depend on when items were **initially tested** (between-list order)?
2. Do **B/F/R conditions** show different OI patterns based on initial test order?
3. Do these condition effects **vary by item type** (ST/SO/TO/FTO)?
4. Are effects **linear or curvilinear** (primacy/recency patterns)?
5. Do conditions produce different **shapes of OI** (linear vs U-shaped vs inverted-U)?

### **Key Difference from Between-Final:**
- **Between-Initial**: Examines effects based on when items were tested in the **initial test phase**
- **Between-Final**: Examines effects based on when items are tested in the **final test phase**

### **Interpretation:**
- If initial order effects differ by condition → Suggests encoding/initial retrieval differences
- If final order effects differ by condition → Suggests output interference during final test

---

## **Expected Results**

### **What to Look For:**

1. **Item Type Differences:**
   - ST items should show highest accuracy
   - SO/TO items should show intermediate accuracy
   - FTO items (foils) should show good rejection rates

2. **Initial Order Effects:**
   - May show primacy/recency patterns
   - Negative linear trend = items tested later perform worse (proactive interference)
   - Positive linear trend = items tested later perform better (facilitation)
   - U-shaped = both early and late items perform better

3. **Condition × Initial Order Interactions:**
   - **Critical test**: Do B/F/R conditions show different OI patterns based on initial test order?
   - If significant → Condition manipulation affects how initial test order influences final performance

---

## **To Run Different Models:**

### **To Run Between-Final (Final Test Order):**
1. Comment out `m_between_initial`
2. Uncomment `m_between_final`
3. Update trends section to use `final_order` variables
4. Update condition interaction section

### **To Run Within-List Models:**
1. Comment out `m_between_initial`
2. Uncomment `m_final_within_study` and/or `m_final_within_test`
3. Comment out condition interaction section (within-list don't have condition)
4. Update results and trends sections

---

## **Convergence Expectations**

**This model is complex (3-way interactions, 4 item types, 3 conditions):**
- Expected relative gradient: 0.01 - 0.05 (marginal but acceptable)
- May show Hessian warnings due to complexity
- Effects with p < .01 should be reliable
- Effects with p = .04 - .05 interpret with caution

**Comparison to other models:**
- More complex than within-list models (fewer parameters, simpler interactions)
- Similar complexity to between-final model
- Both between-list models should show similar convergence

---

## **Next Steps**

1. **Run the analysis:** `Rscript experiment1_comprehensive_analysis.R`
2. **Check convergence:** Look for relative gradient < 0.05
3. **Examine condition interactions:** Key focus of this analysis
4. **Compare with between-final results:** Do initial vs final order show different patterns?
