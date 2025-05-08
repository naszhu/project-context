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
2. (predicting merge) delete tau_filter, add criterion_initial, change criterion by testpos
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
const p_listchange_finaltest =0 #probe probability change for context
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
=========================================================================================================== =#

using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
function printimg(img, img2) 
    tt1=img.word.word_features
    tt12 = img2.word.word_features
    tt2=[img.context_features[i].value for i in eachindex(img.context_features)]
    tt22=[img2.context_features[i].value for i in eachindex(img2.context_features)]
    tt3=[img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item,DataFrame(word1=tt1, word2=tt12), DataFrame(fval1=tt2,fval2=tt22,feature_type=tt3))
end

function printimg(img) 
    tt1=img.word.word_features
    tt2=[img.context_features[i].value for i in eachindex(img.context_features)]
    tt3=[img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item,DataFrame(word1=tt1), DataFrame(fval1=tt2,feature_type=tt3))
end

function fast_concat(vectors::Vector{Vector{T}}) where T
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

printword(wordimg)  = [wordimg[i].word_features for i in eachindex(wordimg)];
printfeature(ft) = [[ft[i][j].value for j in eachindex(ft[1])] for i in eachindex(ft)];

const w_context =50; #first half unchange context, second half change context, third half word-change context
w_positioncode=0
w_allcontext=w_context+w_positioncode
ratio_U=0.5 #ratio of general(unchanging) context
ratio_C_final=0.1 #ratio of changing context
nU = round(Int,w_context*ratio_U)
nC = w_context-nU
nU_f=nU;#allunchange is used
nC_f=round(Int,nU_f/(1-ratio_C_final)*ratio_C_final)


is_finaltest = true;
n_simulations= 50
context_tau = 100
firststg_allctx=false; #cancle this
firststg_allctx2=false;
is_test_allcontext = true #include general context? not testing all context in intial test
is_test_allcontext2 = true #is testing all context in final test
is_test_changecontext2 = false #is testing only change context in final test
# p_listchange_finaltest = LinRange(0.06,0.01, 10)
p_listchange_finaltest = LinRange(0.06,0.01, 10)
# p_listchange_finaltest = ones(10)*0.06 #0.1 prob list change for final test
# p_listchange_finaltest = ones(10)*0.00 #probe probability change for context
# criterion_final = 0.25#0.5
criterion_final = LinRange(0.38, 0.5, 10) #LinRange(0.22, 0.37, 10) to p_listchange_finaltest 0.1 ;  LinRange(0.34, 0.4, 10) vs 0.06
# p_listchange_finaltest = ones(10)*0.06 #probe probability change for context
# criterion_final = 0.05
final_gap_change = 0.03;
context_tau_final = 100 #0.20.2 above if this is 10
# criterion_final = 0.4 # the following 2 are for is_test_allcontext2=true
# p_listchange_finaltest =0.4 #probe probability change for context
is_restore_final=true#followed by the next
is_onlyaddtrace_final=true
is_restore_initial=true

is_restore_context = false # currently don't want to restore context features, only add new context features tarce

w_word = 25;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 
is_firststage = true;

is_onlyaddtrace = false; #*add but not strengtening trace
is_onlytest_currentlist=false; #this is discarded currently

const n_probes = 20; # Number of probes to test
const n_lists = 10;
# const n_words = 40;
const n_words = n_probes;
# criterion_initial =  vcat(LinRange(1, 0.6, 20),ones(n_probes-min(20,n_probes)).-0.4) #change by test position
# criterion_initial =  vcat(LinRange(2, 1, 20),ones(n_probes-min(20,n_probes)).-0.4) #change by test position
# criterion_initial=ones(n_probes)
# criterion_initial =  LinRange(1, 0.7, n_probes);
criterion_initial =  LinRange(1, 0.55, n_probes);#the bigger the later number, more close hits and CR merges. control merging  

p_poscode_change = 0.1
p_reinstate_context = 0.8 #stop reinstate after how much features
# n_studytest_change = 12;
# n_between_listchange = 5;
# n_studytest_change = 15;#20
# n_studytest_change = round.(Int, range(5, stop=35, length=10))
# n_studytest_change = round.(Int, range(2, stop=35, length=10)) 
# n_studytest_change = round.(Int,ones(10)*25)
n_studytest_change = round.(Int,ones(10)*5)
# n_between_listchange =8; #15
# n_between_listchange =15; #15
n_between_listchange =5; #5;15; 
# n_between_listchange =8; #15
const p_listchange = 0.03; # studied prior list probability change 
#n_ri and n_between_listchange use p_listchange at the same time
p_reinstate_rate = 0.4 #prob of reinstatement
    # n_studytest_change = round.(Int,ones(10)*25)
    println("prob of each feature change between list $(1-(1-p_listchange)^n_between_listchange)")
    println("prob of each feature drift between study and test $(1-(1-p_listchange)^n_studytest_change[1])")
    aa=(1-(1-p_listchange)^n_between_listchange);
    println("prob of feature change after 4 lists $(1-(1-aa)^8)")
    println("prob of each all features had changed after 5 $(1-(1-p_reinstate_rate)^5)")
