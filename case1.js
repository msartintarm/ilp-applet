var hardware_loaded = false;

var case1 = {};

/**
 * Finds what the user has specified for all machines / services.
 * Creates two arrays of doubles.
 * Then, gives the data to the Java applet. It will pass the model back to JS, shown on the right.
 */
case1.load_from_java = function() {




    var the_file = document.getElementById("syn_case1_file");
    var the_applet = document.getElementById("syn_the_applet");
    var selected_file = the_file.options[the_file.selectedIndex].value;

    the_applet.JSload1(selected_file);
};
