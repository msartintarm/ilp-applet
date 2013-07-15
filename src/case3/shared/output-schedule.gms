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