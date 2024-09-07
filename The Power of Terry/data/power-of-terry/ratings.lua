local sks = 0
local gds = 0
local bds = 0
local brs = 0
local health = 0
local nr = 0
local comb = 0
local sizeee = 40
local letter = '?'

function onCreate()
    nr = (math.floor(rating*10000)/100)
    --Text Basics!
    makeLuaText("S", ("Sicks: "..sks), 0, 0, 0)
    makeLuaText("G", ("Goods: "..gds), 0, 0, 0)
    makeLuaText("B", ("Bads: "..bds), 0, 0, 0)
    makeLuaText("VB", ("Bruh: "..brs), 0, 0, 0)
    makeLuaText("Mss", ("Misses: "..misses), 0, 0, 0)
    makeLuaText("hp", ("Health: "..health), 0, 0, 0)
    makeLuaText("acc", (letter..' - '..nr.."%"), 1280, 0, 0)
    makeLuaText("sc", score, 1280, 0, 0)
    makeLuaText("com", comb, 0, 0, 0)

    setObjectCamera("S", "other")
    setObjectCamera("G", "other")
    setObjectCamera("B", "other")
    setObjectCamera("VB", "other")
    setObjectCamera("Mss", "other")
    setObjectCamera("hp", "other")
    setObjectCamera("acc", "other")
    setObjectCamera("sc", "other")
    setObjectCamera("com", "other")
    
    addLuaText("S")
    addLuaText("G")
    addLuaText("B")
    addLuaText("VB")
    addLuaText("Mss")
    addLuaText("hp")
    addLuaText("acc")
    addLuaText("sc")
    addLuaText("com")

    --Text Positioning
    screenCenter("S", 'y')
    screenCenter("G", 'y')
    screenCenter("B", 'y')
    screenCenter("VB", 'y')
    screenCenter("Mss", 'y')
    screenCenter("hp", 'y')
    screenCenter("acc", 'y')
    screenCenter("sc", 'y')
    screenCenter("com", 'y')
    y1 = getProperty('S.y')-60
    y2 = getProperty('G.y')-40
    y3 = getProperty('B.y')-20
    y4 = getProperty('Mss.y')+20
    y5 = getProperty('hp.y')+40
    y6 = 0
    y7 = 30
    x1 = 0
    y8 = screenHeight-28
    setProperty('S.y', y1)
    setProperty('G.y', y2)
    setProperty('B.y', y3)
    setProperty('Mss.y', y4)
    setProperty('hp.y', y5)
    setProperty('acc.y', y6)
    setProperty('sc.y', y7)
    setProperty('com.y', y8)
    setProperty('acc.x', x1)
    setProperty('sc.x', x1)

    --Text Properties!
    setTextSize("S", 20)
    setTextSize("G", 20)
    setTextSize("B", 20)
    setTextSize("VB", 20)
    setTextSize("Mss", 20)
    setTextSize("hp", 20)
    setTextSize("acc", 30)
    setTextSize("sc", 20)
    setTextSize("com", 30)
    setTextAlignment("S", 'left')
    setTextAlignment("G", 'left')
    setTextAlignment("B", 'left')
    setTextAlignment("VB", 'left')
    setTextAlignment("Mss", 'left')
    setTextAlignment("hp", 'left')
    setTextAlignment("acc", 'right')
    setTextAlignment("sc", 'right')
    setTextAlignment("com", 'left')
    setTextColor("S", "FF00FF")
    setTextColor("G", "00FF00")
    setTextColor("B", "FFFF00")
    setTextColor("VB", "FF7500")
    setTextColor("Mss", "FF0000")
    setTextColor("hp", "00FFFF")
    setTextColor("acc", "FFFFFF")
    setTextColor("sc", "FFFFFF")
    setTextColor("com", "FFFFFF")

    makeLuaSprite('beat', 'me/popup/beatthing',20,y1-70)
    setObjectCamera("beat", 'other')
    scaleObject("beat", 0.15, 0.15)
    addLuaSprite("beat")
end

function onBeatHit()
    if raa then
        doTweenColor("bcst", "beat", "FF0000", 0.1, "linear")
        raa = false
    else
        doTweenColor("bcst", "beat", "FFFFFF", 0.1, "linear")
        raa = true
    end
    setProperty('beat.scale.x',0.3)
    setProperty('beat.scale.y',0.3)
    doTweenX('btsx','beat.scale',0.15,0.4,'expoOut')
    doTweenY('btsy','beat.scale',0.15,0.4,'expoOut')
end

--This moves the rating text forward based on when the credits text show up, positions vary for the length of the credit names
function onCountdownTick(counter)
	if counter == 1 then
        doTweenX('xS','S', 325,0.4,'expoOut')
        doTweenX('xG','G', 325,0.4,'expoOut')
        doTweenX('xB','B', 325,0.4,'expoOut')
        doTweenX('xVB','VB', 325,0.4,'expoOut')
        doTweenX('xMss','Mss', 325,0.4,'expoOut')
        doTweenX('xhp','hp', 325,0.4,'expoOut')
    elseif counter == 2 then
        doTweenX('xxS','S', 700,0.4,'expoOut')
        doTweenX('xxG','G', 700,0.4,'expoOut')
        doTweenX('xxB','B', 700,0.4,'expoOut')
        doTweenX('xxVB','VB', 700,0.4,'expoOut')
        doTweenX('xxMss','Mss', 700,0.4,'expoOut')
        doTweenX('xxhp','hp', 700,0.4,'expoOut')
    elseif counter == 3 then
        runTimer('end4', 1.2, 1)
    end
