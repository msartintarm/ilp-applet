package org.neos.examples;

import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;

import javax.swing.JApplet;
import javax.swing.JPanel;


/**
 * Show example usage of Java 2D
 * 
 * See the following tutorial for more detail
 * 
 * Learning Java2D
 * http://java.sun.com/developer/technicalArticles/GUI/java2d/java2dpart1.html
 * http://java.sun.com/developer/technicalArticles/GUI/java2d/java2dpart2.html
 * 
 * @author Thawan Kooburat
 *
 */
public class Java2DApplet extends JApplet {

	class DisplayPanel extends JPanel {

		protected void paintComponent(Graphics g) {
			super.paintComponents(g);

			// Cast to 2D so we get more capability
			Graphics2D g2 = (Graphics2D) g;

			int w = getWidth();
			int h = getHeight();

			Point p1 = new Point(w / 2, h / 2);
			Point p2 = new Point(w * 2 / 3, h / 2);

			// Paint the top left and bottom right in red.
			g2.setColor(Color.BLACK);
			g2.fillRect(p1.x, p1.y, 5, 5);
			g2.fillRect(p2.x, p2.y, 5, 5);

			// Paint the bottom left and top right in white.
			g2.setColor(Color.RED);
			g2.drawOval(w / 4, h / 4, w / 2, h / 2);

		}
	}

	public void init() {

		DisplayPanel dPanel = new DisplayPanel();
		dPanel.setPreferredSize(new Dimension(400, 400));

		Container content = getContentPane();
		content.add(dPanel);

	}
}
