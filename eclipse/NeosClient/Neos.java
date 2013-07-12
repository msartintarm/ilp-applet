package NeosClient;

import java.util.Vector;
import java.applet.Applet;
import java.awt.event.*;
import java.io.*;

import javax.swing.Timer;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultCallback;

import netscape.javascript.*;

class NeosResponse implements ResultCallback {

@Override
public void handleJobInfo(int job_num, String passwd) {
  System.out.println("Job " + job_num + " submitted. Password: " + passwd);
}

@Override
public void handleFinalResult(String results) {
  System.out.println("Result follows:\n " + results);
}
}

/*
 * Temporary main class designed to test the NEOS server's capability. - The
 * giant string represents a complete GAMS model of a spatial architecture. -
 * Success here means another giant string (a solution) will be returned from
 * the server. Next step: think about duplicating this in Javascript?
 */
public class Neos extends Applet {

static final long serialVersionUID = 248L;

static Integer job_name = -1;
static String job_pass = "-1";
final NeosXmlRpcClient the_client = new NeosXmlRpcClient(
      "www.neos-server.org", "3332");

static JSObject js_dashboard;
static JSObject js_case3;

static Timer the_timer;

String js_model = "";
boolean js_submitted = false;

// Construct a GAMS string for case 2.
// If we hae 'i' classes of services:
// Service[3*i] = number of services
// Service[3*i + 1] = mem usage
// Service[3*i + 2] = cpu usage
    public void JSload2(char model_type, String[] services, String[] machines) {

	switch(model_type) {
	case 'S': // SSAP
	    js_model  = "Set S /s1*s" + Integer.valueOf(services[0]) + "/;\n";
	    js_model += "Set C /c1*c" + Integer.valueOf(machines[0]) + "/;\n";
	    js_model += readFile("case2/SSAP.gms");
	    break;
	case 'W': // WSAP
	    js_model  = "Set S /s1*s" + Integer.valueOf(services[0]) + "/;\n";
	    js_model += "Set C /c1*c" + Integer.valueOf(machines[0]) + "/;\n";
	    js_model += "parameter numS(S);\n";
	    js_model += "numS(S)=" + Integer.valueOf(services[0]) + "/5;\n";
	    js_model += readFile("case2/WSAP.gms");
	    break;
	case 'T': // TSAP
	    js_model  = "Set S /s1*s" + Integer.valueOf(services[0]) + "/;\n";
	    js_model += "Set C /c1*c" + Integer.valueOf(machines[0]) + "/;\n";
	    js_model += "parameter numS(S);\n";
	    js_model += "Set T /t1*t8/;\n";
	    js_model += "numS(S)=" + Integer.valueOf(machines[0]) + "/5;\n";
	    js_model += readFile("case2/TSAP.gms");
	    break;
	case 'I': // ISAP
	    js_model  = "Set S /s1*s" + Integer.valueOf(services[0]) + "/;\n";
	    js_model += "Set C /c1*c" + Integer.valueOf(machines[0]) + "/;\n";
	    js_model += "parameter numS(S);\n";
	    js_model += "Set T /t1*t1/;\n";
	    js_model += "numS(S)=" + (Integer.valueOf(machines[0]) / Integer.valueOf(services[0])) + ";\n";
	    js_model += "numS(s1)=numS(s1)+" + (Integer.valueOf(machines[0]) % Integer.valueOf(services[0])) + ";\n";
	    js_model += readFile("case2/ISAP.gms");
	    break;
	}
  // Show the user (using Javascript) the model they specified.
  js_show_file(js_model);
}

// Construct a GAMS string for case 3.
// Check case 3's 'run-gams.sh' for a command-line version of this selector.
public void JSload3(String arch, String software_file, String hardware_file) {

    final String root = "case3/";
    js_model  = readFile(root + arch + "/kind.gms");
    js_model += readFile(root + arch + "/SW-DAG/" + software_file);
    js_model += readFile(root + arch + "/HW-GRAPH/" + hardware_file);
    js_model += readFile(root + "shared/gen-variables.gms");
    js_model += readFile(root + "shared/gen-constraints.gms");
    js_model += readFile(root + arch + "/constraints/constraints.gms");
    // Show the user (using Javascript) the model they specified.
    js_show_file(js_model);
}

// Called from Javascript, using the string in its text box.
// It cannot invoke the method directly due to sandboxing, so instead
// it will change a variable, which is monitored by a Java thread.
public void JSsubmit(String the_model) {
  js_model = the_model;
  js_submitted = true;
}

// Called at applet's creation.
// Here this gets references to HTML DOM / JS objects.
public void init() {
  js_dashboard = JSObject.getWindow(this);
  //  js_case3 = (JSObject) js_dashboard.getMember("case3");
}

@Override
// Called when the applet container has finished loading.
// Here we init a timer to check for JS updates.
// We also test the connection by querying for solvers.
public void start() {
    
    //Sets up delay to check for JS model
    ActionListener watch_submission = new ActionListener() {
	public void actionPerformed(ActionEvent evt) {
	    if(js_submitted == false) return; // reset our flag
	    else js_submitted = false;
	    sendToNeos(js_model);
	}
    };
    
    int delay = 500; // milliseconds
    the_timer = new Timer(delay, watch_submission);
    the_timer.start();

    // Acquire 'connection'
    try {
	// 'Connect' to server
	the_client.connect();
    } catch (XmlRpcException e) {
	System.err.println("Error connecting. " + e.toString());
	return;
    }

    // Print out all the solvers we can use in MILP.
    Object[] solvers = getSolvers(the_client, "milp");
    if (solvers == null) { 
	System.err.println("Solver query failed.");
	return;
    }
    System.out.println("Solvers usable with \"milp\". Solver : input language.");
    for (int i = 0; i < solvers.length; ++i) {
	System.out.print(solvers[i] + " ");
    }
    System.out.print("\n");

  // Ready to go.. toggle submit button.
  js_dashboard.call("submit_toggle", null);
}

void js_show_file(String the_text) {
  js_dashboard.call("show_file", new Object[] { the_text });
}

/**
 * Finds the solvers available for this category (milp) and language (GAMS).
 */
final Object[] getSolvers(final NeosXmlRpcClient the_client, 
                          String the_category) {

  Vector<String> solver_params = new Vector<String>(1);
  solver_params.add("milp");
  try {
    return (Object[]) the_client.execute("listSolversInCategory",
        solver_params, 5000);
  } catch (XmlRpcException e) {
      System.err.println("Error finding solvers. " + e.toString());
    return null;
  }
}

/**
 *  Submits a job, and returns the job ID and password. Quite a lot of params.
 *  This is most likely to fail to to incorrect string formatting.
 */
final Object[] submitJob(final NeosXmlRpcClient the_client, 
                         String the_model, 
                         String category, 
                         String solver, 
                         String language) {

  // Package file into server-sending format by turning it into XML within a Vector.
  Vector<String> the_params = new Vector<String>(1);
  final NeosJobXml the_job = new NeosJobXml(category, solver, language);
  the_job.addParam("model", the_model);
  the_params.add(the_job.toXMLString());

  // Submit job to NEOS, with a 5 second timeout
  try {
    return (Object[]) the_client.execute("submitJob", the_params, 5000);
  } catch (XmlRpcException e) {
    System.err.println("Error submitting job." + e.toString());
    return null;
  }
}

/**
 *  Given the job ID and password, and looks up the job status.
 */
final String jobStatus(final NeosXmlRpcClient the_client, 
    Integer the_user, String the_pass) {
  
  Vector the_params = new Vector(2);
  the_params.add(the_user);
  the_params.add(the_pass);
  try {
    return (String) the_client.execute("getJobStatus", the_params, 10000);
    } catch (XmlRpcException e) {
      System.err.println("Solver status query failed. " + e.toString());
      return null;
    }
}

int saved_offset = 0;
/**
 * Gets output of the solver since last call. Keeps an internal offset
 *   to accomplish this.
 */
final String getSolverOutput(
    final NeosXmlRpcClient client, Integer user, String pass) {

  Vector params = new Vector(3);
  params.add(user);
  params.add(pass);
  params.add(saved_offset);
  try {
    Object[] result = (Object[]) client.execute(
        "getIntermediateResultsNonBlocking", params, 10000);
    saved_offset = (Integer) result[1];
    if (result[0] instanceof String) return (String) result[0];
    else return new String((byte[]) result[0]);

  } catch (XmlRpcException e) {
    System.err.println("Solver output query failed. " + e.toString());
    return null;
  }
}
/**
 * Gets the final solution of the problem. Will return an empty
 * string if one doesn't exist.
 */
final String getSolution(
    final NeosXmlRpcClient client, Integer user, String pass) {

  Vector params = new Vector(2);
  params.add(user);
  params.add(pass);
  try {
    Object result = (Object) client.execute(
        "getFinalResultsNonBlocking", params, 10000);
    if (result instanceof String) return (String) result;
    else return new String((byte[]) result);
  } catch (XmlRpcException e) {
    System.err.println("Solver solution query failed. " + e.toString());
    return null;
  }
}
  
public boolean sendToNeos(String the_model) {

  Object[] results = submitJob(the_client, the_model, "milp", "Gurobi", "GAMS");
  if (results == null) return false;
  
  job_name = (Integer) results[0];
  job_pass = (String) results[1];

  js_dashboard.call("submit_toggle", null);

  ActionListener solution_monitor = new ActionListener() {
    Integer poll_count = 0;
    long start = System.nanoTime();
    boolean solution_found = false;
    
    void monitorJobStatus() {
      String result = jobStatus(the_client, job_name, job_pass);
      long elapsed = (System.nanoTime() - start) / 1000000000;
      String solver_status = "Solver status: " + result
          + ", time elapsed: " + elapsed + " sec.";
      System.out.println(solver_status);
      js_dashboard.call("update_element", new Object[] { "solver_status", solver_status });
      
      // Is solver still running ..? If not, let's get a solution.
      if(result.equals("Done")) {
	  //  js_case3.call("submit_toggle", null);
        this.solution_found = true;
        monitorJobOutput();
      }
    }

    void monitorJobOutput() {
      String result = getSolverOutput(the_client, job_name, job_pass);
      if (result.length() > 2) {
        System.out.println("\nIntermediate results: \n" + result);
        js_dashboard.call("update_element", new Object[] { "solver_output", result });
      }
    }

    void getJobSolution() {
      String result = getSolution(the_client, job_name, job_pass);
      if (result.length() > 2) {
        System.out.println("\nFinalresults: \n" + result);
        js_dashboard.call("update_element", new Object[] { "solver_solution", result });
      }
      // Now that we have a solution, we can stop polling the server.
      the_timer.stop();
    }
    
    public void actionPerformed(ActionEvent evt) {
      if (this.solution_found == true) { getJobSolution();
      } else {
        monitorJobStatus();
        // Every 10 seconds, check the solver output.
        if ((++poll_count % 5) == 0) {
          monitorJobOutput();
        }
      }
    }
  };
  
  int delay = 2000; // milliseconds
  the_timer = new Timer(delay, solution_monitor);
  the_timer.setInitialDelay(0);
  the_timer.start();

  // This class will handle callback in its own thread. I think it checks every
  // 100 ms.
//  ResultReceiver receiver = new ResultReceiver(
  //    the_client, the_response, job_name, job_pass);
  //receiver.start();

  return true; // Boom goes the dynamite.
}

@Override
public void stop() {}

public static void main(String[] args) {}

String readFile(String path) {

  try {
      BufferedReader input = new BufferedReader(
                             new InputStreamReader(
           	             getClass().getResourceAsStream("/" + path)));
    String the_data = "";
    String the_line;

    while ((the_line = input.readLine()) != null) {
      the_data += the_line + "\n";
    }

    input.close();
    return the_data;
  } catch (IOException e) {
    System.err.println("Error reading file " + path + ": " + e.toString());
    return null;
  } catch (NullPointerException e) {
    System.err.println("File " + path + " doesn't exist: " + e.toString());
    return null;
  }
}

}
