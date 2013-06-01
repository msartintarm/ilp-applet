package org.neos.casestudies.diet;

import java.util.List;
import java.util.Vector;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.FileUtils;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;
import org.neos.gams.SolutionData;
import org.neos.gams.SolutionParser;
import org.neos.gams.SolutionRow;

/**
 * Command line version of Diet demo
 * @author Thawan Kooburat
 *
 */
public class DietMain {

	private static final String HOST = "www.neos-server.org";
	private static final String PORT = "3332";

	public static void main(String[] args) {

		NeosXmlRpcClient client = new NeosXmlRpcClient(HOST, PORT);
		ResultReceiver reciever;
		
		DataUtils dataUtils = DataUtils.getInstance(FileUtils.APPLICATION_MODE);

		List<Nutrient> nutList = dataUtils.readNutrient();
		List<Food> foodList = dataUtils.readFood(nutList);
		String model = dataUtils.readFile(DataUtils.MODEL);

		// Select some food
		int count = 0;
		for (Food food : foodList) {
			food.setSelected(true);
			count++;
			if (count > 20)
				break;
		}

		String combinedModel = DietUtils.generateData(foodList, nutList,model);

		NeosJobXml dietJob = new NeosJobXml("nco", "MINOS", "GAMS");
				
		dietJob.addParam("model", combinedModel);
		
		Vector params = new Vector();
		// Job xml
		String job = dietJob.toXMLString();
		System.out.println(job);
		
		params.add(job);		

		Integer currentJob = 0;
		String currentPassword = "";

		String result = "";

		try {
			client.connect();

			Object[] results = (Object[]) client.execute("submitJob", params,
					5000);

			currentJob = (Integer) results[0];
			currentPassword = (String) results[1];

			System.out.println("submitted" + results);

			params = new Vector();
			params.add(currentJob);
			params.add(currentPassword);

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
		//System.out.println(result);
		
		SolutionParser parser = new SolutionParser(result);
		
		System.out.printf("Model Status: %s %s\n", parser.getModelStatusCode(), parser.getModelStatus());
		System.out.printf("Solver Status: %s %s\n", parser.getSolverStatusCode(), parser.getSolverStatus());
		SolutionData buy = null;
		SolutionData cost = null;
		System.out.println(result);		
		if (parser.getSolverStatusCode() == 1) {
			System.out.printf("Objective: %s \n", parser.getObjective());
			buy = parser.getSymbol("x", SolutionData.VAR, 1 );
			cost = parser.getSymbol("cost", SolutionData.VAR, 0 );
		}
		
		for(SolutionRow row : buy.getRows()) {
			System.out.printf("Buy: %s %s %s\n", row.getIndex(0), row.getLevel(), row.getMarginal());
		}
			

	}
}
