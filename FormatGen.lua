--[[
Display:
AA-[####]

Actual:
######

]]

--All Letters



function checkForCode(code)
	return false --False if the code does not exist in the datastore
end

function generateCode()
	return math.random(1,999999)
end

function toCodeChar(num)
	ret = ""
	if num > 0 then
		ret = string.char(num+64)
	end
end

function getDisplayCode(code)
	newCode = code
	codeArray = {0,0,0,0,0,0}
	for i = 6, 1, -1 do
		codeArray[i] = newCode%10
		newCode = math.floor(newCode)
	end
	for i = 1, 2 do
		codeArray[i] = toCodeChar(codeArray[i])
	end
	
	return codeArray[1]..codeArray[2].."-["..codeArray[3]..codeArray[4]..codeArray[5]..codeArray[6].."]"
end