package org.neos.tutorial;

import java.awt.Dimension;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BoxLayout;
import javax.swing.CellEditor;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableModel;

import org.neos.casestudies.diet.DataUtils;
import org.neos.casestudies.diet.Food;
import org.neos.casestudies.diet.Nutrient;
import org.neos.client.FileUtils;

public class SimpleFoodSelectionPanel extends JPanel {
	private JTable table;
	private FoodTableModel model;

	protected List<SimpleFood> foodList;

	public SimpleFoodSelectionPanel(List<SimpleFood> foodList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		model = new FoodTableModel();
		table = new JTable(model);
		// table.setPreferredScrollableViewportSize(new Dimension(500, 70));
		table.setFillsViewportHeight(true);

		// table.setRowSelectionAllowed(false);
		table.setColumnSelectionAllowed(false);
		// table.setCellSelectionEnabled(false);
		this.foodList = foodList;

		add(new JScrollPane(table));

	}

	/**
	 * Cell can be in edit state when user press submit button, This method stop
	 * the editing so the user change is apply to the data model
	 */
	public void stopEditing() {
		if (table.getCellEditor() != null) {
			table.getCellEditor().stopCellEditing();
		}

	}

	public void updateData(List<SimpleFood> foodList) {
		this.foodList = foodList;
		model.fireTableDataChanged();
	}

	class FoodTableModel extends AbstractTableModel {
		// -----------------------------------------------------
		// Give column names

		private String[] columnNames = { "", "" };

		// -----------------------------------------------------

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
			SimpleFood food = foodList.get(row);

			// -----------------------------------------------------
			// Return correct value
			switch (col) {
			case 0:
				//Return value from food
				return null;
			case 1:
				//Return value from food
				return null;
			default:
				return null;
			}
			// -----------------------------------------------------

		}

		/*
		 * JTable uses this method to determine the default renderer/ editor for
		 * each cell. If we didn't implement this method, then the last column
		 * would contain text ("true"/"false"), rather than a check box.
		 */
		public Class getColumnClass(int c) {
			return getValueAt(0, c).getClass();
		}

		/*
		 * Don't need to implement this method unless your table's editable.
		 */
		public boolean isCellEditable(int row, int col) {
			// Note that the data/cell address is constant,
			// no matter where the cell appears onscreen.

			// -----------------------------------------------------
			// enable/disable editing for each column
			if (col == 0) {
				return true;
			} else {
				return false;
			}
			// -----------------------------------------------------

		}

		/*
		 * Don't need to implement this method unless your table's data can
		 * change.
		 */
		public void setValueAt(Object value, int row, int col) {
			SimpleFood food = foodList.get(row);

			// -----------------------------------------------------
			// Handle editing here
			switch (col) {
			case 0:	
				//Update food value
				break;
			case 1:
				//Update food value
				break;
			default:
				break;
			}
			// -------------------------------------------------------

			fireTableCellUpdated(row, col);
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
		FileUtils fileUtils = FileUtils.getInstance(FileUtils.APPLICATION_MODE);

		String mapping = fileUtils
				.readFile("resources/tutorial/food-mapping.conf");

		// Parse food mapping
		ArrayList<SimpleFood> foodList = SimpleFood.parseMapping(mapping);
		
		// Create and set up the content pane.
		SimpleFoodSelectionPanel contentPane = new SimpleFoodSelectionPanel(
				foodList);
		contentPane.setOpaque(true); // content panes must be opaque
		contentPane.setPreferredSize(new Dimension(400, 150));
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
