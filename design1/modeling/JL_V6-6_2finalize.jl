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




const w_context = 0; #first half unchange context, second half change context, third half word-change context (third half is not added yet)
w_word = 20;#25 # number of word features, 30 optimal for inital test, 25 for fianal, lower w would lower overall accuracy 

w_positioncode = 0
w_allcontext = w_context + w_positioncode
ratio_U = 1.0 #ratio of general(unchanging) context #make all unchanging context for now

nU = round(Int, w_context * ratio_U)
nC = w_context - nU


n_simulations = 100;
# n_simulations= 50v

const n_words = 75;
const n_probes = 150; # Number of probes to test
const n_lists = 6;
# const n_words = 40;

# 0.03^(1/11)= ~0.72
criterion_initial = LinRange(1, 1, n_probes);#the bigger the later number, 

p_poscode_change = 0.0


const g_word = 0.35; #geometric base rate
const g_context = 0.35; #0.3 originallly geometric base rate of context, or 0.2

u_star = vcat(0.16, ones(n_lists-1) * 0.16)
u_star_storeintest = u_star #for word # ratio of this and the next is key 
u_star_context=vcat(0.16, ones(n_lists-1)*0.16)
                                                           

const c = 0.7 #coying parameter - 0.8 for context copying 
const c_storeintest = c


const c_context = LinRange(c, c, n_lists)

is_restore_initial = true

ratio_unchanging_to_itself_init = LinRange(1.0, 1.0, n_lists) # if use no unchanging
ratio_changing_to_itself_init = LinRange(0.0, 0.0, n_lists) # if use no unchanging
# Only takes the first value; for a single Int
nU_in = round.(Int, nU .* ratio_unchanging_to_itself_init)[1]
nC_in = round.(Int, nC .* ratio_changing_to_itself_init)[1]



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


struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
    initial_testpos::Int64
    # initial_studypos::Int64
    
end



function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int)::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target], n_probes)) |> shuffle! #every used as target

    for i in 1:n_words

        word_list[i] = Word("Word$(i)L$(list_num)", rand(Geometric(g_word), w_word) .+ 1, types[i], i)
    end


    return word_list
end



function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64)

    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type, word.studypos), zeros(length(context_features)), list_num, 0) # Zero word features

    # for _ in 1:n_units_time
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


        # println("Word Features: ", new_image.word.word_features)
    # end

    push!(image_pool, new_image)

end


"""generate probe for inital test for a given list,
input: studied word list; context features (word_change will modifed from the current list last word's context features)
Return: probe

list_change_features: list feature, same as studied one
test_list_context: changed RI after study, continuous reinstate in test
"""
function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64}, test_list_context::Vector{Int64}, general_context_features::Vector{Int64}, test_list_context_unchange::Vector{Int64}, position_code_all::Vector{Vector{Int64}}, list_num::Int64,studied_pool::Vector{EpisodicImage} )::Vector{Probe}


    probetypes = repeat([:target, :foil], outer=div(n_probes, 2)) |> shuffle!
    probes = Vector{Probe}(undef, length(probetypes))

    words = studied_words|> shuffle! |> deepcopy
    # filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy
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

        # println("$(test_list_context)")
        current_studypos = probetypes[i] == :target ? target_word.studypos : 0;

        current_testpos = i; 


        current_context_features = fast_concat([deepcopy(test_list_context_unchange), deepcopy(test_list_context)]) #here needs a deepcopy, otherwise the front 

        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num, current_testpos), probetypes[i] ,current_testpos)
        

    end


    return probes
end


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


