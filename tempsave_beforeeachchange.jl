function generate_finalt_probes(image_pool, condition,general_context_features,list_change_context_features)

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

    for list_number in lists

        for cf in listcg
            if rand() <  p_listchange_finaltest #cf.change_probability # this equals p_change
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

        # println([i.value for i in listcg])

    end


    return probes
end
