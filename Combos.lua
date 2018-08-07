--[[ Combo Build

ComboList
	ComboName [FORMAT: (attack1 attack2 etc.)]
	
]]

combos = {}  --Each saved as {comboName, attack1, attack2, etc.}
sequence = {}


--Functions

--Sequence
function addToSequence(attack) --Call for each attack (String)
	table.insert(sequence,attack)
	local combo = checkForCombo()
	if combo then
		--PERFORM COMBO
		print("Combo performed: "..combo[1]) --Prints combo name
		breakSequence()
	else
		--Remove the first combo? THIS LIMITS COMBO SIZE
	end
end

function breakSequence()
	sequence = {}
end

--Combo
function addCombo(stringValue)
	local newCombo = {}
	table.insert(newCombo,stringValue.Name)
	for word in string.gmatch(stringValue.Value, "%a+") do table.insert(newCombo, word) end
	table.insert(combos,newCombo)
end

function buildComboList(file)
	combos = {}
	for i, v in pairs(file:GetChildren()) do
		addCombo(v)
	end
end

function compareCombo(combo) --Compares current sequence with a combo
	local match = true
	local index = 1
	while index <= #sequence and match do
		if sequence[i] != combo[i+1] then
			match = false
		end
		index = index + 1
	end
	return match
end

function checkForCombo() --Only call for the minimum number to achieve a combo and above. Once this is hit and fails, remove the first item in the seqeunce.
	local comboMatch = nil
	for i, combo in pairs(combos:GetChildren()) do
		if not comboMatch then --Break if a combo is found
			if compareCombo(combo) then
				comboMatch = combo
			end
		end
	end
	return comboMatch --return nil when no combo is found
end