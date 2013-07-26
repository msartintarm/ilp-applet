option limrow = 1000, limcol = 1000;
$setglobal mesh_radix  7

Sets
  coor         router's coordinates / c0*c%mesh_radix% /
  direction    the four directions /North, South, East, West/
  Port         the router ports /North, West, East, South, Cache, Directory/
;

alias(coor, x, y, px, py, mx, my);

********************************************************************
***** Variables and Constratints related to Memory Controllers *****
********************************************************************

parameter mesh_dimension;
parameter num_memory_controllers;
parameter max_load_on_link;

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
positive variable LoadOnLink;
positive variable z;

Equations
  TotalWideLinks                      limit the total number of wide links
  CapacityPathRatio(x,y,direction)    bound the ratio of capacity and path count for any link

**** Under the assumption that the link width can only take two values,
**** we can linearize the above constraint.
  CapacityFixedConstraint(x,y,direction)
  CapacityVariableConstraint(x,y,direction)

  NoWestLink(y)                       Set L to zero for links with 0 x coordinate and direction West
  NoEastLink(y)                       Set L to zero for links with 7 x coordinate and direction East
  NoNorthLink(x)                      Set L to zero for links with 0 y coordinate and direction North
  NoSouthLink(x)                      Set L to zero for links with 7 y coordinate and direction South

  SymmetricLinkWidthY(x,y)            Y direction Links are symmetric
  SymmetricLinkWidthX(x,y)            X direction Links are symmetric

  PlaceControllers                    Constrain all the controllers to be placed
  PlaceControllersRow(x,y)            Constrain that controllers are not back to back in a row
  PlaceControllersCol(x,y)            Constrain controllers to not be placed in consecutive columns

  LoadOnChannel(x,y,direction)        compute the load on each channel
  Objective
;

TotalWideLinks
    .. sum((x,y,direction), LinkCap(x,y,direction)) =l= 2 * mesh_dimension * (mesh_dimension-1);

CapacityPathRatio(x,y,direction)
    .. (LinkCap(x,y,direction) + 1) =g= LoadOnLink(x,y,direction) * z;
CapacityFixedConstraint(x,y,direction)
    ..  z =g= LoadOnLink(x,y,direction) / 2;
CapacityVariableConstraint(x,y,direction)
    ..  max_load_on_link * LinkCap(x,y,direction) + z =g= LoadOnLink(x,y,direction);

NoWestLink(y)
    .. LinkCap('c0',y,'West') =e= 0;
NoEastLink(y)
    .. LinkCap('c7',y,'East') =e= 0;
NoNorthLink(x)
    .. LinkCap(x,'c0','North') =e= 0;
NoSouthLink(x)
    .. LinkCap(x,'c7','South') =e= 0;

SymmetricLinkWidthY(x,y)
    .. LinkCap(x,y,'North') =e= LinkCap(x,y-1,'South');
SymmetricLinkWidthX(x,y)
    .. LinkCap(x,y,'East') =e= LinkCap(x+1,y,'West');

PlaceControllers
    .. sum((x,y), hasMemoryController(x,y)) =e= num_memory_controllers;
PlaceControllersRow(x,y)
    .. hasMemoryController(x,y) + hasMemoryController(x+1,y) =l= 1;
PlaceControllersCol(x,y)
    .. hasMemoryController(x,y) + hasMemoryController(x,y+1) =l= 1;

LoadOnChannel(x,y,direction)
    .. LoadOnLink(x,y,direction) =e= sum((px,py,mx,my),
                                        hasMemoryController(mx,my)*( mesh_link_for_request(px,py,mx,my,x,y,direction)
                                                                    +mesh_link_for_reply(mx,my,px,py,x,y,direction)));

Objective
    .. z =e= t;

mesh_dimension = 8;
num_memory_controllers = 16;
* max_load_on_link = 2 * mesh_dimension * mesh_dimension * num_memory_controllers;
max_load_on_link = 2 * 81;

LoadOnLink.up(x,y,direction) = max_load_on_link;
z.up  = 81;


******************************************************************
***** Variables and Constratints related to Virtual Channels *****
******************************************************************

$setglobal max_vp 3
parameter vc_budget;
parameter max_vc;

set domVp /v0 * v%max_vp%/;

