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

include("module_jl/utils.jl")
include("module_jl/constants.jl") 
# include("feature_updates.jl")

include("module_jl/data_structures.jl")

include("module_jl/feature_generation.jl")

include("module_jl/likelihood_calculations.jl")

include("module_jl/memory_storage.jl")
include("module_jl/memory_restorage.jl")

include("module_jl/probe_generation.jl")
include("module_jl/probe_evaluation.jl")

include("simulation.jl")

Threads.nthreads()


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

run(`Rscript design1/modeling/R_ploting/R_plots.r`)
run(`bash -c "eog plot1.png & disown"`)

if is_finaltest
    CSV.write(csv_path3, allresf)
    run(`Rscript design1/modeling/R_ploting/R_plots_finalt.r`)
    run(`bash -c "eog plot2.png & disown"`)
end