Equations 
  c1_map_all_v(K,v), c2_map_valid(K,v), c3_map_edge_src(v,e,n), c4_map_edge_dst(e,v,n)
  c5_router_fwd(e,r), c6_timing(v,e,v), c7_max_cycle(v), c8_work_effort(n),
  c9_calc_svc(n), c10_unique_router_source(e,r),
  c21_bundle_edges(v,e,l), c22_bundle_edges_alt(v,l), c23_link_throughput(l)
  objective;
    
c1_map_all_v(K,v)$kindV(K,v)..          sum(n$(kindN(K,n)),     Mvn(v,n)) =e= 1;
c2_map_valid(K,v)$kindV(K,v)..          sum(n$(not kindN(K,n)), Mvn(v,n)) =e= 0;
c3_map_edge_src(v,e,n)$Gve(v,e)..       Mvn(v,n) =e= sum(l$Hnl(n,l), Mel(e,l));
c4_map_edge_dst(e,v,n)$(Gev(e,v))..     Mvn(v,n) =e= sum(l$Hln(l,n), Mel(e,l));
c5_router_fwd(e,r).. sum(l$Hlr(l,r),Mel(e,l)) =e= sum(l$Hrl(r,l), Mel(e,l));
c6_timing(v1,e,v2)$(Gve(v1,e) and Gev(e,v2))..
    Tv(v2) =e= Tv(v1) + sum(l,Mel(e,l)) + delta(e) + extra(e);
c7_max_cycle(v)$(sum(e,Gve(v,e))=0).. LAT =g= Tv(v);
c8_work_effort(n).. sum(v, Mvn(v,n)) =e= Wn(n);
c9_calc_svc(n).. SVC =g= Wn(n);



c10_unique_router_source(e,r).. sum(l$Hlr(l,r),Mel(e,l)) =l= 1;

c21_bundle_edges(v,e,l)$(Gve(v,e))..    Mel(e,l) =l= Mvl(v,l);
c22_bundle_edges_alt(v,l)..             sum(e$(Gve(v,e)),Mel(e,l)) =g= Mvl(v,l);
c23_link_throughput(l)..                sum(v,Mvl(v,l)) =l= 1;