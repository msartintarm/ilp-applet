package org.neos.tutorial;

import org.neos.client.NeosClient;
import org.neos.client.NeosJob;
import org.neos.client.NeosJobXml;

/**
 * Hello NEOS example
 * 
 * @author Thawan Kooburat
 * 
 */
public class HelloNEOS {

	private static final String HOST = "neos1.chtc.wisc.edu";
	private static final String PORT = "3332";

	public static void main(String[] args) {

		/*
		 * See Job XML Spec from:
		 * "http://www.neos-server.org/neos/solvers/test:HelloNEOS/default-help.html"
		 */

		// Create job xml
		NeosJobXml job = new NeosJobXml("test", "HelloNEOS", "default");
		job.addParam("num1", "55");
		job.addParam("num2", "100");
		job.addParam("operation", "Multiplication");

		
		//Connect to server
		NeosClient client = new NeosClient(HOST, PORT);
		
		//Submit job XML
		NeosJob result = client.submitJob(job.toXMLString());

		if (result != null) {
			System.out.println("-----------Job Result-----------");
			//Print result
			System.out.println(result.getResult());
		}

	}
}
