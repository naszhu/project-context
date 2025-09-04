


function generate_features(distribution::Geometric, length::Int)::Vector{Float64}
    return rand(distribution, length) .+ 1
end



function generate_study_list(list_num::Int)::Vector{Word}

    # p_changeword = 0.1
    # study_list = Vector{EpisodicImage}(undef, n_words)
    word_list = Vector{Word}(undef, n_words)
    types = fast_concat(fill.([:T_target, :T_nontarget], [Int(n_probes / 2), Int(n_probes / 2)])) |> shuffle!

    for i in 1:n_words

        features = rand(Geometric(g_word), w_word) .+ 1
        
        # Add Z feature if enabled (initialize as 0 like in E3)
        if use_Z_feature
            push!(features, 0)  # Z feature starts as 0 (not tested before)
        end
        
        word_list[i] = Word("Word$(i)L$(list_num)", features, types[i], i)
    end


    return word_list
end