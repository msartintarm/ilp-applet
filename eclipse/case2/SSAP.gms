*execseed = 1+gmillisec(jnow);

**** Problem Inputs ****

Set K /cpu,mem/;
*Set S /s1*s500/;
*Set C /c1*c500/;

parameter R(S,K);
parameter L(C,K);

R(S,K) = uniform(0,1);
L(C,K) = .5+2*uniform(0,1);
*L(C,K) = 1.5;


* Variables
binary variable M(S,C);
binary variable O(C);
variable totalOn;

alias(C,C1,C2,C3);
alias(S,S1,S2);

* lattice cuts
scalar strictlyGreater;
parameter CGC(C,C);
loop((C1,C2),
  strictlyGreater=1;
  loop(K,
    strictlyGreater = strictlyGreater and L(C1,K) > L(C2,K);
  );
  CGC(C1,C2) = strictlyGreater;
);

scalar numCGC;
numCGC = sum((C1,C2),CGC(C1,C2));
display numCGC;

* refactor
parameter CGC2(C,C);
CGC2(C1,C2)=CGC(C1,C2);
loop((C1,C2,C3),
  if( CGC(C1,C2) and CGC(C2,C3),
    CGC2(C1,C3)=0;
  );
);

CGC(C1,C2)=CGC2(C1,C2);
numCGC = sum((C1,C2),CGC(C1,C2));
display numCGC;


* First-Fit Algorithm
scalar isSet, fits, fail, ffVal;

fail=0;
M.l(S,C)=0;
loop(S,
  isSet=0;
  loop(C,
    IF (isSet=0,
      fits=1;
      loop(K,
        fits=fits and (sum(S2,M.l(S2,C)*R(S2,K)) + R(S,K))<L(C,K);
      );
      IF(fits,
        M.l(S,C)=1;
        isSet=1;
        O.l(C)=1;
      );
    );
  );
  if(not isSet,
    fail=1;
  );
);

ffVal=sum(C,O.l(C));
totalOn.l=ffVal;

display totalOn.l;

* Constraints


Equations uniqueMapping(S), computerIsOn(S,C), utilization(C,K), calcTotalOn, onOrdering(C1,C2),latticeOrdering(C1,C2);

uniqueMapping(S)..  sum(C,M(S,C)) =e= 1;
computerIsOn(S,C).. M(S,C) =l= O(C);
utilization(C,K)..  sum(S,M(S,C)*R(S,K)) =l= O(C)* L(C,K);
onOrdering(C1,C2)$(ORD(C1)=ORD(C2)-1).. O(C1) =g= O(C2);
latticeOrdering(C1,C2)$(CGC(C1,C2)).. O(C1) =g= O(C2);
calcTotalOn..       totalOn =e= sum(C,O(C));

*Model allocate /uniqueMapping,utilization,calcTotalOn,computerIsOn,onOrdering/;
Model allocate /uniqueMapping,utilization,calcTotalOn,latticeOrdering/;

allocate.optca=0.99999999;
allocate.optcr=0.1;

*mipstart!
*M.l(S,C)=1$(ORD(S)=ORD(C));
*O.l(C)=1;
*totalOn.l=sum(C,O.l(C));

*M.prior(S,C)=1000*ORD(C)+ORD(S);
*O.prior(C)=1000*ORD(C)+1;
*allocate.prioropt=1;
allocate.threads=8;
allocate.optfile=1;

file optfile /cplex.opt/;      
put optfile;
put 'parallelmode -1'/;
put 'probe 2'/;
put 'mipstart 1'/;
*put 'heurfreq 1'/;
putclose;

option mip=cplex
solve allocate using MIP minimizing totalOn;

file outfile / "allocation.lst" /;
outfile.pc=8;
outfile.pw=4096;
put outfile;

loop(C,
  put C.tl :;

  loop(K,
    put L(C,K);
  );

  put :;

  loop(S$(M.l(S,C)=1),
    put S.tl;
  );
  put /;
);

*$batinclude print-allocate-stats.gms

*display R(S,K);
*display L(C,K);
*display M.l(S,C);
