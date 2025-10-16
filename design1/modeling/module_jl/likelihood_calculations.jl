
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

    ilist = probe.list_number   

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        probe_context = probe.context_features
        image_context = image.context_features

        if firststg_allctx #false
            if is_test_allcontext  #here is secon  stage would be wrong, including position code, unchage, change
                # context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
                eror("1")
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context]), fast_concat([image.word.word_features, image_context]), g_word, c)
            else  #not testing all context but change only, no unchange or position code
                error("not modifeid here")
                context_likelihood = calculate_likelihood_ratio(probe_context[nU+1:w_context], image_context[nU+1:w_context], g_context, c)  # .#  Context calculation
            end
        else #currently goes here
            if is_test_allcontext  #false here; here is secon  stage would be wrong, including position code, unchage, change

                error("testing all context is mistaken right here")
                # println(length(image_context))
                # img_ctx_now = image_context[nU+1: w_context]
                # context_likelihood = calculate_likelihood_ratio(probe_context,img_ctx_now,g_context,c )  # .#  Context calculation
            else  #not testing all context but change only, no unchange or position code

                # currently goes here

                # Combine nC and a portion of nU based on list number (dynamic weighting)
                # Use list-specific UC and CC weights (ilist is probe.list_number from line 44)
                U_ctx = nU_in[ilist]
                C_ctx = nC_in[ilist]

                #CHANGED: !! should start from nU!! careful here!
                probe_context_adjusted = fast_concat([probe_context[1 : U_ctx], probe_context[(nU +1) : (nU + C_ctx)]]) #take the first half
                image_context_adjusted = fast_concat([image_context[1 : U_ctx], image_context[(nU +1) : (nU + C_ctx)]]) #ohoh, this is not wrong, its chunking the context of the image trace in memory...

                context_likelihood = calculate_likelihood_ratio(probe_context_adjusted, image_context_adjusted, g_context, c_context[ilist])  # Context calculation
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
            error("first stage must be assigned")
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end


function calculate_two_step_likelihoods2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}

    nU_fs =nU_f[1];
    nC_fs =nC_f[1];        
    
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))
    probe_context = probe.context_features
    probe_context_f = fast_concat([probe_context[1 : (nU_fs)], probe_context[(nU_fs + 1):(nU_fs + nC_fs)]]) #

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        image_context = image.context_features

        if firststg_allctx2 #false
            if is_test_allcontext2  #here is secon  stage would be wrong
                image_context_f = fast_concat([image_context[1:nU_fs], image_context[nU_fs+1:nU_fs+nC_fs]])
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context_f]), fast_concat([image.word.word_features, image_context_f]), g_context, c)  # .#  Context calculation
            elseif is_test_changecontext2
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context[nU+1:end]]), fast_concat([image.word.word_features, image_context[nU+1:end]]), g_context, c)
            else #only test general context (first part)
                context_likelihood = calculate_likelihood_ratio(fast_concat([probe.word.word_features, probe_context[1:nU]]), fast_concat([image.word.word_features, image_context[1:nU]]), g_context, c) #  Context calculation
            end
        else #is_test_allcontext2 true
            if is_test_allcontext2  #true; currently goes here
                image_context_f = fast_concat([image_context[1:nU_fs], image_context[nU_fs+1:nU_fs+nC_fs]])
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

                word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:w_word], image.word.word_features[1:w_word], g_word, c)

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
            error("must use first stage")
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end


    end

    return context_likelihoods, word_likelihoods
end
