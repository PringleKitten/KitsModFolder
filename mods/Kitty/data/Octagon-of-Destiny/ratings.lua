local sks = 0
local gds = 0
local bds = 0
local brs = 0
local health = 0
local nr = 0
local comb = 0
local sizeee = 40
local letter = '?'

function luatxt(tag,txt,w,x,y,cam,ts,tc,sc,ali,f) -- set certain values to '.' for default or no value
    makeLuaText(tag,txt,w,x,y)
    setObjectCamera(tag,cam)
    setTextSize(tag, ts)
    if tc == '.' then
        tc = 'FFFFFF'
    end
    setTextColor(tag, tc)
    if sc ~= '.' then
        screenCenter(tag, sc)
    end
    if ali == '.' then
        ali = 'center'
    end
    setTextAlignment(tag, ali)
    if f == '.' then
        f = false
    end
    addLuaText(tag,f)
end

function onCreate()
    nr = (math.floor(rating*10000)/100)
    --Text Basics!

    luatxt("S", ("Sicks: "..sks), 0, 0, 0,"other",20,'FF00FF','y','left','.')
    luatxt("G", ("Goods: "..gds), 0, 0, 0,"other",20,'00FF00','y','left','.')
    luatxt("B", ("Bads: "..bds), 0, 0, 0,"other",20,'FFFF00','y','left','.')
    luatxt("VB", ("Bruh: "..brs), 0, 0, 0,"other",20,'FF7500','y','left','.')
    luatxt("Mss", ("Misses: "..misses), 0, 0, 0,"other",20,'FF0000','y','left','.')
    luatxt("hp", ("Health: "..health), 0, 0, 0,"other",20,'00FFFF','y','left','.')
    luatxt("acc", (letter..' - '..nr.."%"), 1280, 0, 0,"other",30,'.','.','right','.')
    luatxt("sc", score, 1280, 0, 0,"other",20,'.','.','right','.')
    luatxt("com", comb, 0, 0, screenHeight-28,"other",30,'.','.','left','.')

    --Text Positioning
    setProperty('S.y',getProperty('S.y')-60)
    setProperty('G.y',getProperty('G.y')-40)
    setProperty('B.y',getProperty('B.y')-20)
    setProperty('Mss.y',getProperty('Mss.y')+20)
    setProperty('hp.y',getProperty('hp.y')+40)
    setProperty('acc.y',0)
    setProperty('sc.y',30)
    setProperty('com.y',screenHeight-28)

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
        doTweenColor("bcst", "beat", ".", 0.1, "linear")
        raa = true
    end
    setProperty('beat.scale.x',0.3)
    setProperty('beat.scale.y',0.3)
    doTweenX('btsx','beat.scale',0.15,0.4,'expoOut')
    doTweenY('btsy','beat.scale',0.15,0.4,'expoOut')
end

--This moves the rating text forward based on when the credits text show up, positions vary for the length of the credit names
function onCountdownTick(counter)
    if counter == 2 then
        doTweenX('xS','S',600,0.5,'expoOut')
        doTweenX('xG','G',600,0.5,'expoOut')
        doTweenX('xB','B',600,0.5,'expoOut')
        doTweenX('xVB','VB',600,0.5,'expoOut')
        doTweenX('xMss','Mss',600,0.5,'expoOut')
        doTweenX('xhp','hp',600,0.5,'expoOut')
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
        for _, value in pairs({'mtxtsx','mtxtsy','mtxtx','mtxty','txtsx','txtsy','txtx','txty'}) do
            cancelTween(value)
        end
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
    for _, value in pairs({'mtxtsx','mtxtsy','mtxtx','mtxty','txtsx','txtsy','txtx','txty'}) do
        cancelTween(value)
    end
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