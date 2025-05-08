#= ===========================================================================================================
Author      : Shuchun (Lea) Lai
Date        : 2024-03-18
Description : modified on 3/18 try to add final test


Notes       : some important modifications are done, and some lines are marked in red for problems, this version doesn't include any learning of test images
...
=========================================================================================================== =#

using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
function printimg(img, img2) 
    tt1=img.word.word_features
    tt12 = img2.word.word_features
    tt2=[img.context_features[i].value for i in eachindex(img.context_features)]
    tt22=[img2.context_features[i].value for i in eachindex(img2.context_features)]
    tt3=[img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item,DataFrame(word1=tt1, word2=tt12), DataFrame(fval1=tt2,fval2=tt22,feature_type=tt3))
end

function printimg(img) 
    tt1=img.word.word_features
    tt2=[img.context_features[i].value for i in eachindex(img.context_features)]
    tt3=[img.context_features[i].type for i in eachindex(img.context_features)]
    println(img.word.item,DataFrame(word1=tt1), DataFrame(fval1=tt2,feature_type=tt3))
end

function printimgpool(image_pool) 
    word_features_list = []  # Store word features for each image
    feature_values = []
    feature_types = []
    
    for img in image_pool
        push!(word_features_list, img.word.word_features)  
        push!(feature_values, [cf.value for cf in img.context_features])
        push!(feature_types, [cf.type for cf in img.context_features])
    end
    
    word_df = DataFrame(word_features_list, :auto)
    feature_df = DataFrame(feature_values, :auto)
    insertcols!(feature_df, 1, :ft => feature_types[1])
    
    return (word_df, feature_df) 
end
# printimgpool(image_pool)

printword(wordimg)  = [wordimg[i].word_features for i in eachindex(wordimg)];
printfeature(ft) = [[ft[i][j].value for j in eachindex(ft[1])] for i in eachindex(ft)];

n_finalprobs = 420;
num_halflistprob = 21; # number of probes in each list in half

n_lists = 10;
n_probes = 20; # Number of probes to test
n_words = 20;
n_simulations = 200
n_units_time = 10; #number of steps

c = 0.7; #copying parameter - 0.8 for context copying 
w_context =30; #2*15
w_word = 20;
words_per_list = 20;
g_word = 0.3; #geometric base rate
g_context = 0.2; #geometric base rate of context
p_change = 0.3;
u_star = 0.04; # Probability of storage 0.34 for context 
c = 0.7; # Probability of copy
context_tau = 1e5
context_tau_f = 2;
# Data Structures                         
struct Word
    item::String
    word_features::Vector{Int64}
end

mutable struct ContextFeature
    value::Int64 
    type::Symbol  # :word_change, :list_change, :general
    change_probability::Float64
end

mutable struct EpisodicImage
    word::Word
    context_features::Vector{ContextFeature}
    list_number::Int64
end

struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
end

# EpisodicImage(Word("Word1", [1, 4, 3, 6, 4, 4, 1, 1, 1, 3  …  2, 1, 1, 2, 2, 1, 3, 3, 1, 1]), ContextFeature[ContextFeature(9, :general, 0.15), ContextFeature(13, :general, 0.15), ContextFeature(1, :general, 0.15), ...)
# episodic_image.word :# Word("Word1", [1, 4, 3, 6, 4, 4, 1, 1, 1, 3  …  2, 1, 1, 2, 2, 1, 3, 3, 1, 1])
# episodic_image.context_features: 30-element Vector{ContextFeature}:
#  ContextFeature(9, :general, 0.15)
#  ContextFeature(13, :general, 0.15)
#  ⋮
#  ContextFeature(6, :list_change, 0.15)
#  ContextFeature(2, :list_change, 0.15)

# Functions
function generate_features(distribution, length)
    return rand(distribution, length) .+ 1
end


function generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change,list_num)
    
    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    
    for i in 1:n_words

        word = Word("Word$(i)L$(list_num)", rand(Geometric(g_word), w_word) .+ 1) 
        word_list[i]=word;
    end
    
    
    return word_list
