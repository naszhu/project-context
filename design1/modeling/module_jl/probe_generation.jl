
"""generate probe for inital test for a given list,
input: studied word list; context features (word_change will modifed from the current list last word's context features)
Return: probe

list_change_features: list feature, same as studied one
test_list_context: changed RI after study, continuous reinstate in test
"""
function generate_probes(studied_words::Vector{Word}, list_change_features::Vector{Int64}, test_list_context::Vector{Int64}, general_context_features::Vector{Int64}, test_list_context_unchange::Vector{Int64}, position_code_all::Vector{Vector{Int64}}, list_num::Int64,studied_pool::Vector{EpisodicImage} )::Vector{Probe}
    # here, not deep copy word_change_features is safe because even if it influence the original index, the word-change context features will be disgarded when this list ends  


    probetypes = repeat([:target, :foil], outer=div(n_probes, 2)) |> shuffle!
    probes = Vector{Probe}(undef, length(probetypes))

    words = filter(word -> word.type == :T_target, studied_words) |> shuffle! |> deepcopy
    # println("List $(list_num)")
    # test
    stdpos  = 0;
    for i in eachindex(probetypes)
        # println("probe$(i)")
        if probetypes[i] == :target # 
            target_word = pop!(words) #pop from pre-decided targets
            stdpos += 1
            # Set Z=0 for targets according to E3 rules: Target probes (T, TN+1) → Z = 0
            if use_Z_feature
                set_Z_feature_value!(target_word, 0)
            end
            # testpos = 
        elseif probetypes[i] == :foil  # Foil case
            foil_features = generate_features(Geometric(g_word), w_word)
            # Add Z feature if enabled - E3 rules: Foil probes (F, FN+1) → Z = 0
            if use_Z_feature
                push!(foil_features, 0)  # Z feature starts as 0 (not tested before) - correct per E3 rules
            end
            target_word = Word(randstring(8), foil_features, :T_foil, 0) #insert studypos 0
        else
            error("probetypewrong")
        end

        if i>1

            # reinstate changing context: test_list_context
            nct = length(test_list_context)
            for ict in eachindex(test_list_context)
                if ict < Int(round(nct * p_reinstate_context)) #stop reinstate after a certain number of features

                    if (test_list_context[ict] != list_change_features[ict]) & (rand() < p_reinstate_rate)
                        # println("here")
                        test_list_context[ict] = list_change_features[ict] #it's ok, change list_change_features[i] won't change left
                        # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                    end
                else
                    # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
                end
                # println("$(list_change_features)")
            end


            # reinstate unchange context test_list_context_unchange
            if is_UnchangeCtxDriftAndReinstate
                nct = length(test_list_context_unchange)
                for ict in eachindex(test_list_context_unchange)
                    if ict < Int(round(nct * p_reinstate_context))

                        if (test_list_context_unchange[ict] != general_context_features[ict]) & (rand() < p_reinstate_rate)
                            # println("here")
                            test_list_context_unchange[ict] = general_context_features[ict] #it's ok, change list_change_features[i] won't change left
                            # test_list_context[ict]=2222 #it's ok, change list_change_features[i] won't change left
                        end
                    else
                        # test_list_context[ict]=list_change_features[ict] #the rest context doesn't change or reinstate
                    end
                    # println("$(list_change_features)")
                end
            end

        end
        # println("$(test_list_context)")
        current_studypos = probetypes[i] == :target ? target_word.studypos : 0;

        current_testpos = i; 


        current_poscode = probetypes[i] == :target ? position_code_all[current_studypos] : rand(Geometric(g_context), w_positioncode) .+ 1
        # println("currentprobetype is $(probetypes[i]), position is $(current_studypos)")

        current_context_features = fast_concat([deepcopy(test_list_context_unchange), deepcopy(test_list_context), current_poscode]) #here needs a deepcopy, otherwise the front remembered context change with later ones  
        # current_context_features = deepcopy(test_list_context); #here needs a deepcopy, otherwise the front remembered context change with later ones  


        # probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], target_word.studypos ,i)
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num, current_testpos), probetypes[i] ,current_testpos)
        
        if probetypes[i] == :target

            matching_image = findfirst(img -> img.word.item == target_word.item, studied_pool)

            if matching_image !== nothing
                studied_pool[matching_image].initial_testpos_img = current_testpos #update the test position of the image in the studied pool
            else
                error("Image not found in studied pool")
            end
        end
        # println("List $(list_num),probe $(i)")
        # # println("contextf1 $(list_change_features)")
        # println("contextf2 $(current_context_features[31:end])")

    end

    # Apply content distortion if enabled (from E3)
    if is_content_drift_between_study_and_test
        # Apply distortion to probes with linear decay in probability
        # The distortion probability starts high for the first probe and linearly decreases to 0
        # after max_distortion_probes. This creates a strong distortion effect
        # for early probes that gradually diminishes for later probes.
        distorted_probes, original_probes = distort_probes_with_linear_decay(
            probes, 
            max_distortion_probes;  # Use constant from constants.jl
            base_distortion_prob = base_distortion_prob,  # Use constant from constants.jl
            g_word = g_word  # Use the constant defined in constants.jl
        )
        
        # Replace probes with distorted versions for testing
        probes = distorted_probes
    end

    return probes
