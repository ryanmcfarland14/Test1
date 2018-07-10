import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class UI extends JFrame implements WindowListener, ActionListener {
	Label title, a, b, c, d, e, info1,info2;
	Label[] list;
	Catalog gambitList;
	JPanel build, buttons, topBar;
	JButton button1, button2, button3, 
			button11, button12, button13,
			button21, button22, button23,
			button31, button32, button33,
			infoPopup;
	Gambit gambitPanel;
	

	public UI(Gambit _gambitPanel, Catalog _gambitList) {
		JPanel mainPanel = new JPanel();
		mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));
		JPanel infoPanel = new JPanel();
		infoPanel.setLayout(new GridLayout(3,1));
		
		
		//Components
		topBar = new JPanel();
			topBar.setLayout(new GridLayout(1,2));
			title = new Label("Enter a combination.");
			build = new JPanel();
				build.setLayout(new GridLayout(1,5));
				a = new Label("L");
				b = new Label("O");
				c = new Label("T");
				d = new Label("R");
				e = new Label("O");
				list = new Label[]{a,b,c,d,e};
		buttons = new JPanel();
			buttons.setLayout(new GridLayout(4,3));
			button1 = new JButton("1"); button2 = new JButton("2"); button3 = new JButton("3");
			button11 = new JButton("11"); button12 = new JButton("12"); button13 = new JButton("13"); 
			button21 = new JButton("21"); button22 = new JButton("22"); button23 = new JButton("23");
			button31 = new JButton("31"); button32 = new JButton("32"); button33 = new JButton("33");
		info1 = new Label("Hotkeys:");
		info2 = new Label("Builds = (Shift/Ctrl/Alt) + 1, 2, 3       E = Remove Last       F = Clear All");
		infoPopup = new JButton("Gambit List");
		
		//Positioning
		add(mainPanel);
		mainPanel.add(topBar);
		topBar.add(build);
		build.add(a);
		build.add(b);
		build.add(c);
		build.add(d);
		build.add(e);
		topBar.add(title);
		mainPanel.add(buttons);
		buttons.add(button1); buttons.add(button2); buttons.add(button3);
		buttons.add(button11); buttons.add(button12); buttons.add(button13);
		buttons.add(button21); buttons.add(button22); buttons.add(button23);
		buttons.add(button31); buttons.add(button32); buttons.add(button33);
		mainPanel.add(infoPanel);
		infoPanel.add(info1);
		infoPanel.add(info2);
		infoPanel.add(infoPopup);
		
		//Housekeeping
		buttons.setPreferredSize(new Dimension(500,200));
		gambitList = _gambitList;
		gambitPanel = _gambitPanel;
		setTitle("Gambit Trainer");
		setSize(400,400);
		setLocationRelativeTo(null);
		setVisible(true);
		title.setAlignment(WIDTH);
		for(int i = 0; i < list.length; i++) {
			list[i].setAlignment(WIDTH);
		}
		build.setSize(500,200);
		title.setSize(500,200);
		setResizable(false);
		
		
		//Colors
		Color red = new Color(250,100,100);
		Color green = new Color(100,200,100);
		Color yellow = new Color(230,230,100);
		Color white = new Color(250,250,250);
		Color gray = new Color(240,240,240);
		Color black = new Color(50,50,50);
		
		setBackground(black);
		title.setForeground(white);
		title.setBackground(black);
		for(int i = 0; i < list.length; i++) {
			list[i].setBackground(black);
			list[i].setForeground(white);
		}
		button1.setBackground(red);
		button2.setBackground(green);
		button3.setBackground(yellow);
		JButton[] buttonList = new JButton[] {button11,button12,button13,
											button21,button22,button23,
											button31,button32,button33};
		for(int i = 0; i < buttonList.length; i++) {
			buttonList[i].setBackground(gray);
		}
		infoPopup.setBackground(new Color(0,170,250));
		infoPopup.setForeground(white);
		info1.setBackground(black);
		info2.setBackground(black);
		info1.setForeground(red);
		info2.setForeground(white);
		buttons.setBackground(black);
		mainPanel.setBackground(black);


		
		
		
		//Listeners
		addWindowListener(this);
		
		//Button Bindings
		addButtonAction(button1, (evt) -> {buildCombinations(1);});
		addButtonAction(button2, (evt) -> {buildCombinations(2);});
		addButtonAction(button3, (evt) -> {buildCombinations(3);});
		addButtonAction(button11, (evt) -> {buildCombinations(1);buildCombinations(1);});
		addButtonAction(button12, (evt) -> {buildCombinations(1);buildCombinations(2);});
		addButtonAction(button13, (evt) -> {buildCombinations(1);buildCombinations(3);});
		addButtonAction(button21, (evt) -> {buildCombinations(2);buildCombinations(1);});
		addButtonAction(button22, (evt) -> {buildCombinations(2);buildCombinations(2);});
		addButtonAction(button23, (evt) -> {buildCombinations(2);buildCombinations(3);});
		addButtonAction(button31, (evt) -> {buildCombinations(3);buildCombinations(1);});
		addButtonAction(button32, (evt) -> {buildCombinations(3);buildCombinations(2);});
		addButtonAction(button33, (evt) -> {buildCombinations(3);buildCombinations(3);});
		addButtonAction(infoPopup, (evt) -> {popupWindow();});
		
		//Key bindings
		addKeyBinding(buttons, KeyEvent.VK_1, "insert1", (evt) -> {buildCombinations(1);});
		addKeyBinding(buttons, KeyEvent.VK_2, "insert2", (evt) -> {buildCombinations(2);});
		addKeyBinding(buttons, KeyEvent.VK_3, "insert3", (evt) -> {buildCombinations(3);});
		addKeyBinding(buttons, KeyEvent.VK_1, Event.SHIFT_MASK, "insert11", (evt) -> {buildCombinations(1);buildCombinations(1);});
		addKeyBinding(buttons, KeyEvent.VK_2, Event.SHIFT_MASK, "insert12", (evt) -> {buildCombinations(1);buildCombinations(2);});
		addKeyBinding(buttons, KeyEvent.VK_3, Event.SHIFT_MASK, "insert13", (evt) -> {buildCombinations(1);buildCombinations(3);});
		addKeyBinding(buttons, KeyEvent.VK_1, Event.CTRL_MASK, "insert21", (evt) -> {buildCombinations(2);buildCombinations(1);});
		addKeyBinding(buttons, KeyEvent.VK_2, Event.CTRL_MASK, "insert22", (evt) -> {buildCombinations(2);buildCombinations(2);});
		addKeyBinding(buttons, KeyEvent.VK_3, Event.CTRL_MASK, "insert23", (evt) -> {buildCombinations(2);buildCombinations(3);});
		addKeyBinding(buttons, KeyEvent.VK_1, Event.ALT_MASK, "insert31", (evt) -> {buildCombinations(3);buildCombinations(1);});
		addKeyBinding(buttons, KeyEvent.VK_2, Event.ALT_MASK, "insert32", (evt) -> {buildCombinations(3);buildCombinations(2);});
		addKeyBinding(buttons, KeyEvent.VK_3, Event.ALT_MASK, "insert33", (evt) -> {buildCombinations(3);buildCombinations(3);});
		
		addKeyBinding(buttons, KeyEvent.VK_E, "Remove Last", (evt) -> {gambitPanel.removeLast();updateUI();});
		addKeyBinding(buttons, KeyEvent.VK_F, "Cash Out", (evt) -> {gambitPanel.clearAll();updateUI();});
	}
	
    
	//Key binding function
	public static void addKeyBinding(JComponent comp, int keyCode, String id, ActionListener lambda) {
		InputMap im = comp.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW);		
		ActionMap ap = comp.getActionMap();
		
		im.put(KeyStroke.getKeyStroke(keyCode, 0, false), id);
		
		ap.put(id, new AbstractAction() {
			@Override
			public void actionPerformed(ActionEvent e) {
				lambda.actionPerformed(e);
			}
		});
	}
	
	public static void addKeyBinding(JComponent comp, int keyCode, int mask, String id, ActionListener lambda) {
		InputMap im = comp.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW);		
		ActionMap ap = comp.getActionMap();
		
		im.put(KeyStroke.getKeyStroke(keyCode, mask, false), id);
		
		ap.put(id, new AbstractAction() {
			@Override
			public void actionPerformed(ActionEvent e) {
				lambda.actionPerformed(e);
			}
		});
	}
	
	public static void addButtonAction(JButton button, ActionListener lambda) {
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				lambda.actionPerformed(e);
			}
		});
	}
	
    //Actions
    public void buildCombinations(int x) {
    	System.out.println(x);
    	gambitPanel.add(x);
    	updateUI();
    }
    
    public void popupWindow() {
    	PopUp newWindow = new PopUp(gambitList);
    	newWindow.buildList();
    }
    
    //String Breakers
	public String getCodeString(int[] _code) {
		String ret = "";
		for(int i = 0; i<5; i++) {
			if(_code[i] != 0) {
				ret = ret + _code[i];
			} else {
				i = 5;
			}
		}
		return ret;
	}
	public String noMoreUnderscore(String text) {
		String ret = text;
		if(text.indexOf("_") != -1) {
			String first = text.substring(0, text.indexOf("_"));
			String last = text.substring(text.indexOf("_")+1,text.length());
			ret = noMoreUnderscore(first+" "+last);
		}
		return ret;
	}
    
    //Update
    public void updateUI() {
    	int[] code = gambitPanel.getCode();
    	for(int i = 0; i<5; i++) {
    		if(code[i]==0) {
    			list[i].setText("");
    		} else {
    			list[i].setText(code[i]+"");
    		}
    	}
    	String nameSet = "N/A";
    	Gambit[] allGambits = gambitList.getList();
    	for(int i = 0; i < allGambits.length; i++) {
    		Gambit currentGambit = allGambits[i];
    		if(getCodeString(code).equals(currentGambit.getCodeString())) {
    			System.out.println("Match!");
    			nameSet = noMoreUnderscore(currentGambit.getName());
    		} else {
    			System.out.println("No Match");
    		}
    	}
    	title.setText(nameSet);
    }
	
    
	//Window Features
	@Override public void windowClosing(WindowEvent evt) {System.exit(0);}
	@Override public void windowIconified(WindowEvent evt) {}
	@Override public void windowDeactivated(WindowEvent evt) {}
	@Override public void windowDeiconified(WindowEvent evt) {}
	@Override public void windowActivated(WindowEvent evt) {}
	@Override public void windowClosed(WindowEvent arg0) {}
	@Override public void windowOpened(WindowEvent arg0) {}
	
}
