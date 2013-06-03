package test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import org.neos.client.FileUtils;
import org.neos.gams.Parameter;
import org.neos.gams.Set;
import org.neos.gams.SolutionData;
import org.neos.gams.SolutionParser;
import org.neos.gams.SolutionRow;

public class DietUtils {

    public static boolean parseResult(String results, List<Food> foodList,
				      List<Nutrient> nutList, JobStat stat) {
	System.out.println("***********");
	System.out.println(results);
	System.out.println("***********");

	SolutionParser parser = new SolutionParser(results);

	if (parser.getModelStatusCode() == SolutionParser.INFEASIBLE) {
	    // infeasible
	    stat.setFeasible(false);
	    return false;
	}

	stat.setTotalCost(String.format("%f", parser.getObjective()));

	// clear all selection from GUI
	for (Food food : foodList)
	    food.setSelected(false);

	// process food dual cost table
	SolutionData buy = parser.getSymbol("x", SolutionData.VAR, 1);

	for (SolutionRow row : buy.getRows()) {
	    for (Food food : foodList) {
		if (food.getShortName().equals(row.getIndex(0))) {

		    food.setSolutionRow(row);

		    food.setSelected(true);
		    break;
		}
	    }
	}

	// process food dual cost table
	SolutionData nut_lo = parser.getSymbol("nut_lo", SolutionData.EQU, 1);
	SolutionData nut_hi = parser.getSymbol("nut_hi", SolutionData.EQU, 1);

	for (int i = 0; i < nut_lo.getRows().size(); i++) {
	    //Both table should have the same ordering
	    SolutionRow loRow = nut_lo.getRows().get(i);
	    SolutionRow hiRow = nut_hi.getRows().get(i);

	    //Try to find matching nutrient and update its data
	    for (Nutrient nut : nutList) {
		if (nut.getName().equals(loRow.getIndex(0))) {
					
		    //Combine 2 tables into one table for display
		    Double[] dualCostTable = new Double[5];
		    // lower dual
		    dualCostTable[0] = loRow.getMarginal();
		    // lower
		    dualCostTable[1] = loRow.getLower();
		    // level
		    dualCostTable[2] = loRow.getLevel();
		    // upper
		    dualCostTable[3] = hiRow.getUpper();
		    // Maginal
		    dualCostTable[4] = hiRow.getMarginal();

		    nut.setDualCostTable(dualCostTable);

		    break;
		}
	    }
	}

	stat.setFeasible(true);
	return true;
    }

    public static int getPositiveInt(String value) {
	int result = 0;
	try {
	    result = Integer.parseInt(value);
	} catch (NumberFormatException e) {
	    result = 0;
	}

	if (result < 0)
	    result = 0;
	return result;
    }

    /**
     * Create GAMS model 
     * @param foods
     * @param nutrients
     * @param model
     * @return
     */
    public static String generateData(List<Food> foods,
				      List<Nutrient> nutrients, String model) {
	StringBuffer data = new StringBuffer();

	// Food set and params
	Set foodDomain = new Set("f", "food");
	Set foodSelect = new Set("fs(f)", "food selected");

	Parameter f_min = new Parameter("f_min(fs)", "");
	Parameter f_max = new Parameter("f_max(fs)", "");
	Parameter price = new Parameter("price(fs)", "");

	for (Food food : foods) {
	    foodDomain.addValue(food.getShortName());
	    if (food.isSelected()) {
		foodSelect.addValue(food.getShortName());
		f_min.add(food.shortName, food.min.toString());
		f_max.add(food.shortName, food.max.toString());
		price.add(food.shortName, food.cost.toString());
	    }
	}

	// Nutrient set and params
	Set nutDomain = new Set("n", "nutrient");
	Set nutSelect = new Set("ns(n)", "nutrient selected");

	Parameter n_min = new Parameter("n_min(ns)", "");
	Parameter n_max = new Parameter("n_max(ns)", "");

	for (Nutrient nut : nutrients) {
	    nutDomain.addValue(nut.getName());
	    if (nut.isSelected()) {
		nutSelect.addValue(nut.getName());
		n_min.add(nut.getName(), nut.getMin().toString());
		n_max.add(nut.getName(), nut.getMax().toString());
	    }
	}

	// Create data portion of model
	data.append(foodDomain.toString());
	data.append(foodSelect.toString());

	data.append(nutDomain.toString());
	data.append(nutSelect.toString());

	data.append(f_min.toString());
	data.append(f_max.toString());
	data.append(n_min.toString());
	data.append(n_max.toString());
	data.append(price.toString());

	data.append(model);

	return data.toString();
    }

    /**
     * Use to clone object and its children. Useful for cloning a collection.
     * Standard Java clone only do shallow copy, so object in a collection is
     * not cloned.
     * 
     * @param oldObj
     * @return
     */
    static public Object deepCopy(Object oldObj) {
	ObjectOutputStream oos = null;
	ObjectInputStream ois = null;
	Object result = null;
	try {
	    ByteArrayOutputStream bos = new ByteArrayOutputStream(); // A
	    oos = new ObjectOutputStream(bos); // B
	    // serialize and pass the object
	    oos.writeObject(oldObj); // C
	    oos.flush(); // D
	    ByteArrayInputStream bin = new ByteArrayInputStream(
								bos.toByteArray()); // E
	    ois = new ObjectInputStream(bin); // F
	    // return the new object
	    result = ois.readObject(); // G

	    oos.close();
	    ois.close();
	} catch (Exception e) {
	    e.printStackTrace();

	}
	return result;
    }

    public static void main(String[] args) {
	DataUtils dataUtils = DataUtils.getInstance(FileUtils.APPLICATION_MODE);

	String results = dataUtils.readFile(DataUtils.INFEASIBLE);
	List<Nutrient> nutList = dataUtils.readNutrient();
	List<Food> foodList = dataUtils.readFood(nutList);

	System.out.println(parseResult(results, foodList, nutList,
				       new JobStat()));

    }
}
