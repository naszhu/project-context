
using Distributions: Categorical

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

        _, likelihood_ratios_org = calculate_two_step_likelihoods2(probes[i].image, image_pool, 1.0, i)
        likelihood_ratios = likelihood_ratios_org |> x -> filter(e -> e != 344523466743, x)
        #    if ii==1 println(size(image_pool),"of", size(likelihood_ratios)) end


        # println(likelihood_ratios)
        odds = (1 / length(likelihood_ratios) * sum(likelihood_ratios))^power_taken

        crrchunk = ceil(Int, i / 42)
        criterion_final_i = criterion_final[crrchunk] #this need to be changed if 

        # Calculate sampling probabilities early (following E3 pattern)
        filtered_content_LL_ratios_inOriginalLength = likelihood_ratios_org |> x -> map(e -> e == 344523466743 ? 0 : e, x)
        filtered_content_LL_ratios_inOriginalLength_to_11thpower = filtered_content_LL_ratios_inOriginalLength .^ power_taken
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength_to_11thpower)
        sampling_probabilities = total_sum_LL == 0 ? zeros(length(filtered_content_LL_ratios_inOriginalLength_to_11thpower)) : [filtered_content_LL_ratios_inOriginalLength_to_11thpower[i_LL_proportion] ./ total_sum_LL for i_LL_proportion in eachindex(filtered_content_LL_ratios_inOriginalLength_to_11thpower)]

        # Sample or select item BEFORE decision logic (following E3 pattern)
        sampled_item = nothing
        is_same_item = false  # Initialize is_same_item
        is_sampled = false    # Initialize is_sampled
        if (odds > criterion_final_i) && (odds > recall_odds_threshold)
            is_sampled = true

            if sampling_method
                # Use sampling probabilities - check if we have valid probabilities
                if sum(sampling_probabilities) > 0
                    cdf_each_boral_sets = Categorical(sampling_probabilities)
                    index_sampled = rand(cdf_each_boral_sets)
                    sampled_item = image_pool[index_sampled]

                    # Check if the sampled item is the same as the probe being tested
                    is_same_item = sampled_item.word.item == probes[i].image.word.item
                end
            else
                # Pick the image with maximum content_LL_ratios value
                imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org])
                sampled_item = image_pool[imax]

                # Check if the sampled item is the same as the probe being tested
                is_same_item = sampled_item.word.item == probes[i].image.word.item
            end
        end

        # Decision logic - only if we have a sampled item (following E3 pattern)
        if odds > criterion_final_i
            if odds > recall_odds_threshold
                # We should have a sampled item at this point
                @assert !isnothing(sampled_item) "sampled item is nothing"
                decision_isold = 1
            else
                decision_isold = 1
            end
        else #if didn't pass, directly judge new
            decision_isold = 0
        end



        # Calculate Z values for targets in current chunk ONLY (not all memory pool)
        currchunk = crrchunk  # Use the chunk calculated earlier
        current_chunk_targets = filter(img -> img.list_number == currchunk && img.word.type == :T_target, image_pool)
        Z_sum = 0
        Z_proportion = 0.0
        
        if !isempty(current_chunk_targets)
            Z_sum = sum(get_Z_feature_value(target.word) for target in current_chunk_targets)
            Z_proportion = Z_sum / length(current_chunk_targets)
        end

        # Store results (modify as needed)
        # Debug: Track final test performance by initial position for the flat line issue
        if i <= 10  # Only for first 10 probes to avoid spam
            is_distorted = contains(probes[i].image.word.item, "DISTORTED")
            # println("[DEBUG-FLAT-LINE] Final pos $(i): initial_testpos=$(probes[i].image.initial_testpos_img), Type=$(probes[i].classification), distorted=$(is_distorted), decision=$(decision_isold), odds=$(round(odds, digits=3))")
        end
        
        # Debug: Summary of initial test position distribution at end of first list
        if i == length(probes)
            # Count distribution of initial test positions
            initial_pos_counts = Dict{Int, Int}()
            distorted_by_pos = Dict{Int, Int}()
            
            for probe in probes
                pos = probe.image.initial_testpos_img
                initial_pos_counts[pos] = get(initial_pos_counts, pos, 0) + 1
                
                if contains(probe.image.word.item, "DISTORTED")
                    distorted_by_pos[pos] = get(distorted_by_pos, pos, 0) + 1
                end
            end
            
            # println("\n[DEBUG-FLAT-LINE-SUMMARY] Final test probe distribution:")
            for pos in sort(collect(keys(initial_pos_counts)))
                distorted_count = get(distorted_by_pos, pos, 0)
                total_count = initial_pos_counts[pos]
                # println("  initial_testpos=$(pos): $(total_count) probes, $(distorted_count) distorted")
            end
        end

        results[i] = (decision_isold=decision_isold, is_target=string(probes[i].classification), odds=odds, list_num=probes[i].image.list_number, initial_studypos=probes[i].image.word.studypos, initial_testpos = probes[i].image.initial_testpos_img, Z_sum=Z_sum, Z_proportion=Z_proportion, is_sampled=is_sampled, is_same_item=is_same_item) #! made changes to results, format different than that in inital

        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);
        # restore_intest(image_pool,probes[i].image, decision_isold, argmax(likelihood_ratios));
        if is_restore_final
            restore_intest_final(image_pool, probes[i].image, decision_isold, odds, i, likelihood_ratios_org, sampled_item, criterion_final[currchunk], i)
        end
        
        # Debug: Close final test position 1 section
        # if i == 1
        #     println("[DEBUG-FINAL-TEST-POS1] Final decision: decision_isold=$(decision_isold), odds=$(round(odds, digits=3))")
        #     println("=== END FINAL TEST POSITION 1 ===\n")
        # end
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
        odds = (1 / nl * sum(likelihood_ratios))^power_taken

        if (isnan(odds))
            println("Current context_tau is too high, there are some simulations that have no tarce passing context filter in first step", nl, likelihood_ratios)
        end

        # Calculate sampling probabilities early (following E3 pattern)
        filtered_content_LL_ratios_inOriginalLength = likelihood_ratios_org |> x -> map(e -> e == 344523466743 ? 0 : e, x)
        filtered_content_LL_ratios_inOriginalLength_to_11thpower= filtered_content_LL_ratios_inOriginalLength .^ power_taken
        total_sum_LL = sum(filtered_content_LL_ratios_inOriginalLength_to_11thpower)
        sampling_probabilities = total_sum_LL == 0 ? zeros(length(filtered_content_LL_ratios_inOriginalLength_to_11thpower)) : [filtered_content_LL_ratios_inOriginalLength_to_11thpower[i_LL_proportion] ./ total_sum_LL  for i_LL_proportion in eachindex(filtered_content_LL_ratios_inOriginalLength_to_11thpower)]
        
        # E1 New Z Feature Logic (adapted from E3)
        # Sample or select item BEFORE decision logic
        sampled_item = nothing
        is_same_item = false
        is_sampled = false
        
        if odds > criterion_initial[i_testpos,ilist_probe]
            if odds > recall_odds_threshold
                is_sampled = true
                
                if sampling_method
                    # Use sampling probabilities to select an item
                    if sum(sampling_probabilities) > 0  # Check if we have valid probabilities
                        cdf_each_boral_sets = Categorical(sampling_probabilities)
                        index_sampled = rand(cdf_each_boral_sets)
                        sampled_item = image_pool_currentlist[index_sampled]
                        is_same_item = sampled_item.word.item == probes[i].image.word.item
                    end
                else
                    # Pick the image with maximum likelihood ratio
                    imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org])
                    sampled_item = image_pool_currentlist[imax]
                    is_same_item = sampled_item.word.item == probes[i].image.word.item
                end
                
                # Apply Z feature logic for E1 (simplified - only targets, no confusing foils)
                if ilist_probe != 1 && use_Z_feature && !isnothing(sampled_item)
                    ranv = rand()
                    if ranv < h_j[ilist_probe-1]
                        # Use Z feature from sampled item
                        Z_value = get_Z_feature_value(sampled_item.word)


                        """
                        I'm not sure what to do for this part. Should E1 have the recall to reject? I don't think so so I commented this out. But if this is the case, Z feature doesn't play a part at all then. Might be a problem. But I can't think of a way for explaining why Z could work right here

                        Ok, i thought of a way of why this works. That is, Ss want to focus on current list, and thus, when they found this is an OLD list item, they ignored this item. So they judge new. maybe
                        """
                        if Z_value === 1
                            decision_isold = 0  # Z=1 means judged new
                            # println("here")
                        else
                            # println("there")
                            decision_isold = 1  # Z=0 means judged old
                        end

                        # decision_isold = 0 #This is probably wrong but you could set another prob and say now with this prob you could answer mistakenly 
                    else
                        # Don't use Z feature, use familiarity only
                        decision_isold = 1
                    end
                else
                    # List 1 or Z feature disabled - use familiarity only
                    decision_isold = 1
                end
            else
                decision_isold = 1
            end
        else
            decision_isold = 0  # Didn't pass threshold, judge as new
        end
        
        diff = 1 / (abs(odds - criterion_initial[i_testpos,ilist_probe]) + 1e-10)

        #criterion change by test position

        # Sample or select item BEFORE decision logic (following E3 pattern)
        # sampled_item = nothing
        # is_same_item = false  # Initialize is_same_item
        # is_sampled = false    # Initialize is_sampled
        # if (odds > criterion_initial[i_testpos, ilist_probe]) && (odds > recall_odds_threshold)
        #     is_sampled = true
            
        #     if sampling_method
        #         # Use sampling probabilities
        #         cdf_each_boral_sets = Categorical(sampling_probabilities)
        #         index_sampled = rand(cdf_each_boral_sets)
        #         sampled_item = image_pool_currentlist[index_sampled]
                
        #         # Check if the sampled item is the same as the probe being tested
        #         is_same_item = sampled_item.word.item == probes[i].image.word.item
        #     else
        #         # Pick the image with maximum content_LL_ratios value
        #         imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org])
        #         sampled_item = image_pool_currentlist[imax]
                
        #         # Check if the sampled item is the same as the probe being tested
        #         is_same_item = sampled_item.word.item == probes[i].image.word.item
        #     end
        # end

        # decision_isold = odds > criterion_initial[i_testpos] ? 1 : 0;

        nav = length(likelihood_ratios) / (length(image_pool_currentlist))
        # println(nav)
        # if (decision_isold == 1) && (odds > recall_odds_threshold)
        #     imgMax = image_pool_currentlist[argmax(content_LL_ratios_filtered)]
        # end

        # Calculate Z values for current list targets ONLY (not all memory pool)
        # Only calculate Z for the list being currently tested (j == currentlist)
        Z_sum = 0
        Z_proportion = 0.0

        for j in eachindex(unique_list_numbers)
            nimages = count(image -> image.list_number == j, image_pool_currentlist)
            nimages_activated = count(ii -> (image_pool_currentlist[ii].list_number == j) && (likelihood_ratios_org[ii] != 344523466743), eachindex(image_pool_currentlist))
            
            # Calculate Z metrics for current list targets only
            if j == currentlist  # Only calculate Z for the list being tested
                current_list_targets = filter(img -> img.list_number == j && img.word.type == :T_target, image_pool_currentlist)
                if !isempty(current_list_targets)
                    Z_sum = sum(get_Z_feature_value(target.word) for target in current_list_targets)
                    Z_proportion = Z_sum / length(current_list_targets)
                end
            end

            results[n_listimagepool*(i-1)+j] = (decision_isold=decision_isold, is_target=probes[i].classification, odds=odds, ilist_image=j, Nratio_imageinlist=nimages_activated / nimages, N_imageinlist=nimages_activated, Nratio_iprobe=nav, testpos=i, studypos=probes[i].image.word.studypos, diff=diff, Z_sum=Z_sum, Z_proportion=Z_proportion, is_sampled=is_sampled, is_same_item=is_same_item)
            # println(nl, " ",nimages_activated)
        end
    
        imax = argmax([ill==344523466743 ? -Inf : ill for ill in likelihood_ratios_org]);


        if is_restore_initial
            restore_intest(image_pool, probes[i].image, decision_isold, odds, likelihood_ratios_org, sampled_item, criterion_initial[i_testpos, ilist_probe], i_testpos) 
        end

        # println("i, $i, i_testpos, $i_testpos")



    end



    return results
end