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
function add_feature_during_restore!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64, g_param::Float64, list_number::Int64; u_adv=0.0, cu::Float64=0.0)::Nothing

    @assert length(target_features) == length(probe_features) "LENGTH NOT MATCH"

    is_content = cu === 0.0 #if cu is 0, then this is a content

    for i in eachindex(probe_features)

         # Special handling for OT feature (last feature) - only if enabled
        # skip the OT feature here, this will be specifically handled later
        # if use_ot_feature && i === tested_before_feature_pos && is_content
        if use_Z_feature && (i === tested_before_feature_pos) && is_content
            # OT feature: use κs probability for incorrect test info
             #do nothing for when OT feature here,this will be specifically handled later

        else#when feature i is not OT feature, or all other else situations
            # Normal features: use existing geometric distribution logic

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

            if use_Z_feature && (i === tested_before_feature_pos) && !is_ctx
                # Z feature: use κs probability for incorrect test info during restoration
                # have tested this does happen               
            else
                 # Normal features: use existing logic

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

            end #end of the Z feature judgement
        end 
    end # for _ in 1:n_units_time_restore
end

########### Z feature functions moved to feature_origin.jl

# =============================================================================
# CONTEXT DISTORTION FUNCTIONS (Issue #50)
# =============================================================================

"""
Distort specific range of probe context features, then apply gradual recovery.

This flexible function can distort UC, CC, or any range of context features separately:
- All probes distorted at once with constant base_distortion_prob
- Recovery applied with constant base_recovery_prob for all probes
- Can be called separately for UC and CC to allow independent control
- Original context is preserved in foils_collection (for final test)
- Distorted context is used for testing (and gets stored in memory)

Args:
    probes: Vector of probes to potentially distort context
    start_idx: Starting index of context features to distort (1-based)
    end_idx: Ending index of context features to distort (inclusive)
    context_type_name: Name for debug messages ("UC", "CC", etc.)
    max_distortion_probes: (Currently unused - kept for compatibility)
    base_distortion_prob: Probability of distortion applied to all probes
    base_recovery_prob: Constant probability of recovering each distorted feature
    g_context: Geometric distribution parameter for generating new feature values

Returns:
    Tuple of (distorted_probes, original_probes) where original_probes are deep copies for reference
    
Logic:
    Step 1: Distort all probes at once with base_distortion_prob
    Step 2: Recover distorted features with constant base_recovery_prob
"""
function distort_probe_context_range_with_linear_decay(
    probes::Vector{Probe},
    start_idx::Int64,
    end_idx::Int64,
    context_type_name::String,
    max_distortion_probes::Int;
    base_distortion_prob::Float64 = 0.12,
    base_recovery_prob::Float64 = 0.3,
    g_context::Float64 = 0.3
)::Tuple{Vector{Probe}, Vector{Probe}}

error("this is not used")
    # Create deep copies of original probes for reference
    original_probes = deepcopy(probes)
    distorted_probes = deepcopy(probes)

    # Step 1: Distort all probes at once with base_distortion_prob
    # Track which features were distorted for each probe
    distorted_features = [Set{Int}() for _ in eachindex(probes)]
    
    for i in eachindex(probes)
        # Distort features in specified range with constant probability
        for j in start_idx:end_idx
            if rand() < base_distortion_prob
                # Store original value before distortion
                distorted_probes[i].image.context_features[j] = rand(Geometric(g_context)) + 1
                push!(distorted_features[i], j)
            end
        end
    end

    # Step 2: Apply recovery - restore some distorted features with constant probability
    # don't recovery here
    # for i in eachindex(probes)
    #     if !isempty(distorted_features[i])
    #         # Use constant recovery probability for all probes
            
    #         # Recover (restore) some distorted features
    #         recovered_count = 0
    #         for j in distorted_features[i]
    #             if (rand() < base_recovery_prob) && (i!=1) #not the first probe
    #                 # Restore to original feature value
    #                 distorted_probes[i].image.context_features[j] = original_probes[i].image.context_features[j]
    #                 recovered_count += 1
    #             end
    #         end
            
    #         # Track final distorted count (distorted - recovered)
    #         final_distorted_count = length(distorted_features[i]) - recovered_count

    #         # Add debug marker to word.item if context remains distorted after recovery
    #         if final_distorted_count > 0
    #             original_word = distorted_probes[i].image.word
    #             context_distortion_info = "$(context_type_name)_DISTORTED_pos$(i)_prob$(round(base_distortion_prob, digits=3))_rec$(round(base_recovery_prob, digits=3))_n$(final_distorted_count)"

    #             # Check if word.item already has distortion marker
    #             if contains(original_word.item, "DISTORTED")
    #                 # Append context distortion info
    #                 new_item = "$(original_word.item)_$(context_distortion_info)"
    #             else
    #                 # Add context distortion marker
    #                 new_item = "$(original_word.item)_[$(context_distortion_info)]"
    #             end

    #             # Create new Word instance with modified item (since Word is immutable)
    #             new_word = Word(new_item, original_word.word_features, original_word.type, original_word.studypos)

    #             # Replace the word in the EpisodicImage (which is mutable)
    #             distorted_probes[i].image.word = new_word
    #         end
    #     end
    # end

    return distorted_probes, original_probes
end

