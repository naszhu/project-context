

is_finaltest = false
n_simulations = is_finaltest ? 200 : 2000;

# =============================================================================
# SIMULATION CONTROL FLAGS
# =============================================================================

# =============================================================================
# LIST AND PROBE PARAMETERS
# =============================================================================

const n_probes = 20; # Number of probes to test
const n_lists = 10;
const n_words = n_probes;
# Only takes the first value; for a single Int
# Initial test ratios

# =============================================================================
# CONTEXT AND WORD FEATURE PARAMETERS
# =============================================================================
const w_context = 56; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_word = 23;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 
w_positioncode = 0
w_allcontext = w_context + w_positioncode

# Context composition ratios
ratio_U = 0.5 #ratio of general(unchanging) context
nU = round(Int, w_context * ratio_U)
nC = w_context - nU

# =============================================================================
# GEOMETRIC BASE RATES
# =============================================================================
const g_word = 0.3; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

# =============================================================================
# TIME AND STORAGE PARAMETERS
# =============================================================================
n_grade = 2 #only first to be special 
const n_units_time = 13 #number of steps                                                                                                                                                                                                                        

# u_star parameters
u_star_v = 0.046
u_star = vcat(u_star_v, ones(n_lists-1) * u_star_v)
u_star_storeintest = u_star #for word # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence

adv_u_star_strengthen = 0.06# 0.06
adv_c_strenghten = 0.1# 0.1

# Additional advantage parameters from E3
u_star_adv = 0  # 0.06 in E3
c_adv = 0  # 0.06 in E3

# u_star_context parameters
# u_star_context=vcat(0.08, ones(n_lists-1)*0.045)
#CHANGED, TODO: can change back firstL special
u_star_context=vcat(u_star_v, ones(n_lists-1)*u_star_v)
init_pos1_ustar_ctx_adv =0.00 #0.05
# what would happen if I put this not special for first list? (the specificity for first poistion still exists)
 
# Time restoration parameters
n_units_time_restore = n_units_time #only applies for adding traces now. 
n_units_time_restore_t = n_units_time_restore  # -3
n_units_time_restore_f = n_units_time_restore_t # -3
# n_units_time_restore = n_units_time + 10

const c = 0.895 #coying parameter - 0.8 for context copying 
const c_storeintest = fill(c, n_lists)  # Make this an array to match usage
const c_context = fill(c, n_lists)

# E3 specific context copying parameters
const c_context_c = fill(c, n_lists)  # copying parameter for changing context
const c_context_un = fill(c, n_lists)  # copying parameter for unchanging context



# =============================================================================
# SIMULATION CONTROL FLAGS
# =============================================================================

# Sampling method flag
sampling_method = true  # true for probabilistic sampling, false for argmax

# Context testing flags
firststg_allctx = false; #cancle this
firststg_allctx2 = false;
is_test_allcontext = false #include general context? not testing all context in intial test 
is_test_allcontext2 = true #is testing all context in final testZ
is_test_changecontext2 = false #is testing only change context in final test

# Restoration flags
is_restore_initial = true
is_UnchangeCtxDriftAndReinstate = false  # Disable UC distortion (align with E3)
const is_store_mismatch = true; #if mismatched value is restored during test
is_restore_final = true #followed by the next
is_onlyaddtrace_final = false
is_restore_context = true # currently don't want to restore context features, only add new context features tarce
is_content_drift_between_study_and_test = true  # Enable content distortion (from E3)

# Stage control flags
is_firststage = true;
is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist = false; #this is discarded currently

# =============================================================================
# CRITERION AND THRESHOLD PARAMETERS
# =============================================================================
# criterion_initial = LinRange(1.5, 0.3, n_probes);#the bigger the later number, more close hits and CR merges. control merging  
# criterion_initial is already a 2D array: [test_position, list_number]
power_taken = 1/11  # raise to 1/11 power for sampling

# this is [0.148] in E3
v_criterion_initial = 0.65#0.1^power_taken
criterion_initial = generate_asymptotic_values(1.0, v_criterion_initial, v_criterion_initial, 1.0, 1.0, 5.0) 

recall_odds_threshold = 0.0^power_taken;
recall_to_addtrace_threshold = Inf;  # E3 parameter for adding traces even when recalling
p_recallFeatureStore = 0.85;

# =============================================================================
# E1 LIST ORIGIN PARAMETERS
# =============================================================================
# E1 list origin parameters for switching from familiarity to list origin recall
# These help participants focus on current list context as memory accumulates

# # Base probabilities for switching to list origin recall
# z_base_T = 0.04  # Base probability for targets (lower than E3 since no confusing foils)
# z_base_F = 0.40  # Base probability for foils (lower than E3 since no confusing foils)

# # How much the z values increase over lists
# how_much_z_T = 0.07  # How much target z increases (less than E3's 0.16)
# how_much_z_F = 0.07  # How much foil z increases (less than E3's 0.3)

