#= ===========================================================================================================
Author      : Shuchun (Lea) Lai
Date        : 2024-03-29
Description : modified on 3/18 try to add final test


Notes       : some important modifications are done, and some lines are marked in red for problems, this version doesn't include any learning of test images;

!! add learning in test images now. 

store context by adding more context features and add into the 0s - doing an experiment to ask subjects what they knew about the item if they've seen it before or not. 
finished at 3/29/24, change to next version to add learning in final test
...
=========================================================================================================== =#

using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads

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

const n_simulations = 1
const is_store_mismatch = true; #if mismatched value is restored during test
const n_finalprobs = 420;
const num_halflistprob = 21; # number of probes in each list in half

const n_lists = 10;
const n_probes = 20; # Number of probes to test
const n_words = 20;
const n_units_time = 10; #number of steps

const c = 0.7; #copying parameter - 0.8 for context copying 
const w_context =30; #2*15 number of context features
const w_word = 20; # number of word features
const words_per_list = 20;
const g_word = 0.3; #geometric base rate
const g_context = 0.2; #geometric base rate of context
const p_change = 0.3;

const u_star = 0.04; # Probability of storage 

const u_star_storeintest = u_star #for word
const c_storeintest = c  

const u_star_context = u_star +0.03 # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
const c_context = c + 0.1

const criterion_final = 1
const context_tau = 1e5#1e20
const context_tau_f = 20;

#the following changed magnitude of final test accuracy
const p_listchange_finalstudy = 0.1; #either of these contribute to differences between list 
const p_listchange_finaltest = 0.1;

# Data Structures                         
struct Word
    item::String
    word_features::Vector{Int64}
    type::Symbol
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


function generate_study_list(list_num)
    
    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = vcat(fill.([:T_target, :T_nontarget], [10,10])...) |>shuffle! ;
    
    Threads.@threads for i in 1:n_words

        word_list[i] = Word("Word$(i)L$(list_num)", rand(Geometric(g_word), w_word) .+ 1, types[i]) 
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


function store_episodic_image(image_pool, word, context_features, list_num)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type), [ContextFeature(zero(Int64), cf.type, cf.change_probability) for cf in context_features], list_num) # Zero word features
    
    for _ in 1:n_units_time
        Threads.@threads for i in eachindex(new_image.word.word_features)
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
        
        Threads.@threads for ic in eachindex(new_image.context_features)
            j = new_image.context_features[ic].value
            
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star_context ? 1 : 0)*context_features[ic].value;
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context ? stored_val : rand(Geometric(g_context)) + 1;
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

# image_pool = [];
# context_features = []; # Initialize context features
# for i in eachindex(tempword1)
#     store_episodic_image(image_pool, tempword1[i], tf1[i], u_star, c, n_units_time, g_word, g_context, 1);
# end
# printimg(image_pool[2])

## this function only do word_change_features for last word studied, then keeps the same?
function generate_probes(studied_words, list_change_features, general_context_features, list_num; g_context=g_context, w_word=w_word)

    current_context_features = vcat(general_context_features, list_change_features) ;

    probetypes = repeat([:target, :foil], outer = div(n_probes,2)) |>shuffle! ;
    probes = Vector{Probe}(undef, length(probetypes));

    words = filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy;

    Threads.@threads for i in eachindex(probetypes)
        if probetypes[i] == :target # 
            target_word = pop!(words) #pop from pre-decided targets
        elseif probetypes[i] == :foil  # Foil case
            target_word = Word(randstring(8), generate_features(Geometric(g_word), w_word), :T_foil) 
        else
            error("probetypewrong")
        end
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i])

    end
    
    
    return probes
end

# p1=generate_probes(word_list,  list_change_context_features, general_context_features,1);
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

function calculate_two_step_likelihoods(probe, image_pool)
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));

    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        probe_context = [cf.value for cf in probe.context_features];
        image_context = [cf.value for cf in image.context_features];
        context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
        context_likelihoods[ii] = context_likelihood;
        
        if context_likelihood > context_tau 
            word_likelihood = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)
            word_likelihoods[ii]= word_likelihood
        else
            word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
        end
        # word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)


    end

    return context_likelihoods, word_likelihoods
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
    
        # _, likelihood_ratios = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        
        _, likelihood_ratios = calculate_two_step_likelihoods(probes[i].image, image_pool)
        likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        decision_isold = odds > criterion_final ? 1 : 0
        
        # Store results (modify as needed)
        results[i] = (decision_isold = decision_isold, is_target = string(probes[i].classification), odds = odds, list_num = probes[i].image.list_number) #! made changes to results, format different than that in inital

        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1);
    end
    
    return results
