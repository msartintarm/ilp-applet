
Variable            optimal;

*S.up                = 100;
*Tv.up(v)            = 300;
*Te.up(e)            = 300;
*LAT.up        = 5000;

* Input latency for TRIPS is static 
Tv.fx(v)$kindV('In1',v)=4;
Tv.fx(v)$kindV('In2',v)=5;
Tv.fx(v)$kindV('In3',v)=6;
Tv.fx(v)$kindV('In4',v)=7;

Equations
    t1_timing(v1,e,v2)
    t2_max_cycle
    t3_throughput_1(l)
    t3_throughput_2(n)
    t4_calc_mxl(l)
    t5_limit_maxv(n)
    t6_dim_order_route(e,l,l2);


scalar BIGM /1000/;
binary variable Mxl(l);

* Conforms to 'c6_timing', but only certain links in TRIPS need consideration
t1_timing(v1,e,v2)$(Gve(v1,e) and Gev(e,v2))..
    Tv(v2) =e= Tv(v1) + sum(l$kindL('rrL',l),Mel(e,l)) + delta(e) + extra(e);

* Conforms to 'c7_max_cycle', but only nodes designated as critical
*  need consideration (this considerably decreases solver time)
t2_max_cycle..   LAT =e= sum(v$(kind2V('Critical',v)),Tv(v));

*throughput(l)$kindL('rrL',l)..   sum(e,Mel(e,l)) =l= S;
t3_throughput_1(l)$kindL('rrL',l)..  sum(e$(NOT kindE('Mutex',e)),Mel(e,l)) + Mxl(l) =l= S;
t3_throughput_2(n)$kindN('Comp',n).. sum(v, Mvn(v,n) * delays(v)) =l= S;

t4_calc_mxl(l).. sum(e$(kindE('Mutex',e)),Mel(e,l)) - BIGM*Mxl(l) =l= 0;

t5_limit_maxv(n)$kindN('Comp',n)..      sum(v$(kindV('Comp',v)), Mvn(v, n)) =l= 8;
t6_dim_order_route(e,l,l2)$F(l,l2)..        Mel(e,l) + Mel(e,l2) =l= 1;

*Minimizes Throughput & Latency
objective..        optimal =e= LAT + S;

*Minimizes Latency (use this if software graph is large)
*objective..       optimal =e= LAT;

Model solution /c1_map_all_v, c2_map_valid, c3_map_edge_src, c4_map_edge_dst,
                c5_router_fwd, c10_unique_router_source, objective,
                t1_timing, t2_max_cycle, t3_throughput_1, 
                t3_throughput_2, t4_calc_mxl,t5_limit_maxv,t6_dim_order_route/;

solution.optCA=0.999;
solution.optCR=0;
solution.optfile=1;
solution.holdFixed=1;

solve solution using mip minimizing optimal;