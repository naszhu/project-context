
"""generate probe for inital test for a given list,
input: studied word list; context features; content features
Return: probe, foil_collection

Parameters:
- content_before_distort: word list with drifted content (REINSTATEMENT TARGET for content)
- content_after_distort: word list with drifted+distorted content (CURRENT for content)
- CC_before_distort: drifted CC context (REINSTATEMENT TARGET for CC)
- CC_after_distort: drifted+distorted CC context (CURRENT for CC)
- UC_before_distort: drifted UC context (REINSTATEMENT TARGET for UC)
- UC_after_distort: drifted+distorted UC context (CURRENT for UC)
- general_context_features: general context (not modified, legacy parameter)
- position_code_all: position codes
- list_num: current list number
- studied_pool: studied images pool

Reinstatement: probes after the first one will partially reinstate toward "before_distort" versions
"""
function generate_probes(
    content_before_distort::Vector{Word}, 
    content_after_distort::Vector{Word},
    CC_before_distort::Vector{Int64}, 
    CC_after_distort::Vector{Int64}, 
    UC_before_distort::Vector{Int64}, 
    UC_after_distort::Vector{Int64},
    general_context_features::Vector{Int64}, 
    position_code_all::Vector{Vector{Int64}}, 
    list_num::Int64,
    studied_pool::Vector{EpisodicImage}
)::Tuple{Vector{Probe}, Vector{EpisodicImage}}
    # here, not deep copy word_change_features is safe because even if it influence the original index, the word-change context features will be disgarded when this list ends  


    probetypes = repeat([:target, :foil], outer=div(n_probes, 2)) |> shuffle!
    probes = Vector{Probe}(undef, length(probetypes))
    
    # Initialize foils collection to store new foil probes
    foils_collection = Vector{EpisodicImage}()

    # STEP 1: Create all words (targets and foils) BEFORE distortion
    # Use content_before_distort (not distorted yet) for selecting target words
    target_words_pool = filter(word -> word.type == :T_target, content_before_distort) |> shuffle! |> deepcopy
    
    # Create array to hold all probe words (will be distorted together)
    probe_words = Vector{Word}(undef, length(probetypes))
    
    for i in eachindex(probetypes)
        if probetypes[i] == :target
            probe_words[i] = pop!(target_words_pool)
            # Set Z=0 for targets according to E3 rules: Target probes (T, TN+1) → Z = 0
            if use_Z_feature
                set_Z_feature_value!(probe_words[i], 0)
            end
        elseif probetypes[i] == :foil
            foil_features = generate_features(Geometric(g_word), w_word)
            # Add Z feature if enabled - E3 rules: Foil probes (F, FN+1) → Z = 0
            if use_Z_feature
                push!(foil_features, 0)  # Z feature starts as 0 (not tested before)
            end
            probe_words[i] = Word(randstring(8), foil_features, :T_foil, 0)
        else
            error("probetypewrong")
        end
    end
    
    # STEP 2: Apply CONTENT DISTORTION to all probe words at once (both targets and foils)
    probe_words_before_distort = deepcopy(probe_words)  # Save for reinstatement
    probe_words_after_distort = deepcopy(probe_words)   # Will be distorted
    
    if is_content_distort_between_study_and_test
        distort_probe_words_content!(probe_words_after_distort, base_distortion_prob, g_word, w_word)
    end
    
    # STEP 3: Now iterate through probes, applying reinstatement and creating probes
    for i in eachindex(probetypes)
        target_word = probe_words_after_distort[i]  # Get the (possibly distorted) word
        
        if i>1 #now the first item is not reinstated

            # REINSTATE CC (changing context): reinstate from after_distort toward before_distort
            reinstate_context_duringTest!(CC_after_distort, CC_before_distort, p_reinstate_context, p_reinstate_rate)

            # REINSTATE UC (unchanging context): reinstate from after_distort toward before_distort
            if is_UC_distort_between_study_and_test
                reinstate_context_duringTest!(UC_after_distort, UC_before_distort, p_reinstate_context, p_reinstate_rate)
            end

            # REINSTATE CONTENT: reinstate THIS probe's word features from after_distort toward before_distort
            if is_content_distort_between_study_and_test
                reinstate_word_content_duringTest!(target_word, probe_words_before_distort[i], p_reinstate_rate, w_word)
            end

        end


        



        # println("$(test_list_context)")
        current_studypos = probetypes[i] == :target ? target_word.studypos : 0;

        current_testpos = i; 


        current_poscode = probetypes[i] == :target ? position_code_all[current_studypos] : rand(Geometric(g_context), w_positioncode) .+ 1
        # println("currentprobetype is $(probetypes[i]), position is $(current_studypos)")

        # Build context from UC_after_distort and CC_after_distort (which may have been reinstated)
        current_context_features = fast_concat([deepcopy(UC_after_distort), deepcopy(CC_after_distort), current_poscode]) #here needs a deepcopy, otherwise the front remembered context change with later ones  


        # probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num), probetypes[i], target_word.studypos ,i)
        probes[i] = Probe(EpisodicImage(target_word, current_context_features, list_num, current_testpos), probetypes[i] ,current_testpos)
        
        # Collect foils for the foils collection
        # IMPORTANT: Use NON-DISTORTED word for foils_collection (for final test)
        # Context can be before or after distortion/reinstatement (doesn't affect final test per comment line 143)
        if probetypes[i] == :foil
            non_distorted_foil = EpisodicImage(
                probe_words_before_distort[i],  # NON-DISTORTED word content
                current_context_features,        # Context (doesn't matter for final test)
                list_num,
                current_testpos
            )
            push!(foils_collection, deepcopy(non_distorted_foil))
        end
        
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



    ## deleted the old distortion  


    ## foil collection will have context before or after drifted to be stored in studypool is both fine becuase final test don't use this only use the content in studied pool, so as long as the content is not drifted
    return probes, foils_collection
end





"""Input the flattened studied pool, first 30 are t/n/f in list 1, and etc; give last list's list_change_cf to change from list to list for probes

    Add, make initial_testpos in probes
    """
function generate_finalt_probes(studied_pool::Array{EpisodicImage}, condition::Symbol, general_context_features::Vector{Int64}, list_change_context_features::Vector{Int64}, original_list_CC_by_list::Dict{Int64, Vector{Int64}})::Vector{Probe}

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
        # if (icount !=1) && (condition != :true_random)
        #     drift_between_lists_final!(listcg, icount)
        #     drift_between_lists_final!(generalcg, icount)

        #     # Context reconstruction
        #     original_CC = original_list_CC_by_list[list_number]
        #     reinstate_CC_finaltest!(listcg, original_CC, condition)
        # end

        if condition != :true_random

             # Context reconstruction
            #  if (list_number == 1) && (condition == :forward)
                original_CC = original_list_CC_by_list[list_number]
                reinstate_CC_finaltest!(listcg, original_CC, condition)
            #  end

            if icount != 1
                drift_between_lists_final!(listcg, icount)
                drift_between_lists_final!(generalcg, icount)
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
                
                iprobe_chunk = ceil(Int, iprobe / chunk_size_final_change)  # Divide 420 into 10 chunks, each with 42 probes

                #the following is to change context by chunk (of list) for random condition
                # don't change context when (list in iprobe == 1) ||

                # TODO: should only change if not first list, check here
                if (iprobe!=1) && (iprobe_chunk != ceil(Int, (iprobe - 1) / chunk_size_final_change))
                    drift_between_lists_final!(listcg, icount)
                    drift_between_lists_final!(generalcg, icount)
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