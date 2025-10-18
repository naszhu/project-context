
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

#
##############################################################
# Unified Asymptotic Function Core
###############################################################
# General kernel for asymptotic increase or decrease
# f(x) = start + dir * (Δ) * (1 - exp(-rate * x))
# direction: +1 = increase, -1 = decrease
###############################################################
function _asym_core(start::Float64, change::Float64, rate::Float64, n::Int; direction::Int=1)
    @assert n ≥ 1
    return [start + direction * change * (1 - exp(-rate * k)) for k in 0:n-1]
end


###############################################################
# 1. asym_decrease_shift_fj  (κu values, from E3)
###############################################################
function asym_decrease_shift_fj(start_at::Float64,
                                how_much::Float64,
                                how_fast::Float64,
                                n::Int)::Vector{Float64}
    return _asym_core(start_at, how_much, how_fast, n; direction=-1)
end


###############################################################
# 2. asym_increase_shift_hj  (h_j parameter, from E3)
###############################################################
function asym_increase_shift_hj(start_at::Float64,
                                how_much::Float64,
                                how_fast::Float64,
                                n::Int)::Vector{Float64}
    return _asym_core(start_at, how_much, how_fast, n; direction=+1)
end


###############################################################
# 3. asym_increase_shift  (general increasing)
###############################################################
function asym_increase_shift(start_at::Float64,
                             how_much::Float64,
                             how_fast::Float64,
                             n::Int)::Vector{Float64}
    return _asym_core(start_at, how_much, how_fast, n; direction=+1)
end


###############################################################
# 4. asym_decrease_shift  (general decreasing)
###############################################################
function asym_decrease_shift(start_at::Float64,
                             how_much::Float64,
                             how_fast::Float64,
                             n::Int)::Vector{Float64}
    return _asym_core(start_at, how_much, how_fast, n; direction=-1)
end


###############################################################
# 5. asym_decrease_to_end  (explicit end value)
###############################################################
function asym_decrease_to_end(start_at::Float64,
                              end_at::Float64,
                              how_fast::Float64,
                              n::Int)::Vector{Float64}
    how_much = start_at - end_at
    return _asym_core(start_at, how_much, how_fast, n; direction=-1)
end


###############################################################
# 6. asym_decrease  (scaled exponential decrease between two values)
###############################################################
function asym_decrease(start_val::Float64,
                       end_val::Float64,
                       beta::Float64,
                       n::Int)::Vector{Float64}
    @assert n ≥ 1
    return [end_val + (start_val - end_val) * exp(-beta * (i - 1) / (n - 1))
            for i in 1:n]
end


###############################################################
# 7. generate_asymptotic_increase_fixed_start (increase toward 1)
###############################################################
function generate_asymptotic_increase_fixed_start(start_at::Float64,
                                                  rate::Float64,
                                                  num_values::Int64)::Vector{Float64}
    return [start_at + (1 - exp(-rate * (i - 1))) * (1 - start_at)
            for i in 1:num_values]
end


###############################################################
# 7b. linear_increase_diminishing  (linear diminishing increments)
# Creates a nonlinear increase where the increment amount itself decreases linearly
# Each step increases by less than the previous step, with the decrease being constant
###############################################################
function linear_increase_diminishing(start_at::Float64,
                                     initial_increment::Float64,
                                     decrement_per_step::Float64,
                                     n::Int)::Vector{Float64}
    @assert n ≥ 1
    result = Vector{Float64}(undef, n)
    result[1] = start_at
    
    for k in 2:n
        # Increment decreases linearly: initial_increment - decrement_per_step * (k-2)
        current_increment = max(0.0, initial_increment - decrement_per_step * (k - 2))
        result[k] = result[k-1] + current_increment
    end
    
    return result
end


###############################################################
# 8. generate_asymptotic_values (2D matrix, criterion change)
###############################################################
function generate_asymptotic_values(p::Float64,
                                    within_list_start::Float64,
                                    within_list_end::Float64,
                                    between_list_start::Float64,
                                    between_list_end::Float64,
                                    b_rate::Float64)::Matrix{Float64}
    # Uses asym_decrease for within-list decay and between-list decay
    dim1 = asym_decrease(within_list_start, within_list_end, b_rate, n_probes)
    dim2 = asym_decrease(between_list_start, between_list_end, 5.0, n_lists)
    dim2 = dim2 .^ p
    return dim1 .* transpose(dim2)
end


###############################################################
# 8b. generate_asymptotic_values_linear_diminishing (2D matrix with linear diminishing for between-list)
# Same structure as generate_asymptotic_values but uses linear_increase_diminishing for between-list dimension
###############################################################
function generate_asymptotic_values_linear_diminishing(p::Float64,
                                                       within_list_start::Float64,
                                                       within_list_end::Float64,
                                                       between_list_start::Float64,
                                                       between_list_initial_increment::Float64,
                                                       between_list_decrement_per_step::Float64)::Matrix{Float64}
    # dim1 is n_probes long (within-list, rows)
    # dim2 is n_lists long (between-list, columns)
    # Result is n_probes x n_lists matrix
    dim1 = asym_decrease(within_list_start, within_list_end, 5.0, n_probes)
    dim2 = linear_increase_diminishing(between_list_start, between_list_initial_increment, between_list_decrement_per_step, n_lists)
    dim2 = dim2 .^ p
    # transpose(dim2) makes it a row vector, so outer product gives n_probes x n_lists
    return dim1 .* transpose(dim2)
end


###############################################################
# 8c. asym_increase_formula (formula-based asymptotic increase like E3's h_j)
# Creates an asymptotic increase using the formula Z(j) = 1 - [1-Z] R^(j-2)
# where Z is the base value and R controls the rate of approach to 1
###############################################################
function asym_increase_formula(z_base::Float64,
                              r_rate::Float64,
                              n::Int)::Vector{Float64}
    @assert n ≥ 1
    @assert 0.0 ≤ z_base ≤ 1.0 "z_base must be between 0 and 1"
    @assert r_rate > 0.0 "r_rate must be positive"
    
    result = Vector{Float64}(undef, n)
    result[1] = z_base
    
    for j in 2:n
        # Z(j) = 1 - [1-Z] R^(j-2)
        result[j] = 1.0 - (1.0 - z_base) * (r_rate^(j-2))
    end
    
    return result
end


###############################################################
# 8d. generate_asymptotic_values_formula (2D matrix with formula-based increase for between-list)
# Same structure as generate_asymptotic_values_linear_diminishing but uses formula-based asymptotic for between-list dimension
# This mimics E3's h_j asymptotic behavior for criterion_initial's list dimension
###############################################################
function generate_asymptotic_values_formula(p::Float64,
                                           within_list_start::Float64,
                                           within_list_end::Float64,
                                           between_list_base::Float64,
                                           between_list_r_rate::Float64)::Matrix{Float64}
    # dim1 is n_probes long (within-list, rows) - kept same as before
    # dim2 is n_lists long (between-list, columns) - uses E3-style formula
    # Result is n_probes x n_lists matrix
    dim1 = asym_decrease(within_list_start, within_list_end, 5.0, n_probes)
    dim2 = asym_increase_formula(between_list_base, between_list_r_rate, n_lists)
    dim2 = dim2 .^ p
    # transpose(dim2) makes it a row vector, so outer product gives n_probes x n_lists
    return dim1 .* transpose(dim2)
end
