if difficultyName ~= 'Insanity' then
    close()
end
---------------------------------------
-- This is the Entire Modchart Here! --
---------------------------------------
local danceGame = false
local nrn = false
function onStepHit()
    if curStep == 4 then
        local camAngle = 20
        local timeMove = 0.35
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 8 then
        local camAngle = -40
        local timeMove = 0.35
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 12 then
        local winMove = 200
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMove, timeMove, 'expoOut')
    elseif curStep == 14 then
        local camAngle = 0
        local winMove = -200
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMove, timeMove, 'expoOut')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 18 then
        local camAngle = 0
        local winMoveX = 0
        local winMoveY = 100
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'expoOut')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
    elseif curStep == 20 then
        local winMoveY = -100
        local timeMove = 0.2
        
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
    elseif curStep == 24 then
        local camAngle = 10
        local winMoveX = 50
        local winMoveY = -50
        local winSize = 0.75
        local timeMove = 0.3
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'linear')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'linear')
        doTweenZoom('2z', 'camHUD', winSize, timeMove, 'linear')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'linear')
    elseif curStep == 28 then
        local camAngle = -10
        local winMoveX = -50
        local winMoveY = 0
        local winSize = 1
        local timeMove = 0.3
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'linear')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'linear')
        doTweenZoom('2z', 'camHUD', winSize, timeMove, 'linear')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'linear')
    elseif curStep == 32 then
        local camAngle = 0
        local winMoveX = 0
        local winMoveY = 0
        local winSize = 0.8
        local timeMove = 0.2
        setProperty('camHUD.x', winMoveX)
        setProperty('camHUD.y', winMoveY)
        setProperty('camHUD.angle', camAngle)
        doTweenZoom('2z', 'camHUD', winSize, timeMove, 'expoOut')
    elseif curStep == 36 then
        local camAngle = -10
        local winMoveX = -250
        local winMoveY = 100
        local winSize = 0.7
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'expoOut')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
        doTweenZoom('2z', 'camHUD', winSize, timeMove, 'expoOut')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 40 then
        local camAngle = 10
        local winMoveX = 250
        local winMoveY = -100
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'expoOut')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 44 then
        local camAngle = 0
        local winMoveY = 0
        local timeMove = 0.2
        usD(true, timeMove, 'expoOut', true)
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
        doTweenAngle('2a', 'camHUD', camAngle, timeMove, 'expoOut')
    elseif curStep == 46 then
        local winMoveX = 0
        local winMoveY = 0
        local timeMove = 0.2
        doTweenX('2ax', 'camHUD', winMoveX, timeMove, 'expoOut')
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
    elseif curStep == 50 then
        local winMoveX = 0
        local winMoveY = 0
        local timeMove = 0.2
        doTweenY('2ay', 'camHUD', winMoveY, timeMove, 'expoOut')
        usD(false, timeMove, 'expoOut', false)
    elseif curStep == 52 then
        local timeMove = 0.2
        usD(false, timeMove, 'expoOut', true)
    elseif curStep == 56 then
        local hudAngle = -10
        local gameAngle = 10
        local timeMove = 0.2
        setProperty('camGame.zoom', 0.7)
        setProperty('defaultCamZoom', 0.7)
        setObjectCamera('whiteBar', 'game')
        setObjectCamera('gameTitle', 'game')
        setObjectCamera('fnf', 'game')
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 60 then
        local hudAngle = 10
        local gameAngle = -10
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 64 then
        local hudAngle = -10
        local gameAngle = 10
        local timeMove = 0.3
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoIn')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoIn')
        usD(true, timeMove, 'cubeOut', true)
    elseif curStep == 68 then
        local hudAngle = -10
        local gameAngle = 10
        local timeMove = 0.3
        setProperty('camHUD.angle', 10)
        setProperty('camGame.angle', -10)
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoIn')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoIn')
    elseif curStep == 72 then
        local hudAngle = 0
        local gameAngle = 0
        local timeMove = 0.2
        usD(false, timeMove, 'cubeOut', true)
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 76 then
        local hudAngle = 90
        local gameAngle = -90
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 78 then
        local timeMove = 0.2
        usD(true, timeMove, 'cubeOut', true)
    elseif curStep == 82 then
        local hudAngle = 0
        local gameAngle = 0
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 84 then
        local timeMove = 0.2
        usD(false, timeMove, 'cubeOut', false)
    elseif curStep == 88 then
        local hudAngle = 45
        local gameAngle = 45
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 92 then
        local hudAngle = -45
        local gameAngle = -45
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 96 then
        local timeMove = 0.2
        usD(false, timeMove, 'linear', true)
    elseif curStep == 100 then
        local hudAngle = 45
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
    elseif curStep == 104 then
        local gameAngle = 45
        local timeMove = 0.2
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 108 then
        local hudAngle = 0
        local gameAngle = 0
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 110 then
        local timeMove = 0.2
        usD(true, timeMove, 'expoOut', false)
    elseif curStep == 114 then
        local hudAngle = -45
        local timeMove = 0.2
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
    elseif curStep == 116 then
        local gameAngle = 45
        local timeMove = 0.2
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 120 then
        local hudAngle = 0
        local timeMove = 0.2
        local winSize = 1
        local stepMove = 7 * stepCrochet/1000
        doTweenZoom('2z', 'camHUD', winSize, stepMove, 'linear')
        doTweenZoom('2zg', 'camGame', winSize, stepMove, 'linear')
        doTweenAngle('2ah', 'camHUD', hudAngle, timeMove, 'expoOut')
    elseif curStep == 124 then
        local gameAngle = 0
        local timeMove = 0.2
        doTweenAngle('2ag', 'camGame', gameAngle, timeMove, 'expoOut')
    elseif curStep == 128 then
        local timeMove = 0
        usD(false, timeMove, 'linear', true)
        if buildTarget ~= 'android' then
            ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
        end
        nrn = true
        setProperty('stg1.alpha', 1)
        setProperty('stg2.alpha', 1)
        setProperty('stg3.alpha', 1)
        setProperty('boyfriend.alpha', 1)
        setProperty('gf.alpha', 1)
    elseif curStep == 370 then
        local winSize = 0.95

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
    elseif curStep == 372 then
        local winSize = 0.9

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
        setProperty('stg1.alpha', 0)
        setProperty('stg2.alpha', 0)
        setProperty('stg3.alpha', 0)
    elseif curStep == 374 then
        local winSize = 0.85

        if buildTarget ~= 'android' then
            ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00080000)
            ffi.C.SetLayeredWindowAttributes(ffi.C.GetActiveWindow(), 0x00000000, 0, 0x00000001)
        end
        nrn = false
        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
        setProperty('boyfriend.alpha', 0)
        setProperty('gf.alpha', 0)
    elseif curStep == 376 then
        local winSize = 0.8

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
    elseif curStep == 378 then
        local winSize = 0.75

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
    elseif curStep == 380 then
        local winSize = 0.7

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
    elseif curStep == 444 then
        local winSize = 0.6

        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
    elseif curStep == 447 then
        danceGame = true
        setPropertyFromClass('openfl.Lib', 'application.window.x', 0)
        setPropertyFromClass('openfl.Lib', 'application.window.y', -1)
        setPropertyFromClass("openfl.Lib", "application.window.width", 1920)
        setPropertyFromClass("openfl.Lib", "application.window.height", 1081)
    elseif curStep == 700 then
        danceGame = false
        for _, obj in pairs({'danceZ1Y', 'danceZ2Y', 'danceZ3Y','danceZ1X', 'danceZ2X', 'danceZ3X','danceZ1A', 'danceZ2A', 'danceZ3A'}) do
            cancelTween(obj)
        end
        setProperty('whiteBar.alpha', 0)
        setProperty('gameTitle.alpha', 0)
        setProperty('fnf.alpha', 0)
    elseif curStep == 701 then
        local stepMove = 2 * stepCrochet/1000
        doTweenAngle('danceZ1A', 'camGame', 0, stepMove, 'elasticIn')
        doTweenAngle('danceZ2A', 'camHUD', 0, stepMove, 'elasticIn')
        doTweenAngle('danceZ3A', 'camOther', 0, stepMove, 'elasticIn')
        doTweenX('danceZ1X', 'camGame', 0, stepMove, 'elasticIn')
        doTweenX('danceZ2X', 'camHUD', 0, stepMove, 'elasticIn')
        doTweenX('danceZ3X', 'camOther', 0, stepMove, 'elasticIn')
        doTweenY('danceZ1Y', 'camGame', 0, stepMove, 'elasticIn')
        doTweenY('danceZ2Y', 'camHUD', 0, stepMove, 'elasticIn')
        doTweenY('danceZ3Y', 'camOther', 0, stepMove, 'elasticIn')
    elseif curStep == 704 then
        setProperty('stg1.alpha', 1)
        setProperty('stg2.alpha', 1)
        setProperty('stg3.alpha', 1)
        setPropertyFromClass('openfl.Lib', 'application.window.x', 0)
        setPropertyFromClass('openfl.Lib', 'application.window.y', -1)
        setPropertyFromClass("openfl.Lib", "application.window.width", 1920)
        setPropertyFromClass("openfl.Lib", "application.window.height", 1081)
        setProperty('boyfriend.alpha', 1)
        setProperty('gf.alpha', 1)
        local winSize = 1
        
        setProperty('camHUD.zoom', winSize)
        setProperty('camGame.zoom', winSize)
        setProperty('camOther.zoom', winSize)
        setProperty('defaultCamUIZoom', winSize)
        setProperty('defaultCamZoom', winSize)
        if buildTarget ~= 'android' then
            ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
        end
        nrn = true
        
    end  -- First size for camHUD winSize was 0.5 for Noting and currently 0.7
    if danceGame and curStep % 2 == 0 then
        local stepMove = 2 * stepCrochet/1000
        if done then
            doTweenY('danceZ1Y', 'camGame', 80, stepMove, 'quartInOut')
            doTweenY('danceZ2Y', 'camHUD', 80, stepMove, 'quartInOut')
            doTweenY('danceZ3Y', 'camOther', 80, stepMove, 'quartInOut')
            done = false
        elseif not done then
            doTweenY('danceZ1Y', 'camGame', -80, stepMove, 'quadOut')
            doTweenY('danceZ2Y', 'camHUD', -80, stepMove, 'quadOut')
            doTweenY('danceZ3Y', 'camOther', -80, stepMove, 'quadOut')
            done = true
        end
    end
