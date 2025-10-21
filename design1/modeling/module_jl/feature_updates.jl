using Distributions: Geometric

"""Update list context features based on change probability for final test.

Updates the list context features (ctx) by randomly changing each feature
with probability p_ListChange_finaltest[icount].

Args:
    ctx: Vector of list context features to be modified
    icount: Index used to determine change probability from p_ListChange_finaltest
"""
function drift_between_lists_final!(ctx::Vector{Int64}, icount::Int64)
    for cf in eachindex(ctx)
        if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
            ctx[cf] = rand(Geometric(g_context)) + 1
        end
    end
end

"""Reconstruct (reinstate) the changing context (CC) to original study-time values.

This function reinstates the CC features to their original values from study time,
simulating participants' ability to reconstruct the study context for a specific list
during final test. The reinstatement happens once at the start of each list/chunk and
persists throughout that list/chunk.

Args:
    current_CC: Current CC vector to be modified (will be modified in place)
    original_CC: Original CC vector from study time for the target list
    condition: Current test condition (:forward, :backward, or :true_random)

Returns:
    Nothing (modifies current_CC in place)
"""
function reinstate_CC_finaltest!(current_CC::Vector{Int64}, original_CC::Vector{Int64}, condition::Symbol)::Nothing
    # Check if reconstruction is enabled for this condition
    do_reconstruct = false
    if condition == :forward && is_reconstruct_finaltest_forward
        do_reconstruct = true
    elseif condition == :backward && is_reconstruct_finaltest_backward
        do_reconstruct = true
    elseif condition == :true_random # && is_reconstruct_finaltest_random
        do_reconstruct = false #never do reconstruction for random condition
    end

    # If reconstruction is enabled, fully reinstate all CC features
    if do_reconstruct
        # Copy all original CC values to current CC
        for i in eachindex(current_CC)
            current_CC[i] =  rand() < p_reinstate_rate_finaltest ? original_CC[i] : current_CC[i]
        end
    end

    return nothing
end

######### OK these were added from E3, used in memory_restorage

"""
Helper functions for feature updates in memory restorage
"""

"""
assume read nU from constant.jl
cu and cc is copying parameter value
"""
function add_feature_during_restore!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64, g_param::Float64, list_number::Int64; cu::Float64=0.0)::Nothing

    @assert length(target_features) == length(probe_features) "LENGTH NOT MATCH"

    is_content = cu === 0.0 #if cu is 0, then this is a content

    for i in eachindex(probe_features)

        if is_content #cu?==0.0? this means when this is a content (so no cu will be inputed)
            c_param = cc
        else     

            if i > nU #FIXME: fast workaround here
                c_param = cc
            else
                c_param = cu
            end
        end
        
        j = target_features[i]
        if j === 0
            target_features[i] = rand() < u_star ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
        end
        
    end

    return nothing
end

"""
Strengthen features during memory restoration
Based on E3's strengthen_features! function
"""
function strengthen_features!(target_features::Vector{Int}, source_features::Vector{Int}, p_recallFeatureStore::Float64, list_number::Int64; is_store_mismatch::Bool=is_store_mismatch, is_ctx::Bool=false)::Nothing

    @assert length(target_features) == length(source_features) "target_features and source_features must have the same length: target=$(length(target_features)), source=$(length(source_features))"
    
    for _ in 1:n_units_time_restore
        for i in eachindex(source_features)
            current_value = target_features[i]
            source_value = source_features[i]

            if is_ctx
                @assert length(target_features)==nU+nC "not same length"
                if i>nU # for CC

                    @assert all(c_context_c .== c_context_c[1]) "c_context_c should not change by list"
                    @assert all(c_context_un .== c_context_un[1]) "c_context_un should not change by list"
                    @assert all(u_star_context .== u_star_context[1]) "u_star_context should not change by list"
                    c_usenow = c_context_c[1] #, perfect storage 
                    u_star_now = u_star_context[1] + u_advFoilInitialT #u_advFoilInitialT is the adv for foil (judged new, add trace) in initial test, to see if final test p overlappsss....u_advFoilInitialT=0 currently
                else # for unchanging 
                    c_usenow =c_context_c[1]
                    u_star_now = u_star_context[1] + u_advFoilInitialT 
                end
            else #if content
                c_usenow = c[1] 
                u_star_now = u_star[1] + u_advFoilInitialT 
            end
        
            #is_store_mismatch is false now so no mismatch stored
            if (current_value === 0) || ((current_value !== 0) && (current_value !== source_value) && is_store_mismatch)
                target_features[i] = rand() < u_star_now[1]+u_star_adv ? (rand() < c_usenow[1]+c_adv ? source_value : rand(Geometric(g_context)) + 1) : current_value
            end
        end 
    end # for _ in 1:n_units_time_restore
