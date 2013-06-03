package test;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.FileUtils;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultReceiver;

/**
 * Main class for Diet GUI version
 * @author Thawan Kooburat
 *
 */
public class DietPanel extends JPanel implements ActionListener {

    private static final String SUBMIT_COMMAND = "submit";
    private static final String RESET_COMMAND = "clear";
    private static final String DEFAULT_COMMAND = "default";

    private static final String HOST = "www.neos-server.org";
    private static final String PORT = "3332";

    private JButton submitButton;
    private JButton clearButton;

    private FoodSelectionPanel foodSelectionPanel;
    private NutrientSelectionPanel nutrientSelectionPanel;

    private NeosXmlRpcClient client;
    private ResultReceiver receiver;

    private List<Food> foodList;
    private List<Nutrient> nutrientList;

    private List<Food> oriFoodList;
    private List<Nutrient> oriNutrientList;

    private String model;

    private DataUtils dataUtils;

    public DietPanel(int mode) {
	super();

	dataUtils = DataUtils.getInstance(mode);

	init();

    }

    public void init() {
	loadData();
	createGUI();

	client = new NeosXmlRpcClient(HOST, PORT);

	try {
	    client.connect();
	} catch (XmlRpcException e) {
	    System.out.println("Unable to connect to NEOS server :"
			       + e.getMessage());
	    JOptionPane.showMessageDialog(this,
					  "Unable to connect to the NEOS server", "Message",
					  JOptionPane.ERROR_MESSAGE);
	}
    }

    public void loadData() {
	oriNutrientList = dataUtils.readNutrient();
	oriFoodList = dataUtils.readFood(oriNutrientList);
	model = dataUtils.readFile(DataUtils.MODEL);

	// Need to clone data for each instance of the job
	foodList = (List<Food>) DietUtils.deepCopy(oriFoodList);
	nutrientList = (List<Nutrient>) DietUtils.deepCopy(oriNutrientList);
    }

    public void createGUI() {

	setLayout(new BorderLayout());

	JButton submitButton = new JButton("Submit");
	submitButton.setActionCommand(SUBMIT_COMMAND);
	submitButton.addActionListener(this);

	JButton clearButton = new JButton("Reset");
	clearButton.setActionCommand(RESET_COMMAND);
	clearButton.addActionListener(this);

	JButton defaultButton = new JButton("Default");
	defaultButton.setActionCommand(DEFAULT_COMMAND);
	defaultButton.addActionListener(this);

	// Lay everything out.

	JPanel buttonPanel = new JPanel(new GridLayout(1, 2));
	// buttonPanel.setPreferredSize(new Dimension(200, 30));
	buttonPanel.add(submitButton);
	buttonPanel.add(clearButton);
	buttonPanel.add(defaultButton);
	add(buttonPanel, BorderLayout.NORTH);

	// setSize(new Dimension(300, 200));

	foodSelectionPanel = new FoodSelectionPanel(foodList, nutrientList);
	nutrientSelectionPanel = new NutrientSelectionPanel(nutrientList);

	JLabel foodLabel = new JLabel("Please select food and adjust portion");
	JLabel nutrientLabel = new JLabel("Nutrient Constraints");

	JPanel foodPanel = new JPanel();
	foodPanel.setLayout(new BoxLayout(foodPanel, BoxLayout.Y_AXIS));
	foodPanel.add(foodLabel);
	foodPanel.add(foodSelectionPanel);
	add(foodPanel, BorderLayout.CENTER);

	JPanel nutPanel = new JPanel();
	nutPanel.setLayout(new BoxLayout(nutPanel, BoxLayout.Y_AXIS));
	nutPanel.add(nutrientLabel);
	nutPanel.add(nutrientSelectionPanel);
	nutrientSelectionPanel.setPreferredSize(new Dimension(500, 195));
	add(nutPanel, BorderLayout.SOUTH);

	setPreferredSize(new Dimension(800, 900));
    }

    public void actionPerformed(ActionEvent e) {
	String command = e.getActionCommand();

	if (command.equals(SUBMIT_COMMAND)) {
	    foodSelectionPanel.stopEditing();
	    nutrientSelectionPanel.stopEditing();
	    submitJob();

	} else if (command.equals(RESET_COMMAND)) {
	    clearSelection();

	} else if (command.equals(DEFAULT_COMMAND)) {
	    defaultSelection();

	}

    }

    void clearSelection() {
	foodList = (List<Food>) DietUtils.deepCopy(oriFoodList);
	nutrientList = (List<Nutrient>) DietUtils.deepCopy(oriNutrientList);

	foodSelectionPanel.updateData(foodList, nutrientList);
	nutrientSelectionPanel.updateData(nutrientList);
    }

    void defaultSelection() {
	foodList = (List<Food>) DietUtils.deepCopy(oriFoodList);
	nutrientList = (List<Nutrient>) DietUtils.deepCopy(oriNutrientList);

	// Select some food and will create feasible solution
	int count = 0;
	for (int i = 7; i < 25; i += 2) {
	    foodList.get(i).setSelected(true);
	}

	foodSelectionPanel.updateData(foodList, nutrientList);
	nutrientSelectionPanel.updateData(nutrientList);
    }

    void submitJob() {

	String combinedModel = DietUtils.generateData(foodList, nutrientList,
						      model);

	NeosJobXml dietJob = new NeosJobXml("nco", "MINOS", "GAMS");

	System.out.println(combinedModel);

	dietJob.addParam("model", combinedModel);

	Vector params = new Vector();
	// Job xml
	params.add(dietJob.toXMLString());
	
	Integer currentJob = 0;
	String currentPassword = "";

	ResultFrame jobPopup = new ResultFrame(foodList, nutrientList);

	try {
	    Object[] results = (Object[]) client.execute("submitJob", params);

	    currentJob = (Integer) results[0];
	    currentPassword = (String) results[1];
	} catch (XmlRpcException e) {
	    System.out.println("Error submitting job :" + e.getMessage());

	    JOptionPane.showMessageDialog(this,
					  "Unable to submit a job to the NEOS server", "Message",
					  JOptionPane.ERROR_MESSAGE);

	    return;
	}
	if (currentJob == 0) {
	    System.out.println(currentPassword);
	    return;
	}
	JobStat stat = new JobStat();
	stat.setJobNumber("" + currentJob);
	stat.setJobPassword(currentPassword);

	jobPopup.showJobInfo(stat);

	receiver = new ResultReceiver(client, jobPopup, currentJob,
				      currentPassword);
	receiver.start();

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

}
