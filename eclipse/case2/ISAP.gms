*execseed = 1+gmillisec(jnow);

**** Problem Inputs ****

Set K /cpu,mem/;

*Set S /s1*s5/;
*Set C /c1*c300/;
*Set T /t1*t1/;
*parameter numS(S);
*numS(S)=30;

alias(S,S1,S2);
alias(C,C1,C2);

scalar thediff;
loop((S1,S2)$(ORD(S1)+1=ORD(S2) and mod(ORD(S1),2)=0),
  thediff = uniformint(1,numS(S1));
  numS(S1) = numS(S1) + thediff;
  numS(S2) = numS(S2) - thediff;
);

parameter R(S,K,T);
parameter L(C,K);

R(S,K,T) = uniform(0,1);
*L(C,K) = 0.5+uniform(0,1);
L(C,K) = 1.5;

Parameter P(S);
Parameter X(S);

P(S) = .75*uniform(0,1);
X(S) = .5 + uniform(0,1);

* Variables

integer variable M(S,C);
binary variable O(C);
variable totalOn;
binary variable Y(S,C);

* First-Fit Algorithm
scalar isSet;
scalar fits;
scalar fail;
scalar i,ffval;

fail=0;
M.l(S,C)=0;
Y.l(S,C)=0;
loop(S,
  for (i = 1 to numS(S),
    isSet=0;
    loop(C,
      IF (isSet=0,
        fits=1;
        loop((K,T),
          fits=fits and (sum(S2,M.l(S2,C)*R(S2,K,T)) + R(S,K,T))<L(C,K);
        );
        
        fits=fits and sum(S2,M.l(S2,C)*P(S2)) <= X(S);

        loop(S1$(Y.l(S1,C)),
          fits=fits and sum(S2,M.l(S2,C)*P(S2))+P(S)-P(S1) <= X(S1);
        );

        IF(fits,
          M.l(S,C)=M.l(S,C)+1;
          isSet=1;
          O.l(C)=1;
          Y.l(S,C)=1;
        );
      );
    );
    if(not isSet,
      fail=1;
    );
  );
);

display fail;

if(fail,
  display M.l;
);

* sort em
*scalar curIndex, curVal;
*parameter temp(S);
*loop(C,
*  loop((C1,C2)$(ORD(C1)+1=ORD(C2)),
*    if(sum(S, M.l(S,C1)*ORD(S)*5) < sum(S, M.l(S,C2)*ORD(S)*5),
*      temp(S)=M.l(S,C2);
*      M.l(S,C2)=M.l(S,C1);
*      M.l(S,C1)=temp(S);
*    );
*  );
*);

* find most S that can map to C, to make BIGM variable small
scalar maxPossible;
parameter MOST(S,C);
MOST(S,C) = numS(S);
loop(S,
  loop(C,
    
    loop((K,T),
      maxPossible = floor(L(C,K) / R(S,K,T));
      if(maxPossible < MOST(S,C),
        MOST(S,C)=maxPossible;
      );
    );
  );
);

Y.l(S,C) = M.l(S,C);
ffVal=sum(C,O.l(C));
totalOn.l=ffVal;

scalar maxPressure;
maxPressure=smax(S,X(S));

Parameter TM(S,C);
*TM(S,C) = min((K,T), L(C,K)/R(S,K,T));

* Constraint
Equations uniqueMapping(S), computerIsOn(S,C), utilization(C,K,T), onOrdering, calcTotalOn, sense(C,S), qos(C,S),orderS(C1,C2);

uniqueMapping(S)..    sum(C,M(S,C)) =e= numS(S);
utilization(C,K,T)..  sum(S,M(S,C)*R(S,K,T)) =l= O(C)*L(C,K);
onOrdering(C1,C2)$(ORD(C1)=ORD(C2)-1)..
                      O(C1) =g= O(C2);
*qos(C,S)..            sum(S2,M(S2,C)*P(S2))-P(S) -(sum(S1,MOST(S1,C)*P(S1)))*(1-Y(S,C)) =l= X(S);

* GOOD BIGM
sense(C,S)..          Y(S,C)*MOST(S,C) =g= M(S,C);
qos(C,S)..           sum(S2,M(S2,C)*P(S2))-P(S) - maxPressure*(1-Y(S,C)) =l= X(S);

* BAD BIGM
*sense(C,S)..          Y(S,C)*10000 =g= M(S,C);
*qos(C,S)..           sum(S2,M(S2,C)*P(S2))-P(S) - 10000*(1-Y(S,C)) =l= X(S);

*orderS(C1,C2)$(ORD(C1)=ORD(C2)-1).. sum(S, M(S,C1)*ORD(S)*5) =g= sum(S, M(S,C2)*ORD(S)*5);
calcTotalOn..         totalOn =e= sum(C,O(C));

Model allocate /uniqueMapping,utilization,onOrdering,calcTotalOn,sense,qos/;

allocate.optca=0.99999999;
allocate.optcr=0.1;
allocate.threads=8;

*M.prior(S,C)=Ord(C)*1000+Ord(S);
*O.prior(C)=1000000;
*allocate.prioropt=1;
allocate.OptFile=1;

file optfile /cplex.opt/;      
put optfile;
put 'parallelmode -1'/;
*put 'probe 3'/;
*put 'heurfreq 1'/;
*put 'mipemphasis 0'/;
*put 'mipdisplay 4'/;
put 'mipstart 1'/;
*put 'symmetry 5'/;
putclose;

solve allocate using MIP minimizing totalOn;

file outfile / "allocation_e.lst" /;
outfile.pc=8;
outfile.pw=4096;
put outfile;


put "main"/;
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
