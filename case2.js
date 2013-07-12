var hardware_loaded = false;

var case2 = {};

case2.describe = function(hardware_num) {

    if(hardware_loaded === true) return;

    var hw_title = document.getElementById("case2_title");
    var hw_describe = document.getElementById("case2_describe");
    switch(hardware_num) {
    case 1:
	hw_title.innerHTML = "Static Server Allocation (SSAP)";
	hw_describe.innerHTML = "\
Allocate services with fixed resource requirements onto machines with fixed resource limitations. \
We assume that machines can provide heterogeneous resource requirements, and all instances of \
services have been profiled individually. <br/>\
Conceptually similar to the multidimensional vector bin-packing algorithm.";
	break;
    case 2:
	hw_title.innerHTML = "Warehouse Server Allocation (WSAP)";
	hw_describe.innerHTML = "\
SSAP assumes workloads can be individually profiled. Under warehouse settings, workloads are \
instead classified into particular types, allowing benefits such as aggregated profiling. \
Such workload classifications can be taken advantage of in ILP to extend the formulation \
and reduce overall computational complexity.";
	break;
    case 3:
	hw_title.innerHTML = "Time-Varying Server Allocation (TSAP)";
	hw_describe.innerHTML = "\
Certain resource usage patterns can be inferred <i>a priori</i> based upon the time of day - \
for example, certain services may be used more often in the nighttime than in the daytime. \
Such time-specific knowledge can be statically utilized by co-locating machines with \
 complementary resource patterns.";
	break;
    case 4:
	hw_title.innerHTML = "Interference-Sensitive Server Allocation (ISAP)";
	hw_describe.innerHTML = "\
The 'bin-packing' approach used in the other three strategies does not lend itself easily to \
interference in the memory system. Cache interference and contention for memory bandwidth \
can profoundly affect the overall quality of service (QoS) for the system, and the \
relationship is specific to the applications involved. <br/> \
This problem is modeled with the abstract concepts of <i>memory pressure</i>, the application's \
lowest level working set size, and of <i>memory sensitivity</i>, the projected QoS degradation \
for a machine given the memory pressure from all other applications on the machine. <br/> \
These are used in ISAP as a constraint denoting a minimum acceptable QoS threshhold. ";
	break;
    default: break;
    }
}

function select_own_cfg() {
    var own_cfg = document.getElementById('own_cfg');
    var filename = document.getElementById('upload_file_input').value;
    own_cfg.value = filename;
    own_cfg.innerHTML = filename.substr(filename.lastIndexOf('\\') + 1);
    own_cfg.disabled = false;
    own_cfg.selected = true;
}

case2.load = function(hardware_num) {

    if(hardware_loaded === false) {
	case2.describe(hardware_num);
	document.getElementById("case2_content").style.display = "inline-block";
	hardware_loaded = true;	
    }

    var hw_title = document.getElementById("case2_title");
    var hw_describe = document.getElementById("case2_describe");
    switch(hardware_num) {
    case 1:
		services.innerHTML="Specify resource usage of services.<br/>";
		add_service();
		machines.innerHTML="Specify resources of machines.<br/>";
		add_machine();
		break;
    case 2:
		services.innerHTML="Specify resource usage of services.<br/>";
		add_service();
		machines.innerHTML="Specify resources of machines.<br/>";
		add_machine();
		break;
    case 3:
		services.innerHTML="Specify resource usage of services.<br/>";
		add_service();
		machines.innerHTML="Specify resources of machines.<br/>";
		add_machine();
		additional_params.innerHTML="Specify number of time periods over which to divide variance: \
<input type='text' value='4' size='3'></input> time periods.";
		break;
    case 4:
		hw_describe.innerHTML = "Four hardware graphs, and five provided software DAGs.";
		break;
    default: break;
    }
}

function add_service() {
		services.innerHTML += "\
<input type='text' value='100' size='3'></input> services with \
<input type='text' id='mem' value='4.00' size='3'></input> GB / \
<input type='text' value='0.75' size='3'></input> CPU %<br/>";
}

function add_timed_service() {
		services.innerHTML += "\
<input type='text' value='100' size='3'></input> services with \
<input type='text' id='mem' value='4.00' size='3'></input> GB / \
<input type='text' value='0.75' size='3'></input> CPU %<br/>";
}

function add_machine() {
		machines.innerHTML += "\
<input type='text' value='2' size='3'></input> machines with \
<input type='text' id='mem' value='16.0' size='3'></input> GB / \
<input type='text' value='1.00' size='3'></input> GHz <br/>";
}