# criterion_initial =  ones(20);
# (1-(1-0.04)^10)
const g_word = 0.4; #geometric base rate
const g_context = 0.3; #0.3 originallly geometric base rate of context, or 0.2
# const u_star = 0.04; # Probability of storage 
n_grade=2 #only first to be special 
# u_star = vcat(LinRange(0.05, 0.04, n_grade),ones(n_words-n_grade).*0.04); # Probability of storage 
# u_star = vcat(0.05,ones(n_words)*0.04)
u_star = vcat(0.08,ones(n_words)*0.07)
# u_star = ones(n_words)*0.04; # Probability of storage 
u_star_storeintest = u_star #for word
# u_star_context = vcat(LinRange(0.1, 0.04, n_grade),ones(n_words-n_grade).*0.04) # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
u_star_context = vcat(LinRange(0.2, 0.1, n_grade),ones(n_words-n_grade).*0.04) # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence

const n_units_time = 10; #number of steps

n_units_time_restore_t = n_units_time  # -3
n_units_time_restore_f = n_units_time_restore_t-5 # -3
# n_units_time_restore = n_units_time + 10

const is_store_mismatch = false; #if mismatched value is restored during test
const n_finalprobs = 420;
const c = 0.8; #copying parameter - 0.8 for context copying 

# n_units_time_restore = n_units_time 

#the following changed magnitude of final test accuracy

# p_wordchange = 0.003 #0.008 in original REM
# n_wordchange_ST = 2 #80 in original REM number more between study and test
# either of these contribute to differences between list 


#only probing with change context in inital test， but this should be changed if a second stage is added 

# P_s = [0.2,0.25,0.3, 0.35,0.4,0.45, 0.49,0.993,0.999, 1] ;#proportion feature tested
# P_s = fill(1,10) #proportion feature tested this value used only in final test, intial test p=1
range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling
# const w_context =60; #first half normal context, second half change context, third half word-change context

# const p_change = 0.3;#this is not actually needed

const c_storeintest = c

# const u_star_context = u_star +0.03 
# const u_star_context = u_star # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
const c_context = c 

# const context_tau_f = 20;



#===============================================
===============================================#
# Data Structures                         
struct Word
    item::String
    word_features::Vector{Int64}
    type::Symbol
    studypos:: Int64
end


mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64
end

struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
    testpos:: Int64
end

# Functions
function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end