"""
Distort probe context features with constant probability across all probes.

This function applies a constant distortion probability to each feature 
within the specified range for all probes (no linear decay or position effects).

Args:
    probes: Vector of probes to distort
    start_idx: Starting index of context features to distort (1-based)
    end_idx: Ending index of context features to distort (inclusive)
    context_type_name: Name for debug messages ("UC", "CC", etc.)
    distortion_prob: Constant probability of distorting each feature
    g_context: Geometric distribution parameter for generating new feature values

Returns:
    Tuple of (distorted_probes, original_probes) where original_probes are deep copies for reference
    
Logic:
    For each probe, distort each feature in [start_idx:end_idx] independently 
    with constant probability base_distortion_prob
"""
function distort_probe_context_constant_prob(
    probes::Vector{Probe},
    start_idx::Int64,
    end_idx::Int64,
    context_type_name::String,
    distortion_prob::Float64,
    g_context::Float64
)::Tuple{Vector{Probe}, Vector{Probe}}

error("this is not used")
    # Create deep copies of original probes for reference
    original_probes = deepcopy(probes)
    distorted_probes = deepcopy(probes)

    # Distort each feature with constant probability
    for i in eachindex(probes)
        for j in start_idx:end_idx
            if rand() < distortion_prob
                # Replace with new random feature value
                distorted_probes[i].image.context_features[j] = rand(Geometric(g_context)) + 1
            end
        end
    end

    return distorted_probes, original_probes
end

# =============================================================================
# CONTENT DISTORTION FUNCTIONS (from E3)
# =============================================================================

"""
Distort probe content features, then apply recovery.
This function implements a two-step process:
1. Distort all probes at once with base_distortion_prob
2. Recover distorted features with constant base_recovery_prob

Args:
    probes: Vector of probes to potentially distort
    max_distortion_probes: (Currently unused - kept for compatibility)
    base_distortion_prob: Probability of distortion applied to all probes
    base_recovery_prob: Constant probability of recovering each distorted feature
    g_word: Geometric distribution parameter for generating new feature values

Returns:
    Tuple of (distorted_probes, original_probes) where original_probes are deep copies for reference

Logic:
    Step 1: Distort all probes at once with base_distortion_prob
    Step 2: Recover distorted features with constant base_recovery_prob
"""
function distort_probes_with_linear_decay(
    probes::Vector{Probe}, 
    max_distortion_probes::Int; 
    base_distortion_prob::Float64 = 0.8,
    base_recovery_prob::Float64 = 0.3,
    g_word::Float64 = 0.3
)::Tuple{Vector{Probe}, Vector{Probe}}
    
error("this is not used")
    # Create deep copies of original probes for reference
    original_probes = deepcopy(probes)
    distorted_probes = deepcopy(probes)

    if is_distort_probes
        # Step 1: Distort all probes at once with base_distortion_prob
        # Track which features were distorted for each probe
        distorted_features = [Set{Int}() for _ in eachindex(probes)]
        
        for i in eachindex(probes)
            # Distort features with constant probability
            for j in eachindex(distorted_probes[i].image.word.word_features)
                if j <= w_word #only distort normal content features
                    if rand() < base_distortion_prob
                        # Generate new feature value using Geometric distribution
                        distorted_probes[i].image.word.word_features[j] = rand(Geometric(g_word)) + 1
                        push!(distorted_features[i], j)
                    end
                end
            end
        end

        #don't recovery here
        # Step 2: Apply recovery - restore some distorted features with constant probability
        # for i in eachindex(probes)
        #     if !isempty(distorted_features[i])
        #         # Use constant recovery probability for all probes
                
        #         # Recover (restore) some distorted features
        #         recovered_count = 0
        #         for j in distorted_features[i]
        #             if (rand() < base_recovery_prob) && (i!=1)
        #                 # Restore to original feature value
        #                 distorted_probes[i].image.word.word_features[j] = original_probes[i].image.word.word_features[j]
        #                 recovered_count += 1
        #             end
        #         end
                
        #         # Track final distorted count (distorted - recovered)
        #         final_distorted_count = length(distorted_features[i]) - recovered_count
                    
        #         # Add debug marker to word.item if features remain distorted after recovery
        #         if final_distorted_count > 0
        #             original_word = distorted_probes[i].image.word
        #             distortion_info = "DISTORTED_pos$(i)_prob$(round(base_distortion_prob, digits=3))_rec$(round(base_recovery_prob, digits=3))_features$(final_distorted_count)"
        #             new_item = "$(original_word.item)_[$(distortion_info)]"
                    
        #             # Create new Word instance with modified item (since Word is immutable)
        #             new_word = Word(new_item, original_word.word_features, original_word.type, original_word.studypos)
                    
        #             # Replace the word in the EpisodicImage (which is mutable)
        #             distorted_probes[i].image.word = new_word
                    
        #             # Debug: Print when distortion actually happens for position 1
        #             # if i == 1
        #             #     println("[DEBUG-DISTORTION-POS1] ✓ DISTORTED - Type: $(new_word.type), Features changed: $(final_distorted_count), Item: $(new_item)")
        #             # end
        #         else
        #             # Debug: Print when no features were distorted for position 1
        #             # if i == 1
        #             #     println("[DEBUG-DISTORTION-POS1] ✗ No features distorted - Type: $(distorted_probes[i].image.word.type)")
        #             # end
        #         end
        #     end
        #     # For probes beyond max_distortion_probes, no distortion (probability = 0)
        # end #end for loop
    end
    
    return distorted_probes, original_probes
end