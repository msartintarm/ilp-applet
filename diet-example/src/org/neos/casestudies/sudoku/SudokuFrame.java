package org.neos.casestudies.sudoku;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.text.*;
import java.lang.*;
import java.util.*;
import java.util.regex.*;
import java.awt.Graphics;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.*;
import java.awt.GridLayout;
import javax.swing.BoxLayout;

import org.neos.client.Base64;

import java.awt.BorderLayout;
import java.net.*;
import java.io.*;


public class SudokuFrame extends JFrame {
  int size; // size of problem (3, 4, 5, etc.)
  Puzzle puzzle;
  public PuzzlePanel puzzlePanel;
  public int currentPuzzleID;
  JPanel buttonPanel;
  JComboBox selectComboBox;
  JButton submitButton;
  JButton revealButton;
  
  public JTextArea infoArea;
  JScrollPane infoScroll;
  
  public String PUZZLES[] ={ 
    "000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    "056800900200000370043009106400007030862000417030400002305700860024000001008001240",
    "005600000093470000700053000609010204082060510501030608000120009000098450000007300",
    "004000019060070300830001000702500030400020008050008204000100097007050080120000500",
    "020050089000600000005100240000005094502000608790800000079006800000001000380090010",
    "000007980002603000507010300005900006030080040600005800009060104000502700078300000",
    "600003000100200460042000007000070090038060570090040000300000140069008005000700006",
    "000934700000000400300000098802400007005010300100007206650000002008000000004158000",
    "000420000000005610046030700760000000002000800000000043007060980083500000000084000"};


  public  SudokuFrame() {
    super();
    createGUI();
    /*    try {
      SwingUtilities.invokeAndWait(new Runnable() {
	  public void run() {
	    createGUI();
	  }
	});
    } catch (Exception e) {
      System.err.println("createGUI didn't successfully complete");
      }*/
  }

  public void createGUI() {
    size = 3;
    try {
    submitButton = null;
    revealButton = null;
    puzzle = new Puzzle(size,PUZZLES[1]);
    puzzlePanel = new PuzzlePanel(this,puzzle);
    buttonPanel = new JPanel();
    buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.Y_AXIS));
    infoArea = new JTextArea("",25,20);
    infoScroll = new JScrollPane(infoArea);
    String[] puzzleStrings = { "Select Puzzle",
			       "0 (blank)","1 (easy)","2 (easy)",
			       "3 (moderate)","4 (moderate)","5 (moderate)",
			       "6 (hard)", "7 (hard)","8 (evil)"};
    selectComboBox = new JComboBox(puzzleStrings);
    currentPuzzleID = 1;
    //    selectComboBox.setSelectedIndex(0);
    selectComboBox.addActionListener(puzzlePanel);
    submitButton= new JButton("Submit to NEOS");
    submitButton.addActionListener(puzzlePanel);
    revealButton = new JButton("Reveal Solution");
    revealButton.addActionListener(puzzlePanel);
    revealButton.setEnabled(false);
    buttonPanel.add(selectComboBox);
    buttonPanel.add(submitButton);
    buttonPanel.add(revealButton);
    buttonPanel.add(infoScroll);
    
    add(puzzlePanel,BorderLayout.CENTER);
    add(buttonPanel,BorderLayout.LINE_END);
    } catch (Exception e) {
      e.printStackTrace();
      StackTraceElement stack[] = e.getStackTrace();
      for (int i=0;i<stack.length;i++) {
	infoArea.append(stack[i]+ "\n");
      }
    }
      
  }

}

interface Charmap {
  public Character getChar(int b);
}

class DefaultCharmap implements Charmap {
  Map m;
  public DefaultCharmap(int n) {
    int i;
    m = new Hashtable(10);
    m.put(new Integer(0),new Character(' '));
    for (i=1;i<=n*n;i++) {
      m.put(new Integer(i),new Character((char)(i+'0')));
    }
  }

  public Character getChar(int b) {
    Character c = (Character)(m.get(new Integer(b)));
    return c;
  }
}


