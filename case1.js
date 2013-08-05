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
    case1.drawGraph();
};

/**
 * Draws a graph using Dracula.
 */
case1.drawGraph = function() {

    var okay = {};
    var inputs = {};
    var outputs = {};

    var parseGamsSet = function(graph, text) {

        var set_v = /Set\s([A-Z][a-z]*)\(v\)\/([a-z]+[0-9]+[,]*)+\/;/g;
        var the_match = text.match(set_v);
        console.log(set_v);
        console.log(the_match);

        for(var i = 0; i < the_match.length; ++i) {
            var new_text = the_match[i].replace(the_match, "$1", "");
            var each_v = /([a-z]+[0-9]+[,]*)/g;
            var one_name = each_v.exec(new_text);
            while(one_name !== null) {
                var new_name = one_name[0].replace(",", "");
                console.log(new_name);
                if (i === 0) okay[new_name] = 1;
                if (i === 1) inputs[new_name] = 1;
                if (i === 2) outputs[new_name] = 1;
                one_name = each_v.exec(new_text);
            }
        }
    };

    var g = new Graph();

    var text = document.getElementById("syn_input_file").value;

    parseGamsSet(g, text);

    var set_v = /Gvv\(v\,v\)\/([a-z]+[0-9]+.[a-z]+[0-9]+[,\s]*)+\/;/g;
    var new_text = text.match(set_v);
    new_text = new_text[0].replace("Gvv(v,v)/", "");
    console.log(new_text);
    var each_v = /([a-z]+[0-9]+[,\s]*)/g;
    var one_name = each_v.exec(new_text);

    var i = 0;

//    g.addNode(new_name);

    var added = {};

    while(one_name !== null) {
        var new_name = one_name[0].replace(",", "");


        if(!added[new_name]) { g.addNode(new_name); added[new_name] = 1; }

        if(++i % 2 === 0) {
            console.log(other_name + " --> " + new_name);
            g.addEdge(other_name, new_name, { directed: true });
        } else {
            other_name = new_name;
        }
        one_name = each_v.exec(new_text);
    }
/*
    g.addNode("input");
    g.addNode("mul1");
    g.addNode("mul2");
    g.addNode("output");




    g.addEdge("input", "mul1", { directed: true });
    g.addEdge("input", "mul2", { directed: true });
    g.addEdge("mul1", "mul2", { directed: true });
    g.addEdge("mul2", "output", { directed: true });
*/

    var spring = new Graph.Layout.Ordered(g, g.nodes);
    var render = new Graph.Renderer.Raphael("syn_canvas", g,  300, 300);
    spring.layout();
    render.draw();


};
