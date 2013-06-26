package org.neos.gams;

import java.util.ArrayList;
import java.util.List;

public class SolutionData {
    /**
     * Equation type
     */
    public static final String EQU = "EQU";
	
    /**
     * Variable type
     */
    public static final String VAR = "VAR";

    String description;
    String name;
    int dimension;
    String type;

    List<SolutionRow> rows = new ArrayList<SolutionRow>();
	
    public boolean addRow(SolutionRow row) { return this.rows.add(row); }
    public void setDimension(int dimension) { this.dimension = dimension; }
    public void setType(String type) { this.type = type; }
    public void setDescription(String description) { this.description = description; }
    public void setName(String name) { this.name = name; }
	
    public List<SolutionRow> getRows() { return this.rows; }
    public String getDescription() { return description; }
    public String getName() { return name; }
    public int getDimension() { return dimension; }
    public String getType() { return type; }

}
