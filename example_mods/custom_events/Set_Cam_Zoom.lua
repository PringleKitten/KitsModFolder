function onEvent(name,value1,value2)

    if name == "Set_Cam_Zoom" then
        
        setProperty("defaultCamZoom",value1) 
        if not value1 == '' then
            setProperty("camGame.zoom",value1) 
	end
            
    end


end