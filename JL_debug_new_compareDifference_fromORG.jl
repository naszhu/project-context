# the following is valid



    # println("nothere")
    iimage = decision_isold ==  1 ? image_pool[imax] : EpisodicImage(Word(iprobe_img.word.item, fill(0, length(iprobe_img.word.word_features)), iprobe_img.word.type, iprobe_img.word.studypos), zeros(length(iprobe_img.context_features)), iprobe_img.list_number); 


# if decision is old, the following change the image in image pool
# if the decision is new, the following modify the new empty image

# if onlyaddingtrace

for _ in 1:n_units_time_restore_f
    
    for i in eachindex(iprobe_img.word.word_features)
        j=iimage.word.word_features[i]

        if decision_isold==1
            if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                iimage.word.word_features[i] = rand() < 1 ? (rand() < 1 ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j;
            end
        else
            if (j==0) | ((j!=0) &( decision_isold==1) & (j!=iprobe_img.word.word_features[i]) & (is_store_mismatch))
                iimage.word.word_features[i] = rand() < u_star_context[2] ? (rand() < c_storeintest ? iprobe_img.word.word_features[i] : rand(Geometric(g_word)) + 1) : j; # u_star_context[2] ->0.04
            end
        end
    end

        
    # else #when don't strengten/restore context, then only store new context
        if decision_isold==0 #when new
            for ic in eachindex(iprobe_img.context_features)
                j = iimage.context_features[ic]
                
                if j==0
                    # println(j,!is_onlyaddtrace)
                    #u_star_context to 0.04
                    if iprobe_img.list_number==1
                        iimage.context_features[ic] = rand() < u_star_context[1] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                    else
                        iimage.context_features[ic] = rand() < u_star_context[2] ? (rand() < c_context ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                    end
                    # iimage.context_features[ic] = rand() < 1 ? (rand() < 1 ? iprobe_img.context_features[ic] : rand(Geometric(g_context)) + 1) : j;
                end

            end
        end
end

if (decision_isold == 0) | is_onlyaddtrace
    push!(image_pool,iimage);
end