package org.neos.examples;

import java.util.List;
import java.util.Vector;

import org.apache.ws.commons.util.Base64;
import org.apache.xmlrpc.XmlRpcException;
import org.neos.casestudies.diet.DataUtils;
import org.neos.casestudies.diet.DietUtils;
import org.neos.casestudies.diet.Food;
import org.neos.casestudies.diet.Nutrient;
import org.neos.client.FileUtils;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;
import org.neos.gams.SolutionData;
import org.neos.gams.SolutionParser;
import org.neos.gams.SolutionRow;

/**
 * Command line version of Diet demo
 * 
 * @author Thawan Kooburat
 * 
 */
public class DietGDX {

	private static final String HOST = "neos1.chtc.wisc.edu";
	private static final String PORT = "3332";

	public static void main(String[] args) {

		NeosXmlRpcClient client = new NeosXmlRpcClient(HOST, PORT);
		ResultReceiver reciever;

		FileUtils fileUtils = FileUtils.getInstance(FileUtils.APPLICATION_MODE);

		String model = fileUtils.readFile("resources/dietgdx.mod");
		byte[] gdx = fileUtils.readBinaryFile("resources/diet.gdx");

		NeosJobXml dietJob = new NeosJobXml("nco", "MINOS", "GAMS");

		dietJob.addParam("model", model);
		dietJob.addBinaryParam("gdx", gdx);

		Vector params = new Vector();
		// Job xml
		String job = dietJob.toXMLString();
		params.add(job);

		Integer jobNo = 0;
		String jobPass = "";

		String result = "";

		try {
			client.connect();

			Object[] results = (Object[]) client.execute("submitJob", params,
					5000);

			jobNo = (Integer) results[0];
			jobPass = (String) results[1];

			System.out.println("submitted" + results);

			params = new Vector();
			params.add(jobNo);
			params.add(jobPass);

			String neosStatus = "";

			while (!neosStatus.equals("Done")) {
				neosStatus = (String) client.execute("getJobStatus", params);
				System.out.println("getStatus");
			}

			Object retval = client.execute("getFinalResults", params);
			System.out.println("getResult");
			if (retval instanceof String) {
				result = (String) retval;
			} else if (retval instanceof byte[]) {
				result = (new String((byte[]) retval));

			}

		} catch (XmlRpcException e) {
			System.out.println("Error submitting job :" + e.getMessage());
			return;
		}
		System.out.printf("Job No %d\n", jobNo);

		System.out.println(result);

	}
}
