#= ===========================================================================================================
Author      : Shuchun (Lea) Lai
Date        : 2024-10-30, modified from 6-3-1!
Description :


Notes       : 
.  (predicting merging trend by target and foil): change criterion by test position, criterion gradually decrease,  from 1  to 0.7 
2. (predict increase in average) - context drift & context reinstate. Context reinstate graduatlly, and about 90% context will be reinstated after 5 tests. 
======

Q: Original REM: is decrease Hs from 1-20 caused by strengtening trace? 
A: change is_onlyaddtrace = true, taking away feature of strengtening, at least Foils go down (align with observation.), but Target not sure and it fluturate too much,
if take away restore_intest, no restore in testing at all, then almost no performance change  



*is_finaltest = false; temporarily
1.plotting R more prediction, 
2.adding context word_change
    * n_wordchange_ST times change during study and test in each list more than word_chagne context original 
    *[div(w_context,3)
    * context_fea=[general,list-change,word-change]
3. try adding a filter for inital  serial-position result (no output interfereance) (tau_filter; filter in second stage)

*4. change probe_evluation function: make image_pool_currentlist image pool of each list ininitial only contain current list images. is_onlytest_current_list=false;

5. weirdly,after all those change decision_isold = odds =1.2 for list 1

I.test-position effect
1. delete word_change; is_only_test_current_list=false; 
2. (predicting merge) delete tau_filter, add criterion_initial, change criterion by initial_testpos
3. serial-pos plot add an average
4. (predict avg increase) - context reinstatement, modify sim(rem); generate_probes()
    *add 
    *reinstate with no errors for now (in probe generation)

            # list_change_context_features only change between lists, change after each list;
            # test_list_context is dynamic, it changes after gap of study and test, & change/reinstate after each test, discard after each list;
            # list_change_context_features is used as a record, to reinstate in probe generation

    image context: [general,listchange]
    probe context: []

II. serial-position effect
1.plot primacy/recency - change structure, add word.studypos. change correspondingly

III. add final test
1. add condition is_finaltest in plotting
2. add allresf record initial_testpos; initial_studypos

IV, don't restore(strengten) context, but add new context trace; 
is_restore_context

V small changes:
n_lists: able to change number. modified definition of study_pool n


is_restore_context: current features: don't restore context features, only restore content features
only test list_change_context_features

-------------------------------------
6-2: final test tunning
I. 
const p_ListChange_finaltest =0 #probe probability change for context
===
report: if test general context, then there is a dip, if only test change context, there is no dip
===
make foils in inital test only store shifted context

advices: amount of strengthening goes down list by list, and filtering at end using only unchanging, 

===
add ratio of Unchanging/Changing context

============
6-3， 
I. Add RT , absolute value of criterion and odds 
II. add position coding. with position code, there has to be same number of study and test

delete position coding

- change u_star, store better at beginning.

6-3-1: unchange and change both drift
- add primacy affect: add n_grade, change u_star to have a gradient

6-4-2: add firststg_allctx, change two functions calculate_two_step_likelihood
add a function fast_concat, find vcat to be slow
----------------------------------------------------
! Tjos versopm os ,pdofoed frp, 6.5-3d_debug new by shiffrin.jl
    4-3 version: found the porblem of why having the dip in initial test: the starting of each list necessarily would have more
#   item from previous lists, so the activation from the current list would be lower than the activation from the piror list

However, the problem is still unknown about where there is a dip in the inital test between list results

I.  in inital test, take off the probing of the changing context, see what happens, see if needs to add proportion
    of changing context throughout lists

--------------
Delete all println from   "JL_V6-4-3  new by shifrin_printLogSave.jl"
---------------
modify from JL_V6-4-4.jl 
- attempt to improve on final test prediction

- Puzzle appear and now I want to print and know how much initial target were strenghtened
     - After printing ratio of strenghtened out of target number, the printed ratio seems to be close to 1, which makes sense, so next reason need to be found

-!! To predict previous target > all others in final test, I added back intial test restorage of target context. -> it works and make T_target highest performance

- !! For final test prediction on previous foil and previous study only, 
    -I'm currently canceling the first position speciaty on its inital storage process (change to using u_star_context[end]);
    -  

- u_star_context controls the general  difference between target and foil largely! 

-- To predict inital cross of between list result (similar foil and target performance), I make list 1 to be special on !!  [content storage ustar]. 
    - Make u_star an array of n_lists, rather than n_words
    - Final test u_star are all using u_star[end] value
    -- ok this doesn't work well, try making context of first list  to be special 
    -- So I made u_star_context to be an array of n_lists, rather than n_words as well!
    -- inside usage of u_star_context is changed everywhere to be u_star_context[list_num] 
    -To make initial test primacy effect: see if content storage of first item. 

    - On line 378, made first test position special as welll (+plus 0.05)


    -- !!! change generate_finalt_probes(...) funciton, to make its random condition to have a list number as well.  

---------------------------------------------------------------------
Modified from JL_V6-4-1.jl
    -- Plot finall test by intial study/test number
    ok. this is a buggy and useless file. I thought I didn't have studypos stored. but I actually do. I took at least an hour to work on this and realized that I had it originally anyways.

------------------------------
6-5, modified on 6-4-2_use : a workable version

1. make initilal advantage for only changing 
and ! inital advantage is only that in study store, not testing restore.change that in store_episodic_image

2. in plotting, add that by test position
----------------------------

3. add new trace when didn't pass threshold of recall

Try:
1. don't reinstate unchage context - won't work
-----------------
debug version!!
!! Found that the part of [adding new trace when old and didn't pass threshold] was wrong in restore_intest

- the only one more thing: 
to get T_foil stored better at intial testing, see if it fixes final test prediction

---------------------
change from 6-6finalize, 
    - my own suggestion (for final test)
    1. make p_final_list_change >> p_initial (this will cause forward context pass more toward list 10), but might be small
    2. Strenghen more content in final test=> this  

    3. Foward recency effect: increase p_final (> p_initial) , makes later test num pass traces go UP 

Rich suggestion:
    1. increase storage of foil in final test as well
        variable u_advFoilInitialT; line 1147 => this will theoretically make more foil pass first stage filter. But acutally, it doesn't work well.

** Also found that final test hasn't adjusted to have old that didn't pass threshold to have traces added

--------------
For E3 prediction trys:
!Error: Final Test Context Old should be restored as well! I forgot this was changed ealier for inital test. Modified to make final test restorage exist.
!!Notice: Current final test restorage prob for content and ctx are perfect (1) ; but this in final test won't give much OI
!!Explain: why not probe with UC context initial: if so, recall start with MORE traces (pass first filter) from prior list. => makes the BUMP ; but this is

1. to make strenghten of final test T more, see if it makes later target performance drop -- doesn't work well even with p=1
2. to make intial test restore old more; cancel criterion change;

- match the change log file
=========================================================================================================== =#



using Base

using RCall

using Random, Distributions, Statistics, DataFrames, DataFramesMeta
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
Threads.nthreads()
# JULIA_NUM_THREADS=8 julia
function printimg(img, img2)
    tt1 = img.word.word_features
    tt12 = img2.word.word_features
    tt2 = [img.context_features[i].value for i in eachindex(img.context_features)]
    tt22 = [img2.context_features[i].value for i in eachindex(img2.context_features)]
    tt3 = [img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item, DataFrame(word1=tt1, word2=tt12), DataFrame(fval1=tt2, fval2=tt22, feature_type=tt3))
end

function printimg(img)
    tt1 = img.word.word_features
    tt2 = [img.context_features[i].value for i in eachindex(img.context_features)]
    tt3 = [img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item, DataFrame(word1=tt1), DataFrame(fval1=tt2, feature_type=tt3))
end

function fast_concat(vectors::Vector{Vector{T}}) where {T}
    total_length = sum(length(v) for v in vectors)  # Compute total length
    result = Vector{T}(undef, total_length)  # Preallocate memory

    pos = 1
    for v in vectors
        copyto!(result, pos, v, 1, length(v))  # Copy each vector
        pos += length(v)
    end

    return result
end

function printimgpool(image_pool)
    word_features_list = []  # Store word features for each image
    feature_values = []
    feature_types = []

    for img in image_pool
        push!(word_features_list, img.word.word_features)
        push!(feature_values, [cf.value for cf in img.context_features])
        push!(feature_types, [cf.type for cf in img.context_features])
    end

    word_df = DataFrame(word_features_list, :auto)
    feature_df = DataFrame(feature_values, :auto)
    insertcols!(feature_df, 1, :ft => feature_types[1])

    return (word_df, feature_df)
end
# printimgpool(image_pool)

# recall_odds_threshold = 1e5;
recall_odds_threshold = 100;
p_recallFeatureStore = 0.85;

printword(wordimg) = [wordimg[i].word_features for i in eachindex(wordimg)];
printfeature(ft) = [[ft[i][j].value for j in eachindex(ft[1])] for i in eachindex(ft)];

const w_context = 50; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_positioncode = 0
w_allcontext = w_context + w_positioncode
ratio_U = 0.5 #ratio of general(unchanging) context

nU = round(Int, w_context * ratio_U)
nC = w_context - nU



is_finaltest = true
n_simulations = is_finaltest ? 20 : 20;
# n_simulations= 50v
context_tau = 100#foil odds should lower than this  
firststg_allctx = false; #cancle this
firststg_allctx2 = false;
is_test_allcontext = false #include general context? not testing all context in intial test
is_test_allcontext2 = true #is testing all context in final testZ
is_test_changecontext2 = false #is testing only change context in final test



is_restore_context = false # currently don't want to restore context features, only add new context features tarce

w_word = 25;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 
is_firststage = true;

is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist = false; #this is discarded currently

const n_probes = 20; # Number of probes to test
const n_lists = 10;
# const n_words = 40;
const n_words = n_probes;

criterion_initial = LinRange(1, 0.25, n_probes);#the bigger the later number, more close hits and CR merges. control merging  
# criterion_initial = ones(n_probes)*1;#the bigger the later number, more close hits and CR merges. control merging  

p_poscode_change = 0.1
p_reinstate_context = 0.8 #stop reinstate after how much features


#p_driftAndListChange should be used for both within-list drift and between-list change
#7, 10 IS A COMBINATION
n_driftStudyTest = round.(Int, ones(10) * 9) #7
n_between_listchange = 12; #5;15; 
const p_driftAndListChange = 0.03; # studied prior list probability change 

p_reinstate_rate = 0.5#0.4 #prob of reinstatement


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
u_star = vcat(0.06, ones(n_lists-1) * 0.06)
# u_star = ones(n_words)*0.04; # Probability of storage 
u_star_storeintest = u_star #for word # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence


# u_star_context = vcat(LinRange(0.08, 0.08, n_grade), ones(n_words - n_grade) .* 0.045) # currently make inital storage, restorage to have the last u_star_context value. The strenghtened item has its own parameter prob store.  
# u_star_context=vcat(0.08, ones(n_lists-1)*0.045)
u_star_context=vcat(0.08, ones(n_lists-1)*0.05)

const n_units_time = 13#number of steps                                                                                                                                                                                                                        
n_units_time_restore = n_units_time #only applies for adding traces now. 
n_units_time_restore_t = n_units_time_restore  # -3
n_units_time_restore_f = n_units_time_restore_t # -3
# n_units_time_restore = n_units_time + 10

const is_store_mismatch = true; #if mismatched value is restored during test
const n_finalprobs = 420;
const c = 0.75 #coying parameter - 0.8 for context copying 


range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling
# const w_context =60; #first half normal context, second half change context, third half word-change context


const c_storeintest = c

# const u_star_context = u_star # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
const c_context = c

# const context_tau_f = 20;
# -------------------------------
# criterion_final = LinRange(0.165, 0.24, 10)
is_restore_initial = true
is_UnchangeCtxDriftAndReinstate = true

criterion_final = LinRange(0.18, 0.23, 10)
final_gap_change = 0.2; #0.21

context_tau_final = 100 #0.20.2 above if this is 10
is_restore_final = true#followed by the next
is_onlyaddtrace_final = false

p_ListChange_finaltest = ones(10) * 0.55 #0.1 prob list change for final test

ratio_C_final = 0.1 #ratio of changing context used in final
nU_f = nU;#allunchange is used
nC_f = round(Int, nU_f / (1 - ratio_C_final) * ratio_C_final)

#the advatage of foil in inital test (to make final T prediciton overlap)
u_advFoilInitialT = 0;
#===============================================
===============================================#
# Data Structures                         
struct Word
    item::String
    word_features::Vector{Int64}
    type::Symbol
    studypos::Int64
end


mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64
    initial_testpos_img::Int64
    # function EpisodicImage(word::Word,context_features::Vector{Int64},list_number::Int64, initial_testpos_img::Int64=0)
    #     return EpisodicImage(word, context_features, list_number, initial_testpos_img)
    # end
end

ceil(Int, 43 / 42)
ceil(Int, (43 - 1) / 42)

struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
    initial_testpos::Int64
    # initial_studypos::Int64
    
end

a = [1 1 1; 1 1 1]

# Constructor with default value for final_testpos
# function Probe(image::EpisodicImage, classification::Symbol, initial_testpos::Int64=0)
#     return Probe(image, classification, initial_testpos, initial_testpos)
# end



# Functions

function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int)::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target, :T_nontarget], [Int(n_probes / 2), Int(n_probes / 2)])) |> shuffle!

    for i in 1:n_words

        word_list[i] = Word("Word$(i)L$(list_num)", rand(Geometric(g_word), w_word) .+ 1, types[i], i)
    end


    return word_list
