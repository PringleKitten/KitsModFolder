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
		makeLuaText('acaptionText', 'l', 600, 0,500)
    	addLuaText('acaptionText')
    	setTextSize('acaptionText', 35)
    	setTextAlignment('acaptionText', 'center')
    	setProperty('acaptionText.x', (screenWidth/2)-(getProperty('acaptionText.width')/2))
    	setObjectCamera('acaptionText', 'other')
    	setProperty('acaptionText.alpha', 0)
	end
	
	if mid and not ls then
		screenCenter("acaptionText", 'x')
	elseif ls and not mid then
		setProperty("acaptionText.x", 630)
	elseif not ls and not mid then
		setProperty("acaptionText.x", 0)
	elseif mid and ls then
		screenCenter("acaptionText", 'x')
	end
end

function onEvent(name, value1, value2)
	if ccaptions then
		if name == 'makeCaptionbystep' and value2 ~= 0 then
			value2 = tonumber(value2)
			stTime = value2
			startTime = true
			setTextString('acaptionText', value1)
			--if songName == '' then
			if value2 >= 0.05 then
				doTweenAlpha('acaptionAlpha', 'acaptionText', 1, 0.1, 'linear')
			else
				setProperty('acaptionText.alpha', 1)
			end
			--end
		elseif name == 'makeCaptionbystep' and value2 == 0 then
			debugPrint('Hey bro, dont put 0 in value 2 please, game says no no no!')
		end
	end
end

function onStepHit()
	if stTime > 0 and startTime then
		stTime = stTime - 1
	else
		doTweenAlpha('acaptionAlpha', 'acaptionText', 0, 0.1, 'linear')
		stTime = 0
		startTime = false
	end
end