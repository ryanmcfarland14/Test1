package mainGame;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.ArrayList;
/**
 * The main Heads Up Display of the game
 * 
 * @author Brandon Loehle 5/30/16
 *
 */

public class HUD {

	private double greenValue = 255;

	protected Font font;
	protected int score = 0;
	private int level = 1;
	
	protected Color scoreColor = Color.white;

	private int extraLives = 0;

	
	protected HUDRectangle HUDBackground;
	protected HUDRectangle healthBarBackground;
	protected HUDRectangle healthBar;
	protected HUDText scoreText;
	protected HUDText levelText;
	private HUDText livesText;
	private HUDText abilityText;
	protected ArrayList<HUDElement> HUDElementList;
	
	
	public HUD() {
		font = new Font("Amoebic", 1, 30);
		HUDBackground = new HUDRectangle(0, 0, 
				Color.GRAY, 
				1920, 90);
		healthBarBackground = new HUDRectangle(10, 10, 
				Color.BLACK, 
				410, 44);
		healthBar = new HUDRectangle(15, 15, 
				new Color(75, (int) greenValue, 0), 
				100, 32);
		scoreText = new HUDText(700, 64, scoreColor, font);
		levelText = new HUDText(1100, 64, scoreColor, font);
		livesText = new HUDText(1300, 64, scoreColor, font);
		abilityText = new HUDText(1500, 64, scoreColor, font);
		HUDElementList = new ArrayList<HUDElement>();
		HUDElementList.add(HUDBackground);
		HUDElementList.add(healthBarBackground);
		HUDElementList.add(healthBar);
		HUDElementList.add(scoreText);
		HUDElementList.add(levelText);
		HUDElementList.add(livesText);
		HUDElementList.add(abilityText);
	}
	
	public void tick() {
		this.greenValue = Game.clamp(greenValue, 0, 255);	
	}

	public void render(Graphics g) {
		for (HUDElement element : this.HUDElementList) {
			element.render(g);
		}
	}

	public void updateScoreColor(Color color) {
		this.scoreColor = color;
	}

	public void updateHealth(int health) {
		healthBar.setWidth(health * 4);
	}
	
	public void updateScoreText(int score) {
		scoreText.setText("Score: " + score);
	}
	
	public void updateLevelText(int level) {
		levelText.setText("Level: " + level);
	}
	
	public void updateLivesText(int lives) {
		livesText.setText("Lives: " + lives);
	}
	
	public void updateAbilityText(Player.Ability ability, int abilityUses) {
		String abilityName = "";
		switch (ability) {
			case FreezeTime:
				abilityName = "Time Freezes:";
				break;
			case ClearScreen:
				abilityName = "Screen Clears:";
				break;
			case LevelSkip:
				abilityName = "Level Skips:";
				break;
			default:
				System.out.println("NOTHING TO SHOW");
				break;
		}
		if (ability == Player.Ability.None) {
			abilityText.setText("");
		} else {
			abilityText.setText(abilityName + " " + abilityUses);
		}
	}
	
	public void tickScore() {
		score++;
		updateScoreText(score);
	}
	
	public void setScore(int score) {
		this.score = score;
	}

	public int getScore() {
		return score;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public void setExtraLives(int lives) {
		this.extraLives = lives;
	}

	public int getExtraLives() {
		return this.extraLives;
	}

	public void activateDoubleHealth() {
		healthBar.setHeight(64);
		healthBarBackground.setHeight(76);
	}

	public void resetHealth() {
		healthBar.setHeight(32);
		healthBarBackground.setHeight(44);
	}
	
	protected class HUDElement {
		protected int xPos;
		protected int yPos;
		protected Color color;
		
		public HUDElement(int xPos, int yPos, Color color) {
			this.xPos = (int) Game.scaleX(xPos);
			this.yPos = (int) Game.scaleY(yPos);
			this.color = color;
		}
		
		public void render(Graphics g) {}

		public int getxPos() {
			return xPos;
		}

		public void setxPos(int xPos) {
			this.xPos = (int) Game.scaleX(xPos);
		}

		public int getyPos() {
			return yPos;
		}

		public void setyPos(int yPos) {
			this.yPos = (int) Game.scaleY(yPos);
		}

		public Color getColor() {
			return color;
		}

		public void setColor(Color color) {
			this.color = color;
		}
		
		
	}
	
	protected class HUDRectangle extends HUDElement {
		private int width;
		private int height;
		
		public HUDRectangle(int xPos, int yPos, Color color, int width, int height) {
			super(xPos, yPos, color);
			this.width = (int) Game.scaleX(width);
			this.height = (int) Game.scaleY(height);
		}
		
		public void render(Graphics g) {
			g.setColor(color);
			g.fillRect(xPos, yPos, width, height);
		}

		public void setWidth(int width) {
			this.width = (int) Game.scaleX(width);
		}

		public void setHeight(int height) {
			this.height = (int) Game.scaleY(height);
		}
	}	
	
	protected class HUDText extends HUDElement {
		private int size;
		private Font font;
		private String text = "";
		
		public HUDText(int xPos, int yPos, Color color, Font font) {
			super(xPos, yPos, color);
			this.font = font;
			
		}
		
		public void render(Graphics g) {
			g.setColor(color);
			g.setFont(font);
			g.drawString(text, xPos, yPos);
		}
		
		public void setText(String text) {
			this.text = text;
		}
	}
}
