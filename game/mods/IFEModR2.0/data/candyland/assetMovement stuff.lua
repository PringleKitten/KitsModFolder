local lockedPosition = nil
local tweening = false
local tweenEndTime = 0
local started = false

function onBeatHit()
    if curBeat == 4 then
        tweenWindow(200, 100, 1280*0.6, 720*0.6, 1, "expoOut")
    elseif curBeat == 8 then
        tweenWindow(600, 500, 1280*0.8, 720*0.8, 1, "expoOut")
    elseif curBeat == 12 then
        tweenWindow(550, 300, 1280*0.7, 720*0.7, 0.8, "expoOut")
    elseif curBeat == 14 then
        tweenWindowS(550, 300, 1280*1.3, 720*1.3, 0.8, "sineOut")
    elseif curBeat == 16 then
        tweenWindow(200, 100, 1280*0.6, 720*0.6, 1, "expoOut")
    elseif curBeat == 66 then
        close()
    end
end
function onStepHit()
    if curStep == 78 then
        setWindow("+800", "+0", "+0", "+0")
    elseif curStep > 79 and curStep < 84 then
        setWindow("+0", "+75", "+0", "+0")
    elseif curStep > 83 and curStep < 88 then
        setWindow("-200", "+0", "+0", "+0")
    elseif curStep == 88 then
        setWindow("+0", "-300", "+0", "+0")
    elseif curStep == 90 then
        setWindow("+700", "+200", "+0", "+0")
    elseif curStep == 91 then
        setWindow("-700", "+0", "+0", "+0")
    elseif curStep == 92 then
        setWindow("+300", "+0", "+0", "+0")
    elseif curStep == 94 then
        setWindow(100, 50, 1280*0.8, 720*0.8)
    elseif curStep > 95 and curStep < 100 then
        setWindow("+0", "+75", "+0", "+0")
    elseif curStep > 99 and curStep < 104 then
        setWindow("+200", "+0", "+0", "+0")
    elseif curStep == 104 then
        setWindow("+0", "-300", "+0", "+0")
    elseif curStep == 110 then
        setWindow("center", "center", "+0", "+0")
    elseif curStep > 111 and curStep < 120 then
        setWindowS("+0", "+0", "+32", "+18")
    elseif curStep == 120 then
        setWindowS("+0", "+0", "+160", "+98")
    elseif curStep == 122 then
        setWindowS("+0", "+0", "+160", "+98")
    elseif curStep == 124 then
        setWindowS("+0", "+0", "+160", "+98")
    elseif curStep == 126 then
        setWindowS("+0", "+0", "+160", "+98")
    end
end
function setWindow(x, y, w, h)
    local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
    local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
    local newW, newH = parseValue(w, current.width), parseValue(h, current.height)
    local newX, newY = parseValue(x, current.x, screen.sw, newW), parseValue(y, current.y, screen.sh, newH)
    runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], newX, newY, newW, newH))
    lockedPosition = { x = newX, y = newY, width = newW, height = newH }
end
function setWindowS(x, y, w, h)
    local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
    local scaleX, scaleY = screen.sw / 1920, screen.sh / 1080
    local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
    local parsedW, parsedH = parseValue(w, current.width), parseValue(h, current.height)
    local sw, sh = parsedW * scaleX, parsedH * scaleY
    local scaledX, scaledY = parseValue(x, current.x, screen.sw, sw), parseValue(y, current.y, screen.sh, sh)
    local dw, dh = sw - current.width, sh - current.height
    local newX, newY = scaledX - dw / 2, scaledY - dh / 2
    runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], newX, newY, sw, sh))
    lockedPosition = { x = newX, y = newY, width = sw, height = sh }
end
function parseValue(param, current, screenSize, windowSize)
    if type(param) == "string" then
        if param == "center" and screenSize and windowSize then return (screenSize - windowSize) / 2 end
        local sign, num = param:match("^([+-])(%d+)$")
        if sign and num then return tonumber(num) * (sign == '+' and 1 or -1) + current end
        local n = tonumber(param)
        if n then return n end
    elseif type(param) == "number" then return param end
    return current
end
function scaleWindowParams(x, y, w, h)
    local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
    local scaleX, scaleY = screen.sw / 1920, screen.sh / 1080
    return x * scaleX, y * scaleY, w * scaleX, h * scaleY