end

function customRatingThing(m)
    if m then
        comb = 0
    else
        comb = comb+1
    end
    nr = (math.floor(rating*10000)/100)
    if nr >= 95 then
        setTextColor("acc", "FF00FF")
        letter = 'S'
    elseif nr >= 90 and nr < 95 then
        setTextColor("acc", "00FF00")
        letter = 'A'
    elseif nr < 90 and nr >= 80 then
        setTextColor("acc", "0075FF")
        letter = 'B'
    elseif nr < 80 and nr >= 70 then
        setTextColor("acc", "FFFF00")
        letter = 'C'
    elseif nr < 70 and nr >= 60 then
        setTextColor("acc", "FF7500")
        letter = 'D'
    elseif nr < 60 then
        setTextColor("acc", "FF0000")
        letter = 'F'
    end
    setTextString("acc", (letter..' - '..nr.."%"))
    setTextString("sc", score)
    setTextString("com", comb)
    setTextString("Mss", ("Misses: "..misses))
end

function onUpdate()
    health = (getProperty('health')*50)
    setTextString("hp", ("Health: "..health))
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if getPropertyFromGroup('notes',id,'rating') == 'sick' then
        sks = sks+1
    end
    if getPropertyFromGroup('notes',id,'rating') == 'good' then
        gds = gds+1
    end
    if getPropertyFromGroup('notes',id,'rating') == 'bad' then
        bds = bds+1
    end
    if getPropertyFromGroup('notes',id,'rating') == 'shit' then
        brs = brs+1
    end
    setTextString("S", ("Sicks: "..sks))
    setTextString("G", ("Goods: "..gds))
    setTextString("B", ("Bads: "..bds))
    setTextString("VB", ("Bruh: "..brs))
    if not isSustainNote then
        customRatingThing(false)
        cancelTween('mtxtsx')
        cancelTween('mtxtsy')
        cancelTween('mtxtx')
        cancelTween('mtxty')
        cancelTween('txtsx')
        cancelTween('txtsy')
        cancelTween('txtx')
        cancelTween('txty')
        if comb < 10 then
            setProperty('com.scale.x', 3.6)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 43)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut")
        elseif comb >= 10 and comb < 100 then
            setProperty('com.scale.x', 3.4)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 40)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut")
        elseif comb >= 100 and comb < 1000 then
            setProperty('com.scale.x', 3)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 52)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut")
        elseif comb >= 1000 and comb < 10000 then
            setProperty('com.scale.x', 2.6)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 56)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut") 
        elseif comb >= 10000 and comb < 100000 then
            setProperty('com.scale.x', 2.2)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 56)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut")
        elseif comb >= 100000 and comb < 1000000 then
            setProperty('com.scale.x', 2)
            setProperty('com.scale.y', 2)
            setProperty('com.x', 56)
            setProperty('com.y', screenHeight-39)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", 0, 0.4, "expoOut")
            doTweenY("txty", "com", screenHeight-28, 0.4, "expoOut") 
        end
        if comb >= 1000000 then
            setTextColor("com", "FF00FF")
        elseif comb < 1000000 then
            setTextColor("com", "FFFFFF")
        end
    end
end

function noteMiss(id, noteData, noteType, isSustainNote)
    customRatingThing(true)
    cancelTween('txtsx')
    cancelTween('txtsy')
    cancelTween('txtx')
    cancelTween('txty')
    cancelTween('mtxtsx')
    cancelTween('mtxtsy')
    cancelTween('mtxtx')
    cancelTween('mtxty')
    setProperty('com.scale.x', 0.25)
    setProperty('com.scale.y', 0.5)
    setProperty('com.x', -5)
    setProperty('com.y', screenHeight-25)
    doTweenX("mtxtsx", "com.scale", 1, 0.5, "expoOut")
    doTweenY("mtxtsy", "com.scale", 1, 0.5, "expoOut")
    doTweenX("mtxtx", "com", 0, 0.5, "expoOut")
    doTweenY("mtxty", "com", screenHeight-28, 0.5, "expoOut")
end

--When using credits, This makes the text go back after the credits.lua normal time length.
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'lol' then
        doTweenX('xS','S',0,0.5,'expoOut')
        doTweenX('xG','G',0,0.5,'expoOut')
        doTweenX('xB','B',0,0.5,'expoOut')
        doTweenX('xVB','VB',0,0.5,'expoOut')
        doTweenX('xMss','Mss',0,0.5,'expoOut')
        doTweenX('xhp','hp',0,0.5,'expoOut')
    end
    if tag == 'end4' then
        runTimer("lol", 0.2)
    end
end

--@PringleKitten's Very Simple Custom Ratings!