end

function onBeatHit()
    if danceGame then
        local stepMove = 3 * stepCrochet/1000
        if doneB then
            doTweenX('danceZ1X', 'camGame', 120, stepMove, 'linear')
            doTweenX('danceZ2X', 'camHUD', 120, stepMove, 'linear')
            doTweenX('danceZ3X', 'camOther', 120, stepMove, 'linear')
            doTweenAngle('danceZ1A', 'camGame', 10, stepMove, 'cubicInOut')
            doTweenAngle('danceZ2A', 'camHUD', 10, stepMove, 'cubicInOut')
            doTweenAngle('danceZ3A', 'camOther', 10, stepMove, 'cubicInOut')
            doneB = false
        elseif not doneB then
            doTweenX('danceZ1X', 'camGame', -120, stepMove, 'linear')
            doTweenX('danceZ2X', 'camHUD', -120, stepMove, 'linear')
            doTweenX('danceZ3X', 'camOther', -120, stepMove, 'linear')
            doTweenAngle('danceZ1A', 'camGame', -10, stepMove, 'cubicInOut')
            doTweenAngle('danceZ2A', 'camHUD', -10, stepMove, 'cubicInOut')
            doTweenAngle('danceZ3A', 'camOther', -10, stepMove, 'cubicInOut')
            doneB = true
        end
    end
