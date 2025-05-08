#= ===========================================================================================================
   Author      : Shuchun (Lea) Lai
   Date        : 2024-04-23
   Description :
                

   Notes       : This version is newly created as the clean version of the simulation
                 ...
   =========================================================================================================== =#



using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
using RData


# params = [n_units_time, n_less, c, w_word, w_context, g_word, g_context, u_star]

data = load("SAVED_data_initialtest.RData")["dfnow"];
# data
# or for RDS
# data = load("data.rds")


n_simulations = 50
context_tau = 1e4
criterion_final = 1
is_firststage = true;
is_finaltest = false;
is_onlyaddtrace = false; #add but not strengtening trace

is_onlyprobe_changecontext = true
P_s = [0.2,0.25,0.3, 0.35,0.4,0.45, 0.49,0.993,0.999, 1] ;#proportion feature 

const is_store_mismatch = true; #if mismatched value is restored during test
const n_finalprobs = 420;
const num_halflistprob = 21; # number of probes in each list in half

const n_lists = 10;
const n_probes = 20; # Number of probes to test
const n_words = 20;

const words_per_list = 20;
const p_change = 0.3;

const context_tau_f = 20;

const p_listchange_finalstudy = 0.1; #either of these contribute to differences between list 
const p_listchange_finaltest = 0.1;


####################################################################
# Data structures
#
####################################################################

struct Word
    item::String
    word_features::Vector{Int64}
    type::Symbol
end

mutable struct EpisodicImage
    word::Word
    context_features::Vector{Int64}
    list_number::Int64
end

struct Probe
    image::EpisodicImage
    classification::Symbol  # :target or :test
    testpos:: Int64
end

####################################################################
# Model start
#
####################################################################

function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end


function generate_study_list(list_num::Int, n_words::Int, g_word::Float64, w_word::Int)::Vector{Word}
    
    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = vcat(fill.([:T_target, :T_nontarget], [10,10])...) |>shuffle! ;
    
    Threads.@threads for i in 1:n_words
        
        word_list[i] = Word("Word$(i)L$(list_num)", rand(Geometric(clamp(g_word, 0.01,1)), trunc(Int, w_word)) .+ 1, types[i]) 
    end
    
    
    return word_list
end


function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64, u_star::Float64, c::Float64, n_units_time::Int64)
    
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type), zeros(length(context_features)), list_num) # Zero word features
    
    for _ in 1:n_units_time
        Threads.@threads for i in eachindex(new_image.word.word_features)
            j=new_image.word.word_features[i]
            
            # copystore_process(new_image,j,u_star,)
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star ? 1 : 0)*word.word_features[i];
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c ? stored_val : rand(Geometric(clamp(g_word, 0,1))) + 1;
                    new_image.word.word_features[i]=copied_val;
                end
            end
        end

        u_star_context = u_star+0.03;
        c_context=c+0.1;

        Threads.@threads for ic in eachindex(new_image.context_features)
            j = new_image.context_features[ic]
            
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star_context ? 1 : 0)*context_features[ic];
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context ? stored_val : rand(Geometric(clamp(g_context, 0,1))) + 1;
                    new_image.context_features[ic]=copied_val;
                end
            end
            
        end
        # println("Word Features: ", new_image.word.word_features)
    end
    
    push!(image_pool, new_image)
end


function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, list_num::Int64, g_word::Float64, w_word::Int64)::Vector{Probe}
    
    current_context_features = vcat(general_context_features, list_change_features) ;
    
    probetypes = repeat([:target, :foil], outer = div(n_probes,2)) |>shuffle! ;
    probes = Vector{Probe}(undef, length(probetypes));
    
    words = filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy;
    
    # Threads.@threads 
    for i in eachindex(probetypes)
        if probetypes[i] == :target # 
            target_word = pop!(words) #pop from pre-decided targets
        elseif probetypes[i] == :foil  # Foil case
            target_word = Word(randstring(8), generate_features(Geometric(clamp(g_word, 0.01,1)), trunc(Int, w_word)), :T_foil) 
        else
            error("probetypewrong")
        end
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], i)
        
    end
    
    
    return probes
end

function calculate_likelihood_ratio(probe::Vector{Int64}, image::Vector{Int64}, g::Float64, c::Float64)::Float64
    
    lambda = Vector{Float64}(undef, length(probe));
    
    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  
            lambda[k] = 1;
        elseif image[k] != 0 
            if image[k] != probe[k]# for those that doesn't match
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



