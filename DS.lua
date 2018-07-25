--[[
ServerScriptService
	[SCRIPT]
ServerStorage
	CurrentCodes
		[String values]
	PlayerData
		Default (Character folder)
			[Categories]
				[Items] 
		PlayerList
			[PlayerName]
				ActiveCharacter (int)
				[CHARACTER 1-3]
					[Category...]
						[Stats...]
						Name -String
						Code -String
						Plantation -String
						XP -Number (total)
						Cores -Int
						Location -String
			
--DATASTORES
Codes [Global]
CHARACTER
Stats
Character
Inventory			
]]

--Variables
_numCharacters = 3


--Keys
key_stats = "FRX_stats"
key_char = "FRX_character"
key_inv = "FRX_inventory"
key_codes = "FRX_takenCodes"
	key_activeCodes = "CODELIST"

--Services
local DSservice = game:GetService("DataStoreService")
local DS_codes = DSservice:GetDataStore(key_codes)
local serStorage = game:GetService("ServerStorage")
local playerFile = serStorage:WaitForChild("PlayerData")
local playerList = serStorage:WaitForChild("PlayerList")


--Functions
function newFolder(player)
	local playerFolder = playerList:FindFirstChild(player.UserId)
	if playerFolder then
		playerFolder:Destroy()
	end
	local newFile = Instance.new("Folder")
	newFile.Parent = playerList
	newFile.Name = player.UserId
	for i = 1, _numCharacters do
		local newCharacter = playerFile.Default:Clone()
		newCharacter.Parent = newFile
		newCharacter.Name = "Character"..i
	end
	print(player.."'s File Loaded!")
	return newFile
end

function codeTaken(code)
	local ret = false
	local data
	
	local DataFetchSuccess, ErrorMessage = pcall(function()
		data = DS_codes:GetAsync(key_activeCodes)
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
	if codeTaken(code) then
		print("Code: "..code.." already exists.")
	else
		local current = DS_codes:GetAsync(key_activeCodes)
		DS_codes:SetAsync(key_activeCodes, current, code)

		local codeStore = DS_codes:GetAsync(key_activeCodes)
		local totalCodes
		if codeStore[1] then
			totalCodes = codeStore[1]
			for i = 1, totalCodes do
				local currentCode = Instance.new("StringValue")
				currentCode.Name = "Code_"..i
				currentCode.Parent = codeFile
				currentCode.Value = codeStore[i+1]
			end
		else
			--First Launch
			codeStore[1] = 0
			print("New Code Store Generated")
		end
	end
end

function buildIn(folder, data)
	for i, v in pairs(folder:GetChildren()) do
		local newData = data:GetAsync(v.Name)
		if newData then
			v.Value = newData
		end
	end
end
function loadData(playerFolder, currentStores)
	buildIn(playerFolder.Stats, currentStores)
	buildIn(playerFolder.Character, currentStores)
	buildIn(playerFolder.Inventory, currentStores)
end

function saveTo(folder, currentStore)
	for i, v in pairs(folder:GetChildren()) do
		currentStore:SetAsync(v.Name,folder:FindFirstChild(v.Name).Value)
	end
end
function saveAllStores(playerFolder, currentStores)
	saveTo(buildIn(playerFolder.Stats, currentStores)
	saveTo(buildIn(playerFolder.Character, currentStores)
	saveTo(buildIn(playerFolder.Inventory, currentStores)
end


--Connections
game.Players.PlayerAdded:connect(function(player)

	local playerFolder = newFolder(player)
			
	local canSave = Instance.new("BoolValue")
	canSave.Parent = player
	
	canSave.Name = "CanSaveData"
	canSave.Value = true

	for i = 1, _numCharacters do
	
		--Datastores in Scope
		local playerStats = DSservice:GetDataStore(key_stats, player.UserId.."_char"..i)
		local playerChar = DSservice:GetDataStore(key_char, player.UserId.."_char"..i)
		local playerInv = DSservice:GetDataStore(key_inv, player.UserId.."_char"..i)
		local currentStores = {playerStats, playerChar, playerInv}
		
		--Test for any data loaded
		local DataFetchSuccess, ErrorMessage = pcall(function()
			playerStats:GetAsync("Name")
		end)
		
		if DataFetchSuccess then	
			loadData(playerFolder:FindFirstChild("Character"..i), currentStores)
		else	
			player.CanSaveData.Value = false
			player:Kick("Your data failed to load. Please rejoin")	
		end
	
	end

end)


game.Players.PlayerRemoving:connect(function(player)

	if player.CanSaveData.Value == false then return end
	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	
	for i = 1, _numCharacters do
	
		--Datastores in Scope
		local playerStats = DSservice:GetDataStore(key_stats, player.UserId.."_char"..i)
		local playerChar = DSservice:GetDataStore(key_char, player.UserId.."_char"..i)
		local playerInv = DSservice:GetDataStore(key_inv, player.UserId.."_char"..i)
		local currentStores = {playerStats, playerChar, playerInv}
	
		local DataWriteSuccess,ErrorMessage = pcall(function()
			saveAllStores(playerFolder:FindFirstChild("Character"..i), currentStores)
		end)
		
		if not DataWriteSuccess then
		
			local Retry_Count = 0
			
			while Retry_Count<6 do
				wait(30)
				local Succeeded, Error = pcall(function()
					saveAllStores(playerFolder:FindFirstChild("Character"..i), currentStores)
				end)
				if Succeeded then break end
				Retry_Count = Retry_Count + 1
			end
			
		end
	end
end)