class PuzzlePanel extends JPanel implements DocumentListener , ActionListener {
  public JTextField entries[][];
  Integer solution[][];
  SudokuFrame parent;
  JPanel boxes[][];
  Puzzle puzzle;
  Charmap charmap;
  SolutionFinder solutionFinder;
  int N;

  public PuzzlePanel(SudokuFrame parent,Puzzle puzzle) {
    int i,j;
    this.parent = parent;
    this.puzzle = puzzle;
    solutionFinder=null;
    N = puzzle.getSize();
    charmap = new DefaultCharmap(N);
    this.setLayout(new GridLayout(N,N));

    boxes = new JPanel[N][N];
    entries = new JTextField[N*N][N*N];

    for (i=0;i<N;i++)
      for (j=0;j<N;j++) {
	boxes[i][j] = new JPanel();
	boxes[i][j].setBorder(BorderFactory.createLineBorder(Color.black));
	boxes[i][j].setLayout(new GridLayout(N,N));
	add(boxes[i][j]);
      }
    Font font=null;
    for (i=0;i<N*N;i++)
      for (j=0;j<N*N;j++) {
	entries[i][j] = new JTextField(charmap.getChar(puzzle.getValue(i,j)).toString());
	if (font == null) {
	    font = entries[i][j].getFont();
	    font = font.deriveFont((float)font.getSize()+(float)8.0);
	}
	entries[i][j].setFont(font);
	if (puzzle.getValue(i,j)!=0)
	  entries[i][j].setEditable(false);
	entries[i][j].setHorizontalAlignment(JTextField.CENTER);
	Document d = entries[i][j].getDocument();
	d.addDocumentListener(this);
	d.putProperty("Box",new Integer(N*N*i+j));
	boxes[i/N][j/N].add(entries[i][j]);
      }
    if (parent.submitButton != null) 
      parent.submitButton.setEnabled(true);
    if (parent.selectComboBox != null)
      parent.selectComboBox.setEnabled(true);
  }

  public void reset(int index) {
    parent.infoArea.append("resetting puzzle.\n");
    solution = null;
    if (solutionFinder != null) {
	solutionFinder.stopMe=true;
	solutionFinder = null;
    }
    puzzle = new Puzzle(N,parent.PUZZLES[index]);

    parent.revealButton.setEnabled(false);
    for (int i=0;i<N*N;i++)
      for (int j=0;j<N*N;j++) {
	entries[i][j].setText(charmap.getChar(puzzle.getValue(i,j)).toString());
	entries[i][j].setEditable(puzzle.getValue(i,j)==0);
      }
  }

  public void setSolution(Integer table[][]) {
    solution = table;
  }
  public void updateSolution() {
    int i,j;
    for (i=0;i<N*N;i++) {
      for (j=0;j<N*N;j++) {
	entries[i][j].setText(solution[i][j].toString());
      }
    }
  }

   public void changedUpdate(DocumentEvent e) {
     Document d = e.getDocument();
     int boxNumber = ((Integer)d.getProperty("Box")).intValue();
     int i = boxNumber/(N*N);
     int j = boxNumber%(N*N);
     String t = entries[i][j].getText();
     if (t.trim().length() > 0) {
       Integer I = new Integer(t.trim());
       puzzle.setValue(i,j,I.intValue());
     }
   }
   public void removeUpdate(DocumentEvent e) {
     changedUpdate(e);
   }
   public void insertUpdate(DocumentEvent e) {
     changedUpdate(e);
   }
   public void actionPerformed(ActionEvent e) {
     if (e.getSource() instanceof JComboBox) {
       JComboBox b = (JComboBox)(e.getSource());
       int index = b.getSelectedIndex()-1; // ignore title entry
       if (index>=0 && index != parent.currentPuzzleID) {
	 reset(index);
	 parent.currentPuzzleID = index;
       }
       return;
		      
     }	      
     String command = e.getActionCommand();
     if (command.equals("Submit to NEOS")) {
       if (solutionFinder != null) {
         solutionFinder.stopMe = true;
	 solutionFinder = null;
       }
       solutionFinder = new SolutionFinder(parent,puzzle);
       solutionFinder.start();
     }
     else if (command.equals("Reveal Solution")) {
       updateSolution();
     }       
     else if (command.equals("Cancel Solve")) {
	 solutionFinder.stopMe = true;
	 solutionFinder.interrupt();
     }
   }
}
class SolutionFinder extends Thread {
   SudokuFrame parent;
   int size;
   Puzzle puzzle;
   Integer jobNumber;
   String password;
   public boolean stopMe;
   boolean bailing;

