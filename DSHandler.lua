--Syntax
prefix_data = "data_"
prefix_player = "player_"

--Keys
key_playerData = "FRX_datastore&TEST2"
key_codesData = "FRX_codestore&TEST2"

--Service
local DataStoreService = game:GetService("DataStoreService")
local DS_main = DataStoreService:GetDataStore(key_playerData)
local serStorage = game:GetService("ReplicatedStorage")
local playerFile = serStorage:WaitForChild("PlayerData")
local playerList = playerFile:WaitForChild("PlayerList")
local codeList = serStorage:WaitForChild("CodeList")
local defaultFile = playerFile.Default:Clone()
local remote = serStorage:WaitForChild("Events"):WaitForChild("UpdateValue")


--Connections
game.Players.PlayerAdded:connect(function(player)
	
	print(player.Name.." data loading...")

	local canSave = Instance.new("BoolValue")
	canSave.Parent = player
	
	canSave.Name = "CanSaveData"
	canSave.Value = true
	
	local tStats = defaultFile:Clone()
	
	local pData
	
	--Test for the default data load
	local DataFetchSuccess, ErrorMessage = pcall(function()
		pData = DS_main:GetAsync(player.UserId)
	end)
		
	if DataFetchSuccess then	
		for i, v in next, pData do
			if tStats:FindFirstChild(i) then
				tStats[i].Value = v
			end
		end
	else	
		player.CanSaveData.Value = false
		player:Kick("Your data failed to load. Please rejoin")	
	end

	tStats.Name = player.UserId
	tStats.Parent = playerList
	
end)


game.Players.PlayerRemoving:Connect(function(plr)
	local pStats = playerList:FindFirstChild(plr.UserId)
	local newData = {}
	for index, value in next, pStats:GetChildren() do
		newData[value.Name] = value.Value
	end
	local success, message = pcall(DS_main:SetAsync(plr.UserId, newData))
	if not success then
		for i = 1,6 do
			wait(5)
			pcall(DS_main:SetAsync(plr.UserId, newData))
		end
	end
end)

remote.OnServerEvent:Connect(function(player,valueName,value)
	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	
	local ref = playerFolder:findFirstChild(valueName)
	
	if ref then
		ref.Value = value
	end
	
end)

game.Workspace.Part.ClickDetector.MouseClick:connect(function(player)
	
	print(player.Name.." data saving...")

	if player.CanSaveData.Value == false then return end
	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	
	local pStats = playerList:FindFirstChild(player.UserId)
	local newData = {}
	for i, v in pairs(playerFolder:GetChildren()) do
		newData[v.Name] = v.Value
	end

	local DataWriteSuccess,ErrorMessage = pcall(function()
		DS_main:SetAsync(prefix_player..player.UserId, newData)
	end)
	
	if not DataWriteSuccess then
	
		local Retry_Count = 0
		
		while Retry_Count<6 do
			wait(30)
			local Succeeded, Error = pcall(function()
				DS_main:SetAsync(prefix_player..player.UserId, newData)
				print("Saving")
			end)
			if Succeeded then break end
			print("RETRY")
			Retry_Count = Retry_Count + 1
		end
		
	end

end)


