local ccaptions = true

function onCreate()
	makeLuaText('captionText', 'l', '800', 400,450)
    addLuaText('captionText')
    setTextSize('captionText', 50)
    setTextAlignment('captionText', 'center')
    setProperty('captionText.x', (screenWidth/2)-(getProperty('captionText.width')/2))
    setObjectCamera('captionText', 'other')
    setProperty('captionText.alpha', 0)
end

function captionson(capen)
	ccaptions = capen
end

function onUpdate()
	if ccaptions then
		--if songName == '' then
			if showCaption then
				doTweenAlpha('captionAlpha', 'captionText', 1, 0.2, 'linear')
			else
				doTweenAlpha('captoinAlpha', 'captionText', 0, 0.2, 'linear')
			end
		--end
	end
end

function onEvent(name, value1, value2)
	if ccaptions then
		if name == 'makeCaption' then
			runTimer('captionLength', value2, 0)
			setTextString('captionText', value1)
			showCaption = true
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if ccaptions then
		if tag == 'captionLength' then
			showCaption = false
		end
	end
end