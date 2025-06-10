

#### Logic Flow:

                    [Minimize # of changes & keep them plausible]
                                   │
                    ┌───────────┼───────────────┐
                    │           │               │
                         ▼           ▼               ▼
          (1) Criterion    (2a) CC-focus    (2b) T-focus 
               rises           │                     Attention Weight
               (power fn.)     │               │
                              │               │
                              ▼               ▼
                    ↑ CC-change       Extra T focus
                    (via focus)       at cost of other T  
                              │               │
                              │               |
                      Strengthen??            │
                    ┌───────┴───────┐       └───┐
                    │               │           │
                    ▼               ▼           │
               Strengthen           Strengthen  │
               all features?        CC only     │
               (cancels effects)    (plausible) │
                    │               │           │
                    │               │           │
                    └──────────┬────┘           │
                              │                │
                              ▼                ▼
                    Need CC > T boost      Total T constant 
                    to fit foil-CRs        (redistribution)
                              │                │
                              └──────┬─────────┘
                                        │
                                        ▼
                    Ensure final test fit:
                    study-only ≈ foil-only CR
                                        │
                                        ▼
                              [Simulation required]


---
#### Counterpart:

                 Strengthen T       ⇄       Strengthen CC
                ─────────────                ─────────────
                ↓ CRs (Stage 2)             ↑ CRs (Stage 1)
                         ↕
               Balance CC > T to match data

---


I am hoping we can minimize the number of things that change as lists continue and make those few things plausible: 

1) The criterion rises — this is sensible because S starts receiving feedback that many old responses are incorrect. The data seem to show that the criterion cages level off after about four lists,  and that might suggest the **criterion rises according to a power function to an asymptote.** But before doing that. consider what else changes as lists continue: 

   1) 2a) CC feature numbers stay the same, but S focuses more and more on CC features that allow those feature to be more list specific and hence produce **more CC change between lists** thereby reducing activation of prior list traces due stage 1 filtering. 

   2) 2b)  CC feature numbers stay the same, and **change from list to list stays the same but S focuses more and more on T features** that identify the list of origin, thereby allowing a  trace to be rejected sometimes if recalled and from the prior list.

2a) When I had suggested modeling with 2a, I had suggested we would want to strengthen by strengthening all features, CC, UC and T. Why? If only T gets strengthened then all confusing last trial traces pass stage 1 equally; then the stronger T features for confusing foils will produce higher stage 2 likelihood ratios and higher FAs (lower CRs). 

However, the data show study-test foils have fewer FAs and Higher CRs than study-only and foil-only confusing foils. 

I had thought to reverse that by increasing the filtering out of prior list traces in stage 1. That might work, but **only if we strengthen only CC, not UC**, because strengthening both produce opposite effects and tend to cancel each other. **Strengthening only CC is conceptually sensible** because it is plausible that S can control only the CC features. There is still a delicate balancing act if we want to fit data: The study-test traces may be filtered out better than the other confusing foils in stage 1 filtering, but the ones that pass the filter will get more FAs, thus the effects on study-test confusing foils compete. **To fit the results we might have to assume more strengthening of CC than T**. If we do this that might help predict why confusing foils that were foil on list N-1 have higher CRs than confusing foils that were study only on last N-1. This approach seems to require complex balancing of several factors.

2b) We must assume that testing produces extra T features that identify list origin, but at the cost of other T features, so in the simplest model the total number of T features does not change. This is done by this special kind of strengthening of T features only.

In both 2a and 2b we must consider how to make final testing of study-only confusing foils about equal to foil only confusing foils.

Is 2b simpler? Perhaps (this is confusing).

## Implementation

1. before application; if nothing change
   (commit 43352de81ea8c2e6a996a8c6ece704b35da0305b finetune(model-3): An Anchor V: if nothing change)
![alt text](<imgMD/25-06-10 Rich suggestion /image-1.png>)

2. only CC change change
```julia
     # Note
     is_strengthen_contextandcontent = false
     n_between_listchange = round.(Int, LinRange(12, 20, n_lists)); #5;15;      #CHANGED, this is used in sim()
```

![alt text](<imgMD/25-06-10 Rich suggestion /image-2.png>)

3. 