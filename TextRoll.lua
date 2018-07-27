local codeDisplay
local rollSound --or wbhatever

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

local rollAmount = 100
function rollText(realCode)
	for i = 1, rollAmount do
		if i ~= rollAmount then
			codeDisplay.Test = getCode()
			rollSound:Play()
			wait(1/(rollAmount-))
		else
			codeDisplay.Text = realCode
		end
	end
end


rollText(getCode()) --CHECK THIS WITH DATASTORE CODES TO