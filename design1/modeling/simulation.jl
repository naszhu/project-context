
function simulate_rem()
    # 1. Initialization

    df_inital = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], decision_isold=Int[], is_target=Bool[], odds=Float64[], Nratio_iprobe=Float64[], Nratio_iimageinlist=Float64[], N_imageinlist=Float64[], ilist_image=Int[], study_position=Int[], diff_rt=Float64[] )

    df_final = DataFrame(list_number=Int[], test_position=Int[], simulation_number=Int[], condition=Symbol[], decision_isold=Int[], is_target=String[], odds=Float64[], rt=Float64[], initial_studypos=Int[], initial_testpos = Int[], study_pos=Float64[])

    for sim_num in 1:n_simulations

        #    sim_num=1
        image_pool = EpisodicImage[]
        studied_pool = Array{EpisodicImage}(undef, n_probes + Int(n_probes / 2), n_lists) #30 images (10 Tt, 10 Tn, 10 Tf) of 10 lists
        general_context_features = rand(Geometric(g_context), nU) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(w_context, 2)] 
        list_change_context_features = rand(Geometric(g_context), nC) .+ 1#[ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(w_context, 2)]



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

            # list_change_context_features only change between lists, change after each list;
            # list_change_context_features use as a record, to reinstate in probe generation 
            # test_list_context change between study and test, & change/reinstate after each test, discard after each list;

             #context drift below for both 
            for _ in 1:n_driftStudyTest[list_num]

                # drift for changing context
                for cf in eachindex(test_list_context)
                    if rand() < p_driftAndListChange #cf.change_probability # this equals p_change
                        test_list_context[cf] = rand(Geometric(g_context)) + 1
                    end
                end

                # drift for unchanging context
                if is_UnchangeCtxDriftAndReinstate
                    for cf in eachindex(test_list_context_unchange)
                        if rand() < p_driftAndListChange
                            test_list_context_unchange[cf] = rand(Geometric(g_context)) + 1
                        end
                    end
                end
            end

            #studied_pool[:, list_num]
            # studied_pool[j, list_num]
            # println(studied_pool)#studdied pool has length of 30, so only take first 20
            probes = generate_probes(word_list, list_change_context_features, test_list_context, general_context_features, test_list_context_unchange, position_code_all, list_num, studied_pool[1:n_probes,list_num]) #probe number is current list number, get probes of current list 
            

            # println("ImagePoolNow", [i.word.item for i in image_pool])
            # println("list $(list_num), ")
            @assert length(filter(prb -> prb.classification == :foil, probes)) == Int(n_probes / 2) "wrong number!"
            # @assert count(isdefined, studied_pool[list_num,:])== 20 "wrong studied"

            # foil stored
            #    println(studied_pool[list_num,20])
            #    println(studied_pool[list_num,21])
            studied_pool[n_words+1:n_words+Int(n_words / 2), list_num] = [i.image for i in filter(prb -> prb.classification == :foil, probes)]
            results = probe_evaluation(image_pool, probes, list_change_context_features, general_context_features, sim_num)
            # println("ImagePoolNow", [i.word.item for i in image_pool])
            

            for (ires, res) in enumerate(results) #1D array, length is 20 words
                tt = res.is_target == :target ? true : false
                row = [list_num, res.testpos, sim_num, res.decision_isold, tt, res.odds, res.Nratio_iprobe, res.Nratio_imageinlist, res.N_imageinlist, res.ilist_image, res.studypos, res.diff] # Add more fields as needed
                # results[]=(decision_isold = decision_isold, is_target = probes[i].classification, odds = odds, ilist_image=j,Nratio_imageinlist = nimages_activated/nimages, Nratio_iprobe = nav);
                # odds = Float64[], Nratio_iprobe = Float64[], Nratio_iimageinlist = Float64[], ilist_image = Int[])
                push!(df_inital, row)
            end
            # Update list_change_context_features 
            for _ in 1:n_between_listchange
                for cf in eachindex(list_change_context_features)
                    if rand() < p_driftAndListChange #cf.change_probability # this equals p_change
                        list_change_context_features[cf] = rand(Geometric(g_context)) + 1
                    end
                end
            end
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
            for icondition in [:forward, :backward, :true_random]
                image_pool_bc = deepcopy(image_pool)
                finalprobes = generate_finalt_probes(studied_pool, icondition, general_context_features, list_change_context_features)
                results_final = probe_evaluation2(image_pool_bc, finalprobes)
                for ii in eachindex(results_final)
                    res = results_final[ii]
                    push!(df_final, [res.list_num, ii, sim_num, icondition, res.decision_isold, res.is_target, res.odds, res.rt, res.initial_studypos, res.initial_testpos, res.initial_studypos])
                end
            end
        end


    end

    return df_inital, df_final
end