end

#    @time generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    @profile generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    Profile.print()
#    @time generate_study_list2(n_words, w_context, w_word, g_context, g_word, p_change);

# tempword1, tf1= generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change,1);
# printfeature(tf1)

#    word_list, word_change_feature_list =  generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);


function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    # println(length(context_features))
    # intial_testpos_img, initilaize with 0, change whatever it is in probe creating. Well, the probe is created independently anyways
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type, word.studypos), zeros(length(context_features)), list_num, 0) # Zero word features

    for _ in 1:n_units_time
        for i in eachindex(new_image.word.word_features)
            j = new_image.word.word_features[i]

            # copystore_process(new_image,j,u_star,)
            if j == 0 # if nothing is stored
                stored_val = (rand() < u_star[list_num] ? 1 : 0) * word.word_features[i]
                # if list_num==1
                #     stored_val =(rand() < u_star[word.studypos]-0.02 ? 1 : 0)*word.word_features[i];
                # else stored_val =(rand() < u_star[word.studypos] ? 1 : 0)*word.word_features[i];
                # end
                if stored_val != 0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c ? stored_val : rand(Geometric(g_word)) + 1
                    new_image.word.word_features[i] = copied_val
                end
            end
        end

        # a[length(a)/2]1-3 4-7; 3,3
        for ic in eachindex(new_image.context_features)
        # for ic in eachindex() #only change context features, not unchange context features
            j = new_image.context_features[ic]

            if j == 0 # if nothing is stored
                # stored_val =(rand() < u_star_context[word.studypos] ? 1 : 0)*context_features[ic];
                if (list_num == 1) & (ic>nU) #only for changing 
                    if (word.studypos==1) & (ic>nU)
                        stored_val = (rand() < u_star_context[list_num]+0.05 ? 1 : 0) * context_features[ic]
                    else
                    
                    
                        stored_val = (rand() < u_star_context[list_num] ? 1 : 0) * context_features[ic]
                    end
                    # stored_val = (rand() < u_star_context[word.studypos] ? 1 : 0) * context_features[ic]
                else
                    if (word.studypos==1) & (ic>nU)
                        stored_val = (rand() < u_star_context[end]+0.05 ? 1 : 0) * context_features[ic]
                    else
                        
                        stored_val = (rand() < u_star_context[end] ? 1 : 0) * context_features[ic]
                    end
                    # stored_val = (rand() < u_star_context[word.studypos] ? 1 : 0) * context_features[ic]

                end
                if stored_val != 0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context ? stored_val : rand(Geometric(g_context)) + 1
                    new_image.context_features[ic] = copied_val
                end
            end

        end
        # println("Word Features: ", new_image.word.word_features)
    end

    push!(image_pool, new_image)

    # println("Studied word: ", new_image.word.item, " List: ", new_image.list_number, " Study Position: ", new_image.word.studypos," ",[iimg.word.item for iimg in image_pool])
    # println("Word Features: ", new_image.word.word_features)

    # return image_pool
