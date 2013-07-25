var Neos = {};

Neos.update_element = function(element, result) {
    document.getElementById(element).value = result;
}

Neos.send_to_applet = function() {
    var the_applet = document.getElementById("the_applet");
    var text_to_send = document.getElementById("input_file").value;
    the_applet.JSsubmit(text_to_send);
}

/**
 * Sends the model to load on the right.
 */
Neos.submit_from_java = function() {

    var the_applet = document.getElementById("the_applet");
    var input_file = document.getElementById("input_file");
    the_applet.JSsubmit(input_file.value);
};

/**
 * Kills a model if it's currently executing.
 */
Neos.kill_job = function() {

    document.getElementById("the_applet").JSkill();
};

Neos.submit_toggle = function() {

    var active_text = "Submit job to NEOS!";
    var inactive_text = "NEOS working..";
    var submit_button = document.getElementById("submit_button");
    
    if(submit_button.disabled !== true) {
	submit_button.disabled = true;
	submit_button.innerHTML = inactive_text;
    } else {
	submit_button.disabled = false;
	submit_button.innerHTML = active_text;
    }
};

Neos.kill_toggle = function() {

    var kill_button = document.getElementById("kill_button");
    
    if(kill_button.disabled !== true) {
	kill_button.disabled = true;
    } else {
	kill_button.disabled = false;
    }
};
