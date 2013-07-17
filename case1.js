var hardware_loaded = false;

var case1 = {};

case1.model = 'X';

/**
 * Finds what the user has specified for all machines / services.
 * Creates two arrays of doubles.
 * Then, gives the data to the Java applet. It will pass the model back to JS, shown on the right.
 */
case1.load_from_java = function() {




    var the_file = document.getElementById("case1_file");
    var selected_file = the_file.options[the_file.selectedIndex].value;

    the_applet.JSload1(selected_file);
};

/**
 * Sends the model to load on the right.
 */
case1.submit_from_java = function() {

    var the_applet = document.getElementById("the_applet");
    var input_file = document.getElementById("input_file");
    the_applet.JSsubmit(input_file.value);
};

case1.submit_toggle = function() {

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
