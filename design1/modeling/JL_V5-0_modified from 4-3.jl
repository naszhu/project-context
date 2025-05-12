#= ===========================================================================================================
   Author      : Shuchun (Lea) Lai
   Date        : 2024-05-28
   Description :
                

   Notes       : This version is created to emulate function of Pcj

   change criteion 
                 ...
   =========================================================================================================== =#

using Random, Distributions,Statistics, DataFrames, DataFramesMeta
using RCall
using BenchmarkTools, ProfileView, Profile, Base.Threads
using QuadGK
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

n_simulations= 50
context_tau = 1e2
criterion_final = 1
is_firststage = true;
is_finaltest = true;
is_onlyaddtrace = false; #add but not strengtening trace
const n_units_time = 10; #number of steps
n_units_time_restore = n_units_time - 5

 #only probing with change context in inital test， but this should be changed if a second stage is added 
is_onlyprobe_changecontext = true
w_word = 20; # number of word features
# P_s = [0.2,0.25,0.3, 0.35,0.4,0.45, 0.49,0.993,0.999, 1] ;#proportion feature tested
# P_s = fill(1,10) #proportion feature tested this value used only in final test, intial test p=1
range_breaks_finalt = range(1, stop=420, length=11)  # Create 10 intervals (11 breaks)
Brt = 250#base time of RT
Pi = 30#RT scaling

const is_store_mismatch = false; #if mismatched value is restored during test
const n_finalprobs = 420;
const num_halflistprob = 21; # number of probes in each list in half

const n_lists = 10;
const n_probes = 20; # Number of probes to test
const n_words = 20;


const c = 0.8; #copying parameter - 0.8 for context copying 
const w_context =50; #first half normal context, second half change context
const words_per_list = 20;
const g_word = 0.3; #geometric base rate
const g_context = 0.2; #geometric base rate of context
# const p_change = 0.3;#this is not actually needed

const u_star = 0.04; # Probability of storage 

const u_star_storeintest = u_star #for word
const c_storeintest = c

const u_star_context = u_star +0.03 # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
# const u_star_context = u_star # ratio of this and the next is key for T_nt > T_t, when that for storage and test is seperatly added, also influence
const c_context = c 

const context_tau_f = 20;

#the following changed magnitude of final test accuracy
const p_listchange_finalstudy = 0.05; # studied prior list probability change 
# either of these contribute to differences between list 
const p_listchange_finaltest =0.05 #probe probability change for context

#===============================================
===============================================#
# Data Structures                         
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

# Functions
function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end


function generate_study_list(list_num::Int)::Vector{Word}
    
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


function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type), zeros(length(context_features)), list_num) # Zero word features
    
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
            j = new_image.context_features[ic]
            
            if j==0 # if nothing is stored
                stored_val =(rand() < u_star_context ? 1 : 0)*context_features[ic];
                if stored_val !=0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context ? stored_val : rand(Geometric(g_context)) + 1;
                    new_image.context_features[ic]=copied_val;
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
function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, list_num::Int64)::Vector{Probe}
    
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
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], i)
        
    end
    
    
    return probes
end

# p1=generate_probes(word_list,  list_change_context_features, general_context_features,1);
# image_context2 = [cf.value for cf in word_change_feature_list[1]]
# image_context3 = [cf.value for cf in p1.context_features]



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

   calculate_likelihood_ratio([2,3,4,3], [0,1,0,3], 0.4, 0.7)
   calculate_likelihood_ratio([2,3,4,3], [2,2,1,0], 0.4, 0.7)
   calculate_likelihood_ratio([6,1,1,3], [2,2,1,0], 0.4, 0.7)
   calculate_likelihood_ratio([6,1,1,3], [0,1,0,3], 0.4, 0.7)

function calculate_two_step_likelihoods(probe::EpisodicImage, image_pool::Vector{EpisodicImage}, p::Float64)::Tuple{Vector{Float64}, Vector{Float64}} 
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    
    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        probe_context = probe.context_features;
        image_context = image.context_features;

        if is_onlyprobe_changecontext  #here is second stage would be wrong
            context_likelihood = calculate_likelihood_ratio(probe_context[div(w_context,2)+1:w_context],image_context[div(w_context,2)+1:w_context],g_context,c )  # .#  Context calculation
        else 
            context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
        end
        context_likelihoods[ii] = context_likelihood
        
        if is_firststage
            if context_likelihood > context_tau 
                word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
            else
                word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
            end
        else
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features[1:round(Int, w_word * p)], image.word.word_features[1:round(Int, w_word * p)], g_word, c)
        end
        
        
    end
    
    return context_likelihoods, word_likelihoods
