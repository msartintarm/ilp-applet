model problem1 "Incorporates basic constraints"
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


