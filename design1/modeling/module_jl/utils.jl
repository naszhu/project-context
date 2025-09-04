
function fast_concat(vectors::Vector{Vector{T}}) where {T}
    total_length = sum(length(v) for v in vectors)  # Compute total length
    result = Vector{T}(undef, total_length)  # Preallocate memory

    pos = 1
    for v in vectors
        copyto!(result, pos, v, 1, length(v))  # Copy each vector
        pos += length(v)
    end

    return result
end


log_transform(x; k=10) = log1p(k*x) / log1p(k)
# “Notch” or band-stop style transform: strong suppression in mid-range, mild/no suppression at extremes
notch_transform(x; α=10.0, μ=0.5, σ=0.2) = x / (1 + α * exp(-((x - μ)^2) / (2*σ^2)))

# multiplicative-notch version
valley_transform(x; α=0.8, μ=0.5, σ=0.2) = x * (1 - α * exp(-((x - μ)^2) / (2*σ^2)))

"""
   For criterion change across lists: generate a power function that asymptotically increases and flattens out near position 4, here's a simplified version of the code:

   p: # Power exponent for the asymptotic increase; p = 2.0 , roughly stop increasing at 4th position

   currently, this function only have argument inputs p, and though should include arguments of how dimn1 change as well 
"""
function generate_asymptotic_values(p::Float64, within_list_start::Float64, within_list_end::Float64,  between_list_start::Float64,  between_list_end::Float64,b_rate::Float64 )::Matrix{Float64}
    # Generate linearly decreasing dim1 from 6 to 4
    dim1 = asym_decrease(within_list_start, within_list_end,b_rate, n_probes)
    
    t = LinRange(between_list_start, between_list_end, n_lists)   # Normalized range for column positions (0 to 1)
    dim2 = t .^ p  # Apply the power-law to create the asymptotic increase
    
    # 3) Create the 2D matrix by outer-product of dim1 and dim2
    M = dim1 .* transpose(dim2)     # M is of size (n_probes, n_lists)
    
    return M
end


# asym_range(start_val, end_val, beta, n)
# beta 越大越快趋近 end_val
"""
This is for calculating help for criterion_initial
"""
function asym_decrease(start_val::Float64,
                       end_val::Float64,
                       beta::Float64,
                       n::Int)::Vector{Float64}
    @assert n ≥ 1
    [end_val + (start_val - end_val) * exp(-beta * (i - 1) / (n - 1))
     for i in 1:n]
end



"""
the fixed start asympotopically changes vector: gradually decrease the level of increase  
This is currently being used for p_switch*pOld
"""
function generate_asymptotic_increase_fixed_start(start_at::Float64, rate::Float64, num_values::Int64)::Vector{Float64}
    values = zeros(num_values)
    for i in 1:num_values
        values[i] = start_at + (1 - exp(-rate * (i - 1))) * (1 - start_at)
    end
    return values
end


function asym_increase_shift(start_at::Float64,
                              how_much::Float64,
                              how_fast::Float64,
                              n::Int)::Vector{Float64}
    @assert n ≥ 1
    return [start_at + how_much * (1 - exp(-how_fast * (k))) for k in 0:n-1]
end




# Generate κu values using asymptotic decreasing function (from E3)
function asym_decrease_shift_fj(start_at::Float64,
    how_much::Float64,
    how_fast::Float64,
    n::Int)::Vector{Float64}
@assert n ≥ 1
return [start_at - how_much * (1 - exp(-how_fast * k)) for k in 0:n-1]
end

# κu values will be calculated in main file after constants are loaded

# h_j parameter for Z feature usage probability (from E3)
hj_asymptote_increase_val = 0.4
hj_rate = 0.85
hj_base = 0.6

function asym_increase_shift_hj(start_at::Float64,
    how_much::Float64,
    how_fast::Float64,
    n::Int)::Vector{Float64}
@assert n ≥ 1
return [start_at + how_much * (1 - exp(-how_fast * k)) for k in 0:n-1]
end

