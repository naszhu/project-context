
    [Need to explain H↓  &  CR↑]
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
    (1) F₁         (2) CC       (3) Feature-balance
    change         drift          ┌─────────────┐
    over lists    magnitude       │             │
        │           │            ▼ ▼           ▼
        │           │      ↓UC + ↑CC      ↓CC only
        │           │         │              │
        │           │         │              │
    Eval: needs   Eval: requires Eval: smooth   Eval: hurts  
    active control    jumps explain    H↓ & CR↑     overall  
                      (implausible)                 performance

## Current thought: (3)-a 

(previously used (2))
got this

```julia
ratio_unchanging_to_itself_init = LinRange(0.2, 0.2, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(1, 1, n_lists) # if use no unchanging
n_between_listchange = round.(Int, LinRange(12, 20, n_lists)); #5;15; #CHANGED, this is used in sim()
context_tau = LinRange(1000, 1000, n_lists) ##CHANGED 1000#foil odds should lower than this  
criterion_initial = LinRange(6, 4, n_probes); #CHANGED
```

![alt text](<imgMD/25-05-21 new tracking - new ideas _rich and me/image.png>)

- Now give (3)-a
```julia
ratio_unchanging_to_itself_init = LinRange(0.4, 0, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(0.7, 1, n_lists) # if use no unchanging
n_between_listchange = round.(Int, LinRange(12, 12, n_lists)); #5;15; #CHANGED, this is used in sim()
```
![alt text](<imgMD/25-05-21 new tracking - new ideas _rich and me/image-1.png>)

```julia
ratio_unchanging_to_itself_init = LinRange(0.5, 0.15, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(0.7, 1, n_lists) # if use no unchanging
context_tau = LinRange(10000, 10000, n_lists) ##CHANGED 1000#foil odds should lower than this  
n_between_listchange = round.(Int, LinRange(12, 12, n_lists)); #5;15; #CHANGED, this is used in sim()
```

To match more of the current obs.

![alt text](<imgMD/25-05-21 new tracking - new ideas _rich and me/image-2.png>)