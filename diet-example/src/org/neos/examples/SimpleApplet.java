package org.neos.examples;

import javax.swing.JApplet;
import javax.swing.SwingUtilities;

/**
 * Applet version of the simple job submission applet
 * @author Thawan Kooburat
 *
 */
public class SimpleApplet extends JApplet {
	// Called when this applet is loaded into the browser.
	public void init() {
		// Execute a job on the event-dispatching thread; creating this applet's
		// GUI.
		try {
			SwingUtilities.invokeAndWait(new Runnable() {
				public void run() {
					createGUI();
				}
			});
		} catch (Exception e) {
			System.err.println("createGUI didn't complete successfully: "+e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * Create the GUI. For thread safety, this method should be invoked from the
	 * event-dispatching thread.
	 */
	private void createGUI() {
		// Create and set up the content pane.
		SimplePanel simplePanel = new SimplePanel();
		simplePanel.setOpaque(true);
		setContentPane(simplePanel);

	}
}
