package org.neos.tutorial.solution;

import java.awt.BorderLayout;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import org.neos.casestudies.diet.DietUtils;
import org.neos.casestudies.diet.ui.DietPanel;
import org.neos.client.FileUtils;
import org.neos.client.ResultCallback;
import org.neos.gams.SolutionData;
import org.neos.gams.SolutionParser;
import org.neos.gams.SolutionRow;

/**
 * Frame for displaying job result. By using frame, we can display this as a
 * popup for each job instance
 * 
 * @author Thawan Kooburat
 * 
 */
public class SimpleDietResultFrame extends JFrame implements ResultCallback {

	private List<SimpleFood> foodList;
	JTextArea resultTextArea;

	double cost;
	boolean feasible = false;

	public SimpleDietResultFrame(List<SimpleFood> foodList) {
		super("Submitting a job");

		// We use a new copy of data,
		// This is required if we use table to display data, so that result of 
		// a new job do not overwrite our result. 
		
		this.foodList =	(List<SimpleFood>) FileUtils.deepCopy(foodList);		

		setLayout(new BorderLayout());

		resultTextArea = new JTextArea(3, 30);

		JLabel resultLabel = new JLabel("Result");
		resultTextArea.setText("Submitting job to NEOS\n");

		JPanel resultPane = new JPanel();
		resultPane.setLayout(new BoxLayout(resultPane, BoxLayout.Y_AXIS));
		resultPane.add(resultLabel);
		resultPane.add(resultTextArea);
		add(resultPane, BorderLayout.NORTH);
		pack();
		setVisible(true);
	}

	@Override
	public void handleJobInfo(int jobNo, String jobPass) {

		setTitle("Waiting for Result");
		resultTextArea.setText("");
		resultTextArea.append("Job Number   :\t" + jobNo + "\n");
		resultTextArea.append("Job Password :\t" + jobPass + "\n");
		pack();
	}

	@Override
	public void handleFinalResult(String results) {

		SolutionParser parser = new SolutionParser(results);

		// Feasible or not
		if (parser != null && parser.getModelStatusCode() == 1) {
			feasible = true;
			SolutionData buy = parser.getSymbol("buy", SolutionData.VAR, 1);
			SolutionData cost = parser.getSymbol("cost", SolutionData.VAR, 0);

			if (cost != null) {

				SolutionRow row = cost.getRows().get(0);
				this.cost = row.getLevel();

			}

			if (buy != null) {
				for (SolutionRow row : buy.getRows()) {
					if (row.getLevel() == 0)
						continue;

					for (SimpleFood food : foodList) {
						if (food.getShortName().equals(row.getIndex(0)))
							food.setBuy(row.getLevel());
					}

				}
			}

		} else {
			feasible = false;
		}

		showResult();

		pack();
	}

	private void showResult() {

		if (feasible) {
			resultTextArea.append("Total cost   :\t" + cost + " USD\n");
			setTitle("Job Result");

		} else {

			resultTextArea
					.append("The problem is infeasible: please add more food or adjust constraints\n");
			setTitle("Infeasible Problem");
			return;
		}

		SimpleDietChartPanel chartPanel = new SimpleDietChartPanel(foodList);

		add(chartPanel);
	}

	public void createGUI() {
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				// Create and set up the window.
				JFrame frame = new JFrame("Diet Problem");
				frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

				// Create and set up the content pane.
				DietPanel newContentPane = new DietPanel(
						FileUtils.APPLICATION_MODE);
				newContentPane.setOpaque(true); // content panes must be opaque

				frame.setContentPane(newContentPane);

				// Display the window.
				frame.pack();
				frame.setVisible(true);
			}
		});
	}

	public static void main(String[] args) {

		FileUtils fileUtils = FileUtils.getInstance(FileUtils.APPLICATION_MODE);
		String results = fileUtils.readFile("resources/tutorial/feasible.txt");

		String mapping = fileUtils
				.readFile("resources/tutorial/food-mapping.conf");

		// Parse food mapping and set default value
		ArrayList<SimpleFood> foodList = SimpleFood.parseMapping(mapping);

		SimpleDietResultFrame popup = new SimpleDietResultFrame(foodList);

		try {
			// Mimic waiting for result from NEOS
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		popup.handleJobInfo(23423, "test");
		try {
			//Mimic waiting for result from neos
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		popup.handleFinalResult(results);

	}

}
