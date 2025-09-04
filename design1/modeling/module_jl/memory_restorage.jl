
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
function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, sampling_probabilities::Vector{Float64}, odds::Float64, content_LL_ratios::Vector{Float64})::Nothing


    if is_onlyaddtrace
        error("not coded here")
    end
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

        
    if ((decision_isold==1) & (odds > recall_odds_threshold) )

        if sampling_method
            @assert length(image_pool) == length(sampling_probabilities) "image_pool and sampling_probabilities should be the same length"
            #recall; restore old
            cdf_each_boral_sets = Categorical(sampling_probabilities)     
            index_sampled = rand(cdf_each_boral_sets)
            iimage_tostrenghten = image_pool[index_sampled]
        else
            # Pick the image from image_pool with the maximum content_LL_ratios value
            @assert length(content_LL_ratios) == length(image_pool) "content_LL_ratios and image_pool must have the same length"
            imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios]);
            iimage_tostrenghten  = image_pool[imax]
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
            add_features_from_empty!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest_ilist, g_word)
            @assert length(iprobe_img.context_features) == length(iimage_toadd.context_features) "context features should be the same length"

            # Update context features
            # u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
            @assert u_star_context[end] == u_star_context[1] "u_star_context is not well defined to be used in restore_intest for intial test, final test is dependant on u_star_context[ilist], but not yet like that in inital test, initial doens't have a u_star_context difference right now, notice"
            add_features_from_empty!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[end] + u_advFoilInitialT, c_context_ilist_cc, g_context; cu = c_context_ilist_cu) 
        end



    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((decision_isold==1) & (odds > recall_odds_threshold) )

        # println(iprobe_img.word.type)
        if is_strengthen_contextandcontent #true
            restore_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore)

            restore_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, c_context_c[1], g_context, cu=c_context_c[1], is_ctx=true)
            
            # Update Z feature during strengthening for targets in E1
            if use_Z_feature && iimage_tostrenghten.word.type == :target
                update_Z_feature_target_restoration!(iimage_tostrenghten.word, iprobe_img.list_number)
            end
        else
            # error("should strenghen here")
        end

        # the following makes sure that we actually must need to restore context.
         
        !is_restore_context ? error("context restored in initial is not well written this part") : nothing

    end


    if (decision_isold == 0) || ((decision_isold == 1) && (odds < recall_odds_threshold))|| ((decision_isold==1) && (odds > recall_odds_threshold) && (odds<recall_to_addtrace_threshold)) 
        push!(image_pool, iimage_toadd)
        # println("pass, decision_isold $(decision_isold); is pass $(odds < recall_odds_threshold)")
    else
        # print("here")
    end

    return nothing


end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, sampling_probabilities::Vector{Float64}, odds::Float64, finaltest_pos::Int64,content_LL_ratios::Vector{Float64} )::Nothing
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
    if ((decision_isold==1) & (odds > recall_odds_threshold) )

        if sampling_method
            @assert length(image_pool) == length(sampling_probabilities) "image_pool and sampling_probabilities should be the same length"
            #recall; restore old
            cdf_each_boral_sets = Categorical(sampling_probabilities)     
            index_sampled = rand(cdf_each_boral_sets)
            iimage_tostrenghten = image_pool[index_sampled]
        else
            # Pick the image from image_pool with the maximum content_LL_ratios value
            @assert length(content_LL_ratios) == length(image_pool) "content_LL_ratios and image_pool must have the same length"
            imax = argmax([ill==344523466743 ? -Inf : ill for ill in content_LL_ratios]);
            iimage_tostrenghten = image_pool[imax]
        end

    end

    
    ############# ADD TRACE ######################
    # if new, or old but didn't pass threshold -- ADD TRACE
    # if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold))| ((decision_isold==1) & (odds > recall_odds_threshold)) 

        for _ in 1:n_units_time_restore

            add_features_from_empty!(iimage_toadd.word.word_features, iprobe_img.word.word_features, u_star[end], c_storeintest[end], g_word) #TODO

            # if iprobe_img.list_number == 1

            # Issue 12, 13(ambigiou use const array)
            # this problem occur u_star_context[probe_img.list_number] has problem here because should not use probe's list number but final test order list number, but I don't have that in my structure right now

            iprobe_chunk_boundaries = cumsum([total_probe_L1 * nItemPerUnit_final * 2; fill(total_probe_Ln * nItemPerUnit_final * 2, 9)])  # First chunk has 15*2*2 items, rest 9 chunks have 12*2*2 items

            # Determine the chunk index for the current probe
            iprobe_chunk = findfirst(x -> finaltest_pos <= x, iprobe_chunk_boundaries)  

            add_features_from_empty!(iimage_toadd.context_features, iprobe_img.context_features, u_star_context[iprobe_chunk], c_context_c[end], g_context; cu=c_context_un[end]); #TODO: use last big ctx?
            # else
                # add_features_from_empty!(iimage.context_features, iprobe_img.context_features, u_star_context[end]+u_advFoilInitialT+0.1, c_context_ilist, g_context)
            
            # end


        end


    ###### STRENGHTEN TRACE ######################
    # RESTORE CONTEXT & CONTENT
    if ((decision_isold==1) & (odds > recall_odds_threshold) )

        # pass: strenghten
        #single parameter for missing or replacing
        # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

        if !is_store_mismatch
            error("current prog is not written when doesn't store mismatch")
        end

        if is_strengthen_contextandcontent
            restore_features!(iimage_tostrenghten.word.word_features, iprobe_img.word.word_features, p_recallFeatureStore)

            restore_features!(iimage_tostrenghten.context_features, iprobe_img.context_features, p_recallFeatureStore, c_context_c[1], g_context, cu=c_context_c[1], is_ctx=true)
            
            # Update Z feature during strengthening for targets in E1 (final test)
            if use_Z_feature && iimage_tostrenghten.word.type == :target
                update_Z_feature_target_restoration!(iimage_tostrenghten.word, iprobe_img.list_number)
            end
        end

        !is_restore_context ? error("context restored in initial is not well written this part") : nothing


    end

    # if (decision_isold == 0)
    if (decision_isold == 0) || ((decision_isold == 1) && (odds < recall_odds_threshold))|| ((decision_isold==1) && (odds > recall_odds_threshold) && (odds<recall_to_addtrace_threshold)) 
        push!(image_pool, iimage_toadd)
    end

    return nothing


    # if decision_isold ==1 println("afterchange",iimage) end
end 