function generate_study_list(list_num::Int)::Vector{Word}
    
    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target, :T_nontarget], [Int(n_probes/2),Int(n_probes/2)])) |>shuffle! ;
    
    Threads.@threads for i in 1:n_words
        
        word_list[i] = Word("Word$(i)L$(list_num)", rand(Geometric(g_word), w_word) .+ 1, types[i],i) 
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
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type,word.studypos), zeros(length(context_features)), list_num) # Zero word features
    
    for _ in 1:n_units_time
        Threads.@threads for i in eachindex(new_image.word.word_features)
            j=new_image.word.word_features[i]
            
            # copystore_process(new_image,j,u_star,)
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star[word.studypos] ? 1 : 0)*word.word_features[i];
                # if list_num==1
                #     stored_val =(rand() < u_star[word.studypos]-0.02 ? 1 : 0)*word.word_features[i];
                # else stored_val =(rand() < u_star[word.studypos] ? 1 : 0)*word.word_features[i];
                # end
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c ? stored_val : rand(Geometric(g_word)) + 1;
                    new_image.word.word_features[i]=copied_val;
                end
            end
        end
        
        Threads.@threads for ic in eachindex(new_image.context_features)
            j = new_image.context_features[ic]
            
            if j==0 # if nothing is stored
                # stored_val =(rand() < u_star_context[word.studypos] ? 1 : 0)*context_features[ic];
                if list_num==1
                    stored_val =(rand() < u_star_context[word.studypos]+0.02 ? 1 : 0)*context_features[ic];
                else stored_val =(rand() < u_star_context[word.studypos] ? 1 : 0)*context_features[ic];
                end
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context ? stored_val : rand(Geometric(g_context)) + 1;
                    new_image.context_features[ic]=copied_val;
                end
            end
            
        end
        # println("Word Features: ", new_image.word.word_features)
    end
    
    push!(image_pool, new_image)
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
function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64},test_list_context::Vector{Int64}, general_context_features::Vector{Int64},test_list_context_unchange::Vector{Int64}, position_code_all::Vector{Vector{Int64}},list_num::Int64)::Vector{Probe}
    # here, not deep copy word_change_features is safe because even if it influence the original index, the word-change context features will be disgarded when this list ends  
    # current_context_features = vcat(general_context_features, list_change_features,word_change_features) ;
    
    # list_change_features_change = deepcopy(a);

    probetypes = repeat([:target, :foil], outer = div(n_probes,2)) |>shuffle! ;
    probes = Vector{Probe}(undef, length(probetypes));
    
    words = filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy;
    # println("List $(list_num)")
    for i in eachindex(probetypes)
        # println("probe$(i)")
        if probetypes[i] == :target # 
            target_word = pop!(words) #pop from pre-decided targets
        elseif probetypes[i] == :foil  # Foil case
            target_word = Word(randstring(8), generate_features(Geometric(g_word), w_word), :T_foil, 0) #insert studypos 0
        else
            error("probetypewrong")
        end

        # reinstate context test_list_context
        nct=length(test_list_context)
        for ict in eachindex(test_list_context)
            if ict < Int(round(nct*p_reinstate_context)) #stop reinstate after a certain number of features
                
                if (test_list_context[ict]!=list_change_features[ict]) & (rand() < p_reinstate_rate) 
                    # println("here")
                    test_list_context[ict]=list_change_features[ict] #it's ok, change list_change_features[i] won't change left
                    # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                end
            else 
                # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
            end
            # println("$(list_change_features)")
        end


        # reinstate context test_list_context
        nct=length(test_list_context_unchange)
        for ict in eachindex(test_list_context_unchange)
            if ict < Int(round(nct*p_reinstate_context))
                
                if (test_list_context_unchange[ict]!=general_context_features[ict]) & (rand() < p_reinstate_rate) 
                    # println("here")
                    test_list_context_unchange[ict]=general_context_features[ict] #it's ok, change list_change_features[i] won't change left
                    # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                end
            else 
                # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
            end
            # println("$(list_change_features)")
        end
        # println("$(test_list_context)")
        current_studypos= probetypes[i] == :target ? target_word.studypos : 0
        current_poscode= probetypes[i] == :target ? position_code_all[current_studypos] : rand(Geometric(g_context),w_positioncode) .+ 1;
        # println("currentprobetype is $(probetypes[i]), position is $(current_studypos)")

        current_context_features = fast_concat([deepcopy(test_list_context_unchange), deepcopy(test_list_context),current_poscode]) ; #here needs a deepcopy, otherwise the front remembered context change with later ones  
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], i)
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
    
    lambda = Vector{Float64}(undef, length(probe));
    
    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  
            lambda[k] = 1;
        elseif image[k] != 0 
            if image[k] != probe[k]# for those that doesn't match
                lambda[k] = 1-c;
                # println(1-c)
            elseif image[k] == probe[k]
                lambda[k] = (c + (1-c)*g*(1-g)^(image[k]-1))/(g*(1-g)^(image[k]-1));
            else 
                error("error image match")
            end
        else
            error("error here")
        end
    end
    
    return prod(lambda)
end

calculate_likelihood_ratio([2,3,4,3], [0,1,0,3], 0.4, 0.7)
calculate_likelihood_ratio([2,3,4,3], [2,2,1,0], 0.4, 0.7)
calculate_likelihood_ratio([6,1,1,3], [2,2,1,0], 0.4, 0.7)
calculate_likelihood_ratio([6,1,1,3], [0,1,0,3], 0.4, 0.7)


"""
Initial test stage
Input: A probe and the whole image_pool
adding the filter here
"""
function calculate_two_step_likelihoods(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64}, Vector{Float64}} 
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    
    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        probe_context = probe.context_features;
        image_context = image.context_features;

        if firststg_allctx
            if is_test_allcontext  #here is secon  stage would be wrong, including position code, unchage, change
                # context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
                context_likelihood=calculate_likelihood_ratio(fast_concat([probe.word.word_features,probe_context]), fast_concat([image.word.word_features,image_context]), g_word, c)
            else  #not testing all context but change only, no unchange or position code
                error("not modifeid here")
                context_likelihood = calculate_likelihood_ratio(probe_context[nU + 1 : w_context],image_context[nU + 1 : w_context],g_context,c )  # .#  Context calculation
            end
        else
            if is_test_allcontext  #here is secon  stage would be wrong, including position code, unchage, change
                context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
            else  #not testing all context but change only, no unchange or position code
                context_likelihood = calculate_likelihood_ratio(probe_context[nU + 1 : w_context],image_context[nU + 1 : w_context],g_context,c )  # .#  Context calculation
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


