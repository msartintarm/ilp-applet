$GDXIN in.gdx

Sets n nutrients
     f foods;

$LOAD n f

Parameter b(n) required daily allowances of nutrients
          a(f,n) nutritive value of foods (per dollar spent);

$LOAD b a

Positive Variable x(f)  dollars of food f to be purchased daily   (dollars)

Free     Variable cost  total food bill                           (dollars)

Equations  nb(n) nutrient balance  (units),  cb cost balance  (dollars) ;

nb(n).. sum(f, a(f,n)*x(f)) =g= b(n);  cb..  cost=e= sum(f, x(f));

Model diet stiglers diet problem / nb,cb /;
Solve diet minimizing cost using lp;


