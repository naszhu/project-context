using Distributions: Geometric

######### OK these were added from E3, used in memory_restorage

"""
Helper functions for feature updates in memory restorage
"""

"""
Add features from empty target to match probe features
assume read nU from constant.jl
cu and cc is copying parameter value
"""
function add_features_from_empty!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64, g_param::Float64; u_adv=0.0, cu::Float64=0.0)::Nothing

    @assert length(target_features) == length(probe_features) "LENGTH NOT MATCH"

    for i in eachindex(probe_features)

        if cu==0.0
            c_param = cc
        else
            if i > nU #FIXME: fast workaround here
                c_param = cc
            else
                c_param = cu
            end
        end
        j = target_features[i]
        if j == 0
            target_features[i] = rand() < u_star ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
        end
    end

end

"""
Restore features from source to target during memory restoration
Based on add_feature_during_restore! function logic
"""
function restore_features!(target_features::Vector{Int}, probe_features::Vector{Int}, u_star::Float64, cc::Float64=c_context_c[1], g_param::Float64=g_context; u_adv::Float64=0.0, cu::Float64=0.0, is_ctx::Bool=false)::Nothing

    # Use safe bounds checking instead of assertion
    max_index = min(length(target_features), length(probe_features))
    is_content = cu === 0.0 # if cu is 0, then this is a content

    for i in 1:max_index
        # Special handling for Z feature (last feature) - only if enabled
        # skip the Z feature here, this will be specifically handled later
        if use_Z_feature && (i === tested_before_feature_pos) && is_content
            # Z feature: skip here, will be handled specifically later
        else # when feature i is not Z feature, or all other else situations
            # Normal features: use existing geometric distribution logic

            if is_content # cu == 0.0? this means when this is a content (so no cu will be inputed)
                c_param = cc
            else     
                if i > nU # FIXME: fast workaround here
                    c_param = cc
                else
                    c_param = cu
                end
            end
            
            j = target_features[i]
            if j === 0
                target_features[i] = rand() < (u_star + u_adv) ? (rand() < c_param ? probe_features[i] : rand(Geometric(g_param)) + 1) : j
            end
        end
    end

    return nothing
end

# =============================================================================
# Z FEATURE UPDATE FUNCTIONS (adapted from design3)
# =============================================================================

"""
Update Z feature during study for targets in E1
Since E1 has no confusing foils, only κu is needed for targets
"""
function update_Z_feature_study!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # κ parameters start from list 2, so κ[1] = list 2, κ[2] = list 3, etc.
        # For list 1, use base κu value (no asymptotic effect yet)
        if list_number === 1
            κ_value = ku_base
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end
        
        # Set Z feature value based on κu probability
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end

"""
Get Z feature value from word (helper function)
"""
function get_Z_feature_value(word::Word)::Int64
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0
    end
end

"""
Update Z feature during restoration for targets in E1
Only targets need updating since E1 has no confusing foils

I don't know if this is needed for experiment 1, but this function keep for now, can comment out where calls this function later
"""
function update_Z_feature_target_restoration!(word::Word, list_number::Int64)::Nothing
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        # Use same κu logic as study
        if list_number === 1
            κ_value = ku_base
        else
            κ_index = list_number - 1
            κ_value = κu[κ_index]
        end
        
        # Update Z feature during restoration
        word.word_features[tested_before_feature_pos] = rand() < κ_value ? 1 : 0
    end
    return nothing
end