end


function probe_evaluation2(image_pool::Vector{EpisodicImage}, probes::Vector{Probe})::Array{Any}
    results = Array{Any}(undef, length(probes));
    for i in eachindex(probes)
        
        # _, likelihood_ratios = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        if i==1 index = 1 else index = searchsortedfirst(range_breaks_finalt, i) - 1 end
        # println(index)
        # if index != -1
        #     P = P_s[index]
        # else
        #     error("Value out of range.")
        # end


        _, likelihood_ratios = calculate_two_step_likelihoods(probes[i].image, image_pool, 1.0)
        likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        decision_isold = odds > criterion_final ? 1 : 0

        # pold = pcrr_EZddf(log(odds))
        rt = Brt+Pi*abs(log(odds));
        
        # Store results (modify as needed)
        results[i] = (decision_isold = decision_isold, is_target = string(probes[i].classification), odds = odds, list_num = probes[i].image.list_number, rt = rt) #! made changes to results, format different than that in inital
        
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        restore_intest_final(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, probes[i].classification);
    end
    
    return results
end

function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe})::Array{Any}
    unique_list_numbers = unique([image.list_number for image in image_pool])
    n_listimagepool = length(unique_list_numbers)
    results = Array{Any}(undef, n_probes*n_listimagepool);
    
    for i in eachindex(probes)
        
        # calculate_two_step_likelihoods_rule2(probes[i].image, image_pool);
        _, likelihood_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool, 1.0); #proportion is all
        # likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool); #proportion is all
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x);
        
        
    
        ilist_probe = probes[i].image.list_number
        ilist_image = probes[i].image.list_number
        # if ilist_probe ==1
        #     # nl = 0.8*length(likelihood_ratios)
        #     nl = 19
        # else
        #     nl = length(likelihood_ratios) 
        #     # nl = 0.7*length(likelihood_ratios)#[img for img in image_pool if img.list_number == probes[i].image.list_number] |>  length
        # end
        nl = length(likelihood_ratios)
        odds = 1 / nl * sum(likelihood_ratios);

        if ilist_probe==1
            decision_isold = odds > 0.7 ? 1 : 0;
        else
            decision_isold = odds > 1 ? 1 : 0;
        end

        nav = length(likelihood_ratios)/(length(image_pool))

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool);
            nimages_activated=count(ii -> (image_pool[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool));

            results[n_listimagepool*(i-1)+j] = (decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, Nratio_iprobe = nav, testpos = i);
        end
        # println("item:",probes[i].image.word.item,mean_ctx)
        
        # if probes[i].image.list_number !=1
            restore_intest(image_pool,probes[i].image, decision_isold, decision_isold==1 ? argmax(likelihood_ratios) : 1, probes[i].classification);
        # end
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios) );
    end
    
    
    
    return results
end

function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, probetype::Symbol)
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    
    if is_onlyaddtrace #only start with empty if only add trace
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    else
        # println("nothere")
        iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 

        # The following is to test why there is non-monotonic change of target value
        # probe_word_item = iprobe_img.word.item
        # matching_image = findfirst(image -> image.word.item == probe_word_item, image_pool)

        # iimage = probetype == :target ? image_pool[matching_image] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 
        # if decision_isold==1 println("old", decision_isold,iimage) end
    end
    
    # if decision is old, the following change the image in image pool
    # if the decision is new, the following modify the new empty image
    
    # if onlyaddingtrace
    for _ in 1:n_units_time_restore
        #    for i in eachindex(iprobe_img.word.word_features)
        #        j=iimage.word.word_features[i]
        
        #        # if stored sucessfully and copied suces - probe val
        #        # if stored sucessfully and copied not suces - random val
        #        # if not stored sucessfully - 0/keeps original value j 
        
        #        # if nothing is stored; or old but something is stored, and when values doesn't match
        #        if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
        #            iimage.word.word_features[i] = rand() < u_star_storeintest ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
        #        end
        #    end
        
        tf =  (iimage.word.word_features .== 0) .| ((iimage.word.word_features .!=0) .& (decision_isold .==1) .& (iimage.word.word_features .!= iprobe_img.word.word_features) .& is_store_mismatch .& (.!is_onlyaddtrace))
        iimage.word.word_features[tf] = ifelse.(rand(sum(tf)) .< u_star_storeintest, ifelse.(rand(sum(tf)) .< c_storeintest, iprobe_img.word.word_features[tf], rand(Geometric(g_context),sum(tf)) .+ 1), iimage.word.word_features[tf])

        
        # vals = [i.value for i in iimage.context_features]
        # vals2 = [i.value for i in iprobe_img.context_features]
        
        # tf =  vals .== 0 .| (vals .!=0 .& decision_isold==1 .& vals .!= vals2 .& is_store_mismatch)
        # println(iimage.context_features[tf])
        # iimage.context_features[tf]
        # iimage.context_features[tf].value = ifelse.(rand(length(tf)) .< u_star_context, ifelse.(rand(length(tf)) .< c_context, iprobe_img.context_features[tf].value, rand(Geometric(g_context)) + 1), iimage.context_features[tf].value)
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
    
    # if decision_isold ==1 println("afterchange",iimage) end
