# PhD Dissertation Outline: The Role of Context in Memory Storage and Retrieval: Insights from Recognition Experiments and Computational Modeling

**Overall Estimated Page Count (Main Content):** 180 - 240 pages
**Overall Estimated Word Count (Main Content):** Approximately 45,000 - 60,000 words (excluding references, appendices)

---

## **Preliminary Pages**
* Title Page
* Copyright Page
* Abstract (Approx. 1 page / 250-350 words)
* Acknowledgements
* Table of Contents
* List of Tables
* List of Figures

---

## **Chapter 1: Introduction**
* **Estimated Pages:** 15-20 pages
    * 1.1. The Importance of Episodic Memory (Approx. 2-3 pages)
    * 1.2. The Concept of Context in Memory Research (Approx. 3-4 pages)
        * 1.2.1. Defining Context vs. Content
        * 1.2.2. The Dynamic Nature of Context
    * 1.3. The Role of Context in Memory Storage and Retrieval (Approx. 3-4 pages)
    * 1.4. Challenges in Studying Context (Approx. 2-3 pages)
    * 1.5. Overview of Computational Models of Memory (Briefly introducing REM) (Approx. 2-3 pages)
    * 1.6. Research Aims and Objectives of the Dissertation (Approx. 2 pages)
        * 1.6.1. Investigating context through recognition paradigms
        * 1.6.2. Developing and testing an extended computational model (REM-based)
    * 1.7. Structure of the Dissertation (Approx. 1 page)

---

## **Chapter 2: Literature Review**
* **Estimated Pages:** 25-30 pages
    * 2.1. Theories of Episodic Memory (Approx. 4-5 pages)
        * 2.1.1. Dual-process theories (familiarity and recollection)
        * 2.1.2. Single-process theories
    * 2.2. Context in Memory Models (Approx. 5-6 pages)
        * 2.2.1. Temporal Context Model (TCM)
        * 2.2.2. Retrieving Effectively from Memory (REM) and its variants
        * 2.2.3. Other relevant models (e.g., SAM, BCDMEM)
    * 2.3. Empirical Findings on Context Effects (Approx. 6-7 pages)
        * 2.3.1. List length effects
        * 2.3.2. Serial position effects (primacy, recency)
        * 2.3.3. Output interference
        * 2.3.4. Context change and reinstatement
        * 2.3.5. The role of temporal information and context drift
    * 2.4. Recognition Memory Paradigms (Approx. 4-5 pages)
        * 2.4.1. Item recognition
        * 2.4.2. Associative recognition
        * 2.4.3. The influence of foil types
    * 2.5. Computational Modeling in Memory Research (Approx. 3-4 pages)
        * 2.5.1. Advantages and approaches
        * 2.5.2. Previous modeling of context effects using REM
    * 2.6. Gaps in the Literature and Rationale for Current Studies (Approx. 2-3 pages)

---

## **Chapter 3: Experiment 1 - Picture Recognition with Novel Foils**
* **Estimated Pages:** 30-35 pages
    * 3.1. Rationale and Aims of Experiment 1 (Approx. 2-3 pages)
    * 3.2. Methodology (Approx. 6-8 pages)
        * 3.2.1. Participants
        * 3.2.2. Materials and Stimuli (Picture stimuli)
        * 3.2.3. Design
            * 3.2.3.1. Initial Study-Test Phase (10 lists, 20 study/20 test trials)
            * 3.2.3.2. Final Test Phase (all items tested; Random, Forward, Backward conditions)
        * 3.2.4. Procedure
    * 3.3. Data Analysis Strategy (Approx. 2-3 pages)
    * 3.4. Results of Initial Study-Test Phase (Approx. 8-10 pages)
        * 3.4.1. Within-list effects (study position, test position)
        * 3.4.2. Between-list effects (performance across lists)
        * 3.4.3. Hit rates vs. Correct Rejection rates
    * 3.5. Results of Final Test Phase (Approx. 8-10 pages)
        * 3.5.1. Performance by item type (studied-only, tested-only, studied-and-tested)
        * 3.5.2. Effects of final test condition (Random, Forward, Backward)
        * 3.5.3. Primacy and recency effects in final test
        * 3.5.4. Output interference in final test
    * 3.6. Discussion of Experiment 1 Findings (Approx. 4-6 pages)
        * 3.6.1. Summary of key results
        * 3.6.2. Implications for the role of context
        * 3.6.3. Pointers for computational modeling