Variables
*   virtual channel count for a link

    VCount(x,y,Port)

*   since we want to have two virtual networks, we need VCount to be a
*   multiple of two. Vp can take any natural number as value.
*   We set VCount = 2 * Vp

    Vp(x,y,Port)

*   Maximum load per virtual channel

    LVC

*   Binary variables for number of virtual channels associated with a link
    Ivp(x,y,Port,domVp)

*   Positive variable for linearizing the bilinear constraint, stolen from
*   implementation provided by Prof. Ferris.
    Wvp(x,y,Port)
    Fvp(x,y,Port, domVp)
;

Integer variable Vp;
positive variable VCount;
positive variable LVC;
Binary variable Ivp;
positive variable Wvp;
positive variable Fvp;

Equations
*   Constrain the total number of virtual channels with a budget

    TotalVC

*   Constrain the maximum number of virtual channels a particular link
*   can have

    MaximumVC(x,y,Port)

*   Constrain that the directory port can have virtual channels only
*   if a memory controller is located at that location

    MaximumDirVC(x,y)

*   Since we need two virtual networks, constrain that VCount is twice Vp

    MultipleTwo(x,y,Port)

*   These constraints are for allocating the virtual channels in proportion
*   to the traffic observed by a link.

    VCPathRatioNorth(x,y)
    VCPathRatioSouth(x,y)
    VCPathRatioWest(x,y)
    VCPathRatioEast(x,y)
    VCPathRatioCache(x,y)
    VCPathRatioDir(x,y)

*   These constraints prevent allocation of virtual channels to links that
*   do not exist. These links should have zero traffic and hence no
*   virtual channels. If I recall correctly, I have seen some of them being
*   assigned virtual channels, most likely because it did not really matter
*   to which links the virtual channels were assigned. Hence, these
*   constraints were added to bar the solver from doing such assignments.

    NoVCForWestInput(y)
    NoVCForEastInput(y)
    NoVCForNorthInput(x)
    NoVCForSouthInput(x)

*   Even this constraint seems unnecessary. It was added so that even if a
*   particular link was used at all in a given traffic ditribution, still it
*   has virtual channels so that it can be used in another distribution.

    PositiveVC(x,y,Port)

*   Linear inequalities for relating number of virtual channels and load on a link
*   These inequalities are based on the assumption that only a maximum of 6 virtual
*   channels can be assigned to a link.

    VCPathRatioNorth_1(x,y,domVp)
    VCPathRatioSouth_1(x,y,domVp)
    VCPathRatioWest_1(x,y,domVp) 
    VCPathRatioEast_1(x,y,domVp) 
    VCPathRatioCache_1(x,y,domVp)
    VCPathRatioDir_1(x,y,domVp)

    VCPathRatioNorth_2(x,y)
    VCPathRatioSouth_2(x,y)
    VCPathRatioWest_2(x,y) 
    VCPathRatioEast_2(x,y) 
    VCPathRatioCache_2(x,y)
    VCPathRatioDir_2(x,y)

*   Set the Vp value based on the Ivps
    SetVp(x,y,Port)
    LimitIvp(x,y,Port)
    SetWvp(x,y,Port)

    Bound1(x,y,Port,domVp)
    Bound2(x,y,Port,domVp)
    Bound3(x,y,Port,domVp)

    CombinedObjective
;

TotalVC                     .. sum((x,y,Port), VCount(x,y,Port)) =l= vc_budget;
MaximumVC(x,y,Port)         .. VCount(x,y,Port) =l= max_vc;
MaximumDirVC(x,y)           .. VCount(x,y,'Directory') =l= hasMemoryController(x,y) * max_vc;
MultipleTwo(x,y,Port)       .. VCount(x,y,Port) =e= 2 * Vp(x,y,Port);

VCPathRatioNorth(x,y)       .. LVC * Vp(x,y,'North') =g= LoadOnLink(x,y-1,'South');
VCPathRatioSouth(x,y)       .. LVC * Vp(x,y,'South') =g= LoadOnLink(x,y+1,'North');
VCPathRatioWest(x,y)        .. LVC * Vp(x,y,'West')  =g= LoadOnLink(x-1,y,'East');
VCPathRatioEast(x,y)        .. LVC * Vp(x,y,'East')  =g= LoadOnLink(x+1,y,'West');

