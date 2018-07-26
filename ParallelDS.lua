--[[
ServerScriptService
	[SCRIPT]
		addCode
		
ServerStorage
	CodeList
		[String values]
	PlayerData
		Default (Character folder)
			[CATEGORIES]
				[Items] 
		PlayerList
			[PlayerName]
				[CATEGORIES]
					[Stats...]
					Name -String
					Code -String
					Plantation -String
					XP -Number (total)
					Cores -Int
					Location -String
			
--DATASTORES
Codes [Global]
Stats
Character
Inventory			
]]



--Syntax
prefix_data = "data_"
prefix_player = "player_"

--Keys
key_playerData = "FRX_datastore&TEST"
key_codesData = "FRX_codestore&TEST"

--Services
local DSservice = game:GetService("DataStoreService")
local serStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local playerFile = serStorage:WaitForChild("PlayerData")
local playerList = serStorage:WaitForChild("PlayerList")
local codeList = serStorage:WaitForChild("CodeList")
local remote_addCode = script.addCode

--[[Datastore Build
playerDataValues = { --Add in values if and when the default folder is updated
	Stats = {	
		playerName = "Name",
		Cores = 0,
		Code = "AA-[000]"
		}
	Character = {
		skinTone = Color3.new(0,0,0)
		detailColor = Color3.new(0,0,0)
		hairColor = Color3.new(0,0,0)
		}
	Inventory = {
		slot1 = "NONE"
		slot2 = "NONE"
		slot3 = "NONE"
		}
	}

tableValues = HttpService:JSONEncode(playerDataValues)
print(tableValues)
]]

--Structure
datastoreStructure = {
	Stats = {}
	Character = {}
	Inventory = {}
	}

--Datastores
local DS_main = DSservice:GetDataStore(key_playerData)
local DS_codes = DSservice:GetOrderedDataStore(key_codesData)

--Functions
function newFolder(player)
	if playerList:FindFirstChild(player.UserId) then
		playerList:FindFirstChild(player.UserId):Destroy()
	end
	local newFile = playerFile.Default:Clone()
	newFile.Parent = playerList
	newFile.Name = player.UserId
	print(player.Name.."'s File Generated")
end

function loadData(player, data)
	local playerFile = playerList:findFirstChild(player.UserId)
	for i, v in pairs(playerFile:GetChildren()) do
		local currentFile = playerFile:FindFirstChild(v.Name)
		local currentArray = data[currentFile]
		for i, x in pairs(v:GetChildren()) do
			local currentValue = x.Name
			local currentData = currentArray[prefix_data..currentValue]
			x.Value = currentData or x.Value
			end
		end
	end
end

function getSaveTable(player)
	local playerFile = playerList:findFirstChild(player.UserId)
	local playerDataTable = datastoreStructure:Clone()
	for i, v in pairs(playerFile:GetChildren()) do
		local currentTable = playerDataTable[v.Name]
		for i, x in pairs(v:GetChildren()) do
			currentTable[prefix_data..x.Name] = x.Value
		end
	end
	return HttpService:JSONEncode(playerDataTable)
end

function addCode(player, code)
	DS_codes:SetAsync(prefix_player..player.UserId, code)
end

function buildCodeList()
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
game.Players.PlayerAdded:connect(function(player)

	local canSave = Instance.new("BoolValue")
	canSave.Parent = player
	
	canSave.Name = "CanSaveData"
	canSave.Value = true
	
	newFoler(player)
	
	local playerData
	
	--Test for the default data load
	local DataFetchSuccess, ErrorMessage = pcall(function()
		playerData = playerStats:GetAsync(prefix_player..player.UserId)
	end)
		
	if DataFetchSuccess then	
		loadData(player, HttpService:JSONDecode(playerData))
	else	
		player.CanSaveData.Value = false
		player:Kick("Your data failed to load. Please rejoin")	
	end

end)


game.Players.PlayerRemoving:connect(function(player)

	if player.CanSaveData.Value == false then return end
	
	local playerFolder = playerList:FindFirstChild(player.UserId)
	

	local DataWriteSuccess,ErrorMessage = pcall(function()
		DS_main:SetAsync(prefix_player..player.UserId, getSaveTable(player))
	end)
	
	if not DataWriteSuccess then
	
		local Retry_Count = 0
		
		while Retry_Count<6 do
			wait(30)
			local Succeeded, Error = pcall(function()
				DS_main:SetAsync(prefix_player..player.UserId, getSaveTable(player))
			end)
			if Succeeded then break end
			Retry_Count = Retry_Count + 1
		end
		
	end

end)


remote_addCode.OnServerEvent:connect(function(player, code)
	addCode(player, code)
end)


--Startup
buildCodeList()