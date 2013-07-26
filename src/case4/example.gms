$title bilinear term linearized
$ontext
* Nilay simplified version
* Using Ahmed simplest approach
* write w(j) = Z*v(j) using binary expansion
* Michael Ferris (Oct 26, 2012)

* min z st  z v(j) >= C(j,:) x
            Ax = b
            0 <= z <= zup
            0 <= v(j) <= power(2,r) -1, integer
            sum_j  v(j) <= vbar
$offtext

option limrow=0, limcol=0;
$offlisting

$if not set r $set r 2
$if not set frac $set frac 0.9
$if not set zup $set zup 5

$eval pr power(2,%r%)-1

set j /1*20/,
    i /1*50/,
    m /1*4/,
    k /1*%r%/;

$eval vbar %frac%*card(j)*%pr%

option seed = 101;
parameter A(m,i), b(m), c(j,i);
A(m,i) = uniform(-1,1);
b(m) = uniform(-3,4);
c(j,i) = uniform(0,2);

positive variables z, x(i);
* integer variables v(j);
positive variables v(j);
variables obj, w(j);
binary variables e(j,k);
positive variables f(j,k);

* z.up = %zup%;
* v.up(j) = %pr%;

equations defc(m), defbilin(j), defv(j), defw(j), bnd1(j,k), bnd2(j,k), bnd3(j,k);
equation defobj, limv;

defc(m)..
  b(m) =e= sum(i, A(m,i)*x(i));

limv..
  sum(j, v(j)) =l= %vbar%;

defbilin(j)..
  w(j) =g= sum(i, c(j,i)*x(i));

defv(j)..
v(j) =e= sum(k, power(2,k.ord-1)*e(j,k));

defw(j)..
w(j) =e= sum(k, power(2,k.ord-1)*f(j,k));

bnd1(j,k)..
f(j,k) =l= %zup%*e(j,k);

bnd2(j,k)..
f(j,k) =l= z;

bnd3(j,k)..
f(j,k) =g= z + %zup%*e(j,k) - %zup%;

defobj..
  obj =e= z;

model blp /all/;
blp.optcr = 1e-4;
blp.optca = 0;
solve blp using mip min obj;

parameter l(j);
l(j) = sum(i, c(j,i)*x.l(i));

display l, w.l;