function calculate_two_step_likelihoods_rule2(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, g_word::Float64, c::Float64)::Vector{Float64} 

    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    unique_list_numbers = unique([img.list_number for img in image_pool]);
    nlength = length(unique_list_numbers);

    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        p_slice = P_s[n_lists-nlength+1:end]; #e.g. nlength = 2 nlist=10, n-n=8, 

        list_number_i = image_pool[ii].list_number;

        if rand()<p_slice[list_number_i] #the current trace is passed 
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)
        else 
            word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
        end

    end

    return word_likelihoods
end



function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe}, g_word::Float64, c::Float64, n_units_time::Int64, n_less::Int64, u_star::Float64)::Array{Any}
    results = Array{Any}(undef, n_probes);
    
    for i in eachindex(probes)
        
        likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool, g_word, c); #proportion is all
        likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x);
        

        ilist = probes[i].image.list_number
        if ilist ==1
            nl = 19
        else
            nl = length(likelihood_ratios) 
        end
        odds = 1 / nl * sum(likelihood_ratios);
        decision_isold = odds > 1 ? 1 : 0;

        # nav = length(likelihood_ratios)/(length(image_pool))
        results[i] = (decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, nactivated = length(likelihood_ratios));
        
        restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, u_star, c, n_units_time, n_less);
    end
    return results
end


function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, u_star::Float64, c::Float64, n_units_time::Int64, n_less::Int64)
    
    if is_onlyaddtrace #only start with empty if only add trace
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    else
        iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 
    end
    
    u_star_storeintest = u_star;
    c_storeintest = c;
    u_star_context = u_star +0.03;
    c_context = c + 0.1;
    n_units_time_restore = n_units_time -n_less;


    for _ in 1:n_units_time_restore
           for i in eachindex(iprobe_img.word.word_features)
               j=iimage.word.word_features[i]
        
               if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                   iimage.word.word_features[i] = rand() < u_star_storeintest ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
               end
           end
        

        for ic in eachindex(iprobe_img.context_features)
            j = iimage.context_features[ic]
            
            if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
                # println(j,!is_onlyaddtrace)
                iimage.context_features[ic] = rand() < u_star_context ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
            end
            
        end
    end
    
    if (decision_isold == 0) | is_onlyaddtrace
        push!(image_pool,iimage);
    end
    
end


function simulate_rem(params)
    # 1. Initialization
    # params = [n_units_time, n_less, c, w_word, w_context, g_word, g_context, u_star]

    n_units_time = params[1]
    n_less = params[2]
    c = params[3]
    w_word = params[4]
    w_context = params[5]
    g_word = params[6]
    g_context = params[7]
    u_star = params[8]

    


    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[], nactivated = Float64[])
    
    for sim_num in 1:n_simulations
        
        # clamp.(df.a, 0, Inf)
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, 20+10,10); 
        general_context_features = rand(Geometric(clamp(g_context, 0.01,1)),div(trunc(Int, w_context), 2)) .+ 1#
        list_change_context_features = rand(Geometric(clamp(g_context, 0.01,1)),div(trunc(Int, w_context), 2)) .+ 1
        
        for list_num in 1:n_lists
            
            word_list = generate_study_list(list_num, n_words, g_word, trunc(Int, w_word));
            
            for j in eachindex(word_list) 
                current_context_features = vcat(general_context_features, deepcopy(list_change_context_features));
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num, u_star, c, trunc(Int, n_units_time));
                
                # target and nontarget stored into studied pool 
                studied_pool[j,list_num] = episodic_image;
            end
            
            probes = generate_probes(word_list, deepcopy(list_change_context_features), general_context_features, list_num, g_word, trunc(Int, w_word));

            studied_pool[21:30,list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)] ;
            results = probe_evaluation(image_pool, probes, g_word, c, trunc(Int, n_units_time), trunc(Int, n_less), u_star);
            
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds, res.nactivated] # Add more fields as needed
                push!(df_inital, row)
            end

            list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_listchange_finalstudy,rand(Geometric(clamp(g_context, 0.01,1)),length(list_change_context_features)) .+ 1,list_change_context_features)
            
        end
        

    end
    
    df_inital = @chain df_inital begin
        @by([:list_number, :is_target, :simulation_number], :meanx = mean(:decision_isold))
        @by([:list_number, :is_target], :meanx = mean(:meanx))
        @transform(:meanx = ifelse.(:is_target, :meanx, 1 .- :meanx))
    end

    merged_data = innerjoin(data, df_inital, on = [:list_number, :is_target],renamecols = "_data" => "_predict")

    # Calculate the sum of squared deviations
    ssd = sum((row.meanx_data - row.meanx_predict)^2 for row in eachrow(merged_data))

    return ssd
