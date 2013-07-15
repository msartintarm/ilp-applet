* Hardware Nodes / Links
Set n "Nodes"   /n1 * n8/;
Set r "Routers" /r1 * r4/;
Set l "Links"   /l1 * l20/;

* Node Connections
Set Hnl(n,l) /n1.l1, n2.l3, n3.l5, n5.l13, n7.l18, n8.l20/;
Set Hln(l,n) /l2.n1, l4.n2, l7.n4, l15.n6, l17.n7, l19.n8/;

* Router Connections
Set Hrl(r,l) /r1.l2, r1.l6, r1.l9, 
    	      r2.l4, r2.l7, r2.l8, r2.l11,
	      r3.l10, r3.l14, r3.l17,
	      r4.l12, r4.l15, r4.l16, r4.l18/;
Set Hlr(l,r) /l1.r1, l5.r1, l8.r1, l10.r1,
    	      l3.r2, l8.r2, l12.r2,
	      l9.r3, l13.r3, l16.r3, l18.r3,
	      l11.r4, l14.r4, l20.r4/;

* Kinds of Operational Nodes
Set kindN(K,n)  /IN.n3, IN.n5, MULT.n1, ADD.n2, SUB.n2, 
     	         ADD.n7, SUB.n7, DIV.n8, OUT.n4, OUT.n6/;
