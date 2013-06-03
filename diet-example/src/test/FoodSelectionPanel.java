package test;

import java.awt.event.MouseEvent;
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

import org.neos.client.FileUtils;

public class FoodSelectionPanel extends JPanel {
	private JTable table;
	private FoodTableModel model;

	protected List<Food> foodList;
	protected List<Nutrient> nutrientList;

	public FoodSelectionPanel(List<Food> foodList, List<Nutrient> nutrientList) {
		super();
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));

		model =  new FoodTableModel();
		table = new FoodTable(model);
		//table.setPreferredScrollableViewportSize(new Dimension(500, 70));
		table.setFillsViewportHeight(true);

		// table.setRowSelectionAllowed(false);
		table.setColumnSelectionAllowed(false);
		// table.setCellSelectionEnabled(false);
		add(new JScrollPane(table));

		this.foodList = foodList;
		this.nutrientList = nutrientList;

	}
	
	/**
	 * Cell can be in edit state when user press submit button,
	 * This method stop the editing so the user change is apply to the data model
	 */
	public void stopEditing() {
		if (table.getCellEditor() != null) {
		    table.getCellEditor().stopCellEditing();
		}

	}
	
	public void updateData(List<Food> foodList, List<Nutrient> nutrientList) {
		this.foodList = foodList;
		this.nutrientList = nutrientList;
		model.fireTableDataChanged();
	}

	class FoodTable extends JTable {
		public FoodTable(TableModel m) {
			super(m);
		}
		
		/**
		 * Show nutritional value of each food in tooltip
		 */
		public String getToolTipText(MouseEvent e) {
			StringBuffer tip = new StringBuffer();
			java.awt.Point p = e.getPoint();
			int rowIndex = rowAtPoint(p);
			int colIndex = columnAtPoint(p);
			int realRowIndex = convertRowIndexToModel(rowIndex);
			int realColIndex = convertColumnIndexToModel(colIndex);
			//Use html to get multi-line (with table) in tooltip
			tip.append("<html><table>");
			if (realColIndex == 1) {
				Food food = foodList.get(realRowIndex);
				for (Nutrient nutrient : nutrientList) {
					String value = food.getNutrientValue(nutrient.getName());
					tip.append("<tr><td>" + nutrient.getName() + "</td><td>" + value + "</td></tr>");
				}
			}
			tip.append("</table></html>");
			return tip.toString();
		}
	}

	class FoodTableModel extends AbstractTableModel {

		private String[] columnNames = { "Select", "Name", "Serving",
				"Price/Serving ($)", "Min", "Max" };

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
				return food.isSelected();
			case 1:
				return food.getLongName();
			case 2:
				return food.getServingSize();
			case 3:
				return food.cost;
			case 4:
				return food.getMin();
			case 5:
				return food.getMax();
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
		 */
		public boolean isCellEditable(int row, int col) {
			// Note that the data/cell address is constant,
			// no matter where the cell appears onscreen.
			if (col >= 4 || col == 0) {
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
			Food food = foodList.get(row);
			switch (col) {
			case 0:
				food.setSelected((Boolean) value);

				break;
			case 4:
				Integer min = (Integer) value;
				if (min > food.getMax())
					food.setMin(food.getMax());
				else
					food.setMin(min);
				break;
			case 5:
				Integer max = (Integer) value;
				if (max < food.getMin())
					food.setMax(food.getMin());
				else
					food.setMax(max);

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
		List<Food> foodList = dataUtils.readFood(nutList);

		// Create and set up the content pane.
		FoodSelectionPanel newContentPane = new FoodSelectionPanel(foodList,
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
