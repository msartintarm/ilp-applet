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
  z                     variable that lower bounds the ratio of capacity and count for any link
  t
;

Binary variable hasMemoryController;
Binary variable L;
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

  PlaceControllers
  LoadOnChannel(x,y,direction)        compute the load on each channel
  Objective
;

**** Initial Solution
*hasMemoryController.fx('c0','c0') = 1;
*hasMemoryController.fx('c0','c7') = 1;
*hasMemoryController.fx('c1','c1') = 1;
*hasMemoryController.fx('c1','c6') = 1;
*hasMemoryController.fx('c2','c2') = 1;
*hasMemoryController.fx('c2','c5') = 1;
*hasMemoryController.fx('c3','c3') = 1;
*hasMemoryController.fx('c3','c4') = 1;
*hasMemoryController.fx('c4','c3') = 1;
*hasMemoryController.fx('c4','c4') = 1;
*hasMemoryController.fx('c5','c2') = 1;
*hasMemoryController.fx('c5','c5') = 1;
*hasMemoryController.fx('c6','c6') = 1;
*hasMemoryController.fx('c6','c1') = 1;
*hasMemoryController.fx('c7','c7') = 1;
*hasMemoryController.fx('c7','c0') = 1;

*hasMemoryController.fx('c0','c3') = 1;
*hasMemoryController.fx('c0','c4') = 1;
*hasMemoryController.fx('c1','c2') = 1;
*hasMemoryController.fx('c1','c5') = 1;
*hasMemoryController.fx('c2','c1') = 1;
*hasMemoryController.fx('c2','c6') = 1;
*hasMemoryController.fx('c3','c0') = 1;
*hasMemoryController.fx('c3','c7') = 1;
*hasMemoryController.fx('c4','c0') = 1;
*hasMemoryController.fx('c4','c7') = 1;
*hasMemoryController.fx('c5','c1') = 1;
*hasMemoryController.fx('c5','c6') = 1;
*hasMemoryController.fx('c6','c2') = 1;
*hasMemoryController.fx('c6','c5') = 1;
*hasMemoryController.fx('c7','c3') = 1;
*hasMemoryController.fx('c7','c4') = 1;

*hasMemoryController.fx('c0','c3') = 1;
*hasMemoryController.fx('c0','c4') = 1;
*hasMemoryController.fx('c0','c2') = 1;
*hasMemoryController.fx('c0','c5') = 1;
*hasMemoryController.fx('c0','c1') = 1;
*hasMemoryController.fx('c0','c6') = 1;
*hasMemoryController.fx('c0','c0') = 1;
*hasMemoryController.fx('c0','c7') = 1;
*hasMemoryController.fx('c7','c0') = 1;
*hasMemoryController.fx('c7','c7') = 1;
*hasMemoryController.fx('c7','c1') = 1;
*hasMemoryController.fx('c7','c6') = 1;
*hasMemoryController.fx('c7','c2') = 1;
*hasMemoryController.fx('c7','c5') = 1;
*hasMemoryController.fx('c7','c3') = 1;
*hasMemoryController.fx('c7','c4') = 1;

hasMemoryController.l('c0','c1') = 1;
hasMemoryController.l('c0','c5') = 1;
hasMemoryController.l('c1','c3') = 1;
hasMemoryController.l('c1','c7') = 1;
hasMemoryController.l('c2','c2') = 1;
hasMemoryController.l('c2','c6') = 1;
hasMemoryController.l('c3','c0') = 1;
hasMemoryController.l('c3','c4') = 1;
hasMemoryController.l('c4','c2') = 1;
hasMemoryController.l('c4','c5') = 1;
hasMemoryController.l('c5','c1') = 1;
hasMemoryController.l('c5','c7') = 1;
hasMemoryController.l('c6','c0') = 1;
hasMemoryController.l('c6','c6') = 1;
hasMemoryController.l('c7','c3') = 1;
hasMemoryController.l('c7','c4') = 1;

