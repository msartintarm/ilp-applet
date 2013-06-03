package test;

import javax.swing.JApplet;
import javax.swing.SwingUtilities;

import test.DietPanel;
import org.neos.client.FileUtils;

/**
 * Applet version of the Diet demo
 * @author Thawan Kooburat
 *
 */
public class DietApplet extends JApplet {
	
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
			System.err.println("createGUI didn't complete successfully: "
					+ e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * Create the GUI. For thread safety, this method should be invoked from the
	 * event-dispatching thread.
	 */
	private void createGUI() {

		// Applet need to load data differently from normal application

		DietPanel dietPanel = new DietPanel(FileUtils.APPLET_MODE);
		dietPanel.setOpaque(true);
		setContentPane(dietPanel);

	}
}
