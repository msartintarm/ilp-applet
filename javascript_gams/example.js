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




function send_to_neos() {

    // We are going to submit a job.
    var the_request = new XmlRpcRequest("http://www.neos-server.org:3332", "submitJob");
    the_request.crossDomain = true;
//    the_request.setHeader("Origin", "192.168.1.118");
//    the_request.setHeader("Access-Control-Request-Method", "POST");
    the_request.addParam(turn_into_xml(input_file.innerHTML));
    console.log(the_request);
    var response = the_request.send();

    alert(response.parseXML());
}
