var hardware_loaded = false;

var case4 = {};

/**
 * Finds what the user has specified for all machines / services.
 * Creates two arrays of doubles.
 * Then, gives the data to the Java applet. It will pass the model back to JS, shown on the right.
 */
case4.load_from_java = function() {

    var relative_gap = document.getElementById("syn_relative_tolerance").value;
    var the_applet = document.getElementById("syn_the_applet");

    the_applet.JSload4(relative_gap);
};
