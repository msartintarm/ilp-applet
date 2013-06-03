package test;

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

import org.neos.client.FileUtils;


/**
 * Cost display panel
 * @author Thawan Kooburat
 *
 */
public class ResultCostPanel extends JPanel {
	private JTable table;

	protected List<Food> foodList = new ArrayList<Food>();

	public ResultCostPanel(List<Food> foodList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		//We create a new list based on selected (by user) food only
		for (Food food : foodList) {
			if (food.isSelected())
				this.foodList.add(food);
		}

		table = new JTable(new ResultCostTableModel());
		// table.setPreferredScrollableViewportSize(new Dimension(500, 70));
		table.setFillsViewportHeight(true);
		table.setColumnSelectionAllowed(false);
		for (int i = 0; i < table.getColumnModel().getColumnCount(); i++) {
			TableColumn col = table.getColumnModel().getColumn(i);
			col.setCellRenderer(new ResultTableCellRenderer());
		}

		add(new JScrollPane(table));

	}

	class ResultTableCellRenderer extends DefaultTableCellRenderer {
		
		/**
		 * Render cell green when food is selected by the model
		 */
		public Component getTableCellRendererComponent(JTable table,
				Object value, boolean isSelected, boolean hasFocus, int row,
				int col) {
			Component comp = super.getTableCellRendererComponent(table, value,
					isSelected, hasFocus, row, col);

			if (!(foodList.get(row).getSolutionRow().getLevel() == 0)) {
				// System.out.println(" " + row + " " + col );
				comp.setBackground(Color.green);
			} else {
				comp.setBackground(Color.white);
			}

			return (comp);
		}
	}

	class ResultCostTableModel extends AbstractTableModel {

		private String[] columnNames = { "Name", "Buy", "Cost" };

		public int getColumnCount() {
			return columnNames.length;
		}

		public int getRowCount() {

			return foodList.size();
		}

		public String getColumnName(int col) {
			return columnNames[col];
		}

		public Object getValueAt(int row, int col) {

			Food food = foodList.get(row);
			switch (col) {
			case 0:
				return food.getLongName();

			case 1:
				return food.getSolutionRow().getLevel();
			case 2:
				double buy,
				cost,
				totalCost;
				try {
					cost = Double.parseDouble(food.getCost());
					totalCost = cost * food.getSolutionRow().getLevel();
				} catch (NumberFormatException e) {
					buy = cost = totalCost = 0;
				}
				return (float)totalCost;
			default:
				return null;
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
		ResultCostPanel newContentPane = new ResultCostPanel(foodList);
		newContentPane.setOpaque(true); // content panes must be opaque

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
