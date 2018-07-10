
public class Main {

	public static void main(String[] args) {
		Catalog gambitList = new Catalog("In The Fray");
		Gambit gambitPanel = new Gambit("MainPanel");
		gambitList.buildGambitsFromFile("GambitList");
		new UI(gambitPanel, gambitList);
	}
}
