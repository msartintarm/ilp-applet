$setglobal mesh_radix  7

Sets
  coor         router's coordinates / c0*c%mesh_radix% /
  direction    the four directions /North, South, East, West/
  dirIn        the four directions /North, West, East, South, Cache, Directory/
  dirOut       the four directions /North, South, East, West, Cache, Directory/
;

alias(coor, x, y, px, py, mx, my);

Scalar mesh_dimension / 8 /;
parameter num_memory_controllers;
parameter buffer_budget;
parameter vc_budget;
parameter PathsPerInOut(x,y,dirIn,dirOut);

$include uniform_link_contention.txt
$include link_contention

Variables
  hasMemoryController(x,y)          coordinates x y have a memory controller
  LoadOnLink(x,y,direction)         load on channel x y direction

  L(x,y,direction)      binary variable denoting whether x y direction link is wide or narrow
  R(x,y,dirIn)          integer variable denoting buffers for x y dirIn dirOut
  V(x,y,dirIn)
  Vp(x,y,dirIn)
  z                     variable that lower bounds the ratio of capacity and count for any link
  w                     variable that lower bounds the ratio of buffer and count for any in out pair
  s                     variable that lower bounds the ratio of number of VCs and path count per router and in port
  t                     sum of z and w
;

Binary variable hasMemoryController;
Binary variable L;
Integer variable R;
Integer variable V;
Integer variable Vp;
positive variable z;
positive variable LoadOnLink;

Equations
  TotalWideLinks                      limit the total number of wide links
  CapacityPathRatio(x,y,direction)    bound the ratio of capacity and path count for any link

  NoWestLink(y)                       Set L to zero for links with 0 x coordinate and direction West
  NoEastLink(y)                       Set L to zero for links with 7 x coordinate and direction East
  NoNorthLink(x)                      Set L to zero for links with 0 y coordinate and direction North
  NoSouthLink(x)                      Set L to zero for links with 7 y coordinate and direction South

  SymmetricLinkWidthY(x,y)            Y direction Links are symmetric
  SymmetricLinkWidthX(x,y)            X direction Links are symmetric

  TotalBuffers                        limit the total number of buffers
  BufferPathRatio(x,y,dirIn)
  BufferPathRatioDir(x,y)

  NoBufferForWestInput(y)             Set R to zero for no west input
  NoBufferForEastInput(y)             Set R to zero for no east input
  NoBufferForNorthInput(x)            Set R to zero for no north input
  NoBufferForSouthInput(x)            Set R to zero for no south input

  TotalVC                             limit the total number of virtual channels
  MaximumVC(x,y,dirIn)                maximimum virtual channels
  MaximumCacheVC(x,y)
  MultipleTwo(x,y,dirIn)
  VCPathRatio(x,y,dirIn)
  NoVCForWestInput(y)                 Set V to zero for no west input
  NoVCForEastInput(y)                 Set V to zero for no east input
  NoVCForNorthInput(x)                Set V to zero for no north input
  NoVCForSouthInput(x)                Set V to zero for no south input

  PlaceControllers
  LoadOnChannel(x,y,direction)        compute the load on each channel
  CombinedObjective
;

TotalWideLinks                        ..  sum((x,y,direction), L(x,y,direction)) =l= 2 * mesh_dimension * (mesh_dimension-1);
CapacityPathRatio(x,y,direction)      ..  (L(x,y,direction) + 1) =g= LoadOnLink(x,y,direction) * z;

NoWestLink(y)                         ..  L('c0',y,'West') =e= 0;
NoEastLink(y)                         ..  L('c7',y,'East') =e= 0;
NoNorthLink(x)                        ..  L(x,'c0','North') =e= 0;
NoSouthLink(x)                        ..  L(x,'c7','South') =e= 0;

SymmetricLinkWidthY(x,y)              ..  L(x,y,'North') =e= L(x,y-1,'South');
SymmetricLinkWidthX(x,y)              ..  L(x,y,'East') =e= L(x+1,y,'West');

BufferPathRatio(x,y,dirIn)$(not sameas(dirIn, 'Directory'))  ..  R(x,y,DirIn) =g=   sum(dirOut,PathsPerInOut(x,y,DirIn,dirOut)) * w
                                                                                 - PathsPerInOut(x,y,dirIn, 'Directory') * w
                                                                                 + hasMemoryController(x,y) * PathsPerInOut(x,y,dirIn, 'Directory') * w;

BufferPathRatioDir(x,y)               ..  R(x,y,'Directory') =g=   sum(dirOut,PathsPerInOut(x,y,'Directory',dirOut)) * w * hasMemoryController(x,y);

TotalBuffers                          ..  sum((x,y,dirIn), R(x,y,dirIn)) =l= buffer_budget;

NoBufferForWestInput(y)               ..  R('c0',y,'West') =e= 0;
NoBufferForEastInput(y)               ..  R('c7',y,'East') =e= 0;
NoBufferForNorthInput(x)              ..  R(x,'c0','North') =e= 0;
NoBufferForSouthInput(x)              ..  R(x,'c7','South') =e= 0;

TotalVC                               ..  sum((x,y,dirIn), V(x,y,dirIn)) =l= vc_budget;
MaximumVC(x,y,dirIn)                  ..  V(x,y,dirIn) =l= 10;
MaximumCacheVC(x,y)                   ..  V(x,y,'Cache') =l= 4;
MultipleTwo(x,y,dirIn)                ..  V(x,y,dirIn) =e= 2 * Vp(x,y,dirIn);
VCPathRatio(x,y,dirIn)                ..  Vp(x,y,dirIn) =g= sum(dirOut, PathsPerInOut(x,y,dirIn,dirOut)) * s;
NoVCForWestInput(y)                   ..  Vp('c0',y,'West') =e= 0;
NoVCForEastInput(y)                   ..  Vp('c7',y,'East') =e= 0;
NoVCForNorthInput(x)                  ..  Vp(x,'c0','North') =e= 0;
NoVCForSouthInput(x)                  ..  Vp(x,'c7','South') =e= 0;

PlaceControllers                      ..  sum((x,y), hasMemoryController(x,y))   =e= num_memory_controllers;

LoadOnChannel(x,y,direction)          ..  LoadOnLink(x,y,direction)  
                                                =e= sum((px,py,mx,my), hasMemoryController(mx,my)*(   mesh_link_for_request(px,py,mx,my,x,y,direction)
                                                                                                    + mesh_link_for_reply(mx,my,px,py,x,y,direction)));
CombinedObjective                     ..  z  =e= t;

Model RouterConfiguration /all/;
Option MIP = Gurobi;
Option minlp = Baron;
Option nlp = knitro;
RouterConfiguration.optcr=0.0001
Option sysout  = on;

z.up  = 1;
buffer_budget = 5280;
vc_budget = 1056;
num_memory_controllers = 16;
solve RouterConfiguration using minlp maximizing t;

file linkFile /link_output.txt/ ;
put linkFile;
loop((x,y,direction), put x.tl:2, y.tl:2, direction.tl:6, L.l(x,y,direction):1:0 /);

file bufferFile /buffer_output.txt/ ;
put bufferFile;
loop((x,y,dirIn), put x.tl:2, y.tl:2, dirIn.tl:10, R.l(x,y,dirIn):2:0 /);

file vcFile /vc_output.txt/ ;
put vcFile;
loop((x,y,dirIn), put x.tl:2, y.tl:2, dirIn.tl:10, V.l(x,y,dirIn):2:0 /);
