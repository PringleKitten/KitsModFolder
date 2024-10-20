function invt(t)
	ls = t
	captionson(ccaptions)
end

function middcs(ts)
	mid = ts
	captionson(ccaptions)
end

function captionson(capen)
	ccaptions = capen
	if ccaptions then
		makeLuaText('captionText', 'l', 600, 0,500)
    	addLuaText('captionText')
    	setTextSize('captionText', 35)
    	setTextAlignment('captionText', 'center')
    	setProperty('captionText.x', (screenWidth/2)-(getProperty('captionText.width')/2))
    	setObjectCamera('captionText', 'other')
    	setProperty('captionText.alpha', 0)
	end
	
	if mid and not ls then
		screenCenter("captionText", 'x')
	elseif ls and not mid then
		setProperty("captionText.x", 630)
	elseif not ls and not mid then
		setProperty("captionText.x", 0)
	elseif mid and ls then
		screenCenter("captionText", 'x')
	end
end

function onEvent(name, value1, value2)
	if ccaptions then
		if name == 'makeCaption' and value2 ~= 0 then
			value2 = tonumber(value2)
			v2 = value2
			runTimer('captionLength', value2, 0)
			setTextString('captionText', value1)
			--if songName == '' then
			if v2 >= 0.05 then
				doTweenAlpha('captionAlpha', 'captionText', 1, 0.1, 'linear')
			else
				setProperty('captionText.alpha', 1)
			end
			--end
		elseif name == 'makeCaption' and value2 == 0 then
			debugPrint('Hey bro, dont put 0 in value 2 please, game says no no no!')
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if ccaptions then
		if tag == 'captionLength' then
			if v2 > 0.05 then
				doTweenAlpha('captionAlpha', 'captionText', 0, 0.1, 'linear')
			end
		end
	end
end