"""
Initial test stage
Input: A probe and the whole image_pool
adding the filter here
"""
function calculate_two_step_likelihoods(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))

    ilist = probe.list_number   

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)


    end

    return context_likelihoods, word_likelihoods
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


            image_pool_currentlist = image_pool
        # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")

        # calculate_two_step_likelihoods_rule2(probes[i].image, image_pool);
        _, likelihood_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool_currentlist, 1.0, i) #proportion is all
        # likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool); #proportion is all
        likelihood_ratios = likelihood_ratios_org 
        # println(length(likelihood_ratios_org)== length(image_pool_currentlist) )


        ilist_probe = probes[i].image.list_number
        i_testpos = probes[i].initial_testpos#1:20

        nl = count(image -> image.list_number == ilist_probe, image_pool_currentlist) #length(likelihood_ratios)
        # image_pool_ss = filter(img -> img.list_number == ilist_probe, image_pool)
        # likelihood_ratios_ss = [likelihood_ratios[ii] for ii in eachindex(image_pool) if image_pool[ii].list_number == ilist_probe]
        
        nl = length(image_pool)
        odds = 1 / nl * sum(likelihood_ratios)

        if (isnan(odds))
            # println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, likelihood_ratios)
        end
    
        decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0
        diff = 1 / (abs(odds - criterion_initial[i_testpos]) + 1e-10)


        nav = length(likelihood_ratios) / (length(image_pool_currentlist))
        # println(nav)


        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            

            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, is_target=probes[i].classification, odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.studypos, diff=diff)
            # println(nl, " ",nimages_activated)
        end
    
        imax = argmax(likelihood_ratios_org);


        # if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, probes[i].classification, list_change_features, general_context_features, odds, likelihood_ratios_org, simu_i, i) 
        # end


    end



    return results
end

"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)

    if decision_isold==0

        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)

    elseif (decision_isold==1) 

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end



    # if new, context and content change, be added to the pool

    if (decision_isold == 0)

        # for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                # if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                if (j == 0) 
                    iimage.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end

        push!(image_pool, iimage)

        # end
    end

    

    #if old, pass threshold, context and contet change, recall land strenghten

    if (decision_isold == 1) 


            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                # if j!=0
                    if (j == 0) #is only doing this once, so doesn't matter if j==0 or not..

                        iimage.word.word_features[i]  = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : 0 # 0.04 to u_star_context[2]
                    end 
                

            end

           



    end





end





function simulate_rem()
    # 1. Initialization

    df_inital = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_iimageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], study_position=Int[], diff_rt=Float64[] )


    for sim_num in 1:n_simulations

        if sim_num % (n_simulations ÷ 10) == 0
            println("Progress: $(sim_num * 100 ÷ n_simulations)% simulations completed.")
        end
        

        #    sim_num=1
        image_pool = EpisodicImage[]
        # Initialize studied_pool with empty EpisodicImage objects
        studied_pool = Array{EpisodicImage}(undef, n_words + Int(n_probes / 2), n_lists)

        for i in 1:n_words + Int(n_probes / 2),  j in 1:n_lists
            # Create an empty EpisodicImage with default values
            studied_pool[i, j] = EpisodicImage(
            Word("", zeros(Int64, w_word), :T_target, 0),
            zeros(Int64, w_context + w_positioncode),
            0,
            0
            )
        end
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

                studied_pool[j, list_num] = episodic_image
            end

            # study_list_context = deepcopy(list_change_context_features);
            test_list_context = deepcopy(list_change_context_features)
            test_list_context_unchange = deepcopy(general_context_features)


            probes = generate_probes(word_list, list_change_context_features, test_list_context, general_context_features, test_list_context_unchange, position_code_all, list_num, studied_pool[1:n_words,list_num]) #probe number is current list number, get probes of current list 
            

            @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes / 2) "wrong number!"

            studied_pool[n_words+1:n_words+Int(n_probes / 2), list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)]

            results = probe_evaluation(image_pool, probes, list_change_context_features, general_context_features, sim_num)
            # println("ImagePoolNow", [i.word.item for i in image_pool])
            

            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, res.testpos, sim_num, res.decision_isold, tt, res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff] 
                push!(df_inital, row)
            end



        end

        studied_pool = [studied_pool...]
        #final test here

    end

    return df_inital
end


# @benchmark simulate_rem()

all_results = simulate_rem()
# all_results 
DF = @chain all_results begin
    @by([:list_number, :is_target, :test_position, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position], :meanx = mean(:meanx))
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

run(`Rscript design1/modeling/R_ploting/R_plots.r`)
run(`bash -c "eog plot1.png & disown"`)

