$OnEmpty
Set v "Vertices" 
    /v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10/;
Set e "Codeblock Edges" 
    /e0*e31/;
Set mux "Mutually Exclusive Edge Groups" 
    /mu1, mu2, mu3, mu4, mu5, mu6, mu7/;
Set mul "Multicast Edge Groups" 
    /mul1, mul2/;
Parameter Gev(e,v) "Edge-Vertice Connection" 
    /e0.v1 1, e1.v1 1, e2.v1 1, e3.v2 1, e4.v2 1, e5.v2 1, e6.v3 1, e7.v3 1, e8.v3 1, e9.v4 1, e10.v4 1, e11.v5 1, e12.v5 1, e13.v5 1, e14.v6 1, e15.v6 1, e16.v7 1, e17.v7 1, e18.v7 1, e19.v7 1, e20.v8 1, e21.v8 1, e22.v8 1, e23.v8 1, e24.v9 1, e25.v9 1, e26.v9 1, e27.v9 1, e28.v9 1, e29.v9 1, e30.v10 1, e31.v10 1/;
Parameter Gve(v,e) "Vertice-Edge Connection" 
    /v0.e0 1, v0.e1 1, v0.e2 1, v1.e3 1, v1.e4 1, v1.e5 1, v0.e6 1, v0.e7 1, v0.e8 1, v3.e9 1, v3.e10 1, v0.e11 1, v0.e12 1, v0.e13 1, v5.e14 1, v5.e15 1, v3.e16 1, v3.e17 1, v4.e18 1, v4.e19 1, v5.e20 1, v5.e21 1, v6.e22 1, v6.e23 1, v1.e24 1, v2.e25 1, v7.e26 1, v7.e27 1, v8.e28 1, v8.e29 1, v9.e30 1, v9.e31 1/;
Set inV(v) "Input vertices" 
    /v0/;
Set outV(v) "Output vertices" 
    /v10/;
Set compV(v) "Comp vertices" 
    /v1, v2, v3, v4, v5, v6, v7, v8, v9/;
Set critV(v) "Nodes critical to achieving latency constraints" 
    /v10/;
Set muxE(mux,e) "Mutually exclusive edge mapping" 
    /mu1.e16, mu1.e18, mu2.e20, mu2.e22, mu3.e24, mu3.e25, mu4.e17, mu4.e19, mu5.e21, mu5.e23, mu6.e26, mu6.e28, mu7.e27, mu7.e29/;
Set mulE(mul,e) "Multicast edge bundles" 
    /mul1.e6, mul1.e11, mul2.e7, mul2.e12/;
Set mutexE(e) "Mutually exclusive edges themselves" 
    /e16, e18, e20, e22, e24, e25, e17, e19, e21, e23, e26, e28, e27, e29/;
Set multiE(e) "Multicast edges themselves" 
    /e6, e11, e7, e12/;
Parameter delta(e) 
    /e0 0, e1 4, e2 8, e3 22, e4 28, e5 34, e6 12, e7 16, e8 20, e9 26, e10 32, e11 12, e12 16, e13 20, e14 26, e15 32, e16 33, e17 37, e18 28, e19 34, e20 33, e21 37, e22 28, e23 34, e24 38, e25 23, e26 8, e27 14, e28 8, e29 14, e30 6, e31 12/;
Set kindV(K,v);
kindV('In',inV) = YES;
kindV('Out',outV) = YES;
kindV('Comp',compV) = YES;
Set kind2V(K2,v);
kind2V('Critical',critV) = YES;
Set kindE(K,e);
kindE('Mutex',mutexE) = YES;
kindE('Multi',multiE) = YES;
Positive variable Tv(v), Te(e), S, length; 
