option limrow = 100, limcol = 100;
$setglobal mesh_radix  7

Sets
  coor         router's coordinates / c0*c%mesh_radix% /
  direction    the four directions /North, South, East, West/
  dirIn        the four directions /North, West, East, South, Cache, Directory/
  dirOut       the four directions /North, South, East, West, Cache, Directory/
;

alias(coor, x, y, px, py, mx, my);

parameter mesh_dimension;
mesh_dimension = 8;
parameter num_memory_controllers;
parameter buffer_budget;
parameter PathsPerInOut(x,y,dirIn,dirOut);

$include link_contention.txt

Variables
  hasMemoryController(x,y)    coordinates x y have a memory controller
  LoadOnLink(x,y,direction)   load on channel x y direction

  LinkCap(x,y,direction)      binary variable denoting whether x y direction link is wide or narrow
  z                           variable that lower bounds the ratio of capacity and count for any link
  t
;

Binary variable hasMemoryController;
Binary variable LinkCap;
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
  PlaceControllersRow(x,y)
  PlaceControllersCol(x,y)

  LoadOnChannel(x,y,direction)        compute the load on each channel
  Objective
;

TotalWideLinks                   .. sum((x,y,direction), LinkCap(x,y,direction)) =l= 2 * mesh_dimension * (mesh_dimension-1);
CapacityPathRatio(x,y,direction) .. (LinkCap(x,y,direction) + 1) =g= LoadOnLink(x,y,direction) * z;

NoWestLink(y)                    .. LinkCap('c0',y,'West') =e= 0;
NoEastLink(y)                    .. LinkCap('c7',y,'East') =e= 0;
NoNorthLink(x)                   .. LinkCap(x,'c0','North') =e= 0;
NoSouthLink(x)                   .. LinkCap(x,'c7','South') =e= 0;

SymmetricLinkWidthY(x,y)         .. LinkCap(x,y,'North') =e= LinkCap(x,y-1,'South');
SymmetricLinkWidthX(x,y)         .. LinkCap(x,y,'East') =e= LinkCap(x+1,y,'West');

PlaceControllers                 .. sum((x,y), hasMemoryController(x,y)) =e= num_memory_controllers;
*PlaceControllersRow(x)           .. sum(y, hasMemoryController(x,y)) =l= 3;
*PlaceControllersCol(y)           .. sum(x, hasMemoryController(x,y)) =l= 3;
PlaceControllersCol(x,y)          .. hasMemoryController(x,y) + hasMemoryController(x,y+1) =l= 1;
PlaceControllersRow(x,y)          .. hasMemoryController(x,y) + hasMemoryController(x+1,y) =l= 1;

LoadOnChannel(x,y,direction)     .. LoadOnLink(x,y,direction)
                                      =e= sum((px,py,mx,my), hasMemoryController(mx,my)*( mesh_link_for_request(px,py,mx,my,x,y,direction)
                                                                                         +mesh_link_for_reply(mx,my,px,py,x,y,direction)));

Objective                        .. z =e= t;

num_memory_controllers = 16;
LoadOnLink.up(x,y,direction) = num_memory_controllers *  mesh_dimension * 2;
z.up  = 0.02084;

*******************************************************************************************

parameter vc_budget;

Variables
    VCount(x,y,dirIn)
    Vp(x,y,dirIn)
    s
;
Integer variable Vp;
positive variable VCount;
positive variable s;

Equations
    TotalVC
    MaximumVC(x,y,dirIn)
    MaximumDirVC(x,y)
    MultipleTwo(x,y,dirIn)

    VCPathRatioNorth(x,y)
    VCPathRatioSouth(x,y)
    VCPathRatioWest(x,y)
    VCPathRatioEast(x,y)
    VCPathRatioCache(x,y)
    VCPathRatioDir(x,y)

    NoVCForWestInput(y)
    NoVCForEastInput(y)
    NoVCForNorthInput(x)
    NoVCForSouthInput(x)
    PositiveVC(x,y,dirIn)

    CombinedObjective
;

TotalVC                 .. sum((x,y,dirIn), VCount(x,y,dirIn)) =l= vc_budget;
MaximumVC(x,y,dirIn)    .. VCount(x,y,dirIn) =l= 6;
MaximumDirVC(x,y)       .. VCount(x,y,'Directory') =l= hasMemoryController(x,y) * 6;
MultipleTwo(x,y,dirIn)  .. VCount(x,y,dirIn) =e= 2 * Vp(x,y,dirIn);