end

########### Z feature functions moved to feature_origin.jl

# =============================================================================
# CONTEXT DISTORTION FUNCTIONS (Issue #50)
# =============================================================================



# =============================================================================
# CONTENT DISTORTION FUNCTIONS (from E3)
# =============================================================================


# =============================================================================
# DISTORTION AND REINSTATEMENT FUNCTIONS FOR PROBE GENERATION
# =============================================================================

"""
Distort context features with constant probability.
Applies distortion to a range of features in a context vector.

Args:
    context_vector: Context vector to distort (will be modified in place)
    start_idx: Starting index of features to distort (1-based)
    end_idx: Ending index of features to distort (inclusive)
    distortion_prob: Probability of distorting each feature
    g_context: Geometric distribution parameter for new values
"""
function distort_context_range!(
    context_vector::Vector{Int64},
    start_idx::Int64,
    end_idx::Int64,
    distortion_prob::Float64,
    g_context::Float64
)::Nothing
    for j in start_idx:end_idx
        if rand() < distortion_prob
            context_vector[j] = rand(Geometric(g_context)) + 1
        end
    end
    return nothing
end

"""
Distort all content features of all probe words with constant probability.
Applies to all word types (targets and foils).

Args:
    probe_words: Vector of Word objects to distort (will be modified in place)
    distortion_prob: Probability of distorting each feature
    g_word: Geometric distribution parameter for new values
    max_feature_idx: Maximum feature index to distort (to avoid distorting Z feature)
"""
function distort_probe_words_content!(
    probe_words::Vector{Word},
    distortion_prob::Float64,
    g_word::Float64,
    max_feature_idx::Int64
)::Nothing
    for iword in eachindex(probe_words)
        for cf in eachindex(probe_words[iword].word_features)
            if cf <= max_feature_idx  # Only distort normal content features (not Z feature)
                if rand() < distortion_prob
                    probe_words[iword].word_features[cf] = rand(Geometric(g_word)) + 1
                end
            end
        end
    end
    return nothing
end

"""
Reinstate context features from dynamic array back toward reference array.
Used during initial test to partially restore drifted/distorted context.

Args:
    context_array: Current context vector (will be modified in place)
    reference_array: Reference context vector to reinstate toward
    p_reinstate_rate: Probability of reinstating each mismatched feature
"""
function reinstate_context_duringTest!(
    context_array::Vector{Int64}, 
    reference_array::Vector{Int64},
    p_reinstate_rate::Float64
)::Nothing
    # nct = length(context_array)
    for ict in eachindex(context_array)
        # if ict < Int(round(nct * p_reinstate_context)) #disable this, don't need to have this
            if (context_array[ict] != reference_array[ict]) & (rand() < p_reinstate_rate)
                context_array[ict] = reference_array[ict]
            end
        # end
    end
    return nothing
end

"""
Reinstate content features of a single word back toward reference word.
Used during initial test to partially restore distorted word features.

Args:
    word: Word object to reinstate (will be modified in place)
    reference_word: Reference word object to reinstate toward
    p_reinstate_rate: Probability of reinstating each mismatched feature
    max_feature_idx: Maximum feature index to reinstate (to avoid reinstating Z feature)
"""
function reinstate_word_content_duringTest!(
    word::Word,
    reference_word::Word,
    p_reinstate_rate::Float64,
    max_feature_idx::Int64
)::Nothing
    for ifeature in eachindex(word.word_features)
        if ifeature <= max_feature_idx  # Only reinstate normal content features (not Z feature)
            if (word.word_features[ifeature] != reference_word.word_features[ifeature]) & (rand() < p_reinstate_rate)
                word.word_features[ifeature] = reference_word.word_features[ifeature]
            end
        end
    end
    return nothing
end