end

function usD(yes, tMo, twn, mw)
    if not yes then
        if tMo ~= 0 then
            if mw then
                doTweenY('whiteBarMove', 'whiteBar', -40, tMo, twn)
                doTweenY('gameTitleMove', 'gameTitle', -34, tMo, twn)
                doTweenY('fnfMove', 'fnf', -33, tMo, twn)
            end
            noteTweenY('note1',4,50,tMo,twn);
            noteTweenY('note2',5,50,tMo,twn);
            noteTweenY('note3',6,50,tMo,twn);
            noteTweenY('note4',7,50,tMo,twn);

            noteTweenY('opponent1',0,50,tMo,twn);
            noteTweenY('opponent2',1,50,tMo,twn);
            noteTweenY('opponent3',2,50,tMo,twn);
            noteTweenY('opponent4',3,50,tMo,twn);
        else
            if mw then
                setProperty('whiteBar.y', -40)
                setProperty('gameTitle.y', -34)
                setProperty('fnf.y', -33)
            end
            for i = 0,3 do
                setPropertyFromGroup('opponentStrums',i,'y',50);
                setPropertyFromGroup('playerStrums',i,'y',50);
            end
        end
        for i = 0,3 do
            setPropertyFromGroup('opponentStrums',i,'downScroll',false);
            setPropertyFromGroup('playerStrums',i,'downScroll',false);
        end
        dS = false
    else
        if tMo ~= 0 then
            if mw then
                doTweenY('whiteBarMove', 'whiteBar', 720, tMo, twn)
                doTweenY('gameTitleMove', 'gameTitle', 726, tMo, twn)
                doTweenY('fnfMove', 'fnf', 727, tMo, twn)
            end
            noteTweenY('note1',4,560,tMo,twn);
            noteTweenY('note2',5,560,tMo,twn);
            noteTweenY('note3',6,560,tMo,twn);
            noteTweenY('note4',7,560,tMo,twn);

            noteTweenY('opponent1',0,560,tMo,twn);
            noteTweenY('opponent2',1,560,tMo,twn);
            noteTweenY('opponent3',2,560,tMo,twn);
            noteTweenY('opponent4',3,560,tMo,twn);
        else
            if mw then
                setProperty('whiteBar.y', 720)
                setProperty('gameTitle.y', 726)
                setProperty('fnf.y', 727)
            end
            for i = 0,3 do
                setPropertyFromGroup('opponentStrums',i,'y',560);
                setPropertyFromGroup('playerStrums',i,'y',560);
            end
        end
        for i = 0,3 do
            setPropertyFromGroup('opponentStrums',i,'downScroll',true);
            setPropertyFromGroup('playerStrums',i,'downScroll',true);
        end
        dS = true
    end
