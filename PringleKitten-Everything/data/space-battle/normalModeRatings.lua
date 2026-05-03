if assetMovement or mechanicsAgain then
    close()
end
local letter = '?'
local nr = 0
local posXR = 0
local posYR = 0
function onCreate()
    if not downscroll then
        setProperty('botplayTxt.y',90)
        setProperty('practiceTxt.y', 90)
    else
        setProperty('botplayTxt.y',610)
        setProperty('practiceTxt.y', 610)
    end
    health = (getHealth()*50)
    nr = (math.floor(rating*10000)/100)
    luatxt("mainacc", (letter..' - '..nr.."%"), 1280, 0, 25,'other',30,'.','.','right','.')
    luatxt("mainsc", score, 1280, 0, 55,'other',25,'.','.','right','.')
    luatxt("mainhp", ("[Health] "..health), 1280, 0, 0,'other',25,'00AAFF','.','right','.')
        screenCenter("mainhp", 'x')
    luatxt("timeLeftText", "0:00", 200, 0, -2, 'other', 32, 'FF00FF', '.', 'center', '.')
        screenCenter("timeLeftText", 'x')
    luatxt("msText", 'ms', 200, 0, 0, 'other', 20, 'FFFFFF', '.', 'center', '.')
        screenCenter("msText",'xy')
        setProperty("msText.alpha", 0)
    setProperty('botplayTxt.x', 105)
    setProperty('practiceTxt.x', 710)
    setTextSize("botplayTxt", 25)
    setTextSize("practiceTxt", 25)
    setTextBorder('botplayTxt', 1, 'ff00ff')
    setTextColor('botplayTxt', '00ffff')
    setTextBorder('practiceTxt', 1, 'ff00ff')
    setTextColor('practiceTxt', 'ffff00')
end
function onUpdate()
    setTextString("timeLeftText", getProperty("timeTxt.text"))
end
function goodNoteHit(index, noteDir, noteType, isSustainNote)
    updHP()
    if not isSustainNote then
        customRatingThing(false)
        local ms = math.floor((getPropertyFromGroup('notes', index, 'strumTime') - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset'))*100)/100
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
function onTimerCompleted(tag)
    if tag == 'hideMS' then
        setProperty("msText.alpha", 0)
    end
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