VCPathRatioNorth_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + max_load_on_link * (1 - Ivp(x,y,'North', domVp)) =g= LoadOnLink(x,y-1,'South');
VCPathRatioSouth_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + max_load_on_link * (1 - Ivp(x,y,'South', domVp)) =g= LoadOnLink(x,y+1,'North');
VCPathRatioWest_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + max_load_on_link * (1 - Ivp(x,y,'West', domVp))  =g= LoadOnLink(x-1,y,'East');
VCPathRatioEast_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + max_load_on_link * (1 - Ivp(x,y,'East', domVp))  =g= LoadOnLink(x+1,y,'West');

VCPathRatioNorth_2(x,y)     .. Wvp(x,y,'North') =g= LoadOnLink(x,y-1,'South');
VCPathRatioSouth_2(x,y)     .. Wvp(x,y,'South') =g= LoadOnLink(x,y+1,'North');
VCPathRatioWest_2(x,y)      .. Wvp(x,y,'West')  =g= LoadOnLink(x-1,y,'East');
VCPathRatioEast_2(x,y)      .. Wvp(x,y,'East')  =g= LoadOnLink(x+1,y,'West');

VCPathRatioCache(x,y)         .. LVC * Vp(x,y,'Cache') =g= num_memory_controllers;
VCPathRatioCache_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + num_memory_controllers * (1 - Ivp(x,y,'Cache',domVp)) =g= num_memory_controllers;
VCPathRatioCache_2(x,y)       .. Wvp(x,y,'Cache')      =g= num_memory_controllers;


VCPathRatioDir(x,y)         .. LVC * Vp(x,y,'Directory') =g= mesh_dimension * mesh_dimension * hasMemoryController(x,y);
VCPathRatioDir_1(x,y,domVp)
        .. (domVp.ord - 1) * LVC + mesh_dimension * mesh_dimension * (1 - Ivp(x,y,'Directory', domVp))
                                                                    =g= mesh_dimension * mesh_dimension * hasMemoryController(x,y);
VCPathRatioDir_2(x,y)       .. Wvp(x,y,'Directory')      =g= mesh_dimension * mesh_dimension * hasMemoryController(x,y);


NoVCForWestInput(y)         .. Vp('c0',y,'West') =e= 0;
NoVCForEastInput(y)         .. Vp('c7',y,'East') =e= 0;
NoVCForNorthInput(x)        .. Vp(x,'c0','North') =e= 0;
NoVCForSouthInput(x)        .. Vp(x,'c7','South') =e= 0;

PositiveVC(x,y,Port)$(not ( (sameas('c0', x) and sameas('West', Port)) or
                            (sameas('c7', x) and sameas('East', Port)) or
                            (sameas('c0', y) and sameas('North', Port)) or
                            (sameas('c7', y) and sameas('South', Port)) or
                            (sameas(Port, 'Directory'))))
                            .. Vp(x,y,Port) =g= 1;

SetVp(x,y,Port)               .. Vp(x,y,Port) =e= sum(domVp, (domVp.ord - 1) * Ivp(x,y,Port, domVp));
LimitIvp(x,y,Port)            .. sum(domVp, Ivp(x,y,Port, domVp)) =e= 1;
SetWvp(x,y,Port)              .. Wvp(x,y,Port) =e= sum(domVp, (domVp.ord - 1) * Fvp(x,y,Port, domVp));

Bound1(x,y,Port,domVp)        .. Fvp(x,y,Port,domVp) =l= max_load_on_link * Ivp(x,y,Port,domVp);
Bound2(x,y,Port,domVp)        .. Fvp(x,y,Port,domVp) =l= LVC;
Bound3(x,y,Port,domVp)        .. Fvp(x,y,Port,domVp) =g= LVC + max_load_on_link * Ivp(x,y,Port,domVp) - max_load_on_link;

CombinedObjective           ..  z + LVC =e= t;

max_vc = 2 * %max_vp%;
VCount.up(x,y,Port) = max_vc;
Vp.up(x,y,Port) = %max_vp%;
LVC.lo = 1;
LVC.up = max_load_on_link;
vc_budget = 960;

