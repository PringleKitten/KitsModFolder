local offset = 0
local vde = "No Video"
local s1 = 0
local s2 = 0
local f = false
local okm = true
local mdc = 'Enabled'
local modchart = true
local playvideo = false
allowCountdown = false

function onCreate()
    makeLuaSprite('hide', 'me/popup/dim',0,0)
    setObjectCamera("hide", 'other')
    setScrollFactor("hide", 0, 0)
    setGraphicSize("hide", screenWidth, screenHeight)
    addLuaSprite('hide', true)

    makeLuaText("ret", ("Video Quality: "..vde..'p'), screenWidth, 0.0, 0.0)
    makeLuaText("ret1", "Press 1-4 to choose Quality", screenWidth, 0.0, screenHeight/1.75)
    makeLuaText("ret2", "Press Spacebar to Confirm", screenWidth, 0.0, screenHeight/2.5)
    makeLuaText("why", "Laggy? Press N for no video", screenWidth, 0.0, screenHeight/5)
    makeLuaText("coolguy", "Song Suggestion by StupidBlanalba08", screenWidth, 0.0, screenHeight-screenHeight/1.1)

    setObjectCamera("ret", 'other')
    setObjectCamera("ret1", 'other')
    setObjectCamera("ret2", 'other')
    setObjectCamera("why", 'other')
    setObjectCamera("coolguy", 'other')
    screenCenter("ret", 'xy')
    screenCenter("ret1", 'x')
    screenCenter("ret2", 'x')
    screenCenter("why", 'x')
    screenCenter("coolguy", 'x')
    setTextSize("ret", screenWidth/35)
    setTextSize("ret1", screenWidth/40)
    setTextSize("ret2", screenWidth/40)
    setTextSize("why", screenWidth/40)
    setTextSize("coolguy", screenWidth/40)

    setTextColor('why', '00FFFF')
    setTextColor("coolguy", "00FF00")
    
    addLuaText("ret",true)
    addLuaText("ret1",true)
    addLuaText("ret2",true)
    addLuaText("why",true)
    addLuaText("coolguy",true)

    --buttons
    bx = getProperty('coolguy.x')
    by = getProperty('coolguy.y')
    
    makeLuaSprite('button', 'me/buttons/button',0,screenHeight/4)
    setObjectCamera("button", 'other')
    scaleObject("button", 0.5, 0.5)
    addLuaSprite("button",true)

    bx1 = getProperty('button.x')
    makeLuaSprite('button1', 'me/buttons/button',screenWidth-screenWidth/1.1,screenHeight/4)
    setObjectCamera("button1", 'other')
    scaleObject("button1", 0.5, 0.5)
    addLuaSprite("button1",true)

    makeLuaSprite('button2', 'me/buttons/button',0,screenHeight/2.5)
    setObjectCamera("button2", 'other')
    scaleObject("button2", 0.5, 0.5)
    addLuaSprite("button2",true)

    makeLuaSprite('button3', 'me/buttons/button',screenWidth-screenWidth/1.1,screenHeight/2.5)
    setObjectCamera("button3", 'other')
    scaleObject("button3", 0.5, 0.5)
    addLuaSprite("button3",true)

    makeLuaSprite('buttonn', 'me/buttons/button',screenWidth/5,screenHeight/2.3)
    setObjectCamera("buttonn", 'other')
    scaleObject("buttonn", 0.5, 0.5)
    addLuaSprite("buttonn",true)

    makeLuaText('b1', '1', 0, screenWidth-screenWidth/1.0225,screenHeight/3.65)
    setTextSize('b1', screenWidth/20)
    setObjectCamera("b1", 'other')
    addLuaText("b1",true)
    makeLuaText('b2', '2', 0, screenWidth-screenWidth/1.1275,screenHeight/3.65)
    setTextSize('b2', screenWidth/20)
    setObjectCamera("b2", 'other')
    addLuaText("b2",true)
    makeLuaText('b3', '3', 0, screenWidth-screenWidth/1.0225,screenHeight/2.35)
    setTextSize('b3', screenWidth/20)
    setObjectCamera("b3", 'other')
    addLuaText("b3",true)
    makeLuaText('b4', '4', 0, screenWidth-screenWidth/1.1275,screenHeight/2.35)
    setTextSize('b4', screenWidth/20)
    setObjectCamera("b4", 'other')
    addLuaText("b4",true)
    makeLuaText('bn', 'N', 0, screenWidth-screenWidth/1.286,screenHeight/2.175)
    setTextSize('bn', screenWidth/20)
    setObjectCamera("bn", 'other')
    addLuaText("bn",true)

    makeLuaSprite('buttonc', 'me/buttons/button',screenWidth/1.05,screenHeight/1.05)
    setObjectCamera("buttonc", 'other')
    scaleObject("buttonc", 0.5, 0.5)
    addLuaSprite("buttonc",true)
    makeLuaText('bc', 'Done', 0, screenWidth/1.125,screenHeight/1.125)
    setTextSize('bc', screenWidth/39)
    setObjectCamera("bc", 'other')
    addLuaText("bc",true)
    setProperty('buttonc.alpha',0)
    setProperty('bc.alpha',0)
    
    makeLuaSprite('buttonm', 'me/buttons/button',screenWidth/8,screenHeight/1.35)
    setObjectCamera("buttonm", 'other')
    scaleObject("buttonm", 0.5, 0.5)
    addLuaSprite("buttonm",true)
    makeLuaText('bm', 'Mod', 0, screenWidth-screenWidth/1.1625,screenHeight/1.275)
    setTextSize('bm', screenWidth/40)
    setObjectCamera("bm", 'other')
    addLuaText("bm",true)
    
    makeLuaSprite('buttonc', 'me/buttons/button',screenWidth/1.085,screenHeight/1.1625)
    setObjectCamera("buttonc", 'other')
    scaleObject("buttonc", 0.5, 0.5)
    addLuaSprite("buttonc",true)
    makeLuaText('bc', 'Done', 0, screenWidth/1.075,screenHeight/1.105)
    setTextSize('bc', screenWidth/39)
    setObjectCamera("bc", 'other')
    addLuaText("bc",true)
    
    makeLuaText("mc", ("ModChart: "..mdc), screenWidth, 0.0, screenHeight/1.25)
    setObjectCamera("mc", 'other')
    setTextColor("mc", "FF0000")
    setTextSize("mc", 60)
    screenCenter("mc", 'x')
    addLuaText("mc",true)
    
    makeLuaText("mct", "<Press T or F to choose>", screenWidth, 0.0, screenHeight/1.35)
    setObjectCamera("mct", 'other')
    setTextColor("mct", "00FF00")
    setTextSize("mct", 40)
    screenCenter("mct", 'x')
    addLuaText("mct",true)
    addLuaScript("modcharts/terry")
