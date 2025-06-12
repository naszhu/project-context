

1. method1
```julia
nnnow=0.76 #(copy param)

criterion_initial = generate_asymptotic_values(1.0, 0.07, 0.07, 1.0, 1.0); 
criterion_final =  LinRange(0.18,0.2, 10)#LinRange(0.18, 0.23, 10)
context_tau_final = 100 #0.20.2 above if this is 10
recall_odds_threshold = 100;

p_switch_toListOrgin =  LinRange(0.2, 0.8 , 10)#probabiltiy of switch (or can say, 
p_old_with_ListOrigin = 0.5 #
```


![alt text](<imgMD/25-06-20: Pzzle, why so hard to finetune/image.png>)

2. same above, but
commit: 835d79929ae3da438694f4abacad39edfaff0d7f

```julia
nnnow=0.76 

criterion_initial = generate_asymptotic_values(1.0, 0.05, 0.05, 1.0, 1.0); #CHANGED,

criterion_final =  LinRange(0.18,0.2, 10)#LinRange(0.18, 0.23, 10)
context_tau_final = 100 #0.20.2 above if this is 10
recall_odds_threshold = 100;

p_switch_toListOrgin =  LinRange(0.2, 1 , 10) #CHANGED
p_old_with_ListOrigin = 0.5 #
```

![alt text](<imgMD/25-06-20: Pzzle, why so hard to finetune/image-1.png>)


3. m3
```julia
nnnow=0.75
start_and_rate = [0.28, 0.25]
start_and_end = [0.2, 0.65]


# asymptotic_vals =  generate_asymptotic_increase_fixed_start(start_and_rate[1], start_and_rate[2], ilist_switch_stop_at-1)
asymptotic_vals =  LinRange(start_and_end[1], start_and_end[2], ilist_switch_stop_at-1)

p_switch_toListOrgin = vcat(0,asymptotic_vals, asymptotic_vals[end]*ones(n_lists-ilist_switch_stop_at)...)
p_old_with_ListOrigin = 0.55 

```
![alt text](<imgMD/25-06-20: Pzzle, why so hard to finetune/image-2.png>)