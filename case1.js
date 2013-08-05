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

    case1.graph = new Graph();
	var graph = case1.graph;

    var text = document.getElementById("syn_input_file").value;

    parseGamsSet(graph, text);

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


        if(!added[new_name]) { graph.addNode(new_name); added[new_name] = 1; }

        if(++i % 2 === 0) {
            console.log(other_name + " --> " + new_name);
            graph.addEdge(other_name, new_name, { directed: true });
        } else {
            other_name = new_name;
        }
        one_name = each_v.exec(new_text);
    }

    case1.layer = new Graph.Layout.Ordered(graph, graph.nodes);
    case1.renderer = new Graph.Renderer.Raphael("syn_canvas", graph,  300, 300);
    case1.layer.layout();
    case1.renderer.draw();

	case1.highlightGraph();
};

case1.highlightGraph = function() {

	var graph = case1.graph;

	var nodes_to_highlight = ["i0", "i1"];

	function renderHighlight(r, node) {
		/* the default node drawing */
		var color = "#ddeeff";
		var ellipse = r.ellipse(0, 0, 30, 20).attr({fill: color, stroke: color, "stroke-width": 2});
		/* set DOM node ID */
		ellipse.node.id = node.label || node.id;
		var shape = r.set().
			push(ellipse).
			push(r.text(0, 30, node.label || node.id));
		return shape;
	}

	function renderNoHighlight(r, node) {
		/* the default node drawing */
		var color = "#334455";
		var ellipse = r.ellipse(0, 0, 30, 20).attr({fill: color, stroke: color, "stroke-width": 2});
		/* set DOM node ID */
		ellipse.node.id = node.label || node.id;
		var shape = r.set().
			push(ellipse).
			push(r.text(0, 30, node.label || node.id));
		return shape;
	}

	console.log(graph.nodes);
	for(var node_name in graph.nodes) {
		
		var node = graph.nodes[node_name];
		node.shape = null;
		node.render = renderNoHighlight;
	}

	for(var i = 0; i < nodes_to_highlight.length; ++i) {
		var this_node = nodes_to_highlight[i];
		delete graph.nodes[this_node].shape;
		graph.nodes[this_node].render = renderHighlight;
	}

	//    var render = new Graph.Renderer.Raphael("syn_canvas", graph,  300, 300);
    case1.renderer.draw();

	/*
	var ellipses = {};

	// Index ellipses by ID
	var ellipse_list = document.getElementsByTagName("ellipse");
	for (var i = 0; i < ellipse_list.length; ++i) {
		var one_ellipse = ellipse_list[i];
		if (one_ellipse.id === "i1" || one_ellipse.id === "i0") {
			console.log("zzzzooo");
			one_ellipse.fill = "#ee8899";
		}		
		ellipses[one_ellipse.id] = one_ellipse;
	}

	*/


};