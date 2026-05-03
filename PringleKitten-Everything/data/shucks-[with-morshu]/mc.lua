callScript("scripts/LaneUnderlay", "noChoice")
callScript("scripts/ratings", "noChoice")

function onBeatHit()
    setProperty('camOne.visible', false)
    setProperty('camTwo.visible', false)
    if curBeat == 32 then
        for i = 0, 3 do
            noteTweenAlpha("fadeNote"..i, i, 1, 1, "linear")
        end
    elseif curBeat == 64 then
        for i = 4, 7 do
            noteTweenAlpha("fadeNote"..i, i, 1, 2.4, "linear")
        end
    elseif curBeat == 104 then
        for i = 0, 7 do
            noteTweenAlpha("fadeNote"..i, i, 0, 1, "linear")
        end
    elseif curBeat == 127 then
        for i = 0, 7 do
            noteTweenAlpha("fadeNote"..i, i, 1, 0.2, "linear")
        end
    elseif curBeat == 576 then
        bruh = true
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 580 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 584 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 588 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 592 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 596 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 600 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 604 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 608 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 612 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 616 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 620 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
    elseif curBeat == 624 then
        doTweenZoom('inh', 'hud', 1.2, 1,'cubeOut')
        doTweenZoom('ing', 'game', 1.5, 1,'cubeOut')
    elseif curBeat == 628 then
        doTweenZoom('inh', 'hud', 1, 1,'cubeIn')
        doTweenZoom('ing', 'game', 1, 1,'cubeIn')
        bruh = false
    elseif curBeat == 640 then
        for i = 0, 7 do
            noteTweenAlpha("fadeNote"..i, i, 0, 1, "linear")
        end
    elseif curBeat == 703 then
        for i = 0, 7 do
            noteTweenAlpha("fadeNote"..i, i, 1, 0.2, "linear")
        end
    elseif curBeat >= 800 and curBeat < 828 then
        if getProperty('health') > (5 / 50) and getProperty('health') < (2 / 50) then -- Health is from 0 to 2, so dividing the value by 50 allow to just turn it into percentage easly
			setProperty('health', (5 / 50))
		elseif getProperty('health') > (5 / 50) and getProperty('health') > (2 / 50) then
			setProperty('health', getProperty('health')-(2 / 50))
		end
        updHP()
        setProperty('camHUD.zoom', 1.22)
        setProperty('camGame.zoom', 1.22)
        setProperty('defaultCamZoom', 1.22)
        setProperty('defaultCamUIZoom', 1.22)
        doTweenZoom('inh', 'hud', 1, 0.3, 'sineOut')
        doTweenZoom('ing', 'game', 1, 0.3, 'sineOut')
        bruh = true
    elseif curBeat >= 832 and curBeat < 848 then
        if getProperty('health') > (5 / 50) and getProperty('health') < (2 / 50) then -- Health is from 0 to 2, so dividing the value by 50 allow to just turn it into percentage easly
			setProperty('health', (5 / 50))
		elseif getProperty('health') > (5 / 50) and getProperty('health') > (2 / 50) then
			setProperty('health', getProperty('health')-(2 / 50))
		end
        updHP()
        setProperty('camHUD.zoom', 1.22)
        setProperty('camGame.zoom', 1.22)
        setProperty('defaultCamZoom', 1.22)
        setProperty('defaultCamUIZoom', 1.22)
        doTweenZoom('inh', 'hud', 1, 0.3, 'sineOut')
        doTweenZoom('ing', 'game', 1, 0.3, 'sineOut')
        bruh = true
    elseif curBeat == 1120 then
        for i = 0, 7 do
            noteTweenAlpha("fadeNote"..i, i, 0, 5, "linear")
        end
    end
end

local letter = '?'
local nr = 0
local posXR = 0
local posYR = 0
function onCreatePost()
    for i = 0, 7 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0) -- instantly sets alpha
    end
    health = (getHealth()*50)
    nr = (math.floor(rating*10000)/100)
    luatxt("mainacc", (letter..' - '..nr.."%"), 1280, 0, 0,'other',30,'.','.','right','.')
    luatxt("mainsc", score, 1280, 0, 30,'other',25,'.','.','right','.')
    luatxt("mainhp", ("[Health] "..health), 1280, 0, 55,'other',25,'00AAFF','.','right','.')
        screenCenter("mainhp", 'x')
    luatxt("timeLeftText", "0:00", 200, 0, -2, 'other', 32, 'FF00FF', '.', 'center', '.')
        screenCenter("timeLeftText", 'x')
    luatxt("msText", 'ms', 200, 0, 0, 'other', 20, 'FFFFFF', '.', 'center', '.')
        screenCenter("msText",'xy')
        setProperty("msText.alpha", 0)
    setTextSize("botplayTxt", 25)
    setProperty('botplayTxt.x', 500)
    setProperty('botplayTxt.y', 0)
    setObjectCamera("botplayTxt",'other')
    setTextBorder('botplayTxt', 1, 'ff00ff')
    setTextColor('botplayTxt', '00ffff')
    setTextSize("practiceTxt", 25)
    setProperty('practiceTxt.x', 275)
    setProperty('practiceTxt.y', 0)
    setObjectCamera("practiceTxt",'other')
    setTextBorder('practiceTxt', 1, 'ff00ff')
    setTextColor('practiceTxt', 'ffff00')
end
function onUpdate()
    setTextString("timeLeftText", getProperty("timeTxt.text"))
    if curStep == 3309 or curStep == 3389 then
        bruh = false
        cancelTween('inh')
        cancelTween('ing')
        setProperty('defaultCamZoom', 1)
        setProperty('defaultCamUIZoom', 1)
    end
    if bruh then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
        setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
    end
end
function onCountdownStarted()
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
end
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
function txtSet(tag,w,a,t,o)
    setTextWidth(tag, w)
    setTextAlignment(tag,a)
    setTextString(tag, t)
    setObjectOrder(tag, o)
end
function customRatingThing(m)
    nr = math.floor(rating * 10000) / 100
    local ratingData = {
        {100, "00FFFF", "P"},
        {95, "FF00FF", "S"},
        {90, "00FF00", "A"},
        {80, "0075FF", "B"},
        {70, "FFFF00", "C"},
        {60, "FF7500", "D"},
        {0, "FF0000", "F"}
    }
    for _, data in ipairs(ratingData) do
        if nr >= data[1] then
            setTextColor("mainacc", data[2])
            letter = data[3]
            break
        end
    end
    setTextString("mainacc", string.format("%s - %.2f%%", letter, nr))
    setTextString("mainsc", score)
end
function goodNoteHit(id, noteData, noteType, isSustainNote)
    updHP()
    if not isSustainNote then
        customRatingThing(false)
        local ms = math.floor((getPropertyFromGroup('notes', id, 'strumTime') - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset'))*100)/100
        setProperty("msText.alpha", 1)
        setProperty("msText.x", getProperty('msText.x')+posXR)
        setProperty("msText.y", getProperty('msText.y')+posYR)
        setTextString("msText", ms..'ms')
        runTimer('hideMS',1.5)
    end
end
function noteMiss(id, noteData, noteType, isSustainNote)
    updHP()
    if not isSustainNote then
        customRatingThing(true)
    end
end
function updHP()
    health = (getHealth()*50)
    if health >= 100 then
        health = 100
    end
    if health <= 100 then
        setTextString("mainhp", ("[Health] "..health))
    end
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'hideMS' then
        setProperty("msText.alpha", 0)
    end
end
function onTweenCompleted(t)
    if t == 'inh' then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
        setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
    end
end