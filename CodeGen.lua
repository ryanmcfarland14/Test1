--[[
ScreenGui
	Frame
		[SCRIPT]
		StartFrame
			Title - "Datastore Generation Input"
			Button - "Get a random code"
		ResultFrame
			Title - "Thanks! Your code:"
			Label + "AA-[0000]"
ServerStorage
	Codes
		[Strings]
]]

frame = script.Parent
startFrame = frame.StartFrame
resultFrame = frame.ResultFrame
player = game.Players.LocalPlayer
setStorage = game:GetService("ServerStorage")
codeList = serStorage:WaitForChild("Codes")

resultFrame.Visible=false
startFrame.Visible=true

function isTaken(code)
	local ret = false
	for i, v in pairs(codeList:getChildren()) do
		if code == v.Value then
			ret = true
		end
	end
	return ret
end

local restrictedCodes = {}
function getCode()
	local randomNumber
	local restricted = true
	while restricted do
		randomNumber =  math.random(60,999)
		restricted = false
		for i = 1, #restrictedCodes do
			if randomNumber == restrictedCodes[i] then
				restricted = true
			end
		end
	end
	local randomLetter1 = string.char(math.random(65,90))
	local randomLetter2 = string.char(math.random(65,90))
	while string.len(randomNumber) < 3 do
		randomNumber = "0"..randomNumber
	end
	local finalString = randomLetter1..randomLetter2.."-["..randomNumber.."]"
	print("New code generated: "..finalString)
	return finalString
end

startFrame.Button.MouseButton1Click:connect(function()
	local newCode = getCode()
	while isTaken(newCode) do
		newCode = getCode()
	end
	resultFrame.Visible = true
	startFrame.Visible = false
	resultFrame.Label.text = newCode()
	--Fire Server...?
end