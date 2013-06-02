package org.neos.casestudies.diet;

import java.io.Serializable;
import java.util.HashMap;

import org.neos.gams.SolutionRow;

/**
 * Object for storing food constraints and its activity returned from running the model
 * @author Thawan Kooburat
 *
 */
public class Food implements Serializable {
	public static final int DEFAULT_MIN = 0;
	public static final int DEFAULT_MAX = 10;

	private String cost;
	private String shortName;
	private String longName;
	private String servingSize;

	private SolutionRow row;

	private Boolean selected = Boolean.FALSE;

	private HashMap<String, String> nutrientMap = new HashMap<String, String>();

	private Integer min = DEFAULT_MIN;
	private Integer max = DEFAULT_MAX;

	public void addNutrient(String nutrient, String value) {
		nutrientMap.put(nutrient, value);
	}

	public String getNutrientValue(String nutrient) {
		return nutrientMap.get(nutrient);
	}

	public String getCost() {
		return cost;
	}

	public void setCost(String cost) {
		this.cost = cost;
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

	public Integer getMin() {
		return min;
	}

	public void setMin(String min) {
		this.min = DietUtils.getPositiveInt(min);
	}

	public void setMin(Integer min) {
		this.min = min;
	}

	public Integer getMax() {
		return max;
	}

	public void setMax(String max) {
		this.max = DietUtils.getPositiveInt(max);
	}

	public void setMax(Integer max) {
		this.max = max;
	}

	public String getServingSize() {
		return servingSize;
	}

	public void setServingSize(String servingSize) {
		this.servingSize = servingSize;
	}

	public SolutionRow getSolutionRow() {
		return row;
	}

	public void setSolutionRow(SolutionRow row) {
		this.row = row;
	}

	public Boolean isSelected() {
		return selected;
	}

	public void setSelected(Boolean selected) {
		this.selected = selected;
	}

	public HashMap<String, String> getNutrientMap() {
		return nutrientMap;
	}
}