end

# image_pool = [];
# context_features = []; # Initialize context features
# for i in eachindex(tempword1)
#     store_episodic_image(image_pool, tempword1[i], tf1[i], u_star, c, n_units_time, g_word, g_context, 1);
# end
# printimg(image_pool[2])

## this function only do word_change_features for last word studied, then keeps the same?

"""generate probe for inital test for a given list,
input: studied word list; context features (word_change will modifed from the current list last word's context features)
Return: probe

list_change_features: list feature, same as studied one
test_list_context: changed RI after study, continuous reinstate in test
"""
function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64}, test_list_context::Vector{Int64}, general_context_features::Vector{Int64}, test_list_context_unchange::Vector{Int64}, position_code_all::Vector{Vector{Int64}}, list_num::Int64,studied_pool::Vector{EpisodicImage} )::Vector{Probe}
    # here, not deep copy word_change_features is safe because even if it influence the original index, the word-change context features will be disgarded when this list ends  


    probetypes = repeat([:target, :foil], outer=div(n_probes, 2)) |> shuffle!
    probes = Vector{Probe}(undef, length(probetypes))

    words = filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy
    # println("List $(list_num)")
    # test
    stdpos  = 0;
    for i in eachindex(probetypes)
        # println("probe$(i)")
        if probetypes[i] == :target # 
            target_word = pop!(words) #pop from pre-decided targets
            stdpos += 1
            # testpos = 
        elseif probetypes[i] == :foil  # Foil case
            target_word = Word(randstring(8), generate_features(Geometric(g_word), w_word), :T_foil, 0) #insert studypos 0
        else
            error("probetypewrong")
        end

         # reinstate changing context: test_list_context
        nct = length(test_list_context)
        for ict in eachindex(test_list_context)
            if ict < Int(round(nct * p_reinstate_context)) #stop reinstate after a certain number of features

                if (test_list_context[ict] != list_change_features[ict]) & (rand() < p_reinstate_rate)
                    # println("here")
                    test_list_context[ict] = list_change_features[ict] #it's ok, change list_change_features[i] won't change left
                    # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                end
            else
                # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
            end
            # println("$(list_change_features)")
        end


        # reinstate unchange context test_list_context_unchange
        if is_UnchangeCtxDriftAndReinstate
            nct = length(test_list_context_unchange)
            for ict in eachindex(test_list_context_unchange)
                if ict < Int(round(nct * p_reinstate_context))

                    if (test_list_context_unchange[ict] != general_context_features[ict]) & (rand() < p_reinstate_rate)
                        # println("here")
                        test_list_context_unchange[ict] = general_context_features[ict] #it's ok, change list_change_features[i] won't change left
                        # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                    end
                else
                    # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
                end
                # println("$(list_change_features)")
            end
        end

        # println("$(test_list_context)")
        current_studypos = probetypes[i] == :target ? target_word.studypos : 0;

        current_testpos = i; 


        current_poscode = probetypes[i] == :target ? position_code_all[current_studypos] : rand(Geometric(g_context), w_positioncode) .+ 1
        # println("currentprobetype is $(probetypes[i]), position is $(current_studypos)")

        current_context_features = fast_concat([deepcopy(test_list_context_unchange), deepcopy(test_list_context), current_poscode]) #here needs a deepcopy, otherwise the front remembered context change with later ones  
        # current_context_features = deepcopy(test_list_context); #here needs a deepcopy, otherwise the front remembered context change with later ones  


        # probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], target_word.studypos ,i)
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num, current_testpos), probetypes[i] ,current_testpos)
        
        if probetypes[i] == :target

            matching_image = findfirst(img -> img.word.item == target_word.item, studied_pool)

            if matching_image !== nothing
                studied_pool[matching_image].initial_testpos_img = current_testpos #update the test position of the image in the studied pool
            else
                error("Image not found in studied pool")
            end
        end
        # println("List $(list_num),probe $(i)")
        # # println("contextf1 $(list_change_features)")
        # println("contextf2 $(current_context_features[31:end])")

    end


    return probes