function calculate_two_step_likelihoods2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64}, Vector{Float64}} 
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    probe_context = probe.context_features;
    probe_context_f=fast_concat([probe_context[1:nU_f],probe_context[nU_f+1:nU_f+nC_f]])
    
    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        image_context = image.context_features;

        if firststg_allctx2
            if is_test_allcontext2  #here is secon  stage would be wrong
                image_context_f=fast_concat([image_context[1:nU_f],image_context[nU_f+1:nU_f+nC_f]])
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features,probe_context_f]),fast_concat([image.word.word_features,image_context_f]),g_context,c)  # .#  Context calculation
            elseif is_test_changecontext2  
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features,probe_context[nU+1:end]]),fast_concat([image.word.word_features,image_context[nU+1:end]]),g_context,c)
            else #only test general context (first part)
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features,probe_context[1:nU]]),fast_concat([image.word.word_features,image_context[1:nU]]),g_context,c) #  Context calculation
            end
        else
            if is_test_allcontext2  #here is secon  stage would be wrong
                image_context_f=fast_concat([image_context[1:nU_f],image_context[nU_f+1:nU_f+nC_f]])
                context_likelihood = calculate_likelihood_ratio(probe_context_f,image_context_f,g_context,c )  # .#  Context calculation
            elseif is_test_changecontext2  
                context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:end],image_context[nU+1:end],g_context,c ) 
            else #only test general context (first part)
                context_likelihood = calculate_likelihood_ratio(probe_context[1:nU],image_context[1:nU],g_context,c )  # .#  Context calculation
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
    results = Array{Any}(undef, length(probes));
    # println("now#$(length(probes))")
    for i in eachindex(probes)
        
        # _, likelihood_ratios = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        if i==1 index = 1 else index = searchsortedfirst(range_breaks_finalt, i) - 1 end
        # println(index)
        # if index != -1
        #     P = P_s[index]
        # else
        #     error("Value out of range.")
        # end


        _, likelihood_ratios = calculate_two_step_likelihoods2(probes[i].image, image_pool, 1.0,i)
        likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        
        crrchunk=ceil(Int,i/42);
        criterion_final_i = criterion_final[crrchunk] #this need to be changed if 

        decision_isold = odds > criterion_final_i ? 1 : 0

        # pold = pcrr_EZddf(log(odds))
        rt = Brt+Pi*abs(log(odds));
        
        # Store results (modify as needed)
        results[i] = (decision_isold = decision_isold, is_target = string(probes[i].classification), odds = odds, list_num = probes[i].image.list_number, rt = rt, initial_studypos=probes[i].image.word.studypos) #! made changes to results, format different than that in inital
        
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        if is_restore_final
           restore_intest_final(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, probes[i].classification);
        end
    end
    
    return results
end


""" 
First stage
,test_list_context::Vector{Int64}
"""
function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe},list_change_features::Vector{Int64},general_context_features::Vector{Int64} )::Array{Any}
    
    unique_list_numbers = unique([image.list_number for image in image_pool])
    n_listimagepool = length(unique_list_numbers)
    results = Array{Any}(undef, n_probes*n_listimagepool);
    currentlist=probes[1].image.list_number;
    image_pool_currentlist=image_pool

    # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")
    # for imgp in probes
    #     img=imgp.image
    #     println("List $(img.list_number), Word $(img.word.item), type $(img.word.type)")
    # end

    # for img in image_pool_currentlist
    #     println("List $(img.list_number), Word $(img.word.item), type $(img.word.type)")
    # end


    for i in eachindex(probes)
        
        if is_onlytest_currentlist
            image_pool_currentlist = filter(img -> img.list_number == currentlist, image_pool);#it's ok even when new probe were add to the image pool, because new probe has current list numebr as well. It will be kept
        else
            image_pool_currentlist=image_pool;
        end
            # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")
            
        # calculate_two_step_likelihoods_rule2(probes[i].image, image_pool);
        _, likelihood_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool_currentlist, 1.0, i); #proportion is all
        # likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool); #proportion is all
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x);
        
        
    
        ilist_probe = probes[i].image.list_number
        i_testpos=probes[i].testpos;#1:20

        nl = length(likelihood_ratios)
        odds = 1 / nl * sum(likelihood_ratios);

        # criterion in inital test, first list crietion lower
        # if ilist_probe==1
        #     decision_isold = odds > criterion_initial[i_testpos]-0.2 ? 1 : 0;
        # else
        #     decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;
        # end
        # println(criterion_initial)
        # if(isnan(odds)) println(nl,likelihood_ratios,likelihood_ratios_org)end
        if(isnan(odds)) println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step",nl,likelihood_ratios)end
        decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;
        diff = 1/ (abs(odds-criterion_initial[i_testpos])+1e-10)
        
        #criterion change by test position

        # decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;

        nav = length(likelihood_ratios)/(length(image_pool_currentlist))
        # println(nav)

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist);
            nimages_activated=count(ii -> (image_pool_currentlist[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist));

            results[n_listimagepool*(i-1)+j] = (decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, N_imageinlist=nimages_activated,Nratio_iprobe = nav, testpos = i, studypos=probes[i].image.word.studypos, diff=diff);
        end
        # println("item:",probes[i].image.word.item,mean_ctx)
        
        # if probes[i].image.list_number !=1
            # restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, probes[i].classification); #the current probe restored. 
        # end

        #adding a filter. 

        if is_restore_initial
            restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, probes[i].classification, list_change_features,general_context_features);
        end
        
    end
    
    
    
    return results
end

