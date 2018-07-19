--[[
PullLever
	TriggerArea - CanCollide(false) (Fires when the lever trigger connects)
	LeverParts [Welded Parts]
		mainPart
			BodyMover (Acts as a spring)
		LeverTrigger
	Config
		isPulled
		isGripped
	GripArea (Welded to mainpart)
		[Sounds - Release]
	Indicator (NEON)
]]

DEBUG = true

--Components
bin = script.Parent
gripArea = bin.GripArea
	sound_release = gripArea.Release
parts = bin.LeverParts
	part_LeverTrigger = parts.LeverTrigger
config = bin.Config
	config_isGripped = config.isGripped
	config_isPulled = config.isPulled
indicator = bin.Indicator
triggerArea = bin.TriggerArea
	
--Getters
function isGripped()
	return config_isGripped.Value
end

function isPulled()
	return config_isPulled.Value
end

--Setters
function setGripped(value)
	config_isGripped.Value = value
end

function setPulled(value)
	config_isPulled.Value = value
end

--Sounds
function playTweaked(sound)
	sound.PlaybackSpeed = 1 + math.random()
	sound:Play()
end

--Functions
function pullLever()
	setPulled(true)
	Indicator.BrickColor = BrickColor.new("Really red")
	part_LeverTrigger.Anchored = true
	playTweaked(sound_release)
	config_isGripped:Destroy()
	--ACTIVATED
end

--Connections
triggerArea.Touched:connect(function(hit)
	if not isPulled() then
		if hit == part_LeverTrigger then
			pullLever()
		end
	end
end
