local fps = 240  -- Change this value to change the desired fps limit
local change = false -- Set to true to use this custom fps script

function onCreate()
    if change and fps > getPropertyFromClass('flixel.FlxG', 'drawFramerate') then
        setPropertyFromClass('flixel.FlxG', 'updateFramerate', fps)
        setPropertyFromClass('flixel.FlxG', 'drawFramerate', fps)
        setPropertyFromClass('backend.ClientPrefs', 'data.framerate', fps)
    elseif change then
        setPropertyFromClass('flixel.FlxG', 'drawFramerate', fps)
        setPropertyFromClass('flixel.FlxG', 'updateFramerate', fps)
        setPropertyFromClass('backend.ClientPrefs', 'data.framerate', fps)
    end
end

function onDestroy()	
    if framerate > getPropertyFromClass('flixel.FlxG', 'drawFramerate') then
        setPropertyFromClass('flixel.FlxG', 'updateFramerate', framerate)
        setPropertyFromClass('flixel.FlxG', 'drawFramerate', framerate)
    else
        setPropertyFromClass('flixel.FlxG', 'drawFramerate', framerate)
        setPropertyFromClass('flixel.FlxG', 'updateFramerate', framerate)
    end
    close()
end