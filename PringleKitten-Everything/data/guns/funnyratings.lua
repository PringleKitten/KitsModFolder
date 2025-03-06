local comb = 0
local hit = 0
local maxC = 0
local focus = false
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
    --Text Basics!
    luatxt("com", comb, 0, 0, screenHeight-28,"other",50,'.','.','left','.')
    luatxt("rated", hit, 0, 0, screenHeight-28,"other",50,'.','.','left','.')

    --Text Positioning
    setProperty('com.y',screenHeight/2)
    setProperty('com.x',screenWidth/5)
    setProperty("rated.x", screenWidth/5.5)
    setProperty("rated.y", screenHeight/2.5)

    defx = getProperty('com.x')
    defy = getProperty('com.y')
    setProperty('com.alpha',0)
    setProperty('rated.alpha',0)
end

function onBeatHit()
    if curBeat >= 129 and curBeat < 161 then
        setProperty('rated.alpha', 1)
        focus = true
        maxC = 42
        setProperty('com.alpha',1)
        setProperty('showComboNum', false);
    elseif curBeat == 161 then
        focus = false
        setProperty('com.alpha',0)
        setProperty('showComboNum', true);
        runTimer('rats', 2)
    elseif curBeat >= 225 and curBeat < 288 then
        setProperty('rated.alpha', 1)
        focus = true
        maxC = 76
        setProperty('com.alpha',1)
        setProperty('showComboNum', false);
    elseif curBeat == 288 then
        replay = true
    elseif curBeat == 300 then
        hit = 0
        comb = 0
        maxC = 72
        stringysi = (math.floor((hit/maxC)*10000)/100)
        setTextString("rated", (stringysi..'%'))
        setTextString("com", comb)
    elseif curBeat == 364 then
        hit = 0
        comb = 0
        maxC = 79
        stringysi = (math.floor((hit/maxC)*10000)/100)
        setTextString("rated", (stringysi..'%'))
        setTextString("com", comb)
    elseif curBeat == 417 then
        focus = false
        setProperty('com.alpha',0)
        setProperty('showComboNum', true);
        runTimer('rats', 2)
    end
end

function customRatingThing(m)
    if m then
        comb = 0
    elseif focus then
        comb = comb+1
        hit = hit+1
    end
    stringysi = (math.floor((hit/maxC)*10000)/100)
    setTextString("rated", (stringysi..'%'))
    setTextString("com", comb)
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
        customRatingThing(false)
        for _, value in pairs({'mtxtsx','mtxtsy','mtxtx','mtxty','txtsx','txtsy','txtx','txty'}) do
            cancelTween(value)
        end
        if comb < 10 then
            setProperty('com.scale.x', 3.6)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+43)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut")
        elseif comb >= 10 and comb < 100 then
            setProperty('com.scale.x', 3.4)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+40)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut")
        elseif comb >= 100 and comb < 1000 then
            setProperty('com.scale.x', 3)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+52)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut")
        elseif comb >= 1000 and comb < 10000 then
            setProperty('com.scale.x', 2.6)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+56)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut") 
        elseif comb >= 10000 and comb < 100000 then
            setProperty('com.scale.x', 2.2)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+56)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut")
        elseif comb >= 100000 and comb < 1000000 then
            setProperty('com.scale.x', 2)
            setProperty('com.scale.y', 2)
            setProperty('com.x', getProperty('com.x')+56)
            setProperty('com.y', getProperty('com.y')-11)
            doTweenX("txtsx", "com.scale", 1, 0.4, "expoOut")
            doTweenY("txtsy", "com.scale", 1, 0.4, "expoOut")
            doTweenX("txtx", "com", defx, 0.4, "expoOut")
            doTweenY("txty", "com", defy, 0.4, "expoOut") 
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
    setProperty('com.x', getProperty('com.x')-5)
    setProperty('com.y', getProperty('com.y')-3)
    doTweenX("mtxtsx", "com.scale", 1, 0.5, "expoOut")
    doTweenY("mtxtsy", "com.scale", 1, 0.5, "expoOut")
    doTweenX("mtxtx", "com", defx, 0.5, "expoOut")
    doTweenY("mtxty", "com", defy, 0.5, "expoOut")
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'rats' then
        if not replay then
            setProperty('rated.alpha', 0)
        end
        hit = 0
        comb = 0
    end
end 