
function simulate_rem()
    # 1. Initialization

    df_inital = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_iimageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], study_position=Int[], diff=Float64[], is_sampled=Bool[], is_same_item=Bool[] )

    df_final = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], condition=Symbol[], decision_isold=Int[], is_target=String[], odds=Float64[], initial_studypos=Int[], initial_testpos = Int[], study_pos=Float64[], is_sampled=Bool[], is_same_item=Bool[])

    for sim_num in 1:n_simulations

        # Add progress prints every 10% of simulations
        if sim_num % (n_simulations ÷ 10) == 0
            println("Progress: $(sim_num * 100 ÷ n_simulations)% simulations completed.")
        end

        #    sim_num=1
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, n_probes + Int(n_probes / 2), n_lists) #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = rand(Geometric(g_context), nU) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)]
        list_change_context_features = rand(Geometric(g_context), nC) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]

        # Store original CC (changing context) for each list at study time for final test reconstruction
        original_list_CC_by_list = Dict{Int64, Vector{Int64}}()



        for list_num in 1:n_lists

            position_code_all = [fill(0, w_positioncode) for _ in 1:n_words]


            word_list = generate_study_list(list_num) #::Vector{Word}
            # word_change_context_features = rand(Geometric(g_context),div(w_context, 2)) .+ 1;

            for j in eachindex(word_list)

                if j == 1
                    position_code_features_study = rand(Geometric(g_context), w_positioncode) .+ 1
                else
                    position_code_features_study = deepcopy(position_code_all[j-1])
                    for ij in 1:w_positioncode
                        if rand() < p_poscode_change * (j - 1) #cf.change_probability # this equals p_change
                            position_code_features_study[ij] = rand(Geometric(g_context)) + 1
                        end
                    end
                    # println("previous code$(position_code_all[j-1]),current code$(position_code_features_study)")
                end

                position_code_all[j] = position_code_features_study
                current_context_features = fast_concat([deepcopy(general_context_features), deepcopy(list_change_context_features), position_code_features_study])
                episodic_image = EpisodicImage(word_list[j], current_context_features, list_num, 0)

                # study in here
                store_episodic_image(image_pool, episodic_image.word, episodic_image.context_features, list_num)

                # for cf in eachindex(word_change_context_features)
                #     if rand() <  p_wordchange #cf.change_probability # this equals p_change
                #         word_change_context_features[cf] = rand(Geometric(g_context)) + 1 
                #     end
                # end

                # target and nontarget stored into studied pool 
                studied_pool[j, list_num] = episodic_image
            end

            # study_list_context = deepcopy(list_change_context_features);
            test_list_context = deepcopy(list_change_context_features)
            test_list_context_unchange = deepcopy(general_context_features)

            # list_change_context_features: study context, stored in study_pool & used for final test reconstruction
            # test_list_context: gets drifted (and possibly distorted), then used for initial test
            # Probes will reinstate toward the DRIFTED context (not study context)

             #context drift below for both 
            for _ in 1:n_driftStudyTest[list_num]

                # drift for changing context
                for cf in eachindex(test_list_context)
                    if rand() < p_driftStudyTest #cf.change_probability # this equals p_change
                        test_list_context[cf] = rand(Geometric(g_context)) + 1
                    end
                end

                # drift for unchanging context
                if is_UnchangeCtxDriftAndReinstate
                    for cf in eachindex(test_list_context_unchange)
                        if rand() < p_driftStudyTest
                            test_list_context_unchange[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end
            end #end for _ in 1:n_driftStudyTest[list_num]

            
            ## context distortion between study and test
            # CC_before_drift: drifted context (reinstate toward this)
            # CC_after_drift: drifted + distorted context (start probes with this if distortion enabled)
            CC_before_drift = deepcopy(test_list_context)  # Save drifted context as reinstatement target
            CC_after_drift = deepcopy(test_list_context)   # Will be distorted if enabled
            if is_CC_drift_between_study_and_test
                for cf in eachindex(CC_after_drift)
                    if rand() < base_distortion_prob_CC
                        CC_after_drift[cf] = rand(Geometric(g_context)) + 1
                    end
                end
            end


            #studied_pool[:, list_num]
            # studied_pool[j, list_num]
            # println(studied_pool)#studdied pool has length of 30, so only take first 20
            # Pass CC_before_drift as reinstatement target (drifted context, not study context)
            # Pass CC_after_drift as current test context (distorted if enabled, otherwise same as CC_before_drift)
            probes, foil_collections = generate_probes(word_list, CC_before_drift, CC_after_drift, general_context_features, test_list_context_unchange, position_code_all, list_num, studied_pool[1:n_probes,list_num]) 
            

            # println("ImagePoolNow", [i.word.item for i in image_pool])
            # println("list $(list_num), ")
            @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes / 2) "wrong number!"
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"

            # foil stored
            #    println(studied_pool[list_num,20])
            #    println(studied_pool[list_num,21])
            studied_pool[n_words+1:n_words+Int(n_words / 2), list_num] = foil_collections

            # Store original CC for this list (before it changes between lists) for final test reconstruction
            original_list_CC_by_list[list_num] = deepcopy(list_change_context_features)

            results = probe_evaluation(image_pool, probes, list_change_context_features, general_context_features, sim_num)
            # println("ImagePoolNow", [i.word.item for i in image_pool])
            

            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, res.testpos, sim_num, res.decision_isold, tt, res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff, res.is_sampled, res.is_same_item] # Add more fields as needed
                # results[]=(decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, Nratio_iprobe = nav);
                # odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], ilist_image = Int[])
                push!(df_inital, row)
            end
            # Update list_change_context_features
            for _ in 1:n_between_listchange
                for cf in eachindex(list_change_context_features)
                    if rand() < p_driftBetweenList #cf.change_probability # this equals p_change
                        list_change_context_features[cf] = rand(Geometric(g_context)) + 1
                    end
                end
            end
            
            # Update Z features between lists according to E3 rules
            # All studied-only features updated: Z = 1 with probability κs
            # Convert studied_pool matrix to vector of vectors for Z feature update
            # Filter out undefined entries
            studied_pool_vec = Vector{Vector{EpisodicImage}}()
            for i in 1:n_lists
                list_items = EpisodicImage[]
                for j in axes(studied_pool, 1)  # Iterate over first dimension
                    if isassigned(studied_pool, j, i) && !isnothing(studied_pool[j, i])
                        push!(list_items, studied_pool[j, i])
                    end
                end
                push!(studied_pool_vec, list_items)
            end
            update_Z_features_single_appearance_studied_items!(image_pool, studied_pool_vec, list_num, n_words)
            # list_change_context_features .= ifelse.(rand(length(list_change_context_features)) .<  p_driAndndListChange,rand(Geometric(g_context),length(list_change_context_features)) .+ 1,list_change_context_features)
            # println([i.value for i in list_change_context_features])

        end

        studied_pool = [studied_pool...]
        #final test here


        for ccf in eachindex(general_context_features)
            if rand() < final_gap_change #cf.change_probability # this equals p_change
                general_context_features[ccf] = rand(Geometric(g_context)) + 1
            end
        end

        # list_change_context_features
        for ccf in eachindex(list_change_context_features)
            if rand() < final_gap_change #cf.change_probability # this equals p_change
                list_change_context_features[ccf] = rand(Geometric(g_context)) + 1
            end
        end

        if is_finaltest
            # println("Processing final tests for simulation $sim_num...")
            for icondition in [:forward, :backward, :true_random]
                image_pool_bc = deepcopy(image_pool)
                finalprobes = generate_finalt_probes(studied_pool, icondition, general_context_features, list_change_context_features, original_list_CC_by_list)
                results_final = probe_evaluation2(image_pool_bc, finalprobes)
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds, res.initial_studypos, res.initial_testpos, res.initial_studypos, res.is_sampled, res.is_same_item])
                end
            end
        end


    end

    println("All simulations completed! Processing results...")
    return df_inital, df_final
end
