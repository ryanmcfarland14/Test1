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
	Elemental Combos:	This could be a useful feature for squad gameplay. For example,
						if one rig uses ice on an emeny, a teammate using lightning
						could detonate their effect on the enemy for extra damage!
						This will be done using a prime and detonate system. Any
						detonator can detonate any primer. In general, the primers do
						more damage over time or lasting effects while the detonators
						do more immediate damage. Squads should be aware of this and
						incorporate it into their teamwork. It might not always be the
						best to detonate a primed target right away if the target is
						having their damage output reduced for example.
						
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
	Type		Cast		AOE Ultimate	Rig Benefit		Roll		Difficulty(1-5)
	Fire		DoT			Cashout DoT		Resistance		Primer		5
	Ice			Slow		Damage			Defence			Primer		3
	Lightning	Damage		Stun			Damage			Detonater	1
	Wind		Speed		Knockback		Movement		Detonater	2
	
	Earth		Defence		Heal			Defence			Healer		4
	Steel		Bleed		Drain			Movement		Solo		4
	Toxic		Poison		Damage			Health			Primer		2
	Nuclear		Radiate		Detonate		Movement		Solo		3
	Shade		Movement	Damage			Movement		Solo		4
	

Elemental Combos: (Negates effects on the enemy to deal additional damage. The primer and detonator system is universal)
	Primers		Detonaters		Neither (Solo-based)
	Fire		Lightning
	Ice			Wind
]]
--[[
GUI Structure
PlayerGui
	ScreenGui
		Frame
			GambitFrame
				[SCRIPT]
				1
				2
				3
				4
				5
				Gambit

Gambit File Structure:
ReplicatedStorage...
	GambitList
		TreeName = "type" 			(Named by the name of the tree
			GambitName = "sequence" (Named by the name of the skill)
				Values.. 			(Various aspects of the gambit that the script will read. Many are on an if-applicable basis)
				Damage [Number]
				Duration [Int] 		(Deals the damage value once every seccond for this long)
				Slow [Int]			(Slows the enemy for duration)
				Speed [Int}
				
Enemy Structure:
Model
	Config
		Stats
			MaxHealth
			Health
			MaxFuel
			Fuel
			Element
			AttackDelay
			BaseDamage
		Ratings
			Defence
			Resistance
			Crit
		Modifiers
			Damage
			Defence
			AttackSpeed
			MovementSpeed
			Resistance
			Crit
		State
			Primed [Boolean]
			Combat [Boolean]
		Prime
			(Insert effects here one at a time, these can be detonated)
		Debuff
			(Insert debuffs here with their own countdown before the debuff is lifted)
		Gambit
			1 [String]
			2
			3
			4
			5
		
		

]]

--Components
local player = game.Players.LocalPlayer
local repStorage = game:GetService("ReplicatedStorage")
local gambitList = repStorage.Assets.GambitList --Or whatever
local frame = script.Parent
local rig = nil --FIND A WAY TO GET THIS
local gambitReady = false

local build = "" 							--Current Gambit


--Functions: Gambit Builder
function addOn(x) --x must be 1,2, or 3
	if string.len(build) < 5 then
		build = build..x
	end
end

function removeLast()
	build = string.sub(build, 1, -2)
end

function removeAll()
	build = ""
end

function checkGambit()
	local gambit = nil
	for i, v in pairs(gambitList:GetChildren()) do
		if v.Value == build then
		gambit = v
	end
	return gambit --returns nil when no gambit is found
end

--Functions: GUI
function updateGUI()
	local length = string.len(build)
	for i = 1, 5 do
		local label = frame:FindFirstChild(i)
		if i <= length then
			label.Text = string.sub(build,i,i)
		else
			label.Text = ""
		end
	end
end

--Functions: Rig
function updateRig()
	local length = string.len(build)
	for i = 1, 5 do
		local label = rig.Config.Gambit:FindFirstChild(i)
		if i <= length then
			label.Value = string.sub(build,i,i)
		else
			label.Value = "0"
		end
	end
end

--Functions: Input
function onInput(x)
	addOn(x)
	local gambit = checkGambit()
	if gambit then
		gambitReady = true
		--Show the gambit
	else
		gambitReady = false
	end
end