---

## **Chapter 4: Experiment 2 - Picture Recognition with Mixed Foils**
* **Estimated Pages:** 25-30 pages
    * 4.1. Rationale and Aims of Experiment 2 (Approx. 2-3 pages)
        * 4.1.1. Building on Experiment 1
        * 4.1.2. Investigating the impact of different foil types (e.g., foils from prior lists/trials)
    * 4.2. Methodology (Approx. 5-7 pages)
        * 4.2.1. Participants
        * 4.2.2. Materials and Stimuli
        * 4.2.3. Design (similar structure to E1, but with modified foil characteristics)
        * 4.2.4. Procedure
    * 4.3. Data Analysis Strategy (Approx. 2-3 pages)
    * 4.4. Results of Initial Study-Test Phase (similar breakdown as E1) (Approx. 7-9 pages)
        * 4.4.1. Comparison with Experiment 1 results
    * 4.5. Results of Final Test Phase (similar breakdown as E1) (Approx. 7-9 pages)
        * 4.5.1. Comparison with Experiment 1 results
    * 4.6. Discussion of Experiment 2 Findings (Approx. 4-6 pages)
        * 4.6.1. Summary of key results and differences from E1
        * 4.6.2. Implications of foil manipulation for context utilization
        * 4.6.3. Further considerations for computational modeling

---

## **Chapter 5: Computational Modeling of Recognition Experiments 1 & 2 with an Extended REM Framework**
* **Estimated Pages:** 40-50 pages
    * 5.1. Introduction to the Modeling Approach (Approx. 3-4 pages)
        * 5.1.1. Goals of the computational model
        * 5.1.2. Overview of the extended REM framework
    * 5.2. The Extended REM Model Architecture (Approx. 10-12 pages)
        * 5.2.1. Core REM principles
        * 5.2.2. Context Representation
            * 5.2.2.1. Changing Context (CC) features (inter-list changes, probability $\delta_{list}$)
            * 5.2.2.2. Unchanging Context (UC) features
            * 5.2.2.3. Content (C) features
            * 5.2.2.4. Context drift (intra-list, study-to-test, probability $\delta_{drift}$)
            * 5.2.2.5. Context reinstatement (probability $\delta_{reinstate}$)
        * 5.2.3. Feature Encoding and Storage
            * 5.2.3.1. Geometric base rates ($g_{word}$, $g_{context}$)
            * 5.2.3.2. Probability of storage ($U^*$, including special cases for first list/test)
            * 5.2.3.3. Copying parameter ($c$)
        * 5.2.4. Memory Update During Testing (Restorage)
            * 5.2.4.1. Strengthening of content features for old items
            * 5.2.4.2. New trace formation for new items
            * 5.2.4.3. Assumptions about target vs. foil storage during test
        * 5.2.5. Decision Process
            * 5.2.5.1. Context filtering (context threshold $\tau$)
            * 5.2.5.2. Content feature evaluation (criterion $\Theta_j$, including changes across test positions and for final test)
        * 5.2.6. Model Parameters (summary table)
    * 5.3. Modeling Experiment 1 (Approx. 10-12 pages)
        * 5.3.1. Application of the model to E1 data
        * 5.3.2. Simulation of initial test performance (within-list, between-list)
        * 5.3.3. Simulation of final test performance (all conditions)
        * 5.3.4. Comparison of model predictions with E1 empirical data (graphical and statistical)
        * 5.3.5. Parameter fitting and sensitivity analyses (briefly)
    * 5.4. Modeling Experiment 2 (Approx. 8-10 pages)
        * 5.4.1. Adapting or applying the model to E2 data (addressing foil differences)
        * 5.4.2. Simulation of initial test performance
        * 5.4.3. Simulation of final test performance
        * 5.4.4. Comparison of model predictions with E2 empirical data
        * 5.4.5. Discussing how the model accounts for differences/similarities between E1 and E2
    * 5.5. Combined Discussion of Modeling Results for E1 and E2 (Approx. 6-8 pages)
        * 5.5.1. Successes of the model in capturing key data patterns
        * 5.5.2. Role of specific model components (context drift, changing/unchanging context, storage/retrieval assumptions)
        * 5.5.3. Limitations of the current model
        * 5.5.4. Insights gained from the consistent modeling mechanism across experiments

