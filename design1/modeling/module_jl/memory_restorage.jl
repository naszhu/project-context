
using Distributions: Categorical

"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
# flagn = Int64[];
# data_flag = Array{Vector{Any}}(undef, n_simulations)  # Create an array to hold vectors for each simulation
# for i in 1:n_simulations
#     data_flag[i] = Vector{Any}()  # Initialize each row as an empty vector
# end

# function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, odds::Float64, sampled_item::Union{EpisodicImage, Nothing}, criterion::Float64)::Nothing

    #is_onlyaddtrace is false
    # println("nothere")

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold)) #just get a new empty EI

        iimage_toadd = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item, #item
                fill(0, length(iprobe_img.word.word_features)), #word features
                iprobe_img.word.type, #type
                iprobe_img.word.studypos #studypos
            ), 
            # zeros(length(iprobe_img.context_features)),#Context_features: 
            fill(0, length(iprobe_img.context_features)),#Context_features: 
            iprobe_img.list_number,#List_Number; 
            iprobe_img.initial_testpos_img #initial_testpos_img
        )
    # end

        
    if ((odds > criterion) & (odds > recall_odds_threshold) )

        if !isnothing(sampled_item)
            # Use the pre-sampled item
            iimage_tostrenghten = sampled_item
        else
            # If nothing was sampled, criteria didn't pass, so no restoration should happen
            # This case should not occur in normal operation since sampling happens before decision logic
            error("No item was sampled but restoration was attempted. This indicates a logic error.")
        end
    
    end



    # if new, or old but didn't pass threshold -- ADD TRACE 
    # (start with empty EI, then add features)

    c_storeintest_ilist = c_storeintest[iprobe_img.list_number];
    c_context_ilist_cc = c_context_c[iprobe_img.list_number];
    c_context_ilist_cu = c_context_un[iprobe_img.list_number];

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold))


        for _ in 1:n_units_time_restore
            #shouldn't have this in adding trace

        # println(iprobe_img.word.type)
        # for _ in 1:n_units_time #shouldn't have this in adding trace
            # Update word features
            add_feature_during_restore!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest_ilist, g_word, iprobe_img.list_number)
            @assert length(iprobe_img.context_features) == length(iimage_toadd.context_features) "context features should be the same length"

            # Update context features
            @assert u_star_context[end] == u_star_context[1] "u_star_context is not well defined to be used in restore_intest for intial test, final test is dependant on u_star_context[ilist], but not yet like that in inital test, initial doens't have a u_star_context difference right now, notice"
            add_feature_during_restore!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[end], c_context_ilist_cc, g_context, iprobe_img.list_number; cu = c_context_ilist_cu) 
        end



    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((odds > criterion) & (odds > recall_odds_threshold) )

        # println(iprobe_img.word.type)
        # is_strengthen_contextandcontent is true
        strengthen_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore, iprobe_img.list_number)

        strengthen_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, iprobe_img.list_number, is_ctx=true)

        # the following makes sure that we actually must need to restore context.
         
        !is_restore_context ? error("context restored in initial is not well written this part") : nothing

    end


    is_strenghten = (odds > recall_odds_threshold) 

    if (odds < criterion) || ((odds > criterion) && (odds < recall_odds_threshold))
        
        # Debug: Print word.item when adding new trace to memory (initial test) - only for items judged NEW at position 1
        # if decision_isold == 0 && test_position == 1
        #     println("[DEBUG-RESTORE-INITIAL-POS1] Adding NEW trace to memory - Type: $(iimage_toadd.word.type) - word.item: $(iimage_toadd.word.item)")
        #     println("=== END TEST POSITION 1 ===\n")
        # end
        push!(image_pool, iimage_toadd)
        # println("pass, decision_isold $(decision_isold); is pass $(odds < recall_odds_threshold)")
    else
        # Debug: Close test section when no trace is added for position 1
        # if test_position == 1
        #     println("[DEBUG-RESTORE-INITIAL-POS1] No trace added (decision_isold=$(decision_isold))")
        #     println("=== END TEST POSITION 1 ===\n")
        # end
        # print("here")
    end

    return nothing