end

function probe_evaluation(image_pool, probes)
    results = Array{Any}(undef, n_probes);
    
    for i in eachindex(probes)

        ctx, likelihood_ratios = calculate_two_step_likelihoods(probes[i].image, image_pool);
        likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x);
        mean_ctx = map(list_number -> mean(ctx[[i for (i, img) in enumerate(image_pool) if img.list_number == list_number]]), unique([img.list_number for img in image_pool]));

        

        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios);
        decision_isold = odds > 1 ? 1 : 0;
        
        # Store results (modify as needed)
        # results[i] = (decision_isold = decision_isold, is_target = probes[i].classification, probe = probes[i].image, odds = odds, likelihood_ratios = likelihood_ratios);
        results[i] = (decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, mean_contextinlist = mean_ctx);
        # println("item:",probes[i].image.word.item,mean_ctx)

        restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios) );
    end


    
    return results
end

function restore_intest(image_pool, iprobe_img, decision_isold,imax)
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), [ContextFeature(0, cf.type, cf.change_probability) for cf in iprobe_img.context_features], iprobe_img.list_number); 

    # if decision is old, the following change the image in image pool
    # if the decision is new, the following modify the new empty image
    for _ in 1:n_units_time
        # for i in eachindex(iprobe_img.word.word_features)
        #     j=iimage.word.word_features[i]

        #     # if stored sucessfully and copied suces - probe val
        #     # if stored sucessfully and copied not suces - random val
        #     # if not stored sucessfully - 0/keeps original value j 

        #     # if nothing is stored; or old but something is stored, and when values doesn't match
        #     if (j==0) | (j!=0 & decision_isold==1 & j!=iprobe_img.word.word_features[i] & is_store_mismatch)
        #         iimage.word.word_features[i] = rand() < u_star_storeintest ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
        #     end
        # end

        tf =  iimage.word.word_features .== 0 .| (iimage.word.word_features .!=0 .& decision_isold==1 .& iimage.word.word_features .!= iprobe_img.word.word_features .& is_store_mismatch)
        # println(length(rand(sum(tf))), length(iimage.word.word_features[tf]))
        # ifelse.(rand(length(tf)) .< u_star_context, 1, iimage.word.word_features[tf])
        iimage.word.word_features[tf] = ifelse.(rand(sum(tf)) .< u_star_context, ifelse.(rand(sum(tf)) .< c_context, iprobe_img.word.word_features[tf], rand(Geometric(g_context)) + 1), iimage.word.word_features[tf])

        # vals = [i.value for i in iimage.context_features]
        # vals2 = [i.value for i in iprobe_img.context_features]

        # tf =  vals .== 0 .| (vals .!=0 .& decision_isold==1 .& vals .!= vals2 .& is_store_mismatch)
        # println(iimage.context_features[tf])
        # iimage.context_features[tf]
        # iimage.context_features[tf].value = ifelse.(rand(length(tf)) .< u_star_context, ifelse.(rand(length(tf)) .< c_context, iprobe_img.context_features[tf].value, rand(Geometric(g_context)) + 1), iimage.context_features[tf].value)
        for ic in eachindex(iprobe_img.context_features)
            j = iimage.context_features[ic].value
            
            if j==0 | (j!=0 & decision_isold==1 & j!=iprobe_img.context_features[ic].value & is_store_mismatch)# if nothing is stored
                iimage.context_features[ic].value = rand() < u_star_context ? (rand() < c_context ? iprobe_img.context_features[ic].value : rand(Geometric(g_context)) + 1) : j;
            end
            
        end
    end

    if decision_isold == 0
        push!(image_pool,iimage);
    end

end

# if stored sucessfully and copied suces - probeval
# if stored sucessfully and copied not suces - random val
# if not stored sucessfully - 0/keeps original value j 



