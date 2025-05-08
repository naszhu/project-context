function create_array(n_items, n_elements)
    # Outer array to store all sub-arrays
    outer_arr = Array{Array{Int}, 1}(n_items)
  
    # Loop through each item in the outer array
    for i in 1:n_items
      # Inner array to store elements
      inner_arr = Array(Int, n_elements)
  
      # Generate first element from geometric distribution
      inner_arr[1] = geometric(0.3)
  
      # Loop through remaining elements, with probability of change
      for j in 2:n_elements
        if rand() < 0.3
          inner_arr[j] = inner_arr[j-1] + geometric(0.3)
        else
          inner_arr[j] = inner_arr[j-1]
        end
      end
  
      # Store inner array in outer array
      outer_arr[i] = inner_arr
    end
  
    return outer_arr
  end