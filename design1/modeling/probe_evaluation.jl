
function probe_evaluation2(image_pool::Vector{EpisodicImage}, probes::Vector{Probe})::Array{Any}
    results = Array{Any}(undef, length(probes))
    # println("now#$(length(probes))")
    for i in eachindex(probes)

        # _, likelihood_ratios = [calculate_two_step_likelihoods(probes[i].image, image) for image in image_pool] 
        if i == 1
            index = 1
        else
            index = searchsortedfirst(range_breaks_finalt, i) - 1
        end
        # println(index)
        # if index != -1
        #     P = P_s[index]
        # else
        #     error("Value out of range.")
        # end


        _, likelihood_ratios_org = calculate_two_step_likelihoods2(probes[i].image, image_pool, 1.0, i)
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end

        # println(likelihood_ratios)
        odds = 1 / length(likelihood_ratios) * sum(likelihood_ratios)
        # println(round(odds, digits=3), " some llikelihood ", likelihood_ratios[1], " ", likelihood_ratios[2], ", Ndenom: ", length(likelihood_ratios));
        # round(odds, digits=3)
        # for ill in likelihood_ratios
        #     if ill > 1e5
        #         println("$(ill)")
        #         break
        #     end
        # end            
        # println(" ")

        crrchunk = ceil(Int, i / 42)
        criterion_final_i = criterion_final[crrchunk] #this need to be changed if 

        decision_isold = odds > criterion_final_i ? 1 : 0

        # pold = pcrr_EZddf(log(odds))
        rt = Brt + Pi * abs(log(odds))

        # Store results (modify as needed)
        results[i] = (decision_isold=decision_isold, is_target=string(probes[i].classification), odds=odds, list_num=probes[i].image.list_number, rt=rt, initial_studypos=probes[i].image.word.studypos, initial_testpos = probes[i].image.initial_testpos_img ) #! made changes to results, format different than that in inital

        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        if is_restore_final
            restore_intest_final(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, probes[i].classification, odds)
        end
    end

    return results
end


""" 
First stage
,test_list_context::Vector{Int64}
"""
function probe_evaluation(image_pool::Vector{EpisodicImage}, probes::Vector{Probe}, list_change_features::Vector{Int64}, general_context_features::Vector{Int64},simu_i::Int64)::Array{Any}

    unique_list_numbers = unique([image.list_number for image in image_pool])
    n_listimagepool = length(unique_list_numbers)
    results = Array{Any}(undef, n_probes * n_listimagepool)
    currentlist = probes[1].image.list_number
    image_pool_currentlist = image_pool

    for i in eachindex(probes)


        if is_onlytest_currentlist
            error("can't test only current list")
            image_pool_currentlist = filter(img -> img.list_number == currentlist, image_pool)#it's ok even when new probe were add to the image pool, because new probe has current list numebr as well. It will be kept
        else
            image_pool_currentlist = image_pool
        end
        # println("this is list $(currentlist),there are $(length(image_pool_currentlist)) images in the current pool")

        # calculate_two_step_likelihoods_rule2(probes[i].image, image_pool);
        _, likelihood_ratios_org = calculate_two_step_likelihoods(probes[i].image, image_pool_currentlist, 1.0, i) #proportion is all
        # likelihood_ratios = calculate_two_step_likelihoods_rule2(probes[i].image, image_pool); #proportion is all
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x)
        # println(length(likelihood_ratios_org)== length(image_pool_currentlist) )


        ilist_probe = probes[i].image.list_number
        i_testpos = probes[i].initial_testpos#1:20

        nl = length(likelihood_ratios)
        odds = 1 / nl * sum(likelihood_ratios)

        if (isnan(odds))
            println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, likelihood_ratios)
        end
        decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0
        diff = 1 / (abs(odds - criterion_initial[i_testpos]) + 1e-10)

        #criterion change by test position

        # decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;

        nav = length(likelihood_ratios) / (length(image_pool_currentlist))
        # println(nav)
        if (decision_isold == 1) && (odds > recall_odds_threshold)
            imgMax = image_pool_currentlist[argmax(likelihood_ratios)]
        end

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            

            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, is_target=probes[i].classification, odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.studypos, diff=diff)
            # println(nl, " ",nimages_activated)
        end
    
        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);


        if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, decision_isold == 1 ? imax : 1, probes[i].classification, list_change_features, general_context_features, odds, likelihood_ratios_org, simu_i, i) 
        end

        # println("i, $i, i_testpos, $i_testpos")



    end



    return results
end