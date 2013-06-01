package org.neos.examples;

/*
 * This code is based on an example provided by Richard Stanford, 
 * a tutorial reader.
 */

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import org.apache.xmlrpc.XmlRpcException;
import org.neos.client.NeosJobXml;
import org.neos.client.NeosXmlRpcClient;
import org.neos.client.ResultCallback;
import org.neos.client.ResultReceiver;

/**
 * Simple Java Swing application for submiting jobs to NEOS
 * @author Thawan Kooburat
 *
 */
public class SimplePanel extends JPanel implements ActionListener,
						   ResultCallback {

    private static final String SUBMIT_COMMAND = "submit";
    private static final String CLEAR_COMMAND = "clear";

    private static final String HOST = "neos1.chtc.wisc.edu";
    private static final String PORT = "3332";

    private JTextArea outputTextArea;
    private JButton submitButton;
    private JButton clearButton;
    private NeosXmlRpcClient client;
    private ResultReceiver reciever;

    public SimplePanel() {
	super(new BorderLayout());

	JButton submitButton = new JButton("Submit");
	submitButton.setActionCommand(SUBMIT_COMMAND);
	submitButton.addActionListener(this);

	JButton clearButton = new JButton("Clear");
	clearButton.setActionCommand(CLEAR_COMMAND);
	clearButton.addActionListener(this);

	outputTextArea = new JTextArea(20, 20);
	outputTextArea.setEditable(false);
	outputTextArea.setText("initz");
	// Lay everything out.

	JPanel buttonPanel = new JPanel(new GridLayout(1, 2));
	// buttonPanel.setPreferredSize(new Dimension(200, 30));
	buttonPanel.add(submitButton);
	buttonPanel.add(clearButton);
	add(buttonPanel, BorderLayout.NORTH);

	JPanel outputPanel = new JPanel(new FlowLayout());
	// outputPanel.setPreferredSize(new Dimension(200, 120));
	outputPanel.add(outputTextArea);
	add(outputPanel, BorderLayout.CENTER);

	setSize(new Dimension(300, 200));

	client = new NeosXmlRpcClient(HOST, PORT);

	try {
	    client.connect();
	} catch (XmlRpcException e) {
	    outputTextArea.setText("Unable to connect to NEOS server :"
				   + e.getMessage());
	}
    }

    public void actionPerformed(ActionEvent e) {
	String command = e.getActionCommand();

	if (command.equals(SUBMIT_COMMAND)) {
	    submitJob();

	} else if (command.equals(CLEAR_COMMAND)) {
	    outputTextArea.setText("");
	    System.out.println("clear");
	}
    }

    public void submitJob() {
	NeosJobXml job = new NeosJobXml("test", "HelloNEOS", "default");
	job.addParam("num1", "55");
	job.addParam("num2", "100");
	job.addParam("operation", "Multiplication");

	Vector params = new Vector();
	// Job xml
	params.add(job.toXMLString());
		
	Integer currentJob = 0;
	String currentPassword = "";

	try {
	    Object[] results = (Object[]) client.execute("submitJob", params);

	    currentJob = (Integer) results[0];
	    currentPassword = (String) results[1];
	} catch (XmlRpcException e) {
	    outputTextArea.setText("Error submitting job :" + e.getMessage());
	    return;
	}
	if (currentJob == 0) {
	    System.out.println(currentPassword);
	    return;
	}
	reciever = new ResultReceiver(client, this, currentJob, currentPassword);
	reciever.start();

    }

    @Override
    public void handleJobInfo(int jobNo, String pass) {
	// TODO Auto-generated method stub
		
    }
	
    @Override
    public void handleFinalResult(String results) {
	outputTextArea.setText(results);

    }

	

	
}
