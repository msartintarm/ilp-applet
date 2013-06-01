package org.neos.casestudies.sudoku;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class SudokuStarter extends JApplet implements ActionListener
{
    int size;
    SudokuFrame sudoku;

    JButton start = new JButton("New Problem");
    JButton end   = new JButton("Quit");
    JButton about = new JButton("About");

    JPanel buttonPane = new JPanel(new FlowLayout()); 

    public void init()
    {
	super.init();
	buttonPane.setBackground(Color.white);
              
	start.setBackground(Color.lightGray);
	end.setBackground(Color.lightGray);
	//about.setBackground(Color.lightGray);

	start.addActionListener(this);
	end.addActionListener(this);
	//about.addActionListener(this);
      
	buttonPane.add(start, BorderLayout.WEST);
	buttonPane.add(end, BorderLayout.CENTER);
	//buttonPane.add(about, BorderLayout.EAST);

	this.getContentPane().add(buttonPane);

	//aboutWindow = new About(this);
    } /* end init procedure */
  
    public void actionPerformed(ActionEvent e)
    {

	if (e.getSource() == start) {
	    if (sudoku != null) 
		sudoku.dispose();
	    sudoku = new SudokuFrame();
	    sudoku.setSize(new Dimension(800,500));
	    sudoku.show();
	}
	
	if (e.getSource() == end) {
	    if (sudoku != null)
		sudoku.dispose();
	}


    } /* end action procedure */
}    
