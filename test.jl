function probe_evaluation(image_pool, probes)
    results = Array{Any}(undef, n_probes);
    
    for i in eachindex(probes)
        # Choose target or foil, generate probe (implementation needed)
        # calculate_two_step_likelihood(prob1, image_pool[181], context_tau, g_word,g_context, c)
        
        # Calculate likelihoods (with built-in context filtering)
        likelihood_ratios = [calculate_two_step_likelihood(probes[i].image, image, context_tau, g_word, g_context, c) for image in image_pool] |> x -> filter(e -> e != 344523466743, x);
        
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end
        
        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios);
        decision_isold = odds > 1 ? 1 : 0;
        
        # Store results (modify as needed)
        results[i] = (decision_isold = decision_isold, is_target = probes[i].classification, probe = probes[i].image, odds = odds, likelihood_ratios = likelihood_ratios);
    end

    

    
    return results
end












    # Create a new EpisodicImage with 0 fills on values
    new_empty_image = EpisodicImage(Word(iprobe.word.item, fill(0, length(iprobe.word.word_features))), [ContextFeature(0, cf.type, cf.change_probability) for cf in iprobe.context_features], iprobe.list_number)

valuesss = [0.1, 0.6, 0.5]
counts = [3, 1, 2]
vcat(fill.(valuesss, counts)...)

u_star_storeintest = u_star + 0.05
c_storeintest = c + 0.1

u_star_context = u_star +0.03 # ratio of this and the next is key for T_nt > T_t
c_context = c + 0.1


new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features))), [ContextFeature(zero(Int64), cf.type, cf.change_probability) for cf in context_features], list_num) # Zero word features
    
for _ in 1:n_units_time
    for i in eachindex(new_image.word.word_features)
        j=new_image.word.word_features[i]
        
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


listcg = deepcopy(list_change_context_features)
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

    images = list_images[list_number]
probe = repeat([:target, :foil], outer = num_probelist) |>shuffle! ;  # The number of probe is wrong here

for iprobe in eachindex(probe)  
    crrcontext = vcat(general_context_features, deepcopy(listcg));
    if probe[iprobe]==:target
        # println(list_number,images)
        push!(probes, Probe(EpisodicImage(pop!(images).word, crrcontext, list_number),:target))
    elseif probe[iprobe]==:foil
        push!(probes, Probe(EpisodicImage(Word(randstring(8), rand(Geometric(g_word), w_word) .+ 1), crrcontext, list_number),:foil))  # Generate a new foil
    else
        error("probe type wrong!")
    end
end




xx = 5
yy = false 

xx == 5 || yy < 5
(xx == 5) || (yy < 5)
((xx == 5) || yy) == 5

# Evaluation steps:
# 1. x == 5 is evaluated first (due to higher precedence) -> true
# 2. true && y < 5 is evaluated next -> true