
"""
restore content and/or context, here, context include change,unchange, and positioncode. position code is not restored but add to new trace when don't restore context
"""
# flagn = Int64[];
# data_flag = Array{Vector{Any}}(undef, n_simulations)  # Create an array to hold vectors for each simulation
# for i in 1:n_simulations
#     data_flag[i] = Vector{Any}()  # Initialize each row as an empty vector
# end

function restore_intest(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, list_change_features::Vector{Int64}, general_context_features::Vector{Int64}, odds::Float64, likelihood_ratios::Vector{Float64}, simu_i::Int64, initial_testpos::Int64)




    if is_onlyaddtrace
        error("not coded here")
    end
    #is_onlyaddtrace is false
    # println("nothere")

    if (decision_isold==0) | ((decision_isold == 1) & (odds <= recall_odds_threshold))| ((decision_isold==1) & (odds > recall_odds_threshold)) 

        iimage_toadd = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)

    end
    if ((decision_isold==1) & (odds > recall_odds_threshold) ) 

        #recall; restore old
        iimage_tostrenghten = image_pool[imax] 
    end



    # if new, context and content change, be added to the pool
    ############ Add trace

    if (decision_isold == 0)| ((decision_isold == 1) & (odds <= recall_odds_threshold))| ((decision_isold==1) & (odds > recall_odds_threshold)) 


        for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage_toadd.word.word_features[i]
                # if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                if (j == 0) 
                    iimage_toadd.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end


            for ic in eachindex(iprobe_img.context_features)
                j = iimage_toadd.context_features[ic]

                if j == 0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04
                        iimage_toadd.context_features[ic] = rand() < u_star_context[end]+u_advFoilInitialT ? (rand() < c_context[iprobe_img.list_number] ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j

                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end


         push!(image_pool, iimage_toadd)
    end

    

    #if old, pass threshold, context and contet change, recall land strenghten

    if (decision_isold == 1) & (odds > recall_odds_threshold) #single parameter for missing or replacing

        for _ in n_units_time
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage_tostrenghten.word.word_features[i]
                # if j!=0
                    # if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    if (j == 0) #is only doing this once, so doesn't matter if j==0 or not..
                        # println("success")
                        iimage_tostrenghten.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                        # println("now",j,iprobe_img.word.word_features[i])
                    end
                # end
            end

            for ic in eachindex(iprobe_img.context_features)
                j = iimage_tostrenghten.context_features[ic]

                if (j == 0) 
                    # iimage.context_features[ic] = rand() < p_recallFeatureStore ? iprobe_img.context_features[ic] : j 
                    iimage_tostrenghten.context_features[ic] = rand() < u_star_context[end] ? (rand() < c_context[iprobe_img.list_number] ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j
                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end

            # println("Likelihood After ",calculate_likelihood_ratio(iprobe_img.word.word_features, iimage.word.word_features, g_word, c))


        end
            is_restore_context ? error("context restored in initial is not well written this part") : nothing
        # end

    end






end




function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64, imax::Int64, probetype::Symbol, odds::Float64, )
#     iimage = decision_isold == 1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)
# # println(iimage.initial_testpos_img)

    if decision_isold==0

        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img)

    elseif ((decision_isold == 1) & (odds <= recall_odds_threshold))

        # println("not passed",i probe_img.list_number)
        #give new 
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number, iprobe_img.initial_testpos_img) #here is the new image, not the one in the pool
    elseif ((decision_isold==1) & (odds > recall_odds_threshold) )

        #recall; restore old
        iimage = image_pool[imax] 
    else
        error("decision_isold is not well defined")
    end

    if (decision_isold == 0)| ((decision_isold == 1) & (odds < recall_odds_threshold))

        for _ in 1:n_units_time_restore
            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    iimage.word.word_features[i] = rand() < u_star[end] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j # 0.04 to u_star_context[2]
                end
            end


            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]

                if j == 0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04
                    # if iprobe_img.list_number == 1
                    # iimage.context_features[ic]
                    # println("iprobe_img.list_number $(iprobe_img.list_number)")
                    # u_star_context[iprobe_img.list_number]
                    iprobe_img.context_features[ic]
                        iimage.context_features[ic] = rand() < u_star_context[end] ? (rand() < c_context[end] ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j #FIXME, correct listnum assignhere?
                    # else
                        # iimage.context_features[ic] = rand() < u_star_context[end]+u_advFoilInitialT+0.1 ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j
                    # end
                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end
    end

    if !is_onlyaddtrace_final #is_onlyaddtrace_final false, so ! it is true, so will go through following code, but shouldn't becuase it actually overlaps for that from the last.
        # error("Here")
        if (decision_isold == 1) & (odds > recall_odds_threshold) 
            # pass: strenghten
            #single parameter for missing or replacing
            # WARNING: rand(Geometric(g_word)) + 1) is not used here, there is no chance of an incorrect random value storage when judging old 

            if !is_store_mismatch
                error("current prog is not written when doesn't store mismatch")
            end

            for i in eachindex(iprobe_img.word.word_features)
                j = iimage.word.word_features[i]
                if (j == 0) | ((j != 0) & (decision_isold == 1) & (j != iprobe_img.word.word_features[i]) & (is_store_mismatch))
                    # println("Pass here")
                    iimage.word.word_features[i] = rand() < 1 ? iprobe_img.word.word_features[i] : j #p_recallFeatureStore replace 1
                end
            end


            for _ in 1:n_units_time_restore_f
                for i in eachindex(iprobe_img.word.word_features)
                    j=iimage.word.word_features[i]

                    if decision_isold==1
                        if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                            iimage.word.word_features[i] = rand() < 1 ? (rand() < 1 ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
                        end
                    else
                    end
                end
            end

            is_restore_context ? error("context restored in initial is not well written this part") : nothing
        end

    end


    # if (decision_isold == 0)
    if (decision_isold == 0) | ((decision_isold == 1) & (odds < recall_odds_threshold))
        push!(image_pool, iimage)
    end


    # if decision_isold ==1 println("afterchange",iimage) end
end
# if stored sucessfully and copied suces - probeval
# if stored sucessfully and copied not suces - random val
# if not stored sucessfully - 0/keeps original value j 