end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, probetype::Symbol)
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    
    iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    
    for _ in 1:n_units_time_restore
        
        tf =  (iimage.word.word_features .== 0) .| ((iimage.word.word_features .!=0) .& (decision_isold .==1) .& (iimage.word.word_features .!= iprobe_img.word.word_features) .& is_store_mismatch .& (.!is_onlyaddtrace))
        iimage.word.word_features[tf] = ifelse.(rand(sum(tf)) .< u_star_storeintest, ifelse.(rand(sum(tf)) .< c_storeintest, iprobe_img.word.word_features[tf], rand(Geometric(g_context),sum(tf)) .+ 1), iimage.word.word_features[tf])

        

        for ic in eachindex(iprobe_img.context_features)
            j = iimage.context_features[ic]
            
            if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
                # println(j,!is_onlyaddtrace)
                iimage.context_features[ic] = rand() < u_star_context ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
            end
            
        end
    end
    
    # if (decision_isold == 0) | is_onlyaddtrace
    #     push!(image_pool,iimage);
    # end
    push!(image_pool,iimage);

    
    # if decision_isold ==1 println("afterchange",iimage) end
end
# if stored sucessfully and copied suces - probeval
# if stored sucessfully and copied not suces - random val
# if not stored sucessfully - 0/keeps original value j 


"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes"""
function generate_finalt_probes(studied_pool::Array{EpisodicImage}, condition::Symbol,general_context_features::Vector{Int64},list_change_context_features::Vector{Int64})::Vector{Probe}
    
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
        
        # true random doesn't change list context during final test
        all_images = vcat(values(list_images)...)  # Combine all lists
        shuffle!(all_images)  # Shuffle all images together
        list_images = Dict{Int64, Vector{EpisodicImage}}(1 => all_images)
        lists = keys(list_images)
    end 
    
    for list_number in lists
        
        for cf in eachindex(listcg)
            if rand() <  p_listchange_finaltest #cf.change_probability # this equals p_change
                listcg[cf] = rand(Geometric(g_context)) + 1 
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
                push!(probes, Probe(EpisodicImage(pop!(images_Tt).word, crrcontext, list_number),:T_target, iprobe))
            elseif probe[iprobe]==:T_nontarget
                push!(probes, Probe(EpisodicImage(pop!(images_Tnt).word, crrcontext, list_number),:T_nontarget, iprobe))
            elseif probe[iprobe]==:T_foil
                push!(probes, Probe(EpisodicImage(pop!(images_Tf).word, crrcontext, list_number),:T_foil, iprobe))
            elseif probe[iprobe]==:F
                push!(probes, Probe(EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1, :F), crrcontext, list_number),:F, iprobe))  # Generate a new foil
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
    
    df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], ilist_image = Int[])
    df_final = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], condition = Symbol[], decision_isold = Int[], is_target = String[],odds = Float64[], rt = Float64[])
    
    for sim_num in 1:n_simulations
        
        #    sim_num=1
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, 20+10,10); #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)] 
        list_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]
        
        for list_num in 1:n_lists
            
            word_list = generate_study_list(list_num);
            
            for j in eachindex(word_list) 
                current_context_features = vcat(general_context_features, deepcopy(list_change_context_features));
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num);
                
                # target and nontarget stored into studied pool 
                studied_pool[j,list_num] = episodic_image;
            end
            
            probes = generate_probes(word_list, deepcopy(list_change_context_features), general_context_features, list_num);
            
            @assert length(filter(prb -> prb.classification == :foil, probes)) == 10  "wrong number!";
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"
            
            # foil stored
            #    println(studied_pool[list_num,20])
            #    println(studied_pool[list_num,21])
            studied_pool[21:30,list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)] ;
            results = probe_evaluation(image_pool, probes);
            
            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, res.testpos, sim_num, res.decision_isold, tt, res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.ilist_image] # Add more fields as needed
                # results[]=(decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, Nratio_iprobe = nav);
                # odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], ilist_image = Int[])
                push!(df_inital, row)
            end
            # Update list_change_context_features 
            #    for cf in eachindex(list_change_context_features)
            #        if rand() <  p_listchange_finalstudy #cf.change_probability # this equals p_change
            #            list_change_context_features[cf] = rand(Geometric(g_context)) + 1 
            #        end
            #    end
            list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_listchange_finalstudy,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])
            
        end
        
        studied_pool = [studied_pool...];
        #final test here

        if is_finaltest
            for icondition in [:forward, :backward, :true_random]
                image_pool_bc = deepcopy(image_pool);
                finalprobes = generate_finalt_probes(studied_pool, icondition,general_context_features,list_change_context_features);
                results_final = probe_evaluation2(image_pool_bc, finalprobes);
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds, res.rt])
                end 
            end
        end
        
        
    end
    
    return df_inital, df_final
