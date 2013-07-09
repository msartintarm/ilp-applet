var hardware_loaded = false;

function hardware_describe(hardware_num) {

    if(hardware_loaded === true) return;

    var hw_title = document.getElementById("hardware_title");
    var hw_describe = document.getElementById("hardware_describe");
    switch(hardware_num) {
    case 1:
	hw_title.innerHTML = "Simple Architecture";
	hw_describe.innerHTML = "\
A spatial architecture that demonstrates a general set of spatial mapping responsibilities.";
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
