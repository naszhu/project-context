
function calculate_likelihood_ratio(probe::Vector{Int64}, image::Vector{Int64}, g::Float64, c::Float64)::Float64

    lambda = Vector{Float64}(undef, length(probe))

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0
            lambda[k] = 1
        elseif image[k] != probe[k]# for those that doesn't match
            lambda[k] = 1 - c
            # println(1-c)
        else  # image[k] == probe[k]
            lambda[k] = (c + (1 - c) * g * (1 - g)^(image[k] - 1)) / (g * (1 - g)^(image[k] - 1))
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
        probe_context = probe.context_features
        image_context = image.context_features

        #currently goes here
        # Combine nC and a portion of nU based on a probability
        U_ctx = nU_in
        C_ctx = nC_in

        #CHANGED: !! should start from nU!! careful here!
        probe_context_adjusted = fast_concat([probe_context[1 : U_ctx], probe_context[(nU +1) : (nU + C_ctx)]]) #take the first half
        image_context_adjusted = fast_concat([image_context[1 : U_ctx], image_context[(nU +1) : (nU + C_ctx)]]) #ohoh, this is not wrong, its chunking the context of the image trace in memory...

        context_likelihood = calculate_likelihood_ratio(probe_context_adjusted, image_context_adjusted, g_context, c_context[ilist])  # Context calculation
        # println(length(probe_context))
        context_likelihoods[ii] = context_likelihood

        # second stage
        if context_likelihood > context_tau[ilist] # if pass context criterion 

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


    end

    return context_likelihoods, word_likelihoods
end


function calculate_two_step_likelihoods2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64, iprobe::Int64)::Tuple{Vector{Float64},Vector{Float64}}

    # Calculate which chunk this probe belongs to (each chunk has 42 probes)
    currchunk = ceil(Int, iprobe / chunk_size_final_change)
    # Ensure chunk index doesn't exceed array bounds
    currchunk = min(currchunk, length(nU_f))
    
    nU_fs = nU_f[currchunk]
    nC_fs = nC_f[currchunk]        
    
    context_likelihoods = Vector{Float64}(undef, length(image_pool))
    word_likelihoods = Vector{Float64}(undef, length(image_pool))
    probe_context = probe.context_features
    #CHANGED: !! should start from nU!! careful here! (Bug fix: CC starts at nU+1, not nU_fs+1)
    probe_context_f = fast_concat([probe_context[1 : nU_fs], probe_context[(nU + 1) : (nU + nC_fs)]]) #

    for ii in eachindex(image_pool)
        image = image_pool[ii]
        image_context = image.context_features

        #is_test_allcontext2 true; currently goes here
        #CHANGED: !! should start from nU!! (Bug fix: CC starts at nU+1, not nU_fs+1)
        image_context_f = fast_concat([image_context[1:nU_fs], image_context[(nU + 1) : (nU + nC_fs)]])
        context_likelihood = calculate_likelihood_ratio(probe_context_f, image_context_f, g_context, c)  # .#  Context calculation

        context_likelihoods[ii] = context_likelihood

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


    end

    return context_likelihoods, word_likelihoods
end
