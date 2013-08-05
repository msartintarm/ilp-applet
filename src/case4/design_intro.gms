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
