#= ===========================================================================================================
   Author      : Shuchun (Lea) Lai
   Date        : 2024-02-27
   Description :
                modified from gemini2, to test rem 5

   Notes       :  later, when add storage of tests: when respond target, storage add to previous trace. 
        For each feature that isn't in trace, storage when 0 and overwrite previous trace. substitute 0 and keep those from ealier, replace when new was stored. 
        another approch
        - take each feature in each trace,  probability of filling the liklihood proportional, then fill in.   
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

   n_lists = 10;
   n_probes = 20; # Number of probes to test
   n_words = 20;
   n_simulations = 2000
   n_units_time = 10; #number of steps
   
   c = 0.7; #copying parameter - 0.8 for context copying 
   w_context =30; #3*15
   w_word = 20;
   words_per_list = 20;
   g_word = 0.3; #geometric base rate
   g_context = 0.2; #geometric base rate of context
   p_change = 0.3;
   u_star = 0.04; # Probability of storage 0.34 for context 
   c = 0.7; # Probability of copy
   context_tau = 1e5
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
   

   function generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change)

    p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    
    word_change_context_features  = [ContextFeature(rand(Geometric(g_context)) + 1, :word_change, p_changeword) for _ in 1:div(w_context, 3)]
    word_change_feature_list = Vector{Vector{ContextFeature}}([Vector{ContextFeature}(undef, length(word_change_context_features)) for _ in 1:n_words])


    for i in 1:n_words
        n=length(word_change_context_features);
        if i==1
            word_change_feature_list[i]=word_change_context_features;
        else
            tfrand=rand(n) .< p_changeword;
            word_change_feature_list[i][tfrand] = ContextFeature.(generate_features(Geometric(g_context),sum(tfrand)), :word_change, p_changeword);
            word_change_feature_list[i][.!tfrand] = word_change_feature_list[i-1][.!tfrand];
        end

        # Update context features (word-to-word changes)

        word = Word("Word$(i)", rand(Geometric(g_word), w_word) .+ 1) 
        word_list[i]=word;
        # word_change_feature_list[i]=deepcopy(word_change_context_features);
        # word_change_feature_list[i]=copy(word_change_context_features);

    end


    return word_list, word_change_feature_list
end
   
#    @time generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    @profile generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
#    Profile.print()
#    @time generate_study_list2(n_words, w_context, w_word, g_context, g_word, p_change);

   tempword1, tf1= generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
   printfeature(tf1)
   
#    word_list, word_change_feature_list =  generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);

   
   function store_episodic_image(image_pool, word, context_features, u_star, c, n_units_time, g_word, g_context)
       # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
       new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features))), [ContextFeature(zero(Int64), cf.type, cf.change_probability) for cf in context_features]) # Zero word features
   
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
                   stored_val =(rand() < u_star+0.2 ? 1 : 0)*context_features[ic].value;
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
    store_episodic_image(image_pool, tempword1[i], tf1[i], u_star, c, n_units_time, g_word, g_context);
   end
   printimg(image_pool[2])
   
   ## this function only do word_change_features for last word studied, then keeps the same?
   function generate_probe(target_or_foil, studied_words, word_change_features, list_change_features, general_context_features; g_context=g_context, w_word=w_word)
   
       if target_or_foil == :target # make it half and half
           target_word = rand(studied_words) 
       elseif target_or_foil == :foil  # Foil case
           target_word = Word(randstring(8), generate_features(Geometric(g_word), w_word)) 
       else
           error("probetypewrong")
       end
   
       # 1. Modify word_change features with probability
       word_change_features_copy = deepcopy(word_change_features) 
       for cf in word_change_features_copy
           if rand() < cf.change_probability
               # println("here")
               if cf.type == :word_change
                   cf.value = rand(Geometric(g_context)) +1
               end
           end
       end
   
       # println([i.value for i in word_change_features],[i.value for i in word_change_features_copy])
       # 2. & 3. Keep list_change and general features the same
       # println(1,general_context_features, word_change_features_copy, list_change_features)
       current_context_features = vcat(general_context_features, word_change_features_copy, list_change_features) 
   
       return EpisodicImage(target_word, current_context_features) 
   end
   
   p1=generate_probe(:target, word_list, word_change_feature_list[1], list_change_context_features, general_context_features);
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
   
   
    function probe_evaluation(image_pool, word_list, word_change_feature_list,n_lists,list_change_context_features, general_context_features, n_words)
        results = Array{Any}(undef, n_probes);
        for i in 1:n_probes
            # Choose target or foil, generate probe (implementation needed)
            is_target = rand(Bool) ?  :target : :foil;
            probe = generate_probe(is_target, word_list, word_change_feature_list[n_lists], list_change_context_features, general_context_features) 
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
   
   function simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations)
       # 1. Initialization
    #    all_results_df = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[], probe = EpisodicImage[], odds = Float64[], likelihood_ratios = Vector{Float64}[])
       all_results_df = DataFrame(list_number = Int[], test_position = Int[], simulation_number = Int[], decision_isold = Int[], is_target = Bool[],odds = Float64[])
       
       for sim_num in 1:n_simulations
           
        #    sim_num=1
           image_pool = []
           general_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 3)]
           list_change_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 3)]
       
           for list_num in 1:n_lists
   
               word_list, word_change_feature_list = generate_study_list(n_words, w_context, w_word, g_context, g_word, p_change);
   
               for j in eachindex(word_list) 
                   current_context_features = vcat(general_context_features, deepcopy(word_change_feature_list[j]), list_change_context_features);
                   episodic_image = EpisodicImage(word_list[j], current_context_features);
                   store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, u_star, c, n_units_time, g_word, g_context); 
               end
   
               results = probe_evaluation(image_pool, word_list, word_change_feature_list,n_lists,list_change_context_features, general_context_features, n_words)
               
               for (ires, res) in enumerate(results) #1D array, length is 20 words
                   tt = res.is_target == :target ? true : false
                   row = [list_num, ires, sim_num, res.decision_isold, tt, res.odds] # Add more fields as needed
                #    row = [list_num, ires, sim_num, res.decision_isold, tt, res.probe, res.odds, res.likelihood_ratios] # Add more fields as needed
                   push!(all_results_df, row)
               end
                       # Update list_change_context_features 
               for cf in list_change_context_features
                   if rand() < cf.change_probability
                       cf.value = rand(Geometric(g_context)) + 1 
                   end
               end
   
           end
       end
   
       return all_results_df
   end
   
   
   
   
   all_results = simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations)
   all_results 

    #   @profile simulate_rem(n_lists, n_words, w_context, w_word, g_context, g_word, p_change, u_star, c, n_units_time, n_simulations);
#    Profile.print()
   
   DF = @chain all_results begin
       @by([:list_number, :is_target, :test_position], :meanx = mean(:decision_isold))
   end
   
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