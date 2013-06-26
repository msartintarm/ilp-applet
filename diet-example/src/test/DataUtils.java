package test;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.LinkedList;
import java.util.List;

import test.Food;
import test.Nutrient;

/**
 * Data utility class, use singleton pattern
 * See FileUtils for more detailed description
 * @author Thawan Kooburat
 * 
 */
public class DataUtils {

    /**
     * Input data for nutrients and food
     */
    public static final String NUTRIENTS = "resources/nutrients.conf";
    public static final String FOOD = "resources/food.conf";

    /**
     * Static part of the model
     */
    public static final String MODEL = "scheduler/simple-model.gms";
 
    /**
     * Example output for feasible / infeasible problem, for testing
     */
    public static final String FEASIBLE = "resources/feasible.txt";
    public static final String INFEASIBLE = "resources/infeasible.txt";

    public static final int APPLICATION_MODE = 0;
    public static final int APPLET_MODE = 1;

    private static DataUtils self = null;

    private int mode;

    private DataUtils() {}

    public static DataUtils getInstance(int mode) {
	if (self == null) {
	    self = new DataUtils();
	    self.mode = mode;
	}
	return self;
    }

    public List<Food> readFood(List<Nutrient> nutrients) {
	LinkedList<Food> foodList = new LinkedList<Food>();

	String line;
	BufferedReader in;
	try {
	    Reader reader;
	    if (mode == APPLET_MODE)
		reader = new InputStreamReader(DataUtils.class.getResourceAsStream("/" + FOOD));
	    else
		reader = new FileReader(FOOD);

	    in = new BufferedReader(reader);

	    while ((line = in.readLine()) != null) {

		line = line.trim();
		if (line.length() == 0)
		    continue;

		String[] cols = line.split(";");

		String vals = cols[2].trim();
		String[] values = vals.split("\\s+");

		Food food = new Food();

		food.setLongName(cols[0].trim());
		food.setServingSize(cols[1].trim());
		food.setShortName(values[0]);
		food.setCost(values[1]);

		int i = 2;
		for (Nutrient nut : nutrients) {
		    food.addNutrient(nut.getName(), values[i++]);
		}
		foodList.add(food);
	    }
	} catch (FileNotFoundException e) { e.printStackTrace();
	} catch (IOException e) { e.printStackTrace();
	}
	return foodList;
    }

    public List<Nutrient> readNutrient() {
	LinkedList<Nutrient> nutList = new LinkedList<Nutrient>();

	String line;
	BufferedReader in;
	try {
	    Reader reader;
	    if (mode == APPLET_MODE)
		reader = new InputStreamReader(DataUtils.class.getResourceAsStream("/" + NUTRIENTS));
	    else
		reader = new FileReader(NUTRIENTS);

	    in = new BufferedReader(reader);

	    while ((line = in.readLine()) != null) {

		line = line.trim();
		if (line.length() == 0)
		    continue;

		String[] cols = line.split("\\s+");

		Nutrient nut = new Nutrient();

		nut.setName(cols[0]);
		nut.setMin(cols[1]);
		nut.setMax(cols[2]);
		nut.setUnit(cols[3]);

		nutList.add(nut);
	    }

	} catch (FileNotFoundException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}

	return nutList;
    }

    public String readFile(String fileName) {

	StringBuffer content = new StringBuffer();
	String line;
	BufferedReader in;
	try {
	    Reader reader;
	    if (mode == APPLET_MODE)
		reader = new InputStreamReader(
		    DataUtils.class.getResourceAsStream("/" + fileName));
	    else
		reader = new FileReader(fileName);

	    in = new BufferedReader(reader);

	    while ((line = in.readLine()) != null)
		content.append(line + "\n");

	} catch (FileNotFoundException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}

	return content.toString();
    }

}
