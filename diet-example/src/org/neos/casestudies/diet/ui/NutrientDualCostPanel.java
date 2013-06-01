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

public class NutrientDualCostPanel extends JPanel {
	private JTable table;

	protected List<Nutrient> nutrientList = new ArrayList<Nutrient>();

	public NutrientDualCostPanel(List<Nutrient> nutrientList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		table = new JTable(new NutrientDualCostTableModel());
		// table.setPreferredScrollableViewportSize(new Dimension(500, 195));
		table.setFillsViewportHeight(true);

		table.setColumnSelectionAllowed(false);

		add(new JScrollPane(table));

		for (Nutrient nutrient : nutrientList) {
			if (nutrient.isSelected())
				this.nutrientList.add(nutrient);
		}

		TableColumn col = table.getColumnModel().getColumn(3);
		col.setCellRenderer(new NutrientTableCellRenderer());

	}

	class NutrientTableCellRenderer extends DefaultTableCellRenderer {

		public Component getTableCellRendererComponent(JTable table,
				Object value, boolean isSelected, boolean hasFocus, int row,
				int col) {
			Component comp = super.getTableCellRendererComponent(table, value,
					isSelected, hasFocus, row, col);

			Double[] values = nutrientList.get(row).getDualCostTable();

			if ((values[2].equals(values[1])) || (values[2].equals(values[3]))) {
				// System.out.println(" " + row + " " + col );
				comp.setBackground(Color.yellow);
			} else {
				comp.setBackground(Color.white);
			}

			return (comp);
		}
	}

	class NutrientDualCostTableModel extends AbstractTableModel {

		private String[] columnNames = { "Name", "Lower Dual Cost",
				"Lower Bound", "Constraint Activity", "Upper Bound",
				"Upper Dual Cost" };

		public int getColumnCount() {
			return columnNames.length;
		}

		public int getRowCount() {
			return nutrientList.size();
		}

		public String getColumnName(int col) {
			return columnNames[col];
		}

		public Object getValueAt(int row, int col) {

			Nutrient nutrient = nutrientList.get(row);
			if (col == 0)
				return nutrient.getName();
			else
				return nutrient.getDualCostTable()[col - 1];

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
		NutrientDualCostPanel newContentPane = new NutrientDualCostPanel(
				nutList);
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
