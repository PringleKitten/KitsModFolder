function onEvent(name,value1,value2)
    if name == "hudzoom" then        
        if value2 == '' then
			doTweenZoom('camz','camHUD',tonumber(value1),0.01,'sineInOut')
	    else
            doTweenZoom('camz','camHUD',tonumber(value1),tonumber(value2),'sineInOut')
	    end
    end
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom')) 
    end
end