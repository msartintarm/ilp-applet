package org.neos.casestudies.diet.ui;

import java.awt.Color;
import java.awt.Component;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableColumn;

import org.neos.casestudies.diet.DataUtils;
import org.neos.casestudies.diet.DietUtils;
import org.neos.casestudies.diet.Food;
import org.neos.casestudies.diet.JobStat;
import org.neos.casestudies.diet.Nutrient;
import org.neos.client.FileUtils;
import org.neos.gams.SolutionRow;

/**
 * Panel for displaying Food dual cost table
 * 
 * @author Thawan Kooburat
 * 
 */
public class FoodDualCostPanel extends JPanel {
	private JTable table;

	protected List<Food> foodList = new ArrayList<Food>();

	public FoodDualCostPanel(List<Food> foodList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		table = new JTable(new FoodDualCostTableModel());
		// table.setPreferredScrollableViewportSize(new Dimension(500, 70));
		table.setFillsViewportHeight(true);
		table.setColumnSelectionAllowed(false);

		add(new JScrollPane(table));

		for (Food food : foodList) {
			if (food.isSelected())
				this.foodList.add(food);
		}

		TableColumn col = table.getColumnModel().getColumn(2);
		col.setCellRenderer(new FoodTableCellRenderer());
	}

	class FoodTableCellRenderer extends DefaultTableCellRenderer {

		/**
		 * Mark level which touch lower bound or upper bound with yellow to aid
		 * resubmission
		 */
		public Component getTableCellRendererComponent(JTable table,
				Object value, boolean isSelected, boolean hasFocus, int row,
				int col) {
			Component comp = super.getTableCellRendererComponent(table, value,
					isSelected, hasFocus, row, col);

			SolutionRow data = foodList.get(row).getSolutionRow();
			if (data.getLevel() == 0) {
				comp.setBackground(Color.white);
			} else if ((data.getLevel() == data.getLower())
					|| (data.getLevel() == data.getUpper())) {
				// System.out.println(" " + row + " " + col );
				comp.setBackground(Color.yellow);
			} else {
				comp.setBackground(Color.white);
			}

			return (comp);
		}
	}

	class FoodDualCostTableModel extends AbstractTableModel {

		private String[] columnNames = { "Name", "Lower Bound",
				"Servings in Menu", "Upper Bound", "Dual Cost" };

		public int getColumnCount() {
			return columnNames.length;
		}

		public int getRowCount() {

			return foodList.size();
		}

		public String getColumnName(int col) {
			return columnNames[col];
		}

		/**
		 * Render cell value from food object
		 */
		public Object getValueAt(int row, int col) {

			Food food = foodList.get(row);
			SolutionRow data = food.getSolutionRow();
			switch (col) {
			case 0:
				return food.getLongName();
			case 1:
				return data.getLower();
			case 2:
				return data.getLevel();
			case 3:
				return data.getUpper();
			case 4:
				return data.getMarginal();
			default:
				return 0D;
			}

		}

		/*
		 * JTable uses this method to determine the default renderer/ editor for
		 * each cell. If we didn't implement this method, then the last column
		 * would contain text ("true"/"false"), rather than a check box.
		 */
		public Class getColumnClass(int c) {
			return getValueAt(0, c).getClass();
		}

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

		DataUtils dataUtils = DataUtils.getInstance(FileUtils.APPLICATION_MODE);
		String results = dataUtils.readFile(DataUtils.FEASIBLE);
		List<Nutrient> nutList = dataUtils.readNutrient();
		List<Food> foodList = dataUtils.readFood(nutList);

		DietUtils.parseResult(results, foodList, nutList, new JobStat());

		// Create and set up the content pane.
		FoodDualCostPanel newContentPane = new FoodDualCostPanel(foodList);
		newContentPane.setOpaque(true); // content panes must be opaque
		newContentPane.setSize(500, 400);
		frame.setContentPane(newContentPane);

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
