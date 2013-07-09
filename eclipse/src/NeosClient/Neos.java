package NeosClient;

import java.util.Vector;
import java.applet.Applet;
import java.awt.event.*;
import java.io.*;

import javax.swing.Timer;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;
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

static JSObject js_dashboard;

Timer the_timer;

String readFile(String path) {

  try {
    BufferedReader input = new BufferedReader(new InputStreamReader(getClass()
        .getResourceAsStream("/" + path)));
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

String js_model = "";
boolean js_submitted = false;

public void JSsubmit(String the_model) {
  js_model = the_model;
  js_submitted = true;
}

// Called at applet's creation.
@Override
public void init() {
  js_dashboard = JSObject.getWindow(this);
}

@Override
//Called when applet has finished loading.
public void start() {

  js_show_file(readFile("input_model.gms"));
  
//Sets up delay to check for JS model
  ActionListener watch_submission = new ActionListener() {
    public void actionPerformed(ActionEvent evt) {
      if(js_submitted == false) return;
      js_submitted = false; // reset our flag
      sendToNeos(js_model);
    }
  };
  
  int delay = 500; // milliseconds
  the_timer = new Timer(delay, watch_submission);
  the_timer.start();

  
  
//  sendToNeos(the_model);
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
final String getSolverOutput(final NeosXmlRpcClient the_client, 
    Integer the_user, String the_pass) {

  Vector params = new Vector(3);
  params.add(job_name);
  params.add(job_pass);
  params.add(saved_offset);
  try {
    Object[] result = (Object[]) the_client.execute(
        "getIntermediateResultsNonBlocking", params, 10000);
    saved_offset = (Integer) result[1];
    if (result[0] instanceof String) return (String) result[0];
    else return new String((byte[]) result[0]);

  } catch (XmlRpcException e) {
    System.err.println("Solver output query failed. " + e.toString());
    return null;
  }
}
  
public boolean sendToNeos(String the_model) {

  // Acquire 'connection'
  final NeosXmlRpcClient the_client = new NeosXmlRpcClient(
      "www.neos-server.org", "3332");
  try {
    // 'Connect' to server
    the_client.connect();
  } catch (XmlRpcException e) {
    System.err.println("Error connecting. " + e.toString());
    return false;
  }

  // Print out all the solvers we can use in MILP.
  Object[] solvers = getSolvers(the_client, "milp");
  if (solvers == null) return false;
  System.out.println("Solvers usable with \"milp\". Solver : input language.");
  for (int i = 0; i < solvers.length; ++i) {
    System.out.print(solvers[i] + " ");
  }
  System.out.print("\n");

  Object[] results = submitJob(the_client, the_model, "milp", "Gurobi", "GAMS");
  if (results == null) return false;
  
  job_name = (Integer) results[0];
  job_pass = (String) results[1];

  NeosResponse the_response = new NeosResponse(); // implements an asynchronous
                                                  // interface

  ActionListener taskPerformer = new ActionListener() {
    Integer the_offset = 0;
    Integer poll_count = 0;
    long start_time = System.nanoTime();

    // ... the code being measured ...
    @Override
    public void actionPerformed(ActionEvent evt) {
      // Every 5 seconds, check the solver status.
      if ((++poll_count % 5) == 0) {
        String the_result = jobStatus(the_client, job_name, job_pass);
        long elapsed_time = (System.nanoTime() - start_time) / 1000000000;
        System.out.println("Solver status: " + the_result
            + ", time elapsed: " + elapsed_time + " sec.");
        js_dashboard.call("update_status", new Object[] { 
            the_result, elapsed_time });
        // js_dashboard.eval("update_status('" + the_result + "', " +
        // elapsed_time + ");");
      } else {
        String the_result = getSolverOutput(the_client, job_name, job_pass);
        if (the_result.length() > 2) {
          System.out.println("\nIntermediate results: \n" + the_result
              + "\n. Offset " + the_offset);
        }
      }
    }
  };
  
  int delay = 2000; // milliseconds
  the_timer = new Timer(delay, taskPerformer);
  the_timer.start();

  // This class will handle callback in its own thread. I think it checks every
  // 100 ms.
  ResultReceiver receiver = new ResultReceiver(
      the_client, the_response, job_name, job_pass);
  receiver.start();

  return true; // Boom goes the dynamite.
}

@Override
public void stop() {
}

public static void main(String[] args) {
}

}