end

# a = [1 2 3 4 5 6]
# b = [6 5 4 3 2 1]
# for i in 1:3
#     a[3]=b
#     println(a)
# end

# p1=generate_probes(word_list,  list_change_context_features, general_context_features,1);
# image_context2 = [cf.value for cf in word_change_feature_list[1]]
# image_context3 = [cf.value for cf in p1.context_features]



function calculate_likelihood_ratio(probe::Vector{Int64}, image::Vector{Int64}, g::Float64, c::Float64)::Float64

    lambda = Vector{Float64}(undef, length(probe))

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0
            lambda[k] = 1
        elseif image[k] != 0
            if image[k] != probe[k]# for those that doesn't match
                lambda[k] = 1 - c
                # println(1-c)
            elseif image[k] == probe[k]
                lambda[k] = (c + (1 - c) * g * (1 - g)^(image[k] - 1)) / (g * (1 - g)^(image[k] - 1))
            else
                error("error image match")
            end
        else
            error("error here")
        end
    end

    return prod(lambda)
end


# prdlikelihoodtbef=Array{Float64}(undef, 10000)
# prdlikelihoodti=Array{Float64}(undef, 10000)
# prdlikelihoodf=Array{Float64}(undef, 10000)
# for i in 1:10000
#     testrand = [rand(Geometric(g_word))+1 for _ in 1:20]
#     testrandnext = [rand(Geometric(g_word))+1 for _ in 1:20]
#     foili =  [rand(Geometric(g_word))+1 for _ in 1:20]
#     targetibef = [(rand()<0.3 ? testrand[ii] : rand(Geometric(g_word))+1) for ii in 1:20]
#     targeti = [rand()<0.2 ? 0 : targetibef[ii] for ii in 1:20]
#     # g=g_context
#     tallf=calculate_likelihood_ratio(foili,testrand,g_word,c)
#     talltbef=calculate_likelihood_ratio(targetibef,testrandnext,g_word,c) 
#     tallti=calculate_likelihood_ratio(targeti,testrandnext,g_word,c) 
#     prdlikelihoodf[i] = tallf
#     prdlikelihoodtbef[i] = talltbef
#     prdlikelihoodti[i] = tallti
#     if prdlikelihoodf[i]>1e10
#         println("$(prdlikelihoodf[i])")
#     end
# end
# println("f$(mean(prdlikelihoodtbef)),var$(var(prdlikelihoodtbef)),t$(mean(prdlikelihoodti)),var$(var(prdlikelihoodti))")
# #when there are more empty across all features, the likelihood ratio of current target is lower
# #when more empty, the likelihood_ratios for later target will be lower as well

# (1e200+1e2)/2
# (1e200+1e30+1e2)/3

# 20/2
# 30/(2.1)

# for i in eachindex(tall )
#     if tall[i]>10000
#         println(tall[i]," ", testrand[i])
#     end
# end

