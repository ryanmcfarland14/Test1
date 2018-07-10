
public class Gambit {

	private int[] code;
	private String name;
	
	//Constructors
	public Gambit(String _name) {
		name = _name;
		code = new int[] {0,0,0,0,0};
	}
	
	public Gambit(String _name, int[] _code) {
		name = _name;
		code = _code;
	}
	
	
	//Getters
	public String getName() {
		return name;
	}
	
	public int[] getCode() {
		return code;
	}
	
	public int getCodeAt(int _position) {
		int pos = _position;
		if(pos<5 && pos>=0) {
			return code[pos];
		} else {
			System.out.println("ERROR: Selected point is out of bounds.");
			return -1;
		}
	}
	
	public int getNext() {
		int current = 0;
		for(int i = 0; i < 5; i++) {
			if(code[i] == 0) {
				current = i;
				i=5; //Bail
			}
		}
		return current; //Return will be 0 if it is full
	}
	
	public boolean isFull() {
		return getCodeAt(4) != 0;
	}
	
	public boolean isEmpty() {
		return code[0] == 0;
	}
	
	public String getCodeString() {
		String ret = "";
		for(int i = 0; i<5; i++) {
			if(code[i] != 0) {
				ret = ret + code[i];
			} else {
				i = 5;
			}
		}
		return ret;
	}
	
	
	//Setters
	public void setName(String _name) {
		name = _name;
	}
	
	public void setCode(int[] _code) {
		code = _code;
	}
	
	public void setCodeAt(int x, int _position) {
		int pos = _position;
		if(pos<5 && pos>=0) {
			code[pos] = x;
		} else {
			System.out.println("ERROR: Selected point is out of bounds.");
		}
	}

	public void removeLast() {
		if(!isEmpty()) {
			int next = getNext();
			if(next==0) {
				code[4] = 0;
			} else {
				code[getNext()-1] = 0;
			}
		} else {
			System.out.println("Gambit panel is empty");
		}
	}
	
	public void clearAll() {
		code = new int[] {0,0,0,0,0};
	}
	
	
	//Functions
	public void add(int x) {
		if(!isFull()) {
			code[getNext()] = x;
		} else {
			System.out.println("Gambit Panel is full.");
		}
	}
}