"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, probetype::Symbol,list_change_features::Vector{Int64},general_context_features::Vector{Int64})
    
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    # crr_all_contextf=[general_context_features;list_change_features];
   
    
    if is_onlyaddtrace #only start with empty if only add trace
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    else #full blood version 
        # println("nothere")
        iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 


        # The following is to test why there is non-monotonic change of target value
        # probe_word_item = iprobe_img.word.item
        # matching_image = findfirst(image -> image.word.item == probe_word_item, image_pool)

        # iimage = probetype == :target ? image_pool[matching_image] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 
        # if decision_isold==1 println("old", decision_isold,iimage) end
    end
    
    # if decision is old, the following change the image in image pool
    # if the decision is new, the following modify the new empty image
    
    # if onlyaddingtrace
    for _ in 1:n_units_time_restore_t
        
        for i in eachindex(iprobe_img.word.word_features)
            j=iimage.word.word_features[i]
    
            # if stored sucessfully and copied suces - probe val
            # if stored sucessfully and copied not suces - random val
            # if not stored sucessfully - 0/keeps original value j 
    
            # if nothing is stored; or old but something is stored, and when values doesn't match
            if decision_isold==1
                if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    iimage.word.word_features[i] = rand() < 1 ? (rand() < 1 ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
                end
            # else
            #     if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
            #         iimage.word.word_features[i] = rand() < u_star_context[2] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
            #     end
            end
        end
        
    end

    for _ in 1:n_units_time_restore_f
        
        for i in eachindex(iprobe_img.word.word_features)
            j=iimage.word.word_features[i]
    
            # if stored sucessfully and copied suces - probe val
            # if stored sucessfully and copied not suces - random val
            # if not stored sucessfully - 0/keeps original value j 
    
            # if nothing is stored; or old but something is stored, and when values doesn't match
            if decision_isold==1
                if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    iimage.word.word_features[i] = rand() < 1 ? (rand() < 1 ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
                end
            else
                if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    iimage.word.word_features[i] = rand() < u_star_context[2] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
                end
            end
        end




            
            
            
        # else #when don't strengten/restore context, then only store new context
            if decision_isold==0 #when new
                for ic in eachindex(iprobe_img.context_features)
                    j = iimage.context_features[ic]
                    
                    if j==0
                        # println(j,!is_onlyaddtrace)
                        #u_star_context to 0.04
                        if iprobe_img.list_number==1
                            iimage.context_features[ic] = rand() < u_star_context[1] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                        else
                            iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                        end
                        # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                    end

                end
            end
    end
    
    if (decision_isold == 0) | is_onlyaddtrace
        push!(image_pool,iimage);
    end
    
    # if decision_isold ==1 println("afterchange",iimage) end
end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, probetype::Symbol)
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    
    # iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    if is_onlyaddtrace #only start with empty if only add trace
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    else #full blood version 
        # println("nothere")
        iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    end
    
    for _ in 1:n_units_time_restore
        
        
        
        tf =  (iimage.word.word_features .== 0) .| ((iimage.word.word_features .!=0) .& (decision_isold .==1) .& (iimage.word.word_features .!= iprobe_img.word.word_features) .& is_store_mismatch .& (.!is_onlyaddtrace_final))

        iimage.word.word_features[tf] = ifelse.(rand(sum(tf)) .< u_star_storeintest[1], ifelse.(rand(sum(tf)) .< c_storeintest, iprobe_img.word.word_features[tf], rand(Geometric(g_context),sum(tf)) .+ 1), iimage.word.word_features[tf])

        
        if is_restore_context
            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]
                
                if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
                    # println(j,!is_onlyaddtrace)
                    iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end
                
            end
        else #when don't strengten context, then only store new context
            if decision_isold==0 #when new
                for ic in eachindex(iprobe_img.context_features)
                    j = iimage.context_features[ic]
                    
                    if j==0
                        # println(j,!is_onlyaddtrace)
                        iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                        # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                    end

                end
            # else

            end

        end

        # for ic in eachindex(iprobe_img.context_features)
        #     j = iimage.context_features[ic]
            
        #     if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
        #         # println(j,!is_onlyaddtrace)
        #         iimage.context_features[ic] = rand() < u_star_context ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
        #     end
            
        # end
    end
    

    
    # if (decision_isold == 0) | is_onlyaddtrace
    #     push!(image_pool,iimage);
    # end
    push!(image_pool,iimage);

    
    # if decision_isold ==1 println("afterchange",iimage) end
end
# if stored sucessfully and copied suces - probeval
# if stored sucessfully and copied not suces - random val
# if not stored sucessfully - 0/keeps original value j 