end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, odds::Float64, sampled_item::Union{EpisodicImage, Nothing}, criterion::Float64)::Nothing
#     iimage = decision_isold == 1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)
# # println(iimage.initial_testpos_img)

    # if ((decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold)))| ((decision_isold==1) & (odds > recall_odds_threshold)) 
    
        iimage_toadd = EpisodicImage(
            #Word:
            Word(iprobe_img.word.item, #item
                fill(0, length(iprobe_img.word.word_features)), #word features
                iprobe_img.word.type, #type
                iprobe_img.word.studypos #studypos
            ), 
            zeros(length(iprobe_img.context_features)),#Context_features: 
            iprobe_img.list_number,#List_Number; 
            iprobe_img.initial_testpos_img #initial_testpos_img
        )

    # end
    
    if ((odds > criterion) & (odds > recall_odds_threshold) )

        if !isnothing(sampled_item)
            # Use the pre-sampled item
            iimage_tostrenghten = sampled_item
        else
            # If nothing was sampled, criteria didn't pass, so no restoration should happen
            # This case should not occur in normal operation since sampling happens before decision logic
            error("No item was sampled but restoration was attempted. This indicates a logic error.")
        end

    end

    
    ############# ADD TRACE ######################
    # if new, or old but didn't pass threshold -- ADD TRACE
    # if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold))| ((decision_isold==1) & (odds > recall_odds_threshold)) 

        for _ in 1:n_units_time_restore

            add_feature_during_restore!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest[end], g_word, iprobe_img.list_number) #TODO

            # if iprobe_img.list_number == 1

            # Issue 12, 13(ambigiou use const array)
            # this problem occur u_star_context[probe_img.list_number] has problem here because should not use probe's list number but final test order list number, but I don't have that in my structure right now

            # Use hard-coded chunk boundaries: each list has 42 items, so first: 1-42, next: 43-84, and so on
            # n_items_per_list = 42
            # iprobe_chunk_boundaries = collect(n_items_per_list:n_items_per_list:n_items_per_list*10)

            # Determine the chunk index for the current probe
            # iprobe_chunk = findfirst(x -> finaltest_pos <= x, iprobe_chunk_boundaries)  

            add_feature_during_restore!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[end], c_context_c[end], g_context, iprobe_img.list_number; cu=c_context_un[end]); #TODO: use last big ctx?
            # else
                # add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[end]+u_advFoilInitialT+0.1, c_context_ilist, g_context)
            
            # end


        end


    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((odds > criterion) & (odds > recall_odds_threshold) )

        if !isnothing(sampled_item)
            # Use the pre-sampled item
            iimage_tostrenghten = sampled_item
        else
            # If nothing was sampled, criteria didn't pass, so no restoration should happen
            # This case should not occur in normal operation since sampling happens before decision logic
            error("No item was sampled but restoration was attempted. This indicates a logic error.")
        end

        # pass: strenghten
        #single parameter for missing or replacing
        # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

        # is_strengthen_contextandcontent is true
        strengthen_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore, iprobe_img.list_number)

        strengthen_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, iprobe_img.list_number, is_ctx=true)

        !is_restore_context ? error("context restored in initial is not well written this part") : nothing


    end

    is_strenghten = (odds > recall_odds_threshold) 

    if (odds <= criterion) || ((odds > criterion) && (odds < recall_odds_threshold))
        
        # Debug: Print word.item when adding new trace to memory (final test) - only for items judged NEW at position 1
        # if decision_isold == 0 && test_position == 1
        #     println("[DEBUG-RESTORE-FINAL-POS1] Adding NEW trace to memory - Type: $(iimage_toadd.word.type) - word.item: $(iimage_toadd.word.item)")
        # end
        push!(image_pool, iimage_toadd)
    end

    return nothing


    # if decision_isold ==1 println("afterchange",iimage) end
end 