   public SolutionFinder(SudokuFrame parent, Puzzle puzzle) {
     this.parent = parent;
     size = puzzle.getSize();
     this.puzzle = puzzle;
     stopMe = false;
     bailing = false;
   }
  
   public boolean submitJob() {
     String post=new String(
	    "<?xml version='1.0'?>\n"+
	    "<methodCall>\n"+
	    "  <methodName>submitJob</methodName>"+
	    "  <params><param><value><string>\n"+
	    "&lt;sudoku&gt;\n"+
	    "&lt;category&gt;milp&lt;/category&gt;\n"+
	    "&lt;solver&gt;Cbc&lt;/solver&gt;\n"+
	    "&lt;inputMethod&gt;AMPL&lt;/inputMethod&gt;\n"+
            "&lt;priority&gt;short&lt;/priority&gt;\n"+
	    "&lt;model&gt;&lt;![CDATA[\n"+
	    "param m &gt;= 1, integer, default 3;\n"+
	    "param n := m*m;\n"+
	    "set N := 1..n;\n"+
	    "param P{N,N} default 0, integer, &gt;= 0, &lt;= n;\n"+
	    "var z{N,N,N} binary;\n"+
	    "# ... dummy objective\n"+
	    "minimize dummy: 0;\n"+
	    "subject to\n"+
	    "# ... every k present in col j\n"+
	    "col_sum{j in N, k in N}: sum{i in N} z[i,j,k] = 1;\n"+
	    "# ... every k present in row i\n"+
	    "row_sum{i in N, k in N}: sum{j in N} z[i,j,k] = 1;\n"+
	    "# ... every square has unique entry k\n"+
	    "unique{i in N, j in N}: sum{k in N} z[i,j,k] = 1;\n"+
	    "# ... every k present in each mxm square\n"+
	    "sqr_sum{r in 0..m-1, c in 0..m-1, k in N}:\n"+
	    "sum{p in 1..m, q in 1..m} z[m*r+p,m*c+q,k] = 1;\n"+
	    "# ... fixed input\n"+
	    "fixed{i in N, j in N: P[i,j] &lt;&gt; 0}:\n"+
	    "z[i,j,P[i,j]] = 1;\n"+
	    "]]&gt;&lt;/model&gt;\n"+
	    "&lt;data&gt;&lt;![CDATA[\n"+
	    "param m:="+size+";\n"+
	    "param	P: " + puzzle + ";\n"+
	    "]]&gt;&lt;/data&gt;\n"+
	    "&lt;commands&gt;&lt;![CDATA[\n"+
	    "solve;\n"+
	    "# ... display the results\n"+
	    "printf \"\\nAMPL's Solution to SUDOKU:\\n\";\n"+
	    "for {i in N}{\n"+
	    "for {j in N}{\n"+
	    "for {k in N}{\n"+
	    "if (z[i,j,k] >= 0.999) then printf \"%3i\", k;\n"+
	    "};\n"+
	    "if ((j mod m) == 0) then printf \"   \";\n"+
	    "};\n"+
	    "printf \"\\n\";\n"+
	    "if ((i mod m) == 0) then {\n"+
	    "  printf \"\\n\";\n"+
	    "};\n"+
	    "};\n"+
	    "]]&gt;&lt;/commands&gt;\n"+
	    "&lt;/sudoku&gt;\n"+
	    "    </string></value></param>\n"+
	    "  </params>\n"+
	    "</methodCall>\n");
     String response = sendPost(post);

     Pattern jobPattern = 
       Pattern.compile("<int>\\s*([0-9]+)\\s*</int>");
     Pattern passPattern = 
       Pattern.compile("<string>\\s*([a-zA-Z]+)\\s*</string>");
     Matcher jobMatcher =  jobPattern.matcher(response);
     Matcher passMatcher = passPattern.matcher(response);
     jobNumber=new Integer(0);
     password="none";
     if (jobMatcher.find()) {
       jobNumber = new Integer(jobMatcher.group(1));
     }
     if (passMatcher.find()) {
       password = passMatcher.group(1);
     }
     parent.infoArea.append("jobNumber="+jobNumber+", password="+password+"\n");

     return (jobNumber.intValue() > 0);
   }

