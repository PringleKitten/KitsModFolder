local offset = 0
local vde = "No Video"
local s1 = 0
local s2 = 0
local f = false
local playvideo = false
allowCountdown = false

function onCreate()
    makeLuaSprite('hide', 'me/popup/dim',0,0)
    setObjectCamera("hide", 'other')
    setScrollFactor("hide", 0, 0)
    setGraphicSize("hide", screenWidth, screenHeight)
    addLuaSprite('hide', true)

    makeLuaText("ret", ("Video Quality: "..vde..'p'), screenWidth, 0.0, 0.0)
    makeLuaText("ret1", "Press 1-6 to choose Quality", screenWidth, 0.0, screenHeight/1.75)
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
    
    addLuaText("ret")
    addLuaText("ret1")
    addLuaText("ret2")
    addLuaText("why")
    addLuaText("coolguy")
end
function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		return Function_Continue
	end
end
function onUpdate()
    if not allowCountdown then
        if keyboardJustPressed('ONE') then
            vde = 360
            vden = 'a'
            f = true
            s1 = 2.222
            s2 = 2.2205
            p1 = 355.5
            p2 = -174.3
        elseif keyboardJustPressed('TWO') then
            vde = 480
            vden = 'b'
            f = true
            s1 = 1.677
            s2 = 1.666
            p1 = 253.5
            p2 = -234.2
        elseif keyboardJustPressed('THREE') then
            vde = 720
            vden = 'c'
            f = true
            s1 = 1.111
            s2 = 1.11025
            p1 = 35.5
            p2 = -354.25
        elseif keyboardJustPressed('FOUR') then
            vde = 1080
            vden = 'd'
            f = true
            s1 = 0.742
            s2 = 0.741
            p1 = -284.7
            p2 = -534.3
        elseif keyboardJustPressed('FIVE') then
            vde = 1440
            vden = 'e'
            f = true
            s1 = 0.7404
            s2 = 0.7408
            p1 = -119
            p2 = -441
        elseif keyboardJustPressed('SIX') then
            vde = 2160
            vden = 'f'
            f = true
            s1 = 0.7404
            s2 = 0.7408
            p1 = -119
            p2 = -441
        end
        if not keyboardJustPressed('N') and f then
            setTextString("ret", "Video Resolution: "..vde..'p')
            playvideo = true
        else
            setTextString("ret", "No Video")
            vde = 'No Video'
            playvideo = false
            f = false
        end
    end
    if keyboardJustPressed('SPACE') then
        removeLuaText("ret")
        removeLuaText("ret1")
        removeLuaText("ret2")
        removeLuaText("why")
        removeLuaText("coolguy")
        removeLuaSprite('hide')
        allowCountdown = true
        startCountdown()
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
        if not playvideo then
            vde = 'No Video'
            playvideo = false
            f = false
        end
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
end

function onTimerCompleted(tag)
    if tag == 'vid' and playvideo then
        callScript('scripts/videoSprite', 'makeVideoSprite', {vden, vden, p1, p2, 'camGame', s1, s2})
    end
end
