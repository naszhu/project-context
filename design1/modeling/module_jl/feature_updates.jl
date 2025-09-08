using Distributions: Geometric

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

########### Z feature functions here (aligned with E3)
function update_Z_feature_study!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κu value (no asymptotic effect yet)
        if list_number === 1
            κ_value = ku_base # this number doesn't matter because first list won't use Z
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end
        
        # Set Z feature value based on κu probability
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

function get_Z_feature_value(word::Word)::Int64
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0
    end
end

function set_Z_feature_value!(word::Word, value::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        word.word_features[tested_before_feature_pos] = value
    end
    return nothing
end

"""
Update Z feature for recalled+new case (confusing foil - list version used).
For strengthened trace: Replace Z=0 with KB, keep Z=1 as is
"""
function update_Z_feature_recalled_new_strengthen!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        current_z = word.word_features[tested_before_feature_pos]
        
        # If Z = 0 (incorrect/missing) → Replace with KB
        if current_z == 0
            # κ parameters: for list 1 use base, else use array
            if list_number === 1 || list_number === 0
                κ_value = kb_base
            else
                κ_index = list_number - 1
                κ_value = κb[κ_index]
            end
            
            # Only replace if original value is 0, keep 1 if it was already 1
            if word.word_features[tested_before_feature_pos] == 0
                word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
            end
        end
        # If Z = 1 → Keep as 1 (no change needed)
    end
    return nothing
end

"""
Update Z feature for recalled+new case when adding new trace.
Store Z = 1 with probability KB
"""
function update_Z_feature_recalled_new_add_trace!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for recalled+old case.
Store Z = 1 with probability KB (both strengthening and adding trace)
"""
function update_Z_feature_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+new case (really new foil).
Add new trace with Z = 1 with probability KT
"""
function update_Z_feature_not_recalled_new!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+old case (target with no trace recalled).
Add trace with Z = 1 with probability KB
"""
function update_Z_feature_not_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z features for all studied-only items between lists.
This function identifies items that appeared only once in previous lists (studied-only)
and excludes items that appeared multiple times (double-appeared = studied + tested before).
Only studied-only items get Z=1 with probability KS.
"""
function update_Z_features_single_appearance_studied_items!(
    image_pool::Vector{EpisodicImage}, 
    studied_pool::Vector{Vector{EpisodicImage}}, 
    list_num::Int64, 
    n_studyitem::Int64
)::Nothing
    
    for img in image_pool
        # Check if this image is from the current list (not a foil)
        if img.list_number == list_num
            # Check if this is a studied item (not a foil) by looking at its position in studied_pool
            # Studied items are in positions 1:n_studyitem
            is_studied_item = false
            for j in 1:n_studyitem
                if !isnothing(studied_pool[list_num][j]) && 
                   studied_pool[list_num][j].word.item == img.word.item
                    is_studied_item = true
                    break
                end
            end
            
            # If it's a studied item, check how many times it appeared
            if is_studied_item
                appearance_count = 0
                for list_idx in 1:list_num
                    if !isnothing(studied_pool[list_idx])
                        for item in studied_pool[list_idx]
                            if !isnothing(item) && item.word.item == img.word.item
                                appearance_count += 1
                            end
                        end
                    end
                end
                
                # If the item appears only once (studied-only, not double-appeared), update its Z feature
                if appearance_count == 1
                    update_Z_feature_between_lists_studied_only!(img.word, list_num)
                end
            end
        end
    end
    
    return nothing
end

"""
Update Z features for studied-only items between lists.
All studied-only features are updated with Z=1 with probability KS.
"""
function update_Z_feature_between_lists_studied_only!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # Use KS parameter for studied-only items between lists
        if list_number === 1 || list_number === 0
            κ_value = ks_base
        else
            κ_index = list_number - 1
            κ_value = κs[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for target restoration (same as recalled+old case).
Store Z=1 with probability KB.
"""
function update_Z_feature_target_restoration!(word::Word, list_number::Int64)::Nothing
    update_Z_feature_recalled_old!(word, list_number)
    return nothing
end


"""
Update Z feature for recalled+new case when adding new trace.
Store Z = 1 with probability KB
"""
function update_Z_feature_recalled_new_add_trace!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for recalled+old case.
Store Z = 1 with probability KB (both strengthening and adding trace)
"""
function update_Z_feature_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+new case (really new foil).
Add new trace with Z = 1 with probability KT
"""
function update_Z_feature_not_recalled_new!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kt_base
        else
            κ_index = list_number - 1
            κ_value = κt[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Update Z feature for not recalled+old case (target with no trace recalled).
Add trace with Z = 1 with probability KB
"""
function update_Z_feature_not_recalled_old!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters: for list 1 use base, else use array
        if list_number === 1 || list_number === 0
            κ_value = kb_base
        else
            κ_index = list_number - 1
            κ_value = κb[κ_index]
        end
        
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

function update_Z_feature_for_decision!(word::Word, recalled::Bool, answer_old::Bool, is_target::Bool, list_number::Int64)::Nothing
    if recalled && !answer_old
        # Case 1: RECALLED + Answer NEW (confusing foil)
        update_Z_feature_recalled_new_add_trace!(word, list_number)
    elseif recalled && answer_old
        # Case 2: RECALLED + Answer OLD
        update_Z_feature_recalled_old!(word, list_number)
    elseif !recalled && !answer_old
        # Case 3: NOT RECALLED + Answer NEW (really new foil)
        update_Z_feature_not_recalled_new!(word, list_number)
    elseif !recalled && answer_old
        # Case 4: NOT RECALLED + Answer OLD (target with no trace recalled)
        update_Z_feature_not_recalled_old!(word, list_number)
    end
    return nothing
end

# =============================================================================
# CONTENT DISTORTION FUNCTIONS (from E3)
# =============================================================================

"""
Distort probe features with linear decrease in distortion probability from first to last probe.
The distortion probability starts high for the first probe and linearly decreases to 0 after a specified number of probes.

Distort probe content features

Args:
    probes: Vector of probes to potentially distort
    max_distortion_probes: Number of probes until distortion probability reaches 0
    base_distortion_prob: Base probability of distortion for the first probe
    g_word: Geometric distribution parameter for generating new feature values

Returns:
    Tuple of (distorted_probes, original_probes) where original_probes are deep copies for reference
"""
function distort_probes_with_linear_decay(
    probes::Vector{Probe}, 
    max_distortion_probes::Int; 
    base_distortion_prob::Float64 = 0.8,
    g_word::Float64 = 0.3
)::Tuple{Vector{Probe}, Vector{Probe}}
    
    # Create deep copies of original probes for reference
    original_probes = deepcopy(probes)
    distorted_probes = deepcopy(probes)
    
    # Calculate linear decrease in distortion probability
    for i in eachindex(probes)
        if i <= max_distortion_probes
            # Linear decrease from base_distortion_prob to 0
            current_prob = base_distortion_prob * (1 - (i - 1) / max_distortion_probes)
            
            # Debug: Print distortion attempt info for position 1
            if i == 1
                println("[DEBUG-DISTORTION-POS1] Attempting distortion - Probe type: $(probes[i].image.word.type), Distortion prob: $(round(current_prob, digits=3))")
            end
            
            # Apply distortion to each feature of the probe's word
            if rand() < current_prob
                distorted_features_count = 0
                # Distort each feature with the current probability
                for j in eachindex(distorted_probes[i].image.word.word_features)
                    if j <= w_word #only distort normal content features
                        if rand() < current_prob
                            # Generate new feature value using Geometric distribution
                            distorted_probes[i].image.word.word_features[j] = rand(Geometric(g_word)) + 1
                            distorted_features_count += 1
                        end
                    end
                end
                
                # Add debug marker to word.item indicating distortion
                if distorted_features_count > 0
                    original_word = distorted_probes[i].image.word
                    distortion_level = current_prob
                    distortion_info = "DISTORTED_pos$(i)_prob$(round(distortion_level, digits=3))_features$(distorted_features_count)"
                    new_item = "$(original_word.item)_[$(distortion_info)]"
                    
                    # Create new Word instance with modified item (since Word is immutable)
                    new_word = Word(new_item, original_word.word_features, original_word.type, original_word.studypos)
                    
                    # Replace the word in the EpisodicImage (which is mutable)
                    distorted_probes[i].image.word = new_word
                    
                    # Debug: Print when distortion actually happens for position 1
                    if i == 1
                        println("[DEBUG-DISTORTION-POS1] ✓ DISTORTED - Type: $(new_word.type), Features changed: $(distorted_features_count), Item: $(new_item)")
                    end
                else
                    # Debug: Print when distortion was attempted but no features changed for position 1
                    if i == 1
                        println("[DEBUG-DISTORTION-POS1] ✗ No features distorted despite passing probability check - Type: $(distorted_probes[i].image.word.type)")
                    end
                end
            else
                # Debug: Print when distortion probability check failed for position 1
                if i == 1
                    println("[DEBUG-DISTORTION-POS1] ✗ Failed probability check - Type: $(distorted_probes[i].image.word.type)")
                end
            end
        end
        # For probes beyond max_distortion_probes, no distortion (probability = 0)
    end
    
    return distorted_probes, original_probes
end