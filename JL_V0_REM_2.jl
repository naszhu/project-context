#= ===========================================================================================================
Author      : Shuchun (Lea) Lai
Date        : 2024-01-29
Description : now is when I add context
            

Notes       : axes(a, 1) iterate index of axes of dimensions
eachindex() go through each index
enumerate 
                ...
=========================================================================================================== =#

using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
n_words = 20; # Number of items
w = 20; # Number of features
g = 0.3; #geometric base rate
n_units_time = 10; #number of steps
u_star = 0.04; # Probability of storage
c = 0.7; # Probability of copy
n_probes = 20; # Number of probes to test
n_simulations = 5000;
n_lists = 10;


function generate_word_vector(w, g)
    return rand(Geometric(g),w).+1
end


# result_vec = zeros(n_words,w)


function store_episodic_image(n_units_time,u_star,word_vector, c, g; result_vec = zeros(Int,length(word_vector)))
    

    for j_index in eachindex(result_vec)#axes(result_vec,2)
        j = result_vec[j_index];
        if j==0 # if nothing is stored
            stored_val =(rand() < u_star ? 1 : 0)*word_vector[j_index];
            if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                copied_val = rand() < c ? stored_val : rand(Geometric(g)) + 1;
                result_vec[j_index]=copied_val;
            end
        else #if something has already been stored
            copied_val = j; # keep the same
            result_vec[j_index]=copied_val;
        end
    end
    # println(result_vec)

    n_units_time -= 1;
    if n_units_time>0
        return store_episodic_image(n_units_time,u_star,word_vector, c, g,result_vec=result_vec)
    else 
        return result_vec
    end
end

word_vector = generate_word_vector(w, g);
store_episodic_image(n_units_time,u_star,word_vector, c, g)


function calculate_likelihood_ratio(probe, image, g, c)

    lambda = Float64[];

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  # for those that doesn't match
            push!(lambda, 1);
        elseif image[k] != 0 
            if image[k] != probe[k]
                push!(lambda, 1-c);
            elseif image[k] == probe[k]
                push!(lambda, (c + (1-c)*g*(1-g)^(image[k]-1))/(g*(1-g)^(image[k]-1)));
            else 
                error("error image match")
            end
        else
            error("error here")
        end
    end

    return prod(lambda)
end

a = calculate_likelihood_ratio([2 3 4 3], [2 2 1 0], 0.4, 0.7);
a

# Function to choose a probe (either a target or a distractor)
function choose_probe(words, g, w, is_target=true)
    if is_target
        # Choose a target (studied word)
        return rand(words)
    else
        # Generate a distractor (new word)
        return generate_word_vector(w, g)
    end
end

# Expanded main simulation function
function simulate_rem(g, c, u_star, w, n_words, n_units_time,n_probes)
    # Generate word vectors and store episodic images
    words = [generate_word_vector(w, g) for _ in 1:n_words];
    episodic_images = [store_episodic_image(n_units_time,u_star,iword , c, g) for iword in words];#(word, c, u_star)
    
    # Simulation results
    results = Array{Any}(undef, n_probes);

    for i in 1:n_probes
        # Choose a probe (randomly decide if it's a target or a distractor)
        is_target = rand(Bool);
        probe = choose_probe(words, g, w, is_target);

        # Calculate likelihood ratios for each episodic image
        likelihood_ratios = [calculate_likelihood_ratio(probe, image, g, c) for image in episodic_images];

        # Calculate the odds of the probe being an old item
        # println(likelihood_ratios)
        odds = 1 / n_words * sum(likelihood_ratios);

        decision_isold = odds>1 ? 1 : 0;

        # push!(results, (decision_isold, is_target, probe, odds, likelihood_ratios));
        # Storing results as a NamedTuple
        result = (
            decision_isold = decision_isold, 
            is_target = is_target, 
            probe = probe, 
            odds = odds, 
            likelihood_ratios = likelihood_ratios
        )
        results[i] = result
    end

    return results
end
# simulate_rem(g, c, u_star, w, n_words, n_units_time, n_probes)

function simulate_multiple_lists(n_lists, g, c, u_star, w, n_words, n_units_time, n_probes, n_simulations)

    # cols = [:list_number, :simulation_number, :decision_isold, :is_target, :probe, :odds, :likelihood_ratios] # Add more columns as needed
    # all_results_df = DataFrame(;cols...)
    all_results_df = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[], probe = Vector{Int}[], odds = Float64[], likelihood_ratios = Vector{Float64}[])

    for list_num in 1:n_lists
        for sim_num in 1:n_simulations
            results = simulate_rem(g, c, u_star, w, n_words, n_units_time, n_probes);
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                row = [list_num, ires, sim_num, res.decision_isold, res.is_target, res.probe, res.odds, res.likelihood_ratios] # Add more fields as needed
                push!(all_results_df, row)
            end
        end
    end

    return all_results_df

end

all_results = simulate_multiple_lists(n_lists, g, c, u_star, w, n_words, n_units_time, n_probes, n_simulations);
all_results
# [i[1].decision_isold for i in all_results]
# result = @linq df |>
#              @where(:group .!= 'C') |>
#              @select(:group, :value) |>
#              @by(:group, MeanValue = mean(:value))

DF = @chain all_results begin
    @by([:list_number, :is_target, :test_position], :meanx = mean(:decision_isold))
end


@rput DF
R"""
library(ggplot2)
library(dplyr)
head(DF)
DF2 = DF %>% mutate(meanx = case_when(is_target ~ meanx, TRUE ~ 1-meanx))
# head(DF2)
ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
    geom_point(aes(color=is_target))+
    geom_line(aes(color=is_target))+
    facet_grid(list_number~.)
    # ylim(0.5,1)
"""