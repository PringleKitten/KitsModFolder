if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') or buildTarget == 'android' then
    close()
end

local Elap = 0
local running = false
local x = 0
local y = 0
local dance = false
local v2 = 0

function onEvent(name, value1, value2)
    if name == "WindowDance" then
        a = true
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        v2 = tonumber(value2);
        if value1 == 1 or value1 == 2 then
            dance = true
            setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
            setPropertyFromClass('openfl.Lib', 'application.window.y', 180)
        elseif value1 == -1 then
            dance = false
            fcc = false
        elseif value1 == 0 then
            dance = false
            fcc = true
        end
    end
end
function onUpdatePost(elapsed)
    if a then
        if dance then
            Elap = Elap + (elapsed*v2*playbackRate)
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
            setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap)/10+320)
            setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+180)
        elseif fcc then
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
        else
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
            setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
            setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
            setPropertyFromClass("openfl.Lib", "application.window.height", 720)
            setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
            setPropertyFromClass('openfl.Lib', 'application.window.y', 180)
        end
        if Elap == 0 then
            a = false
        end
    end
end