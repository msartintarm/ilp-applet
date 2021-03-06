$onempty
set v "verticies" 
 /I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, O16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31/;
set inV(v) "input verticies" /I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15/;
set outV(v) "output verticies" /O16/;
set iv(v) "instruction verticies";
iv(v) = (not inV(v)) and (not outV(v));
set AddV(v) //;
set SubV(v) //;
set MulV(v) //;
set UDivV(v) //;
set SDivV(v) //;
set URemV(v) //;
set SRemV(v) //;
set IMaxV(v) //;
set IMinV(v) //;
set SMaxV(v) //;
set SMinV(v) //;
set FAddV(v) /N22, N24, N26, N28, N29, N30, N31/;
set FSubV(v) //;
set FMulV(v) /N17, N18, N19, N20, N21, N23, N25, N27/;
set FDivV(v) //;
set FRemV(v) //;
set SqrtV(v) //;
set FSinV(v) //;
set FCosV(v) //;
set FMaxV(v) //;
set FMinV(v) //;
set SExtV(v) //;
set ShlV(v) //;
set LShrV(v) //;
set AShrV(v) //;
set AndV(v) //;
set OrV(v) //;
set XorV(v) //;
set PHIV(v) //;
set TernaryV(v) //;
set CopyV(v) //;
set ICmpEQV(v) //;
set ICmpNEV(v) //;
set ICmpUGTV(v) //;
set ICmpUGEV(v) //;
set ICmpULTV(v) //;
set ICmpULEV(v) //;
set ICmpSGTV(v) //;
set ICmpSGEV(v) //;
set ICmpSLTV(v) //;
set ICmpSLEV(v) //;
set FCmpOEQV(v) //;
set FCmpONEV(v) //;
set FCmpOGTV(v) //;
set FCmpOGEV(v) //;
set FCmpOLTV(v) //;
set FCmpOLEV(v) //;
set e "edges" 
 /I5_N20i0, I4_N20i1, I3_N19i2, I2_N18i3, I1_N18i4, I0_N17i5, I9_N23i6, I8_N19i7, I6_N17i8, I7_N21i9, I12_N23i10, I13_N27i11, I10_N21i12, I11_N25i13, I15_N27i14, I14_N25i15, N17_N22i16, N18_N22i17, N19_N24i18, N20_N24i19, N21_N26i20, N22_N30i21, N23_N28i22, N24_N31i23, N25_N26i24, N26_N30i25, N27_N28i26, N28_N31i27, N29_O16i28, N30_N29i29, N31_N29i30/;
