![alt text](<imgMD/25-06-12 Meetinglog/IMG_20250612_233100.jpg>)

- Go back to the simplest case with minimum working of the high dimensional data space:

i.e.,
1. Fit the top two curves first (the target and new foil) by purely criterion change (+OI), see if it works
2. Then, fit the other 3 confusing foils data by applying different p(old) for items in list n-1 (or all list numbers that are smaller than n-1), assuming the true knowledge of which item is from list n-1 is known ahead of the time  

#### Attempt for 1: Nothing Change, no CC change between lists, see OI
see commit 05f5afe5dde6bf3d1fde11f2c2fa8f83c2d693d2
The OI is so small.
```julia
LLpower = 1 #power of likelihood for changing context, 

u_star_context=vcat(0.05, ones(n_lists-1)*0.05)
c = LinRange(nnnow, nnnow,n_lists)

n_between_listchange = round.(Int, LinRange(0.0, 0.0, n_lists)); #5;15; #CHANGED, this is used in sim()
context_tau = LinRange(10000, 10000, n_lists) ##CHANGED 1000#foil odds should lower than this  
t = LinRange(1, 1, n_lists)   # Normalized range for column positions (0 to 1)

# The following is that as if p1, p2 doens't exist, 
context_threshold_filter = 0
p1_old_after_filter = LinRange(1, 1 , 10); #this is when that equals no threshold change 
p2_old_after_filter = LinRange(0.5, 0.9, 10);

function generate_asymptotic_values(p::Float64)
    # Generate linearly decreasing dim1 from 6 to 4
    dim1 = LinRange(0.3, 0.3, n_probes)
    
    t = LinRange(1, 1, n_lists)   # Normalized range for column positions (0 to 1)
    dim2 = t .^ p  # Apply the power-law to create the asymptotic increase
    
    # 3) Create the 2D matrix by outer-product of dim1 and dim2
    M = dim1 .* transpose(dim2)     # M is of size (n_probes, n_lists)
    
    return M
end

# ... in feature updates

    if is_ctx
        @assert length(target_features)==nU+nC "not same length"
        if i>nU # for CC
            pps = 0.8
        else # for unchanging 
            pps = 0.8
        end
    else #if content
        pps = 0.8
    end
```

![alt text](<imgMD/25-06-12 Meetinglog/image.png>)
![alt text](<imgMD/25-06-12 Meetinglog/image-1.png>)


## Purely check for OI:
see what is the result of list 1 with n=30, and n=300:

When 30 items:  (list 1 value of the two points is around 0.9) 
![alt text](<imgMD/25-06-12 Meetinglog/image-2.png>)

When 300 items:  (list 1 value of the two points is around 0.875) 
![alt text](<imgMD/25-06-12 Meetinglog/image-3.png>)



# Go back to original REM (+context)
JL_V0_REM_2.jl
Between-list results:

- nwords = 20
![alt text](<imgMD/25-06-12 Meetinglog OI explore/image-1.png>)

- nwords = 100
![alt text](<imgMD/25-06-12 Meetinglog OI explore/image-2.png>)


- another scaling comparison show (a drop of both T and F)
![alt text](<imgMD/25-06-12 Meetinglog OI explore/image-3.png>)