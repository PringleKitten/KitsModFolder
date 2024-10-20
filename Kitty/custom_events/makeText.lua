function onCreate()
	makeLuaText('st', 'l', '800', 400,450)
    addLuaText('st')
    setTextSize('st', 50)
    setTextAlignment('st', 'center')
    setProperty('st.x', (screenWidth/2)-(getProperty('st.width')/2))
    setObjectCamera('st', 'other')
    setProperty('st.alpha', 0)
end

function onUpdate()
	if st then
		doTweenAlpha('st', 'st', 1, 0.2, 'linear')
	else
		doTweenAlpha('st', 'st', 0, 0.2, 'linear')
	end
end

function onEvent(name, value1, value2)
	if name == 'makeText' then
		runTimer('stt', value2, 0)
		setTextString('st', value1)
		st = true
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'stt' then
		st = false
	end
end