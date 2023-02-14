-- screen vaules to remember
local running = false
local Elap = 0
local fc = false
local sx = 0
local sy = 0
local sh = 0
local sw = 0
local onlyX = false
local onlyY = false
local x = 0
local stop = false
local y = 0
function onCreate()
    sx = getPropertyFromClass("openfl.Lib", "application.window.x")
    sy = getPropertyFromClass("openfl.Lib", "application.window.y")
    setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/4)
    setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/4)
    x = getPropertyFromClass("openfl.Lib", "application.window.x")
    y = getPropertyFromClass("openfl.Lib", "application.window.y")
    fc = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
    sh = getPropertyFromClass("openfl.Lib", "application.window.height")
    sw = getPropertyFromClass("openfl.Lib", "application.window.width")
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
end
function onUpdate()
    if curBeat == 32 then
        running = true
    elseif curBeat == 96 then
        running = false
        onlyX = true
    elseif curBeat == 112 then
        onlyX = false
        onlyX1 = true
    elseif curBeat == 128 then
        running = true
    elseif curBeat == 160 then
        running = false
    elseif curBeat == 256 then
        running = true
    elseif curBeat == 284 then
        running = false
    elseif curBeat == 296 then
        running = true
    elseif curBeat == 328 then
        running = false
        stop = true
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
    elseif curBeat == 424 then
        stop = false
        running = true
    elseif curBeat == 496 then
        running = false
    end
end
function onUpdatePost(elapsed)
    if ClientPrefs.assetMovement == true then
    Elap = Elap + (elapsed*4)
    if stop then
    else
    if running then
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap)/10+x)
        setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+y)
        setPropertyFromClass("openfl.Lib", "application.window.angle", 10) 
    elseif onlyX then
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap*1.5)/10+x)
    elseif onlyX1 then
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        setPropertyFromClass("openfl.Lib", "application.window.x", 1000*math.cos(Elap*2)/10+x)
    elseif onlyY then
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
        setPropertyFromClass("openfl.Lib", "application.window.y", 1000*math.sin(Elap)/10+y)
    else
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
    end
end
end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", fc)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.x", sx)
    setPropertyFromClass("openfl.Lib", "application.window.y", sy)
    setPropertyFromClass("openfl.Lib", "application.window.width", sw)
    setPropertyFromClass("openfl.Lib", "application.window.height", sh)
end