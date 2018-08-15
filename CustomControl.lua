local player = game.Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:wait()
end

--Custom Character Values
local humanoid = character.Humanoid
	local inCombat = humanoid.Combat
	local hovering = humanoid.Hovering
	
--Variables
local delay_Hover = 3
local val_HoverSpeed = 40
local delay_Dash = 1

--Debounces
local deb_Hover = false
local deb_Dash = false

local 
local mouse = player:GetMouse()
local repStorage = game:GetService("ReplicatedStorage")
local playerFile = repStorage:WaitForChild("PlayerData").PlayerList:WaitForChild(player.Name)
local keybindList = playerFile.Keybinds


--Build KeyList
local keys = {} --{{String,String},{},...}
for i, v in pairs(keybindList:GetChildren()) do
	local newPair = {}
	table.insert(newPair,v.Name)
	table.insert(newPair,v.Value)
	table.insert(keys,newPair)
end


--Actions (not all have to be in here, might be easier for some
function hover()
	if not deb_Hover then
		deb_Hover = true
		if hovering.Value then
			--fall
		else
			--Rise
		end
		wait(delay_Hover)
		deb_Hover = false
	end
end

function dash(directional)
	if not deb_Dash then
		deb_Dash = true
		
		wait(delay_Dash)
		deb_Dash = false
	end
end

--Funcitons
function getValue(key)
	local value = nil
	for i = 1, #keys do
		local set = keys[i]
		if set[2] == key then
			value = set[1]
		end
	end
	return key --returns nil if nothing is found
end


--Keypress Events
local uis = game:GetService("UserInputService")
local shift = false

--KeyDown Events
uis.InputBegan:connect(function(Key, Processed)
	if not Processed then
	
		local event = getValue(Key)
		
		--Special Events
		if Key.KeyCode == Enum.KeyCode.LeftShift then
			shift = true
		end
		
		--Regular Keybinds
		if event == "Hover" then
			else
		end
		
		--Conditional Events
		if shift then
			if Key == "w" then
				dash("w")
			end
			if Key == "a" then
				dash("a")
			end
			if Key == "d" then
				dash("d")
			end
			if Key == "s" then
				dash("s")
			end
		
		
	end
end)

--KeyUp Events
uis.InputEnded:connect(function(Key, Processed)
	if not Processed then
	
		local event = getValue(Key)
		
		--Special Events
		if Key.KeyCode == Enum.KeyCode.LeftShift then
			shift = false
		end
		
	end
	
end)