function getVarr(hpd)
    healthDrain = hpd
end

function triggZ(vs1, vs2)
	if getPropertyFromClass('ClientPrefs', 'healthDrain') == 'healthDrain' then
		bugged = true
	else
		bugged = false
	end
	
	if getPropertyFromClass('ClientPrefs', 'healthDrain') == true or (bugged and healthDrain) == true then
		yesnt = true
	end
	v1 = vs1
	v2 = vs2
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if getProperty('health') > (v2 / 50) and getProperty('health') < (v1 / 50) then -- Health is from 0 to 2, so dividing the value by 50 allow to just turn it into percentage easly
		setProperty('health', (v2 / 50))
	elseif  getProperty('health') > (v2 / 50) and getProperty('health') > (v1 / 50) then
		setProperty('health', getProperty('health')-(v1 / 50))
	end
end