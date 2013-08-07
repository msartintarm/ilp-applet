var hardware_loaded = false;

var case1 = {};

case1.renderHighlight = function(r, node) {
	/* the default node drawing */
	var color = "#ddeeff";
	var ellipse = r.ellipse(0, 0, 15, 15).attr({fill: color, stroke: color, "stroke-width": 2});
	/* set DOM node ID */
	ellipse.node.id = node.label || node.id;
	var shape = r.set().
	push(ellipse).
	push(r.text(0, 0, node.label || node.id));
	return shape;
};

case1.renderNoHighlight = function(r, node) {
	/* the default node drawing */
	var color = "#334455";
	var ellipse = r.ellipse(0, 0, 15, 15).attr({fill: color, stroke: color, "stroke-width": 2});
	/* set DOM node ID */
	ellipse.node.id = node.label || node.id;
	var shape = r.set().
	push(ellipse).
	push(r.text(0, 0, node.label || node.id));
	return shape;
};

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

    var added = {};

    var parseGamsSet = function(graph, text) {

        var set_v = /Set\s([A-Z][a-z]*)\(v\)\/([a-z]+[0-9]+[,]*)+\/;/g;
        var the_match = text.match(set_v);

        for(var i = 0; i < the_match.length; ++i) {
            var new_text = the_match[i].replace(the_match, "$1", "");
            var each_v = /([a-z]+[0-9]+[,]*)/g;
            var one_name = each_v.exec(new_text);
            while(one_name !== null) {
                var new_name = one_name[0].replace(",", "");
                if (i === 0) okay[new_name] = 1;
                if (i === 1) inputs[new_name] = 1;
                if (i === 2) outputs[new_name] = 1;
                one_name = each_v.exec(new_text);
            }
        }
    };

    case1.graph = new Graph();
	var graph = case1.graph;

    var text = document.getElementById("syn_input_file").value;

    parseGamsSet(graph, text);

    var set_v = /Gvv\(v\,v\)\/([a-z]+[0-9]+.[a-z]+[0-9]+[,\s]*)+\/;/g;
    var new_text = text.match(set_v);
    new_text = new_text[0].replace("Gvv(v,v)/", "");
    var each_v = /([a-z]+[0-9]+[,\s]*)/g;
    var one_name = each_v.exec(new_text);

    var i = 0;

//    g.addNode(new_name);

	for (var name in inputs) {
        if(!added[name]) { graph.addNode(name); added[name] = 1; }
	}
	for (var name in okay) {
        if(!added[name]) { graph.addNode(name); added[name] = 1; }
	}
	for (var name in outputs) {
        if(!added[name]) { graph.addNode(name); added[name] = 1; }
	}

    while(one_name !== null) {
        var new_name = one_name[0].replace(",", "");

        if(!added[new_name]) { graph.addNode(new_name); added[new_name] = 1; }

        if(++i % 2 === 0) {
            console.log(other_name + " --> " + new_name);
            graph.addEdge(other_name, new_name, { directed: true });
        } else {
            other_name = new_name;
        }
        one_name = each_v.exec(new_text);
    }

	for(var node_name in graph.nodes) {
		graph.nodes[node_name].render = case1.renderNoHighlight;
	}

    case1.layer = new Graph.Layout.Ordered(graph, graph.nodes);
    case1.renderer = new Graph.Renderer.Raphael("syn_canvas", graph,  300, 300);
    case1.layer.layout();
    case1.renderer.draw();
};
