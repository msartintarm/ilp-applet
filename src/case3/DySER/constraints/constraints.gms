option reslim=300;
option optcr=0.05;
option optca=.999;

positive variable maxExtra;

$batinclude cplex_options.gms
$batinclude mip_start.gms


alias (v1,v2,v);

Equations d1_unique_router_source_vertex(v,r), d2_lat_mismatch(e);

Mvn.prior(v,n)=0;
Mvn.prior(v,n)$(kindV('Input',v) or kindN('Input',n))=5;
Mel.prior(e,l)=10;
Mvl.prior(v,l)=100;

* Set not-possible variables to 0
loop(K,
Mvn.fx(v,n)$(kindV(K,v) and not kindN(K,n))=0;);

Tv.fx(v)$kindV('Input',v)=0;


*This subsumes unique_router_source, but having both improves performance
d1_unique_router_source_vertex(v,r)..
  sum(l$Hlr(l,r),Mvl(v,l)) =l= 1;  
d2_lat_mismatch(e).. 
  maxExtra =g= extra(e);
  
* Fils in the cost to be consistent with the mipstart
cost.l = 1000000* sum((iv,k)$kindV(K,iv),(1-sum(n$(kindN(K,n)), Mvn.l(iv, n)))) +  1000 * LAT.l + sum(l,sum(v,Mvl.l(v,l)));

objective.. cost =e= LAT;

Model schedule /c1_map_all_v, c2_map_valid, c3_map_edge_src, c4_map_edge_dst,
                c5_router_fwd, c6_timing, c7_max_cycle, c10_unique_router_source,
                c21_bundle_edges, c22_bundle_edges_alt, c23_link_throughput,
                d1_unique_router_source_vertex, d2_lat_mismatch, objective/;

schedule.optfile=1;
schedule.prioropt=1;
schedule.threads=32;
schedule.reslim=300;
schedule.holdFixed=1;

solve schedule using mip minimizing cost;

* This turns on latency mismatch equalization, but is commented out for now

*LAT.fx=LAT.l;
*O.up(l)=CARD(L);
*O.l(l)=0;

*variable cost2;
*equation obj2, c24_block_cycles(l,l,e);
*c24_block_cycles(l1,l2,e)$Hll(l1,l2).. O(l1) + Mel(e,l1) + Mel(e,l2) -1 =l= O(l2);

*cost2.l = maxExtra.l;
*obj2.. cost2 =e= maxExtra;

*Model   schedule2  / all /;

*schedule2.optfile=1;
*schedule2.prioropt=1;
*schedule2.threads=32;
*schedule2.reslim=60;
*schedule2.optCA=0.999;

*solve   schedule2    using mip minimizing cost2;
