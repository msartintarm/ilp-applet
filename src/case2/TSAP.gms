alias(C,C1,C2);
alias(S,S1,S2);

scalar thediff;
loop((S1,S2)$(ORD(S1)+1=ORD(S2) and mod(ORD(S1),2)=0),
  thediff = uniformint(1,numS(S1));
  numS(S1) = numS(S1) + thediff;
  numS(S2) = numS(S2) - thediff;
);


parameter R(S,K,T);
R(S,K,T) = uniform(0,1);

* Variables

integer variable M(S,C);
binary variable O(C);
variable totalOn;

* First-Fit Algorithm
scalar isSet;
scalar fits;
scalar fail;
scalar i,ffVal;

fail=0;
M.l(S,C)=0;
loop(S,
  for (i = 1 to numS(S),
    isSet=0;
    loop(C,
      IF (isSet=0,
        fits=1;
        loop((K,T),
          fits=fits and (sum(S2,M.l(S2,C)*R(S2,K,T)) + R(S,K,T))<L(C,K);
        );
        IF(fits,
          M.l(S,C)=M.l(S,C)+1;
          isSet=1;
          O.l(C)=1;
        );
      );
    );
    if(not isSet,
      fail=1;
    );
  );
);
ffVal=sum(C,O.l(C));
totalOn.l=ffVal;

* sort em
scalar curIndex, curVal;
parameter temp(S);
loop(C,
  loop((C1,C2)$(ORD(C1)+1=ORD(C2)),
    if(sum(S, M.l(S,C1)*ORD(S)*5) < sum(S, M.l(S,C2)*ORD(S)*5),
      temp(S)=M.l(S,C2);
      M.l(S,C2)=M.l(S,C1);
      M.l(S,C1)=temp(S);
    );
  );
);

* Constraints
Equations uniqueMapping(S), computerIsOn(S,C), utilization(C,K,T), onOrdering, calcTotalOn,orderS(C1,C2);

uniqueMapping(S)..  sum(C,M(S,C)) =e= numS(S);
computerIsOn(S,C).. M(S,C) =l= numS(S)*O(C);
utilization(C,K,T)..  sum(S,M(S,C)*R(S,K,T)) =l= O(C)*L(C,K);
onOrdering(C1,C2)$(ORD(C1)=ORD(C2)-1).. O(C1) =g= O(C2);
calcTotalOn..       totalOn =e= sum(C,O(C));

Model allocate /uniqueMapping,utilization,calcTotalOn,onOrdering/;

allocate.optca=0.99999999;
allocate.optcr=0.1;
allocate.threads=8;

*M.prior(S,C)=Ord(C)*1000+Ord(S);
*M.prior(S,C)=Ord(S);
*O.prior(C)=ORD(C);
*allocate.prioropt=1;
allocate.OptFile=1;

file optfile /cplex.opt/;
put optfile;
put 'parallelmode -1'/;
put 'probe 3'/;
*put 'heurfreq 1'/;
*put 'mipemphasis 0'/;
*put 'nodesel 3'/;
put 'mipdisplay 4'/;
*put 'symmetry 5'/;
put 'mipstart 1'/;
put 'implbd 2 1'/;
putclose;

solve allocate using MIP minimizing totalOn;


* sort em
scalar curIndex, curVal;
parameter temp(S);
loop(C,
  loop((C1,C2)$(ORD(C1)+1=ORD(C2)),
    if(sum(S, M.l(S,C1)*ORD(S)*5) < sum(S, M.l(S,C2)*ORD(S)*5),
      temp(S)=M.l(S,C2);
      M.l(S,C2)=M.l(S,C1);
      M.l(S,C1)=temp(S);
    );
  );
);

orderS(C1,C2)$(ORD(C1)=ORD(C2)-1).. sum(S, M(S,C1)*ORD(S)*5) =g= sum(S, M(S,C2)*ORD(S)*5);

*Model allocate2 /uniqueMapping,utilization,calcTotalOn,orderS/;
*allocate2.OptFile=1;
*allocate2.cutOff=allocate.objEst;
*solve allocate2 using MIP minimizing totalOn;

file outfile / "allocation_d.lst" /;
outfile.pc=8;
outfile.pw=4096;
put outfile;

loop(C,
  put C.tl :;

  loop(K,
    put L(C,K);
  );

  put :;

  loop(S$(M.l(S,C)>=1),
    put "("S.tl","M.l(S,C)")";
  );
  put /;
);

*$batinclude print-allocate-stats.gms

*display R(S,K);
*display L(C,K);
*display M.l(S,C);
