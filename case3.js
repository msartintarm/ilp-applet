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

case3.load = function(hardware_num) {

    if(hardware_loaded === false) {
	case3.describe(hardware_num);
	document.getElementById("syn_case3_content").style.display = "inline-block";
	hardware_loaded = true;	
    }

    var hw_title = document.getElementById("syn_case3_title");
    var hw_files = document.getElementById("syn_hw_files");
    var sw_files = document.getElementById("syn_sw_files");
    var hw_describe = document.getElementById("syn_case3_describe");
    var upload_file = document.getElementById("syn_upload_file");
    switch(hardware_num) {
    case 1:
	case3.arch = "Simple";
	hw_files.innerHTML="One hardware graph.<br/> <select id='syn_hw_file' size='1'> <option value='simple_graph.gms' selected='selected'> simple_graph.gms </option></select><br/><button>View raw file.</button>";
	sw_files.innerHTML="One software DAG.<br/><select id='syn_sw_file' size='2'>  <option value='simpleDAG.gms' selected='selected'> simpleDAG.gms </option>  <option id='syn_own_cfg' value='ownCFG.gms' disabled='disabled'> Own CFG </option> </select> <br/> <button> View raw file. </button>";
	break;
    case 2:
	case3.arch = "DySER";
	hw_files.innerHTML="One hardware graph.<br/><select id='syn_hw_file' size='1'>  <option value='dyser_model.gms' selected>dyser_model.gms</option></select><br/><button>View raw file.</button>";
	sw_files.innerHTML="One software DAG.<br/><select id='syn_sw_file' size='2'>  <option value='dyser_pdg.gms' selected>dyser_pdg.gms</option>  <option id='syn_own_cfg' value='ownCFG.gms' disabled> Own CFG</option></select><br/><button>View raw file.</button>";
	break;
    case 3:
	case3.arch = "PLUG";
	hw_files.innerHTML="One hardware graph.<br/><select id='syn_hw_file' size='1'>  <option value='PLUG4x4.gms' selected>PLUG4x4.gms</option></select><br/><button>View raw file.</button>";
	sw_files.innerHTML="One software DAG.<br/><select id='sw_file' size='2'>  <option value='plug_ethane.gms' selected>plug_ethane.gms</option>  <option id='syn_own_cfg' value='ownCFG.gms' disabled> Own CFG</option></select><br/><button>View raw file.</button>";
	break;
    case 4:
	case3.arch = "TRIPS";
	hw_files.innerHTML="One hardware graph.<br/><select id='syn_hw_file' size='1'>  <option value='trips4x4.gms' selected>trips4x4.gms</option></select><br/><button>View raw file.</button>";
	sw_files.innerHTML="Two software DAGs.<br/><select id='syn_sw_file' size='3'>  <option value='tripsDAG-small.gms' selected>tripsDAG-small.gms</option>  <option value='tripsDAG-too-large.gms' selected>tripsDAG-too-large.gms</option>  <option id='syn_own_cfg' value='ownCFG.gms' disabled> Own CFG</option></select><br/><button>View raw file.</button>";
	break;
    default: break;
    }
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