"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes"""
function generate_finalt_probes(studied_pool::Array{EpisodicImage}, condition::Symbol,general_context_features::Vector{Int64},list_change_context_features::Vector{Int64})::Vector{Probe}
    
    listcg = deepcopy(list_change_context_features)
    # num_images = length(studied_pool)
    list_images = Dict{Int64, Vector{EpisodicImage}}()
    for img in studied_pool
        push!(get!(list_images, img.list_number, Vector{EpisodicImage}()), img)
    end
    
    lists = keys(list_images) |> collect |>sort;
    probes = Vector{Probe}()
    if condition == :backward
        lists = reverse(lists)
    elseif condition == :true_random
        
        # true random doesn't change list context during final test
        all_images = vcat(values(list_images)...)  # Combine all lists
        shuffle!(all_images)  # Shuffle all images together
        list_images = Dict{Int64, Vector{EpisodicImage}}(1 => all_images)
        lists = keys(list_images)
    end 

    icount=0
    for list_number in lists
        icount+=1
        for cf in eachindex(listcg)
            if rand() <  p_listchange_finaltest[icount] #cf.change_probability # this equals p_change
                listcg[cf] = rand(Geometric(g_context)) + 1 
            end
        end
        
        
        images = list_images[list_number]
        images_Tt = filter(img -> img.word.type == :T_target, images) |> shuffle!;
        images_Tnt = filter(img -> img.word.type == :T_nontarget, images)|> shuffle!;
        images_Tf = filter(img -> img.word.type == :T_foil, images) |> shuffle!;
        
        # Generate targets from shuffled list and foils anew
        if condition != :true_random
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7,7,7,21])) |>shuffle! ;
        else 
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7,7,7,21].*10)) |>shuffle! ;
        end
        
        
        for iprobe in eachindex(probe)  
            crrcontext = fast_concat([general_context_features, deepcopy(listcg)]);
            if probe[iprobe]==:T_target
                push!(probes, Probe(EpisodicImage(pop!(images_Tt).word, crrcontext, list_number),:T_target, iprobe))
            elseif probe[iprobe]==:T_nontarget
                push!(probes, Probe(EpisodicImage(pop!(images_Tnt).word, crrcontext, list_number),:T_nontarget, iprobe))
            elseif probe[iprobe]==:T_foil
                push!(probes, Probe(EpisodicImage(pop!(images_Tf).word, crrcontext, list_number),:T_foil, iprobe))
            elseif probe[iprobe]==:F
                push!(probes, Probe(EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1, :F, 0), crrcontext, list_number),:F, iprobe))  # Generate a new foil
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
    
    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], N_imageinlist=Float64[], ilist_image = Int[], study_position=Int[], diff_rt=Float64[])
    df_final = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], condition = Symbol[], decision_isold = Int[], is_target = String[],odds = Float64[], rt = Float64[], initial_studypos=Int[])
    
    for sim_num in 1:n_simulations
        
        #    sim_num=1
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, n_probes+Int(n_probes/2),n_lists); #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = rand(Geometric(g_context),nU) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)] 
        list_change_context_features = rand(Geometric(g_context),nC) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]
        
        

        for list_num in 1:n_lists
    
            position_code_all = [fill(0, w_positioncode) for _ in 1:n_words];
            

            word_list = generate_study_list(list_num);
            # word_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1;
            
            for j in eachindex(word_list) 
                
                if j==1
                    position_code_features_study = rand(Geometric(g_context),w_positioncode) .+ 1;
                else
                    position_code_features_study = deepcopy(position_code_all[j-1]);
                    for ij in 1:w_positioncode
                        if rand() <  p_poscode_change*(j-1) #cf.change_probability # this equals p_change
                            position_code_features_study[ij] = rand(Geometric(g_context)) + 1 
                        end
                    end
                    # println("previous code$(position_code_all[j-1]),current code$(position_code_features_study)")
                end
                
                position_code_all[j]=position_code_features_study;
                current_context_features = fast_concat([deepcopy(general_context_features), deepcopy(list_change_context_features),position_code_features_study]);
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);

                # study in here
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num);
                
                # for cf in eachindex(word_change_context_features)
                #     if rand() <  p_wordchange #cf.change_probability # this equals p_change
                #         word_change_context_features[cf] = rand(Geometric(g_context)) + 1 
                #     end
                # end

                # target and nontarget stored into studied pool 
                studied_pool[j,list_num] = episodic_image;
            end

            # study_list_context = deepcopy(list_change_context_features);
            test_list_context = deepcopy(list_change_context_features);
            test_list_context_unchange = deepcopy(general_context_features);

            # list_change_context_features only change between lists, change after each list;
            # list_change_context_features use as a record, to reinstate in probe generation 
            # test_list_context change between study and test, & change/reinstate after each test, discard after each list;

            for _ in 1:n_studytest_change[list_num] #context drift
                for cf in eachindex(test_list_context)
                    if rand() <  p_listchange #cf.change_probability # this equals p_change
                        test_list_context[cf] = rand(Geometric(g_context)) + 1 
                    end
                end
                for cf in eachindex(test_list_context_unchange)
                    if rand()<p_listchange
                        test_list_context_unchange[cf]=rand(Geometric(g_context)) + 1 
                    end
                end
             end
            
            probes = generate_probes(word_list, list_change_context_features,test_list_context,general_context_features,test_list_context_unchange, position_code_all,list_num); #probe number is current list number, get probes of current list 
            # println("list $(list_num), ")
            @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes/2)  "wrong number!";
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"
            
            # foil stored
            #    println(studied_pool[list_num,20])
            #    println(studied_pool[list_num,21])
            studied_pool[n_words+1:n_words+Int(n_words/2),list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)] ;
            results = probe_evaluation(image_pool, probes,list_change_context_features,general_context_features);
            
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
                   if rand() <  p_listchange #cf.change_probability # this equals p_change
                       list_change_context_features[cf] = rand(Geometric(g_context)) + 1 
                   end
               end
            end
            # list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_listchange,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])
            
        end
        
        studied_pool = [studied_pool...];
        #final test here

        
        for ccf in eachindex(general_context_features)
            if rand() <  final_gap_change #cf.change_probability # this equals p_change
                general_context_features[ccf] = rand(Geometric(g_context)) + 1 
            end
        end

        if is_finaltest
            for icondition in [:forward, :backward, :true_random]
                image_pool_bc = deepcopy(image_pool);
                finalprobes = generate_finalt_probes(studied_pool, icondition,general_context_features,list_change_context_features);
                results_final = probe_evaluation2(image_pool_bc, finalprobes);
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds, res.rt, res.initial_studypos])
                end 
            end
        end
        
        
    end
    
    return df_inital, df_final
