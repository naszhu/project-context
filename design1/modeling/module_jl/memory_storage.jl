
function store_episodic_image(image_pool::Vector{EpisodicImage}, word::Word, context_features::Vector{Int64}, list_num::Int64)
    # new_image = EpisodicImage(word, copy(context_features)) # Start with a copy
    # println(length(context_features))
    # intial_testpos_img, initilaize with 0, change whatever it is in probe creating. Well, the probe is created independently anyways
    new_image = EpisodicImage(Word(word.item, zeros(Int64, length(word.word_features)), word.type, word.studypos), zeros(length(context_features)), list_num, 0) # Zero word features

    for _ in 1:n_units_time
        for i in eachindex(new_image.word.word_features)
            j = new_image.word.word_features[i]

            # copystore_process(new_image,j,u_star,)
            if j == 0 # if nothing is stored
                stored_val = (rand() < u_star[list_num] ? 1 : 0) * word.word_features[i]
                # if list_num==1
                #     stored_val =(rand() < u_star[word.studypos]-0.02 ? 1 : 0)*word.word_features[i];
                # else stored_val =(rand() < u_star[word.studypos] ? 1 : 0)*word.word_features[i];
                # end
                if stored_val != 0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c ? stored_val : rand(Geometric(g_word)) + 1
                    new_image.word.word_features[i] = copied_val
                end
            end
        end

        # a[length(a)/2]1-3 4-7; 3,3
        for ic in eachindex(new_image.context_features)
        # for ic in eachindex() #only change context features, not unchange context features
            j = new_image.context_features[ic]

            if j == 0 # if nothing is stored
                # stored_val =(rand() < u_star_context[word.studypos] ? 1 : 0)*context_features[ic];
                if (list_num == 1) & (ic>nU) #only for changing; special u_star store only for change & list 1
                    # println("?")
                    stored_val = (rand() < u_star_context[list_num] ? 1 : 0) * context_features[ic]
                    # stored_val = (rand() < u_star_context[word.studypos] ? 1 : 0) * context_features[ic]
                else
                    stored_val = (rand() < u_star_context[end] ? 1 : 0) * context_features[ic]
                    # stored_val = (rand() < u_star_context[word.studypos] ? 1 : 0) * context_features[ic]

                end
                if stored_val != 0 #if sucessfully stored do the folowing, else keep the same value
                    copied_val = rand() < c_context[list_num] ? stored_val : rand(Geometric(g_context)) + 1
                    new_image.context_features[ic] = copied_val
                end
            end

        end
        # println("Word Features: ", new_image.word.word_features)
    end

    push!(image_pool, new_image)

    # println("Studied word: ", new_image.word.item, " List: ", new_image.list_number, " Study Position: ", new_image.word.studypos," ",[iimg.word.item for iimg in image_pool])
    # println("Word Features: ", new_image.word.word_features)

    # return image_pool
end