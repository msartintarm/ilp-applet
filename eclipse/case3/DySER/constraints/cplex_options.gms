file optfile /cplex.opt/;      

put optfile;
put 'parallelmode -1'/;
put 'probe 2'/;
put 'heurfreq 1'/;
put 'mipstart 1'/;
putclose;