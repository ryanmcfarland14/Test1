package mainGame;

import mainGame.Player.Ability;

/**
 * The upgrades that a user can have (they modify the game for the user)
 * 
 * @author Brandon Loehle 5/30/16
 *
 */

public class Upgrades {

	private Game game;
	private Handler handler;
	private HUD hud;
	private Player player;
	private Spawn1to10 spawner;
	private Spawn10to20 spawner2;
	private UpgradeScreen upgradeScreen;
	private String ability;
	private final int freezeTimeUses = 3;
	private final int clearScreenUses = 3;	
	private final int levelSkipUses = 3;

	public Upgrades(Game game, Handler handler, HUD hud, UpgradeScreen upgradeScreen, Player player, Spawn1to10 spawner,
			Spawn10to20 spawner2) {
		this.game = game;
		this.handler = handler;
		this.hud = hud;
		this.upgradeScreen = upgradeScreen;
		this.player = player;
		this.spawner = spawner;
		this.spawner2 = spawner2;
		this.ability = "";
	}

	public void clearScreenAbility() {
		handler.clearEnemies();
		player.decrementAbilityUses();
		if (player.getAbilityUses() == 0) {
			ability = "";
		}
	}

	public void decreasePlayerSize() {
		player.setPlayerSize(24);
	}

	public void extraLife() {
		hud.setExtraLives(hud.getExtraLives() + 1);
	}

	public void improvedDamageResistance() {
		player.setDamage(1);
	}

	public void levelSkipAbility() {
		handler.clearEnemies();
		hud.setLevel(hud.getLevel() + 1);
		if (Spawn1to10.LEVEL_SET == 1) {
			spawner.skipLevel();
		} else if (Spawn1to10.LEVEL_SET == 2) {
			spawner2.skipLevel();
		}
		player.decrementAbilityUses();
		if (player.getAbilityUses() == 0) {
			ability = "";
		}
	}

	public void freezeTimeAbility() {
		handler.pause();
		player.decrementAbilityUses();
		if (player.getAbilityUses() == 0) {
			ability = "";
		}
	}

	public void speedBoost() {
		player.decrementAbilityUses();
	}

	public String getAbility() {
		return ability;
	}

	/**
	 * Activate the correct upgrade
	 * 
	 * @param path
	 *            is to the image of the upgrade that was pressed by the user
	 */
	public void activateUpgrade(String path) {
		System.out.println("UPGRADES CASE MATCH");
		switch (path) {
			case "images/clearscreenability.png":
				player.activateTriggeredAbility(Ability.ClearScreen, clearScreenUses);
				break;
			case "images/decreaseplayersize.png":
				player.activateReducedSize();
				break;
			case "images/extralife.png":
				player.setExtraLives(player.getExtraLives() + 1);
				break;
			case "images/healthincrease.png":
				player.activateDoubleHealth();
				break;
			case "images/healthregeneration.png":
				player.activateRegen();
				break;
			case "images/improveddamageresistance.png":
				player.activateDamageResistance();
				break;
			case "images/levelskipability.png":
				player.activateTriggeredAbility(Ability.LevelSkip, levelSkipUses);
				break;
			case "images/freezetimeability.png":
				player.activateTriggeredAbility(Ability.FreezeTime, freezeTimeUses);
				break;
			case "images/speedboost.png":
				player.activateSpeedBoost();
				break;
			default:
				System.out.println("NOTHING SELECTED: " + path);
				break;
		}

	}

	public void resetUpgrades() {
		hud.resetHealth();
		hud.setExtraLives(0);
		player.setPlayerSize(32);
		upgradeScreen.resetPaths();
	}

}
