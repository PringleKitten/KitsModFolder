local movingX = false
local movingY = false
function onEvent(name, value1, value2)
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
    if name == "WindowCrap" then
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        if value1 == 1 then
                movingX = true
            elseif value1 == 2 then
                movingY = true
            elseif value1 == 3 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
                    else 
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                end
            elseif value1 == 4 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
                    else 
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
                end
            elseif value1 == 5 then
                setPropertyFromClass("openfl.Lib", "application.window.angle", value2)
            
        end
        if movingX then
            value2 = getPropertyFromClass("openfl.Lib", "application.window.x") + value2
            setPropertyFromClass("openfl.Lib", "application.window.x", value2)

            elseif movingY then
            value2 = getPropertyFromClass("openfl.Lib", "application.window.y") + value2
            setPropertyFromClass("openfl.Lib", "application.window.y", value2)

        end
    end
end
end