end

# Set parameter bounds for each parameter
# params = [n_units_time, n_less, c, w_word, w_context, g_word, g_context, u_star]
# params = [n_units_time=8, n_less=5, c=0.7, w_word=35, w_context=30, g_word=0.3, g_context=0.4, u_star=0.03]
bounds = [(6, 15), (0, 6), (0.4,0.9),(15,40),(15,40),(0.1,0.7),(0.1,0.7),(0.01, 0.1)]
x0= [8,5,0.7,35,30,0.3,0.4,0.03]
# Configure and run Bayesian optimization

using BlackBoxOptim
opt = bboptimize(simulate_rem; SearchRange =bounds, MaxTime = 30, NumDimensions=8)


# Display the best found solution and its objective value
println("Best solution found: $(best_candidate(opt))")
println("Best objective value found: $(best_fitness(opt))")

####################################################################
# Calculate prediction and plot
#
####################################################################
n_simulations = 500
function give_results(params)
    # 1. Initialization
    # params = [n_units_time, n_less, c, w_word, w_context, g_word, g_context, u_star]

    n_units_time = params[1]
    n_less = params[2]
    c = params[3]
    w_word = params[4]
    w_context = params[5]
    g_word = params[6]
    g_context = params[7]
    u_star = params[8]

    


    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[], nactivated = Float64[])
    
    for sim_num in 1:n_simulations
        
        # clamp.(df.a, 0, Inf)
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, 20+10,10); 
        general_context_features = rand(Geometric(clamp(g_context, 0.01,1)),div(trunc(Int, w_context), 2)) .+ 1#
        list_change_context_features = rand(Geometric(clamp(g_context, 0.01,1)),div(trunc(Int, w_context), 2)) .+ 1
        
        for list_num in 1:n_lists
            
            word_list = generate_study_list(list_num, n_words, g_word, trunc(Int, w_word));
            
            for j in eachindex(word_list) 
                current_context_features = vcat(general_context_features, deepcopy(list_change_context_features));
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num, u_star, c, trunc(Int, n_units_time));
                
                # target and nontarget stored into studied pool 
                studied_pool[j,list_num] = episodic_image;
            end
            
            probes = generate_probes(word_list, deepcopy(list_change_context_features), general_context_features, list_num, g_word, trunc(Int, w_word));

            studied_pool[21:30,list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)] ;
            results = probe_evaluation(image_pool, probes, g_word, c, trunc(Int, n_units_time), trunc(Int, n_less), u_star);
            
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds, res.nactivated] # Add more fields as needed
                push!(df_inital, row)
            end

            list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_listchange_finalstudy,rand(Geometric(clamp(g_context, 0.01,1)),length(list_change_context_features)) .+ 1,list_change_context_features)
            
        end
        

    end
    
    # df_inital = @chain df_inital begin
    #     @by([:list_number, :is_target, :simulation_number], :meanx = mean(:decision_isold))
    #     @by([:list_number, :is_target], :meanx = mean(:meanx))
    #     @transform(:meanx = ifelse.(:is_target, :meanx, 1 .- :meanx))
    # end

    return df_inital
end

# all_results =  give_results(best_candidate(opt))
all_results =  give_results(x0)
df2= data
# @rput DF
@rput all_results
@rput df2
R"""
library(ggplot2)
library(dplyr)
library(gridExtra)

DF2 = all_results %>% 
group_by(list_number, is_target,simulation_number)%>%
summarize(meanx=mean(decision_isold))%>%
group_by(list_number, is_target)%>%
summarize(meanx=mean(meanx))%>%
mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(list_number=as.numeric(list_number))

DF2
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
ylim(c(0.5,1))+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")


p2=ggplot(data=df2, aes(x=list_number,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
ylim(c(0.5,1))+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")

# p1
grid.arrange(p1,p2, ncol = 2)

"""


# Display the best found solution and its objective value
println("Best solution found: $(best_candidate(opt))")
println("Best objective value found: $(best_fitness(opt))")