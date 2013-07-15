
Variable            cost;
binary variable     Mn(v,n), Ml(e,l);
S.up                = 100;
Tv.up(v)            = 300;
Te.up(e)            = 300;
length.up	    = 5000;
Equations
only1(K,v)
*    inputs(v)       
*    outputs(v)      
noOthers(v)
*add(v)
add
source_mapping(e,n)
dest_mapping(e,n)
incoming_links(e,r)
outgoing_links(e,r)
latencyIn1(v)
latencyIn2(v)
latencyIn3(v)
latencyIn4(v)
latency(e,v)
latency2(e,v)
throughput(l)
throughput2(n)
Trips(n)
Trips2(e,l,l2)
calc_l_used(l)
*onlyOneVperL(l)
minimizing_throughput;

scalar BIGM /1000/;
binary variable Mvl(l);

calc_l_used(l).. sum(e$(kindE('Mutex',e)),Ml(e,l)) - BIGM*Mvl(l) =l= 0;
*onlyOneVperL(l)..  sum(e$kindE('Mutex',e),Mvl(l)) =l= 1;





latencyIn1(v)$kindV('In1',v).. Tv(v) =e= 4;
latencyIn2(v)$kindV('In2',v).. Tv(v) =e= 5;
latencyIn3(v)$kindV('In3',v).. Tv(v) =e= 6;
latencyIn4(v)$kindV('In4',v).. Tv(v) =e= 7;
latency(e,v)$Gve(v,e)..         Te(e) =e= Tv(v) + delta(e) + sum(
					    l$kindL('rrL',l), Ml(e,l));
latency2(e,v)$Gev(e,v)..        Tv(v) =g= Te(e); 

*throughput(l)$kindL('rrL',l)..   sum(e,Ml(e,l)) =l= S;
throughput(l)$kindL('rrL',l)..  sum(e$(NOT kindE('Mutex',e)),Ml(e,l)) + Mvl(l) =l= S;
throughput2(n)$kindN('Comp',n).. sum(v, Mn(v,n) * delays(v)) =l= S;

Trips(n)$kindN('Comp',n)..      sum(v$(kindV('Comp',v)), Mn(v, n)) =l= 8;
Trips2(e,l,l2)$F(l,l2)..        Ml(e,l) + Ml(e,l2) =l= 1;


source_mapping(e,n)..           sum(l$Hnl(n,l),Ml(e,l)) =e= sum(v$Gve(v,e), Mn(v,n));
dest_mapping(e,n)..             sum(l$Hln(l,n),Ml(e,l)) =e= sum(v$Gev(e,v), Mn(v,n));
incoming_links(e,r)..           sum(l$Hlr(l,r),Ml(e,l)) =e= sum(l$Hrl(r,l), Ml(e,l));
outgoing_links(e,r)..           sum(l$Hlr(l,r),Ml(e,l)) =l= 1;
only1(K,v)$kindV(K,v)..         sum(n$(kindN(K,n)), Mn(v, n)) =e= 1;
noOthers(v)..                   sum(n,Mn(v, n)) =e= 1;
*add(v)$kind2V('Critical',v)..   length =g= Tv(v);
add..   length =e= sum(v$(kind2V('Critical',v)),Tv(v));
minimizing_throughput..         cost =e= length + S;



Model   solution    "the solution for this model" / all /;
solution.optCA=0.999;
solution.optCR=0; 
solution.optfile=1;
solution.holdFixed=1;
solve   solution    using mip minimizing cost;


