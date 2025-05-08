
f1=[1 2 3 0 0 0 0 3 2 0]
f2=[3 2 3 0 0 0 1 2 0 0]
rand1 = rand(10)
rand2 = rand(10)
decision_isold = 1
outnow = rand(Geometric(g_context),10) .+ 1
u_star_storeintest = 0.5
c_storeintest = 0.5

f1=[1 2 3 0 0 0 0 3 2 0]
f2=[3 2 3 0 0 0 1 2 0 0]
for i in eachindex(f1)
    j=f2[i]

    if (j==0) | ((j!=0) & (decision_isold==1) & (j!=f1[i]) & (is_store_mismatch))

        println(f2,rand1[i] < u_star_storeintest,rand2[i] < c_storeintest)
        f2[i] = (rand1[i] < u_star_storeintest) ? (rand2[i] < c_storeintest ? f1[i] : outnow[i]) : j;
        # f2[i] = ifelse(rand1[i] < u_star_storeintest, ifelse.(rand2[i] < c_storeintest, f1[i], outnow[i]), f2[i])
    end
end
println(f2)

a = [1 2 3]
b = [2 3 4]
for i in eachindex(a)
    if a[i]>=2
        b[i]=999     
    end
end
b


f1=[1 2 3 0 0 0 0 3 2 0]
f2=[3 2 3 0 0 0 1 2 0 0]
decision_isold = 1
is_store_mismatch = true

tf =  (f2 .== 0) .| ((f2 .!=0) .& (decision_isold.==1) .& (f2 .!= f1) .& is_store_mismatch)


 (f2 .!=0) .& (decision_isold.==1) .& (f2 .!= f1) .& is_store_mismatch
 (f2 .!=0) .& decision_isold.==1 .& (f2 .!= f1) .& is_store_mismatch

 0!=0 & 1==1 & 0!=0 & true
 (0!=0) & (1==1) & (0!=0) & (true)
 (0!=0) & 1==1 & (0!=0) & true
 (0!=0) & 1==1 & false

 
 false & 1==1 & false
#  false && (1==1) && false
#  true && false

 (false & 1) == 1 & false
 false & (1 == 1) & false

 false & 1==1 
 (false & 1) == 1 
 false & (1 == 1) 
 
 (false & 1) == (1 & false)
 false & 1==1 & false
 (false & 1) == 1 & false
 false & (1 == 1) & false

 false &  1



 0 == 1 & false

 false & true & false
 (0!=0) & (1==1) & false
 

tf = [tf...]

f2[tf] = ifelse.(rand1[tf] .< u_star_storeintest, ifelse.(rand2[tf] .< c_storeintest, f1[tf], outnow[tf]), f2[tf])
println(f2)

#= ===========================================================================================================
   Author      : Shuchun (Lea) Lai
   Date        : 2024-04-01
   Description :
                

   Notes       : following test likliehood functions
                 ...
   =========================================================================================================== =#
function calculate_two_step_likelihoods22(probe::Vector{Int}, image_pool::Vector)::Tuple{Vector{Float64}, Vector{Float64}} 
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    
    for ii in eachindex(image_pool) 
        word_likelihoods[ii] = calculate_likelihood_ratio(probe, image_pool[ii], 0.4, 0.7)
        
        
    end
    
    return context_likelihoods, word_likelihoods
end

calculate_likelihood_ratio([2,3,4,3], [0,1,0,3], g_word, c)
calculate_likelihood_ratio([2,3,4,3], [2,2,1,0], g_word, c)
calculate_likelihood_ratio([6,1,1,3], [2,2,1,0], 0.4, 0.7)
calculate_likelihood_ratio([6,1,1,3], [0,1,0,3], 0.4, 0.7)
a = [2,3,4,3]
a2=[6,1,1,3]
b = [[0,1,0,3],[2,2,1,0]]
calculate_likelihood_ratio(a, b[2], 0.4, 0.7)

_, likelihood_ratios = calculate_two_step_likelihoods22(a2, b);
likelihood_ratios
likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x)
#    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end

# println(likelihood_ratios)
odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)




#= ===========================================================================================================
   Author      : Shuchun (Lea) Lai
   Date        : 2024-04-01
   Description :
                

   Notes       : follwing test rem simulation
                 ...
   =========================================================================================================== =#
   function calculate_two_step_likelihoods(probe::EpisodicImage, image_pool::Vector{EpisodicImage};context_tau)::Tuple{Vector{Float64}, Vector{Float64}} 
    context_likelihoods = Vector{Float64}(undef,length(image_pool));
    word_likelihoods = Vector{Float64}(undef,length(image_pool));
    
    for ii in eachindex(image_pool) 
        image = image_pool[ii];
        probe_context = probe.context_features;
        image_context = image.context_features;
        context_likelihood = calculate_likelihood_ratio(probe_context,image_context,g_context,c )  # .#  Context calculation
        context_likelihoods[ii] = context_likelihood
        
        if context_likelihood > context_tau 
            word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)
        else
            word_likelihoods[ii] = 344523466743  # Or another value to indicate context mismatch
        end
        # word_likelihoods[ii] = calculate_likelihood_ratio(probe.word.word_features, image.word.word_features, g_word, c)
        
        
    end
    
    return context_likelihoods, word_likelihoods
end
calculate_two_step_likelihoods(probes[i].image, image_pool,context_tau=1e10);

df_inital = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[])
df_final = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], condition = Symbol[], decision_isold = Int[], is_target = String[],odds = Float64[])


sim_num=1
image_pool = EpisodicImage[]
studied_pool = Array{EpisodicImage}(undef, 20+10,10); #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
general_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)] 
list_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]

for list_num in 1:9
            
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
        row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds] # Add more fields as needed
        #    row = [list_num, ires, sim_num, res.decision_isold, tt, res.probe, res.odds, res.likelihood_ratios] # Add more fields as needed
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



list_num=10
word_list = generate_study_list(list_num);
    
for j in eachindex(word_list) 
    current_context_features = vcat(general_context_features, deepcopy(list_change_context_features));
    episodic_image = EpisodicImage(word_list[j], current_context_features, list_num);
    store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num);
    
    # target and nontarget stored into studied pool 
    studied_pool[j,list_num] = episodic_image;
end

probes = generate_probes(word_list, deepcopy(list_change_context_features), general_context_features, list_num);



# results = probe_evaluation(image_pool, probes);
# probe_evaluation(image_pool, probes):
results = Array{Any}(undef, n_probes);
i=2
ctx, likelihood_ratios = calculate_two_step_likelihoods(probes[i].image, image_pool, context_tau = 1e5);
likelihood_ratios = likelihood_ratios |> x -> filter(e -> e != 344523466743, x);
[i.word.item for i in image_pool[ctx.>1e7]]|>println
# [[image_pool[i].word.item ctx[i]] for i in eachindex(image_pool)]|>println
