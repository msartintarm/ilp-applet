variable
	cost, LAT, SVC;
binary variable
    Mvn(v,n), Mel(e,l), Mvl(v,l);
positive variable   
    Tv(v), Te(e), O(l), extra(e), Wn(n);


* Setup Aliases, and alternate ways of viewing inputs
alias(v1,v2,v);
set Gvv(v,v);
Gvv(v1,v2)=YES$(sum(e,Gve(v1,e) and Gev(e,v2))); 
alias (l1,l2,l);
set Hll(l,l);
Hll(l1,l2)=YES$( sum(n,Hln(l1,n) and Hnl(n,l2)) or 
         (sum(r,Hlr(l1,r) and Hrl(r,l2)) and not sum(n,Hnl(n,l1) and Hln(l2,n))) );
