/**
   Given a string representing a MILP model, turn it into 
   XML format.
*/
function turn_into_xml(input_string) {

    // Pre-model XML
    // We use MILP, the solver SCIP, and in GAMS format.
    var the_xml = "\
<document>\n\
<category>milp</category>\n\
<solver>scip</solver>\n\
<inputMethod>GAMS</inputMethod>\n\
<model>\n\
<![CDATA[\n";

    // The model itself.
    the_xml += input_string;

    // Post-model XML
    the_xml += "\
]]>\n\
</model>\n\
</document\n";

    return the_xml;
}

function update_element(element, result) {
    document.getElementById(element).innerHTML = result;
}

function show_file(the_file) {
    document.getElementById("input_file").value = the_file;
}

function send_to_applet() {
    var the_applet = document.getElementById("the_applet");
    var text_to_send = document.getElementById("input_file").value;
    the_applet.JSsubmit(text_to_send);
}

function send_to_neos() {

    // We are going to submit a job.
    var the_request = new XmlRpcRequest("http://www.neos-dev-1.neos-server.org:3332", "submitJob");
//    var the_request = new XmlRpcRequest("http://neos-1.chtc.wisc.edu:3332", "submitJob");
    the_request.crossDomain = true;
//    the_request.withCredentials = true;
//    the_request.setHeader("Origin", "192.168.1.118");
//    the_request.setHeader("Access-Control-Request-Method", "POST");
    the_request.addParam(turn_into_xml(input_file.innerHTML));
    console.log(the_request);
    var response = the_request.send();

    alert(response.parseXML());
}

function submit_toggle() {

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
