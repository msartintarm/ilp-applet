alias(v,v1,v2);

* HW / SW node latency
Parameter Sdelta(v);
Parameter Hdelta(v);

Sdelta(v)=1;
Hdelta(v)=0;

* Problem Definition
Scalar MAXin /100/;
Scalar MAXout /100/;

* Register File Cost
Scalar RFCin /0/;
Scalar RFCout /0/;

* free operands / instruction
Scalar PORTin /2/;
Scalar PORTout /1/;

integer variable INSTin, INSTout;
integer variable DTin, DTout;
integer variable C;

INSTin.up = MAXin;
INSTout.up = MAXout;

binary variable T(v);
T.fx(v)$(I(v))=0;
T.fx(v)$(not Okay(v))=0;


*Formulating for Template Inputs
binary variable someSuccInT(v);
binary variable isIn(v);

Equations det_succ(v1,v2), lim_succ(v),  calc_in;
Equations det_in1(v), det_in2(v), det_in3(v);

det_succ(v1,v2)$(Gvv(v1,v2)).. someSuccInT(v1) =g= T(v2);
lim_succ(v1)..                someSuccInT(v1) =l= sum(v2$(Gvv(v1,v2)),T(v2));

det_in1(v).. isIn(v) =l= 1-T(v);
det_in2(v).. isIn(v) =l= someSuccInT(v);
det_in3(v).. isIn(v) =g= -T(v)+someSuccInT(v);

Equations is_input(v1,v2);
is_input(v1,v2)$(Gvv(v1,v2)).. isIn(v1) =g= T(v2)-T(v1);

calc_in.. INSTin =e= sum(v,isIn(v));


*Formulating for Template Outputs
binary variable someSuccNotInT(v);
binary variable isOut(v);

Equations det_not_succ(v1,v2), lim_not_succ(v),  calc_out;
Equations det_out1(v), det_out2(v), det_out3(v);

det_not_succ(v1,v2)$(Gvv(v1,v2)).. someSuccNotInT(v1) =g= 1-T(v2);
lim_not_succ(v1)..                someSuccNotInT(v1) =l= sum(v2$(Gvv(v1,v2)),1-T(v2));

det_out1(v).. isOut(v) =l= T(v);
det_out2(v).. isOut(v) =l= someSuccNotInT(v);
det_out3(v).. isOut(v) =g= T(v)+someSuccNotInT(v)-1;

Equations is_output(v1,v2);
is_output(v1,v2)$(Gvv(v1,v2)).. isOut(v1) =g= T(v1) - T(v2);

calc_out.. INSTout =e= sum(v$O(v), T(v)) + sum(v$(not O(v)),  isOut(v));

* Data Transfer Cost

Equations inDT, outDT, costDT;

inDT.. DTin =g= INSTin / PORTin - 1;
outDT.. DTout =g= INSTout / PORTout - 1;
costDT.. C =e= DTin * RFCin + DTout*RFCout;


*Formulating Convexity
binary variable ancestorT(v);
binary variable descendantT(v);

Equations an1(v,v),an2(v,v),an3(v);
Equations de1(v,v),de2(v,v),de3(v);
Equations convexity(v);

an1(v1,v2)$(Gvv(v1,v2)).. ancestorT(v2) =g= T(v1);
an2(v1,v2)$(Gvv(v1,v2)).. ancestorT(v2) =g= ancestorT(v1);
an3(v2).. ancestorT(v2) =l= sum(v1$(Gvv(v1,v2)),T(v1)+ancestorT(v1));

de1(v1,v2)$(Gvv(v1,v2)).. descendantT(v1) =g= T(v2);
de2(v1,v2)$(Gvv(v1,v2)).. descendantT(v1) =g= descendantT(v2);
de3(v1).. descendantT(v1) =l= sum(v2$(Gvv(v1,v2)),T(v2)+descendantT(v2));

convexity(v).. ancestorT(v) + descendantT(v) - T(v) =l= 1;

variable reduction;
positive variable S,Time(v);
integer variable H;
Equations calc_timing(v1,v2), calc_hard, calc_soft(v), calc_reduct;

calc_timing(v1,v2)$Gvv(v1,v2).. Time(v2) =g= Time(v1)+T(v2)*Hdelta(v2);
calc_hard..                            S =e= sum(v,Sdelta(v)*T(v));
calc_soft(v)..                         H =g= Time(v);
calc_reduct.. reduction =e= S-H-C;


*option limrow = 100;
option optca = 0.05;
option optcr = 0;

Model partition 
/is_input, calc_in,
is_output, calc_out,
*/det_succ,  lim_succ, calc_in, det_in1, det_in2, det_in3, 
*det_not_succ,  lim_not_succ, calc_out, det_out1, det_out2, det_out3,
an1,an2,an3,de1,de2,de3, convexity, 
inDT, outDT, costDT,
calc_timing, calc_hard, calc_soft, calc_reduct/;

file stdout / "/dev/stdout" /;
stdout.pc=8;
stdout.pw=4096;
put stdout;

solve partition using MIP maximizing reduction;

put partition.objVal partition.objEst;
put partition.numVar partition.numDVar partition.numEqu partition.numNZ;
put partition.etSolve partition.etSolver/;

display I;
display O;
display T.l;
