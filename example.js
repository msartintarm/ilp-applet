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