calculate_likelihood_ratio([2, 3, 4, 3], [0, 1, 0, 3], 0.4, 0.7)
calculate_likelihood_ratio([2, 3, 4, 3], [2, 2, 1, 0], 0.4, 0.7)
calculate_likelihood_ratio([6, 1, 1, 3], [2, 2, 1, 0], 0.4, 0.7)
calculate_likelihood_ratio([6, 1, 1, 3], [0, 1, 0, 3], 0.4, 0.7)


"""
Initial test stage
Input: A probe and the whole image_pool
adding the filter here
"""
function calculate_two_step_likelihoods(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        probe_context = probe.context_features
        image_context = image.context_features

        if firststg_allctx #false
            if is_test_allcontext  #here is secon  stage would be wrong, including position code, unchage, change
                # context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context]), fast_concat([image.word.word_features, image_context]), g_word, c)
            else  #not testing all context but change only, no unchange or position code
                error("not modifeid here")
                context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:w_context], image_context[nU+1:w_context], g_context, c)  # .#  Context calculation
            end
        else
            if is_test_allcontext  #here is secon  stage would be wrong, including position code, unchage, change

                error("testing all context is mistaken right here")
                # println(length(image_context))
                # img_ctx_now = image_context[nU+1: w_context]
                # context_likelihood = calculate_likelihood_ratio(probe_context,img_ctx_now,g_context,c )  # .#  Context calculation
            else  #not testing all context but change only, no unchange or position code
                context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:w_context], image_context[nU+1:w_context], g_context, c)  # .#  Context calculation
            end
        end
        # println(length(probe_context))
        context_likelihoods[ii] = context_likelihood

        if is_firststage

            # second stage
            if context_likelihood > context_tau # if pass context criterion 

                word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)

                # if iprobe !== 1 #CONTEXT FILTER: if not first probe tested, using the filter, 
                #     # taking  out the very low similarity word_likelihoods
                #     if word_likelihoods[ii] < tau_filter ##adding a filter
                #         word_likelihoods[ii]=344523466743
                #     end
                # end
            else
                # println("now")
                word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
            end
        else
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end


function calculate_two_step_likelihoods2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))
    probe_context = probe.context_features
    probe_context_f = fast_concat([probe_context[1:nU_f], probe_context[nU_f+1:nU_f+nC_f]])

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        image_context = image.context_features

        if firststg_allctx2 #false
            if is_test_allcontext2  #here is secon  stage would be wrong
                image_context_f = fast_concat([image_context[1:nU_f], image_context[nU_f+1:nU_f+nC_f]])
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context_f]), fast_concat([image.word.word_features, image_context_f]), g_context, c)  # .#  Context calculation
            elseif is_test_changecontext2
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context[nU+1:end]]), fast_concat([image.word.word_features, image_context[nU+1:end]]), g_context, c)
            else #only test general context (first part)
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context[1:nU]]), fast_concat([image.word.word_features, image_context[1:nU]]), g_context, c) #  Context calculation
            end
        else #is_test_allcontext2 true
            if is_test_allcontext2  #true; currently goes here
                image_context_f = fast_concat([image_context[1:nU_f], image_context[nU_f+1:nU_f+nC_f]])
                context_likelihood = calculate_likelihood_ratio(probe_context_f, image_context_f, g_context, c)  # .#  Context calculation
            elseif is_test_changecontext2 #false
                context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:end], image_context[nU+1:end], g_context, c)
            else #only test general context (first part)
                context_likelihood = calculate_likelihood_ratio(probe_context[1:nU], image_context[1:nU], g_context, c)  # .#  Context calculation
            end
        end

        context_likelihoods[ii] = context_likelihood

        if is_firststage

            # second stage
            if context_likelihood > context_tau_final # if pass context criterion 

                word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)

                # if iprobe !== 1 #CONTEXT FILTER: if not first probe tested, using the filter, 
                #     # taking  out the very low similarity word_likelihoods
                #     if word_likelihoods[ii] < tau_filter ##adding a filter
                #         word_likelihoods[ii]=344523466743
                #     end
                # end
            else
                # println("now")
                word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
            end
        else
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end


function probe_evaluation2(image_pool::Vector{EpisodicImage}, probes::Vector{Probe})::Array{Any}
    results = Array{Any}(undef, length(probes))
    # println("now#$(length(probes))")
    for i in eachindex(probes)

        # _, likelihood_ratios = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        if i == 1
            index = 1
        else
            index = searchsortedfirst(range_breaks_finalt, i) - 1
        end
        # println(index)
        # if index != -1
        #     P = P_s[index]
        # else
        #     error("Value out of range.")
        # end


        _, likelihood_ratios_org = calculate_two_step_likelihoods2(probes[i].image, image_pool, 1.0, i)
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end

        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        # println(round(odds, digits=3), " some llikelihood ", likelihood_ratios[1], " ", likelihood_ratios[2], ", Ndenom: ", length(likelihood_ratios));
        # round(odds, digits=3)
        # for ill in likelihood_ratios
        #     if ill > 1e5
        #         println("$(ill)")
        #         break
        #     end
        # end            
        # println(" ")

        crrchunk = ceil(Int, i / 42)
        criterion_final_i = criterion_final[crrchunk] #this need to be changed if 

        decision_isold = odds > criterion_final_i ? 1 : 0

        # pold = pcrr_EZddf(log(odds))
        rt = Brt + Pi * abs(log(odds))

        # Store results (modify as needed)
        results[i] = (decision_isold=decision_isold, is_target=string(probes[i].classification), odds=odds, list_num=probes[i].image.list_number, rt=rt, initial_studypos=probes[i].image.word.studypos, initial_testpos = probes[i].image.initial_testpos_img ) #! made changes to results, format different than that in inital

        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        if is_restore_final
            restore_intest_final(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, probes[i].classification, odds)
        end
    end

    return results
end