   public String sendPost(String payload) {
     String response = new String();
     try {
       URL                 neosUrl;
       URLConnection       neos;
       DataOutputStream    printout;
       DataInputStream     input;
       // URL of CGI-Bin script.
       neosUrl = new URL ("http://www.neos-server.org:3332");
       // URL connection channel.
       neos = neosUrl.openConnection();
       // Let the run-time system (RTS) know that we want input.
       neos.setDoInput (true);
       // Let the RTS know that we want to do output.
       neos.setDoOutput (true);
       // No caching, we want the real thing.
       neos.setUseCaches (false);
       // Specify the content type.
       neos.setRequestProperty("Content-Type", "text/plain");

       // Send POST output.
       neos.setRequestProperty("Method","POST");
       printout = new DataOutputStream(neos.getOutputStream());
       printout.writeBytes(payload);
       printout.flush();
       printout.close();

       // Get response data.
       input = new DataInputStream (neos.getInputStream ());
       String str;
       while (null != ((str = input.readLine())))    {
	 response += str;
       }
       input.close ();

     } catch (IOException e) {
       return "";
       //      parent.infoArea.setText(e.getMessage());
     }
     return response;
   } 

   public String getResults() {
     String post=new String(
	"<?xml version='1.0'?>\n"+
	"<methodCall>\n"+
	"  <methodName>getJobStatus</methodName>"+
	"  <params>\n" +
	"    <param><value><int>"+jobNumber+"</int></value></param>\n"+
	"    <param><value><string>"+password+"</string></value></param>\n"+
	"  </params>\n"+
	"</methodCall>\n");
     String response = sendPost(post);
     Pattern statusPattern = 
       Pattern.compile("<string>\\s*([a-zA-Z]+)\\s*</string>");
     Matcher statusMatcher =  statusPattern.matcher(response);
     String status;
     if (statusMatcher.find()) {
       status = statusMatcher.group(1);
       if (status.equals("Done") ||
	   status.equals("Bad Password") ||
	   status.equals("Unknown Job"))  {
	 post = new String(
	  "<?xml version='1.0'?>\n"+
	  "<methodCall>\n"+
	  "  <methodName>getFinalResults</methodName>"+
	  "  <params>\n" +
	  "    <param><value><int>"+jobNumber+"</int></value></param>\n"+
	  "    <param><value><string>"+password+"</string></value></param>\n"+
	  "  </params>\n"+
	  "</methodCall>\n");
	 response = sendPost(post);

	 Pattern resultPattern = 
	   Pattern.compile("<base64>(.*)</base64>");
	 Matcher matcher =  resultPattern.matcher(response);
	 String result;
	 if (matcher.find()) {
	   byte[] dec = Base64.decode( matcher.group(1) );
	   return new String(dec);
	 } else {
	   return response;
	 }
       }
     }
     return null;

   }
   public void run() {
     String response=null;
     parent.submitButton.setText("Cancel Solve");
     parent.submitButton.setActionCommand("Cancel Solve");
     parent.selectComboBox.setEnabled(false);
     submitJob();
     parent.infoArea.append("Job sent to NEOS\n");
     if (jobNumber.intValue() > 0) {
       response = getResults();
       parent.infoArea.append("NEOS job number: " + jobNumber +"\n");
       parent.infoArea.append("Password: " + password + "\n");
       parent.infoArea.append("Waiting for Results...\n");
       while (response  == null) {
	 try {
	   Thread.sleep(5000);
	   response = getResults();
	   if (stopMe) {
	       bail();
	       return;
	   }
	 } catch (InterruptedException e) {
	   if (stopMe) {
	       bail();
	       return;
	   }
	     
	 }
       }

       boolean okay =parseSolution(response);
       if (okay) {
	 parent.infoArea.append("Results received! Click 'Reveal Solution'.\n");
       }  else {
	 parent.infoArea.append( response +"\nError parsing NEOS solution!\n" );
       }
     } else {
       parent.infoArea.append("Jobnumber <= 0!\n");
     }
     parent.submitButton.setText("Submit to NEOS");
     parent.submitButton.setActionCommand("Submit to NEOS");
     parent.submitButton.setEnabled(true);
     parent.selectComboBox.setEnabled(true);
     parent.revealButton.setEnabled(true);
   }
    public void bail() {
	if (bailing)
	    return;
	stopMe = true;
	bailing = true;
	parent.submitButton.setEnabled(false);
	parent.infoArea.append("Stopped.\n");
	parent.infoArea.append("Sending 'Cancel Job' to NEOS.\n");
        String post=new String(
	  "<?xml version='1.0'?>\n"+
	  "<methodCall>\n"+
	  "  <methodName>killJob</methodName>"+
	  "  <params>\n" +
	  "    <param><value><int>"+jobNumber+"</int></value></param>\n"+
	  "    <param><value><string>"+password+"</string></value></param>\n"+
	  "    <param><value><string>Used Cancel Button</string></value></param>\n"+
	  "  </params>\n"+
	  "</methodCall>\n");
	sendPost(post);
	
	parent.submitButton.setText("Submit to NEOS");
	parent.submitButton.setActionCommand("Submit to NEOS");
	parent.submitButton.setEnabled(true);
	parent.selectComboBox.setEnabled(true);
    }
   public boolean parseSolution(String response) {
    int checksum=0;
    int index = response.lastIndexOf(":");
    
    String solution = response.substring(index+2);
    String rows[] = solution.split("\n");
    String cols[];
    int rowIndex = 0, colIndex=0;
    int i,j;
    Integer table[][]= new Integer[size*size][size*size];
    String regex="";
    for (i=0;i<size*size;i++) 
      regex += "(\\d+)\\s*";
    Pattern pattern = Pattern.compile(regex);
    
    Matcher matcher = pattern.matcher(solution);
    i = 0;
    while (matcher.find()) {
      for (j=0;j<size*size;j++) {
	table[i][j] = new Integer(matcher.group(j+1));
	checksum += table[i][j].intValue();
      }
      i++;
      
    }
    parent.puzzlePanel.setSolution(table);
    return (checksum == ((size*size) * (size*size) * (size*size + 1))/2);

  }
 }

  


