local windowOriginX = 0
local windowOriginY = 0
local newOriginX = 0
local newOriginY = 0
local newZoom = 1
local hellYeah = false
function onCreatePost()
    --buildTarget = 'android'
    if assetMovement then
        if buildTarget ~= 'android' then
            windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
            windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
            newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
            newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
            runHaxeCode([[
                import lime.app.Application;
                setVar('wnd', Application.current.window);
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
                wnd.borderless = true;
            ]])
            setWindow('center','center',1920,1082)
            os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/hidePS.ps1"')
        elseif buildTarget == 'android' then
            setObjectCamera('healthBar', 'two')
            setObjectCamera('healthBarBG', 'two')
            setObjectCamera('iconP1', 'two')
            setObjectCamera('iconP2', 'two')
            setObjectCamera('scoreTxt', 'two')
            setObjectCamera('timeBar', 'two')
            setObjectCamera('timeBarBG', 'two')
            setObjectCamera('timeTxt', 'two')
            setObjectCamera('botplayTxt', 'two')
            setObjectCamera('practiceTxt', 'two')
            for i = 0, getProperty('notes.length')-1 do
                setPropertyFromGroup('notes', i, 'camera', 'camTwo')
            end
            makeLuaSprite('mobileDesktop','me/mobile/desktop')
            setObjectCamera('mobileDesktop', 'hud')
            scaleObject('mobileDesktop', 2/3, 2/3)
            addLuaSprite('mobileDesktop',false)
            makeLuaSprite('screen')
            makeGraphic('screen', 1280, 720, '000000')
            setObjectCamera('screen','one')
            addLuaSprite('screen',false)
        end
    end
end
local cur = -1
function onUpdatePost()
    if assetMovement and buildTarget == 'android' then
        setProperty('camOne.x', getProperty("camOther.x"))
        setProperty('camOne.y', getProperty("camOther.y"))
        setProperty('camOne.zoom', getProperty('camOther.zoom'))
    end
end
function onCountdownTick()
    if assetMovement and buildTarget == 'android' then
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
        ]])
    end
end
function onStepHit()
    if assetMovement then
        if curStep == 252 then
            setWindow('center','center',1280,720)
        elseif curStep == 512 then
            tWin(1,-150,1.66,'sineOut')
        elseif curStep == 528 then
            tWin(1,300,1.66,'sineOut')
        elseif curStep == 544 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
            tWin(1,-300,1.66,'sineOut')
        elseif curStep == 548 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 552 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 556 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 560 then
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
            tWin(1,300,1.66,'sineOut')
        elseif curStep == 564 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 568 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 572 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 576 then
            tWin(1,-300,1.66,'sineOut')
        elseif curStep == 592 then
            tWin(1,300,1.66,'sineOut')
        elseif curStep == 544+64 then
            cur = cur+3
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
            tWin(1,-300,1.66,'sineOut')
        elseif curStep == 548+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 552+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 556+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 560+64 then
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
            tWin(1,300,1.66,'sineOut')
        elseif curStep == 564+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 568+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 572+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25)
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')-60,0.25)
        elseif curStep == 640 then
            tWin(1,-150,0.25,'expoOut')
        elseif curStep == 800 then
            cur = cur-3
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 804 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 808 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 812 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 816 then
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 820 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 824 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 828 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 800+64 then
            cur = cur+3
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 804+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 808+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 812+64 then
            cur = cur-1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')-110,0.25,'expoOut')
        elseif curStep == 816+64 then
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 820+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 824+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 828+64 then
            cur = cur+1
            noteTweenX('1',cur+4,getPropertyFromGroup('playerStrums',cur,'x')+110,0.25,'expoOut')
        elseif curStep == 1280 then
            setWindow('center','center',1920,1082)
            tWin(2, 1500, 1.5, 'sineIn')
        end
    end
end
local amountZoom = 0
local zoomBeat = false
function onEvent(n,v1,v2)
    if v2 == 'Add Camera Zoom Edit2' then
        local bv1 = tonumber(v1)
        if mechanicsAgain and buildTarget == 'android' then
            setProperty('camTwo.zoom',getProperty("camTwo.zoom")+bv1)
        else
            setProperty('camHUD.zoom',getProperty("camHUD.zoom")+bv1)
        end
        zoomBack()
    end
    if v2 == 'beatZoom2' then
        if not zoomBeat then
            local bv1 = tonumber(v1)
            zoomBeat = true
            amountZoom = bv1
        else
            zoomBeat = false
        end
    end
    v2 = tonumber(v2)
    local nv2 = 1
    if v2 == '' or v2 == nil or v2 == null then
        v2 = 1
    end
    if v2 == 2 then
        hellYeah = true
        nv2 = 4
    end
    if assetMovement then
        if v1 == 'bgr' then
            setWindow('center','center',1280*v2,720*v2)
        end
        if v1 == 'downYOU' then
            noteTweenY('1a',cur+4,getPropertyFromGroup('playerStrums',cur,'y')+60,0.12)
        end
        if v1 == 'xy' then
            tWin(1, -250, 1.69/nv2, 'expoOut')
            tWin(2, -100, 0.83/nv2, 'expoOut')
        elseif v1 == 'xy2' then
            tWin(1, 250, 1.69/nv2, 'expoOut')
            tWin(2, -100, 0.83/nv2, 'expoOut')
        elseif v1 == 'y' then
            tWin(2, 100, 0.83/nv2, 'expoOut')
        elseif v1 == 'y2' then
            tWin(2, -100, 0.83/nv2, 'expoOut')
        end
    end
