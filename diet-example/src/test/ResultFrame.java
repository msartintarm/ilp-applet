package test;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.util.List;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import org.neos.client.FileUtils;
import org.neos.client.ResultCallback;

/**
 * Frame for displaying job result. By using frame, we can display this as a
 * popup for each job instance
 * 
 * @author Thawan Kooburat
 * 
 */
public class ResultFrame extends JFrame implements ResultCallback {

	private List<Food> foodList;
	private List<Nutrient> nutrientList;
	private JobStat stat;
	JTextArea resultTextArea;

	public ResultFrame(List<Food> foodList, List<Nutrient> nutrientList) {
		super("Submitting a job");

		this.foodList = foodList;
		this.nutrientList = nutrientList;

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

	public void showJobInfo(JobStat stat) {

	}

	private void showResult() {

		if (stat.isFeasible()) {
			resultTextArea.append("Total cost   :\t" + stat.getTotalCost()
					+ " USD\n");
			setTitle("Job Result");

		} else {
			// TODO Find a way to deal with infeasible in GAMS
			// currently we don't display anything
			resultTextArea
					.append("The problem is infeasible: please add more food or adjust constraints\n");
			setTitle("Infeasible Problem");
			return;
		}
		FoodDualCostPanel foodDualCostPanel = new FoodDualCostPanel(foodList);
		NutrientDualCostPanel nutrientDualCostPanel = new NutrientDualCostPanel(
				nutrientList);

		ResultCostPanel costPanel = new ResultCostPanel(foodList);

		JLabel costLabel = new JLabel("Food Cost Table");
		JLabel foodLabel = new JLabel("Food Dual Cost Table");
		JLabel nutrientLabel = new JLabel("Nutrient Dual Cost Table");

		costPanel.setPreferredSize(new Dimension(600, 200));
		foodDualCostPanel.setPreferredSize(new Dimension(600, 150));
		nutrientDualCostPanel.setPreferredSize(new Dimension(600, 195));

		JPanel contentPanel = new JPanel();
		contentPanel.setLayout(new BoxLayout(contentPanel, BoxLayout.Y_AXIS));
		contentPanel.add(costLabel);
		contentPanel.add(costPanel);

		contentPanel.add(foodLabel);
		contentPanel.add(foodDualCostPanel);
		add(contentPanel, BorderLayout.CENTER);

		JPanel nutrientPane = new JPanel();
		nutrientPane.setLayout(new BoxLayout(nutrientPane, BoxLayout.Y_AXIS));
		nutrientPane.add(nutrientLabel);
		nutrientPane.add(nutrientDualCostPanel);
		add(nutrientPane, BorderLayout.SOUTH);
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

		DataUtils dataUtils = DataUtils.getInstance(FileUtils.APPLICATION_MODE);
		String results = dataUtils.readFile(DataUtils.FEASIBLE);
		List<Nutrient> nutList = dataUtils.readNutrient();
		List<Food> foodList = dataUtils.readFood(nutList);

		ResultFrame popup = new ResultFrame(foodList, nutList);

		popup.handleJobInfo(4234, "fdsfsd");
		try {
			// Mimic waiting for result from NEOS
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		popup.handleFinalResult(results);

	}

	@Override
	public void handleJobInfo(int jobNo, String pass) {
		// TODO Auto-generated method stub

		this.stat = new JobStat();
		stat.setJobNumber("" + jobNo);
		stat.setJobPassword(pass);

		setTitle("Waiting for Result");
		resultTextArea.setText("");
		resultTextArea.append("Job Number   :\t" + stat.getJobNumber() + "\n");
		resultTextArea
				.append("Job Password :\t" + stat.getJobPassword() + "\n");
		pack();
	}

	@Override
	public void handleFinalResult(String results) {
		// TODO Auto-generated method stub
		DietUtils.parseResult(results, foodList, nutrientList, stat);
		showResult();
		pack();
	}

}
