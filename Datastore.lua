--[[
ServerScriptService
	[SCRIPT]
ReplicatedStorage
	PlayerData
		Default
			[Items] 
		PlayerList
			[PlayerName]
				[Stats...]
				Name -String
				Code -String
				XP -Number
				Cores -Int
				Location -String
			
				
]]

--Services
local DSservice = game:GetService("DataStoreService")
local DS = DSservice:GetDataStore("FRX_playerData")
local DS_codes = DSservice:GetDataStore("FRX_takenCodes")
local repStorage = game:GetService("ReplicatedStorage")
local playerFile = repStorage:WaitForChild("PlayerData")
local playerList = repStorage:WaitForChild("PlayerList")



--Functions
function getOrderedList(file)
	local newList = {}
	for i, v in pairs(file:GetChildren()) do
		table.insert(newList, v)
	end
	return table.sort(newList, function(a, b) return a.Name:upper() < b.Name:upper() end)
end

function loadFile(player, data)
	local playerFolder = playerList:FindFirstChild(player.UserId)
	if playerFolder then
		playerFolder:Destroy()
	end
	local newFile = playerFile.Default:Clone()
	newFile.Parent = playerList
	newFile.Name = player.UserId
	local newFileArray = getOrderedList(newFile)
	newFile:ClearAllChildren()
	for i = 1, #newFileArray do
		newFileArray[i].Value = data[i]
		newFileArray[i]:Clone().Parent = newFile
	end
end

function saveableList(player)
	return getOrderedList(playerList:findFirstChild(player.UserId).Value)
end

function codeTaken(code)
	local ret = false
	local data
	
	local DataFetchSuccess, ErrorMessage = pcall(function()
		data = DS_codes:GetAsync("CODELIST")
	end)
	
	if DataFetchSuccess then	
		for i = 1, #data do
			if data[i] == code then
				ret = true
			end
		end
	else
		ret = true
	end	
	
	return ret
end

function addCode(code)
	local current = DS_codes:GetAsync("CODELIST")
	DS_codes:SetAsync("CODELIST"", current, code)
end

--Connections
game.Players.PlayerAdded:connect(function(player)
	
	local PlayerData;
	
	local canSave = Instance.new("BoolValue")
	canSave.Parent = player
	
	canSave.Name = "CanSaveData"
	canSave.Value = true
	
	local DataFetchSuccess, ErrorMessage = pcall(function()
		PlayerData = DS:GetAsync(tostring(player.UserId))
	end)
	
	if DataFetchSuccess then	
		loadFile(PlayerData) --nil is okay
	else	
		player.CanSaveData.Value = false
		player:Kick("Your data failed to load. Please rejoin")	
	end

end)


game.Players.PlayerRemoving:connect(function(player)

	if player.CanSaveData.Value == false then return end
	
	local DataWriteSuccess,ErrorMessage = pcall(function()
		DS:SetAsync(tostring(player.UserId),saveableList(player))
	end)
	
	if not DataWriteSuccess then
	
		local Retry_Count = 0
		
		while Retry_Count<6 do
			wait(30)
			local Succeeded, Error = pcall(function()
				saveAllData(player)
				DS:SetAsync(tostring(player.UserId),saveableList(player))
			end)
			if Succeeded then break end
			Retry_Count = Retry_Count + 1
		end
		
	end

end)