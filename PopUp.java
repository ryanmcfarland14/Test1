import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

public class PopUp extends Frame implements WindowListener {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6477304216321828492L;
	
	private Catalog catalog;
	Panel mainPanel;
	UI ui;
	
	Font f_head = new Font("Arial", Font.BOLD, 13);

	public PopUp(UI _ui, Catalog _catalog) {
		catalog = _catalog;
		ui = _ui;
		mainPanel = new Panel();
		mainPanel.setLayout(new GridLayout(catalog.getLength()+1,2));
		
		JPanel container = new JPanel();
		container.add(mainPanel);
		JScrollPane jsp = new JScrollPane(container);
		add(jsp);
		container.setSize(300,800);
		jsp.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		
		
		setTitle("Gambit List");
		setSize(320,600);
		setVisible(true);
		setLocationRelativeTo(null);
		setResizable(false);
		container.setBackground(new Color(255,255,255));
		
		addWindowListener(this);
	
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
	
	int num = 1;
	public void addNew(Gambit gambit) {
		Label newLabel = new Label(noMoreUnderscore(gambit.getName()));
		Label newCode = new Label(gambit.getCodeString());
		if(num%2==0) {
			newLabel.setBackground(new Color(240,240-num,240-num));
			newCode.setBackground(new Color(240,240-num,240-num));
		}
		newCode.setAlignment(MAXIMIZED_HORIZ);
		mainPanel.add(newLabel);
		mainPanel.add(newCode);
		num++;
	}
	
	public void buildList() {
		Label namesLabel = new Label("Gambit Name");
		Label seqLabel = new Label("Sequence");
		namesLabel.setFont(f_head);
		seqLabel.setFont(f_head);
		seqLabel.setAlignment(MAXIMIZED_HORIZ);
		namesLabel.setBackground(new Color(200,240,250));
		seqLabel.setBackground(new Color(200,240,250));
		mainPanel.add(namesLabel);
		mainPanel.add(seqLabel);
		for(int i = 0; i < catalog.getLength(); i++) {
			addNew(catalog.getList()[i]);
		}
	}
	
	//Window Features
		@Override public void windowClosing(WindowEvent evt) {ui.closePopup();this.dispose();}
		@Override public void windowIconified(WindowEvent evt) {}
		@Override public void windowDeactivated(WindowEvent evt) {}
		@Override public void windowDeiconified(WindowEvent evt) {}
		@Override public void windowActivated(WindowEvent evt) {}
		@Override public void windowClosed(WindowEvent arg0) {}
		@Override public void windowOpened(WindowEvent arg0) {}
}