end

function mouseOverlaps(tag, camera)
    x = getMouseX(camera or 'camHUD')
    y = getMouseY(camera or 'camHUD')
    return (x > getProperty(tag..'.x') and y > getProperty(tag..'.y') and x < (getProperty(tag..'.x') + getProperty(tag..'.width')) and y < (getProperty(tag..'.y') + getProperty(tag..'.height')))
end

function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		return Function_Continue
	end
end

local al = false
function buttonStuff()
    if mouseOverlaps('buttonc', 'camOther') and mouseClicked("left") then
        okc = true
    end
    if mouseOverlaps('button', 'camOther') and mouseClicked("left") then
        okn = false
        ok4 = false
        ok3 = false
        ok2 = false
        ok1 = true
    elseif mouseOverlaps('button1', 'camOther') and mouseClicked("left") then
        okn = false
        ok4 = false
        ok3 = false
        ok2 = true
        ok1 = false
    elseif mouseOverlaps('button2', 'camOther') and mouseClicked("left") then
        okn = false
        ok4 = false
        ok3 = true
        ok2 = false
        ok1 = false
    elseif mouseOverlaps('button3', 'camOther') and mouseClicked("left") then
        okn = false
        ok4 = true
        ok3 = false
        ok2 = false
        ok1 = false
    elseif mouseOverlaps('buttonn', 'camOther') and mouseClicked("left") then
        okn = true
        ok4 = false
        ok3 = false
        ok2 = false
        ok1 = false
    end
    if mouseOverlaps('buttonm', 'camOther') and mouseClicked("left") and okm == false then
        okm = true
    elseif mouseOverlaps('buttonm', 'camOther') and mouseClicked("left") and okm == true then
        okm = false
    end

    if not allowCountdown then
        if keyboardJustPressed('T') or okm then
            modchart = true
            okm = true
            mdc = 'Enabled'
            setTextString("mc", ("ModChart: "..mdc))
            setTextColor("mc", "FF0000")
        end
        if keyboardJustPressed("F") or not okm then
            modchart = false
            okm = false
            mdc = 'Disabled'
            setTextString("mc", ("ModChart: "..mdc))
            setTextColor("mc", "00FFFF")
        end
        if keyboardJustPressed('ONE') or ok1 then
            vde = 360
            vden = 'a'
            f = true
            s1 = 2.222
            s2 = 2.2205
            p1 = 355.5
            p2 = -174.3
            okn = false
            ok4 = false
            ok3 = false
            ok2 = false
            ok1 = true
        end
        if keyboardJustPressed('TWO') or ok2 then
            vde = 480
            vden = 'b'
            f = true
            s1 = 1.677
            s2 = 1.666
            p1 = 253.5
            p2 = -234.2
            okn = false
            ok4 = false
            ok3 = false
            ok2 = true
            ok1 = false
        end
        if keyboardJustPressed('THREE') or ok3 then
            vde = 720
            vden = 'c'
            f = true
            s1 = 1.111
            s2 = 1.11025
            p1 = 35.5
            p2 = -354.25
            okn = false
            ok4 = false
            ok3 = true
            ok2 = false
            ok1 = false
        end
        if keyboardJustPressed('FOUR') or ok4 then
            vde = 1080
            vden = 'd'
            f = true
            s1 = 0.742
            s2 = 0.741
            p1 = -284.7
            p2 = -534.3
            okn = false
            ok4 = true
            ok3 = false
            ok2 = false
            ok1 = false
        end
        if not (keyboardJustPressed('N') or okn) and f then
            setTextString("ret", "Video Resolution: "..vde..'p')
            playvideo = true
        else
            setTextString("ret", "No Video")
            vde = 'No Video'
            playvideo = false
            f = false
            okn = true
            ok4 = false
            ok3 = false
            ok2 = false
            ok1 = false
        end
    end
    if keyboardJustPressed('SPACE') or okc then
        callScript("modcharts/terry", "modccc",{modchart})
        removeLuaText("ret")
        removeLuaText("ret1")
        removeLuaText("ret2")
        removeLuaText("why")
        removeLuaText("coolguy")
        removeLuaSprite('hide')
        removeLuaSprite('button')
        removeLuaSprite('button1')
        removeLuaSprite('button2')
        removeLuaSprite('button3')
        removeLuaSprite('buttonn')
        removeLuaSprite('buttonc')
        allowCountdown = true
        startCountdown()
        removeLuaText('b1')
        removeLuaText('b2')
        removeLuaText('b3')
        removeLuaText('b4')
        removeLuaText('bn')
        removeLuaText('bc')
        setPropertyFromGroup('playerStrums',0,'alpha',0);
        setPropertyFromGroup('playerStrums',1,'alpha',0);
        setPropertyFromGroup('playerStrums',2,'alpha',0);
        setPropertyFromGroup('playerStrums',3,'alpha',0);
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
        removeLuaText("mc")
        removeLuaText("mct")
        removeLuaText('bm')
        removeLuaSprite('buttonc')
        removeLuaText('bc')
        removeLuaSprite('buttonm')
        if not playvideo then
            vde = 'No Video'
            playvideo = false
            f = false
        end
    end
end

function onUpdate()
    if not allowCountdown then
        buttonStuff()
    end
end

function onSongStart()
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    debugPrint('Current Offset: ','(',offset,')')
    if playvideo then
        setProperty('showRating', false);
        setProperty('showComboNum', false);
        runTimer('vid',(offset)/1000)
    end
    setProperty('camZoomingMult', 0)
    if botPlay then
        setTextString('botplayTxt', 'You could have tried you know')
        setTextSize("botplayTxt", 15)
        setProperty('botplayTxt.x', 0)
        setProperty('botplayTxt.y', screenHeight/1.025)
        setTextWidth("botplayTxt", screenWidth)
        setTextAlignment("botplayTxt", 'right')
        setObjectCamera("botplayTxt",'other')
    end
end

function onTimerCompleted(tag)
    if tag == 'vid' and playvideo then
        callScript('scripts/videoSprite', 'makeVideoSprite', {vden, vden, p1, p2, 'camGame', s1, s2})
    end
end
