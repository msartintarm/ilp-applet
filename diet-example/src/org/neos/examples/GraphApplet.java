package org.neos.examples;

import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GridBagLayout;
import java.awt.Rectangle;
import java.awt.Shape;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
 
import javax.swing.JApplet;
import javax.swing.JFrame;
 
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.CombinedDomainXYPlot;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.xy.DefaultXYDataset;
 
/**
 * Adapted from http://supertomate.wikispaces.com/JFreeChart+And+Applet  
 */
public class GraphApplet extends JApplet {
 
    private Double xLowerBound = null;
    private Double xUpperBound = null;
 
    private double redSeries[][];// = new double[1000][1000];
 
    private double blueSeries[][];// = new double[1000][1000];
 
 
    public void init() {
       
        redSeries = new double[2][5];
        blueSeries = new double[2][5];
 
        //Set the x coordinate of the 5 red points.
        redSeries[0][0] = 1;
        redSeries[0][1] = 2;
        redSeries[0][2] = 3;
        redSeries[0][3] = 4;
        redSeries[0][4] = 5;
 
        //Set the y coordinate of the 5 red points.
        redSeries[1][0] = 2;
        redSeries[1][1] = 2;
        redSeries[1][2] = 3;
        redSeries[1][3] = 3;
        redSeries[1][4] = 4;
 
        //Set the x coordinate of the 5 blue points.
        blueSeries[0][0] = 2;
        blueSeries[0][1] = 3;
        blueSeries[0][2] = 4;
        blueSeries[0][3] = 5;
        blueSeries[0][4] = 6;
 
        //Set the y coordinate of the 5 blue points.
        blueSeries[1][0] = 3;
        blueSeries[1][1] = 3;
        blueSeries[1][2] = 4;
        blueSeries[1][3] = 4;
        blueSeries[1][4] = 5;
 
        xLowerBound = Double.parseDouble("0");
        xUpperBound = Double.parseDouble("6");
 
        // Get the graph (generateGraph will create the JFreeChart graph and add the red and blue point on it).
        JFreeChart jFreeChart = generateGraph();
 
        //Put the jFreeChart in a chartPanel
        ChartPanel chartPanel = new ChartPanel(jFreeChart);
        chartPanel.setPreferredSize(new Dimension(900,600));
 
        chartPanel.setPopupMenu(null);
        //add the chartPanel to the container (getContentPane is inherited from JApplet which AppletGraph extends).
        Container content = getContentPane();
        content.add(chartPanel);
 
    }
 
 
 
    public JFreeChart generateGraph(){
 
        DefaultXYDataset defaultXYDataset = new DefaultXYDataset();
 
 
 
        String redSeriesLabel = "red";
        if(redSeries != null){
            defaultXYDataset.addSeries(redSeriesLabel, redSeries);
        }else{
            //TODO
            //throw new SolexaGraphException("pointSeries was null : you should frist call the plotGraphDrawer.setSegmentSeriesFromFile(String fileAbsolutePath()");
        }
 
        String blueSeriesLabel = "blue";
 
        if(blueSeries != null){
            defaultXYDataset.addSeries(blueSeriesLabel, blueSeries);
        }else{
            //TODO
            //throw new SolexaGraphException("pointSeries was null : you should frist call the plotGraphDrawer.setPointSeriesFromFile(String fileAbsolutePath()");
        }
 
        ValueAxis abscisse = new NumberAxis("Length(in cm)");
        ValueAxis ordonate = new NumberAxis("Height(in cm");
        CombinedDomainXYPlot combinedDomainXYPlot = new CombinedDomainXYPlot(abscisse);
 
        XYLineAndShapeRenderer xyLineAndShapeRenderer = new XYLineAndShapeRenderer();
 
        xyLineAndShapeRenderer.setSeriesPaint(0, Color.RED);
        xyLineAndShapeRenderer.setSeriesPaint(1, Color.BLUE);
 
        Dimension dimension = new Dimension(1,1);
        Shape shape = new Rectangle(dimension);
        xyLineAndShapeRenderer.setSeriesShape(0, shape);
        xyLineAndShapeRenderer.setSeriesShape(1, shape);
 
 
        xyLineAndShapeRenderer.setSeriesLinesVisible(0, false);
        xyLineAndShapeRenderer.setSeriesLinesVisible(1, false);
        xyLineAndShapeRenderer.setSeriesShapesVisible(0, true);
        xyLineAndShapeRenderer.setSeriesShapesVisible(1, true);
 
        xyLineAndShapeRenderer.setPlot(combinedDomainXYPlot);
 
        XYPlot xyPlot = new XYPlot(defaultXYDataset,abscisse,ordonate,xyLineAndShapeRenderer);
 
        xyPlot.setDataset(defaultXYDataset);
 
        if(xLowerBound != null && xUpperBound != null){
            xyPlot.getDomainAxis().setLowerBound(xLowerBound);
            xyPlot.getDomainAxis().setUpperBound(xUpperBound);
        }
        combinedDomainXYPlot.add(xyPlot);
 
 
        JFreeChart jFreeChart = new JFreeChart(combinedDomainXYPlot);
 
        return jFreeChart;
    }
 
 
}
