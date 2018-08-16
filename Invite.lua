--[[
ReplicatedStorage
	PartyData
		PartyName
			Players...
PlayerGui
 HUD
	Top
		IncomingInvite [Frame]
			[SCRIPT]
				InviteEvent
			ShadowRef = Shadow_Invite
			Title
			Accept
			Decline
			Block
				PlayerNames...
			Config
				isOpen
			IncomingInvites
	Mid
		Shadow_IncomingInvite
		
]]

--Components
local frame = script.Parent
local title = frame.Title
local accept = frame.Accept
local decline = frame.Decline
local block = frame.Block
local config = frame.Config
	local isOpen = config.isOpen
local invites = frame.IncomingInvites

local repStorage = game:GetService("ReplicatedStorage")
local playerData = repStorage:WaitForChild("PlayerData")
local player = game.Players.LocalPlayer
local playerFile = playerData.PlayerList:WaitForChild(player.UserId)
	local playerStats = playerFile:WaitForChild("Stats")
		local partner = playerFile:WaitForChild("Partner")
		local party = playerFile:WaitForChild("Party")

local currentInvite = nil

--Queue
local queue = {}
local curPos = 1

function enqueue(value)
	table.insert(value)
end

function dequeue()
	curPos = curPos + 1
end

function getCur()
	return queue[curPos]
end

function resetQueue()
	queue = {}
	curPos = 1
end

function isEmpty()
	if getCur() then
		return false
	else
		resetQueue()
		return true
	end
end

function findCur()
	return invites:FindFirstChild(getCur()) --returns nil when it does not exist
end
		
--Functions
function showNext()
	if not isEmpty() then
		currentInvite = getCur()
		openInvite(currentInvite)
	end
end

function openInvite(invite)  --Will either be Squad or Partner
	isOpen.Value = true
	title.Text = "New "..invite.Value.." Invite from "..invite.Name.."!"
	frame:TweenPosition(UDim2.new(0,0,0,0),"Out","Back")
end

function closeInvite()
	frame:TweenPosition(UDim2.new(0,0,0,0),"Out","Back")
	wait(1)
	currentInvite = nil
	dequeue()
	invite:Destroy()
	currentInvite = nil
	isOpen.Value = false
	showNext()
end

function checkIfAlreadyInvited(name)
	local count = 0
	for i, v in pairs(invites:GetChildren()) do
		if v.Name == name then
			count = count + 1
		end
	end
	if count > 1 then
		return false
	else
		return true
	end
end
		
--Connection
invites.ChildAdded:connect(function(invite)  --String where the name is a player and the value is the type
	if checkIfAlreadyInvited then
		invite:Destroy()
	else
		enqueue(invite.Name)
		if not isOpen.Value then
			currentInvite = invite
			openInvite(invite)
		end
	end
end)