end





"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes
    
    Add, make initial_testpos in probes
    """
function generate_finalt_probes(studied_pool::Array{EpisodicImage}, condition::Symbol, general_context_features::Vector{Int64}, list_change_context_features::Vector{Int64})::Vector{Probe}

    listcg = deepcopy(list_change_context_features)
    generalcg = deepcopy(general_context_features);
    # num_images = length(studied_pool)
    studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}()
    for img in studied_pool
        push!(get!(studyPool_Img_byList, img.list_number, Vector{EpisodicImage}()), img)
    end

# println(img.initial_testpos_img)

    lists = keys(studyPool_Img_byList) |> collect |> sort
    probes = Vector{Probe}()
    if condition == :backward
        lists = reverse(lists)
    elseif condition == :true_random

        # true random doesn't change list context during final test
        all_images = vcat(values(studyPool_Img_byList)...)  # Combine all lists
        shuffle!(all_images)  # Shuffle all images together
        studyPool_Img_byList = Dict{Int64,Vector{EpisodicImage}}(1 => all_images)
        lists = keys(studyPool_Img_byList)
        # println(lists)
    end

    icount = 0
    for list_number in lists #lists is [1] for random condition
        icount += 1
        if (icount !=1) && (condition != :true_random)
            for cf in eachindex(listcg)
                if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
                    listcg[cf] = rand(Geometric(g_context)) + 1
                end
            end
        end


        # for cf in eachindex(generalcg)
        #     if rand() < 0.01 #cf.change_probability # this equals p_change
        #         generalcg[cf] = rand(Geometric(g_context)) + 1
        #     end
        # end

        # images hold pool_image of the current list, 
        images = studyPool_Img_byList[list_number]
        images_Tt = filter(img -> img.word.type == :T_target, images) |> shuffle!
        images_Tnt = filter(img -> img.word.type == :T_nontarget, images) |> shuffle!
        images_Tf = filter(img -> img.word.type == :T_foil, images) |> shuffle!

        # Generate targets from shuffled list and foils anew
        if condition != :true_random
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7, 7, 7, 21])) |> shuffle!
        else
            probe = fast_concat(fill.([:T_target, :T_nontarget, :T_foil, :F], [7, 7, 7, 21] .* 10)) |> shuffle!
        end

        # Flagging when iprobe_chunk changes value

        

        for iprobe in eachindex(probe) #iprobe is final test testing position (maybe in group)
        

            
            if condition == :true_random
                iprobe_chunk = ceil(Int, iprobe / 42)  # Divide 420 into 10 chunks, each with 42 probes

                #the following is to change context by chunk (of list) for random condition
                # don't change context when (list in iprobe == 1) ||

                # TODO: should only change if not first list, check here
                if (iprobe!=1) && (iprobe_chunk != ceil(Int, (iprobe - 1) / 42))
                    
                    # println("iprobe ",iprobe, " iprobe_chunk ", iprobe_chunk, " flag ", iprobe_chunk != (ceil(Int, (iprobe - 1) / 42)))
                    for cf in eachindex(listcg)
                        if rand() < p_ListChange_finaltest[icount] #cf.change_probability # this equals p_change
                            listcg[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end

                # for cf in eachindex(generalcg)
                #     if rand() < p_driftAndListChange_final_ #cf.change_probability # this equals p_change
                #         generalcg[cf] = rand(Geometric(g_context)) + 1
                #     end
                # end

            end

            global img = nothing  # Initialize img as nothing to refresh its value in each iteration

            crrcontext = fast_concat([deepcopy(generalcg), deepcopy(listcg)]);


            if probe[iprobe]==:T_target

                global img = pop!(images_Tt) #this way, natrually assigns list number by the orignal image number, 
                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number,
                     img.initial_testpos_img),:T_target, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number,
                    img.initial_testpos_img),:T_target, iprobe))
                end

            elseif probe[iprobe]==:T_nontarget

                global img = pop!(images_Tnt)
                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number, img.initial_testpos_img), :T_nontarget, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number, img.initial_testpos_img),:T_nontarget, iprobe))
                end

            elseif probe[iprobe]==:T_foil

                global img = pop!(images_Tf)


                if condition== :true_random
                   
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, img.list_number, img.initial_testpos_img),:T_foil, iprobe))
                else
                    push!(probes, Probe(EpisodicImage(img.word, crrcontext, list_number, img.initial_testpos_img),:T_foil, iprobe))
                end

            elseif probe[iprobe]==:F

                foil_features = rand(Geometric(g_word), w_word) .+ 1
                # Add Z feature if enabled - E3 rules: Foil probes (F, FN+1) → Z = 0
                if use_Z_feature
                    push!(foil_features, 0)  # Z feature starts as 0 (not tested before)
                end
                global img = EpisodicImage(Word(randstring(8), foil_features, :F, 0), crrcontext, 0, 0)
                # for F, the list_number will always be only [1]
                push!(probes, Probe(img, :F, iprobe))  # Generate a new foil
            else
                error("probe type wrong!")
            end

        end

        # println([i.value for i in listcg])

    end


    return probes
end