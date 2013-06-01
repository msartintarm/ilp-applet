package org.neos.casestudies.diet.ui;

import java.util.List;

import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

import org.neos.casestudies.diet.DataUtils;
import org.neos.casestudies.diet.Nutrient;
import org.neos.client.FileUtils;

public class NutrientSelectionPanel extends JPanel {
	private JTable table;
	private NutrientTableModel model;
	protected List<Nutrient> nutrientList;

	public NutrientSelectionPanel(List<Nutrient> nutrientList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
		model = new NutrientTableModel();
		table = new JTable(model);
		// table.setPreferredScrollableViewportSize(new Dimension(500, 70));
		table.setFillsViewportHeight(true);

		// table.setRowSelectionAllowed(false);
		table.setColumnSelectionAllowed(false);
		// table.setCellSelectionEnabled(false);

		table.getTableHeader().setReorderingAllowed(false);

		add(new JScrollPane(table));

		this.nutrientList = nutrientList;

	}

	public void stopEditing() {
		if (table.getCellEditor() != null) {
			table.getCellEditor().stopCellEditing();
		}

	}

	/**
	 * Cell can be in edit state when user press submit button,
	 * This method stop the editing so the user change is apply to the data model
	 */
	public void updateData(List<Nutrient> nutrientList) {

		this.nutrientList = nutrientList;
		model.fireTableDataChanged();
	}

	class NutrientTableModel extends AbstractTableModel {

		private String[] columnNames = { "Select", "Name", "Unit", "Min", "Max" };

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
			switch (col) {
			case 0:
				return nutrient.isSelected();
			case 1:
				return nutrient.getName();
			case 2:
				return nutrient.getUnit();
			case 3:
				return nutrient.getMin();
			case 4:
				return nutrient.getMax();
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

		/*
		 * Don't need to implement this method unless your table's editable.
		 * Enable editing only on constraint columns
		 */
		public boolean isCellEditable(int row, int col) {
			// Note that the data/cell address is constant,
			// no matter where the cell appears onscreen.
			if (col >= 3 || col == 0) {
				return true;
			} else {
				return false;
			}
		}

		/*
		 * Don't need to implement this method unless your table's data can
		 * change.
		 */
		public void setValueAt(Object value, int row, int col) {
			Nutrient nutrient = nutrientList.get(row);
			switch (col) {
			case 0:
				nutrient.setSelected((Boolean) value);
				break;
			case 3:
				Integer min = (Integer) value;
				if (min > nutrient.getMax())
					nutrient.setMin(nutrient.getMax());
				else
					nutrient.setMin(min);
				break;
			case 4:
				Integer max = (Integer) value;
				if (max < nutrient.getMin())
					nutrient.setMax(nutrient.getMin());
				else
					nutrient.setMax(max);

				break;
			default:
				break;
			}

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
		DataUtils dataUtils = DataUtils.getInstance(FileUtils.APPLICATION_MODE);

		List<Nutrient> nutList = dataUtils.readNutrient();

		// Create and set up the content pane.
		NutrientSelectionPanel newContentPane = new NutrientSelectionPanel(
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
