local Elap = 0
local running = false
local x = 0
local y = 0
local dance = false
local v2 = 0
function onEvent(name, value1, value2)
    if name == "WindowDance" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        v2 = tonumber(value2);
        x = screenWidth/4
        y = screenHeight/4
        if value1 == 1 then
        dance = true
        else
            dance = false
        end
    end
    end
end
function onUpdatePost(elapsed)
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
    if dance then
        Elap = Elap + (elapsed*v2)
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap)/10+x)
        setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+y)
    else
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
    end
end
end