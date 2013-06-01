package org.neos.tutorial;

import java.awt.Dimension;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.UIManager;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.neos.client.FileUtils;

/**
 * Adapted from http://supertomate.wikispaces.com/JFreeChart+And+Applet
 */
public class SimpleDietChartPanel extends JPanel {

	List<SimpleFood> foodList;

	public SimpleDietChartPanel(List<SimpleFood> foodList) {
		super();

		this.foodList = foodList;

		// Get the graph (generateGraph will create the JFreeChart graph and add
		// the red and blue point on it).
		JFreeChart jFreeChart = generateChart(foodList);

		// Put the jFreeChart in a chartPanel
		ChartPanel chartPanel = new ChartPanel(jFreeChart);
		chartPanel.setPreferredSize(new Dimension(400, 300));
		chartPanel.setPopupMenu(null);

		this.add(chartPanel);

	}

	public JFreeChart generateChart(List<SimpleFood> foodList) {

		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		for (SimpleFood food : foodList) {
			// ------------------------------------------------------------
			// Populate dataset here
			// We should add any food that has buy > 0
			// dataset.addValue( VALUE, SERIES, CATEGORY );

			
			// ------------------------------------------------------------
		}

		// create the chart...
		JFreeChart chart = ChartFactory.createBarChart("", // chart title
				"Food", // domain axis label
				"Buy", // range axis label
				dataset, // data
				PlotOrientation.VERTICAL, // orientation
				true, // include legend
				true, // tooltips?
				false // URLs?
				);

		return chart;
	}

	/**
	 * Create the GUI and show it. For thread safety, this method should be
	 * invoked from the event-dispatching thread.
	 */
	private static void createAndShowGUI() {
		// Disable boldface controls.
		UIManager.put("swing.boldMetal", Boolean.FALSE);

		// Create and set up the window.
		JFrame frame = new JFrame("DietFoodPanel");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		FileUtils fileUtils = FileUtils.getInstance(FileUtils.APPLICATION_MODE);

		String mapping = fileUtils
				.readFile("resources/tutorial/food-mapping.conf");

		// Parse food mapping and set default value
		ArrayList<SimpleFood> foodList = new ArrayList<SimpleFood>();
		String[] lines = mapping.split("\n");

		int count = 1;
		for (String line : lines) {

			String[] tokens = line.split(":");
			if (tokens.length == 2) {
				SimpleFood food = new SimpleFood();
				food.setLongName(tokens[1]);
				food.setShortName(tokens[0]);
				food.setSelected(false);
				food.setBuy((double) count);

				foodList.add(food);
				count++;
			}
			if (count > 4)
				break;

		}

		// Create and set up the content pane.
		SimpleDietChartPanel contentPane = new SimpleDietChartPanel(foodList);
		contentPane.setOpaque(true); // content panes must be opaque
		contentPane.setPreferredSize(new Dimension(420, 320));
		frame.setContentPane(contentPane);

		// Display the window.
		frame.pack();
		frame.setVisible(true);
	}

	public static void main(String[] args) {

		// Schedule a job for the event-dispatching thread:
		// creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createAndShowGUI();
			}
		});
	}

}
