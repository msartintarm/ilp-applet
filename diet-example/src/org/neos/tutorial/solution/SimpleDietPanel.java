package org.neos.tutorial.solution;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

import org.neos.casestudies.diet.DietUtils;
import org.neos.client.FileUtils;
import org.neos.client.NeosClient;
import org.neos.client.NeosJob;
import org.neos.client.NeosJobXml;
import org.neos.gams.Set;

/**
 * Main class for Diet GUI version
 * 
 * @author Thawan Kooburat
 * 
 */
public class SimpleDietPanel extends JPanel implements ActionListener {

	private static final String SUBMIT_COMMAND = "submit";
	private static final String RESET_COMMAND = "reset";

	private static final String HOST = "neos1.chtc.wisc.edu";
	private static final String PORT = "3332";

	NeosClient client = new NeosClient(HOST, PORT);

	SimpleFoodSelectionPanel selectionPanel;

	private JButton submitButton;
	private JButton resetButton;

	private List<SimpleFood> foodList;
	private List<SimpleFood> oriFoodList;

	private String dataDomain;
	private String foodmapping;
	private String model;

	private FileUtils fileUtils;

	public SimpleDietPanel(int mode) {
		super();

		fileUtils = FileUtils.getInstance(mode);

		init();

	}

	public void init() {
		loadData();
		createGUI();

	}

	public void loadData() {
		dataDomain = fileUtils
				.readFile("resources/tutorial/simplediet-data.txt");
		model = fileUtils.readFile("resources/tutorial/simplediet-model.txt");
		foodmapping = fileUtils
				.readFile("resources/tutorial/food-mapping.conf");

		// Parse food mapping
		oriFoodList = SimpleFood.parseMapping(foodmapping);

		// Clone original data;
		foodList = (List<SimpleFood>) fileUtils.deepCopy(oriFoodList);

	}

	public void createGUI() {

		setLayout(new BorderLayout());

		JButton submitButton = new JButton("Submit");
		submitButton.setActionCommand(SUBMIT_COMMAND);
		submitButton.addActionListener(this);

		JButton resetButton = new JButton("Reset");
		resetButton.setActionCommand(RESET_COMMAND);
		resetButton.addActionListener(this);

		// Lay everything out.
		JPanel buttonPanel = new JPanel(new GridLayout(1, 2));
		// buttonPanel.setPreferredSize(new Dimension(200, 30));
		buttonPanel.add(submitButton);
		buttonPanel.add(resetButton);
		add(buttonPanel, BorderLayout.SOUTH);

		// setSize(new Dimension(300, 200));

		selectionPanel = new SimpleFoodSelectionPanel(foodList);
		add(selectionPanel, BorderLayout.CENTER);

		setPreferredSize(new Dimension(500, 300));
	}

	public void actionPerformed(ActionEvent e) {
		String command = e.getActionCommand();

		if (command.equals(SUBMIT_COMMAND)) {
			submitJob();

		} else if (command.equals(RESET_COMMAND)) {
			clearSelection();
		}

	}

	void clearSelection() {
		
		//Create a new copy of original data and force the selection panel to use a new data
		//Any modification by the selection panel will affect the foodList as well 
		foodList = (List<SimpleFood>) DietUtils.deepCopy(oriFoodList);
		selectionPanel.updateData(foodList);
		
	}
	
	
	String getSelection() {
		Set fs = new Set("fs(f)", "Food selected");
		for (SimpleFood food : foodList) {
			if (food.getSelected())
				fs.addValue(food.getShortName());
		}
		return fs.toString();
	}
	
	

	void submitJob() {

		String selected = "Set fs(f) foods selected  / Bro1,Chi66,Por50,Pot7,Tor56 /;";

		String combinedModel = dataDomain + getSelection() + model;

		NeosJobXml dietJob = new NeosJobXml("nco", "MINOS", "GAMS");

		dietJob.addParam("model", combinedModel);

		SimpleDietResultFrame jobFrame = new SimpleDietResultFrame(foodList);

		NeosJob job = client.submitJobNonBlocking(dietJob.toXMLString(),
				jobFrame);		
		

	}

	public static void main(String[] args) {

		// Schedule a job for the event-dispatching thread:
		// creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				// Create and set up the window.
				JFrame frame = new JFrame("Diet Problem");
				frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

				// Create and set up the content pane.
				SimpleDietPanel newContentPane = new SimpleDietPanel(
						FileUtils.APPLICATION_MODE);
				newContentPane.setOpaque(true); // content panes must be opaque

				frame.setContentPane(newContentPane);

				// Display the window.
				frame.pack();
				frame.setVisible(true);
			}
		});
	}

}
