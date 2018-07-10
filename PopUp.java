import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

public class PopUp extends Frame implements WindowListener {
	private Catalog catalog;
	

	public PopUp(Catalog _catalog) {
		catalog = _catalog;
		setLayout(new GridLayout(catalog.getLength()+1,2));
		
		setSize(300,800);
		setVisible(true);
		setLocationRelativeTo(null);
		setResizable(false);
		
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
		add(newLabel);
		add(newCode);
		num++;
	}
	
	public void buildList() {
		Label namesLabel = new Label("Gambit Name");
		Label seqLabel = new Label("Sequence");
		seqLabel.setAlignment(MAXIMIZED_HORIZ);
		namesLabel.setBackground(new Color(200,240,250));
		seqLabel.setBackground(new Color(200,240,250));
		add(namesLabel);
		add(seqLabel);
		for(int i = 0; i < catalog.getLength(); i++) {
			addNew(catalog.getList()[i]);
		}
	}
	
	//Window Features
		@Override public void windowClosing(WindowEvent evt) {this.dispose();}
		@Override public void windowIconified(WindowEvent evt) {}
		@Override public void windowDeactivated(WindowEvent evt) {}
		@Override public void windowDeiconified(WindowEvent evt) {}
		@Override public void windowActivated(WindowEvent evt) {}
		@Override public void windowClosed(WindowEvent arg0) {}
		@Override public void windowOpened(WindowEvent arg0) {}
}
