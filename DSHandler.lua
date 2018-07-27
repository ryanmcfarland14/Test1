--[[

ReplicatedStorage
	PlayerData
		Default
		PlayerList
			Stats
			Character
			Inventory
	Events
		DataInput
			UpdateStats
			UpdateCharacter
			UpdateInventory
			AddCode
]]
		


--Syntax
prefix_player = "player_TEST_"

--Keys
key_statsData = "FRX_stats&TEST"
key_characterData = "FRX_stats&TEST"
key_inventoryData = "FRX_stats&TEST"
key_codesData = "FRX_codestore&TEST"

--Service
local DataStoreService = game:GetService("DataStoreService")
local repStorage = game:GetService("ReplicatedStorage")
local playerFile = repStorage:WaitForChild("PlayerData")
local playerList = playerFile:WaitForChild("PlayerList")
local codeList = repStorage:WaitForChild("CodeList")
local defaultFile = playerFile.Default:Clone()


--Datastores
local DS_stats = DataStoreService:GetDataStore(key_statsData)
local DS_character = DataStoreService:GetDataStore(key_characterData)
local DS_inventory = DataStoreService:GetDataStore(key_inventoryData)
local DS_codes = DataStoreService:GetOrderedDataStore(key_codesData)


--Remotes
local eventFolder = repStorage:WaitForChild("Events")
local eventUpdates = eventFolder.DataInput
local remote_stats = eventUpdates:WaitForChild("UpdateStats")
local remote_character = eventUpdates:WaitForChild("UpdateCharacter")
local remote_inventory = eventUpdates:WaitForChild("UpdateInventory")
local remote_addCode = eventUpdates:WaitForChild("AddCode")



--Functions
function addCode(player, code)
	DS_codes:SetAsync(prefix_player..player.UserId, code)
end

function buildCodeList() --OrderedDataStore
	local pages = DS_codes:GetSortedAsync(false, 10)
	local currentPageNumber = 0
	
	while true do
		print("Page: "..currentPageNumber)
		local data = pages:GetCurrentPage()
		
		for _, pair in ipairs(data) do
			print(pair.key..":"..pair.value..)
			
			local newVal = Instance.new("StringValue")
			newVal.Parent = codeList
			newVal.Name = pair.key
			newVal.Value = pair.value
		end
		
		if pages.IsFinished then
			break
		end
		
		pages:AdvanceToNextPageAsync()
		currentPageNumber = currentPageNumber + 1
		
	end
end


--Connections
--LOAD
game.Players.PlayerAdded:connect(function(player)
	
	print(player.Name.." data loading...")

	local canSave = Instance.new("BoolValue")
	canSave.Parent = player
	
	canSave.Name = "CanSaveData"
	canSave.Value = true
	
	local playerFolder = defaultFile:Clone()
	
	local data_stats, data_character, data_inventory
	
	--Test for the default data load
	local DataFetchSuccess, ErrorMessage = pcall(function()
		data_stats = DS_stats:GetAsync(prefix_player..player.UserId)
		data_character = DS_character:GetAsync(prefix_player..player.UserId)
		data_inventory = DS_inventory:GetAsync(prefix_player..player.UserId)
	end)
		
	if DataFetchSuccess then
		for i, v in next, data_stats do
			if playerFolder.Stats:FindFirstChild(i) then
				playerFolder.Stats[i].Value = v
			end
		end
		for i, v in next, data_character do
			if playerFolder.Character:FindFirstChild(i) then
				playerFolder.Character[i].Value = v
			end
		end
		for i, v in next, data_stats do
			if playerFolder.Inventory:FindFirstChild(i) then
				playerFolder.Inventory[i].Value = v
			end
		end
	else	
		player.CanSaveData.Value = false
		player:Kick("Your data failed to load. Please rejoin")	
	end

	playerFolder.Name = player.UserId
	playerFolder.Parent = playerList
	
	print(player.Name.."'s data loaded!")
	
end)

--SAVE
game.Players.PlayerRemoving:Connect(function(plr)

	print(player.Name.." data saving...")

	local playerFolder = playerList:FindFirstChild(plr.UserId)
	local new_stats = {}
	local new_character = {}
	local new_inventory = {}
	for index, value in next, playerFolder.Stats:GetChildren() do
		new_stats[value.Name] = value.Value
	end
	for index, value in next, playerFolder.Character:GetChildren() do
		new_character[value.Name] = value.Value
	end
	for index, value in next, playerFolder.Inventory:GetChildren() do
		new_inventory[value.Name] = value.Value
	end
	local success, message = pcall(	DS_stats:SetAsync(prefix_player..plr.UserId, new_stats);
									DS_character:SetAsync(prefix_player..plr.UserId, new_character);
									DS_inventory:SetAsync(prefix_player..plr.UserId, new_inventory))
	if not success then
		for i = 1,6 do
			wait(5)
			pcall(	DS_stats:SetAsync(prefix_player..plr.UserId, new_stats);
					DS_character:SetAsync(prefix_player..plr.UserId, new_character);
					DS_inventory:SetAsync(prefix_player..plr.UserId, new_inventory))
		end
	end
	
	print(player.Name.."'s data saved!")
end)

--UPDATES
remote_stats.OnServerEvent:Connect(function(player,valueName,value)	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	local curentFolder = playerFolder.Stats
	local ref = currentFolder:findFirstChild(valueName)
	if ref then
		ref.Value = value
	end
end)

remote_character.OnServerEvent:Connect(function(player,valueName,value)	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	local curentFolder = playerFolder.Character
	local ref = currentFolder:findFirstChild(valueName)
	if ref then
		ref.Value = value
	end
end)

remote_inventory.OnServerEvent:Connect(function(player,valueName,value)	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	local curentFolder = playerFolder.Inventory
	local ref = currentFolder:findFirstChild(valueName)
	if ref then
		ref.Value = value
	end
end)

remote_addCode.OnServerEvent:Connect(function(player, code)
	addCode(player, code)
end)


--Startup
buildCodeList()