# h_j values will be calculated in main file after constants are loaded

# =============================================================================
# Z FEATURE HELPER FUNCTIONS (aligned with E3 implementation)
# =============================================================================

"""
    get_Z_feature_value(word::Word) -> Int

Get the Z feature value from a word's feature vector.
Returns the Z feature (tested_before) value, or 0 if not present.
"""
function get_Z_feature_value(word::Word)::Int
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        return word.word_features[tested_before_feature_pos]
    else
        return 0  # Default to not tested before
    end
end

"""
    set_Z_feature_value!(word::Word, value::Int)

Set the Z feature value in a word's feature vector.
"""
function set_Z_feature_value!(word::Word, value::Int)
    if use_Z_feature && length(word.word_features) >= tested_before_feature_pos
        word.word_features[tested_before_feature_pos] = value
    end
end

"""
    update_Z_feature_probabilistic!(word::Word, probability::Float64)

Update the Z feature with given probability.
If Z=0 (incorrect/missing), replace with probability.
If Z=1, keep as 1.
"""
function update_Z_feature_probabilistic!(word::Word, probability::Float64)
    if use_Z_feature
        current_z = get_Z_feature_value(word)
        if current_z == 0 && rand() < probability
            set_Z_feature_value!(word, 1)
        end
        # If already 1, keep it as 1 (no change needed)
    end
end

"""
    update_Z_feature_target_restoration!(word::Word, list_number::Int)

Update Z feature for targets during restoration according to E3 rules.
Used for Case 2: RECALLED + Answer OLD - strengthening using KB probability.
"""
function update_Z_feature_target_restoration!(word::Word, list_number::Int)
    if use_Z_feature
        # Use KB probability for strengthening when recalled and answered OLD
        update_Z_feature_probabilistic!(word, KB)
    end
end

"""
    update_Z_features_between_lists!(image_pool::Vector{EpisodicImage})

Update Z features for all studied-only features between lists according to E3 rules.
Uses KS probability for all studied features.
"""
function update_Z_features_between_lists!(image_pool::Vector{EpisodicImage})
    if use_Z_feature
        for image in image_pool
            # Apply KS probability to all studied features between lists
            update_Z_feature_probabilistic!(image.word, KS)
        end
    end
end

"""
    update_Z_feature_for_decision!(word::Word, recalled::Bool, answer_old::Bool, is_target::Bool)

Update Z feature based on probe evaluation decision according to E3 rules.
Handles all four cases from the E3 specification.
"""
function update_Z_feature_for_decision!(word::Word, recalled::Bool, answer_old::Bool, is_target::Bool)
    if !use_Z_feature
        return
    end
    
    if recalled && !answer_old
        # Case 1: RECALLED + Answer NEW (confusing foil - list version used)
        # For strengthening: If Z = 0, replace with KB; If Z = 1, keep as 1
        # For adding new trace: Store Z = 1 with probability KB
        update_Z_feature_probabilistic!(word, KB)
        
    elseif recalled && answer_old
        # Case 2: RECALLED + Answer OLD
        # Both strengthening and adding trace: Store Z = 1 with probability KB
        update_Z_feature_probabilistic!(word, KB)
        
    elseif !recalled && !answer_old
        # Case 3: NOT RECALLED + Answer NEW (really new foil)
        # Add new trace with Z = 1 with probability KT
        update_Z_feature_probabilistic!(word, KT)
        
    elseif !recalled && answer_old
        # Case 4: NOT RECALLED + Answer OLD (target with no trace recalled)
        # Add trace with Z = 1 with probability KT
        update_Z_feature_probabilistic!(word, KT)
    end
end

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================
# Function to generate asymptotic increasing values over lists (from E3)
function asym_increase_shift(start_at::Float64,
    how_much::Float64,
    how_fast::Float64,
    n::Int)::Vector{Float64}
@assert n ≥ 1
return [start_at + how_much * (1 - exp(-how_fast * (k))) for k in 0:n-1]
end
