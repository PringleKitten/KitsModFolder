function onEvent(name,value1,value2)
    if name == "Set_Cam_Zoom" then     
		value1 = tonumber(value1)
		value2 = tonumber(value2)   
        if value2 == '' or value2 < 0.012 then
			setProperty('camGame.zoom',value1)
			setProperty('defaultCamZoom',value1)
		else
            doTweenZoom('camz','camGame',value1,value2,'sineInOut')
			runTimer("WHY",value2)
			NO = true
		end
    end
end
function onUpdate()
	if NO then
		setProperty('defaultCamZoom',getProperty('camGame.zoom'))
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'WHY' then
		NO = false
	end
end

function onTweenCompleted(name)
	if name == 'camz' then
		setProperty('defaultCamZoom',getProperty('camGame.zoom'))
	end
end