LoadOnLink.l('c0','c0','North') =      0  ; 
LoadOnLink.l('c0','c0','South') =    30.0000;
LoadOnLink.l('c0','c0','East') =     14.0000;
LoadOnLink.l('c0','c0','West') =       0   ;
LoadOnLink.l('c0','c1','North') =    14.0000;
LoadOnLink.l('c0','c1','South') =    40.0000;
LoadOnLink.l('c0','c1','East') =     70.0000;
LoadOnLink.l('c0','c1','West') =       0   ;
LoadOnLink.l('c0','c2','North') =    72.0000;
LoadOnLink.l('c0','c2','South') =    54.0000;
LoadOnLink.l('c0','c2','East') =     14.0000;
LoadOnLink.l('c0','c2','West') =       0   ;
LoadOnLink.l('c0','c3','North') =    70.0000;
LoadOnLink.l('c0','c3','South') =    64.0000;
LoadOnLink.l('c0','c3','East') =     14.0000;
LoadOnLink.l('c0','c3','West') =       0   ;
LoadOnLink.l('c0','c4','North') =    64.0000;
LoadOnLink.l('c0','c4','South') =    70.0000;
LoadOnLink.l('c0','c4','East') =     14.0000;
LoadOnLink.l('c0','c4','West') =       0   ;
LoadOnLink.l('c0','c5','North') =    54.0000;
LoadOnLink.l('c0','c5','South') =    24.0000;
LoadOnLink.l('c0','c5','East') =     70.0000;
LoadOnLink.l('c0','c5','West') =       0   ;
LoadOnLink.l('c0','c6','North') =    56.0000;
LoadOnLink.l('c0','c6','South') =    14.0000;
LoadOnLink.l('c0','c6','East') =     14.0000;
LoadOnLink.l('c0','c6','West') =       0   ;
LoadOnLink.l('c0','c7','North') =    30.0000;
LoadOnLink.l('c0','c7','South') =      0   ;
LoadOnLink.l('c0','c7','East') =     14.0000;
LoadOnLink.l('c0','c7','West') =       0   ;
LoadOnLink.l('c1','c0','North') =      0   ;
LoadOnLink.l('c1','c0','South') =    30.0000;
LoadOnLink.l('c1','c0','East') =     24.0000;
LoadOnLink.l('c1','c0','West') =     30.0000;
LoadOnLink.l('c1','c1','North') =    14.0000;
LoadOnLink.l('c1','c1','South') =    56.0000;
LoadOnLink.l('c1','c1','East') =     72.0000;
LoadOnLink.l('c1','c1','West') =     22.0000;
LoadOnLink.l('c1','c2','North') =    24.0000;
LoadOnLink.l('c1','c2','South') =    78.0000;
LoadOnLink.l('c1','c2','East') =     24.0000;
LoadOnLink.l('c1','c2','West') =     30.0000;
LoadOnLink.l('c1','c3','North') =    30.0000;
LoadOnLink.l('c1','c3','South') =    64.0000;
LoadOnLink.l('c1','c3','East') =     72.0000;
LoadOnLink.l('c1','c3','West') =     30.0000;
LoadOnLink.l('c1','c4','North') =    64.0000;
LoadOnLink.l('c1','c4','South') =    70.0000;
LoadOnLink.l('c1','c4','East') =     24.0000;
LoadOnLink.l('c1','c4','West') =     30.0000;
LoadOnLink.l('c1','c5','North') =    54.0000;
LoadOnLink.l('c1','c5','South') =    72.0000;
LoadOnLink.l('c1','c5','East') =     72.0000;
LoadOnLink.l('c1','c5','West') =     22.0000;
LoadOnLink.l('c1','c6','North') =    40.0000;
LoadOnLink.l('c1','c6','South') =    70.0000;
LoadOnLink.l('c1','c6','East') =     24.0000;
LoadOnLink.l('c1','c6','West') =     30.0000;
LoadOnLink.l('c1','c7','North') =    22.0000;
LoadOnLink.l('c1','c7','South') =      0   ;
LoadOnLink.l('c1','c7','East') =     72.0000;
LoadOnLink.l('c1','c7','West') =     30.0000;
LoadOnLink.l('c2','c0','North') =      0   ;
LoadOnLink.l('c2','c0','South') =    30.0000;
LoadOnLink.l('c2','c0','East') =     30.0000;
LoadOnLink.l('c2','c0','West') =     56.0000;
LoadOnLink.l('c2','c1','North') =    14.0000;
LoadOnLink.l('c2','c1','South') =    56.0000;
LoadOnLink.l('c2','c1','East') =     70.0000;
LoadOnLink.l('c2','c1','West') =     40.0000;
LoadOnLink.l('c2','c2','North') =    24.0000;
LoadOnLink.l('c2','c2','South') =    54.0000;
LoadOnLink.l('c2','c2','East') =     70.0000;
LoadOnLink.l('c2','c2','West') =     56.0000;
LoadOnLink.l('c2','c3','North') =    70.0000;
LoadOnLink.l('c2','c3','South') =    64.0000;
LoadOnLink.l('c2','c3','East') =     70.0000;
LoadOnLink.l('c2','c3','West') =     40.0000;
LoadOnLink.l('c2','c4','North') =    64.0000;
LoadOnLink.l('c2','c4','South') =    70.0000;
LoadOnLink.l('c2','c4','East') =     30.0000;
LoadOnLink.l('c2','c4','West') =     56.0000;
LoadOnLink.l('c2','c5','North') =    54.0000;
LoadOnLink.l('c2','c5','South') =    72.0000;
LoadOnLink.l('c2','c5','East') =     70.0000;
LoadOnLink.l('c2','c5','West') =     40.0000;
LoadOnLink.l('c2','c6','North') =    40.0000;
LoadOnLink.l('c2','c6','South') =    14.0000;
LoadOnLink.l('c2','c6','East') =     70.0000;
LoadOnLink.l('c2','c6','West') =     56.0000;
LoadOnLink.l('c2','c7','North') =    30.0000;
LoadOnLink.l('c2','c7','South') =      0   ;
LoadOnLink.l('c2','c7','East') =     70.0000;
LoadOnLink.l('c2','c7','West') =     40.0000;
LoadOnLink.l('c3','c0','North') =      0   ;
LoadOnLink.l('c3','c0','South') =    22.0000;
LoadOnLink.l('c3','c0','East') =     64.0000;
LoadOnLink.l('c3','c0','West') =     78.0000;
LoadOnLink.l('c3','c1','North') =    70.0000;
LoadOnLink.l('c3','c1','South') =    40.0000;
LoadOnLink.l('c3','c1','East') =     64.0000;
LoadOnLink.l('c3','c1','West') =     54.0000;
LoadOnLink.l('c3','c2','North') =    72.0000;
LoadOnLink.l('c3','c2','South') =    54.0000;
LoadOnLink.l('c3','c2','East') =     64.0000;
LoadOnLink.l('c3','c2','West') =     54.0000;
LoadOnLink.l('c3','c3','North') =    70.0000;
LoadOnLink.l('c3','c3','South') =    64.0000;
LoadOnLink.l('c3','c3','East') =     64.0000;
LoadOnLink.l('c3','c3','West') =     54.0000;
LoadOnLink.l('c3','c4','North') =    64.0000;
LoadOnLink.l('c3','c4','South') =    30.0000;
LoadOnLink.l('c3','c4','East') =     64.0000;
LoadOnLink.l('c3','c4','West') =     78.0000;
LoadOnLink.l('c3','c5','North') =    78.0000;
LoadOnLink.l('c3','c5','South') =    24.0000;
LoadOnLink.l('c3','c5','East') =     64.0000;
LoadOnLink.l('c3','c5','West') =     54.0000;
LoadOnLink.l('c3','c6','North') =    56.0000;
LoadOnLink.l('c3','c6','South') =    14.0000;
LoadOnLink.l('c3','c6','East') =     64.0000;
LoadOnLink.l('c3','c6','West') =     54.0000;
LoadOnLink.l('c3','c7','North') =    30.0000;
LoadOnLink.l('c3','c7','South') =      0   ;
LoadOnLink.l('c3','c7','East') =     64.0000;
LoadOnLink.l('c3','c7','West') =     54.0000;
LoadOnLink.l('c4','c0','North') =      0   ;
LoadOnLink.l('c4','c0','South') =    30.0000;
LoadOnLink.l('c4','c0','East') =     54.0000;
LoadOnLink.l('c4','c0','West') =     64.0000;
LoadOnLink.l('c4','c1','North') =    14.0000;
LoadOnLink.l('c4','c1','South') =    56.0000;
LoadOnLink.l('c4','c1','East') =     54.0000;
LoadOnLink.l('c4','c1','West') =     64.0000;
LoadOnLink.l('c4','c2','North') =    24.0000;
LoadOnLink.l('c4','c2','South') =    54.0000;
LoadOnLink.l('c4','c2','East') =     78.0000;
LoadOnLink.l('c4','c2','West') =     64.0000;
LoadOnLink.l('c4','c3','North') =    70.0000;
LoadOnLink.l('c4','c3','South') =    64.0000;
LoadOnLink.l('c4','c3','East') =     54.0000;
LoadOnLink.l('c4','c3','West') =     64.0000;
LoadOnLink.l('c4','c4','North') =    64.0000;
LoadOnLink.l('c4','c4','South') =    70.0000;
LoadOnLink.l('c4','c4','East') =     54.0000;
LoadOnLink.l('c4','c4','West') =     64.0000;
LoadOnLink.l('c4','c5','North') =    54.0000;
LoadOnLink.l('c4','c5','South') =    24.0000;
LoadOnLink.l('c4','c5','East') =     78.0000;
LoadOnLink.l('c4','c5','West') =     64.0000;
LoadOnLink.l('c4','c6','North') =    56.0000;
LoadOnLink.l('c4','c6','South') =    14.0000;
LoadOnLink.l('c4','c6','East') =     54.0000;
LoadOnLink.l('c4','c6','West') =     64.0000;
LoadOnLink.l('c4','c7','North') =    30.0000;
LoadOnLink.l('c4','c7','South') =      0   ;
LoadOnLink.l('c4','c7','East') =     54.0000;
LoadOnLink.l('c4','c7','West') =     64.0000;
LoadOnLink.l('c5','c0','North') =      0   ;
LoadOnLink.l('c5','c0','South') =    30.0000;
LoadOnLink.l('c5','c0','East') =     40.0000;
LoadOnLink.l('c5','c0','West') =     70.0000;
LoadOnLink.l('c5','c1','North') =    14.0000;
LoadOnLink.l('c5','c1','South') =    40.0000;
LoadOnLink.l('c5','c1','East') =     56.0000;
LoadOnLink.l('c5','c1','West') =     70.0000;
LoadOnLink.l('c5','c2','North') =    72.0000;
LoadOnLink.l('c5','c2','South') =    54.0000;
LoadOnLink.l('c5','c2','East') =     56.0000;
LoadOnLink.l('c5','c2','West') =     30.0000;
LoadOnLink.l('c5','c3','North') =    70.0000;
LoadOnLink.l('c5','c3','South') =    64.0000;
LoadOnLink.l('c5','c3','East') =     40.0000;
LoadOnLink.l('c5','c3','West') =     70.0000;
LoadOnLink.l('c5','c4','North') =    64.0000;
LoadOnLink.l('c5','c4','South') =    70.0000;
LoadOnLink.l('c5','c4','East') =     40.0000;
LoadOnLink.l('c5','c4','West') =     70.0000;
LoadOnLink.l('c5','c5','North') =    54.0000;
LoadOnLink.l('c5','c5','South') =    72.0000;
LoadOnLink.l('c5','c5','East') =     56.0000;
LoadOnLink.l('c5','c5','West') =     30.0000;
LoadOnLink.l('c5','c6','North') =    40.0000;
LoadOnLink.l('c5','c6','South') =    70.0000;
LoadOnLink.l('c5','c6','East') =     40.0000;
LoadOnLink.l('c5','c6','West') =     70.0000;
LoadOnLink.l('c5','c7','North') =    22.0000;
LoadOnLink.l('c5','c7','South') =      0   ;
LoadOnLink.l('c5','c7','East') =     56.0000;
LoadOnLink.l('c5','c7','West') =     70.0000;
LoadOnLink.l('c6','c0','North') =      0   ;
LoadOnLink.l('c6','c0','South') =    22.0000;
LoadOnLink.l('c6','c0','East') =     30.0000;
LoadOnLink.l('c6','c0','West') =     72.0000;
LoadOnLink.l('c6','c1','North') =    70.0000;
LoadOnLink.l('c6','c1','South') =    40.0000;
LoadOnLink.l('c6','c1','East') =     30.0000;
LoadOnLink.l('c6','c1','West') =     24.0000;
LoadOnLink.l('c6','c2','North') =    72.0000;
LoadOnLink.l('c6','c2','South') =    54.0000;
LoadOnLink.l('c6','c2','East') =     30.0000;
LoadOnLink.l('c6','c2','West') =     24.0000;
LoadOnLink.l('c6','c3','North') =    70.0000;
LoadOnLink.l('c6','c3','South') =    64.0000;
LoadOnLink.l('c6','c3','East') =     22.0000;
LoadOnLink.l('c6','c3','West') =     72.0000;
LoadOnLink.l('c6','c4','North') =    64.0000;
LoadOnLink.l('c6','c4','South') =    70.0000;
LoadOnLink.l('c6','c4','East') =     22.0000;
LoadOnLink.l('c6','c4','West') =     72.0000;
LoadOnLink.l('c6','c5','North') =    54.0000;
LoadOnLink.l('c6','c5','South') =    72.0000;
LoadOnLink.l('c6','c5','East') =     30.0000;
LoadOnLink.l('c6','c5','West') =     24.0000;
LoadOnLink.l('c6','c6','North') =    40.0000;
LoadOnLink.l('c6','c6','South') =    14.0000;
LoadOnLink.l('c6','c6','East') =     30.0000;
LoadOnLink.l('c6','c6','West') =     72.0000;
LoadOnLink.l('c6','c7','North') =    30.0000;
LoadOnLink.l('c6','c7','South') =      0   ;
LoadOnLink.l('c6','c7','East') =     30.0000;
LoadOnLink.l('c6','c7','West') =     24.0000;
LoadOnLink.l('c7','c0','North') =      0   ;
LoadOnLink.l('c7','c0','South') =    30.0000;
LoadOnLink.l('c7','c0','East') =       0   ;
LoadOnLink.l('c7','c0','West') =     14.0000;
LoadOnLink.l('c7','c1','North') =    14.0000;
LoadOnLink.l('c7','c1','South') =    56.0000;
LoadOnLink.l('c7','c1','East') =       0   ;
LoadOnLink.l('c7','c1','West') =     14.0000;
LoadOnLink.l('c7','c2','North') =    24.0000;
LoadOnLink.l('c7','c2','South') =    78.0000;
LoadOnLink.l('c7','c2','East') =       0   ;
LoadOnLink.l('c7','c2','West') =     14.0000;
LoadOnLink.l('c7','c3','North') =    30.0000;
LoadOnLink.l('c7','c3','South') =    64.0000;
LoadOnLink.l('c7','c3','East') =       0   ;
LoadOnLink.l('c7','c3','West') =     70.0000;
LoadOnLink.l('c7','c4','North') =    64.0000;
LoadOnLink.l('c7','c4','South') =    30.0000;
LoadOnLink.l('c7','c4','East') =       0   ;
LoadOnLink.l('c7','c4','West') =     70.0000;
LoadOnLink.l('c7','c5','North') =    78.0000;
LoadOnLink.l('c7','c5','South') =    24.0000;
LoadOnLink.l('c7','c5','East') =       0   ;
LoadOnLink.l('c7','c5','West') =     14.0000;
LoadOnLink.l('c7','c6','North') =    56.0000;
LoadOnLink.l('c7','c6','South') =    14.0000;
LoadOnLink.l('c7','c6','East') =       0   ;
LoadOnLink.l('c7','c6','West') =     14.0000;
LoadOnLink.l('c7','c7','North') =    30.0000;
LoadOnLink.l('c7','c7','South') =      0   ;
LoadOnLink.l('c7','c7','East') =       0   ;
LoadOnLink.l('c7','c7','West') =     14.0000;