---

## **Chapter 6: Recognition memory decisions made with short- and long-term retrieval (Lai, Cao, & Shiffrin, 2024)**
* **Estimated Pages:** 18-22 pages (main text, excluding paper's own references/appendices if extensive)
    * 6.1. Introduction: Relevance to the Dissertation's Themes (Approx. 1-2 pages)
        * (Briefly connect the published work to the broader investigation of context, memory, or modeling, particularly how it informs or differs from the primary dissertation experiments E1 & E2)
    * 6.2. Content of the Published Paper (Reformatted/Summarized for Dissertation Flow)
        * 6.2.1. Abstract (as in paper, approx. 0.5 page)
        * 6.2.2. Introduction / Background and Rationale (from paper, approx. 2-3 pages)
        * 6.2.3. Method (from paper, approx. 3-4 pages)
            * Overview
            * CM conditions overview
            * Method details for the present studies (new paradigm)
            * Stimuli and apparatus
            * Trial timing
            * Groups and conditions
            * Participants
        * 6.2.4. Results (from paper, approx. 4-5 pages)
            * CM versus VM
            * Set-size effects
            * AN versus VM versus CM
            * Mixed/Pure
            * Target lag effects
            * Target lag effects at different set sizes
        * 6.2.5. Modeling (SLR23 Model from paper, approx. 5-6 pages)
            * Conceptual overview (already introduced)
            * Implementation of SLR23 in EBRW
            * Recency for target tests
            * Stages of processing
            * Similarity differences
            * Context change and long-term event trace activation
            * Response times and response boundaries
            * Glitches
            * Fitting the data
            * Predictions
        * 6.2.6. Model Assessment / Discussion (from paper, including comparison with SLR21, approx. 3-4 pages)
            * Model flexibility and parameter variations
            * Estimated parameter values
            * Comparison with Nosofsky et al. (2021) model (SLR21)
        * 6.2.7. Conclusion (from paper, approx. 1 page)
    * 6.3. Brief Discussion: How this work complements the primary dissertation research (Approx. 1-2 pages)
        * (Highlight specific contributions of this paper to the dissertation's arguments, e.g., regarding short-term vs. long-term retrieval, learning, or specific modeling techniques that might contrast or align with the extended REM for E1/E2).

---

## **Chapter 7: General Discussion**
* **Estimated Pages:** 20-25 pages
    * 7.1. Summary of Major Findings (Approx. 3-4 pages)
        * 7.1.1. Key empirical results from Experiment 1 and Experiment 2
        * 7.1.2. Key insights from the computational modeling efforts (Chapters 5 & 6)
    * 7.2. Theoretical Implications (Approx. 5-7 pages)
        * 7.2.1. The multifaceted role of context in recognition memory
        * 7.2.2. Understanding context dynamics (drift, reinstatement, changing vs. unchanging elements)
        * 7.2.3. Contributions to the REM framework and memory modeling (integrating insights from both modeling efforts)
    * 7.3. Integration with Existing Literature (Approx. 4-5 pages)
    * 7.4. Strengths of the Dissertation Research (Approx. 2-3 pages)
    * 7.5. Limitations and Caveats (Approx. 2-3 pages)
        * 7.5.1. Experimental limitations
        * 7.5.2. Modeling limitations and assumptions
    * 7.6. Future Directions (Approx. 3-4 pages)
        * 7.6.1. Further empirical investigations
        * 7.6.2. Potential model refinements and extensions (e.g., to other paradigms, incorporating individual differences)
        * 7.6.3. Broader implications for memory theory

---

## **Chapter 8: Conclusion**
* **Estimated Pages:** 3-5 pages
    * 8.1. Restatement of Key Contributions (Approx. 1-2 pages)
    * 8.2. Concluding Remarks on the Role of Context in Memory (Approx. 2-3 pages)

---

## **References**
* **Estimated Pages:** 10-15 pages (Combined references from all chapters)

---

## **Appendices (Optional)**
* **Estimated Pages:** 5-10 pages
    * Appendix A: Detailed Model Parameters (for Chapter 5 model)
    * Appendix B: Stimuli Examples or Lists (if appropriate for E1/E2)
    * Appendix C: Supplementary Analyses or Figures

---