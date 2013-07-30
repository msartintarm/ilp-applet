var hardware_loaded = false;

var case4 = {};

/**
 * Finds what the user has specified for all machines / services.
 * Creates two arrays of doubles.
 * Then, gives the data to the Java applet. It will pass the model back to JS, shown on the right.
 */
case4.load_from_java = function() {

    var the_file = document.getElementById("syn_case4_file");
    var the_applet = document.getElementById("syn_the_applet");
    var selected_file = the_file.options[the_file.selectedIndex].value;

    the_applet.JSload4(selected_file);
};
