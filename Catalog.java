import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Catalog {

	private Gambit[] list;
	private String name;
	
	//Constructor
	public Catalog(String _name) {
		list = new Gambit[0];
		name = _name;
	}
	
	
	//Getters
	public Gambit[] getList() {
		return list;
	}
	
	public Gambit getGambit(int x) {
		if(x>=0 && x<list.length) {
			return list[x];
		} else {
			System.out.println("ERROR: Index [" + x + "] is out of bounds.");
			return null;
		}
	}
	
	public int getLength() {
		return list.length;
	}
	
	
	//Setters
	public void addGambit(Gambit gambit) {
		Gambit[] newList = new Gambit[list.length+1];
		for(int i = 0; i < list.length; i++) {
			newList[i] = list[i];
		}
		newList[list.length] = gambit;
		list = newList;
	}
	
	
	//Functions
	public void printList() {
		System.out.println("Gambit List");
		for(int i = 0; i<list.length; i++) {
			System.out.println(list[i].getName()+"\t\t"+list[i].getCodeString());
		}
	}
	
	
	public void buildGambitsFromFile(String _filename) {
		File file = new File(_filename +".txt");
		
		try {
			
			Scanner in = new Scanner(file);
			while(in.hasNextLine()) {
				String _name = in.next(); //Resolve _ into spaces
				String _code = in.next();
				int[] uploadCode = new int[_code.length()];
				for(int i = 0; i<_code.length(); i++) {
					uploadCode[i] = Integer.parseInt(_code.substring(i, i+1));
				}
				Gambit newGambit = new Gambit(_name);
				for(int i = 0; i<uploadCode.length; i++) {
					newGambit.add(uploadCode[i]);
				}
				addGambit(newGambit);
			}
			in.close();
		} catch(FileNotFoundException e) {
			System.out.println("ERROR: no file (" + file + ") found!");
		}
	}
}
