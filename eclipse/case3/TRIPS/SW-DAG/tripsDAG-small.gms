$OnEmpty
Set v "Vertices" 
    /v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, br25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39/;
Set e "Instruction Edges" 
    /e0*e36/;
Set inV1(v) "Input vertices" 
    //;
Set inV2(v) "Input vertices" 
    //;
Set inV3(v) "Input vertices" 
    /v26/;
Set inV4(v) "Input vertices" 
    //;
Set outV1(v) "Output vertices" 
    //;
Set outV2(v) "Output vertices" 
    //;
Set outV3(v) "Output vertices" 
    /v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39/;
Set outV4(v) "Output vertices" 
    //;
Set compV(v) "Comp vertices" 
    /v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25/;
Set memV(v) "Memory vertices" 
    //;
Set brV(v) "Branch vertices" 
    /br25/;
Set muE(e) "Mutually exclusive edges" 
    /e34/;
Set critV(v) "Nodes critical to achieving latency constraints" 
    /br25, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39/;
Set kindV(K,v);
Set kind2V(K2,v);
kindV('In1',inV1) = YES;
kindV('In2',inV2) = YES;
kindV('In3',inV3) = YES;
kindV('In4',inV4) = YES;
kindV('Out1',outV1) = YES;
kindV('Out2',outV2) = YES;
kindV('Out3',outV3) = YES;
kindV('Out4',outV4) = YES;
kindV('Comp',compV) = YES;
kindV('Memory',memV) = YES;
kindV('Branch',brV) = YES;
kind2V('Critical',critV) = YES;
Set kindE(K,e);
kindE('Mutex',muE) = YES;
Parameter Gev(e,v) 
    /e0.v1 1, e1.v3 1, e2.v3 1, e3.v35 1, e4.v5 1, e5.v37 1, e6.v7 1, e7.v9 1, e8.v9 1, e9.v11 1, e10.v10 1, e11.v12 1, e12.v13 1, e13.v14 1, e14.v27 1, e15.v17 1, e16.v21 1, e17.v20 1, e18.v16 1, e19.v19 1, e20.v23 1, e21.v15 1, e22.v18 1, e23.v22 1, e24.v29 1, e25.v33 1, e26.v32 1, e27.v28 1, e28.v39 1, e29.v36 1, e30.v34 1, e31.v30 1, e32.v38 1, e33.v31 1, e34.br25 1, e35.v2 1, e36.v8 1/;
Parameter Gve(v,e) 
    /v0.e0 1, v1.e1 1, v2.e2 1, v3.e3 1, v4.e4 1, v5.e5 1, v6.e6 1, v7.e7 1, v8.e8 1, v9.e9 1, v9.e10 1, v10.e11 1, v10.e12 1, v11.e13 1, v11.e14 1, v12.e15 1, v12.e16 1, v12.e17 1, v13.e18 1, v13.e19 1, v13.e20 1, v14.e21 1, v14.e22 1, v14.e23 1, v15.e24 1, v16.e25 1, v17.e26 1, v18.e27 1, v19.e28 1, v20.e29 1, v21.e30 1, v22.e31 1, v23.e32 1, v24.e33 1, v25.e34 1, v26.e35 1, v26.e36 1/;
Parameter delta(e) 
    /e0 1, e1 1, e2 3, e3 1, e4 1, e5 1, e6 1, e7 1, e8 3, e9 1, e10 1, e11 1, e12 1, e13 1, e14 1, e15 1, e16 1, e17 1, e18 1, e19 1, e20 1, e21 1, e22 1, e23 1, e24 1, e25 1, e26 1, e27 1, e28 1, e29 1, e30 1, e31 1, e32 1, e33 1, e34 0, e35 0, e36 0/;
Parameter delays(v) 
    /v0 1, v1 1, v2 3, v3 1, v4 1, v5 1, v6 1, v7 1, v8 3, v9 1, v10 1, v11 1, v12 1, v13 1, v14 1, v15 1, v16 1, v17 1, v18 1, v19 1, v20 1, v21 1, v22 1, v23 1, v24 1, v25 1, v26 0, v27 0, v28 0, v29 0, v30 0, v31 0, v32 0, v33 0, v34 0, v35 0, v36 0, v37 0, v38 0, v39 0/;
Positive variable Tv(v), Te(e), S, length; 
Tv.lo('v0')            = 0;
Tv.lo('v1')            = 1;
Tv.lo('v2')            = 6;
Tv.lo('v3')            = 9;
Tv.lo('v4')            = 0;
Tv.lo('v5')            = 1;
Tv.lo('v6')            = 0;
Tv.lo('v7')            = 1;
Tv.lo('v8')            = 6;
Tv.lo('v9')            = 9;
Tv.lo('v10')            = 10;
Tv.lo('v11')            = 10;
Tv.lo('v12')            = 11;
Tv.lo('v13')            = 11;
Tv.lo('v14')            = 11;
Tv.lo('v15')            = 12;
Tv.lo('v16')            = 12;
Tv.lo('v17')            = 12;
Tv.lo('v18')            = 12;
Tv.lo('v19')            = 12;
Tv.lo('v20')            = 12;
Tv.lo('v21')            = 12;
Tv.lo('v22')            = 12;
Tv.lo('v23')            = 12;
Tv.lo('v24')            = 0;
Tv.lo('v25')            = 0;
Tv.lo('v26')            = 6;
Tv.lo('v27')            = 11;
Tv.lo('v28')            = 13;
Tv.lo('v29')            = 13;
Tv.lo('v30')            = 13;
Tv.lo('v31')            = 1;
Tv.lo('v32')            = 13;
Tv.lo('v33')            = 13;
Tv.lo('v34')            = 13;
Tv.lo('v35')            = 10;
Tv.lo('v36')            = 13;
Tv.lo('v37')            = 2;
Tv.lo('v38')            = 13;
Tv.lo('v39')            = 13;
S.lo                   = 3;
