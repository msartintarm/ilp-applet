package org.neos.tutorial;

import java.io.Serializable;
import java.util.ArrayList;


/**
 * Data entity class. 
 * Need to implement serializable, so that we can use deepCopy()
 * @author Thawan Kooburat
 *
 */
public class SimpleFood implements Serializable{
	private Boolean selected;
	private String shortName;
	private String longName;

	private double buy;

	public Boolean getSelected() {
		return selected;
	}

	public void setSelected(Boolean selected) {
		this.selected = selected;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public String getLongName() {
		return longName;
	}

	public void setLongName(String longName) {
		this.longName = longName;
	}

	public double getBuy() {
		return buy;
	}

	public void setBuy(double buy) {
		this.buy = buy;
	}

	public static ArrayList<SimpleFood> parseMapping(String mapping) {
		ArrayList<SimpleFood> foodList = new ArrayList<SimpleFood>();
		String[] lines = mapping.split("\n");

		for (String line : lines) {

			String[] tokens = line.split(":");
			if (tokens.length == 2) {
				SimpleFood food = new SimpleFood();
				food.setLongName(tokens[1]);
				food.setShortName(tokens[0]);
				food.setSelected(false);

				foodList.add(food);

			}

		}
		return foodList;
	}

}
