local thingyIDK = false
local all = false
local thingyCount = 0
local special = 0
local dpsx = {}
local dpsy = {}
local times = {1, 25, 49, 50, 72, 84, 93, 94, 95, 118, 143, 144, 165, 178, 190, 254, 278, 296, 297, 299, 301, 303, 343, 353, 363, 373, 377, 381, 382, 384, 394, 404, 414, 415, 416, 417, 418, 419, 420, 421, 422, 433, 443, 453, 463, 473, 483}
function onUpdatePost()
    if thingyIDK then
        setProperty('camOne.angle', getProperty('camHUD.angle'))
        setProperty('camTwo.angle', getProperty('camHUD.angle'))
        setProperty('camThree.angle', getProperty('camHUD.angle'))
    end
    if curBeat < 280 and curBeat > 292 then
        setProperty('camOne.x', getProperty("camOther.x"))
        setProperty('camOne.y', getProperty("camOther.y"))
    end
    setProperty('camOne.zoom', getProperty('camHUD.zoom'))
    setProperty('camTwo.flashSprite.scaleX', 2)
    setProperty('camTwo.flashSprite.scaleY', 2)
    setProperty('camTwo.zoom', 0.5 * getProperty('camHUD.zoom'))
    if getPropertyFromClass('openfl.Lib','application.window.fullscreen') then
        FS(false)
    end
end
function onStepHit()
    if curStep > 127 and curStep < 255 then
        if curStep == 128 then
            cameraShake('hud', 0.01, 9.59)
            cameraShake('camOne', 0.01, 9.59)
            cameraShake('camTwo', 0.01, 9.59)
        end
        for i = 0,3 do
            setPropertyFromGroup('playerStrums', i, 'angle', getRandomInt(-180,180))
            setPropertyFromGroup('playerStrums', i, 'angle', getRandomInt(-180,180))
        end
        setProperty('camHUD.angle', getRandomInt(-3,3))
    elseif curStep == 255 then
        setProperty('camHUD.angle', 0)
        setWindow("center", "center", 1280,720)
        for i = 0,3 do
            setPropertyFromGroup('playerStrums', i, 'angle', 0)
        end
    elseif curStep == 1423 then
        for i = 0,3 do
            cancelTween('ttmBack'..(i+4))
            setPropertyFromGroup('playerStrums', i, 'y', 50)
        end
    elseif curStep % 2 == 0 and ((curStep >= 1168 and curStep < 1280) or (curStep >= 1296 and curStep < 1408)) then
        objFlash(false)
    elseif curStep % 2 == 0 and ((curStep >= 1280 and curStep < 1296) or (curStep >= 1408 and curStep < 1424) or (curStep >= 1664 and curStep < 1680) or (curStep >= 1792 and curStep < 1808) or (curStep >= 1920 and curStep < 1936)) then
        objFlash(true)
        if curStep == 1930 then
            callScript('scripts/videoSprite', 'makeVideoSprite', {'abrbe2', 'abrbe2', 'hud', 1})
            setProperty('videoCutscene.alpha', 0)
            doTweenAlpha('cutsceneFade', 'videoCutscene', 0.5, 3, 'linear')
        end
    elseif curStep == 1522 then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'abrbe1', 'abrbe1', 'hud', 1})
        setProperty('videoCutscene.alpha', 0)
        doTweenAlpha('cutsceneFade', 'videoCutscene', 0.5, 3, 'linear')
    end
