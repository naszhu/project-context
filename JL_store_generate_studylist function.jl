function generate_study_list(num_words, num_context_features, num_word_features, g_context, g_word, p_change)
    
    study_list = Vector{EpisodicImage}(undef, num_words)
    # word_list = Vector{Word}(undef, num_words)
    # study_list = Vector{EpisodicImage}(undef, num_words)

    general_context_features = [ContextFeature(rand(Geometric(g_context)) + 1, :general, p_change) for _ in 1:div(num_context_features, 3)]
    word_change_context_features  = [ContextFeature(rand(Geometric(g_context)) + 1, :word_change, p_change) for _ in 1:div(num_context_features, 3)]
    list_change_context_features  = [ContextFeature(rand(Geometric(g_context)) + 1, :list_change, p_change) for _ in 1:div(num_context_features, 3)]

    # context_features = vcat(general_context_features, word_change_context_features, list_change_context_features)

    for i in 1:num_words
        # Update context features (word-to-word changes)
        for cf in word_change_context_features
            if  rand() < cf.change_probability
                if (cf.type == :word_change) & (i!==1)
                    cf.value = rand(Geometric(g_context)) + 1
                    # cf.value = 99999
                end
            end
        end

        word = Word("Word$(i)", generate_features(Geometric(g_word), num_word_features)) 
        current_context_features = vcat(general_context_features, deepcopy(word_change_context_features), list_change_context_features)
        episodic_image = EpisodicImage(word, current_context_features)
        study_list[i]=episodic_image;


    end


    return study_list
end