end


# @benchmark simulate_rem()

all_results, allresf  = simulate_rem()
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



    allresf = @chain allresf begin @transform(:condition = string.(:condition))end
end
# DFf
# using CSV
# CSV.write("temp.csv", DF)


@rput DF
@rput all_results #all intial results

R"""
library(dplyr)
library(ggplot2)
library(tidyr)
df1=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position)%>%
    mutate(meanx_m=mean(meanx))

p_in_20=ggplot(data=df1,aes(x=test_position,y=meanx,group=is_target))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+ylim(c(0.5,1))


df2=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(test_position,is_target,simulation_number,list_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,list_number)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,list_number)%>%
    mutate(meanx_m=mean(meanx))

p_in_20in10=ggplot(data=df2%>%filter(list_number==1),aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(list_number~.)

p_in_20in10

p_in_20in100=ggplot(data=df2,aes(x=test_position,y=meanx,group=interaction(list_number,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    # geom_point()+
    facet_grid(list_number~.)

p_in_20in100

df3=all_results%>%mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(listbreak=case_when(list_number<=5~1,TRUE~2))%>%
    group_by(test_position,is_target,simulation_number,listbreak)%>%
    summarize(meanx=mean(correct))%>%
    group_by(test_position,is_target,listbreak)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))%>%
    group_by(test_position,listbreak)%>%
    mutate(meanx_m=mean(meanx))
    
p_in_20in10_break2=ggplot(data=df3,aes(x=test_position,y=meanx,group=interaction(listbreak,is_target)))+
    geom_line(aes(color=is_target))+
    geom_line(aes(x=test_position,y=meanx_m),color="black")+
    geom_point()+
    facet_grid(listbreak~.)

    p_in_20in10_break2
    p_in_20in100
"""

# R"""
# head(all_results)
# DF3 = all_results %>% 
# mutate(is_target = case_when(is_target~ 1, TRUE ~ 0))%>%
# mutate(meanx = case_when(decision_isold==1 ~ is_target==decision_isold, TRUE ~ !(is_target==decision_isold)))%>%
# group_by(test_position,list_number,is_target, simulation_number)%>%
# summarize(meanx=mean(meanx))%>%
# group_by(test_position,list_number,is_target)%>%
# summarize(meanx=mean(meanx))%>%
# mutate(is_target=as.factor(is_target))
# # mutate(ilist_image=as.factor(ilist_image))
# # mutate(test_position=as.factor(test_position))

# p4=ggplot(data=DF3, aes(x=test_position,y=meanx, group=interaction(list_number,is_target)))+
# geom_point(aes(color=is_target))+
# geom_line(aes(color=is_target))+
# facet_grid(list_number~.)
# # geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
# # labs(title="Ratio of activated trace for 10 lists in 10 color")
# # scale_x_continuous(name="list",breaks = rev(1:10),labels=as.character(rev(1:10)))
# # scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) 
# # head(all_results)
# """

R"""
library(ggplot2)
library(dplyr)
library(gridExtra)

DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
ylim(c(0.65,1))+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")


DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
facet_grid(list_number~.)

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(Nratio_iprobe))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))

# mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))
p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx))+
geom_line(aes(x=list_number,y=meanx))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace in each list",y="N (number of activated trace)")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))

# head(all_results)
# Nratio_imageinlist, ilist_image
# p4

p2
"""


