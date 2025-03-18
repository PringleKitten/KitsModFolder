---------------------------------------
-- This is the Entire Modchart Here! --
---------------------------------------
function onStepHit()
    if difficultyName == "Insanity" then
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
            setObjectCamera('lS-fnf', 'game')

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
        end  -- First size for camHUD winSize was 0.5 for Noting
    end
end

function usD(yes, tMo, twn, mw)
    if not yes then
        if mw then
            doTweenY('whiteBarMove', 'whiteBar', -40, tMo, twn)
            doTweenY('gameTitleMove', 'gameTitle', -34, tMo, twn)
            doTweenY('fnfMove', 'lS-fnf', -33, tMo, twn)
        end
        noteTweenY('note1',4,50,tMo,twn);
        noteTweenY('note2',5,50,tMo,twn);
        noteTweenY('note3',6,50,tMo,twn);
        noteTweenY('note4',7,50,tMo,twn);

        noteTweenY('opponent1',0,50,tMo,twn);
        noteTweenY('opponent2',1,50,tMo,twn);
        noteTweenY('opponent3',2,50,tMo,twn);
        noteTweenY('opponent4',3,50,tMo,twn);
        for i = 0,3 do
            setPropertyFromGroup('opponentStrums',i,'downScroll',false);
            setPropertyFromGroup('playerStrums',i,'downScroll',false);
        end
        dS = false
    else
        if mw then
            doTweenY('whiteBarMove', 'whiteBar', 720, tMo, twn)
            doTweenY('gameTitleMove', 'gameTitle', 726, tMo, twn)
            doTweenY('fnfMove', 'lS-fnf', 727, tMo, twn)
        end
        noteTweenY('note1',4,560,tMo,twn);
        noteTweenY('note2',5,560,tMo,twn);
        noteTweenY('note3',6,560,tMo,twn);
        noteTweenY('note4',7,560,tMo,twn);

        noteTweenY('opponent1',0,560,tMo,twn);
        noteTweenY('opponent2',1,560,tMo,twn);
        noteTweenY('opponent3',2,560,tMo,twn);
        noteTweenY('opponent4',3,560,tMo,twn);
        for i = 0,3 do
            setPropertyFromGroup('opponentStrums',i,'downScroll',true);
            setPropertyFromGroup('playerStrums',i,'downScroll',true);
        end
        dS = true
    end
end

function onSpawnNote()
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if dS then
            if getPropertyFromGroup('notes',i,'isSustainNote') then
                setPropertyFromGroup('notes',i,'flipY',true)
                setPropertyFromGroup('notes', i, 'correctionOffset', 0)
            end
            if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then
                setPropertyFromGroup('unspawnNotes',i,'flipY',true)
                setPropertyFromGroup('unspawnNotes', i, 'correctionOffset', 0)
            end
        elseif not dS then
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
end

function onTweenCompleted(tag)
    if tag == '1' or tag == '2z' then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom'))
        setProperty("defaultCamZoom",getProperty('camGame.zoom'))
    end
end

--------------------
-- Variables Here --
--------------------

local startWidth = 0
local startHeight = 0
local targetWidth = 0
local targetHeight = 0
local startX = 0
local targetX = 0
local startY = 0
local tweenDurationSize = 0
local tweenDurationPos = 0
local tweenStartTimeSize = 0
local tweenStartTimePos = 0
local tweenEaseSize = nil
local tweenEasePos = nil
local isTweeningSize = false
local isTweeningPos = false

local startOffsetX = 0
local startOffsetY = 0
local targetOffsetX = 0
local targetOffsetY = 0

function onCreatePost()
    if difficultyName ~= 'Insanity' then
        close()
    else
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
        makeLuaText('fpsDrawer', '', 0, 0, 0)
        setTextSize('fpsDrawer', 20)
        setTextColor('fpsDrawer', 'ffff00')
        setTextBorder('fpsDrawer', 1, 'ff0000')
        setTextAlignment('fpsDrawer', 'left')
        setObjectCamera('fpsDrawer', 'other')
        addLuaText('fpsDrawer')

        drawf = getPropertyFromClass("Main", "fpsVar.text")
        setTextString("fpsDrawer", drawf)
    end
end

function onUpdatePost()
    drawf = getPropertyFromClass("Main", "fpsVar.text")
    setTextString("fpsDrawer", drawf)
end

--------------------------------------------
-- This here makes the Window Transparent --
--------------------------------------------
if buildTarget ~= "android" then
    local ffi = require("ffi")
end
function onSongStart()
    if buildTarget ~= "android" then
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
    setPropertyFromGroup('opponentStrums',0,'x',defaultOpponentStrumX0+75);
    setPropertyFromGroup('opponentStrums',1,'x',defaultOpponentStrumX1+75);
    setPropertyFromGroup('opponentStrums',2,'x',defaultOpponentStrumX2-79);
    setPropertyFromGroup('opponentStrums',3,'x',defaultOpponentStrumX3-79);
    setPropertyFromGroup('playerStrums',0,'x',defaultPlayerStrumX0-323);
    setPropertyFromGroup('playerStrums',1,'x',defaultPlayerStrumX1-323);
    setPropertyFromGroup('playerStrums',2,'x',defaultPlayerStrumX2-323);
    setPropertyFromGroup('playerStrums',3,'x',defaultPlayerStrumX3-323);
    setPropertyFromGroup('opponentStrums',0,'alpha',0);
    setPropertyFromGroup('opponentStrums',1,'alpha',0);
    setPropertyFromGroup('opponentStrums',2,'alpha',0);
    setPropertyFromGroup('opponentStrums',3,'alpha',0);
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

    -----------------------------------------------------------------------------------
    -- No Longer gonna do this but it was to make a sorta fake window title bar hehe --
    -----------------------------------------------------------------------------------
    --luaGraphic('bg', 0, -11, 1280, 731, '0000bb')
    --setObjectCamera('bg', 'game')
    luaGraphic('whiteBar', 0, -40, 1280, 30, 'FFFFFF')
    luaSprite('fnf', 8, -33, 1, 1, 0, 1, 'hud', 'n', 106)
    makeLuaText('gameTitle', 'Friday Night Funkin\': Internet Favorites Engine', 0, 29, -34)
    setTextSize('gameTitle', 16)
    setObjectCamera('gameTitle', 'hud')
    setObjectOrder('gameTitle', 104)
    setTextColor('gameTitle', '0000ff')
    setTextBorder('gameTitle', 0)
    addLuaText('gameTitle')
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
function luaSprite(tag, xPos, yPos, xw, yh, sF, aA, C, sC, oO)
    local nTag = 'lS-'..tag
    makeLuaSprite(nTag, 'me/popup/'..tag,xPos,yPos)
    setObjectCamera(nTag, C)
    setScrollFactor(nTag, sF, sF)
    setObjectOrder(nTag, oO)
    scaleObject(nTag, xw,yh)
    setProperty(nTag..".alpha", aA)
    if sC ~= 'n' then
        screenCenter(nTag, sC)
    end
end

--------------------------------------------------------------
-- This makes the game easier to tab back into when pausing --
--------------------------------------------------------------
function onPause()
    if doinThing then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end
end
function onResume()
    if doinThing then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(ffi.C.GetActiveWindow(), 0x00000000, 0, 0x00000001)
    end
end

------------------------------------------------
-- Fixes the window when resetting or leaving --
------------------------------------------------
function onDestroy()
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
    setPropertyFromClass("Main", "fpsVar.visible", true)
    close()
end