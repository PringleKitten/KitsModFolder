if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') or buildTarget == 'android' then
    close()
end

local movingX = false
local movingY = false

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", ogFS)
    setPropertyFromClass('openfl.Lib', 'application.window.maximized', ogM)
    if not ogFS or not ogm then
        setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
        setPropertyFromClass('openfl.Lib', 'application.window.y', 180)
        setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
        setPropertyFromClass("openfl.Lib", "application.window.height", 720)
    end
end

function onSongStart()
    ogM = getPropertyFromClass('openfl.Lib', 'application.window.maximized')
    ogFS = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
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
    if name == "WindowCrap" then
        value1 = tonumber(value1);
        if value1 == 9090 then
            forceS = true
        elseif value1 == 8080 then
            forceS = false
        end
        if value1 == 1 then
            if value2 == '00' then
                setPropertyFromClass("openfl.Lib", "application.window.x", ogX)
            else
                value2 = tonumber(value2);
                setPropertyFromClass("openfl.Lib", "application.window.x", value2)
            end
        end
        if value1 == 2 then
            if value2 == '00' then
                setPropertyFromClass("openfl.Lib", "application.window.y", ogY)
            else
                value2 = tonumber(value2);
                setPropertyFromClass("openfl.Lib", "application.window.y", value2)
            end
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
    end
end