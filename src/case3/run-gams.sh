#!/bin/sh
set -e
# * *  Configuration Options  * * * * * * * * * 

#  Correspond to the directories the script
#    will search for GAMS files.
ARCHS="DySER PLUG Simple TRIPS"

#  Path to a valid GAMS license on your system goes here.
GAMS=/p/gams/systems/lnx_64/23.6/gams

# * * * * * * * * * * * * * * * * * * * * * * * 

# Check whether config options work or have changed
config_check() {

	for iARCH in `echo $ARCHS`; do
		[[ ! -d $iARCH/ ]] && echo -e "\
New arch '$iARCH' detected. Check existing architectures
 to view how to establish folder heirarchy.

" && exit 1
	done
	
	[[ ! -e $GAMS ]] && echo -e "\
Path '$GAMS' does not point to a valid GAMS executable.
" && exit 1
	return 0
}

# Prints an error message, along with
#  hardware graphs in directories listed in the ARCHS string
print_graphs() {
	
	echo -e "$1

Hardware graph options are: 
"	
    for iARCH in `echo $ARCHS`; do
		if [ -e $iARCH/HW-GRAPH ]; then
			GRAPHs=($iARCH/HW-GRAPH/*.gms)
			if [ -e ${GRAPHs[0]} ]; then
				echo "  (${iARCH})"
				for iGRAPH in `ls $iARCH/HW-GRAPH/*.gms`; do
					echo "   \`-h `basename $iGRAPH`'"
				done
				echo ""
			else
				echo -e "  No hardware graphs for $iARCH architecture found. \n"
			fi
		else
			echo -e "$iARCH architecture not found. \n"
		fi
    done
	
	exit 1
}

# Sets arch in directories listed in the ARCHS string
#  Also finds if hardware graph is invalid
set_graph() {
	unset ARCH
	for iARCH in `echo "$ARCHS"`; do
		if [ -e $iARCH/HW-GRAPH/$HW_GRAPH ]; then
			ARCH=$iARCH
		fi
	done
	if [[ -z $ARCH ]]; then
		print_graphs "Input hardware graph '$HW_GRAPH' is not for any existing architecture."
	else
		echo -e "Located input graph '$HW_GRAPH' for $ARCH architecture. "
	fi
}

# Prints an error message. If the hardware graph is valid,
#   also prints which software DAGs (if any) fit this particular
#   architecture.
print_dags() {
	echo -e "
$1
"	
	if [[ $ARCH ]]; then
		DAGs=($ARCH/SW-DAG/*.gms)
		if [ -e ${DAGs[0]} ]; then
			echo "Options for this arch (${ARCH}) are:"
			for iDAG in `ls $ARCH/SW-DAG/*.gms`; do
				echo " \`-s `basename $iDAG`'"
			done
			echo ""
		else
			echo -e "No software DAGs for $ARCH architecture found. \n"
		fi
	fi
	exit 1
}

# Sets software DAGs if a directory has been specified
# Input: name of the GAMS software DAG
set_dag() {
	if [[ -e $ARCH/SW-DAG/$SW_DAG ]]; then
		echo "Located input software DAG '$1'."
	else 
		print_dags "Input '$SW_DAG' is not a correct software DAG."
	fi
}

run_gams(){
	ROOT=$PWD
	pushd work >& /dev/null
    rm -f solve.gms
    echo "\$batinclude $ROOT/$ARCH/kind.gms" >> solve.gms
    echo "\$batinclude $ROOT/$ARCH/SW-DAG/$SW_DAG" >> solve.gms
    echo "\$batinclude $ROOT/$ARCH/HW-GRAPH/$HW_GRAPH" >> solve.gms
    echo "\$batinclude $ROOT/shared/gen-variables.gms" >> solve.gms
    echo "\$batinclude $ROOT/shared/gen-constraints.gms" >> solve.gms
	echo "\$batinclude $ROOT/$ARCH/constraints/constraints.gms" >> solve.gms
    echo "\$batinclude $ROOT/shared/output-schedule.gms" >> solve.gms
    echo "" >> solve.gms
	echo "Generated 'work/solve.gms'."
    echo "
Running GAMS solver (check work/log.txt for progress) . . . "
	rm -f log.txt
	SECONDS=0
#    $GAMS solve.gms lo=3 idir ./$ARCH:./$ARCH/SW-DAG:./$ARCH/HW-GRAPH:./$ARCH/constraints:./shared/ >& log.txt &&
    $GAMS solve.gms lo=3 idir $ROOT/$ARCH:$ROOT/$ARCH/constraints >& log.txt &&
	echo "\
Scheduling complete in $SECONDS seconds.
- Check output file 'work/solution.lst' for model.
- If no solution is found, 'work/solve.lst' will show
   the progress of the solver.
" && popd >& /dev/null && return 0
	# Solution is invalid by this point. Error out.
	echo "\
GAMS encountered an error. Search for \`****' string in 'work/solve.lst'.
" && popd >& /dev/null && return 1
}

clear
echo -e "\033[4m\
                      ILP Scheduling Interface                            "
tput sgr0
echo "\
-                                                                        -
-  Developed at University of Wisconsin Madison - Computer Science Dept  -
-                                                                        -"
config_check

if [ "$#" -eq 0 ]; then
    print_graphs "Syntax: 
   \`./run-gams.sh -h <hardware_graph.gms> -s <software_DAG.gms>'
   "
fi

unset SW_DAG; unset HW_GRAPH; unset ARCH;

while [ $# -gt 0 ]; do
    case "$1" in

	-clean)
	    sleep 0.5;;

	-h) 
	    # Hardware flag: ensure next path exists
	    if [[ 2 -gt $# ]] || [[ "$2" == "-s" ]]; then
			print_graphs "Must specify a hardware graph after '-h' flag."
	    fi
		shift
		HW_GRAPH="$1"
	    ;;

	-s)
	    # 
	    if [[ 2 -gt $# ]] || [[ "$2" == "-h" ]]; then
			SW_DAG="none" 
		else
			shift
			SW_DAG="$1"
	    fi
	    ;;

	*)
	    echo -e "   The command '$1' doesn't do anything...
"
	    sleep 3;;
		
    esac; shift
done

if [[ -z $HW_GRAPH ]]; then print_graphs "\
You didn't specify an input hardware graph."; fi
set_graph $HW_GRAPH
if [[ -z $SW_DAG ]]; then print_dags "\
Must also specify an input software graph: '-s <softwareDAG.gms>'."; fi
if [[ "none" = "$SW_DAG" ]]; then print_dags "\
You didn't specify an input software graph."; fi
set_dag $SW_DAG
run_gams
exit 0
