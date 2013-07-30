var hardware_loaded = false;

var case3 = {};
case3.arch = "";

case3.describe = function(hardware_num) {

    if(hardware_loaded === true) return;

    var hw_title = document.getElementById("syn_case3_title");
    var hw_describe = document.getElementById("syn_case3_describe");
    switch(hardware_num) {
    case 1:
	hw_title.innerHTML = "Simple Architecture";
	hw_describe.innerHTML = "A spatial architecture that demonstrates a general set of spatial mapping responsibilities.";
	break;
    case 2:
	hw_title.innerHTML = "DySER Architecture";
	hw_describe.innerHTML = "An accelerator.";
	break;
    case 3:
	hw_title.innerHTML = "PLUG Architecture";
	hw_describe.innerHTML = "A weird architecture.";
	break;
    case 4:
	hw_title.innerHTML = "TRIPS Architecture";
	hw_describe.innerHTML = "An intended general-purpose architecture.";
	break;
    default: break;
    }
};

function select_own_cfg() {
    var own_cfg = document.getElementById("syn_own_cfg");
    var filename = document.getElementById("syn_upload_file_input").value;
    own_cfg.value = filename;
    own_cfg.innerHTML = filename.substr(filename.lastIndexOf('\\') + 1);
    own_cfg.disabled = false;
    own_cfg.selected = true;
};

case3.appendOption = function(parent, name, select) {

    var select_option=document.createElement("option");
    select_option.value = name;
    if(select) select_option.selected = "selected";
    select_option.text  = name;
    parent.appendChild(select_option);

}

case3.load = function(hardware_num) {

    if(hardware_loaded === false) {
	case3.describe(hardware_num);
	document.getElementById("syn_case3_content").style.display = "inline-block";
	hardware_loaded = true;	
    }

    var hw_files = document.getElementById("syn_hw_files");
    var sw_files = document.getElementById("syn_sw_files");

    while(hw_files.firstChild) {
	var doomed_child = hw_files.firstChild;
	hw_files.removeChild(doomed_child);
	delete doomed_child;
    }
    while(sw_files.firstChild) {
	var doomed_child = sw_files.firstChild;
	sw_files.removeChild(doomed_child);
	delete doomed_child;
    }

    var select=document.createElement("select");
    select.id = "syn_hw_file";
    var select_button=document.createElement("button");
    select_button.innerHTML  = "View Raw File.";

    var select2=document.createElement("select");
    select2.id = "syn_sw_file";
    var select_button2=document.createElement("button");
    select_button2.innerHTML  = "View Raw File.";

    var special_option=document.createElement("option");
    special_option.id  = "syn_own_cfg";
    special_option.disabled  = "disabled";
    special_option.text  = "Own CFG";

    switch(hardware_num) {
    case 1:
	case3.arch = "Simple";

	hw_files.appendChild(document.createTextNode("One hardware graph."));
	case3.appendOption(select, "simple_graph.gms", true);

	sw_files.appendChild(document.createTextNode("One software DAG."));
	case3.appendOption(select2, "simpleDAG.gms", true);

	break;
    case 2:
	case3.arch = "DySER";

	hw_files.appendChild(document.createTextNode("One hardware graph."));
	case3.appendOption(select, "dyser_model.gms", true);

	sw_files.appendChild(document.createTextNode("One software DAG."));
	case3.appendOption(select2, "dyser_pdg.gms", true);

	break;
    case 3:
	case3.arch = "PLUG";
	hw_files.appendChild(document.createTextNode("One hardware graph."));
	case3.appendOption(select, "PLUG4x4.gms", true);

	sw_files.appendChild(document.createTextNode("One software DAG."));
	case3.appendOption(select2, "plug_ethane.gms", true);

	break;
    case 4:
	case3.arch = "TRIPS";
	hw_files.appendChild(document.createTextNode("One hardware graph."));
	case3.appendOption(select, "trips4x4.gms", true);

	sw_files.appendChild(document.createTextNode("Two software DAGs."));
	case3.appendOption(select2, "tripsDAG-small.gms", true);
	case3.appendOption(select2, "tripsDAG-too-large.gms");
	select2.size = 3;

	break;
    default: break;
    }
    hw_files.appendChild(document.createElement("br"));
    hw_files.appendChild(select);
    hw_files.appendChild(document.createElement("br"));
    hw_files.appendChild(select_button);

    select2.appendChild(special_option);
    sw_files.appendChild(document.createElement("br"));
    sw_files.appendChild(select2);
    sw_files.appendChild(document.createElement("br"));
    sw_files.appendChild(select_button2);

    var upload_file = document.getElementById("syn_upload_file");
    upload_file.innerHTML="Or, specify an input DAG.<br/><input name='to_upload' id='syn_upload_file_input' type='file' style='float:left;'/><br/><button onclick='select_own_cfg()' style='float:left;'>Upload..</button>";

};

/**
 * Figures out which software and hardware DAGs are selected.
 * Then, sends the model to load on the right.
 */
case3.load_from_java = function() {

    var the_applet = document.getElementById("syn_the_applet");
    var sw_select = document.getElementById("syn_sw_file");
    var sw_file = sw_select.options[sw_select.selectedIndex].text;
    var hw_select = document.getElementById("syn_hw_file");
    var hw_file = hw_select.options[hw_select.selectedIndex].text;
    the_applet.JSload3(case3.arch, sw_file, hw_file);
};