set kindV(K,v) "Vertex Type"; 
kindV('Input', inV(v))=YES;
kindV('Output', outV(v))=YES;
kindV('Add', AddV(v))=YES;
kindV('Sub', SubV(v))=YES;
kindV('Mul', MulV(v))=YES;
kindV('UDiv', UDivV(v))=YES;
kindV('SDiv', SDivV(v))=YES;
kindV('URem', URemV(v))=YES;
kindV('SRem', SRemV(v))=YES;
kindV('IMax', IMaxV(v))=YES;
kindV('IMin', IMinV(v))=YES;
kindV('SMax', SMaxV(v))=YES;
kindV('SMin', SMinV(v))=YES;
kindV('FAdd', FAddV(v))=YES;
kindV('FSub', FSubV(v))=YES;
kindV('FMul', FMulV(v))=YES;
kindV('FDiv', FDivV(v))=YES;
kindV('FRem', FRemV(v))=YES;
kindV('Sqrt', SqrtV(v))=YES;
kindV('FSin', FSinV(v))=YES;
kindV('FCos', FCosV(v))=YES;
kindV('FMax', FMaxV(v))=YES;
kindV('FMin', FMinV(v))=YES;
kindV('SExt', SExtV(v))=YES;
kindV('Shl', ShlV(v))=YES;
kindV('LShr', LShrV(v))=YES;
kindV('AShr', AShrV(v))=YES;
kindV('And', AndV(v))=YES;
kindV('Or', OrV(v))=YES;
kindV('Xor', XorV(v))=YES;
kindV('PHI', PHIV(v))=YES;
kindV('Ternary', TernaryV(v))=YES;
kindV('Copy', CopyV(v))=YES;
kindV('ICmpEQ', ICmpEQV(v))=YES;
kindV('ICmpNE', ICmpNEV(v))=YES;
kindV('ICmpUGT', ICmpUGTV(v))=YES;
kindV('ICmpUGE', ICmpUGEV(v))=YES;
kindV('ICmpULT', ICmpULTV(v))=YES;
kindV('ICmpULE', ICmpULEV(v))=YES;
kindV('ICmpSGT', ICmpSGTV(v))=YES;
kindV('ICmpSGE', ICmpSGEV(v))=YES;
kindV('ICmpSLT', ICmpSLTV(v))=YES;
kindV('ICmpSLE', ICmpSLEV(v))=YES;
kindV('FCmpOEQ', FCmpOEQV(v))=YES;
kindV('FCmpONE', FCmpONEV(v))=YES;
kindV('FCmpOGT', FCmpOGTV(v))=YES;
kindV('FCmpOGE', FCmpOGEV(v))=YES;
kindV('FCmpOLT', FCmpOLTV(v))=YES;
kindV('FCmpOLE', FCmpOLEV(v))=YES;
parameter Gve(v,e) "vetex to edge" 
 /I5.I5_N20i0 1, I4.I4_N20i1 1, I3.I3_N19i2 1, I2.I2_N18i3 1, I1.I1_N18i4 1, I0.I0_N17i5 1, I9.I9_N23i6 1, I8.I8_N19i7 1, I6.I6_N17i8 1, I7.I7_N21i9 1, I12.I12_N23i10 1, I13.I13_N27i11 1, I10.I10_N21i12 1, I11.I11_N25i13 1, I15.I15_N27i14 1, I14.I14_N25i15 1, N17.N17_N22i16 1, N18.N18_N22i17 1, N19.N19_N24i18 1, N20.N20_N24i19 1, N21.N21_N26i20 1, N22.N22_N30i21 1, N23.N23_N28i22 1, N24.N24_N31i23 1, N25.N25_N26i24 1, N26.N26_N30i25 1, N27.N27_N28i26 1, N28.N28_N31i27 1, N29.N29_O16i28 1, N30.N30_N29i29 1, N31.N31_N29i30 1/;
parameter Gev(e,v) "edge to vertex" 
 /I5_N20i0.N20 1, I4_N20i1.N20 1, I3_N19i2.N19 1, I2_N18i3.N18 1, I1_N18i4.N18 1, I0_N17i5.N17 1, I9_N23i6.N23 1, I8_N19i7.N19 1, I6_N17i8.N17 1, I7_N21i9.N21 1, I12_N23i10.N23 1, I13_N27i11.N27 1, I10_N21i12.N21 1, I11_N25i13.N25 1, I15_N27i14.N27 1, I14_N25i15.N25 1, N17_N22i16.N22 1, N18_N22i17.N22 1, N19_N24i18.N24 1, N20_N24i19.N24 1, N21_N26i20.N26 1, N22_N30i21.N30 1, N23_N28i22.N28 1, N24_N31i23.N31 1, N25_N26i24.N26 1, N26_N30i25.N30 1, N27_N28i26.N28 1, N28_N31i27.N31 1, N29_O16i28.O16 1, N30_N29i29.N29 1, N31_N29i30.N29 1/;
set intedges(e) "edges" 
 /N17_N22i16, N18_N22i17, N19_N24i18, N20_N24i19, N21_N26i20, N22_N30i21, N23_N28i22, N24_N31i23, N25_N26i24, N26_N30i25, N27_N28i26, N28_N31i27, N30_N29i29, N31_N29i30/;
parameter delta(e) "delay of edge" 
 /I5_N20i0 0, I4_N20i1 0, I3_N19i2 0, I2_N18i3 0, I1_N18i4 0, I0_N17i5 0, I9_N23i6 0, I8_N19i7 0, I6_N17i8 0, I7_N21i9 0, I12_N23i10 0, I13_N27i11 0, I10_N21i12 0, I11_N25i13 0, I15_N27i14 0, I14_N25i15 0, N17_N22i16 3, N18_N22i17 3, N19_N24i18 3, N20_N24i19 3, N21_N26i20 3, N22_N30i21 3, N23_N28i22 3, N24_N31i23 3, N25_N26i24 3, N26_N30i25 3, N27_N28i26 3, N28_N31i27 3, N29_O16i28 3, N30_N29i29 3, N31_N29i30 3/;
