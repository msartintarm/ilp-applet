var Neos = {};

Neos.update_element = function(element, result) {
    document.getElementById(element).value = result;
}

Neos.send_to_applet = function() {
    var the_applet = document.getElementById("syn_the_applet");
    var text_to_send = document.getElementById("syn_input_file").value;
    the_applet.JSsubmit(text_to_send);
}

/**
 * Sends the model to load on the right.
 */
Neos.submit_from_java = function() {

    var the_applet = document.getElementById("syn_the_applet");
    var input_file = document.getElementById("syn_input_file");
    the_applet.JSsubmit(input_file.value);
    Neos.submit_toggle("Sending to NEOS..");
};

/**
 * Kills a model if it's currently executing.
 */
Neos.kill_job = function() {

    document.getElementById("syn_the_applet").JSkill();
};

Neos.submit_toggle = function(new_text) {
    
    var submit_button = document.getElementById("syn_submit_button");

    if(submit_button.disabled !== true) {
	submit_button.disabled = true;
    } else {
	submit_button.disabled = false;
    }
    submit_button.innerHTML = new_text;
};

Neos.submit_change_text = function(new_text) {
    document.getElementById("syn_submit_button").innerHTML = new_text;
};

Neos.kill_toggle = function() {

    var kill_button = document.getElementById("syn_kill_button");
    
    if(kill_button.disabled !== true) {
	kill_button.disabled = true;
    } else {
	kill_button.disabled = false;
    }
};

Neos.resizeTextArea = function(elem_name) {
	
	var parent = document.getElementById("syn_" + elem_name + "_holder");
	var button = document.getElementById("syn_" + elem_name + "_button");
	var text = document.getElementById("syn_solver_" + elem_name + "");
	if(parent.style.cssFloat !== "none") {
		parent.style.cssFloat = "none";
		parent.style.width = "100%";
		parent.style.clear = "both";
		text.rows = 40;
		button.innerHTML = "shrink";
	} else {
		parent.style.cssFloat = "left";
		parent.style.width = "33%";
		parent.style.clear = "none";
		text.rows = 12;
		button.innerHTML = "expand";
	}
	/*
	if(solution.rows < 20) {
		solution.rows = 40;
		solution.style.width = "500px";
		solution.style.cssFloat = "none";
	} else {
		solution.rows = 12;
		solution.style.width = "95%";
	}
	*/
};

Neos.case1_highlightGraph = function() {

	var graph = case1.graph;

	var nodes_to_highlight = document.getElementById("syn_parsed_solution").value.split(/\s+/);

	for(var i = 1; i < nodes_to_highlight.length; ++i) {
		var this_node = nodes_to_highlight[i];
		if (graph.nodes[this_node]) {
			delete graph.nodes[this_node].shape;
			graph.nodes[this_node].render = case1.renderHighlight;
		}
	}

    case1.renderer.draw();
};