L.l('c0','c0','North') =    0  ; 
L.l('c0','c0','South') =    0  ; 
L.l('c0','c0','East') =     0  ; 
L.l('c0','c0','West') =     0  ; 
L.l('c0','c1','North') =    0  ; 
L.l('c0','c1','South') =   1.0000;
L.l('c0','c1','East') =    1.0000;
L.l('c0','c1','West') =     0   ;
L.l('c0','c2','North') =   1.0000;
L.l('c0','c2','South') =   1.0000;
L.l('c0','c2','East') =     0   ;
L.l('c0','c2','West') =     0   ;
L.l('c0','c3','North') =   1.0000;
L.l('c0','c3','South') =    0   ;
L.l('c0','c3','East') =     0   ;
L.l('c0','c3','West') =     0   ;
L.l('c0','c4','North') =    0   ;
L.l('c0','c4','South') =   1.0000;
L.l('c0','c4','East') =     0   ;
L.l('c0','c4','West') =     0   ;
L.l('c0','c5','North') =   1.0000;
L.l('c0','c5','South') =    0   ;
L.l('c0','c5','East') =    1.0000;
L.l('c0','c5','West') =     0   ;
L.l('c0','c6','North') =    0   ;
L.l('c0','c6','South') =    0   ;
L.l('c0','c6','East') =     0   ;
L.l('c0','c6','West') =     0   ;
L.l('c0','c7','North') =    0   ;
L.l('c0','c7','South') =    0   ;
L.l('c0','c7','East') =     0   ;
L.l('c0','c7','West') =     0   ;
L.l('c1','c0','North') =    0   ;
L.l('c1','c0','South') =    0   ;
L.l('c1','c0','East') =     0   ;
L.l('c1','c0','West') =     0   ;
L.l('c1','c1','North') =    0   ;
L.l('c1','c1','South') =    0   ;
L.l('c1','c1','East') =    1.0000;
L.l('c1','c1','West') =    1.0000;
L.l('c1','c2','North') =    0   ;
L.l('c1','c2','South') =   1.0000;
L.l('c1','c2','East') =     0   ;
L.l('c1','c2','West') =     0   ;
L.l('c1','c3','North') =   1.0000;
L.l('c1','c3','South') =    0   ;
L.l('c1','c3','East') =    1.0000;
L.l('c1','c3','West') =     0   ;
L.l('c1','c4','North') =    0   ;
L.l('c1','c4','South') =   1.0000;
L.l('c1','c4','East') =     0   ;
L.l('c1','c4','West') =     0   ;
L.l('c1','c5','North') =   1.0000;
L.l('c1','c5','South') =   1.0000;
L.l('c1','c5','East') =    1.0000;
L.l('c1','c5','West') =    1.0000;
L.l('c1','c6','North') =   1.0000;
L.l('c1','c6','South') =   1.0000;
L.l('c1','c6','East') =     0   ;
L.l('c1','c6','West') =     0   ;
L.l('c1','c7','North') =   1.0000;
L.l('c1','c7','South') =    0   ;
L.l('c1','c7','East') =    1.0000;
L.l('c1','c7','West') =     0   ;
L.l('c2','c0','North') =    0   ;
L.l('c2','c0','South') =    0   ;
L.l('c2','c0','East') =    1.0000;
L.l('c2','c0','West') =     0   ;
L.l('c2','c1','North') =    0   ;
L.l('c2','c1','South') =   0   ;
L.l('c2','c1','East') =   1.0000;
L.l('c2','c1','West') =   1.0000;
L.l('c2','c2','North') =   0   ;
L.l('c2','c2','South') =  1.0000;
L.l('c2','c2','East') =   1.0000;
L.l('c2','c2','West') =    0   ;
L.l('c2','c3','North') =  1.0000;
L.l('c2','c3','South') =   0   ;
L.l('c2','c3','East') =   1.0000;
L.l('c2','c3','West') =   1.0000;
L.l('c2','c4','North') =   0   ;
L.l('c2','c4','South') =  1.0000;
L.l('c2','c4','East') =   1.0000;
L.l('c2','c4','West') =    0   ;
L.l('c2','c5','North') =  1.0000;
L.l('c2','c5','South') =  1.0000;
L.l('c2','c5','East') =   1.0000;
L.l('c2','c5','West') =   1.0000;
L.l('c2','c6','North') =  1.0000;
L.l('c2','c6','South') =   0   ;
L.l('c2','c6','East') =   1.0000;
L.l('c2','c6','West') =    0   ;
L.l('c2','c7','North') =   0   ;
L.l('c2','c7','South') =   0   ;
L.l('c2','c7','East') =   1.0000;
L.l('c2','c7','West') =   1.0000;
L.l('c3','c0','North') =   0   ;
L.l('c3','c0','South') =  1.0000;
L.l('c3','c0','East') =    0   ;
L.l('c3','c0','West') =   1.0000;
L.l('c3','c1','North') =  1.0000;
L.l('c3','c1','South') =  1.0000;
L.l('c3','c1','East') =    0   ;
L.l('c3','c1','West') =   1.0000;
L.l('c3','c2','North') =  1.0000;
L.l('c3','c2','South') =  1.0000;
L.l('c3','c2','East') =    0   ;
L.l('c3','c2','West') =   1.0000;
L.l('c3','c3','North') =  1.0000;
L.l('c3','c3','South') =   0   ;
L.l('c3','c3','East') =    0   ;
L.l('c3','c3','West') =   1.0000;
L.l('c3','c4','North') =   0   ;
L.l('c3','c4','South') =  1.0000;
L.l('c3','c4','East') =    0   ;
L.l('c3','c4','West') =   1.0000;
L.l('c3','c5','North') =  1.0000;
L.l('c3','c5','South') =   0   ;
L.l('c3','c5','East') =    0   ;
L.l('c3','c5','West') =   1.0000;
L.l('c3','c6','North') =   0   ;
L.l('c3','c6','South') =   0   ;
L.l('c3','c6','East') =    0   ;
L.l('c3','c6','West') =   1.0000;
L.l('c3','c7','North') =   0   ;
L.l('c3','c7','South') =   0   ;
L.l('c3','c7','East') =    0   ;
L.l('c3','c7','West') =   1.0000;
L.l('c4','c0','North') =   0   ;
L.l('c4','c0','South') =   0   ;
L.l('c4','c0','East') =   1.0000;
L.l('c4','c0','West') =    0   ;
L.l('c4','c1','North') =   0   ;
L.l('c4','c1','South') =   0   ;
L.l('c4','c1','East') =   1.0000;
L.l('c4','c1','West') =    0   ;
L.l('c4','c2','North') =   0   ;
L.l('c4','c2','South') =  1.0000;
L.l('c4','c2','East') =   1.0000;
L.l('c4','c2','West') =    0   ;
L.l('c4','c3','North') =  1.0000;
L.l('c4','c3','South') =   0   ;
L.l('c4','c3','East') =   1.0000;
L.l('c4','c3','West') =    0   ;
L.l('c4','c4','North') =   0   ;
L.l('c4','c4','South') =  1.0000;
L.l('c4','c4','East') =   1.0000;
L.l('c4','c4','West') =    0   ;
L.l('c4','c5','North') =  1.0000;
L.l('c4','c5','South') =   0   ;
L.l('c4','c5','East') =   1.0000;
L.l('c4','c5','West') =    0   ;
L.l('c4','c6','North') =   0   ;
L.l('c4','c6','South') =   0   ;
L.l('c4','c6','East') =   1.0000;
L.l('c4','c6','West') =    0   ;
L.l('c4','c7','North') =   0   ;
L.l('c4','c7','South') =   0   ;
L.l('c4','c7','East') =   1.0000;
L.l('c4','c7','West') =    0   ;
L.l('c5','c0','North') =   0   ;
L.l('c5','c0','South') =   0   ;
L.l('c5','c0','East') =   1.0000;
L.l('c5','c0','West') =   1.0000;
L.l('c5','c1','North') =   0   ;
L.l('c5','c1','South') =  1.0000;
L.l('c5','c1','East') =    0   ;
L.l('c5','c1','West') =   1.0000;
L.l('c5','c2','North') =  1.0000;
L.l('c5','c2','South') =  1.0000;
L.l('c5','c2','East') =    0   ;
L.l('c5','c2','West') =   1.0000;
L.l('c5','c3','North') =  1.0000;
L.l('c5','c3','South') =   0   ;
L.l('c5','c3','East') =   1.0000;
L.l('c5','c3','West') =   1.0000;
L.l('c5','c4','North') =   0   ;
L.l('c5','c4','South') =  1.0000;
L.l('c5','c4','East') =   1.0000;
L.l('c5','c4','West') =   1.0000;
L.l('c5','c5','North') =  1.0000;
L.l('c5','c5','South') =  1.0000;
L.l('c5','c5','East') =    0   ;
L.l('c5','c5','West') =   1.0000;
L.l('c5','c6','North') =  1.0000;
L.l('c5','c6','South') =  1.0000;
L.l('c5','c6','East') =   1.0000;
L.l('c5','c6','West') =   1.0000;
L.l('c5','c7','North') =  1.0000;
L.l('c5','c7','South') =   0   ;
L.l('c5','c7','East') =    0   ;
L.l('c5','c7','West') =   1.0000;
L.l('c6','c0','North') =   0   ;
L.l('c6','c0','South') =  1.0000;
L.l('c6','c0','East') =    0   ;
L.l('c6','c0','West') =   1.0000;
L.l('c6','c1','North') =  1.0000;
L.l('c6','c1','South') =  1.0000;
L.l('c6','c1','East') =    0   ;
L.l('c6','c1','West') =    0   ;
L.l('c6','c2','North') =  1.0000;
L.l('c6','c2','South') =  1.0000;
L.l('c6','c2','East') =    0   ;
L.l('c6','c2','West') =    0   ;
L.l('c6','c3','North') =  1.0000;
L.l('c6','c3','South') =   0   ;
L.l('c6','c3','East') =   1.0000;
L.l('c6','c3','West') =   1.0000;
L.l('c6','c4','North') =   0   ;
L.l('c6','c4','South') =  1.0000;
L.l('c6','c4','East') =   1.0000;
L.l('c6','c4','West') =   1.0000;
L.l('c6','c5','North') =  1.0000;
L.l('c6','c5','South') =  1.0000;
L.l('c6','c5','East') =    0   ;
L.l('c6','c5','West') =    0   ;
L.l('c6','c6','North') =  1.0000;
L.l('c6','c6','South') =   0   ;
L.l('c6','c6','East') =    0   ;
L.l('c6','c6','West') =   1.0000;
L.l('c6','c7','North') =   0   ;
L.l('c6','c7','South') =   0   ;
L.l('c6','c7','East') =    0   ;
L.l('c6','c7','West') =    0   ;
L.l('c7','c0','North') =   0   ;
L.l('c7','c0','South') =   0   ;
L.l('c7','c0','East') =    0   ;
L.l('c7','c0','West') =    0   ;
L.l('c7','c1','North') =   0   ;
L.l('c7','c1','South') =   0   ;
L.l('c7','c1','East') =    0   ;
L.l('c7','c1','West') =    0   ;
L.l('c7','c2','North') =   0   ;
L.l('c7','c2','South') =  1.0000;
L.l('c7','c2','East') =    0   ;
L.l('c7','c2','West') =    0   ;
L.l('c7','c3','North') =  1.0000;
L.l('c7','c3','South') =   0   ;
L.l('c7','c3','East') =    0   ;
L.l('c7','c3','West') =   1.0000;
L.l('c7','c4','North') =   0   ;
L.l('c7','c4','South') =  1.0000;
L.l('c7','c4','East') =    0   ;
L.l('c7','c4','West') =   1.0000;
L.l('c7','c5','North') =  1.0000;
L.l('c7','c5','South') =   0   ;
L.l('c7','c5','East') =    0   ;
L.l('c7','c5','West') =    0   ;
L.l('c7','c6','North') =   0   ;
L.l('c7','c6','South') =   0   ;
L.l('c7','c6','East') =    0   ;
L.l('c7','c6','West') =    0   ;
L.l('c7','c7','North') =   0   ;
L.l('c7','c7','South') =   0   ;
L.l('c7','c7','East') =    0   ;
L.l('c7','c7','West') =    0   ;