end

#    @time generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    @profile generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    Profile.print()
#    @time generate_study_list2(n_words, w_context, w_word, g_context, g_word, p_change);

# tempword1, tf1= generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change,1);
# printfeature(tf1)

#    word_list, word_change_feature_list =  generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);


function store_episodic_image(image_pool, word, context_features, u_star, c, n_units_time, g_word, g_context, list_num)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features))), [ContextFeature(zero(Int64), cf.type, cf.change_probability) for cf in context_features], list_num) # Zero word features
    
    for _ in 1:n_units_time
        for i in eachindex(new_image.word.word_features)
            # println(new_image.word.word_features[i])
            # if new_image.word.word_features[i] == 0  # Check if empty
            #     # println("22")
            #     if rand() < u_star
            #         new_image.word.word_features[i] = word.word_features[i]  # Store
            #         if rand() > c
            #             # Sample from geometric distribution when not copying
            #             new_image.word.word_features[i] = rand(Geometric(g_word))+1  # Adjust distribution as needed
            #             # println("here")
            #         end
            #     end
            # end
            j=new_image.word.word_features[i]
            
            # copystore_process(new_image,j,u_star,)
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star ? 1 : 0)*word.word_features[i];
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c ? stored_val : rand(Geometric(g_word)) + 1;
                    new_image.word.word_features[i]=copied_val;
                end
            end
        end
        
        for ic in eachindex(new_image.context_features)
            j = new_image.context_features[ic].value
            
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star+0.05 ? 1 : 0)*context_features[ic].value;
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c+0.1 ? stored_val : rand(Geometric(g_context)) + 1;
                    new_image.context_features[ic].value=copied_val;
                end
            end
            
        end
        # println("Word Features: ", new_image.word.word_features)
    end
    
    push!(image_pool, new_image)
    # println("Word Features: ", new_image.word.word_features)
    
    # return image_pool
end

image_pool = [];
context_features = []; # Initialize context features
for i in eachindex(tempword1)
    store_episodic_image(image_pool, tempword1[i], tf1[i], u_star, c, n_units_time, g_word, g_context, 1);
end
printimg(image_pool[2])

## this function only do word_change_features for last word studied, then keeps the same?
function generate_probe(target_or_foil, studied_words, list_change_features, general_context_features, list_num; g_context=g_context, w_word=w_word)
    
    if target_or_foil == :target # make it half and half
        target_word = rand(studied_words) 
    elseif target_or_foil == :foil  # Foil case
        target_word = Word(randstring(8), generate_features(Geometric(g_word), w_word)) 
    else
        error("probetypewrong")
    end
    
    
    
    # println([i.value for i in word_change_features],[i.value for i in word_change_features_copy])
    # 2. & 3. Keep list_change and general features the same
    # println(1,general_context_features, word_change_features_copy, list_change_features)
    current_context_features = vcat(general_context_features, list_change_features) 
    
    return EpisodicImage(target_word, current_context_features, list_num) 
end

# p1=generate_probe(:target, word_list, word_change_feature_list[1], list_change_context_features, general_context_features);
# image_context2 = [cf.value for cf in word_change_feature_list[1]]
# image_context3 = [cf.value for cf in p1.context_features]



function calculate_likelihood_ratio(probe, image, g, c)
    
    lambda = Vector{Float64}(undef, length(probe));
    
    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  # for those that doesn't match
            lambda[k] = 1;
        elseif image[k] != 0 
            if image[k] != probe[k]
                lambda[k] = 1-c;
                # println(1-c)
            elseif image[k] == probe[k]
                lambda[k] = (c + (1-c)*g*(1-g)^(image[k]-1))/(g*(1-g)^(image[k]-1));
            else 
                error("error image match")
            end
        else
            error("error here")
        end
    end
    
    return prod(lambda)
end

calculate_likelihood_ratio([2 3 4 3], [2 2 1 0], 0.4, 0.7)

