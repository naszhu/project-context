
## Deduction of new REM for new design

..Assume total number of traces is M

I think the rigorous deduction is:



$$

\begin{aligned}
\frac{P(O \mid D)}{P(N \mid D)}
\;=\;& \frac{P(D \mid O)}{P(D \mid N)} \\[1ex]
=\;& 
\frac{\displaystyle \sum_{j=1}^{M} P(D \mid S_{j})\,P(S_{j})}
     {P(D \mid N)} 
\quad\Bigl(\text{law of total probability over }S_{j}\Bigr) \\[1.5ex]
=\;&
\frac{\displaystyle \frac{1}{n}\sum_{j=1}^{M} P(D \mid S_{j})}
     {P(D \mid N)} 
\quad\Bigl(P(S_{j}) = 1/n\text{ for }j=1,\ldots,n\Bigr) \\[1.5ex]
=\;&
\frac{\displaystyle \frac{1}{n}\sum_{j=1}^{M} 
        \Bigl[P(D_{j}\mid S_{j})\,\prod_{\,i \neq j\,} P(D_{i}\mid N_{i})\Bigr]}
     {\displaystyle x\,\Bigl[\frac{1}{n}\sum_{j=1}^{M} 
        P(D_{j}\mid S_{j})\,\prod_{\,i \neq j\,} P(D_{i}\mid N_{i})\Bigr]
     \;+\;(1 - x)\,\Bigl[\prod_{\,i=1}^{M} P(D_{i}\mid N_{i})\Bigr]}
\quad\Bigl(\text{confusing‐foil mix}\Bigr) \\[2ex]
=\;&
\frac{
  \displaystyle \frac{1}{n}\sum_{j=1}^{M}
    \frac{\,P(D_{j}\mid S_{j})\,}{\,P(D_{j}\mid N_{j})\,}
}
{
  \displaystyle x\,\Bigl[\frac{1}{n}\sum_{j=1}^{M}
    \frac{\,P(D_{j}\mid S_{j})\,}{\,P(D_{j}\mid N_{j})\,}\Bigr]
  \;+\;(1 - x)
}
\quad\Bigl(\text{cancel each } \prod_{i=1}^{M}P(D_{i}\mid N_{i})\Bigr)\,.
\end{aligned}

$$
And here, ${P(D_j|S_j)/ P(Dj|Nj) }$ is the original odds, likelihood ratio, for regular REM

In the document, you wrote $M=n+z2n$, actually, i don't think its quite like that. There are two ways to consider total number of prior traces, if current list study item is n: 

(a) (a-1) prior traces include a new trace of study + test item whenever they appear.  then total number traces prior =2n, this is aligned to your thought so far 

(a-2) prior trace include only new trace of all studied item + test item that didn't appear in study. 
That is, only every FIRST APPEAR of an item across study and test will be added as a new trace. Deduction of REM
Our design do have the number of totally pictures newly drawn from the pool as study/test items, it will be 45 items in list 1, and 36 items in list 2-10;. then total number of traces for the most recent prior list will be different, according to this value, will have different relationships to n;

(b), Though, there are different ways to count M by that includes all prior list or just most recent prior list

(b-1)I.e., in list 2, number of traces from current study is 30, then number of total traces in memory from list 1 is 45; and in list 3, number of current study trace is 30, but number of total from list 2 is 36. 
(b-2) But, if, the total number of all traces M, after list 2, includes not only the most recent prior trace, but an accumulated number of all prior traces. i.e., in list 3, M = 30(current) + 36 (list 2) + 45 (list 1) = 111.? 

This will make (1) M to be different for each list, we will have M1, M2,..... M10, (2) x will be different for each prior list as well, x1, x2, ... xn. we can calculated proportion of matching foils out of M still, with a more complicated relationship with z, we will just have different x for each list anyways; 



Well, you are using method a-1 & b-1, simple counts of all every appearance of traces added to memory + only count most recent prior list. 
But, even if just using a-1 and b-1, the number of M is actually not exactly $n+z*2n$, either. Our design is, we have only 9 traces that will be used as confusing foils in the next list. (1) Assuming, study+test total number 60 for list n-1, the simplest way of calculation of matching traces is 9 vs. 60 in total. (2) Or, because we use 60 as total number n-1, that means we count two appearance of targets in list n-1 twice into the 60, and 3 such targets will be used in list n, meaning, actually 6 (because of double count to new trace) of such target traces out of the 60, meaning, total number of matching traces is 6+6=12. So, it will be 12:48 for matching vs. un-matching counted this way...


Ok, but I think we can halt on the calculation of M, because we will have an M calculated eventually any ways (maybe for each list), and we will have x calculated anyways for each list as well, depending on which method we want to use. 





