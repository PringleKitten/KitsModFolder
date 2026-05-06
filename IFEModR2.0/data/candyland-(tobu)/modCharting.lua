local nuh = 0
local dSM = 1
local a = 0
local sSs = 2.6

function onBeatHit()
    if mechanicsAgain then
        if curBeat >= 32 and curBeat <= 62 then
            goingG = true
            doTweenY('cOy', 'camOne', -200*dSM, 0.35, 'sineIn')
        elseif curBeat == 63 then
            doTweenY('cOyE', 'camOne', 0, 0.35, 'sineIn')
            goingG = false
        elseif curBeat >= 161 and curBeat < 186 then
            goingG = true
            doTweenY('cOy2', 'camOne', 200*dSM, 0.35, 'expoIn')
        elseif curBeat == 186 then
            doTweenY('cOyE', 'camOne', 0, 0.1, 'sineOut')
        elseif curBeat >= 188 and curBeat <= 190 then
            doTweenY('cOy', 'camOne', -200*dSM, 0.35, 'sineIn')
        elseif curBeat == 191 then
            doTweenY('cOyE', 'camOne', 0, 0.35, 'sineIn')
            goingG = false
        elseif curBeat >= 320 and curBeat < 348 then
            goingG = true
            doTweenY('cOy2', 'camOne', 200*dSM, 0.35, 'expoIn')
        elseif curBeat >= 353 and curBeat < 380 then
            goingG = true
            doTweenY('cOy2', 'camOne', 200*dSM, 0.35, 'expoIn')
        elseif curBeat >= 385 and curBeat < 408 then
            goingG = true
            doTweenY('cOy2', 'camOne', 200*dSM, 0.35, 'expoIn')
        elseif curBeat == 408 then
            doTweenY('cOyE', 'camOne', 0, 0.1, 'sineOut')
        end
    end
    if curBeat == 127 then
        if buildTarget ~= 'android' then
            setProperty('stg1.alpha', 0)
            setProperty('stg2.alpha', 0)
            setProperty('stg3.alpha', 0)
            setProperty('boyfriend.alpha', 0)
            setProperty('gf.alpha', 0)
            ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00080000)
            ffi.C.SetLayeredWindowAttributes(ffi.C.GetActiveWindow(), 0x00000000, 0, 0x00000001)
        end
    elseif curBeat == 156 then
        setObjectCamera('healthBar', 'one')
        setObjectCamera('healthBarBG', 'one')
        setObjectCamera('iconP1', 'one')
        setObjectCamera('iconP2', 'one')
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camTwo];
            }
        ]])
        setProperty('camOne.x', getProperty('camOne.x')-100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retO', 'one', 0.5, 0.3, 'sineOut')
        setProperty('camTwo.x', getProperty('camTwo.x')+100*dSM)
        setProperty('camTwo.zoom', 0.8)
        doTweenZoom('retT', 'two', 1, 0.3, 'sineOut')
    elseif curBeat >= 157 and curBeat <= 159 then
        setProperty('camOne.x', getProperty('camOne.x')-100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retO', 'one', 0.5, 0.3, 'sineOut')
        setProperty('camTwo.x', getProperty('camTwo.x')+100*dSM)
        setProperty('camTwo.zoom', 0.8)
        doTweenZoom('retT', 'two', 1, 0.3, 'sineOut')
    elseif curBeat == 160 then
        doTweenX('retXO','camOne', 0, 0.45, 'expoIn')
        doTweenX('retXT', 'camTwo', 0, 0.45, 'expoIn')
	elseif curBeat == 192 then
        if buildTarget ~= 'android' then
            ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
            setProperty('stg1.alpha', 1)
            setProperty('stg2.alpha', 1)
            setProperty('stg3.alpha', 1)
            setProperty('boyfriend.alpha', 1)
            setProperty('gf.alpha', 1)
        end
    elseif curBeat == 348 then
        goingG = false
        goBack()
        doTweenY('cOyE', 'camOne', 0, 0.1, 'sineOut')
        setObjectCamera('healthBar', 'two')
        setObjectCamera('healthBarBG', 'two')
        setObjectCamera('iconP1', 'two')
        setObjectCamera('iconP2', 'two')
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camOne];
            }
        ]])
        setProperty('camTwo.x', getProperty('camTwo.x')-100*dSM)
        setProperty('camTwo.zoom', 0.8)
        doTweenZoom('retO', 'two', 1, 0.3, 'sineOut')
        setProperty('camOne.x', getProperty('camOne.x')+100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retT', 'one', 0.5, 0.3, 'sineOut')
    elseif curBeat >= 349 and curBeat <= 351 then
        setProperty('camTwo.x', getProperty('camTwo.x')-100*dSM)
        setProperty('camTwo.zoom', 0.8)
        doTweenZoom('retO', 'two', 1, 0.3, 'sineOut')
        setProperty('camOne.x', getProperty('camOne.x')+100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retT', 'one', 0.5, 0.3, 'sineOut')
    elseif curBeat == 352 then
        doTweenX('retXO','camOne', 0, 0.45, 'expoIn')
        doTweenX('retXT', 'camTwo', 0, 0.45, 'expoIn')
    elseif curBeat == 380 then
        goingG = false
        goBack()
        doTweenY('cOyE', 'camOne', 0, 0.1, 'sineOut')
        setObjectCamera('healthBar', 'two')
        setObjectCamera('healthBarBG', 'two')
        setObjectCamera('iconP1', 'two')
        setObjectCamera('iconP2', 'two')
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camOne];
            }
        ]])
        setProperty('camTwo.x', getProperty('camTwo.x')-100*dSM)
        setProperty('camTwo.zoom', 1.2)
        doTweenZoom('retO', 'two', 1, 0.3, 'sineOut')
        setProperty('camOne.x', getProperty('camOne.x')+100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retT', 'one', 0.5, 0.3, 'sineOut')
    elseif curBeat >= 381 and curBeat <= 383 then
        setProperty('camTwo.x', getProperty('camTwo.x')-100*dSM)
        setProperty('camTwo.zoom', 1.2)
        doTweenZoom('retO', 'two', 1, 0.3, 'sineOut')
        setProperty('camOne.x', getProperty('camOne.x')+100*dSM)
        setProperty('camOne.zoom', 0.6)
        doTweenZoom('retT', 'one', 0.5, 0.3, 'sineOut')
    elseif curBeat == 384 then
        doTweenX('retXO','camOne', 0, 0.45, 'expoIn')
        doTweenX('retXT', 'camTwo', 0, 0.45, 'expoIn')
    end
end

if mechanicsAgain then
    function onStepHit()
        if curStep == 56 or curStep == 58 or curStep == 60 then
            goingG = true
            setProperty('camOne.y', -660*dSM)
            doTweenY('sv', 'camOne', (-660+720)*dSM, 0.225, 'linear')
        elseif curStep == 62 then
            goingG = false
            setProperty('camOne.y', -680*dSM)
            doTweenY('svA', 'camOne', 0, 0.225, 'sineOut')
        elseif curStep == 120 or curStep == 122 or curStep == 124 then
            goingG = true
            setProperty('camOne.y', -660*dSM)
            doTweenY('sv', 'camOne', (-660+720)*dSM, 0.225, 'linear')
        elseif curStep == 126 then
            goingG = false
            setProperty('camOne.y', -680*dSM)
            doTweenY('svA', 'camOne', 0, 0.225, 'expoOut')
        elseif curStep == 832 or curStep == 848 or curStep == 864 or curStep == 880 then
            goingG = true
            setProperty('camOne.y', -270*dSM)
            doTweenY('sv', 'camOne', 320*dSM, 0.48, 'linear')
        elseif curStep == 838 or curStep == 854 or curStep == 870 or curStep == 886 then
            setProperty('camOne.y', -200*dSM)
            doTweenY('sv', 'camOne', 630*dSM, 0.72, 'linear')
        elseif (curStep >= 896 and curStep <= 903) or (curStep >= 912 and curStep <= 919) or (curStep >= 922 and curStep <= 923) or (curStep >= 928 and curStep <= 935) or (curStep >= 944 and curStep <= 951) or (curStep >= 960 and curStep <= 967) or (curStep >= 976 and curStep <= 983) or (curStep >= 986 and curStep <= 987) or (curStep >= 992 and curStep <= 999) then
            setProperty('camOne.y', -100*dSM)
            doTweenY('sv', 'camOne', 44*dSM, 0.12, 'linear')
        elseif curStep == 910 or curStep == 920 or curStep == 924 or curStep == 926 or curStep == 942 or curStep == 952 or curStep == 954 or curStep == 956 or curStep == 958 or curStep == 974 or curStep == 984 or curStep == 988 or curStep == 990 then
            setProperty('camOne.y', -200*dSM)
            doTweenY('sv', 'camOne', 87*dSM, 0.24, 'linear')
        elseif curStep == 1008 then
            goingG = false
            goBack()
            if not downscroll then
                noteTweenY('dScrollnNote5',4,560,1.87,'linear')
                noteTweenY('dScrollnNote6',5,560,1.87,'linear')
                noteTweenY('dScrollnNote7',6,560,1.87,'linear')
                noteTweenY('dScrollnNote8',7,560,1.87,'linear')
                doTweenY('dScroll1','healthBar',80, 1.87, 'linear')
                doTweenY('dScroll2','healthBarBG',80, 1.87, 'linear')
                doTweenY('dScroll3','iconP1',10, 1.87, 'linear')
                doTweenY('dScroll4','iconP2',10, 1.87, 'linear')
                doTweenY('dScroll5','scoreTxt',120, 1.87, 'linear')
                doTweenY('dScroll6','timeTxt', 668, 1.87, 'linear')
                doTweenY('dScroll7','timeBar', 676, 1.87, 'linear')
                doTweenY('dScroll8','timeBarBG', 684, 1.87, 'linear')
                doTweenY('dScroll9','botplayTxt', 610,1.87,'linear')
                doTweenY('dScroll10','practiceTxt', 610,1.87,'linear')
            else
                noteTweenY('dScrollnNote5',4,50,1.87,'linear')
                noteTweenY('dScrollnNote6',5,50,1.87,'linear')
                noteTweenY('dScrollnNote7',6,50,1.87,'linear')
                noteTweenY('dScrollnNote8',7,50,1.87,'linear')
                doTweenY('dScroll1','healthBar',640,1.87,'linear')
                doTweenY('dScroll2','healthBarBG',840,1.87,'linear')
                doTweenY('dScroll3','iconP1',570,1.87,'linear')
                doTweenY('dScroll4','iconP2',570,1.87,'linear')
                doTweenY('dScroll5','scoreTxt',680,1.87,'linear')
                doTweenY('dScroll6','timeTxt',19,1.87,'linear')
                doTweenY('dScroll7','timeBar',27,1.87,'linear')
                doTweenY('dScroll8','timeBarBG',23,1.87,'linear')
                doTweenY('dScroll9','botplayTxt', 90,1.87,'linear')
                doTweenY('dScroll10','practiceTxt', 90,1.87,'linear')
            end
        elseif curStep == 1016 then
            if not downscroll then
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            else
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            runTimer('lowLag', 0.1)
        end
        -- Other Thing --
        if goingG then
            runHaxeCode([[
                for (note in notes) {
                    if (note.mustPress) {
                        note.cameras = [camOne];
                    }
                }
            ]])
        end
    end
    function goBack()
        runHaxeCode([[
            for (note in notes) {
                if (note.mustPress) {
                    note.cameras = [camHUD];
                }
            }
        ]])
    end
    function onTimerCompleted(tag)
        if tag == 'removeSorry' then
            removeLuaText('Sorry')
        end
        if tag == 'lowLag' then
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if getPropertyFromGroup('playerStrums',1,'downScroll') then
                    if getPropertyFromGroup('notes',i,'isSustainNote') then
                        setPropertyFromGroup('notes',i,'flipY',true)
                        setPropertyFromGroup('notes', i, 'correctionOffset', 0)
                    end
                    if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then
                        setPropertyFromGroup('unspawnNotes',i,'flipY',true)
                        setPropertyFromGroup('unspawnNotes', i, 'correctionOffset', 0)
                    end
                else
                    if getPropertyFromGroup('notes',i,'isSustainNote') then
                        setPropertyFromGroup('notes',i,'flipY',false)
                        setPropertyFromGroup('notes', i, 'correctionOffset', 50)
                    end
                    if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then
                        setPropertyFromGroup('unspawnNotes',i,'flipY',false)
                        setPropertyFromGroup('unspawnNotes', i, 'correctionOffset', 50)
                    end
                end
            end
            runTimer('lowLag', 0.1)
        end
    end
end

function onTweenCompleted(t)
    if mechanicsAgain then
        if t == 'cOyE' or t == 'svA' then
            goBack()
        end
        if t == 'sv' then
            setProperty('camOne.y', 0)
        end
        if t == 'cOy' then
            doTweenY('cOya', 'camOne', 200*dSM, 0.1, 'sineOut')
        end
        if t == 'cOy2' then
            doTweenY('cOya', 'camOne', -200*dSM, 0.1, 'sineOut')
        end
    end
    if t == 'retXO' then
        setObjectCamera('healthBar', 'hud')
        setObjectCamera('healthBarBG', 'hud')
        setObjectCamera('iconP1', 'hud')
        setObjectCamera('iconP2', 'hud')
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camHUD];
            }
        ]])
    end
