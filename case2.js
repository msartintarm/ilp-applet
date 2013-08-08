var hardware_loaded = false;

var case2 = {};

case2.model = 'X';

case2.describe = function(hardware_num) {

    if(hardware_loaded === true) return;

    var hw_title = document.getElementById("syn_case2_title");
    var hw_describe = document.getElementById("syn_case2_describe");
    switch(hardware_num) {
    case 1:
	hw_title.innerHTML = "Static Server Allocation (SSAP)";
	hw_describe.innerHTML = "Allocate services with fixed resource requirements onto machines with fixed resource limitations. We assume that machines can provide heterogeneous resource requirements, and all instances of services have been profiled individually. <br/>Conceptually similar to the multidimensional vector bin-packing algorithm.";
	break;
    case 2:
	hw_title.innerHTML = "Warehouse Server Allocation (WSAP)";
	hw_describe.innerHTML = "SSAP assumes workloads can be individually profiled. Under warehouse settings, workloads are instead classified into particular types, allowing benefits such as aggregated profiling. Such workload classifications can be taken advantage of in ILP to extend the formulation and reduce overall computational complexity.";
	break;
    case 3:
	hw_title.innerHTML = "Time-Varying Server Allocation (TSAP)";
	hw_describe.innerHTML = "Certain resource usage patterns can be inferred <i>a priori</i> based upon the time of day - for example, certain services may be used more often in the nighttime than in the daytime. Such time-specific knowledge can be statically utilized by co-locating machines with  complementary resource patterns.";
	break;
    case 4:
	hw_title.innerHTML = "Interference-Sensitive Server Allocation (ISAP)";
	hw_describe.innerHTML = "The 'bin-packing' approach used in the other three strategies does not lend itself easily to interference in the memory system. Cache interference and contention for memory bandwidth can profoundly affect the overall quality of service (QoS) for the system, and the relationship is specific to the applications involved. <br/> This problem is modeled with the abstract concepts of <i>memory pressure</i>, the application's lowest level working set size, and of <i>memory sensitivity</i>, the projected QoS degradation for a machine given the memory pressure from all other applications on the machine. <br/> These are used in ISAP as a constraint denoting a minimum acceptable QoS threshhold. ";
	break;
    default: break;
    }
}

case2.load = function(hardware_num) {

    hardware_loaded = false;
    case2.describe(hardware_num);
    document.getElementById("syn_case2_content").style.display = "inline-block";
    hardware_loaded = true;

    case2.services = 0;
    case2.machines = 0;

    var hw_title = document.getElementById("syn_case2_title");
    var hw_describe = document.getElementById("syn_case2_describe");
    var services = document.getElementById("syn_services");
    var machines = document.getElementById("syn_machines");
    var service_button = document.getElementById("syn_service_button");
    var machine_button = document.getElementById("syn_machine_button");
    switch(hardware_num) {
    case 1:
	case2.model = 'S';
	services.innerHTML = "Specify resource usage of services.<br/>";
	services.innerHTML += "<i>Service memory usage varies uniformly across the range specified.</i><br/>";
	machines.innerHTML = "Specify resources of machines.<br/>";
	service_button.onclick = case2.add_service;
	machine_button.onclick = case2.add_machine;
	case2.add_service();
	case2.add_machine();
	break;
    case 2:
	case2.model = 'W';
	services.innerHTML="Specify resource usage of services.<br/>";
	services.innerHTML += "<i>Services with the same parameters are aggregated together.</i><br/>";
	machines.innerHTML="Specify resources of machines.<br/>";
	service_button.onclick = case2.add_warehouse_service;
	machine_button.onclick = case2.add_warehouse_machine;
	case2.add_warehouse_service();
	case2.add_warehouse_machine();
	break;
    case 3:
	var additional_params = document.getElementById("syn_additional_params");
	    case2.model = 'T';
	services.innerHTML="Specify resource usage of services.<br/>";
	machines.innerHTML="Specify resources of machines.<br/>";
	service_button.onclick = case2.add_service;
	machine_button.onclick = case2.add_machine;
	case2.add_service();
	case2.add_machine();
	additional_params.innerHTML="Specify number of time periods over which to divide variance.<br/>";
	additional_params.innerHTML += "<input type='text' id='syn_timing' value='4' size='1'/> time periods";
	break;
    case 4:
	case2.model = 'I';
	hw_describe.innerHTML = "Four hardware graphs, and five provided software DAGs.";
	break;
    default: break;
    }
}

/**
 * Add Case 2 services with 3 params: number of services, mem usage, CPU usage
 * Give unique ID that can be looked up later.
 */
