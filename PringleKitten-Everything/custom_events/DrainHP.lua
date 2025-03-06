local run = false
local value1 = 0
local value2 = 0
function onEvent(name, v1, v2)
	if name == "DrainHP" then
		if getPropertyFromClass('backend.ClientPrefs', 'data.healthDrain') == true then
			stopper = getPropertyFromClass("backend.ClientPrefs", "data.guitarHeroSustains")
			value1 = v1
			value2 = v2
		end
	end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if stopper then
		if not isSustainNote then
			drainbruh = true
		end
	else
		drainbruh = true
	end
	if drainbruh then
		if getProperty('health') > (value2 / 50) and getProperty('health') < (value1 / 50) then -- Health is from 0 to 2, so dividing the value by 50 allow to just turn it into percentage easly
			setProperty('health', (value2 / 50))
		elseif getProperty('health') > (value2 / 50) and getProperty('health') > (value1 / 50) then
			setProperty('health', getProperty('health')-(value1 / 50))
		end
		drainbruh = false
	end
end