*******************************************************************************
$include initial_solution.txt

Option MIP = Gurobi;
Option minlp = Baron;
Option nlp = knitro;
Option sysout  = on;
Option reslim = 216000;

*******************************************************************************
Model MeshDesignLinksOnly /
                            TotalWideLinks, CapacityPathRatio,
                            NoWestLink, NoEastLink, NoNorthLink, NoSouthLink,
                            SymmetricLinkWidthY, SymmetricLinkWidthX,
                            PlaceControllers, PlaceControllersRow,
                            PlaceControllersCol,
                            LoadOnChannel, Objective
                        /;

MeshDesignLinksOnly.optcr=0.0001;
MeshDesignLinksOnly.Workspace = 960;
*solve MeshDesignLinksOnly using minlp maximizing t;


*******************************************************************************
Model LinearMeshDesignLinksOnly /
                            TotalWideLinks,
                            CapacityFixedConstraint, CapacityVariableConstraint,
                            NoWestLink, NoEastLink, NoNorthLink, NoSouthLink,
                            SymmetricLinkWidthY, SymmetricLinkWidthX,
                            PlaceControllers, PlaceControllersRow,
                            PlaceControllersCol,
                            LoadOnChannel, Objective
                        /;
LinearMeshDesignLinksOnly.optcr=0.0001;
LinearMeshDesignLinksOnly.optfile=1;
LinearMeshDesignLinksOnly.Workspace = 12000;
* solve LinearMeshDesignLinksOnly using mip minimizing t;

*******************************************************************************
Model MeshDesignLinksRouters /
                                TotalWideLinks,
*                                CapacityPathRatio,
                                CapacityFixedConstraint, CapacityVariableConstraint,
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
*                                SetVp, LimitIvp

                                CombinedObjective
                            /;

MeshDesignLinksRouters.optcr=0.000;
MeshDesignLinksRouters.optca=0.000;
MeshDesignLinksRouters.Workspace = 9600;
*solve MeshDesignLinksRouters using minlp minimizing t;

*******************************************************************************
Model MeshDesignLinearLinksRouters /
                                TotalWideLinks,
                                CapacityFixedConstraint, CapacityVariableConstraint,
                                NoWestLink, NoEastLink, NoNorthLink, NoSouthLink,
                                SymmetricLinkWidthY, SymmetricLinkWidthX,
                                PlaceControllers,
                                PlaceControllersRow,
                                PlaceControllersCol,
                                LoadOnChannel,

                                TotalVC, MaximumVC, MaximumDirVC,
                                MultipleTwo, 

                                VCPathRatioNorth_1, VCPathRatioSouth_1,
                                VCPathRatioWest_1, VCPathRatioEast_1,
                                VCPathRatioCache_1, VCPathRatioDir_1,

*                                VCPathRatioNorth_2, VCPathRatioSouth_2,
*                                VCPathRatioWest_2, VCPathRatioEast_2,
*                                VCPathRatioCache_2, VCPathRatioDir_2,

                                SetVp, LimitIvp,
*                                SetWvp, Bound1, Bound2, Bound3

                                NoVCForWestInput, NoVCForEastInput,
                                NoVCForNorthInput, NoVCForSouthInput,
                                PositiveVC,

                                CombinedObjective
                            /;

MeshDesignLinearLinksRouters.optcr=0.000;
MeshDesignLinearLinksRouters.optca=0.000;
MeshDesignLinearLinksRouters.Workspace = 12000;
MeshDesignLinearLinksRouters.optfile=1;
solve MeshDesignLinearLinksRouters using mip minimizing t;

*******************************************************************************
Option minlp=dicopt;
MeshDesignLinksRouters.optfile=1;
**solve MeshDesignLinksRouters using minlp maximizing t;

*******************************************************************************
***************************  Write Output to files ****************************
*******************************************************************************
file linkFile /link_output.txt/ ;
put linkFile;
loop((x,y,direction), put x.tl:3, y.tl:3, direction.tl:6, LinkCap.l(x,y,direction):1:0 /);

file vcFile /vc_output.txt/ ;
put vcFile;
loop((x,y,Port), put x.tl:3, y.tl:3, Port.tl:10, VCount.l(x,y,Port):2:0 /);
