
$batinclude tripsCFG.gams
$batinclude tripsDFG.gams
$batinclude constraints.gams

option Mn:0:0:1;
display Mn.l;
option Ml:0:0:1;
display Ml.l;


file outfile / "solution.lst" /;
outfile.pc=8;
put outfile;
put solution.etSolve;
put solution.numEqu;
put solution.numVar;
put "# Nodes -> Vertices" /
*loop((v,n)$(Mn.l(v,n)<>0), put v.tl"."n.tl/); 
loop((n),
    put n.tl ":";
    loop((v)$(Mn.l(v,n)<>0),
        put v.tl 
    );
    put /
);

put "# Edges -> Links" /
loop((l), 
    put l.tl ":"
    loop((e)$(Ml.l(e,l)<>0),
        put e.tl
    );
    put /
);
file solve_time / "solve_time.lst" /;
solve_time.pc=8;
put solve_time;
put solution.etSolve;
file solve_equ / "solve_equ.lst" /;
solve_equ.pc=8;
put solve_equ;
put solution.numEqu;
file solve_var / "solve_var.lst" /;
solve_var.pc=8;
put solve_var;
put solution.numVar;
