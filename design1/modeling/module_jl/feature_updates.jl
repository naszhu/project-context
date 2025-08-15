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
Restore features from source to target with probability p_recallFeatureStore
"""
function restore_features!(target_features::Vector{Int}, source_features::Vector{Int}, p_recallFeatureStore::Float64; is_store_mismatch::Bool=is_store_mismatch, is_ctx::Bool=false)::Nothing

    
    for _ in 1:n_units_time_restore
        for i in eachindex(source_features)
            current_value = target_features[i]
            source_value = source_features[i]

            if is_ctx
                @assert length(target_features)==nU+nC "not same length"
                if i>nU # for CC
                    c_usenow = c_context_c[1] #, perfect storage
                    u_star_now = u_star_context[1] + u_advFoilInitialT
                else # for unchanging 
                    c_usenow = c_context_c[1]
                    u_star_now = u_star_context[1] + u_advFoilInitialT 
                end
            else #if content
                c_usenow = c # c is a scalar, not an array
                u_star_now = u_star[1] + u_advFoilInitialT 
            end
            
            #is_store_mismatch is false now so no mismatch stored
            if (current_value === 0) 

                target_features[i] = rand() < u_star_now+adv_u_star_strengthen ? (rand() < c_usenow+adv_c_strenghten ? source_value : rand(Geometric(g_context)) + 1) : current_value
                # target_features[i] = rand() < u_star_now ? (rand() < c_usenow ? source_value : rand(Geometric(g_context)) + 1) : current_value
            end

            
        end 
    end # for _ in 1:n_units_time_restore
end
