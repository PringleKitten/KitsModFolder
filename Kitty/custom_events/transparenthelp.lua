function getVarr(vis,bm)
    visuals = vis
    botherme = bm
end

function onEvent(name, value1, value2)
    value1 = tonumber(value1)
    if name == "transparenthelp" then
        if botherme then
            debugPrint('Go to custom_events/transparenthelp.lua to use transparency events!')
        end
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == 'assetMovement' then
            bugged = true
        else
            bugged = false
        end
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true or (bugged and visuals) == true then
            if value1 == 1 then
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
                setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
                setPropertyFromClass("openfl.Lib", "application.window.width", 1919)
                setPropertyFromClass("openfl.Lib", "application.window.height", 1079)
                setPropertyFromClass("openfl.Lib", "application.window.x", 0)
                setPropertyFromClass("openfl.Lib", "application.window.y", 0)
            else
                if value1 == 0 then
                setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
                setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
                end
            end
        end
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
end