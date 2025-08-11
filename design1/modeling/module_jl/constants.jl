
# recall_odds_threshold = 1e5;
recall_odds_threshold = 100;
p_recallFeatureStore = 0.85;

printword(wordimg) = [wordimg[i].word_features for i in eachindex(wordimg)];
printfeature(ft) = [[ft[i][j].value for j in eachindex(ft[1])] for i in eachindex(ft)];

const w_context = 50; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_word = 25;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 

w_positioncode = 0
w_allcontext = w_context + w_positioncode
ratio_U = 0.5 #ratio of general(unchanging) context

nU = round(Int, w_context * ratio_U)
nC = w_context - nU



is_finaltest = false
n_simulations = is_finaltest ? 100 : 500;
# n_simulations= 50v
context_tau = 100#foil odds should lower than this  
firststg_allctx = false; #cancle this
firststg_allctx2 = false;
is_test_allcontext = false #include general context? not testing all context in intial test
is_test_allcontext2 = true #is testing all context in final testZ
is_test_changecontext2 = false #is testing only change context in final test
is_restore_initial = true
is_UnchangeCtxDriftAndReinstate = true
const is_store_mismatch = true; #if mismatched value is restored during test
is_restore_final = true#followed by the next
is_onlyaddtrace_final = false

is_restore_context = false # currently don't want to restore context features, only add new context features tarce

is_firststage = true;

is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist = false; #this is discarded currently

const n_probes = 20; # Number of probes to test
const n_lists = 10;
# const n_words = 40;
const n_words = n_probes;

# criterion_initial = LinRange(1.5, 0.3, n_probes);#the bigger the later number, more close hits and CR merges. control merging  
criterion_initial = criterion_initial = generate_asymptotic_values(1.0, 0.14, 0.14, 1.0, 1.0, 5.0) 

p_poscode_change = 0.1
p_reinstate_context = 1.0 #stop reinstate after how much features, 1.9 means a hundrad percent of features are reinstated


#p_driftAndListChange should be used for both within-list drift and between-list change
#7, 10 IS A COMBINATION
n_driftStudyTest = round.(Int, ones(10) * 7) #7
n_between_listchange = 25; #5;15; 

const p_driftAndListChange = 0.03; # studied prior list probability change 

# p_ratio_unchanging_between_list = 0.2 #0.3 #prob of unchanging context probing each list
p_reinstate_rate = 0.2 #0.4 #prob of reinstatement


# n_driftStudyTest = round.(Int,ones(10)*25)
println("prob of each feature change between list $(1-(1-p_driftAndListChange)^n_between_listchange)")
println("prob of each feature drift between study and test $(1-(1-p_driftAndListChange)^n_driftStudyTest[1])")
aa = (1 - (1 - p_driftAndListChange)^n_between_listchange);
println("prob of feature change after 4 lists $(1-(1-aa)^8)")
println("prob of each all features had reinstate after 3 $(1-(1-p_reinstate_rate)^3)")

const g_word = 0.4; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2

n_grade = 2 #only first to be special 

# u_star = vcat(0.09, ones(n_lists-1) * 0.06)
u_star = vcat(0.066, ones(n_lists-1) * 0.066)
u_star_storeintest = u_star #for word # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence

# u_star_context=vcat(0.08, ones(n_lists-1)*0.045)
#CHANGED, TODO: can change back firstL special
u_star_context=vcat(0.05, ones(n_lists-1)*0.05)
init_pos1_ustar_ctx_adv =0.00 #0.05
# what would happen if I put this not special for first list? (the specificity for first poistion still exists)
 
const n_units_time = 13#number of steps                                                                                                                                                                                                                        
n_units_time_restore = n_units_time #only applies for adding traces now. 
n_units_time_restore_t = n_units_time_restore  # -3
n_units_time_restore_f = n_units_time_restore_t # -3
# n_units_time_restore = n_units_time + 10


const n_finalprobs = 420;
const c = 0.75 #coying parameter - 0.8 for context copying 


range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling
# const w_context =60; #first half normal context, second half change context, third half word-change context


const c_storeintest = c

# const u_star_context = u_star # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
const c_context = LinRange(c, c, n_lists)

# const context_tau_f = 20;
# -------------------------------
# criterion_final = LinRange(0.165, 0.24, 10)


# criterion_final = LinRange(0.18, 0.23, 10)
criterion_final = LinRange(0.5, 0.6, 10)
final_gap_change = 0.1; #0.21

context_tau_final = 100 #0.20.2 above if this is 10


p_ListChange_finaltest = ones(10) * 0.55 #0.1 prob list change for final test

ratio_unchanging_to_itself_init = LinRange(0.4, 0.4, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(1, 1, n_lists) # if use no unchanging

# Only takes the first value; for a single Int
nU_in = round.(Int, nU .* ratio_unchanging_to_itself_init)[1]
nC_in = round.(Int, nC .* ratio_changing_to_itself_init)[1]

#delete ratio_C_final
ratio_unchanging_to_itself_final = LinRange(0.5,0.5, n_lists) # if use no unchanging
ratio_changing_to_itself_final = LinRange(0.1,0.1, n_lists) # if use no unchanging

nU_f = round.(Int, nU .* ratio_unchanging_to_itself_final)
nC_f = round.(Int, nC .* ratio_changing_to_itself_final)


#the advatage of foil in inital test (to make final T prediciton overlap)
u_advFoilInitialT = 0;