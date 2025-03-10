local Elap = 0
local running = false
local x = 0
local y = 0
local dance = false
local v2 = 0

function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false or buildTarget == 'android' then
        close(true)
    end
end

function onEvent(name, value1, value2)
    if name == "WindowDance" then
        a = true
        if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
            v2 = tonumber(value2);
            x = screenWidth/3.75
            y = screenHeight/3.5
        if value1 == 1 then
            dance = true
            fcc = true
        else
            dance = false
            fcc = true
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
        end
        if value1 == 2 then
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
            dance = true
            fcc = false
        elseif value1 ~= 1 then
            dance = false
            fcc = true
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
        end
        end
    end
end
function onUpdatePost(elapsed)
    if a then
        if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
            if dance then
                Elap = Elap + (elapsed*v2*playbackRate)
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
                setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
                setPropertyFromClass("openfl.Lib", "application.window.height", 720)
                setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap)/10+x)
                setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+y)
            elseif fcc then
                setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
            else
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
                setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
                setPropertyFromClass("openfl.Lib", "application.window.height", 720)
            end
        end
        if Elap == 0 then
            a = false
        end
    end
end