function calculate_likelihood_ratio_test(probe, image, g, c)

    lambda = Float64[];

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  # for those that doesn't match
            push!(lambda, 1);
        elseif image[k] != 0 
            if image[k] != probe[k]
                push!(lambda, 1-c);
            elseif image[k] == probe[k]
                push!(lambda, (c + (1-c)*g*(1-g)^(image[k]-1))/(g*(1-g)^(image[k]-1)));
            else 
                error("error image match")
            end
        else
            error("error here")
        end
    end

    return prod(lambda)
end

a = calculate_likelihood_ratio_test([2 3 4 3], [2 2 1 0], 0.4, 0.7);

function calculate_likelihood_ratio(probe, image, g, c)
   
    lambda = Vector{Float64}(undef, length(probe));

    for k in eachindex(probe) # 1:length(probe)
        if image[k] == 0  # for those that doesn't match
            lambda[k] = 1;
        elseif image[k] != 0 
            if image[k] != probe[k]
                lambda[k] = 1-c;
                # println(1-c)
            elseif image[k] == probe[k]
                lambda[k] = (c + (1-c)*g*(1-g)^(image[k]-1))/(g*(1-g)^(image[k]-1));
            else 
                error("error image match")
            end
        else
            error("error here")
        end
    end

    return prod(lambda)
end

calculate_likelihood_ratio([2 3 4 3], [2 2 1 0], 0.4, 0.7)


odds = 1 / n_words * sum(likelihood_ratios);

        decision_isold = odds>1 ? 1 : 0;

itt = :target;
itf = :foil;

ptarget = generate_probe(itt, word_list, word_change_feature_list[n_lists], list_change_context_features, general_context_features) 
pfoil = generate_probe(itf, word_list, word_change_feature_list[n_lists], list_change_context_features, general_context_features) 

# ; Row │ fval1  fval2  feature_type 
# ; │ Int64  Int64  Symbol
# ; ─────┼────────────────────────────
# ; 1 │     3      3  general
# ; 2 │     3      3  general
# ; 3 │     8      8  general
# ; 4 │     3      3  general
# ; 5 │    12     12  general
# ; 6 │     2      2  general
# ; 7 │     6      6  general
# ; 8 │     4      4  general
# ; 9 │     2      2  general
# ; 10 │     6      6  general
# ; 11 │     1      1  word_change
# ; 12 │     1      1  word_change
# ; 13 │     3      3  word_change
# ; 14 │     3      3  word_change
# ; 15 │     5      7  word_change
# ; 16 │     1      1  word_change
# ; 17 │     2      2  word_change
# ; 18 │     1      1  word_change
# ; 19 │     2      2  word_change
# ; 20 │     2      2  word_change
# ; 21 │     1      1  list_change
# ; 22 │     2      2  list_change
# ; 23 │     2      2  list_change
# ; 24 │     3      3  list_change
# ; 25 │     3      3  list_change
# ; 26 │     1      1  list_change
# ; 27 │     2      2  list_change
# ; 28 │     4      4  list_change
# ; 29 │     7      7  list_change
# ; 30 │     9      9  list_change


[calculate_two_step_likelihood(ptarget, image, context_tau, g_word, g_context, c) for image in image_pool]
# 0.001158738620062501
#  3.504410527500005e-6
#  6.030128166750012e-8
#  8.833061424037514e-6
#  0.0008869187137500008
#  0.00701115822205832
#  0.08279732930625006
#  6.247548225000008e-5
#  ⋮
#  0.0013732458084562513
#  0.007087474200310322
#  0.00020849482923750024
#  1.9683000000000025e-5
#  3.8371941697558825e-7
#  0.00021104550000000023
#  1.0894540500000018e-6
#  3.6315135000000056e-6

[calculate_two_step_likelihood(pfoil, image, context_tau, g_word, g_context, c) for image in image_pool]

# 0.0011587386200625006
# 3.504410527500005e-6
# 0.0008149870561735739
# 2.941525935000006e-8
# 0.0005652383512500005
# 3.577991953932765e-5
# 0.00027572602500000023
# 0.07874971333678132
# ⋮
# 0.0014247146664562512
# 2.2333808025000032e-6
# 0.00032715042311250045
# 0.0022628767500000022
# 4.5109533559207346e-5
# 0.10804659018750004
# 0.0013732458084562515
# 0.0006698760041250008

ptarget_val=ptarget.word.word_features;
eps = [i.word.word_features for i in image_pool];

[calculate_likelihood_ratio_test(ptarget_val, image, g_word, c) for image in eps]
# 0.001158738620062501
# 3.504410527500005e-6
# 6.030128166750012e-8
# 8.833061424037514e-6
# 0.0008869187137500008
# 0.00701115822205832
# 0.08279732930625006
# 6.247548225000008e-5
# ⋮
# 0.0013732458084562513
# 0.007087474200310322
# 0.00020849482923750024
# 1.9683000000000025e-5
# 3.8371941697558825e-7
# 0.00021104550000000023
# 1.0894540500000018e-6
# 3.6315135000000056e-6

pfoil_val=pfoil.word.word_features;
# eps = [i.word.word_features for i in image_pool];

[calculate_likelihood_ratio_test(pfoil_val, image, g_word, c) for image in eps]
# 0.0011587386200625006
# 3.504410527500005e-6
# 0.0008149870561735739
# 2.941525935000006e-8
# 0.0005652383512500005
# 3.577991953932765e-5
# 0.00027572602500000023
# 0.07874971333678132
# ⋮
# 0.0014247146664562512
# 2.2333808025000032e-6
# 0.00032715042311250045
# 0.0022628767500000022
# 4.5109533559207346e-5
# 0.10804659018750004
# 0.0013732458084562515
# 0.0006698760041250008
