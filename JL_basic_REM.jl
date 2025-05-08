using Random, Distributions,Statistics
n_words = 10 #number of items
w = 20 # number of features
g =0.45;
n_units_time = 8
u_star=0.05 #p of storage
c=0.7 #probability of copy
n_probes = 10 # Number of probes to test



function generate_word_vector(w, g)
    return rand(Geometric(g),w).+1
end


# result_vec = zeros(n_words,w)


function store_episodic_image(n_units_time,u_star,word_vector, c, g; result_vec = zeros(Int,length(word_vector)))
    

    for j_index in eachindex(result_vec)#axes(result_vec,2)
        j = result_vec[j_index];
        if j==0 # if nothing is stored
            stored_val =(rand() < u_star ? 1 : 0)*word_vector[j_index];
            if stored_val !=0 #if sucessfully stored
                copied_val = rand() < c ? stored_val : rand(Geometric(g));
                result_vec[j_index]=copied_val;
            end
        else #if something has already been stored
            copied_val = j; # keep the same
            result_vec[j_index]=copied_val;
        end
    end
    # println(result_vec)

    n_units_time -= 1;
    if n_units_time>0
        return store_episodic_image(n_units_time,u_star,word_vector, c, g,result_vec=result_vec)
    else 
        return result_vec
    end
end

word_vector = generate_word_vector(w, g);
store_episodic_image(n_units_time,u_star,word_vector, c, g);


function calculate_likelihood_ratio(probe, image, g, c)

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

_,a = calculate_likelihood_ratio([2 3 4 3], [2 2 1 0], 0.4, 0.7);
a

# Function to choose a probe (either a target or a distractor)
function choose_probe(words, g, w, is_target=true)
    if is_target
        # Choose a target (studied word)
        return rand(words)
    else
        # Generate a distractor (new word)
        return generate_word_vector(w, g)
    end
end

# Expanded main simulation function
function simulate_rem(g, c, u_star, w, n_words, n_units_time)
    # Generate word vectors and store episodic images
    words = [generate_word_vector(w, g) for _ in 1:n_words];
    episodic_images = [store_episodic_image(n_units_time,u_star,iword , c, g) for iword in words];#(word, c, u_star)
    
    # Simulation results
    results = [];

    for _ in 1:n_probes
        # Choose a probe (randomly decide if it's a target or a distractor)
        is_target = rand(Bool);
        probe = choose_probe(words, g, w, is_target);

        # Calculate likelihood ratios for each episodic image
        likelihood_ratios = [calculate_likelihood_ratio(probe, image, g, c) for image in episodic_images];

        # Calculate the odds of the probe being an old item
        # println(likelihood_ratios)
        odds = 1 / n_words * sum(likelihood_ratios);

        decision = odds>1 ? "old" : "new"

        push!(results, (decision, is_target, probe, odds, likelihood_ratios));
    end

    return results, episodic_images
end

results, episodic_images = simulate_rem(g, c, u_star, w, n_words, n_units_time);
results
