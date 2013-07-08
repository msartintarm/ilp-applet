import java.util.Vector;
import java.applet.Applet;
import java.awt.event.*;
import java.io.*;
import java.nio.charset.Charset;

import javax.swing.Timer;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;
import org.neos.client.ResultCallback;

import netscape.javascript.*;

class NeosResponse implements ResultCallback {

    public void handleJobInfo (int job_num, String passwd) {
	System.out.println("Job " + job_num + " submitted. Password: " + passwd);
    }
    public void handleFinalResult (String results) {
	System.out.println("Result follows:\n " + results);
    }
}

/*
  Temporary main class designed to test the NEOS server's capability.
  - The giant string represents a complete GAMS model of a spatial architecture.
  - Success here means another giant string (a solution) will be returned from the server.
  Next step: think about duplicating this in Javascript?
*/  
public class Neos extends Applet {

	static final long serialVersionUID = 248L;
	
	static Integer job_name = -1;
	static String job_pass = "-1";
	
	static JSObject js_dashboard;
	
	Timer the_timer;

    String readFile (String path, Charset method) {

    	try {
    		BufferedReader input = new BufferedReader (
    				new InputStreamReader(
    						getClass().getResourceAsStream("/" + path)
    						));
    		String the_data = "";
    		String the_line;
    		
    		while ((the_line = input.readLine()) != null) {
    			the_data += the_line + "\n";
    		}

    		input.close();
    		return the_data;
    	} catch (IOException e) {
    		System.err.println("Error reading file.. " + e);
    		return null;
    	}
    }

    String readFile (String path) { 
    	return readFile(path, Charset.defaultCharset()); 
	}
    
    public void init() {
    	
    	js_dashboard = JSObject.getWindow(this);
    	
    }
    public void start() {

    	final String the_model = readFile("input_model.gms");
    	send_to_neos(the_model);
    }
    	
	public void send_to_neos(String the_model) {
		js_dashboard.call("show_file", new Object[] {the_model} );
    	// Package 'file' into server-sending format
    	// .. first by turning it into XML ..
    	NeosJobXml the_job = new NeosJobXml("milp", "Gurobi", "GAMS");
    	the_job.addParam("model", the_model);
    	// .. and then by putting the XML into a vector.
    	Vector<String> the_params = new Vector<String>();
    	the_params.add(the_job.toXMLString());

    	final NeosXmlRpcClient the_client = new NeosXmlRpcClient("www.neos-server.org", "3332");

	try { 
	    // Connect to server
	    the_client.connect();
	    System.out.println("Connected");

	    // Print out all the solvers we can use in MILP.
	    Vector<String> solver_params = new Vector<String>();
	    solver_params.add("milp");
	    Object[] solvers = (Object[])the_client.execute("listSolversInCategory",
							    solver_params,
							    5000);
	    System.out.println("Solvers usable with \"milp\". Solver : input language.");
	    for(int i = 0; i < solvers.length; ++i) {
		System.out.print(solvers[i] + " ");
	    }
	    System.out.print("\n");

	    // Submit job to NEOS, with a 5 sec timeoue for job ID / password
	    System.out.println("About to submit..");
	    Object[] results = (Object[])the_client.execute("submitJob",
							    the_params,
							    5000);
	    System.out.println("Submitted.");
	    job_name = (Integer) results[0];
	    job_pass = (String) results[1];
	    System.out.println("submitted. Job number: " + job_name + ", job password: " + job_pass);

	    NeosResponse the_response = new NeosResponse(); // implements an asynchronous interface

	    
	    int delay = 2000; //milliseconds
	    ActionListener taskPerformer = new ActionListener() {

	    	
	    	
	    	Integer the_offset = 0;
	    	Integer poll_count = 0;
	    	long start_time = System.nanoTime();    
	    	// ... the code being measured ...    
	    	public void actionPerformed(ActionEvent evt) {
	    		if((++poll_count) == 5) {
	    			poll_count = 0;
			    	Vector the_params = new Vector();
			    	the_params.add(job_name);
			    	the_params.add(job_pass);
					try {
						Object results2 = (Object)the_client.execute("getJobStatus",
							    the_params,
							    10000);
						String the_result = "--";
						if (results2 instanceof String) {
							the_result = (String) results2;
						} else if (results2 instanceof byte[]) {
							the_result = (new String((byte[]) results2));

						}
				    	long elapsed_time = (System.nanoTime() - start_time / 1000000000);
						System.out.println("Solver status: " + the_result + ", time elapsed: " + elapsed_time + " sec.");
						js_dashboard.eval("update_status('" + the_result + "', " + elapsed_time + ");");
					} catch (XmlRpcException e) {
						System.err.println("Query failed. " + e.toString());
					}
	    		} else {
					Vector the_params = new Vector();
					the_params.add(job_name);
					the_params.add(job_pass);
					the_params.add(the_offset);
					try {
						Object[] results2 = (Object[])the_client.execute("getIntermediateResultsNonBlocking",
								the_params,
								10000);
						String the_result = "--";
						if (results2[0] instanceof String) {
							the_result = (String) results2[0];
						} else if (results2[0] instanceof byte[]) {
							the_result = (new String((byte[]) results2[0]));

						}
						the_offset = (Integer) results2[1];
						if(the_result.length() > 2) {
							System.out.println("\nIntermediate results: \n" + the_result + "\n. Offset " + the_offset);
						}
					} catch (XmlRpcException e) {
						System.err.println("Query failed! " + e.toString());
					}
	    		}	
	    	}
	    };

	    
	    the_timer = new Timer(delay, taskPerformer);
	    the_timer.start();
	    
	    // This class will handle callback in its own thread. I think it checks every 100 ms.
	    ResultReceiver receiver = new ResultReceiver(the_client, the_response, job_name, job_pass);
	    receiver.start();

	    // Boom goes the dynamite.

	} catch (XmlRpcException e) {
	    System.err.println("Uh-oh.. error! " + e);
	}
    }
    
    public void stop() {}
    
    public static void main(String[] args) {}

}


