--[[ Gambit System
Description:
	The gambit system is a method of combat that utilizes combonations in a specific
	order to achieve special attacks. These special attacks are called "Gambits" and
	normal attacks that lead up to these are called "Gambit Builders." They operate
	like regular combos. For example Punch, Kick, Kick = DropKick or something. But
	once you do those three combinations, the DropKick gambit is then unlocked and
	must be "cashed out." This means that the player must assign a special key to
	"cash out" these gambits for more devastating attacks. Once cashed out, the
	gambit builders reset completely and you may begin building a new gambit. Here
	is an example of how the GUI would look:
	
	_ _ _ _ _ | _
	
	Each of the first five underscores are for the builders and the last underscore
	is for the gambit. Note that the final underscore will remain empty/default until
	a proper gambit has been built using gambit builders. Cashing out the gambit with-
	out having a proper gambit build will cause the player to miss or stumble. 
	
	FUTER ENHANCEMENTS
	Chaining Gambits:	We have the potential to add multipliers for chaining together
						similar gambits in succession which ultimately improves the
						overall damage output.
	Double Gambit Builders:	These are special skills that can either be passive or
						an actual attack. Either way, their purpose should not be to
						deal damage, but to instead build a gambit faster. This is
						for advanced players to chain together special attacks more
						quickly and frequently.
	Elemental Cores: 	We can have a spec on each rig that you can swap out to find
						your favorite. These specs will be elmental abilities that
						replace cetain attacks (including gambits).
						
Gambit Builder Types:
	1 - Punch
	2 - Kick
	3 - ??? (Maybe an elemental ability bound to the mech?)
	
Gambit List: (Note that these work in trees of chained attacks that are unlocked as the player levels, more will be added)
	Basic Attack Tree (Damage)
	12 - Jab
	121 - Uppercut
	1212 - Bash
	12121 - Blast (Knockback)
	
	Basic Kick Tree (Healing)
	21 - Sure Footing
	212 - Boot (Increase Defence)
	2121 - Roundhouse (Drain)
	21212 - Stomp (Heal)
	
	Basic Elemental Tree (Effect based on elemet)
	31 - Burst
	313 - Breach
	3131 - Conquer
	31313 - Fury
	
	
Elemental Core Types: (Rig benefit, elemental benefit)
	Fire  		None, Damage over Time
	Ice  		Slow Enemies, Debuff
	Wind  		Speed up attacks, Knockback
	Lightning 	Increased damage, Stuns
	Earth		Increased health, Stuns
	
]]