end

function onTweenCompleted(tag)
    if tag == '1' or tag == '2z' or tag == '2zg' then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom'))
        setProperty("defaultCamZoom",getProperty('camGame.zoom'))
    end
end

--------------------
-- Variables Here --
--------------------

function onCreatePost()
    luaSprite('stg1', 'cg5/bg/mixroom', -480, -270, 0.88, 0.88, 0.9, 0, 'game', 'n', 3);
    luaSprite('stg2', 'cg5/bg/ploosh', 990, 180, 1, 1, 0.9, 0, 'game', 'n', 6);
    luaSprite('stg3', 'cg5/bg/recordroom', -450, -200, 0.9, 0.9, 0.9, 0, 'game', 'n', 9);
    setProperty('boyfriend.alpha', 0)
    setProperty('gf.alpha', 0)

    setObjectOrder("gfGroup", getObjectOrder("stg3")-1)
    setObjectOrder("boyfriendGroup", getObjectOrder("stg3")+1)
    setObjectOrder("dadGroup", getObjectOrder("stg3")+2)
    -------------------------------------------------
    -- Botplay and Practice Mode Text for cheaters --
    -------------------------------------------------
    if botPlay then
        setTextString('botplayTxt', 'botPlay User')
        setTextSize("botplayTxt", 25)
        setProperty('botplayTxt.x', screenWidth/2.32)
        setProperty('botplayTxt.y', 0)
        setTextWidth("botplayTxt", 0)
        setTextAlignment("botplayTxt", 'center')
        setObjectCamera("botplayTxt",'other')
        setTextBorder('botplayTxt', 1, 'ffff00')
        setTextColor('botplayTxt', 'ff0000')
    end
    if practice then
        setTextString('practiceTxt', 'No Death? Wow')
        setTextSize("practiceTxt", 25)
        setProperty('practiceTxt.x', screenWidth/2.36)
        setProperty('practiceTxt.y', getProperty('botplayTxt.y')+20)
        setTextWidth("practiceTxt", 0)
        setTextAlignment("practiceTxt", 'center')
        setObjectCamera("practiceTxt",'other')
        setTextBorder('practiceTxt', 1, 'ffff00')
        setTextColor('practiceTxt', 'ff0000')
    end
    ----------------------------------------------------------
    -- Custom FPS Text since window makes black hard to see --
    ----------------------------------------------------------
    setPropertyFromClass("Main", "fpsVar.visible", false)
    luaText('fpsDrawer', '', 0, 0, 0, 20, 'other', 200, 'ffffff', 0, '000000', 'left')
    setTextString("fpsDrawer", getPropertyFromClass("Main", "fpsVar.text"))
    runTimer('fpsT', 0.07)
end

function onTimerCompleted(tag)
    if tag == 'fpsT' then
        setTextString("fpsDrawer", getPropertyFromClass("Main", "fpsVar.text"))
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if dS or getPropertyFromGroup('playerStrums',1,'downScroll') then
                if getPropertyFromGroup('notes',i,'isSustainNote') then
                    setPropertyFromGroup('notes',i,'flipY',true)
                    setPropertyFromGroup('notes', i, 'correctionOffset', 0)
                end
                if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then
                    setPropertyFromGroup('unspawnNotes',i,'flipY',true)
                    setPropertyFromGroup('unspawnNotes', i, 'correctionOffset', 0)
                end
            elseif not dS or not getPropertyFromGroup('playerStrums',1,'downScroll') then
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
        runTimer('fpsT', 0.07)
    end
end