function calculate_two_step_likelihood(probe, image, context_tau, g_word,g_context, c)
    
    probe_context = [cf.value for cf in probe.context_features];
    image_context = [cf.value for cf in image.context_features];
    context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
    if context_likelihood > context_tau 
        word_likelihood = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)
        return word_likelihood
    else
        return 344523466743  # Or another value to indicate context mismatch
    end
end

# context_tau
# [calculate_two_step_likelihood(probe, image, 11, g_word, g_context, c) for image in image_pool]
# for episodic_image in image_pool
#     # println("Word Features: ", episodic_image.word.word_features)
#     context_feature_values = [cf.value for cf in episodic_image.context_features]
#     # println("Context Feature Values: ", context_feature_values)
# end

# printimg(image_pool[19], probe) 

# context_tau = 1e25
# prob1=generate_probe(:target, word_list, word_change_feature_list[1], list_change_context_features, general_context_features);
# probe_context = [cf.value for cf in prob1.context_features]
# image_context = [cf.value for cf in image_pool[181].context_features]
# cat(probe_context,image_context; dims=2)|>transpose

# context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_word,c )

# calculate_two_step_likelihood(prob1, image_pool[181], context_tau, g_word,g_context, c)
 

function probe_evaluation2(image_pool, probes)
    results = Array{Any}(undef, length(probes));
    for i in eachindex(probes)
    
        likelihood_ratios = [calculate_two_step_likelihood(probes[i].image, image, context_tau_f, g_word, g_context, c) for image in image_pool] |> x -> filter(e -> e != 344523466743, x)
        
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        decision_isold = odds > 1 ? 1 : 0
        
        # Store results (modify as needed)
        result = (decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, likelihood_ratios = likelihood_ratios, list_num = probes[i].image.list_number) #! made changes to results, format different than that in inital 
        results[i] = result
    end
    
    return results
end

function probe_evaluation(image_pool, word_list,n_lists,list_change_context_features, general_context_features, n_words, list_num)
    results = Array{Any}(undef, n_probes);
    for i in 1:n_probes
        # Choose target or foil, generate probe (implementation needed)
        is_target = rand(Bool) ?  :target : :foil;
        probe = generate_probe(is_target, word_list, list_change_context_features, general_context_features, list_num) 
        # calculate_two_step_likelihood(prob1, image_pool[181], context_tau, g_word,g_context, c)
        
        # Calculate likelihoods (with built-in context filtering)
        likelihood_ratios = [calculate_two_step_likelihood(probe, image, context_tau, g_word, g_context, c) for image in image_pool] |> x -> filter(e -> e != 344523466743, x)
        
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        decision_isold = odds > 1 ? 1 : 0
        
        # Store results (modify as needed)
        result = (decision_isold = decision_isold, is_target = is_target, probe = probe, odds = odds, likelihood_ratios = likelihood_ratios)
        results[i] = result
    end
    
    return results
end




function generate_finalt_probes(image_pool, condition,general_context_features,list_change_context_features)
    # num_images = length(image_pool)
    list_images = Dict{Int64, Vector{EpisodicImage}}()
    for img in image_pool
        push!(get!(list_images, img.list_number, Vector{EpisodicImage}()), img)
    end

    lists = keys(list_images) |> collect |>sort;
    probes = Vector{Probe}()
    if condition == :backward
        lists = reverse(lists)
    elseif condition == :true_random
        all_images = vcat(values(list_images)...)  # Combine all lists
        shuffle!(all_images)  # Shuffle all images together
        list_images = Dict{Int64, Vector{EpisodicImage}}(1 => all_images)
        lists = keys(list_images)
    end

    for list_number in lists

        for cf in list_change_context_features
            if rand() <  0.3 #cf.change_probability # this equals p_change
                cf.value = rand(Geometric(g_context)) + 1 
            end
        end

        images = list_images[list_number]

        if condition != :true_random
            shuffle!(images)  # Shuffle images within the list
            num_probelist = 14;
        else 
            num_probelist = 14*10;
        end
        
        # Generate targets from shuffled list and foils anew
        
        probe = repeat([:target, :foil], outer = num_probelist) |>shuffle! ;  # The number of probe is wrong here

        for iprobe in eachindex(probe)  # Assuming 35 targets per list or condition
            crrcontext = vcat(general_context_features, list_change_context_features);
            if probe[iprobe]==:target
                # println(list_number,images)
                push!(probes, Probe(EpisodicImage(pop!(images).word, crrcontext, list_number),:target))
            elseif probe[iprobe]==:foil
                push!(probes, Probe(EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1), crrcontext, list_number),:foil))  # Generate a new foil
            else
                error("probe type wrong!")
            end
        end

    end


    return probes
