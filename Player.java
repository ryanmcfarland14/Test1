package mainGame;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Rectangle;
import java.util.Random;
import javax.swing.JOptionPane;

import mainGame.Game.STATE;

/**
 * The main player in the game
 * 
 * @author Brandon Loehle 5/30/16
 *
 */

public class Player extends GameObject {

	Random r = new Random();
	Handler handler;
	private HUD hud;
	private int regenTick = 0;
	private Game game;
	private int health = 0;
	public int playerSpeed = 10;
	private boolean doubleHealth = false;
	private boolean regen = false;
	private int score = 0;
	private int abilityUses = 3;
	private int extraLives = 0;
	private Ability ability = Ability.None;
	private int damage;
	private int playerWidth, playerHeight;
	
	private final int reducedDamageValue = 1;
	private final double speedBoostMod = 2;
	
	private final int reducedPlayerSize = 24;
	
	
	private final int startingHealth = 100;
	private final int startingDamage = 2;
	private final int startingPlayerWidth = 32;
	private final int startingPlayerHeight = 32;
	private final int startingPlayerSpeed = 10;
	
	public enum Ability {
		None,
		FreezeTime,
		ClearScreen,
		LevelSkip
	}
	
	public Player(double x, double y, ID id, Handler handler, Game game) {
		super(x, y, id);
		this.handler = handler;
		this.hud = hud;
		this.game = game;
		this.damage = 2;
		playerWidth = 32;
		playerHeight = 32;
	}
	
	public void initialize() {
		switch (game.gameState) {
			case Game:
				hud = game.getHud();
				break;
			case Survival:
				hud = game.getSurvivalHud();
				break;
			default:
				break;
		}
		health = startingHealth;
		doubleHealth = false;
		regen = false;
		regenTick = 0;
		extraLives = 0;
		ability = Ability.None;
		abilityUses = 3;
		damage = startingDamage;
		playerWidth = startingPlayerWidth;
		playerHeight = startingPlayerHeight;
		playerSpeed = startingPlayerSpeed;
		hud.updateHealth(health);
		hud.updateLivesText(extraLives);
	}

	@Override
	public void tick() {
		this.x += velX;
		this.y += velY;
		x = Game.clamp(x, 0, Game.WIDTH - 38);
		y = Game.clamp(y, Game.scaleY(90), Game.HEIGHT - 60);

		// add the trail that follows it
		handler.addObject(new Trail(x, y, ID.Trail, Color.white, playerWidth, playerHeight, 0.05, this.handler));
		collision();
		checkIfDead();

		hud.tickScore();
		hud.updateHealth(health);
		hud.updateLivesText(extraLives);
		
		
		if(regen) {
			if(regenTick>=25) {
				regenTick = 0;
				if(health<=100) {
					health++;
				}
			} else {
				regenTick++;
			}
		}
	
	}

	public void checkIfDead() {
		if (health <= 0) {// player is dead, game over!

			if (extraLives == 0) {
				game.previousGameState = game.gameState;
				game.gameState = STATE.GameOver;
				Sound.stopSoundMenu();
				Sound.stopSoundWaves();
				Sound.playSoundOver();
			}

			else if (extraLives > 0) {// has an extra life, game continues
				extraLives--;
				health = startingHealth;
			}
		}
//		if(this.getHealth() == 90){
//			//Add health is low sound
//			Sound.playLowHealth();
//		}
	}

	/**
	 * Checks for collisions with all of the enemies, and handles it accordingly
	 */
	public void collision() {

		hud.updateScoreColor(Color.white);
		for (int i = 0; i < handler.object.size(); i++) {
			GameObject tempObject = handler.object.get(i);

			if (tempObject.getId() == ID.EnemyBasic 
					|| tempObject.getId() == ID.EnemyFast
					|| tempObject.getId() == ID.EnemySmart 
					|| tempObject.getId() == ID.EnemyBossBullet
					|| tempObject.getId() == ID.EnemySweep 
					|| tempObject.getId() == ID.EnemyShooterBullet
					|| tempObject.getId() == ID.EnemyBurst 
					|| tempObject.getId() == ID.EnemyShooter
					|| tempObject.getId() == ID.BossEye
					|| tempObject.getId() == ID.EnemyRaindrop
					|| tempObject.getId() == ID.EnemyShotgun
					|| tempObject.getId() == ID.EnemyShotgunBullet
					|| tempObject.getId() == ID.EnemySmarter
					|| tempObject.getId() == ID.EnemyBossGhost
					|| tempObject.getId() == ID.EnemyBossGhostTrail
					|| tempObject.getId() == ID.EnemyCircle) {// tempObject is an enemy

				// collision code
				if (getBounds().intersects(tempObject.getBounds())) {// player hit an enemy
					hud.updateScoreColor(Color.red);
							health -= damage;
							hud.updateScoreColor(Color.red);
				}
				hud.updateHealth(health);

			}
			if (tempObject.getId() == ID.EnemyBoss) {
				// Allows player time to get out of upper area where they will get hurt once the
				// boss starts moving
				if (this.y <= 138 && tempObject.isMoving) {
					health -= 2;
					hud.updateScoreColor(Color.red);
				}
			}

		}
	}

	@Override
	public void render(Graphics g) {

		g.setColor(Color.blue);
		g.fillRect((int) x, (int) y, (int) Game.scaleX(playerWidth), (int) Game.scaleY(playerHeight));

	}

	@Override
	public Rectangle getBounds() {
		return new Rectangle((int) this.x, (int) this.y, (int) Game.scaleX(playerWidth), (int) Game.scaleY(playerHeight));
	}
	
	public void activateDoubleHealth() {
		doubleHealth = true;
		health = 2 * startingHealth;
		hud.activateDoubleHealth();
	}
	
	public void activateRegen() {
		regen = true;
	}
	
	public void activateDamageResistance() {
		damage = reducedDamageValue;
	}
	
	public void activateTriggeredAbility(Ability ability, int uses) {
		this.ability = ability;
		abilityUses = uses;
		hud.updateAbilityText(ability, uses);
	}
	
	public void decrementAbilityUses() {
		abilityUses--;
		hud.updateAbilityText(ability, abilityUses);
		if (abilityUses < 1) {
			ability = Ability.None;
			hud.updateAbilityText(ability, abilityUses);
		}
	}
	
	public void activateSpeedBoost() {
		playerSpeed *= speedBoostMod;
	}
	
	public void activateReducedSize() {
		setPlayerSize(reducedPlayerSize);
	}

	public void setDamage(int damage) {
		this.damage = damage;
	}

	public void setPlayerSize(int size) {
		this.playerWidth = size;
		this.playerHeight = size;
	}
	
	public Ability getAbility() {
		return ability;
	}

	public void setAbility(Ability ability) {
		this.ability = ability;
	}

	public int getAbilityUses() {
		return abilityUses;
	}

	public void setAbilityUses(int abilityUses) {
		this.abilityUses = abilityUses;
	}

	public int getExtraLives() {
		return extraLives;
	}

	public void setExtraLives(int extraLives) {
		this.extraLives = extraLives;
	}

	public Game getGame() {
		return game;
	}	

	public void setHUD(HUD newHud) {
		hud = newHud;
	}

}