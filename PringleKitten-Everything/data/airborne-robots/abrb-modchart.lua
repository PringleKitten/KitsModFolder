local special = 0
function onBeatHit()
    if curBeat == 280 then
        doTweenY('hud1', 'camOne', 220, 0.5, 'quadInOut')
        doTweenY('hud2', 'camTwo', 220, 0.5, 'quadInOut')
        special = 220
    elseif curBeat == 292 then
        doTweenY('hude1', 'camOne', 0, 0.1, 'quadInOut')
        doTweenY('hude2', 'camTwo', 0, 0.1, 'quadInOut')
        special = 0
    end
end
function onStepHit()
    if curStep == 128 then
        cameraShake('hud', 0.01, 9.59)
        cameraShake('camOne', 0.01, 9.59)
        cameraShake('camTwo', 0.01, 9.59)
    end
    if curStep > 127 and curStep < 255 then
        setPropertyFromGroup('playerStrums', 0, 'angle', getRandomInt(-180,180))
        setPropertyFromGroup('playerStrums', 1, 'angle', getRandomInt(-180,180))
        setPropertyFromGroup('playerStrums', 2, 'angle', getRandomInt(-180,180))
        setPropertyFromGroup('playerStrums', 3, 'angle', getRandomInt(-180,180))
    elseif curStep == 255 then
        setWindow("center", "center", 1280,720)
        setPropertyFromGroup('playerStrums', 0, 'angle', 0)
        setPropertyFromGroup('playerStrums', 1, 'angle', 0)
        setPropertyFromGroup('playerStrums', 2, 'angle', 0)
        setPropertyFromGroup('playerStrums', 3, 'angle', 0)
    end
end
function onUpdatePost()
    if thingyIDK then
        setProperty('camOne.angle', getProperty('camHUD.angle'))
        setProperty('camTwo.angle', getProperty('camHUD.angle'))
        setProperty('camThree.angle', getProperty('camHUD.angle'))
    end
    if getPropertyFromClass('openfl.Lib','application.window.fullscreen') then
            FS(false)
        end
    if not mechanicsAgain then
        close()
    end
    if curBeat < 280 and curBeat > 292 then
        setProperty('camOne.x', getProperty("camOther.x"))
        setProperty('camOne.y', getProperty("camOther.y"))
    end
    setProperty('camOne.zoom', getProperty('camHUD.zoom'))
    setProperty('camTwo.flashSprite.scaleX', 2)
    setProperty('camTwo.flashSprite.scaleY', 2)
    setProperty('camTwo.zoom', 0.5 * getProperty('camHUD.zoom'))
end
function onCountdownTick()
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
function onEvent(e,a,b)
    if e == '' then
        if a == 'lz' then
            setProperty('strumLineNotes.members[4].scale.x', 1.2)
            setProperty('strumLineNotes.members[4].scale.y', 1.2)
            cancelTween('noteScaleX4')
            cancelTween('noteScaleY4')
            doTweenX('noteScaleX4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'dz' then
            setProperty('strumLineNotes.members[5].scale.x', 1.2)
            setProperty('strumLineNotes.members[5].scale.y', 1.2)
            cancelTween('noteScaleX5')
            cancelTween('noteScaleY5')
            doTweenX('noteScaleX5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'uz' then
            setProperty('strumLineNotes.members[6].scale.x', 1.2)
            setProperty('strumLineNotes.members[6].scale.y', 1.2)
            cancelTween('noteScaleX6')
            cancelTween('noteScaleY6')
            doTweenX('noteScaleX6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'rz' then
            setProperty('strumLineNotes.members[7].scale.x', 1.2)
            setProperty('strumLineNotes.members[7].scale.y', 1.2)
            cancelTween('noteScaleX7')
            cancelTween('noteScaleY7')
            doTweenX('noteScaleX7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
        end
        if a == 'az' then
            setProperty('strumLineNotes.members[4].scale.x', 1.2)
            setProperty('strumLineNotes.members[4].scale.y', 1.2)
            setProperty('strumLineNotes.members[5].scale.x', 1.2)
            setProperty('strumLineNotes.members[5].scale.y', 1.2)
            setProperty('strumLineNotes.members[6].scale.x', 1.2)
            setProperty('strumLineNotes.members[6].scale.y', 1.2)
            setProperty('strumLineNotes.members[7].scale.x', 1.2)
            setProperty('strumLineNotes.members[7].scale.y', 1.2)
            cancelTween('noteScaleX4')
            cancelTween('noteScaleY4')
            cancelTween('noteScaleX5')
            cancelTween('noteScaleY5')
            cancelTween('noteScaleX6')
            cancelTween('noteScaleY6')
            cancelTween('noteScaleX7')
            cancelTween('noteScaleY7')
            doTweenX('noteScaleX4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY4', 'strumLineNotes.members[4].scale', 0.7, 0.2, 'sineOut')
            doTweenX('noteScaleX5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY5', 'strumLineNotes.members[5].scale', 0.7, 0.2, 'sineOut')
            doTweenX('noteScaleX6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY6', 'strumLineNotes.members[6].scale', 0.7, 0.2, 'sineOut')
            doTweenX('noteScaleX7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
            doTweenY('noteScaleY7', 'strumLineNotes.members[7].scale', 0.7, 0.2, 'sineOut')
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
                setWindow(vt[1], vt[2], vt[3], vt[4])
            end
        end
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
        -- Check for +/- offsets (e.g., "-50" or "+50")
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
    
    -- Calculate independent scales for width and height
    local scaleX = screen.sw / 1920
    local scaleY = screen.sh / 1080
    
    -- Apply X scale to horizontal values, Y scale to vertical values
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
        local screenW = 1280 -- Rendering Resolution. Never changes unless some other engine does so
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
function onCreatePost()
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