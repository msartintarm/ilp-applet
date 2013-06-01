package org.neos.examples;

import java.awt.Container;
import java.awt.Dimension;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JApplet;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * Retrieve static map image from Google and display it on applet.
 * 
 * See Static map developer guide for more detail
 * http://code.google.com/apis/maps/documentation/staticmaps
 * 
 * Use this utility to test geocode or latitude/longitude
 * http://gmaps-samples.googlecode.com/svn/trunk/geocoder/singlegeocode.html
 * 
 * @author Thawan Kooburat
 * 
 */

public class GoogleMapApplet extends JApplet {
	
	public class Param {
		String key;
		String value;

		Param(String key, String value) {
			this.key = key;
			this.value = value;

		}
	}

	public void init() {
		// Try to construct this url
		// http://maps.google.com/maps/api/staticmap?&path=color:0x0000ff|weight:5|43.071396,-89.407082|41.873651,-87.632446&markers=color:blue|43.071396,-89.407082|41.873651,-87.632446&size=400x400&maptype=roadmap&sensor=false

		String baseUrl = "http://maps.google.com/maps/api/staticmap?";

		/*
		 * Constructing parameter list
		 */
		ArrayList<Param> paramsList = new ArrayList<Param>();
		// Using roadmap
		paramsList.add(new Param("maptype", "roadmap"));
		// our application do not sensor device
		paramsList.add(new Param("sensor", "false"));
		paramsList.add(new Param("size", "800x800"));
		paramsList.add(new Param("markers",
				"color:blue|43.071396,-89.407082|41.873651,-87.632446"));
		paramsList
				.add(new Param("path",
						"color:blue|weight:5|43.071396,-89.407082|41.873651,-87.632446"));

		// Use string buffer to construct string for better performance
		String url = baseUrl;
		for (Param param : paramsList) {
			url += "&" + param.key + "=" + param.value;
		}

		BufferedImage mapImage = null;
		try {
			URLConnection con = new URL(url).openConnection();
			InputStream is = con.getInputStream();
			mapImage = ImageIO.read(is);
			is.close();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("Unable to retrive map");
		}

		JLabel map = new JLabel(new ImageIcon(mapImage));

		JPanel mapPanel = new JPanel();
		mapPanel.setPreferredSize(new Dimension(900, 600));
		mapPanel.add(map);

		Container content = getContentPane();
		content.add(mapPanel);

	}
}