end
function tweenWindow(x, y, w, h, dur, easeType)
    local easeMap = { linear = 'linear', sineIn = 'sineIn', sineOut = 'sineOut', expoIn = 'expoIn', expoOut = 'expoOut' }
    local ease = easeMap[easeType] or 'linear'
    tweening, tweenEndTime = true, os.clock() + dur
    local sx, sy, sw, sh = scaleWindowParams(x, y, w, h)
    runHaxeCode(string.format([[import lime.app.Application; import flixel.tweens.FlxTween; import flixel.tweens.FlxEase; import Reflect; var wnd = Application.current.window; var props = { x: %f, y: %f, width: %f, height: %f }; var easeFunc = Reflect.field(FlxEase, "%s"); if (easeFunc == null) easeFunc = FlxEase.linear; FlxTween.tween(wnd, props, %f, { ease: easeFunc });]], sx, sy, sw, sh, ease, dur))
    lockedPosition = { x = sx, y = sy, width = sw, height = sh }
end
function tweenWindowS(targetX, targetY, targetW, targetH, dur, easeType)
    local easeMap = { linear = 'linear', sineIn = 'sineIn', sineOut = 'sineOut', expoIn = 'expoIn', expoOut = 'expoOut' }
    local ease = easeMap[easeType] or 'linear'
    tweening, tweenEndTime = true, os.clock() + dur
    local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
    local scaleX, scaleY = screen.sw / 1920, screen.sh / 1080
    local sx, sy = targetX * scaleX, targetY * scaleY
    local sw, sh = targetW * scaleX, targetH * scaleY
    local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
    local dw, dh = sw - current.width, sh - current.height
    local newX, newY = sx - dw / 2, sy - dh / 2
    lockedPosition = { x = newX, y = newY, width = sw, height = sh }
    runHaxeCode(string.format([[import lime.app.Application; import flixel.tweens.FlxTween; import flixel.tweens.FlxEase; import Reflect; var wnd = Application.current.window; var props = { x: %f, y: %f, width: %f, height: %f }; var easeFunc = Reflect.field(FlxEase, "%s"); if (easeFunc == null) easeFunc = FlxEase.linear; FlxTween.tween(wnd, props, %f, { ease: easeFunc });]], newX, newY, sw, sh, ease, dur))
end
function rememberWindowPosition()
    lockedPosition = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
end
function snapBackIfMoved()
    if tweening or not lockedPosition then return end
    local currentWnd = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
    if not currentWnd then return end
    local dx = math.abs(currentWnd.x - lockedPosition.x)
    local dy = math.abs(currentWnd.y - lockedPosition.y)
    local dw = math.abs(currentWnd.width - lockedPosition.width)
    local dh = math.abs(currentWnd.height - lockedPosition.height)
    if dx > 2 or dy > 2 or dw > 2 or dh > 2 then
        runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], lockedPosition.x, lockedPosition.y, lockedPosition.width, lockedPosition.height))
    end
end
function onCreatePost()
    if buildTarget ~= 'android' then
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/Set-Wallpaper.ps1"')
    end
end
function onSongStart()
    rememberWindowPosition()
    started = true
end
function onUpdate()
    if started and buildTarget ~= 'android' then
        runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; wnd.fullscreen = false;]])
        if tweening and os.clock() >= tweenEndTime then
            tweening = false
            rememberWindowPosition()
        end
        snapBackIfMoved()
    end
end

function luaSprite(tag, where, xPos, yPos, xw, yh, sF, aA, C, sC, oO)
    makeLuaSprite(tag, where, xPos, yPos)
    setObjectCamera(tag, C)
    setScrollFactor(tag, sF, sF)
    setObjectOrder(tag, oO)
    scaleObject(tag, xw, yh)
    setProperty(tag .. ".alpha", aA)
    if sC ~= 'n' then
        screenCenter(tag, sC)
    end
    updateHitbox(tag)
end
function onCountdownStarted()
    setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 323)
    setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 323)
    setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 323)
    setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 323)
    for i = 0, 3 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0) -- instantly sets alpha
    end
    luaSprite('stg1', 'cg5/bg/mixroom', -480, -270, 0.88, 0.88, 0.9, 1, 'game', 'n', 3)
    luaSprite('stg2', 'cg5/bg/ploosh', 990, 180, 1, 1, 0.9, 1, 'game', 'n', 6)
    luaSprite('stg3', 'cg5/bg/recordroom', -450, -200, 0.9, 0.9, 0.9, 1, 'game', 'n', 9)
    setObjectOrder("gfGroup", getObjectOrder("stg3") - 1)
    setObjectOrder("boyfriendGroup", getObjectOrder("stg3") + 1)
    setObjectOrder("dadGroup", getObjectOrder("stg3") + 2)
    if buildTarget == 'android' then
        close()
    elseif buildTarget ~= 'android' and not assetMovement then
        setWindow("center", "center", "1920", "1080")
        close()
    end
end