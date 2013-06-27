Set K "Kinds of Node or Vertice" /IN, OUT, ADD, SUB, MULT, DIV/;
* Software Vertices / Edges
Set v "Vertices"   /v1, v2, v3, v4, v5, v6/;
Set e "Edges"      /e1, e2, e3, e4, e5/;

* Vertice / Edge Connections
Parameter Gve(v,e)       /v1.e1 1, v2.e2 1, v3.e3 1, v4.e4 1, v5.e5 1/;
Parameter Gev(e,v)       /e1.v4 1, e2.v4 1, e3.v5 1, e4.v5 1, e5.v6 1/;

* Delta for non-specified edges (e1 - e3) is 0
parameter delta(e) /e4 1, e5 3/;

* Kinds of Vertices
Set KindV(K,v)     /IN.v1, IN.v2, IN.v3, MULT.v4, DIV.v5, OUT.v6/;
* Hardware Nodes / Links
Set n "Nodes"   /n1 * n8/;
Set r "Routers" /r1 * r4/;
Set l "Links"   /l1 * l20/;

* Node Connections
Set Hnl(n,l) /n1.l1, n2.l3, n3.l5, n5.l13, n7.l18, n8.l20/;
Set Hln(l,n) /l2.n1, l4.n2, l7.n4, l15.n6, l17.n7, l19.n8/;

* Router Connections
Set Hrl(r,l) /r1.l2, r1.l6, r1.l9, 
    	      r2.l4, r2.l7, r2.l8, r2.l11,
	      r3.l10, r3.l14, r3.l17,
	      r4.l12, r4.l15, r4.l16, r4.l18/;
Set Hlr(l,r) /l1.r1, l5.r1, l8.r1, l10.r1,
    	      l3.r2, l8.r2, l12.r2,
	      l9.r3, l13.r3, l16.r3, l18.r3,
	      l11.r4, l14.r4, l20.r4/;

* Kinds of Operational Nodes
Set kindN(K,n)  /IN.n3, IN.n5, MULT.n1, ADD.n2, SUB.n2, 
     	         ADD.n7, SUB.n7, DIV.n8, OUT.n4, OUT.n6/;
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
c23_link_throughput(l)..                sum(v,Mvl(v,l)) =l= 1;model problem1 "Incorporates basic constraints"
      /c1_map_all_v, 
	   c2_map_valid, 
	   c3_map_edge_src,
	   c4_map_edge_dst,
	   c5_router_fwd,
	   c6_timing,
	   c7_max_cycle,
	   c8_work_effort,
	   c9_calc_svc/;
solve problem1 using mip minimizing SVC;

Equation objective "Service Interval Constraint";
objective.. SVC =e= SVC.l;	
model problem2 "Constrains service interval to <= 1"
      /c1_map_all_v, 
	   c2_map_valid, 
	   c3_map_edge_src,
	   c4_map_edge_dst,
	   c5_router_fwd,
	   c6_timing,
	   c7_max_cycle,
	   c8_work_effort,
	   c9_calc_svc,
	   objective/;
solve problem2 using mip minimizing LAT;


file outfile / "solution.lst" /;
outfile.pc=8;
outfile.pw=4096;
put outfile;

put "Vertex : Node  Mapping" /
loop(v,
    put v.tl ":";
    loop((n)$(Mvn.l(v,n)<>0),
        put n.tl
    );
    put /
);

put / "Edge : Link  Mapping" /
loop(e,
    put e.tl ":"
    loop((l)$(Mel.l(e,l)<>0),
        put l.tl
    );
    put /
);