# # How fast the z values increase over lists  
# how_fast_z_T = 0.6   # How fast target z increases (less than E3's 0.8)
# how_fast_z_F = 0.3   # How fast foil z increases (less than E3's 0.4)

# # Generate z values that increase over lists for E1
# z_time_p_val_E1 = Dict(
#     :T => asym_increase_shift(z_base_T, how_much_z_T, how_fast_z_T, n_lists-1),
#     :F => asym_increase_shift(z_base_F, how_much_z_F, how_fast_z_F, n_lists-1)
# )

# println("E1 z_time_p_val: ", z_time_p_val_E1)

# =============================================================================
# CONTEXT TESTING PARAMETERS  
# =============================================================================
# Context testing flags
context_tau = 100 #foil odds should lower than this

# =============================================================================
# DRIFT AND CHANGE PARAMETERS
# =============================================================================
p_poscode_change = 0.1 #this won't be used
p_reinstate_context = 1 #stop reinstate after how much features, 1.9 means a hundrad percent of features are reinstated
# CATION: uh, this needs to be 1 for E3 as well. 
p_reinstate_rate = 0.1 #0.4 #prob of reinstatement

#this number is 12 in E3, i theoretically should keep this the same, but very hard
n_driftStudyTest = round.(Int, ones(10) * 11) #7

n_between_listchange = 18 #18 in E3 #25 originally 

const p_driftAndListChange = 0.03; # studied prior list probability change

# Content distortion parameters (from E3) for content drift between study and test
max_distortion_probes = 7  # Number of probes until distortion probability reaches 0
base_distortion_prob = 0.29  # Base probability of distortion for the first probe 

# p_ratio_unchanging_between_list = 0.2 #0.3 #prob of unchanging context probing each list

# =============================================================================
# RATIO PARAMETERS FOR INITIAL AND FINAL TESTS
# =============================================================================
ratio_unchanging_to_itself_init = LinRange(0.46, 0.46, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(1, 1, n_lists) # if use no unchanging

nU_in = round.(Int, nU .* ratio_unchanging_to_itself_init)[1]
nC_in = round.(Int, nC .* ratio_changing_to_itself_init)[1]

# =============================================================================
# FINAL TEST PARAMETERS
# =============================================================================
const n_finalprobs = 420;

range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)

# E3 final test chunk parameters
const total_probe_L1 = 15;  # total probes in list 1
const total_probe_Ln = 12;  # total probes in other lists
const nItemPerUnit_final = 2;  # items per unit in final test

criterion_final = LinRange(0.5^power_taken, 0.6^power_taken, 10)
final_gap_change = 0.1; #0.16 in E3 
context_tau_final = 100 #0.20.2 above if this is 10
p_ListChange_finaltest = ones(10) * 0.2 #0.8 in E3, but undecided as well in E3
ratio_unchanging_to_itself_final = LinRange(1,1, n_lists) # if use no unchanging
ratio_changing_to_itself_final = LinRange(0.3,0.3, n_lists) # if use no unchanging

nU_f = round.(Int, nU .* ratio_unchanging_to_itself_final)
nC_f = round.(Int, nC .* ratio_changing_to_itself_final)

# =============================================================================
# Z FEATURE PARAMETERS (adapted from design3)
# =============================================================================
# Z feature configuration for E1 - only targets (no confusing foils)
use_Z_feature = true

# Number of Z features to add (1 for the tested_before status)
n_z_features = 1
const tested_before_feature_pos = w_word + n_z_features  # position of Z feature (24)

# Kappa parameters for Z feature - E1 only needs κu for targets since no confusing foils
# Based on design3 κu values but adapted for E1's simpler structure
ku_base = 0.15  # Base probability for targets during study, higher this value, lower the starting point of T
fj_asymptote_decrease_val = 0.01  # Asymptote value for decreasing function
fj_rate = 0.26  # Rate of change for the decreasing function

# =============================================================================
# MISCELLANEOUS PARAMETERS
# =============================================================================
#the advatage of foil in inital test (to make final T prediciton overlap)
u_advFoilInitialT = 0;

# E3 specific parameters
is_strengthen_contextandcontent = true;  # E3 parameter for strengthening context and content

# =============================================================================
# PROBABILITY CALCULATIONS AND DEBUG OUTPUT
# =============================================================================
# n_driftStudyTest = round.(Int,ones(10)*25)
println("prob of each feature change between list $(1-(1-p_driftAndListChange)^n_between_listchange)")
println("prob of each feature drift between study and test $(1-(1-p_driftAndListChange)^n_driftStudyTest[1])")
aa = (1 - (1 - p_driftAndListChange)^n_between_listchange);
println("prob of feature change after 4 lists $(1-(aa)^8)")
println("prob of each all features had reinstate after 3 $(1-(1-p_reinstate_rate)^3)")
println("The actual u_star after nsteps is", 1-(1-u_star[1])^n_units_time)