z.l = 0.015625;
t.l = 0.015625;

TotalWideLinks                     ..  sum((x,y,direction), L(x,y,direction)) =l= 2 * mesh_dimension * (mesh_dimension-1);
CapacityPathRatio(x,y,direction)   ..  (L(x,y,direction) + 1) =g= LoadOnLink(x,y,direction) * z;

NoWestLink(y)                      ..  L('c0',y,'West') =e= 0;
NoEastLink(y)                      ..  L('c7',y,'East') =e= 0;
NoNorthLink(x)                     ..  L(x,'c0','North') =e= 0;
NoSouthLink(x)                     ..  L(x,'c7','South') =e= 0;

SymmetricLinkWidthY(x,y)           ..  L(x,y,'North') =e= L(x,y-1,'South');
SymmetricLinkWidthX(x,y)           ..  L(x,y,'East') =e= L(x+1,y,'West');

PlaceControllers                   ..  sum((x,y), hasMemoryController(x,y)) =e= num_memory_controllers;

LoadOnChannel(x,y,direction)       ..  LoadOnLink(x,y,direction)  
                                         =e= sum((px,py,mx,my), hasMemoryController(mx,my)*( mesh_link_for_request(px,py,mx,my,x,y,direction)
                                                                                        + mesh_link_for_reply(mx,my,px,py,x,y,direction)));
Objective                          ..  z =e= t;
z.up  = 0.0173;

Model MeshDesign /all/;
Option MIP = Gurobi;
Option minlp = Baron;
Option nlp = knitro;
MeshDesign.optcr=0.0001
Option sysout  = on;
option reslim = 216000;
MeshDesign.Workspace = 960;

num_memory_controllers = 16;
solve MeshDesign using minlp maximizing t;