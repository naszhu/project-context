



const w_context = 56; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_word = 23;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 
nU = 28#round(Int, w_context * ratio_U)
nC = 28#w_context - nU

ratio_unchanging_to_itself_init = 13#LinRange(0.46, 0.46, n_lists) # if use no unchanging
ratio_changing_to_itself_init = 28#LinRange(1, 1, n_lists) # if use no unchanging


const g_word = 0.3; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

# =============================================================================
# TIME AND STORAGE PARAMETERS
# =============================================================================
n_grade = 2 #only first to be special 

u_star_v = 0.4#1-(1-0.04)^13 #0.04

u_star_context=u_star_v

c = 0.76 #lower this value, the differences between T and F bigger at beginning, smaller later


criterion_initial_between_list_base = 0.21  #criterion_between_list_base base value for between-list criterion (Z in formula)
criterion_initial_between_list_r_rate = 0.75  # R parameter controlling asymptotic approach to 1 (0 < R < 1)
criterion_final =0.37
criterion_final_decreasement = - 0.01
recall_odds_threshold = 0.08

context_tau = 100 #foil odds should lower than this

p_reinstate_rate = 0.16 #0.4 #prob of reinstatement #do not reinstate. 
base_recovery_prob = p_reinstate_rate  # smae parameter above 

base_distortion_prob_UC = 0.19  # distortion probability for UC (set higher to test effect)
base_distortion_prob_CC = 0.19  # distortion probability for CC (set higher to test effect)

const p_driftStudyTest = 0.1; # Equivalent to (1-(1-0.03)^9) for study-test drift
const p_driftBetweenList = 0.456; # Equivalent to (1-(1-0.03)^20) for between-list change


chunk_size_final_change = 42; 

p_reinstate_rate_finaltest = 0.3  # for forward and backward test        # Probability of reinstating original CC features in final test 



final_gap_change = 0.1; #0.16 in E3 
context_tau_final = 100 #0.20.2 above if this is 10

p_ListChange_finaltest = ones(10) * 0.013 #0.8 in E3, but undecided as well in E3

ratio_unchanging_to_itself_final = 28# LinRange(1.0,1.0, n_lists) # if use no unchanging
ratio_changing_to_itself_final = 4#LinRange(0.15,0.15, n_lists) # if use no unchanging 

