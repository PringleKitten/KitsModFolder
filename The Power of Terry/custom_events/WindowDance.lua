local Elap = 0
local running = false
local x = 0
local y = 0
local dance = false
local v2 = 0
function onEvent(name, value1, value2)
    if name == "WindowDance" then
        a = true
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
            v2 = tonumber(value2);
            x = screenWidth/2.5
            y = screenHeight/2.5
            if value1 == 1 then
                dance = true
                fcc = true
            else
                dance = false
                fcc = true
                setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/3)
                setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/3)
                setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.height", screenHeight/1.25)
            end
            if value1 == 2 then
                setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.height", screenHeight/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/3)
                setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/3)
                dance = true
                fcc = false
            elseif value1 ~= 1 then
                dance = false
                fcc = true
                setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/3)
                setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/3)
                setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.height", screenHeight/1.25)
            end
        end
    end
end
function onUpdatePost(elapsed)
    if a then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            if dance then
                Elap = Elap + (elapsed*v2)
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap)/10+x)
                setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+y)
            elseif fcc then
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
            else
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.height", screenHeight/1.25)
                setPropertyFromClass("openfl.Lib", "application.window.x", screenheight/3)
                setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/3)
            end
        end
        if Elap == 0 then
            a = false
        end
    end
end