end


# @benchmark simulate_rem()

all_results, allresf  = simulate_rem()
# all_results 
DF = @chain all_results begin
    @by([:list_number, :is_target, :test_position, :simulation_number], :meanx = mean(:decision_isold))
    @by([:list_number, :is_target, :test_position], :meanx = mean(:meanx))
end

if is_finaltest
    DFf = @chain allresf begin
        @by([:list_number, :is_target, :test_position, :condition, :simulation_number], :meanx = mean(:decision_isold))
        @by([:list_number, :is_target, :test_position, :condition], :meanx = mean(:meanx))
        @transform(:condition = string.(:condition)) 
    end



    allresf = @chain allresf begin @transform(:condition = string.(:condition))end
end
# DFf
# using CSV
# CSV.write("temp.csv", DF)


@rput DF
@rput all_results
R"""
library(ggplot2)
library(dplyr)
library(gridExtra)

DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
ylim(c(0.5,1))+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")


DF2 = DF %>% mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))%>%
mutate(test_position=as.numeric(test_position))
p2=ggplot(data=DF2, aes(x=test_position,y=meanx,group=is_target))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
facet_grid(list_number~.)

DF3 = all_results %>% 
group_by(list_number, simulation_number)%>%
summarize(meanx=mean(Nratio_iprobe))%>%
group_by(list_number)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.integer(list_number))

# mutate(meanx = case_when(is_target~ meanx, TRUE ~ 1-meanx))
p3=ggplot(data=DF3, aes(x=list_number,y=meanx))+
geom_point(aes(x=list_number,y=meanx))+
geom_line(aes(x=list_number,y=meanx))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace in each list",y="N (number of activated trace)")+
scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))

# head(all_results)
# Nratio_imageinlist, ilist_image
# p4


"""

R"""
DF3 = all_results %>% 
group_by(list_number, simulation_number, ilist_image)%>%
summarize(meanx=mean(Nratio_iimageinlist))%>%
group_by(list_number, ilist_image)%>%
summarize(meanx=mean(meanx))%>%
mutate(list_number=as.factor(list_number))
# mutate(ilist_image=as.factor(ilist_image))
# mutate(test_position=as.factor(test_position))

p4=ggplot(data=DF3, aes(x=ilist_image,y=meanx, group=list_number))+
geom_point(aes(color=list_number))+
geom_line(aes(color=list_number))+
geom_text(aes(label = round(meanx,digits=3)),nudge_y = 0.01)+
labs(title="Ratio of activated trace for 10 lists in 10 color")+
# scale_x_continuous(name="list",breaks = rev(1:10),labels=as.character(rev(1:10)))
scale_x_reverse(name="traces from which list, left end - recent list, right, right end - prior list",breaks = 1:10,labels=as.character(1:10)) 

"""

@rput allresf
R"""
head(allresf)
DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(test_position=as.numeric(test_position))%>%
mutate(test_position_group=ntile(test_position,10))%>%
group_by(test_position_group,is_target,condition)%>%
summarize(meanx=mean(correct))

# head(summary(DF00$test_position_group))
"""

R"""
p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
# ylim(c(0.5,1))+
# scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
# # allresf
facet_grid(condition~.)# ylim(c(50,100))
# grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)


DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target!="F") ~ 1, 
decision_isold==0 & is_target=="F" ~1,TRUE ~ 0))%>%
mutate(list_number=as.numeric(list_number))%>%
group_by(list_number,is_target,condition)%>%
summarize(meanx=mean(correct))

p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
geom_point(aes(color=is_target))+
geom_line(aes(color=is_target))+
# ylim(c(0.5,1))+
# scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
# # allresf
facet_grid(condition~.)# ylim(c(50,100))
grid.arrange(p10, p101,p1,p3 ,ncol = 2,nrow=2)
# grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)


"""