end
local played = false
function opponentNoteHit()
    played = true
end
function onSectionHit()
    if played then
        if mechanicsAgain and buildTarget == 'android' then
            setProperty('camTwo.zoom',getProperty("camTwo.zoom")+0.03)
        else
            setProperty('camHUD.zoom',getProperty("camHUD.zoom")+0.03)
        end
        zoomBack()
    end
end
function zoomBack()
    if mechanicsAgain and buildTarget == 'android' then
        doTweenZoom('back', 'two', getProperty('camOther.zoom')/newZoom, 0.2, 'sineOut')
    else
        doTweenZoom('back', 'camHUD', 1, 0.2, 'sineOut')
    end
end
function onBeatHit()
    if zoomBeat then
        if mechanicsAgain and buildTarget == 'android' then
            setProperty('camTwo.zoom',getProperty("camTwo.zoom")+amountZoom)
        else
            setProperty('camHUD.zoom',getProperty("camHUD.zoom")+(amountZoom))
        end
        zoomBack()
    end
end
function onCountdownStarted()
    if assetMovement and buildTarget == 'android' then
        runHaxeCode([[
            comboGroup.cameras = [camTwo];
            for (note in game.notes) {
                note.camera = game.camTwo;
            }
            for (note in game.unspawnNotes) {
                note.camera = game.camTwo;
            }
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camTwo];
            }
            grpNoteSplashes.cameras = [camTwo];
        ]])
    end
end
function onDestroy()
    if assetMovement then
        if buildTarget ~= 'android' then
            setWindow('center', 'center', 1280, 720)
            noFS(true)
            os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/showPS.ps1"') 
        end
    end
end
--All this makes it possible to be easier to code!!--
function tWin(a, v, d, e)
    -- Get the screen resolution via Haxe
    local screen = runHaxeCode([[
        import lime.app.Application;
        var display = Application.current.window.display;
        return {sw: display.bounds.width, sh: display.bounds.height};
    ]])
    
    -- Calculate the scale factor based on your 1080p design target
    local scaleX = screen.sw / 1920
    local scaleY = screen.sh / 1080
    
    if buildTarget ~= 'android' then
        if a == 1 then
            cancelTween('windowTweenX')
            local scaledV = v * scaleX -- Scale the horizontal movement
            newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
            doTweenX('windowTweenX', 'wnd', newOriginX + scaledV, d, e)
        elseif a == 2 then
            cancelTween('windowTweenY')
            local scaledV = v * scaleY -- Scale the vertical movement
            newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
            doTweenY('windowTweenY', 'wnd', newOriginY + scaledV, d, e)
        end
    else
        -- Android/Mobile scaling logic
        if a == 1 then
            cancelTween('mobileTweenX')
            cancelTween('mobileTweenX2')
            local scaledV = v * (1280 / 1920) -- Mobile usually targets 720p (1280 width)
            newOriginX = getProperty('camOther.x')
            doTweenX('mobileTweenX', 'camOther', newOriginX + (scaledV * newZoom), d, e)
            doTweenX('mobileTweenX2', 'camTwo', newOriginX + (scaledV * newZoom), d, e)
        elseif a == 2 then
            cancelTween('mobileTweenY')
            cancelTween('mobileTweenY2')
            local scaledV = v * (720 / 1080) -- Mobile usually targets 720p height
            newOriginY = getProperty('camOther.y')
            doTweenY('mobileTweenY', 'camOther', newOriginY + (scaledV * newZoom), d, e)
            doTweenY('mobileTweenY2', 'camTwo', newOriginY + (scaledV * newZoom), d, e)
        end
    end
end
function onUpdate()
    if assetMovement then
        if getPropertyFromClass('openfl.Lib','application.window.fullscreen') then
            noFS()
        end
    end
end
function noFS(a)
    if assetMovement then
        if buildTarget ~= 'android' then
            if not a then
                runHaxeCode([[
                    import lime.app.Application;
                    var wnd = Application.current.window;
                    wnd.resizable = false;
                    wnd.fullscreen = false;
                    wnd.borderless = true;
                ]])
            else
                runHaxeCode([[
                    import lime.app.Application;
                    var wnd = Application.current.window;
                    wnd.resizable = true;
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
function resizeW()
    if buildTarget ~= 'android' then
        runHaxeCode([[
            import openfl.Lib;
	        import flixel.FlxG;
	    	FlxG.game.setFilters([]);
	    	var stage = Lib.current.stage;
	    	var resolutionX = 0;
	    	var resolutionY = 0;
	    	if (stage.window != null)
	    	{
	    		var display = stage.window.display;
	    		if (display != null)
	    		{
	    			resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
	    			resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
	    		}
	    	}
	    	if(resolutionX <= 0){
	    		resolutionX = stage.stageWidth;
	    		resolutionY = stage.stageHeight;
	    	}
	        Lib.application.window.x = (resolutionX - Lib.application.window.width)/2;
	        Lib.application.window.y = (resolutionY - Lib.application.window.height)/2;
	    ]])
    else
        local screenWidth = getPropertyFromClass("openfl.Lib", "application.window.width") or 1280
        local screenHeight = getPropertyFromClass("openfl.Lib", "application.window.height") or 720
        local camWidth = getProperty("camOther.width") or 1280
        local camHeight = getProperty("camOther.height") or 720

        local centerX = (screenWidth - camWidth) / 2
        local centerY = (screenHeight - camHeight) / 2

        setProperty("camOther.x", centerX)
        setProperty("camOther.y", centerY)
        setProperty("camTwo.x", centerX)
        setProperty("camTwo.y", centerY)
    end
end