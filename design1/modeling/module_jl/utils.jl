
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
