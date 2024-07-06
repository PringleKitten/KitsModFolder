function onEvent(name, value1, value2)
    if name == 'cameraFlash' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == '' or value1 == null or value1 == nil then
            cameraFlash("game", "0xFFFFFF", value2, true)
        elseif value2 == nil or value2 == null or value2 == '' then
            cameraFlash("game", value1, 1, true)
        elseif value1 == '' or value1 == null or value1 == nil and value2 == '' or value2 == null or value2 == nil then
            cameraFlash("game", "0xFFFFFF", 1, true)
        else
            cameraFlash("game", value1, value2, true)
        end
    end
end