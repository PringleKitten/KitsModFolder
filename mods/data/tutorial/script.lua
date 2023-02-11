local x = 0
local y = 0

function onUpdate()
    songPos = getSongPosition()
    local currentBeat = (songPos/5000)*(curBpm/60)
    x = getPropertyFromClass("openfl.Lib", "application.window.x")
    y = getPropertyFromClass("openfl.Lib", "application.window.y")
    if curStep == 1 then
        setPropertyFromClass("openfl.Lib", "application.window.x", 300)
        setPropertyFromClass("openfl.Lib", "application.window.y", 150)
        end
    if curBeat >= 5 then
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
    setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
    setPropertyFromClass("openfl.Lib", "application.window.height", 720)
    setPropertyFromClass("openfl.Lib", "application.window.x", x - 50*math.sin((currentBeat+4*0.25)*math.pi))
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
end