class Puzzle {
  int N;
  int[][] table;

  public Puzzle(int n, String s) {
    int i,j;
    N = n;
    table = new int[N*N][N*N];
    byte bytes[] = s.getBytes();
    for (i=0;i<N*N;i++)
      for (j=0;j<N*N;j++)
	table[i][j] = (int)(bytes[i*N*N+j]-(byte)'0');
  }

  public int getSize() {
    return N;
  }
  public void setValue(int i, int j, int val) {
    if (i<N*N && j<N*N && i>=0 && j>=0 && val < N*N)
      table[i][j] = val;
    
  }

  public void setValue(int i, int val) {
    if (i >=0 && i < N*N*N*N && val >=0 && val < N*N) 
      table[i/(N*N)][i%(N*N)] = val;
    else
      System.err.println("bad values: i=" + new Integer(i).toString() + "   " 
			 + " val=" + new Integer(val).toString());

  }
  public int getValue(int i, int j) {
    int k,l;
    if (i<N*N && j<N*N && i>=0 && j>=0)
      return table[i][j];
    else
      return 0;
  }

  public String toString() {
    int i,j;
    String s = new String("  ");
    for (j=0;j<N*N;j++) 
      s += (j+1) + " ";
    s += ":=\n";
    for (i=0;i<N*N;i++) {
      s += (i+1) + " ";
      for (j=0;j<N*N;j++) {
	if (table[i][j] == 0) 
	  s += ".";
	else
	  s += table[i][j];
	s += " ";
      }
      s += "\n";
    }
    return s;
  }
}
