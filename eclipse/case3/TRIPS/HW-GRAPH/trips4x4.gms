Set n "Nodes" 
    /br1, in2, out2, in3, out3, in4, out4, in5, out5, mem6, n1, n2, n3, n4, mem11, n5, n6, n7, n8, mem16, n9, n10, n11, n12, mem21, n13, n14, n15, n16/;
Set r "Routers" 
    /r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25/;
Set l "Links" 
    /l1*l129/;
Set rrL(l) "Router-to-router links" 
    /l2, l3, l6, l7, l8, l11, l12, l13, l16, l17, l18, l21, l22, l23, l24, l25, l28, l29, l30, l31, l34, l35, l36, l37, l40, l41, l42, l43, l46, l47, l48, l51, l52, l53, l56, l57, l58, l59, l62, l63, l64, l65, l68, l69, l70, l71, l74, l75, l76, l79, l80, l81, l84, l85, l86, l87, l90, l91, l92, l93, l96, l97, l98, l99, l102, l103, l104, l107, l108, l111, l112, l113, l116, l117, l118, l121, l122, l123, l126, l127/;
Alias (l,l2);
Set inN1(n) "Input nodes" 
    /in2/;
Set inN2(n) "Input nodes" 
    /in3/;
Set inN3(n) "Input nodes" 
    /in4/;
Set inN4(n) "Input nodes" 
    /in5/;
Set outN1(n) "Output nodes" 
    /out2/;
Set outN2(n) "Output nodes" 
    /out3/;
Set outN3(n) "Output nodes" 
    /out4/;
Set outN4(n) "Output nodes" 
    /out5/;
Set compN(n) "Comp nodes" 
    /n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16/;
Set memN(n) "Memory nodes" 
    /mem6, mem11, mem16, mem21/;
Set brN(n) "Branch nodes" 
    /br1/;
Set F(l,l) " Dimension-order Routing Violations" 
    /l23.l3, l28.l7, l28.l8, l34.l12, l34.l13, l40.l17, l40.l18, l46.l22, l2.l25, l51.l25, l6.l30, l56.l30, l6.l31, l56.l31, l11.l36, l62.l36, l11.l37, l62.l37, l16.l42, l68.l42, l16.l43, l68.l43, l21.l48, l74.l48, l24.l53, l79.l53, l29.l58, l84.l58, l29.l59, l84.l59, l35.l64, l90.l64, l35.l65, l90.l65, l41.l70, l96.l70, l41.l71, l96.l71, l47.l76, l102.l76/;
Set kindL(K,l);
kindL('rrL', rrL) = YES;
Set kindN(K,n);
kindN('In1', inN1) = YES;
kindN('In2', inN2) = YES;
kindN('In3', inN3) = YES;
kindN('In4', inN4) = YES;
kindN('Out1', outN1) = YES;
kindN('Out2', outN2) = YES;
kindN('Out3', outN3) = YES;
kindN('Out4', outN4) = YES;
kindN('Comp',compN) = YES;
kindN('Memory',memN) = YES;
kindN('Branch',brN) = YES;
Set Hrl(r,l) 
    /r1.l1, r1.l2, r1.l3, r2.l5, r2.l6, r2.l7, r2.l8, r3.l10, r3.l11, r3.l12, r3.l13, r4.l15, r4.l16, r4.l17, r4.l18, r5.l20, r5.l21, r5.l22, r6.l23, r6.l24, r6.l25, r6.l26, r7.l28, r7.l29, r7.l30, r7.l31, r7.l32, r8.l34, r8.l35, r8.l36, r8.l37, r8.l38, r9.l40, r9.l41, r9.l42, r9.l43, r9.l44, r10.l46, r10.l47, r10.l48, r10.l49, r11.l51, r11.l52, r11.l53, r11.l54, r12.l56, r12.l57, r12.l58, r12.l59, r12.l60, r13.l62, r13.l63, r13.l64, r13.l65, r13.l66, r14.l68, r14.l69, r14.l70, r14.l71, r14.l72, r15.l74, r15.l75, r15.l76, r15.l77, r16.l79, r16.l80, r16.l81, r16.l82, r17.l84, r17.l85, r17.l86, r17.l87, r17.l88, r18.l90, r18.l91, r18.l92, r18.l93, r18.l94, r19.l96, r19.l97, r19.l98, r19.l99, r19.l100, r20.l102, r20.l103, r20.l104, r20.l105, r21.l107, r21.l108, r21.l109, r22.l111, r22.l112, r22.l113, r22.l114, r23.l116, r23.l117, r23.l118, r23.l119, r24.l121, r24.l122, r24.l123, r24.l124, r25.l126, r25.l127, r25.l128/;
Set Hlr(l,r) 
    /l2.r6, l3.r2, l4.r2, l6.r7, l7.r3, l8.r1, l9.r3, l11.r8, l12.r4, l13.r2, l14.r4, l16.r9, l17.r5, l18.r3, l19.r5, l21.r10, l22.r4, l23.r1, l24.r11, l25.r7, l27.r6, l28.r2, l29.r12, l30.r8, l31.r6, l33.r7, l34.r3, l35.r13, l36.r9, l37.r7, l39.r8, l40.r4, l41.r14, l42.r10, l43.r8, l45.r9, l46.r5, l47.r15, l48.r9, l50.r10, l51.r6, l52.r16, l53.r12, l55.r11, l56.r7, l57.r17, l58.r13, l59.r11, l61.r12, l62.r8, l63.r18, l64.r14, l65.r12, l67.r13, l68.r9, l69.r19, l70.r15, l71.r13, l73.r14, l74.r10, l75.r20, l76.r14, l78.r15, l79.r11, l80.r21, l81.r17, l83.r16, l84.r12, l85.r22, l86.r18, l87.r16, l89.r17, l90.r13, l91.r23, l92.r19, l93.r17, l95.r18, l96.r14, l97.r24, l98.r20, l99.r18, l101.r19, l102.r15, l103.r25, l104.r19, l106.r20, l107.r16, l108.r22, l110.r21, l111.r17, l112.r23, l113.r21, l115.r22, l116.r18, l117.r24, l118.r22, l120.r23, l121.r19, l122.r25, l123.r23, l125.r24, l126.r20, l127.r24, l129.r25/;
Set Hnl(n,l) 
    /in2.l4, in3.l9, in4.l14, in5.l19, mem6.l27, n1.l33, n2.l39, n3.l45, n4.l50, mem11.l55, n5.l61, n6.l67, n7.l73, n8.l78, mem16.l83, n9.l89, n10.l95, n11.l101, n12.l106, mem21.l110, n13.l115, n14.l120, n15.l125, n16.l129/;
Set Hln(l,n) 
    /l1.br1, l5.out2, l10.out3, l15.out4, l20.out5, l26.mem6, l32.n1, l38.n2, l44.n3, l49.n4, l54.mem11, l60.n5, l66.n6, l72.n7, l77.n8, l82.mem16, l88.n9, l94.n10, l100.n11, l105.n12, l109.mem21, l114.n13, l119.n14, l124.n15, l128.n16/;
