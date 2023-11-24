function onEvent(name,value1,value2)
    if name == "add_cam_zoom" then      
		aa = getProperty('camGame.zoom')  
        if value2 == '' then
      	  	setProperty("defaultCamZoom",value1)
			debugPrint(value2 )
		else
            doTweenZoom('camz','camGame',aa+tonumber(value1),tonumber(value2),'sineInOut')
		end
    end
end

function onTweenCompleted(name)
	if name == 'camz' then
  		setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	end
end