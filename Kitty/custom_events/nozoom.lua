function onEvent(name,value1,value2)
    if name == "nozoom" then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 1 then
            stopcam = true
            setProperty('camZoomsBg', false)
        elseif value1 == 0 then
            stopcam = false
            setProperty('camZoomsBg', true)
        end
        if value2 == 1 then
            stopui = true
            setProperty('camZoomsHud', false)
        elseif value2 == 0 then
            stopui = false
            setProperty('camZoomsHud', true)
        end
    end
    if name == "Add Camera Zoom" then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        setProperty('camGame.zoom', getProperty('camGame.zoom')+value2)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom')+value2)
    end
end