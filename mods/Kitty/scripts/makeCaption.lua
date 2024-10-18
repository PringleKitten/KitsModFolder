function captionson(capen)
	ccaptions = capen
end

function onSongStart()
	if ccaptions then
		makeLuaText('captionText', 'l', 1000, 0,600)
    	addLuaText('captionText')
    	setTextSize('captionText', 35)
    	setTextAlignment('captionText', 'center')
		screenCenter("captionText", 'x')
    	setProperty('captionText.x', (screenWidth/2)-(getProperty('captionText.width')/2))
    	setObjectCamera('captionText', 'other')
    	setProperty('captionText.alpha', 0)
	end
end


function onEvent(name, value1, value2)
	if ccaptions then
		if name == 'makeCaption' then
			runTimer('captionLength', value2, 0)
			setTextString('captionText', value1)
		--if songName == '' then
			doTweenAlpha('captionAlpha', 'captionText', 1, 0.1, 'linear')
		--end
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if ccaptions then
		if tag == 'captionLength' then
			doTweenAlpha('captoinAlpha', 'captionText', 0, 0.1, 'linear')
		end
	end
end