end
function onEvent(e,a,b)
    if e == '' then
        if a == 'thingy' then
            thingyCount = thingyCount+1
            for _, time in ipairs(times) do
                if thingyCount == time or (b ~= 'b' and thingyCount >= 183 and thingyCount <= 236) then
                    objFlash(true)
                    all = true
                end
            end
            if not all then
                objFlash(false)
            end
            all = false
            debugPrint(thingyCount)
            if b ~= 'jf' then
                for i = 0,3 do
                    if b ~= 'ne' or b ~= 'bca' or b ~= 'bcl' or b ~= 'bcr' then
                        setPropertyFromGroup('playerStrums', i, 'x', dpsx[i] + getRandomInt(-10,10))
                        setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') + getRandomInt(-10,10))
                    end
                    if b ~= 'n' then
                        local cancelIDs = {'ttmBack', 'ttm'..i, 'ttmb'..i, 'ttma'..i, 'ttmy'..i, 'ttmxc'..i, 'ttmyc'..i}
                        for _, id in ipairs(cancelIDs) do
                            cancelTween(id)
                        end

                        if b == 'd' then
                            noteTweenY('ttma'..i,i+4,getPropertyFromGroup('playerStrums', i, 'y')+getRandomInt(100,165),0.1,'sineOut')
                        elseif b == 'b' then
                            noteTweenY('ttmb'..i,i+4,50,0.1,'expoOut')
                        elseif b ~= 'ne' then
                            noteTweenY('ttm'..i,i+4,getPropertyFromGroup('playerStrums', i, 'y')+getRandomInt(100,165),0.1,'sineOut')
                        elseif b == 'ne' then
                            setPropertyFromGroup('playerStrums', i, 'x', dpsx[i]) 
                            setPropertyFromGroup('playerStrums', i, 'y', dpsy[i])
                        elseif b == 'bca' then
                            setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + getRandomInt(-20,20))
                            setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') + getRandomInt(-20,20))
                            doTweenX('ttmx'..i, i+4, dpsx[i], 0.1, 'sineOut')
                            doTweenY('ttmy'..i, i+4, dpsy[i], 0.1, 'sineOut')
                        end
                        setPropertyFromGroup('playerStrums', i, 'x', dpsx[i]) 
                    end
                end
                local move = getRandomInt(-20,20)
                for i = 0,1 do
                    if b == 'bcl' then
                        setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + move)
                        setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') + move)
                        doTweenX('ttmxc'..i, i+4, dpsx[i], 0.5, 'sineOut')
                        doTweenY('ttmyc'..i, i+4, dpsy[i], 0.5, 'sineOut')
                    end
                end
                for i = 2,3 do
                    if b == 'bcr' then
                        setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - move)
                        setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') - move)
                        doTweenX('ttmxc'..i, i+4, dpsx[i], 0.5, 'sineOut')
                        doTweenY('ttmyc'..i, i+4, dpsy[i], 0.5, 'sineOut')
                    end
                end
            end
        end
        if a == 'lz' then
            cancelTween('noteScaleX4')
            cancelTween('noteScaleY4')
            setProperty('strumLineNotes.members[4].scale.x', 1.2)
            setProperty('strumLineNotes.members[4].scale.y', 1.2)
            doTweenX('noteScaleX4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'dz' then
            cancelTween('noteScaleX5')
            cancelTween('noteScaleY5')
            setProperty('strumLineNotes.members[5].scale.x', 1.2)
            setProperty('strumLineNotes.members[5].scale.y', 1.2)
            doTweenX('noteScaleX5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'uz' then
            cancelTween('noteScaleX6')
            cancelTween('noteScaleY6')
            setProperty('strumLineNotes.members[6].scale.x', 1.2)
            setProperty('strumLineNotes.members[6].scale.y', 1.2)
            doTweenX('noteScaleX6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'rz' then
            cancelTween('noteScaleX7')
            cancelTween('noteScaleY7')
            setProperty('strumLineNotes.members[7].scale.x', 1.2)
            setProperty('strumLineNotes.members[7].scale.y', 1.2)
            doTweenX('noteScaleX7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'az' then
            for i = 4,7 do
                cancelTween('noteScaleX'..i)
                cancelTween('noteScaleY'..i)
                setProperty('strumLineNotes.members['..i..'].scale.x', 1.2)
                setProperty('strumLineNotes.members['..i..'].scale.y', 1.2)
                doTweenX('noteScaleX'..i, 'strumLineNotes.members['..i..'].scale', 0.7, 0.2, 'sineOut')
                doTweenY('noteScaleY'..i, 'strumLineNotes.members['..i..'].scale', 0.7, 0.2, 'sineOut')
            end
        end
        if a == 'whatever' then
            thingyIDK = true
        end
        if a == 'tr' then
            setProperty('camHUD.angle', 10)
            doTweenAngle('tt', 'camHUD', 0, 0.1, 'sineOut')
            for i = 4,7 do
                setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x')+100)
                noteTweenX('ttm'..i, i, getPropertyFromGroup('strumLineNotes', i, 'x') - 100, 0.1, 'sineOut')
            end
        end
        if a == 'tl' then
            setProperty('camHUD.angle', -10)
            doTweenAngle('tt', 'camHUD', 0, 0.1, 'sineOut')
            for i = 4,7 do
                setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x')-100)
                noteTweenX('ttm'..i, i, getPropertyFromGroup('strumLineNotes', i, 'x') + 100, 0.1, 'sineOut')
            end
        end
        if a == 'tu' then
            setProperty('camHUD.angle', 10)
            doTweenAngle('tt', 'camHUD', 0, 0.1, 'sineOut')
            for i = 4,7 do
                setPropertyFromGroup('playerStrums', i-4, 'y', -50)
                noteTweenY('ttm'..i,i,50,0.1,'sineOut')
            end
        end
        if a == 'td' then
            setProperty('camHUD.angle', -10)
            doTweenAngle('tt', 'camHUD', 0, 0.1, 'sineOut')
            for i = 4,7 do
                setPropertyFromGroup('playerStrums', i-4, 'y', 100)
                noteTweenY('ttm'..i,i,50,0.1,'sineOut')
            end
        end
        if a == 'sv' then
            local vt = {}
            for value in string.gmatch(b, '([^,]+)') do
                local number = loadstring("return " .. value)()
                table.insert(vt, number)
            end
            if vt[1] and vt[2] then
                setProperty('camTwo.y', -vt[1]+special)
                doTweenY('sv', 'camTwo', getProperty('camTwo.y')+vt[1] , vt[2], 'linear')
            end
        end
        if a == 'window' then
            local vt = {}
            for value in string.gmatch(b, '([^,]+)') do
                local number = loadstring("return " .. value)()
                table.insert(vt, number)
            end
            if vt[1] and vt[2] and vt[3] and vt[4] then
                for i = 0,3 do
                    if vt[1] ~= 'center' then
                        setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') - vt[1])
                    end
                    if vt[2] ~= 'center' then
                        setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') - vt[2])
                    end
                end
                setWindow(vt[1], vt[2], vt[3], vt[4])
            end
        end
    end
end
function onBeatHit()
    if curBeat == 280 then
        doTweenY('hud1', 'camOne', 220, 0.5, 'quadInOut')
        doTweenY('hud2', 'camTwo', 220, 0.5, 'quadInOut')
        special = 220
    elseif curBeat == 292 then
        doTweenY('hude1', 'camOne', 0, 0.1, 'quadInOut')
        doTweenY('hude2', 'camTwo', 0, 0.1, 'quadInOut')
        special = 0
    elseif (curBeat >= 292 and curBeat < 320) or (curBeat >= 324 and curBeat < 352) then
        for i = 0,3 do
            noteTweenY('ttms'..i,i+4,20,0.1,'sineOut')
            setProperty('strumLineNotes.members['..(i+4)..'].scale.x', 0.3)
            setProperty('strumLineNotes.members['..(i+4)..'].scale.y', 1.1)
            doTweenY('scaleBackY'..i, 'strumLineNotes.members['..(i+4)..'].scale', 0.7, 0.2, 'sineOut')
            doTweenX('scaleBackX'..i, 'strumLineNotes.members['..(i+4)..'].scale', 0.7, 0.2, 'sineOut')
        end
    end
end
function onTweenCompleted(t)
    if t == 'ttm0' then
        for i = 4,7 do
            noteTweenY('ttmBack'..i,i,50,0.4,'sineOut')
        end
    end
    if t == 'ttms0' then
        for i = 0,3 do
            noteTweenY('ttmsBack'..i,i+4,50,0.2,'sineIn')
        end
    end
end
function onPause()
    if getProperty('videoCutscene.alpha') > 0 then
        callMethod('videoCutscene.pause')
    end
end
function onResume()
    if getProperty('videoCutscene.alpha') > 0 then
        callMethod('videoCutscene.resume')
    end
end
function objFlash(allGradients)
    local colorChoices = {0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF}
    local gradientChoices = {'gradientBL', 'gradientTL', 'gradientTR', 'gradientBR'}
    if allGradients then
        for _, gradient in ipairs(gradientChoices) do
            setProperty(gradient..'.alpha', 1)
        end
    else
        setProperty(gradientChoices[getRandomInt(1, #gradientChoices)]..'.alpha', 0.5)
    end
    setProperty('gradientBL.color', colorChoices[getRandomInt(1, #colorChoices)])
    setProperty('gradientTL.color', colorChoices[getRandomInt(1, #colorChoices)])
    setProperty('gradientTR.color', colorChoices[getRandomInt(1, #colorChoices)])
    setProperty('gradientBR.color', colorChoices[getRandomInt(1, #colorChoices)])
    doTweenAlpha('flashBL', 'gradientBL', 0, 0.4, 'sineOut')
    doTweenAlpha('flashTL', 'gradientTL', 0, 0.4, 'sineOut')
    doTweenAlpha('flashTR', 'gradientTR', 0, 0.4, 'sineOut')
    doTweenAlpha('flashBR', 'gradientBR', 0, 0.4, 'sineOut')
end
function FS(a)
    if assetMovement then
        if buildTarget ~= 'android' then
            if a then
                runHaxeCode([[
                    import lime.app.Application;
                    var wnd = Application.current.window;
                    wnd.resizable = true;
                    wnd.fullscreen = true;
                    wnd.borderless = false;
                ]])
            else
                runHaxeCode([[
                    import lime.app.Application;
                    var wnd = Application.current.window;
                    wnd.resizable = false;
                    wnd.fullscreen = false;
                    wnd.borderless = false;
                ]])
            end
        end
    end
end
function parseValue(param, current, screenSize, windowSize)
    if type(param) == "string" then
        if param == "center" and screenSize and windowSize then
            return (screenSize - windowSize) / 2
        end
        local sign, num = param:match("^([+-])(%d+)$")
        if sign and num then
            local offset = tonumber(num)
            
            local screen = runHaxeCode([[import lime.app.Application; return Application.current.window.display.bounds.height;]])
            offset = offset * (screen / 1080)
            
            return sign == "+" and current + offset or current - offset
        end
        local n = tonumber(param)
        if n then return n end
    elseif type(param) == "number" then
        return param
    end
    return current
end
function scaleWindowParams(x, y, w, h)
    local screen = runHaxeCode([[
        import lime.app.Application;
        var display = Application.current.window.display;
        return {sw: display.bounds.width, sh: display.bounds.height};
    ]])
    local scaleX = screen.sw / 1920
    local scaleY = screen.sh / 1080
    local finalX = (type(x) == "number") and (x * scaleX) or x
    local finalY = (type(y) == "number") and (y * scaleY) or y
    local finalW = (type(w) == "number") and (w * scaleX) or w
    local finalH = (type(h) == "number") and (h * scaleY) or h
    return finalX, finalY, finalW, finalH
end
function setWindow(x, y, w, h)
    x, y, w, h = scaleWindowParams(x, y, w, h)
    if buildTarget ~= 'android' then
        local screen = runHaxeCode([[
            import lime.app.Application;
            var d = Application.current.window.display.bounds;
            return { sw: d.width, sh: d.height };
        ]])
        local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
        local newW, newH = parseValue(w, current.width), parseValue(h, current.height)
        local newX, newY = parseValue(x, current.x, screen.sw, newW), parseValue(y, current.y, screen.sh, newH)
        runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], newX, newY, newW, newH))
        lockedPosition = { x = newX, y = newY, width = newW, height = newH }
        newSX = newW
        newSY = newH
    else
        cancelTween('back')
        local screenW = 1280
        local screenH = 720
        if w == 1920 and h == 1082 then
            w = 1920
            h = 1080
        end
        if type(w) ~= "string" then w = w * (screenW/1920) end
        if type(h) ~= "string" then h = h * (screenH/1080) end
        if type(x) ~= "string" then x = x * (screenW/1920) end
        if type(y) ~= "string" then y = y * (screenH/1080) end
        local camW = getProperty("camOther.width")
        local camH = getProperty("camOther.height")
        local newCamX = parseValue(x, getProperty("camOther.x"), screenW, camW)
        local newCamY = parseValue(y, getProperty("camOther.y"), screenH, camH)
        setProperty("camOther.x", newCamX)
        setProperty("camOther.y", newCamY)
        setProperty("camTwo.x", newCamX)
        setProperty("camTwo.y", newCamY)
        local zoomX = w / camW
        local zoomY = h / camH
        newSX = w
        newSY = h
        newZoom = (zoomX + zoomY) / 2
        if newZoom <= 0.09 then
            newZoom = 1
        end
        setProperty("camOther.zoom", newZoom)
        setProperty('camTwo'..'.flashSprite.scaleX', newZoom)
        setProperty('camTwo'..'.flashSprite.scaleY', newZoom)
        setProperty("camTwo.zoom", newZoom/newZoom)
        lockedPosition = {
            x = newCamX,
            y = newCamY,
            width = camW * newZoom,
            height = camH * newZoom
        }
    end
end
function onCountdownStarted()
    runHaxeCode([[
        comboGroup.cameras = [camOne];
        for (note in game.notes) {
            note.camera = game.camTwo;
        }
        for (note in game.unspawnNotes) {
            note.camera = game.camTwo;
        }
        for (i in 0...4) {
            playerStrums.members[i].cameras = [camOne];
        }
        grpNoteSplashes.cameras = [camOne];
    ]])
end
function onCountdownTick(counter)
    if counter == 0 then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'abrbe1', 'abrbe1', 'hud', 1})
    elseif counter == 2 then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'abrbe2', 'abrbe2', 'hud', 1})
    end
    for i = 0,3 do
        dpsx[i] = getPropertyFromGroup('playerStrums', i, 'x')
        dpsy[i] = getPropertyFromGroup('playerStrums', i, 'y')
    end
    runHaxeCode([[
        for (spr in game.members)
        {
            if (spr != null && Std.isOfType(spr, FlxSprite) && spr.graphic != null)
            {
                if (spr.graphic.key.indexOf('ready') != -1 || spr.graphic.key.indexOf('set') != -1 || spr.graphic.key.indexOf('go') != -1)
                {
                    spr.cameras = [camOne];
                }
            }
        }
        import lime.app.Application;
        var wnd = Application.current.window;
        wnd.resizable = false;
        wnd.fullscreen = false;
    ]])
    setWindow("center", "center", 1920, 1082)
end
function onSongStart()
    setProperty('videoCutscene.alpha', 0)
end
function onCreatePost()
    makeLuaSprite('gradientBL', 'me/popup/flashObj', 0, -220)
    makeLuaSprite('gradientTL', 'me/popup/flashObj', 0, 0)
    makeLuaSprite('gradientTR', 'me/popup/flashObj', 330, 0)
    makeLuaSprite('gradientBR', 'me/popup/flashObj', 330, -220)
    setProperty('gradientTL.angle', 90)
    setProperty('gradientTR.angle', 180)
    setProperty('gradientBR.angle', 270)
    setObjectCamera('gradientBL', 'camOther')
    scaleObject('gradientBL', 3.8, 3.8)
    addLuaSprite('gradientBL', true)
    setObjectCamera('gradientTL', 'camOther')
    scaleObject('gradientTL', 3.8, 3.8)
    addLuaSprite('gradientTL', true)
    setObjectCamera('gradientTR', 'camOther')
    scaleObject('gradientTR', 3.8, 3.8)
    addLuaSprite('gradientTR', true)
    setObjectCamera('gradientBR', 'camOther')
    scaleObject('gradientBR', 3.8, 3.8)
    addLuaSprite('gradientBR', true)
    setProperty('gradientBL.alpha', 0)
    setProperty('gradientTL.alpha', 0)
    setProperty('gradientTR.alpha', 0)
    setProperty('gradientBR.alpha', 0)
    if buildTarget ~= 'android' then
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/hidePS.ps1"') 
    end
end
function onDestroy()
    if buildTarget ~= 'android' then
        setWindow('center', 'center', 1280, 720)
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/showPS.ps1"') 
    end
end
if not assetMovement then
    close()
end