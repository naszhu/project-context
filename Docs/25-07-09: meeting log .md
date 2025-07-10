

# prior result sent in email (with non-1 criterion, and with p_swith=0.2, and predplot plor in other way)


![alt text](<imgMD/25-07-09: meeting log /image-4.png>)
![alt text](<imgMD/25-07-09: meeting log /image-1.png>)
![alt text](<imgMD/25-07-09: meeting log /image-7.png>)
![alt text](<imgMD/25-07-09: meeting log /image-3.png>)
![alt text](<imgMD/25-07-09: meeting log /image.png>)



# fix by taking out p_switch
```julia
p_switch_toListOrgin = [0.0,0.0]#probabiltiy of switch (or can say, recall LOR) from familarity to recall, from familarity to knowing "List of Origin"
p_old_with_ListOrigin_SOn = 0.35
# p_old_with_ListOrigin_Tn_Fn = 0.5 #PO+ 
p_old_with_ListOrigin_Fn = 0.35 
p_old_with_ListOrigin_Tn = 0.2 #PO++ (prior target have lowest-make sense)

``` 
![alt text](<imgMD/25-07-09: meeting log /image-8.png>)
![alt text](<imgMD/25-07-09: meeting log /image-9.png>)
![alt text](<imgMD/25-07-09: meeting log /image-10.png>)
![alt text](<imgMD/25-07-09: meeting log /image-11.png>)


![alt text](<imgMD/25-07-09: meeting log /image-13.png>)
![alt text](<imgMD/25-07-09: meeting log /image-14.png>)

![alt text](<imgMD/25-07-09: meeting log /image-12.png>)
---
![alt text](<imgMD/25-07-09: meeting log /image-5.png>)
![alt text](<imgMD/25-07-09: meeting log /image-6.png>)

---
See commit
[`naszhu/REM_E3_model_fixed@4ac5b26`](https://github.com/naszhu/REM_E3_model_fixed/commit/4ac5b26a10a7c0b573029575585302471c18cc5e)

![alt text](<imgMD/25-07-09: meeting log /image-15.png>)
![alt text](<imgMD/25-07-09: meeting log /image-16.png>)

Rich:This shows that using odds only, but with a substantial cc change between lists, that foil only and test only are about .5.  That is a reasonable start. We should make context change a bit lower, so that these two probabilities will drop to about .4. Next suppose we start using p(2) and z1 (which is probably of rejecting due to list of origin info after passing recall threshold). 
To start, we want to make study-only about .10 worse than test only. Let us choose values so that a study only trace that passes the stage 1 filter, and then passes the recall threshold has a small z1, so that [1-p(2)](.86) +p(2)z1 rises from .4 to .48. Then we want a p(2)z2 to be enough higher than p(2)z1 to make test only .10 higher than study only. 