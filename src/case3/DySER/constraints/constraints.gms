option reslim=300;
option optcr=0.05;
option optca=.999;

positive variable maxExtra;

Mvn.l('N19','Fu00')=1;
Mvn.l('N20','Fu01')=1;
Mvn.l('N21','Fu02')=1;
Mvn.l('N23','Fu03')=1;
Mvn.l('N25','Fu10')=1;
Mvn.l('N27','Fu11')=1;
Mvn.l('N24','Fu12')=1;
Mvn.l('N26','Fu13')=1;
Mvn.l('N17','Fu20')=1;
Mvn.l('N31','Fu21')=1;
Mvn.l('N28','Fu22')=1;
Mvn.l('N30','Fu23')=1;
Mvn.l('N18','Fu30')=1;
Mvn.l('N22','Fu31')=1;
Mvn.l('N29','Fu32')=1;
Mvn.l('I9','I0')=1;
Mvn.l('I7','I2')=1;
Mvn.l('I12','I3')=1;
Mvn.l('I4','I4')=1;
Mvn.l('I10','I5')=1;
Mvn.l('I3','I6')=1;
Mvn.l('I5','I7')=1;
Mvn.l('I8','I8')=1;
Mvn.l('I13','I14')=1;
Mvn.l('I11','I16')=1;
Mvn.l('I15','I17')=1;
Mvn.l('I14','I18')=1;
Mvn.l('I0','I26')=1;
Mvn.l('I6','I28')=1;
Mvn.l('I1','I36')=1;
Mvn.l('I2','I38')=1;
Mvn.l('O16','O42')=1;
Mvl.l('I8','Sw00_Fu00')=1;
Mvl.l('I3','Sw01_Fu00')=1;
Mvl.l('N19','Fu00_Sw11')=1;
Mvl.l('I5','Sw01_Fu01')=1;
Mvl.l('I4','Sw02_Fu01')=1;
Mvl.l('N20','Fu01_Sw12')=1;
Mvl.l('I10','Sw02_Fu02')=1;
Mvl.l('I7','Sw03_Fu02')=1;
Mvl.l('N21','Fu02_Sw13')=1;
Mvl.l('I12','Sw03_Fu03')=1;
Mvl.l('I9','Sw04_Fu03')=1;
Mvl.l('N23','Fu03_Sw14')=1;
Mvl.l('I14','Sw10_Fu10')=1;
Mvl.l('I11','Sw11_Fu10')=1;
Mvl.l('N25','Fu10_Sw21')=1;
Mvl.l('I15','Sw11_Fu11')=1;
Mvl.l('I13','Sw12_Fu11')=1;
Mvl.l('N27','Fu11_Sw22')=1;
Mvl.l('N19','Sw12_Fu12')=1;
Mvl.l('N20','Sw22_Fu12')=1;
Mvl.l('N24','Fu12_Sw23')=1;
Mvl.l('N21','Sw13_Fu13')=1;
Mvl.l('N25','Sw23_Fu13')=1;
Mvl.l('N26','Fu13_Sw24')=1;
Mvl.l('I6','Sw20_Fu20')=1;
Mvl.l('I0','Sw21_Fu20')=1;
Mvl.l('N17','Fu20_Sw31')=1;
Mvl.l('N28','Sw32_Fu21')=1;
Mvl.l('N24','Sw22_Fu21')=1;
Mvl.l('N31','Fu21_Sw32')=1;
Mvl.l('N27','Sw22_Fu22')=1;
Mvl.l('N23','Sw23_Fu22')=1;
Mvl.l('N28','Fu22_Sw33')=1;
Mvl.l('N22','Sw33_Fu23')=1;
Mvl.l('N26','Sw24_Fu23')=1;
Mvl.l('N30','Fu23_Sw34')=1;
Mvl.l('I2','Sw30_Fu30')=1;
Mvl.l('I9','I0_Sw04')=1;
Mvl.l('I1','Sw31_Fu30')=1;
Mvl.l('N18','Fu30_Sw41')=1;
Mvl.l('N17','Sw31_Fu31')=1;
Mvl.l('N18','Sw41_Fu31')=1;
Mvl.l('N22','Fu31_Sw42')=1;
Mvl.l('N31','Sw32_Fu32')=1;
Mvl.l('N30','Sw33_Fu32')=1;
Mvl.l('N29','Fu32_Sw43')=1;
Mvl.l('I7','I2_Sw03')=1;
Mvl.l('N19','Sw11_Sw12')=1;
Mvl.l('N20','Sw12_Sw22')=1;
Mvl.l('N24','Sw23_Sw22')=1;
Mvl.l('N23','Sw13_Sw23')=1;
Mvl.l('N23','Sw14_Sw13')=1;
Mvl.l('N25','Sw21_Sw22')=1;
Mvl.l('N25','Sw22_Sw23')=1;
Mvl.l('N28','Sw33_Sw32')=1;
Mvl.l('N22','Sw32_Sw33')=1;
Mvl.l('N30','Sw34_Sw33')=1;
Mvl.l('N22','Sw42_Sw32')=1;
Mvl.l('I12','I3_Sw03')=1;
Mvl.l('I4','I4_Sw02')=1;
Mvl.l('I10','I5_Sw02')=1;
Mvl.l('I3','I6_Sw01')=1;
Mvl.l('I5','I7_Sw01')=1;
Mvl.l('I8','I8_Sw00')=1;
Mvl.l('I13','I14_Sw12')=1;
Mvl.l('I11','I16_Sw11')=1;
Mvl.l('I15','I17_Sw11')=1;
Mvl.l('I14','I18_Sw10')=1;
Mvl.l('I0','I26_Sw21')=1;
Mvl.l('I6','I28_Sw20')=1;
Mvl.l('I1','I36_Sw31')=1;
Mvl.l('I2','I38_Sw30')=1;
Mvl.l('N29','Sw43_O42')=1;
Mel.l('I8_N19i7','Sw00_Fu00')=1;
Mel.l('I3_N19i2','Sw01_Fu00')=1;
Mel.l('N19_N24i18','Fu00_Sw11')=1;
Mel.l('I5_N20i0','Sw01_Fu01')=1;
Mel.l('I4_N20i1','Sw02_Fu01')=1;
Mel.l('N20_N24i19','Fu01_Sw12')=1;
Mel.l('I10_N21i12','Sw02_Fu02')=1;
Mel.l('I7_N21i9','Sw03_Fu02')=1;
Mel.l('N21_N26i20','Fu02_Sw13')=1;
Mel.l('I12_N23i10','Sw03_Fu03')=1;
Mel.l('I9_N23i6','Sw04_Fu03')=1;
Mel.l('N23_N28i22','Fu03_Sw14')=1;
Mel.l('I14_N25i15','Sw10_Fu10')=1;
Mel.l('I11_N25i13','Sw11_Fu10')=1;
Mel.l('N25_N26i24','Fu10_Sw21')=1;
Mel.l('I15_N27i14','Sw11_Fu11')=1;
Mel.l('I13_N27i11','Sw12_Fu11')=1;
Mel.l('N27_N28i26','Fu11_Sw22')=1;
Mel.l('N19_N24i18','Sw12_Fu12')=1;
Mel.l('N20_N24i19','Sw22_Fu12')=1;
Mel.l('N24_N31i23','Fu12_Sw23')=1;
Mel.l('N21_N26i20','Sw13_Fu13')=1;
Mel.l('N25_N26i24','Sw23_Fu13')=1;
Mel.l('N26_N30i25','Fu13_Sw24')=1;
Mel.l('I6_N17i8','Sw20_Fu20')=1;
Mel.l('I0_N17i5','Sw21_Fu20')=1;
Mel.l('N17_N22i16','Fu20_Sw31')=1;
Mel.l('N28_N31i27','Sw32_Fu21')=1;
Mel.l('N24_N31i23','Sw22_Fu21')=1;
Mel.l('N31_N29i30','Fu21_Sw32')=1;
Mel.l('N27_N28i26','Sw22_Fu22')=1;
Mel.l('N23_N28i22','Sw23_Fu22')=1;
Mel.l('N28_N31i27','Fu22_Sw33')=1;
Mel.l('N22_N30i21','Sw33_Fu23')=1;
Mel.l('N26_N30i25','Sw24_Fu23')=1;
Mel.l('N30_N29i29','Fu23_Sw34')=1;
Mel.l('I2_N18i3','Sw30_Fu30')=1;
Mel.l('I9_N23i6','I0_Sw04')=1;
Mel.l('I1_N18i4','Sw31_Fu30')=1;
Mel.l('N18_N22i17','Fu30_Sw41')=1;
Mel.l('N17_N22i16','Sw31_Fu31')=1;
Mel.l('N18_N22i17','Sw41_Fu31')=1;
Mel.l('N22_N30i21','Fu31_Sw42')=1;
Mel.l('N31_N29i30','Sw32_Fu32')=1;
Mel.l('N30_N29i29','Sw33_Fu32')=1;
Mel.l('N29_O16i28','Fu32_Sw43')=1;
Mel.l('I7_N21i9','I2_Sw03')=1;
Mel.l('N19_N24i18','Sw11_Sw12')=1;
Mel.l('N20_N24i19','Sw12_Sw22')=1;
Mel.l('N24_N31i23','Sw23_Sw22')=1;
Mel.l('N23_N28i22','Sw13_Sw23')=1;
Mel.l('N23_N28i22','Sw14_Sw13')=1;
Mel.l('N25_N26i24','Sw21_Sw22')=1;
Mel.l('N25_N26i24','Sw22_Sw23')=1;
Mel.l('N28_N31i27','Sw33_Sw32')=1;
Mel.l('N22_N30i21','Sw32_Sw33')=1;
Mel.l('N30_N29i29','Sw34_Sw33')=1;
Mel.l('N22_N30i21','Sw42_Sw32')=1;
Mel.l('I12_N23i10','I3_Sw03')=1;
Mel.l('I4_N20i1','I4_Sw02')=1;
Mel.l('I10_N21i12','I5_Sw02')=1;
Mel.l('I3_N19i2','I6_Sw01')=1;
Mel.l('I5_N20i0','I7_Sw01')=1;
Mel.l('I8_N19i7','I8_Sw00')=1;
Mel.l('I13_N27i11','I14_Sw12')=1;
Mel.l('I11_N25i13','I16_Sw11')=1;
Mel.l('I15_N27i14','I17_Sw11')=1;
Mel.l('I14_N25i15','I18_Sw10')=1;
Mel.l('I0_N17i5','I26_Sw21')=1;
Mel.l('I6_N17i8','I28_Sw20')=1;
Mel.l('I1_N18i4','I36_Sw31')=1;
Mel.l('I2_N18i3','I38_Sw30')=1;
Mel.l('N29_O16i28','Sw43_O42')=1;
Tv.l(v)=0;
Tv.l('I0')=0;
Tv.l('I1')=0;
Tv.l('I2')=0;
Tv.l('I3')=0;
Tv.l('I4')=0;
Tv.l('I5')=0;
Tv.l('I6')=0;
Tv.l('I7')=0;
Tv.l('I8')=0;
Tv.l('I9')=0;
Tv.l('I10')=0;
Tv.l('I11')=0;
Tv.l('I12')=0;
Tv.l('I13')=0;
Tv.l('I14')=0;
Tv.l('I15')=0;
Tv.l('N17')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N17')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N18')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N18')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N19')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N19')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N20')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N20')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N21')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N21')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N23')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N23')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N25')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N25')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N27')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N27')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N22')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N22')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N24')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N24')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N26')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N26')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N28')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N28')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N30')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N30')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N31')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N31')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
Tv.l('N29')=smax((v1,e)$(Gve(v1,e) and Gev(e,'N29')),Tv.l(v1)+ sum(l,Mel.l(e,l)) + delta(e));
LAT.l=smax(v,Tv.l(v));
cost.l = 1000000* sum((iv,k)$kindV(K,iv),(1-sum(n$(kindN(K,n)), Mvn.l(iv, n)))) +  1000 * LAT.l + sum(l,sum(v,Mvl.l(v,l)));
display Tv.l;
display LAT.l;
display cost.l;

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