end



function simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations)
    # 1. Initialization
    #    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[], probe = EpisodicImage[], odds = Float64[], likelihood_ratios = Vector{Float64}[])
    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[])
    df_final = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], condition = Symbol[], decision_isold = Int[], is_target = Bool[],odds = Float64[])
    
    for sim_num in 1:n_simulations
        
        #    sim_num=1
        image_pool = []
        general_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)]
        list_change_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]
        
        for list_num in 1:n_lists
            
            word_list = generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change, list_num);
            
            for j in eachindex(word_list) 
                current_context_features = vcat(general_context_features, list_change_context_features);
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, u_star, c, n_units_time, g_word, g_context, list_num); 
            end
            
            results = probe_evaluation(image_pool, word_list,n_lists,list_change_context_features, general_context_features, n_words, list_num)
            
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds] # Add more fields as needed
                #    row = [list_num, ires, sim_num, res.decision_isold, tt, res.probe, res.odds, res.likelihood_ratios] # Add more fields as needed
                push!(df_inital, row)
            end
            # Update list_change_context_features 
            for cf in list_change_context_features
                if rand() <  0.3 #cf.change_probability # this equals p_change
                    cf.value = rand(Geometric(g_context)) + 1 
                end
            end

            # println([i.value for i in list_change_context_features])
            
        end

        #final test here
        for icondition in [:forward, :backward, :true_random]
            finalprobes = generate_finalt_probes(image_pool, icondition,general_context_features,list_change_context_features);
            results_final = probe_evaluation2(image_pool, finalprobes);
            for ii in eachindex(results_final)
                res = results_final[ii]
                push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target == :target ? true : false, res.odds])
            end 
        end


    end
    
    return df_inital, df_final
end




all_results, allresf  = simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations)
# all_results 

#   @profile simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations);
#    Profile.print()

DF = @chain all_results begin
    @by([:list_number, :is_target, :test_position, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position], :meanx = mean(:meanx))
end

DFf = @chain allresf begin
    @by([:list_number, :is_target, :test_position, :condition, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))
    @transform(:condition = string.(:condition)) 
end

allresf = @chain allresf begin @transform(:condition = string.(:condition))end
# DFf
# using CSV
# CSV.write("temp.csv", DF)

@rput DF
R"""
library(ggplot2)
library(dplyr)
DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
facet_grid(list_number~.)

# ylim(0.5,1)
"""

@rput allresf
R"""
library(ggplot2)
library(dplyr)
# DF2 = DFf %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ meanx))%>%
# mutate(test_position=as.numeric(test_position))%>%
# mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
# group_by(test_position_in_chunks,is_target,condition)%>%
# summarize(meanx = mean(meanx))

DF22 = allresf %>% 
mutate(test_position=as.numeric(test_position))%>%
mutate(test_position_in_chunks = cut_number(test_position,n=10))%>%
group_by(test_position_in_chunks,is_target,condition,simulation_number)%>%
mutate(meanx = mean(decision_isold))%>%
group_by(test_position_in_chunks,is_target,condition)%>%
mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
summarize(meanx = mean(meanx))
# head(DF2)
ggplot(data=DF22, aes(x=test_position_in_chunks,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
facet_grid(condition~.)+
scale_x_discrete(guide = guide_axis(angle = 45))

# ylim(0.5,1)

"""