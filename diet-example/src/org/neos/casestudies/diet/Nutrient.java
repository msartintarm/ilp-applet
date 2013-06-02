package org.neos.casestudies.diet;

import java.io.Serializable;

/**
 * Object for storing nutrient constraints and its activity returned from running the model
 * @author Thawan Kooburat
 *
 */
public class Nutrient implements Serializable {

    private String name;
    private Integer min, max;
    private String unit;

    private Boolean selected = Boolean.TRUE;

    private Double dualCostTable[];

    public Nutrient() {}

    public String getName() {
	return name;
    }

    public void setName(String name) {
	this.name = name;
    }

    public Integer getMin() {
	return min;
    }

    public void setMin(Integer min) {
	this.min = min;
    }

    public void setMin(String min) {
	this.min = DietUtils.getPositiveInt(min);
    }

    public Integer getMax() {
	return max;
    }

    public void setMax(Integer max) {
	this.max = max;
    }

    public void setMax(String max) {
	this.max = DietUtils.getPositiveInt(max);
    }

    public String getUnit() {
	return unit;
    }

    public void setUnit(String unit) {
	this.unit = unit;
    }

    public Double[] getDualCostTable() {
	return dualCostTable;
    }

    public void setDualCostTable(Double[] dualCostTable) {
	this.dualCostTable = dualCostTable;
    }

    public Boolean isSelected() {
	return selected;
    }

    public void setSelected(Boolean selected) {
	this.selected = selected;
    }
}
