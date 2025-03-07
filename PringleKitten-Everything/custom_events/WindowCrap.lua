local movingX = false
local movingY = false

function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false or buildTarget == 'android' then
        close(true)
    end
end

function onDestroy()
    setPropertyFromClass('openfl.Lib', 'application.window.maximized', ogM)
    setPropertyFromClass('openfl.Lib', 'application.window.x', ogX)
    setPropertyFromClass('openfl.Lib', 'application.window.y', ogY)
    setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
    setPropertyFromClass("openfl.Lib", "application.window.height", 720)
end

function onSongStart()
    ogM = getPropertyFromClass('openfl.Lib', 'application.window.maximized')
    setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
    setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
    setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
    setPropertyFromClass("openfl.Lib", "application.window.height", 720)
    runTimer("waiter",0.05)
    ogX = getPropertyFromClass('openfl.Lib', 'application.window.x')
    ogY = getPropertyFromClass('openfl.Lib', 'application.window.y')
end

function onUpdate()
    if forceS then
        if ffs then
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
        end
        if fnfs then
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
        end
        if fbl then
            setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
        end
        if fnbl then
            setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
        end
    end
end

function onTimerCompleted()
    if tag == 'waiter' then
        setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', true)
    end
end

function onEvent(name, value1, value2)
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
        if name == "WindowCrap" then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
            if value1 == 9090 then
                forceS = true
            elseif value1 == 8080 then
                forceS = false
            end
            if value1 == 1 then
                movingX = true
            end
            if value1 == 2 then
                movingY = true
            end
            if value1 == 3 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
                    ffs = true
                    fnfs = false
                else 
                    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                    fnfs = true
                    ffs = false
                end
            end
            if value1 == 4 then
                if value2 == 1 then
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
                    fbl = true
                    fnbl = false
                else 
                    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
                    fbl = false
                    fnbl = true
                end
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