end

function onCreatePost()
    if not downscroll then
        setProperty('botplayTxt.y',90)
        setProperty('practiceTxt.y', 90)
    else
        setProperty('botplayTxt.y',610)
        setProperty('practiceTxt.y', 610)
    end
    setProperty('botplayTxt.x', 105)
    setProperty('practiceTxt.x', 685)
    setTextSize("botplayTxt", 25)
    setTextSize("practiceTxt", 25)
    setTextBorder('botplayTxt', 1, 'ff00ff')
    setTextColor('botplayTxt', '00ffff')
    setTextBorder('practiceTxt', 1, 'ff00ff')
    setTextColor('practiceTxt', 'ffff00')
    if mechanicsAgain then
        setProperty('camOne'..'.flashSprite.scaleX', 2)
        setProperty('camOne'..'.flashSprite.scaleY', 2)
        runHaxeCode("game."..'camOne'..".setScale(game."..'camOne'..".zoom / 2, game."..'camOne'..".zoom / 2);")
        if downscroll then
            dSM = -1
        end
    end
    if buildTarget ~= "android" then
        runHaxeCode([[
            import lime.app.Application;
            var wnd = Application.current.window;
            wnd.resizable = false;
            wnd.fullscreen = false;
            wnd.borderless = true;
        ]])
        ffi = require("ffi")
        ffi.cdef([[
            typedef void* HWND;
            typedef int BOOL;
            typedef unsigned char BYTE;
            typedef unsigned long DWORD;
            HWND GetActiveWindow();
            long SetWindowLongA(HWND hWnd, int nIndex, long dwNewLong);
            BOOL SetLayeredWindowAttributes(HWND hwnd, DWORD crKey, BYTE bAlpha, DWORD dwFlags);
        ]])
        local hwnd = ffi.C.GetActiveWindow()
    end
