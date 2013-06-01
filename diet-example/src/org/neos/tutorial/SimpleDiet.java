package org.neos.tutorial;

import org.neos.client.FileUtils;
import org.neos.client.NeosClient;
import org.neos.client.NeosJob;
import org.neos.client.NeosJobXml;
import org.neos.gams.SolutionData;
import org.neos.gams.SolutionParser;
import org.neos.gams.SolutionRow;

/**
 * Command line version of Diet demo
 * 
 * @author Thawan Kooburat
 * 
 */
public class SimpleDiet {

	private static final String HOST = "neos1.chtc.wisc.edu";
	private static final String PORT = "3332";

	private static final boolean SOLUTION_PARSER = false;
	private static final boolean RESULTS_TXT = false;

	public static void main(String[] args) {

		NeosClient client = new NeosClient(HOST, PORT);

		// Helper utility to read file
		FileUtils fileUtils = FileUtils.getInstance(FileUtils.APPLICATION_MODE);
		// String containing the model
		String model = fileUtils.readFile("resources/tutorial/simplediet.txt");

		// -------------------------------------------------------------------
		// Create job xml here
		// See XML Spec from
		// "http://www.neos-server.org/neos/solvers/nco:MINOS/GAMS-help.html"
		
		 NeosJobXml job = new NeosJobXml("category", "SolverName", "Input");
		 job.addParam("parameterName", "parameterValue");	

		// --------------------------------------------------------------------

		// Submit job
		NeosJob result = client.submitJob(job.toXMLString());

		// Get result
		if (result != null) {
			System.out.println("-----------Job Result-----------");
			System.out.println(result.getResult());
		}

		/*
		 * Parse job result using Solution Parser
		 */
		if (SOLUTION_PARSER) {
			System.out.println("-----------Parsed Result-----------");

			SolutionParser parser = new SolutionParser(result.getResult());
			System.out.printf("Model Status: %s [%s]\n",
					parser.getModelStatusCode(), parser.getModelStatus());
			System.out.printf("Solver Status: %s [%s]\n",
					parser.getSolverStatusCode(), parser.getSolverStatus());

			// Feasible or not
			if (parser.getModelStatusCode() == 1) {

				SolutionData buy = null;
				SolutionData cost = null;

				// -------------------------------------------------------------------
				// Extract output here
				// Eg. buy = parser.getSymbol("name", SolutionData.VAR | SolutionData.EQU, dimension) 
								
				buy = null;
				cost = null;


				// -------------------------------------------------------------------

				System.out.printf("Objective: %s \n", parser.getObjective());
				if (cost != null) {

					SolutionRow row = cost.getRows().get(0);
					Double costValue = row.getLevel();

					System.out.println("Cost: " + costValue);
				}

				if (buy != null) {
					// print header
					System.out.println("Food \t Level \t Marignal");
					for (SolutionRow row : buy.getRows()) {

						// -------------------------------------------------------------------
						// Extract food data here
						
						String foodName = "";
						Double level = 0.0;
						Double marginal = 0.0;

						// -------------------------------------------------------------------

						System.out.printf("[%7s] %7s %7s\n", foodName, level,
								marginal);
					}
				}
			}
		}

		
		/*
		 * Get resuls.txt file
		 */
		if (RESULTS_TXT) {
			String output = "";
			if (result != null) {
				
				// Retrieve results.txt file
				
				output = client.getResultsFile(result.getJobNo(),
						result.getJobPass());
				
				System.out.println("-----------Results.txt-----------");
				System.out.println(output);
				
				
				System.out.println("-------Results.txt (Tokens)------");				
				String[] lines = output.split("\n");
				for(String line : lines) {
					String[] tokens = line.split(",");
					for(String token : tokens){
						System.out.print(token.trim() + "\t");
					}
					System.out.println();
				}
					
			}

		}

	}
}
