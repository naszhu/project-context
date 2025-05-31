
1. E3
   1. ratio_unchanging_to_itself_init = LinRange(0.0, 0.2, n_lists) # if use no unchanging;
   2. ratio_changing_to_itself_init = LinRange(0.5,1, n_lists) 
   3. context_tau = LinRange(100, 10000, n_lists) 
   4. 
![alt text](imgMD/explore_log_crisis_issue_root7/image.png)

1. E1

![alt text](imgMD/explore_log_crisis_issue_root7/image-2.png)
![alt text](imgMD/explore_log_crisis_issue_root7/image-1.png)

-- previously , I had this:
![alt text](imgMD/explore_log_crisis_issue_root7/image-3.png)

-- !! Okok, I wasn't wrong in likelihood fucntion in adding the chunking image_context...
i don't know what im doing today; stumpling around these issues... Feeling like that I am not focused enough today.... My mind might not be working well today.
![alt text](imgMD/explore_log_crisis_issue_root7/image-4.png) 

uh.. whats the current mechianism for list 1 drop to list 2now?? if i don't have the special save..??

- E1: seems like when adding changing ctx initially (20%, the OI shows up.?) Why? 
- ![alt text](imgMD/explore_log_crisis_issue_root7/image-5.png)

=> Ok, it was a bug; it should be this when no u_star special + 20% self ratio Unchanging initial  
![alt text](imgMD/explore_log_crisis_issue_root7/image-6.png)

---------------
E3 (after debug)
1. stable tau; C + 20%=>0 UC; 