VCPathRatioNorth(x,y)   .. Vp(x,y,'North') =g= s * LoadOnLink(x,y-1,'South');
VCPathRatioSouth(x,y)   .. Vp(x,y,'South') =g= s * LoadOnLink(x,y+1,'North');
VCPathRatioWest(x,y)    .. Vp(x,y,'West')  =g= s * LoadOnLink(x-1,y,'East');
VCPathRatioEast(x,y)    .. Vp(x,y,'East')  =g= s * LoadOnLink(x+1,y,'West');

VCPathRatioCache(x,y)   .. Vp(x,y,'Cache') =g= s * num_memory_controllers;
VCPathRatioDir(x,y)     .. Vp(x,y,'Directory') =g= s * mesh_dimension * mesh_dimension * hasMemoryController(x,y);

NoVCForWestInput(y)     .. Vp('c0',y,'West') =e= 0;
NoVCForEastInput(y)     .. Vp('c7',y,'East') =e= 0;
NoVCForNorthInput(x)    .. Vp(x,'c0','North') =e= 0;
NoVCForSouthInput(x)    .. Vp(x,'c7','South') =e= 0;
PositiveVC(x,y,dirIn)$(not ( (sameas('c0', x) and sameas('West', dirIn)) or
                             (sameas('c7', x) and sameas('East', dirIn)) or
                             (sameas('c0', y) and sameas('North', dirIn)) or
                             (sameas('c7', y) and sameas('South', dirIn)) or
                             (sameas(dirIn, 'Directory'))))
                        .. Vp(x,y,dirIn) =g= 1;

CombinedObjective       ..  z + s =e= t;
VCount.up(x,y,dirIn) = 6;
Vp.up(x,y,dirIn) = 3;
s.up = 0.04;

***********************************************************************************
$include initial_solution.txt

Option MIP = Gurobi;
Option minlp = Baron;
Option nlp = knitro;

Model MeshDesignLinksOnly /
                            TotalWideLinks, CapacityPathRatio,
                            NoWestLink, NoEastLink, NoNorthLink, NoSouthLink,
                            SymmetricLinkWidthY, SymmetricLinkWidthX,
                            PlaceControllers, PlaceControllersRow,
                            PlaceControllersCol,
                            LoadOnChannel, Objective
                        /;

MeshDesignLinksOnly.optcr=0.0001;
Option sysout  = on;
option reslim = 216000;
MeshDesignLinksOnly.Workspace = 960;
**solve MeshDesignLinksOnly using minlp maximizing t;

Model MeshDesignLinksRouters /
                                TotalWideLinks, CapacityPathRatio,
                                NoWestLink, NoEastLink, NoNorthLink, NoSouthLink,
                                SymmetricLinkWidthY, SymmetricLinkWidthX,
                                PlaceControllers,
                                PlaceControllersRow,
                                PlaceControllersCol,
                                LoadOnChannel,

                                TotalVC, MaximumVC, MaximumDirVC,
                                MultipleTwo, VCPathRatioNorth,
                                VCPathRatioSouth, VCPathRatioWest, VCPathRatioEast,
                                VCPathRatioCache, VCPathRatioDir,
                                NoVCForWestInput, NoVCForEastInput,
                                NoVCForNorthInput, NoVCForSouthInput,
                                PositiveVC,

                                CombinedObjective
                            /;

vc_budget = 960;
**t.up = 0.0515;
MeshDesignLinksRouters.optcr=0.000;
MeshDesignLinksRouters.optca=0.000;
MeshDesignLinksRouters.Workspace = 960;
**solve MeshDesignLinksRouters using minlp maximizing t;

option minlp=dicopt;
MeshDesignLinksRouters.optfile=1;
solve MeshDesignLinksRouters using minlp maximizing t;

file linkFile /link_output.txt/ ;
put linkFile;
loop((x,y,direction), put x.tl:3, y.tl:3, direction.tl:6, LinkCap.l(x,y,direction):1:0 /);

file vcFile /vc_output.txt/ ;
put vcFile;
loop((x,y,dirIn), put x.tl:3, y.tl:3, dirIn.tl:10, VCount.l(x,y,dirIn):2:0 /);
