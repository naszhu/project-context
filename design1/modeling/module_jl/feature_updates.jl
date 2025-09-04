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