case2.add_service = function() {

    var services = document.getElementById("syn_services");
    var zz = function(name, value, size, text_before, text_after, break_after) {
        if (!!text_before) services.appendChild(document.createTextNode(text_before));
        var n = document.createElement("input");
        n.type = "text";
        n.id = "" + name;
        n.value = String(value);
        n.size = size;
        services.appendChild(n);
        if (!!text_after) services.appendChild(document.createTextNode(text_after));
        if (!!break_after) services.appendChild(document.createElement("br"));
    };

    zz("syn_service_num" + case2.services, 100, 2, "Number of services:", null, true);
    zz("syn_service_mem" + case2.services, "2.0", 1, "Memory usage: uniform(", ",");
    zz("syn_service2mem" + case2.services, "4.0", 1, null, ") GB ", true);
    zz("syn_service_cpu" + case2.services, 0.75, 2, "CPU usage: ", " %", true);
    case2.services ++;

}

case2.add_warehouse_service = function() {
    var services = document.getElementById("syn_services");
    services.innerHTML += "";
    services.innerHTML += "<input type='text' id='syn_service_num" + case2.services +  "' value='100' size='3'/> services with ";
    services.innerHTML += "<input type='text' id='syn_service_mem" + case2.services +  "' value='4.00' size='3'/> GB / ";
    services.innerHTML += "<input type='text' id='syn_service_cpu" + case2.services +  "' value='0.75' size='3'/> CPU %<br/>";
    case2.services ++;
}

case2.add_timed_service = function() {
    services.innerHTML += "";
    services.innerHTML += "<input type='text' value='100' size='3'/> services with ";
    services.innerHTML += "<input type='text' id='syn_mem' value='4.00' size='3'/> GB / ";
    services.innerHTML += "<input type='text' value='0.75' size='3'/> CPU %<br/>";
}

case2.add_machine = function() {
    var machines = document.getElementById("syn_machines");
    machines.innerHTML += "";
    machines.innerHTML += "<input type='text' id='syn_machine_num" + case2.machines +  "' value='200' size='2'/> machines, ";
    machines.innerHTML += "<input type='text' id='syn_machine_mem" + case2.machines +  "' value='16.0' size='2'/>-";
    machines.innerHTML += "<input type='text' id='syn_machine2mem" + case2.machines +  "' value='16.0' size='2'/> GB / ";
    machines.innerHTML += "<input type='text' id='syn_machine_cpu" + case2.machines +  "' value='1.00' size='2'/> GHz <br/>";
    case2.machines ++;
};

case2.add_warehouse_machine = function() {
    var machines = document.getElementById("syn_machines");
    machines.innerHTML += "";
    machines.innerHTML += "<input type='text' id='syn_machine_num" + case2.machines +  "' value='200' size='2'/> machines with ";
    machines.innerHTML += "<input type='text' id='syn_machine_mem" + case2.machines +  "' value='16.0' size='2'/> GB / ";
    machines.innerHTML += "<input type='text' id='syn_machine_cpu" + case2.machines +  "' value='1.00' size='2'/> GHz <br/>";
    case2.machines ++;
};

/**
 * Finds what the user has specified for all machines / services.
 * Creates two arrays of doubles.
 * Then, gives the data to the Java applet. It will pass the model back to JS, shown on the right.
 */
case2.load_from_java = function() {

    var service_num = [];
    var service_mem = [];
    var service_cpu = [];
    var machine_num = [];
    var machine_mem = [];
    var machine_cpu = [];
    var i;

    if (case2.model === 'T') service_mem.push(document.getElementById("syn_timing").value);
    for(i = 0; i < case2.services; ++i) {
	service_num.push(document.getElementById("syn_service_num" + i).value);
	service_mem.push(document.getElementById("syn_service_mem" + i).value);
	if (case2.model === 'S' || case2.model === 'T')
	    service_mem.push(document.getElementById("syn_service2mem" + i).value);
	service_cpu.push(document.getElementById("syn_service_cpu" + i).value);
    }
    for(i = 0; i < case2.machines; ++i) {
	machine_num.push(document.getElementById("syn_machine_num" + i).value);
	machine_mem.push(document.getElementById("syn_machine_mem" + i).value);
	if (case2.model === 'S' || case2.model === 'T')
	    machine_mem.push(document.getElementById("syn_machine2mem" + i).value);
	machine_cpu.push(document.getElementById("syn_machine_cpu" + i).value);
    }

    document.getElementById("syn_the_applet").JSload2(
	case2.model, case2.services, case2.machines,
	service_num, service_mem, service_cpu,
	machine_num, machine_mem, machine_cpu );
};

case2.submit_toggle = function() {

    var active_text = "Submit job to NEOS!";
    var inactive_text = "NEOS working..";
    var submit_button = document.getElementById("syn_submit_button");

    if(submit_button.disabled !== true) {
	submit_button.disabled = true;
	submit_button.innerHTML = inactive_text;
    } else {
	submit_button.disabled = false;
	submit_button.innerHTML = active_text;
    }
};
