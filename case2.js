var hardware_loaded = false;

function hardware_describe(hardware_num) {

    if(hardware_loaded === true) return;

    var hw_title = document.getElementById("hardware_title");
    var hw_describe = document.getElementById("hardware_describe");
    switch(hardware_num) {
    case 1:
	hw_title.innerHTML = "Static Server Allocation (SSAP)";
	hw_describe.innerHTML = "\
Allocate services with fixed resource requirements onto machines with fixed resource limitations. \
We assume that machines can provide heterogeneous resource requirements, and all instances of \
services have been proviled individually. <br/>\
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

function hardware_load(hardware_num) {

    if(hardware_loaded === false) {
	hardware_describe(hardware_num);
	document.getElementById("hardware_content").style.display = "inline-block";
	hardware_loaded = true;	
    }

    var hw_title = document.getElementById("hardware_title");
    var hw_describe = document.getElementById("hardware_describe");
    var upload_file = document.getElementById("upload_file");
    switch(hardware_num) {
    case 1:
	hw_files.innerHTML="Two hardware graphs.<br/>\
<select id='hw_file' size='2'>\
  <option value='simple_graph.gms' selected>simple_graph.gms</option>\
  <option value='simple_graph2.gms'>simple_graph2.gms</option>\
</select><br/>\
<button>View raw file.</button>";
	sw_files.innerHTML="Three software DAGs.<br/>\
<select id='sw_file' size='2'>\
  <option value='simpleCFG.gms' selected>simpleCFG.gms</option>\
  <option value='simpleCFG2.gms'>simpleCFG2.gms</option>\
  <option value='simpleCFG3.gms'>simpleCFG3.gms</option>\
  <option id='own_cfg' value='ownCFG.gms' disabled> Own CFG</option>\
</select><br/>\
<button>View raw file.</button>";
	upload_file.innerHTML="Or, specify an input DAG.<br/>\
<input name='to_upload' id='upload_file_input' type='file' />\
<button onclick='select_own_cfg()'>Upload</button>";
	break;
    case 2:
	hw_describe.innerHTML = "Two hardware graphs, and three provided software DAGs.";
	break;
    case 3:
	hw_describe.innerHTML = "Three hardware graphs, and four provided software DAGs.";
	break;
    case 4:
	hw_describe.innerHTML = "Four hardware graphs, and five provided software DAGs.";
	break;
    default: break;
    }
}
