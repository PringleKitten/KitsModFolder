function onEvent(name,value1,value2)
    if name == "add_cam_zoom" then      
		aa = getProperty('camHUD.zoom')  
        if value2 == '' then
			doTweenZoom('camz','camHUD',aa+tonumber(value1),0.01,'sineInOut')
	    else
            doTweenZoom('camz','camHUD',aa+tonumber(value1),tonumber(value2),'sineInOut')
	    end
    end
end

function onTweenCompleted(name)
	if name == 'camz' then
  		setProperty("defaultCanUIZoom",getProperty('camHUD.zoom')) 
	end
end