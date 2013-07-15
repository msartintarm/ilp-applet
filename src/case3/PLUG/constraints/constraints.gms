
Variable            optimal;
binary variable     Mxvl(mux,l), Mml(mul,l);
S.up                = 18;
Tv.up(v)            = 1000;
Te.up(e)            = 1000;
length.up	    = 1000;
Equations
*		only1(K,v)
*		noOthers(K,v)
*		add(v)
*		source_mapping(e,n)
*		dest_mapping(e,n)
*		incoming_links(e,r)
*		outgoing_links(e,r)
		p1_mutex_flag(mux,l)
		p2_multi_flag(mul,l)
		p3_multicast(mul,l,r,l2,n)
		p4_throughput(l)
		p5_dimension_routing(e,l,l2)
		p6_timing(v1,e,v2)
*		p6_latency(e,v)
*		p7_latency2(e,v);

scalar BIGM /1000/;
Tv.fx(v)$kindV('In',v)=0;
Wn.up(n)$kindN('Comp',n)=1;
p1_mutex_flag(mux,l).. sum(e$(muxE(mux,e)),Mel(e,l)) - BIGM*Mxvl(mux,l) =l= 0;
p2_multi_flag(mul,l).. sum(e$(mulE(mul,e)),Mel(e,l)) - BIGM*Mml(mul,l) =l= 0;
p3_multicast(mul,l,r,l2,n)$(Hlr(l,r) AND Hrl(r,l2) AND Hln(l2,n)).. 
				Mml(mul,l) =l= Mml(mul,l2);
p4_throughput(l)..  sum(e$(NOT(kindE('Mutex',e) OR kindE('Multi',e))),Mel(e,l)) 
		 + sum(mux,Mxvl(mux,l)) + sum(mul,Mml(mul,l)) =l= S;
p5_dimension_routing(e,l,l2)$F(l,l2)..        Mel(e,l) + Mel(e,l2) =l= 1;
*c6

* Conforms to 'c6_timing', but only certain links in TRIPS need consideration
p6_timing(v1,e,v2)$(Gve(v1,e) and Gev(e,v2))..
    Tv(v2) =e= Tv(v1) + sum(l$kindL('rrL',l),Mel(e,l)) + delta(e) + extra(e);
*p6_latency(e,v)$Gve(v,e)..         Te(e) =e= Tv(v) + delta(e) + sum(
*					    l$kindL('rrL',l), Mel(e,l));
*p7_latency2(e,v)$Gev(e,v)..        Tv(v) =g= Te(e); 

*only1(K,v)$kindV(K,v)..         sum(n$(kindN(K,n)), Mn(v, n)) =e= 1;
*noOthers(K,v)$kindV(K,v)..	sum(n$(NOT kindN(K,n)), Mn(v,n)) =e= 0;
*source_mapping(e,n)..           sum(l$Hnl(n,l),Ml(e,l)) =e= sum(v$Gve(v,e), Mn(v,n));
*dest_mapping(e,n)..             sum(l$Hln(l,n),Ml(e,l)) =e= sum(v$Gev(e,v), Mn(v,n));
*incoming_links(e,r)..           sum(l$Hlr(l,r),Ml(e,l)) =e= sum(l$Hrl(r,l), Ml(e,l));
*outgoing_links(e,r)..           sum(l$Hlr(l,r),Ml(e,l)) =l= 1;
*add(v)$kind2V('Critical',v)..   LAT =g= Tv(v);
*Plug(n)$kindN('Comp',n)..      sum(v$(kindV('Comp',v)), Mn(v, n)) =l= 1;


Model   solution    "the solution for this model" /
    c1_map_all_v,
    c2_map_valid,
    c3_map_edge_src,
    c4_map_edge_dst,
    c5_router_fwd,
	c7_max_cycle
	c8_work_effort
	c10_unique_router_source,
	p1_mutex_flag,
	p2_multi_flag,
	p3_multicast,
	p4_throughput,
	p5_dimension_routing,
	p6_timing/;

solution.optCA=0.999;
solution.optCR=0.05;
solution.optfile=1;
solution.holdFixed=1;
option savepoint=1;
solve   solution    using mip minimizing LAT;