end

function onDestroy()
    if buildTarget ~= 'android' then
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/Restore-Wallpaper.ps1"')
        setWindow("center", "center", 1280*1.4, 720*1.4)
        runHaxeCode([[
            import lime.app.Application;
            var wnd = Application.current.window;
            wnd.resizable = true;
            wnd.fullscreen = false;
            wnd.borderless = false;
        ]])
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end
end

function setWindow(x, y, w, h)
    if buildTarget ~= 'android' then
        local screen = runHaxeCode([[
            import lime.app.Application;
            var d = Application.current.window.display.bounds;
            return { sw: d.width, sh: d.height };
        ]])
        local current = runHaxeCode([[
            import lime.app.Application;
            var wnd = Application.current.window;
            return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };
        ]])
        local newW = parseValue(w, current.width)
        local newH = parseValue(h, current.height)
        local newX = parseValue(x, current.x, screen.sw, newW)
        local newY = parseValue(y, current.y, screen.sh, newH)
        runHaxeCode(string.format([[
            import lime.app.Application;
            var wnd = Application.current.window;
            wnd.x = %f;
            wnd.y = %f;
            wnd.width = %f;
            wnd.height = %f;
        ]], newX, newY, newW, newH))
        lockedPosition = { x = newX, y = newY, width = newW, height = newH }
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
            return sign == "+" and current + offset or current - offset
        end
        local n = tonumber(param)
        if n then return n end
    elseif type(param) == "number" then
        return param
    end
    return current
end
function onUpdate()
    if not mechanicsAgain then
 	    setProperty('songSpeed', 2.6)
    end
end
function onSongStart()
    if buildTarget ~= 'android' then
        makeLuaText('Sorry', 'Windows 11 and non-1080p screens are not supported.\nExpect performance issues.\n Disable these effects in the Internet Favorites Settings menu: Asset Movement', 1280, 0, 0)
        setTextSize('Sorry', 25)
        setTextBorder('Sorry', 1, 'ff00ff')
        setTextColor('Sorry', '00ffff')
        setObjectCamera('Sorry', 'other')
        screenCenter('Sorry', 'xy')
        addLuaText('Sorry')
        runTimer('removeSorry', 5)
    end
end