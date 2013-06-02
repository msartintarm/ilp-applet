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