""" 
First stage
,test_list_context::Vector{Int64}
"""
function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe}, list_change_features::Vector{Int64}, general_context_features::Vector{Int64},simu_i::Int64)::Array{Any}

    unique_list_numbers = unique([image.list_number for image in image_pool])
    n_listimagepool = length(unique_list_numbers)
    results = Array{Any}(undef, n_probes * n_listimagepool)
    currentlist = probes[1].image.list_number
    image_pool_currentlist = image_pool

    for i in eachindex(probes)


        if is_onlytest_currentlist
            error("can't test only current list")
            image_pool_currentlist = filter(img -> img.list_number == currentlist, image_pool)#it's ok even when new probe were add to the image pool, because new probe has current list numebr as well. It will be kept
        else
            image_pool_currentlist = image_pool
        end
        # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")

        # calculate_two_step_likelihoods_rule2(probes[i].image, image_pool);
        _, likelihood_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool_currentlist, 1.0, i) #proportion is all
        # likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool); #proportion is all
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x)
        # println(length(likelihood_ratios_org)== length(image_pool_currentlist) )


        ilist_probe = probes[i].image.list_number
        i_testpos = probes[i].initial_testpos#1:20

        nl = length(likelihood_ratios)
        odds = 1 / nl * sum(likelihood_ratios)

        if (isnan(odds))
            println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, likelihood_ratios)
        end
        decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0
        diff = 1 / (abs(odds - criterion_initial[i_testpos]) + 1e-10)

        #criterion change by test position

        # decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;

        nav = length(likelihood_ratios) / (length(image_pool_currentlist))
        # println(nav)
        if (decision_isold == 1) && (odds > recall_odds_threshold)
            imgMax = image_pool_currentlist[argmax(likelihood_ratios)]
        end

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            

            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, is_target=probes[i].classification, odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.studypos, diff=diff)
            # println(nl, " ",nimages_activated)
        end
    
        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);


        if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, probes[i].classification, list_change_features, general_context_features, odds, likelihood_ratios_org, simu_i, i) 
        end

        # println("i, $i, i_testpos, $i_testpos")



    end



    return results
end

"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
# flagn = Int64[];
# data_flag = Array{Vector{Any}}(undef, n_simulations)  # Create an array to hold vectors for each simulation
# for i in 1:n_simulations
#     data_flag[i] = Vector{Any}()  # Initialize each row as an empty vector
# end

function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)




    if is_onlyaddtrace
        error("not coded here")
    end
    #is_onlyaddtrace is false
    # println("nothere")

    if decision_isold==0

        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)

    elseif ((decision_isold == 1) & (odds <= recall_odds_threshold))

        # println("not passed",i probe_img.list_number)
        #give new 
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img) #here is the new image, not the one in the pool
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end



    # if new, context and content change, be added to the pool

    if (decision_isold == 0)

        for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                # if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                if (j == 0) 
                    iimage.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end


            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]

                if j == 0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04
                        iimage.context_features[ic] = rand() < u_star_context[end]+u_advFoilInitialT ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j

                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end
    end

    

    #if old, pass threshold, context and contet change, recall land strenghten

    if (decision_isold == 1) & (odds > recall_odds_threshold) #single parameter for missing or replacing


            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                # if j!=0
                    # if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    if (j == 0) #is only doing this once, so doesn't matter if j==0 or not..
                        # println("success")
                        # println("now",j,iprobe_img.word.word_features[i])
                        iimage.word.word_features[i] = rand() < p_recallFeatureStore ? iprobe_img.word.word_features[i] : j #p_recallFeatureStore

                    end
                # end
            end

            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]

                if (j == 0)|((j!=0) & (j!= iprobe_img.context_features[ic]) ) 
                    iimage.context_features[ic] = rand() < p_recallFeatureStore ? iprobe_img.context_features[ic] : j 
                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end

            # println("Likelihood After ",calculate_likelihood_ratio(iprobe_img.word.word_features, iimage.word.word_features, g_word, c))



            is_restore_context ? error("context restored in initial is not well written this part") : nothing
        # end

    # if old, dind't pass threshold, add new trace
    elseif (decision_isold == 1) & (odds <= recall_odds_threshold) 
        
        #didn't pass threshold, ADD new trace

        for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                if (j == 0) #delete later part
                    iimage.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end


            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]

                if j == 0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04

                        iimage.context_features[ic] = rand() < u_star_context[end] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j

                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end

    end


    if (decision_isold == 0) | ((decision_isold == 1) & (odds < recall_odds_threshold))
        push!(image_pool, iimage)
        # println("pass, decision_isold $(decision_isold); is pass $(odds < recall_odds_threshold)")

    end
    # if (decision_isold == 0) 
    #     push!(image_pool, iimage)
    # end