function generate_finalt_probes(studied_pool, condition,general_context_features,list_change_context_features)

    listcg = deepcopy(list_change_context_features)
    # num_images = length(studied_pool)
    list_images = Dict{Int64, Vector{EpisodicImage}}()
    for img in studied_pool
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

        for cf in listcg
            if rand() <  p_listchange_finaltest #cf.change_probability # this equals p_change
                cf.value = rand(Geometric(g_context)) + 1 
            end
        end


        images = list_images[list_number]
        images_Tt = filter(img -> img.word.type == :T_target, images) |> shuffle!;
        images_Tnt = filter(img -> img.word.type == :T_nontarget, images)|> shuffle!;
        images_Tf = filter(img -> img.word.type == :T_foil, images) |> shuffle!;

        # Generate targets from shuffled list and foils anew
        if condition != :true_random
            probe = vcat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7,7,7,21])...) |>shuffle! ;
        else 
            probe = vcat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7,7,7,21].*10)...) |>shuffle! ;
        end
        

        for iprobe in eachindex(probe)  
            crrcontext = vcat(general_context_features, deepcopy(listcg));
            if probe[iprobe]==:T_target
                push!(probes, Probe(EpisodicImage(pop!(images_Tt).word, crrcontext, list_number),:T_target))
            elseif probe[iprobe]==:T_nontarget
                push!(probes, Probe(EpisodicImage(pop!(images_Tnt).word, crrcontext, list_number),:T_nontarget))
            elseif probe[iprobe]==:T_foil
                push!(probes, Probe(EpisodicImage(pop!(images_Tf).word, crrcontext, list_number),:T_foil))
            elseif probe[iprobe]==:F
                push!(probes, Probe(EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1, :F), crrcontext, list_number),:F))  # Generate a new foil
            else
                error("probe type wrong!")
            end
        end

        # println([i.value for i in listcg])

    end


    return probes
end
# finalprobes = generate_finalt_probes(image_pool, :backward,general_context_features,list_change_context_features);
# printimgpool([i.image for i in finalprobes][[1,2,51]])

# printimgpool([i.image for i in probes][[1,2,51]])

function simulate_rem()
    # 1. Initialization
    
    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[])
    df_final = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], condition = Symbol[], decision_isold = Int[], is_target = String[],odds = Float64[])
    
    for sim_num in 1:n_simulations
        
        #    sim_num=1
        image_pool = []
        studied_pool = Array{EpisodicImage}(undef, 10,20+10); #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)]
        list_change_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]
        
        for list_num in 1:n_lists
            
            word_list = generate_study_list(list_num);
            
            for j in eachindex(word_list) 
                current_context_features = vcat(general_context_features, deepcopy(list_change_context_features));
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num);
                
                # target and nontarget stored into studied pool 
                studied_pool[list_num,j] = episodic_image;
            end
            
            probes = generate_probes(word_list, deepcopy(list_change_context_features), general_context_features, list_num);

            @assert length(filter(prb -> prb.classification == :foil, probes)) == 10  "wrong number!";
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"

            # foil stored
            studied_pool[list_num,21:30] = [i.image for i in filter(prb -> prb.classification == :foil, probes)] ;
            results = probe_evaluation(image_pool, probes);
            
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds] # Add more fields as needed
                #    row = [list_num, ires, sim_num, res.decision_isold, tt, res.probe, res.odds, res.likelihood_ratios] # Add more fields as needed
                push!(df_inital, row)
            end
            # Update list_change_context_features 
            for cf in list_change_context_features
                if rand() <  p_listchange_finalstudy #cf.change_probability # this equals p_change
                    cf.value = rand(Geometric(g_context)) + 1 
                end
            end

            # println([i.value for i in list_change_context_features])
            
        end

        studied_pool = [studied_pool...];
        #final test here
        for icondition in [:forward, :backward, :true_random]
            finalprobes = generate_finalt_probes(studied_pool, icondition,general_context_features,list_change_context_features);
            results_final = probe_evaluation2(image_pool, finalprobes);
            for ii in eachindex(results_final)
                res = results_final[ii]
                push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds])
            end 
        end


    end
    
    return df_inital, df_final
end



# all_results, allresf  = simulate_rem()
# all_results 
# @benchmark simulate_rem()
@profile simulate_rem()
ProfileView.view()

# @allocated simulate_rem()