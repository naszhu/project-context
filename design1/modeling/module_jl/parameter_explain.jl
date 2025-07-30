






"""
#Mechanism: 
1. Trace strengten when judge old, context not update, content will be updated when a mismatch of feature value is found. The maximum liklihood trace will be chosen as the recalled trace. 
2. When judge new, a new trace will be added.
3. When updating the trace to be strengtened, only content will be updated, context will not be updated.
4. This model has 3 kinds of context: context general to all lists; context specific to list; context drift and reinstate between study and test.
5. Context general to all lists are ignored in inital test, meaning that general context is not used in probing.     
"""
context_tau = 100 #first stage filter likelihood criterion
w_word = 30; # number of word features
criterion =  [1.0, 0.98, 0.96, 0.94, 0.92, 0.89, 0.87, 0.85, 0.83, 0.81, 0.79, 0.77, 0.75, 0.73, 0.71, 0.68, 0.66, 0.64, 0.62, 0.6] # criterion used for second stage content judge. Linear decrease from 1 to 0.6 in 20 test positions 
g_word = 0.4; #geometric base rate for word features
g_context = 0.2; #geometric base rate of context features
w_context =30; #number of context features, including (1) within-list-constant context (20% = 6) and (2) context drift context (80% = 24)
n_units_time = 10; #number of storages
n_units_time_restore = 5 # number of restorage when a trace strengtening happens in testing (change this number doesn't influce result much)
u_star = 0.04; # Probability of storage; equals 0.33 if storage time is 1
c = 0.8; #copying parameter - 0.8 for context copying, equals 0.8 if storage time is 1

p_reinstate_context = 0.8 # (related to the previous parameter) probability of context drift and reinstate out of all context features.
p_RI_change = 0.366 #prob of context feature drift between study&test. 
p_list_change = 0.216 #prob of feature change from list to list. --> It can be calculated that percentage of context feature that has changed after 4 lists is 0.86
p_reinstate_rate = 0.4 #prob of context reinstate --> --> It can be calculated that percentage of context feature that has been reinstated after 5 lists is 0.92