R"""
DF3 = all_results %>% 
group_by(list_number, simulation_number, ilist_image)%>%
# summarize(meanx=mean(Nratio_iimageinlist))%>%
summarize(meanx=mean(N_imageinlist))%>%
group_by(list_number, ilist_image)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.factor(list_number))
# mutate(ilist_image=as.factor(ilist_image))
# mutate(test_position=as.factor(test_position))

p4=ggplot(data=DF3, aes(x=ilist_image,y=meanx, group=list_number))+
geom_point(aes(color=list_number))+
geom_line(aes(color=list_number))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace for 10 lists in 10 color")+
# scale_x_continuous(name="list",breaks = rev(1:10),labels=as.character(rev(1:10)))
scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) 

"""
R"""
df_serial=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    group_by(study_position,is_target,simulation_number)%>%
    summarize(meanx=mean(correct))%>%
    group_by(study_position,is_target)%>%
    summarize(meanx=mean(meanx))%>%
    mutate(is_target=as.factor(is_target))

p_serial=ggplot(data=df_serial,aes(x=study_position,meanx))+
    geom_line(aes(color=is_target))+
    geom_point(size=2,aes(color=is_target))
    # ylim(c(0.75,1))

df_rt=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,test_position)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,test_position)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target))

testpos_rt=ggplot(data=df_rt,aes(x=test_position,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))


df_rt_list=all_results%>%
    mutate(is_target=case_when(is_target~1,TRUE~0),correct=decision_isold==is_target)%>%
    mutate(diff_rt=diff_rt^(1/11))%>%
    group_by(is_target,simulation_number,list_number)%>%
    summarize(rtm=mean(diff_rt))%>%
    group_by(is_target,list_number)%>%
    summarize(rt=mean(rtm))%>%
    mutate(is_target=as.factor(is_target),list_number=as.factor(list_number))

list_rt=ggplot(data=df_rt_list,aes(x=list_number,y=rt,group=interaction(is_target)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))

# df_rt

# names(all_results)

# grid.arrange(p4,p1,p_serial,p_in_20,p_in_20in10,p_in_20in10_break2,ncol = 2,nrow=3)
# grid.arrange(p4,p1,p_serial,p_in_20,p_in_20in10,testpos_rt,list_rt,ncol = 2,nrow=4)
# MARKING: inital test plots/figures here
grid.arrange(p1,list_rt,p_in_20,testpos_rt,p_serial,p4,ncol = 2,nrow=4)
# summary(all_results$diff_rt)
# df_rt_list

all_results%>%filter(!complete.cases(diff_rt))
# length(all_results$diff_rt)
"""
# sum((all_results.list_number.==9) .& (all_results.test_position.==1) .& (all_results.simulation_number.==2))
# all_results[(all_results.list_number.==9) .& (all_results.test_position.==1) .& (all_results.simulation_number.==2),:]
# a=all_results[(all_results.list_number.==9) .& (all_results.test_position.==1) .& (all_results.simulation_number.==2),:]
# sum( (all_results.simulation_number.==2) .& (all_results.list_number.==10))
# findall(isnan, all_results.odds)  

if is_finaltest 
    @rput allresf
    R"""
    # head(allresf)
    DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(test_position=as.numeric(test_position))%>%
    mutate(test_position_group=ntile(test_position,10))%>%
    group_by(test_position_group,is_target,condition)%>%
    summarize(meanx=mean(correct))

    p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)


    
    DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
    decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    mutate(list_number=as.numeric(list_number))%>%
    group_by(list_number,is_target,condition)%>%
    summarize(meanx=mean(correct))

  

    p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # ylim(c(0.5,1))+
    # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # allresf
    facet_grid(condition~.)# ylim(c(50,100))
    # grid.arrange(p10, p101,p1,p3 ,p_in_20,p_in_20in10,ncol = 2,nrow=3)
    # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)

    
    df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%ungroup()%>%select(-list_number)%>%
    full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
    mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
    select(-c("meanx.x","meanx.y"))%>%
    pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")

    ggplot(data=df_allfinal, aes(test_position_group,val,group=interaction(position_kind,condition,is_target)))+
        geom_point(aes(color=is_target,group=is_target))+
        geom_line(aes(color=is_target,group=is_target))+
        facet_grid(condition~position_kind)+
        labs(x="Final test position cut in 10 chunks (left column), Initial test list order (right column)",
            y="prediction (Hits/Correct Rejection)",
            caption="Figure 3. Between List Final Test Results seen in Final Testing",
            color="Type",fill="Type")+
        scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40) 
        )+ylim(c(0.3,1))

        # grid.arrange(p4,p1,p_serial,p_in_20,p10,p101,ncol = 2,nrow=3)

    # DF001

    # DF_fbyi = allresf %>% 
    #     mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
    #     # mutate(list_number=as.numeric(list_number))%>%
    #     group_by(initial_studypos,is_target,condition)%>%
    #     summarize(meanx=mean(correct))
    # DF_fbyi

    # ggplot(data=DF_fbyi,aes(x=initial_studypos,meanx))+
    #     geom_point(aes(color=is_target))+
    #     geom_line(aes(color=is_target))+
    #     facet_grid(condition~.)
    """
end


# all_results[all_results.list_number.!==all_results.ilist_image,:]