--------------------------------------------
-- This here makes the Window Transparent --
--------------------------------------------
function onSongStart()
    if buildTarget ~= "android" then
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
        ffi.C.SetWindowLongA(hwnd, -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(hwnd, 0x00000000, 0, 0x00000001)
        ogM = getPropertyFromClass('openfl.Lib', 'application.window.maximized')
        ogFS = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
        setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
        setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
        setPropertyFromClass('openfl.Lib', 'application.window.x', 0)
        setPropertyFromClass('openfl.Lib', 'application.window.y', -1)
        setPropertyFromClass("openfl.Lib", "application.window.width", 1920)
        setPropertyFromClass("openfl.Lib", "application.window.height", 1081)
        doinThing = true
        os.execute('powershell -ExecutionPolicy Bypass -File '..string.format('"%s"', debug.getinfo(1).source:sub(2):gsub('/[^/]*$', '') .. "/hidePS.ps1"))
    end

    -- Middle scroll and UI stuff
    setProperty('camHUD.zoom', 0.5)
    setProperty('camGame.zoom', 0.5)
    setProperty('defaultCamUIZoom', 0.5)
    setProperty('camZoomingMult', 0)

    setProperty('showRating', false);
	setProperty('showComboNum', false);
    setProperty('healthBar.alpha', 0);
	setProperty('healthBarBG.alpha', 0);
	setProperty('iconP1.alpha', 0);
	setProperty('iconP2.alpha', 0);
	setProperty('scoreTxt.alpha', 0);
	setProperty('timeBar.alpha', 0);
	setProperty('timeTxt.alpha', 0);
	setProperty('timeBar.visible', false)
	setProperty('timeBarBG.visible', false)
	setProperty('timeTxt.visible', false)

    luaGraphic('whiteBar', 0, -40, 1280, 30, 'FFFFFF')
    luaSprite('fnf', 'me/popup/fnf', 8, -33, 1, 1, 0, 1, 'hud', 'n', 106)
    luaText('gameTitle', 'Friday Night Funkin\': Internet Favorites Engine', 0, 29, -34, 16, 'hud', 104, '0000ff', 0, '', 'left')
end
function luaGraphic(tag,xPos,yPos,width,height,color)
    makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, width, height, color)
    setScrollFactor(tag, 0.0, 0.0)
	setObjectCamera(tag, 'hud')
    setObjectOrder(tag, 103)
    setProperty(tag..'.alpha', 1)
	addLuaSprite(tag, true)
end
function luaText(tag,txt,w,x,y,size,cam,oo,col,bs,bc,ali,f)
    makeLuaText(tag, txt, w, x, y)
    setTextSize(tag, size)
    setObjectCamera(tag, cam)
    setObjectOrder(tag, oo)
    setTextColor(tag, col)
    setTextAlignment(tag, ali)
    setTextBorder(tag, bs, bc)
    addLuaText(tag)
end
function luaSprite(tag, where, xPos, yPos, xw, yh, sF, aA, C, sC, oO)
    makeLuaSprite(tag, where,xPos,yPos)
    setObjectCamera(tag, C)
    setScrollFactor(tag, sF, sF)
    setObjectOrder(tag, oO)
    scaleObject(tag, xw,yh)
    setProperty(tag..".alpha", aA)
    if sC ~= 'n' then
        screenCenter(tag, sC)
    end
    updateHitbox(tag)
end

--------------------------------------------------------------
-- This makes the game easier to tab back into when pausing --
--------------------------------------------------------------
function onPause()
    if doinThing and not nrn then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end
    setPropertyFromClass("Main", "fpsVar.visible", true)
end
function onResume()
    setPropertyFromClass("Main", "fpsVar.visible", false)
    if doinThing and not nrn then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(ffi.C.GetActiveWindow(), 0x00000000, 0, 0x00000001)
    end
end

------------------------------------------------
-- Fixes the window when resetting or leaving --
------------------------------------------------
function onDestroy()
    setPropertyFromClass("Main", "fpsVar.visible", true)
    if buildTarget ~= "android" then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)   
        setPropertyFromClass('openfl.Lib', 'application.window.maximized', ogM)
        setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', ogFS)
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
        setPropertyFromClass("openfl.Lib", "application.window.width", 1280)
        setPropertyFromClass("openfl.Lib", "application.window.height", 720)
        setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
        setPropertyFromClass('openfl.Lib', 'application.window.y', 180)
        os.execute('powershell -ExecutionPolicy Bypass -File ' .. string.format('"%s"', debug.getinfo(1).source:sub(2):gsub('/[^/]*$', '') .. "/showPS.ps1"))
    end

    close()
end