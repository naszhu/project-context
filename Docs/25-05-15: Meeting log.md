 Meeting log
 ------------------------------------------------------------May 15
 - [x] Make just trehdhol change, see what happens. (in E3)
    - Will have the trend, but not so well
    - ![alt text](<imgMD/Meeting log/image.png>)
  
 - [x] add to E1-model with only changni+ unchanging, see what happens.
     - 20% ish unchaning in inital E1 model would work; similaritly
     - ![alt text](<imgMD/Meeting log/image-1.png>)     
  
 - [x] Just use changing context, but less use of that across lists.
    - if Changing Ctx as inital probe, but with tau change
      - ![alt text](<imgMD/Meeting log/image-2.png>)
    - if only just changing ctx, with no tau change  
      -  (would work?)
   -  if only just tau change; ?
      -  Yes; will actually work; 
      - ![alt text](<imgMD/Meeting log/image-4.png>)
    - If only high between-list drift + Lots UC ctx? ; will list-length effect apply and T drop?
      - no;gives a flatty result; 
      - 
 - [ ] The thought of second stage filter + decision criterion:
   
   - [ ] Probably much more w_context (100), but much higher first stage filter.
   - [ ] What if most features are unchanging? Don't want to use mostly changing.
   - [ ] Maybe change tau between lists, with many unchanging, will it work?

 - [ ] Keep exactly the same criterion for E1 & E3; can adjust things as lists continue, but not add more mechanisms.

   - [ ] First stage to be special: E1 modeled by special assumption, E3 by...?

   - [ ] Bigger portion of unchanging; and different tau for each list in E1; will it do?

 - [ ] E2: How we change context as lists go on evidence.

 - [ ] Sampling: Sampling memory traces to govern decision.
