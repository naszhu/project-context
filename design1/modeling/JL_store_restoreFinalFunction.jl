function restore_intest_final(image_pool::Vector{EpisodicImage}, iprobe_img::EpisodicImage, decision_isold::Int64,imax::Int64, probetype::Symbol, odds::Float64)
    # iimage = image_pool[argmax(likelihood_ratios)]
    # iprobe_img = probes[i].image
    #if decided the probe is old, choose max liklihood image to start with to restore, else if new, create new empty image according to current probe to push into old images
    
    # iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    if is_onlyaddtrace_final & decision_isold == 0#only start with empty if only add trace
        iimage = EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    else #full blood version 
        # println("nothere")
        iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number);
    end
    
    for _ in 1:n_units_time_restore
        
        
        
        tf =  (iimage.word.word_features .== 0) .| ((iimage.word.word_features .!=0) .& (decision_isold .==1) .& (iimage.word.word_features .!= iprobe_img.word.word_features) .& is_store_mismatch .& (.!is_onlyaddtrace_final))

        iimage.word.word_features[tf] = ifelse.(rand(sum(tf)) .< u_star_storeintest[1], ifelse.(rand(sum(tf)) .< c_storeintest, iprobe_img.word.word_features[tf], rand(Geometric(g_context),sum(tf)) .+ 1), iimage.word.word_features[tf])

        
        if is_restore_context
            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]
                
                if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
                    # println(j,!is_onlyaddtrace)
                    iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end
                
            end
        else #when don't strengten context, then only store new context
            if decision_isold==0 #when new
                for ic in eachindex(iprobe_img.context_features)
                    j = iimage.context_features[ic]
                    
                    if j==0
                        # println(j,!is_onlyaddtrace)
                        iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                        # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                    end

                end
            # else

            end

        end

        # for ic in eachindex(iprobe_img.context_features)
        #     j = iimage.context_features[ic]
            
        #     if (j==0) | ((j!=0) & (decision_isold==1) & (j!=iprobe_img.context_features[ic]) & is_store_mismatch & (!is_onlyaddtrace))# if nothing is stored
        #         # println(j,!is_onlyaddtrace)
        #         iimage.context_features[ic] = rand() < u_star_context ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
        #     end
            
        # end
    end
    

    
    # if (decision_isold == 0) | is_onlyaddtrace
    #     push!(image_pool,iimage);
    # end
    push!(image_pool,iimage);

    
    # if decision_isold ==1 println("afterchange",iimage) end
end