*execseed = 1+gmillisec(jnow);

**** Problem Inputs ****

Set K /cpu,mem/;

*Set S /s1*s20/;
*Set C /c1*c500/;
*parameter numS(S);
*numS(S)=100;

alias(S,S1,S2);
alias(C,C1,C2);

scalar thediff;
loop((S1,S2)$(ORD(S1)+1=ORD(S2) and mod(ORD(S1),2)=0),
  thediff = uniformint(1,numS(S1));
  numS(S1) = numS(S1) + thediff;
  numS(S2) = numS(S2) - thediff;
);

parameter R(S,K);
parameter L(C,K);

R(S,K) = uniform(0,1);
*L(C,K) = 0.5+uniform(0,1);
L(C,K) = 1.5;

* Variables

integer variable M(S,C);
binary variable O(C);
variable totalOn;

* First-Fit Algorithm
scalar isSet;
scalar fits;
scalar fail;
scalar i, ffVal;

fail=0;
M.l(S,C)=0;
loop(S,
  for (i = 1 to numS(S),
    isSet=0;
    loop(C,
      IF (isSet=0,
        fits=1;
        loop(K,
          fits=fits and (sum(S2,M.l(S2,C)*R(S2,K)) + R(S,K))<L(C,K);
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

* Constraints

Equations uniqueMapping(S), computerIsOn(S,C), utilization(C,K), calcTotalOn, onOrdering(C1,C2), orderS(C1,C2);

uniqueMapping(S)..  sum(C,M(S,C)) =e= numS(S);
computerIsOn(S,C).. M(S,C) =l= numS(S)*O(C);
utilization(C,K)..  sum(S,M(S,C)*R(S,K)) =l= O(C) * L(C,K);
onOrdering(C1,C2)$(ORD(C1)=ORD(C2)-1).. O(C1) =g= O(C2);

option mip = cplex;
orderS(C1,C2)$(ORD(C1)=ORD(C2)-1).. sum(S, M(S,C1)*ORD(S)*100) =g= sum(S, M(S,C2)*ORD(S)*100);

calcTotalOn..       totalOn =e= sum(C,O(C));

*Model allocate /uniqueMapping,utilization,calcTotalOn,onOrdering/;
Model allocate /uniqueMapping,utilization,calcTotalOn/;

allocate.optca=0.99999999;
allocate.optcr=0.1;
allocate.threads=8;

M.prior(S,C)=Ord(S);
O.prior(C)=1000000;
allocate.prioropt=1;
allocate.optfile=1;

file optfile /cplex.opt/;      
put optfile;
put 'parallelmode -1'/;
*put 'probe 2'/;
*put 'heurfreq 1'/;
put 'mipstart 1'/;
putclose;

solve allocate using MIP minimizing totalOn;

file outfile / "allocation_b.lst" /;
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

$batinclude print-allocate-stats.gms

*display R(S,K);
*display L(C,K);
*display M.l(S,C);
