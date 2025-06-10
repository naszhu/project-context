
# tunning on copying param

#### 1
    c_context_c = LinRange(0.75, 0.55,n_lists)  #copying parameter - 0.8 for context copying 
    c_storeintest = c
    c_context_c = LinRange(0.6,0.75, n_lists) #0.75->0.6
    c_context_un = LinRange(0.75,0.75, n_lists)
 - ![alt text](<imgMD/image.png>)


#### 2
    c_context_c = LinRange(0.75,0.6, n_lists) #0.75->0.6
- this gives a decrease for T, but small chages of others
==> this gives big decrease of both T and F, small rise in Fb, i think makes sense because ctx second stage... (see handwriting proof here)

#### 3
    c = LinRange(0.75, 0.55,n_lists)  #copying parameter - 0.8 for context copying 
    c_storeintest = c
    c_context_c = LinRange(0.75,0.75, n_lists) #0.75->0.6
    c_context_un = LinRange(0.75,0.75, n_Blists)


#### 4
    c = LinRange(0.75, 0.75,n_lists)  #copying parameter - 0.8 for context copying 
    c_storeintest = c
    c_context_c = LinRange(0.5,0.75, n_lists) #0.75->0.6

Gives the reverse direction of result -> lower Fb, higher T, a bit lower F

see email today for a detail of plots


#### New idea Rich may26, same, C(c) increase but big U
    u_star_context=vcat(1, ones(n_lists-1)*1)#CHANGED
    u_adv_firstpos=0.00 #adv of first position in eeach list

    c = LinRange(0.75, 0.75,n_lists)  #copying parameter - 0.8 for context copying 
    c_storeintest = c
    c_context_c = LinRange(0.5,0.6, n_lists) #0.75->0.6
    c_context_un = LinRange(0.75,0.75, n_lists)

(small increase green Fb, drop both F, T)
![alt text](<imgMD/25-05-25 cc_uc change/image.png>)