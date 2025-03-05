local movingX = false
local movingY = false

function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false then
        close(true)
    end
end

function onSongStart()
    setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
    runTimer("waiter",0.05)
    ogX = getPropertyFromClass('openfl.Lib', 'application.window.x')
    ogY = getPropertyFromClass('openfl.Lib', 'application.window.y')
end

function onTimerCompleted()
    setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', true)
end

function onEvent(name, value1, value2)
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
        if name == "WindowCrap" then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
            if value1 == 1 then
                movingX = true
            end
            if value1 == 2 then
                movingY = true
            end
            if value1 == 3 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
                else 
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                end
            end
            if value1 == 4 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
                else 
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
                end
            end
            if value1 == 5 then
                setPropertyFromClass("openfl.Lib", "application.window.angle", value2)
            end
            if movingX then
                if value2 == 00 then
                    setPropertyFromClass("openfl.Lib", "application.window.x", ogX)
                else
                    setPropertyFromClass("openfl.Lib", "application.window.x", value2)
                end
            
            end
            if movingY then
                if value2 == 00 then
                    setPropertyFromClass("openfl.Lib", "application.window.y", ogY)
                else
                    setPropertyFromClass("openfl.Lib", "application.window.y", value2)
                end
            end
        end
    end
end