end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, odds::Float64, )
#     iimage = decision_isold == 1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)
# # println(iimage.initial_testpos_img)

    if decision_isold==0

        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)

    elseif ((decision_isold == 1) & (odds <= recall_odds_threshold))

        # println("not passed",i probe_img.list_number)
        #give new 
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img) #here is the new image, not the one in the pool
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end

    if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold))

        for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    iimage.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end


            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]

                if j == 0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04
                    # if iprobe_img.list_number == 1
                    # iimage.context_features[ic]
                    # println("iprobe_img.list_number $(iprobe_img.list_number)")
                    # u_star_context[iprobe_img.list_number]
                    iprobe_img.context_features[ic]
                        iimage.context_features[ic] = rand() < u_star_context[end] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j
                    # else
                        # iimage.context_features[ic] = rand() < u_star_context[end]+u_advFoilInitialT+0.1 ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j
                    # end
                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end
    end

    if !is_onlyaddtrace_final #true
        # error("Here")
        if (decision_isold == 1) & (odds > recall_odds_threshold) 
            # pass: strenghten
            #single parameter for missing or replacing
            # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

            if !is_store_mismatch
                error("current prog is not written when doesn't store mismatch")
            end

            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    # println("Pass here")
                    iimage.word.word_features[i] = rand() < 1 ? iprobe_img.word.word_features[i] : j #p_recallFeatureStore replace 1
                end
            end


            for _ in 1:n_units_time_restore_f
                for i in eachindex(iprobe_img.word.word_features)
                    j=iimage.word.word_features[i]

                    if decision_isold==1
                        if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                            iimage.word.word_features[i] = rand() < 1 ? (rand() < 1 ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
                        end
                    else
                    end
                end
            end

            is_restore_context ? error("context restored in initial is not well written this part") : nothing
        end

    end


    # if (decision_isold == 0)
    if (decision_isold == 0) | ((decision_isold == 1) & (odds < recall_odds_threshold))
        push!(image_pool, iimage)
    end


    # if decision_isold ==1 println("afterchange",iimage) end
end
# if stored sucessfully and copied suces - probeval
# if stored sucessfully and copied not suces - random val
# if not stored sucessfully - 0/keeps original value j 


"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes
    
    Add, make initial_testpos in probes
    """
function generate_finalt_probes(studied_pool::Array{EpisodicImage}, condition::Symbol, general_context_features::Vector{Int64}, list_change_context_features::Vector{Int64})::Vector{Probe}

    listcg = deepcopy(list_change_context_features)
    generalcg = deepcopy(general_context_features);
    # num_images = length(studied_pool)
    studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}()
    for img in studied_pool
        push!(get!(studyPool_Img_byList, img.list_number, Vector{EpisodicImage}()), img)
    end

# println(img.initial_testpos_img)

    lists = keys(studyPool_Img_byList) |> collect |> sort
    probes = Vector{Probe}()
    if condition == :backward
        lists = reverse(lists)
    elseif condition == :true_random

        # true random doesn't change list context during final test
        all_images = vcat(values(studyPool_Img_byList)...)  # Combine all lists
        shuffle!(all_images)  # Shuffle all images together
        studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}(1 => all_images)
        lists = keys(studyPool_Img_byList)
        # println(lists)
    end

    icount = 0
    for list_number in lists #lists is [1] for random condition
        icount += 1
        if (icount !=1) && (condition != :true_random)
            for cf in eachindex(listcg)
                if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
                    listcg[cf] = rand(Geometric(g_context)) + 1
                end
            end
        end


        # for cf in eachindex(generalcg)
        #     if rand() < 0.01 #cf.change_probability # this equals p_change
        #         generalcg[cf] = rand(Geometric(g_context)) + 1
        #     end
        # end

        # images hold pool_image of the current list, 
        images = studyPool_Img_byList[list_number]
        images_Tt = filter(img -> img.word.type == :T_target, images) |> shuffle!
        images_Tnt = filter(img -> img.word.type == :T_nontarget, images) |> shuffle!
        images_Tf = filter(img -> img.word.type == :T_foil, images) |> shuffle!

        # Generate targets from shuffled list and foils anew
        if condition != :true_random
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7, 7, 7, 21])) |> shuffle!
        else
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7, 7, 7, 21] .* 10)) |> shuffle!
        end

        # Flagging when iprobe_chunk changes value

        

        for iprobe in eachindex(probe) #iprobe is final test testing position (maybe in group)
        

            
            if condition == :true_random
                iprobe_chunk = ceil(Int, iprobe / 42)  # Divide 420 into 10 chunks, each with 42 probes

                #the following is to change context by chunk (of list) for random condition
                # don't change context when (list in iprobe == 1) ||

                if (iprobe!=1) && (iprobe_chunk != ceil(Int, (iprobe - 1) / 42))
                    
                    # println("iprobe ",iprobe, " iprobe_chunk ", iprobe_chunk, " flag ", iprobe_chunk != (ceil(Int, (iprobe - 1) / 42)))
                    for cf in eachindex(listcg)
                        if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
                            listcg[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end

                # for cf in eachindex(generalcg)
                #     if rand() < p_driftAndListChange_final_ #cf.change_probability # this equals p_change
                #         generalcg[cf] = rand(Geometric(g_context)) + 1
                #     end
                # end

            end

            global img = nothing  # Initialize img as nothing to refresh its value in each iteration

            crrcontext = fast_concat([deepcopy(generalcg), deepcopy(listcg)]);


            if probe[iprobe]==:T_target

                global img = pop!(images_Tt) #this way, natrually assigns list number by the orignal image number, 
                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number,
                     img.initial_testpos_img),:T_target, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number,
                    img.initial_testpos_img),:T_target, iprobe))
                end

            elseif probe[iprobe]==:T_nontarget

                global img = pop!(images_Tnt)
                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number, img.initial_testpos_img), :T_nontarget, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number, img.initial_testpos_img),:T_nontarget, iprobe))
                end

            elseif probe[iprobe]==:T_foil

                global img = pop!(images_Tf)


                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number, img.initial_testpos_img),:T_foil, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number, img.initial_testpos_img),:T_foil, iprobe))
                end

            elseif probe[iprobe]==:F

                global img = EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1, :F, 0), crrcontext, 0, 0)
                # for F, the list_number will always be only [1]
                push!(probes, Probe(img, :F, iprobe))  # Generate a new foil
            else
                error("probe type wrong!")
            end

        end

        # println([i.value for i in listcg])

    end


    return probes
end
# finalprobes = generate_finalt_probes(image_pool, :backward,general_context_features,list_change_context_features);
# printimgpool([i.image for i in finalprobes][[1,2,51]])

# printimgpool([i.image for i in probes][[1,2,51]])

function simulate_rem()
    # 1. Initialization

    df_inital = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_iimageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], study_position=Int[], diff_rt=Float64[] )

    df_final = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], condition=Symbol[], decision_isold=Int[], is_target=String[], odds=Float64[], rt=Float64[], initial_studypos=Int[], initial_testpos = Int[], study_pos=Float64[])

    for sim_num in 1:n_simulations

        #    sim_num=1
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, n_probes + Int(n_probes / 2), n_lists) #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = rand(Geometric(g_context), nU) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)] 
        list_change_context_features = rand(Geometric(g_context), nC) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]



        for list_num in 1:n_lists

            position_code_all = [fill(0, w_positioncode) for _ in 1:n_words]


            word_list = generate_study_list(list_num) #::Vector{Word}
            # word_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1;

            for j in eachindex(word_list)

                if j == 1
                    position_code_features_study = rand(Geometric(g_context), w_positioncode) .+ 1
                else
                    position_code_features_study = deepcopy(position_code_all[j-1])
                    for ij in 1:w_positioncode
                        if rand() < p_poscode_change * (j - 1) #cf.change_probability # this equals p_change
                            position_code_features_study[ij] = rand(Geometric(g_context)) + 1
                        end
                    end
                    # println("previous code$(position_code_all[j-1]),current code$(position_code_features_study)")
                end

                position_code_all[j] = position_code_features_study
                current_context_features = fast_concat([deepcopy(general_context_features), deepcopy(list_change_context_features), position_code_features_study])
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num, 0)

                # study in here
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num)

                # for cf in eachindex(word_change_context_features)
                #     if rand() <  p_wordchange #cf.change_probability # this equals p_change
                #         word_change_context_features[cf] = rand(Geometric(g_context)) + 1 
                #     end
                # end

                # target and nontarget stored into studied pool 
                studied_pool[j, list_num] = episodic_image
            end

            # study_list_context = deepcopy(list_change_context_features);
            test_list_context = deepcopy(list_change_context_features)
            test_list_context_unchange = deepcopy(general_context_features)

            # list_change_context_features only change between lists, change after each list;
            # list_change_context_features use as a record, to reinstate in probe generation 
            # test_list_context change between study and test, & change/reinstate after each test, discard after each list;

             #context drift below for both 
            for _ in 1:n_driftStudyTest[list_num]

                # drift for changing context
                for cf in eachindex(test_list_context)
                    if rand() < p_driftAndListChange #cf.change_probability # this equals p_change
                        test_list_context[cf] = rand(Geometric(g_context)) + 1
                    end
                end

                # drift for unchanging context
                if is_UnchangeCtxDriftAndReinstate
                    for cf in eachindex(test_list_context_unchange)
                        if rand() < p_driftAndListChange
                            test_list_context_unchange[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end
            end

            #studied_pool[:, list_num]
            # studied_pool[j, list_num]
            # println(studied_pool)#studdied pool has length of 30, so only take first 20
            probes = generate_probes(word_list, list_change_context_features, test_list_context, general_context_features, test_list_context_unchange, position_code_all, list_num, studied_pool[1:n_probes,list_num]) #probe number is current list number, get probes of current list 
            

            # println("ImagePoolNow", [i.word.item for i in image_pool])
            # println("list $(list_num), ")
            @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes / 2) "wrong number!"
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"

            # foil stored
            #    println(studied_pool[list_num,20])
            #    println(studied_pool[list_num,21])
            studied_pool[n_words+1:n_words+Int(n_words / 2), list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)]
            results = probe_evaluation(image_pool, probes, list_change_context_features, general_context_features, sim_num)
            # println("ImagePoolNow", [i.word.item for i in image_pool])
            

            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, res.testpos, sim_num, res.decision_isold, tt, res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff] # Add more fields as needed
                # results[]=(decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, Nratio_iprobe = nav);
                # odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], ilist_image = Int[])
                push!(df_inital, row)
            end
            # Update list_change_context_features 
            for _ in 1:n_between_listchange
                for cf in eachindex(list_change_context_features)
                    if rand() < p_driftAndListChange #cf.change_probability # this equals p_change
                        list_change_context_features[cf] = rand(Geometric(g_context)) + 1
                    end
                end
            end
            # list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_driAndndListChange,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])

        end

        studied_pool = [studied_pool...]
        #final test here


        for ccf in eachindex(general_context_features)
            if rand() < final_gap_change #cf.change_probability # this equals p_change
                general_context_features[ccf] = rand(Geometric(g_context)) + 1
            end
        end

        # list_change_context_features
        for ccf in eachindex(list_change_context_features)
            if rand() < final_gap_change #cf.change_probability # this equals p_change
                list_change_context_features[ccf] = rand(Geometric(g_context)) + 1
            end
        end

        if is_finaltest
            for icondition in [:forward, :backward, :true_random]
                image_pool_bc = deepcopy(image_pool)
                finalprobes = generate_finalt_probes(studied_pool, icondition, general_context_features, list_change_context_features)
                results_final = probe_evaluation2(image_pool_bc, finalprobes)
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds, res.rt, res.initial_studypos, res.initial_testpos, res.initial_studypos])
                end
            end
        end


    end

    return df_inital, df_final
end


# @benchmark simulate_rem()

all_results, allresf = simulate_rem()
# all_results 
DF = @chain all_results begin
    @by([:list_number, :is_target, :test_position, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position], :meanx = mean(:meanx))
end

if is_finaltest
    DFf = @chain allresf begin
        @by([:list_number, :is_target, :test_position, :condition, :simulation_number], :meanx = mean(:decision_isold))
        @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))
        @transform(:condition = string.(:condition))
    end



    allresf = @chain allresf begin
        @transform(:condition = string.(:condition))
    end
end
# DFf
# using CSV
# CSV.write("temp.csv", DF)

# using RCall
# R"""
# library(ggplot2)
# ggplot()

# """
using DataFrames, CSV
@rput DF
@rput all_results #all intial results
# using RCall
# RCall.RBin
# Write to a temporary CSV file
csv_path1 = "DF.csv"
csv_path2 = "all_results.csv"
csv_path3 = "allresf.csv"
CSV.write(csv_path1, DF)
CSV.write(csv_path2, all_results)

run(`Rscript R_plots.r`)

if is_finaltest
    CSV.write(csv_path3, allresf)
    run(`Rscript R_plots_finalt.r`)
end
run(`bash -c "feh plot1.png &"`)
run(`bash -c "feh plot2.png &"`)