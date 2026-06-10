function noChoice()
	close()
end
if songName == 'final-boss' then
	close()
end

local position = 1 -- 1 is Left | 2 is Right
local uiType = 0 -- 0 is Psych UI | 1 is IFE UI | 2 is a Mix of both | 3 Is both but doesn't show "Perfects" and uses only health bar
local uiFollowsHideUIEvent = false -- For separate songs, make a lua script that calls this script to change this to true

function ifeUIJoin(uifhuie) -- Call this function in your call script
    uiFollowsHideUIEvent = uifhuie
end

local posXR = 0
local posYR = 0

local pfs = 0
local sks = 0
local gds = 0
local bds = 0
local brs = 0
local health = 0
local nr = 0
local comb = 0
local sizeee = 40
local letter = '?'
local wholeUI = {"mainP", "mainS", "mainG", "mainB", "mainVB", "mainMss", "mainhp", "mainbeat", "timeLeftText", "maincom", "mainsc", "mainacc"}

local died = 0

local combSettings = {
    {max = 10, scaleX = 3.6, x = 43},
    {max = 100, scaleX = 3.4, x = 40},
    {max = 1000, scaleX = 3, x = 52},
    {max = 10000, scaleX = 2.6, x = 56},
    {max = 100000, scaleX = 2.2, x = 56},
    {max = 1000000, scaleX = 2, x = 56}
}
function onEvent(n,v1,v2)
    if n == "Flash Camera" then
        cameraFlash('game', 'FFFFFF', v1, true)
    end
end
function onBeatHit()
    cameraFlash('game', 'FFFFFF', 0.1, true)
    if not hidingUI then
	    local bpm = getPropertyFromClass('backend.Conductor','bpm')
        local beatDur = 60 / bpm
        local tweenTime = beatDur * 0.3
        setProperty("mainbeat.color", getColorFromHex('00FF00'))
        doTweenColor("mainbcst", "mainbeat", "FF0000", tweenTime, "bounceIn")
        setProperty('mainbeat.scale.x',0.3)
        setProperty('mainbeat.scale.y',0.3)
        doTweenX('mainbtsx','mainbeat.scale',0.15,0.4,'expoOut')
        doTweenY('mainbtsy','mainbeat.scale',0.15,0.4,'expoOut')
    end
end

local function applyCombSettings(settings)
    setProperty('maincom.scale.x', settings.scaleX)
    setProperty('maincom.scale.y', 2)
    setProperty('maincom.x', settings.x)
    setProperty('maincom.y', screenHeight - 39)
    
    doTweenX("maintxtsx", "maincom.scale", 1, 0.4, "expoOut")
    doTweenY("maintxtsy", "maincom.scale", 1, 0.4, "expoOut")
    doTweenX("maintxtx", "maincom", 0, 0.4, "expoOut")
    doTweenY("maintxty", "maincom", screenHeight - 29, 0.4, "expoOut")
end

function ratingPosFunc(butnnP)
    if butnnP == 0 then
        if position == 1 then
            position = 2
        else
            position = 1
        end
    elseif butnnP == 1 then
        if position == 2 then
            position = 1
        else
            position = 2
        end
    end
    txtShit()
    aPpearE()
end

function rtsSetup(cam,ui)
    for _, obj in ipairs(wholeUI) do
        setObjectCamera(obj, cam)
    end
    gCam = cam
    uiType = ui
    ratingPosFunc()
end

function aPpearE()
    for _, obj in pairs({"mainP", "mainS", "mainG", "mainB", "mainVB", "mainMss", "mainhp", "mainbeat"}) do
        for _, objUI in pairs({'mainacc', 'mainsc', 'maincom', 'timeLeftText'}) do
            if uiType == 1 or uiType == 2 then
                setProperty(obj..'.alpha', 1)
                setProperty(objUI..'.alpha', 1)
                setProperty('mainMss.y',getProperty('mainVB.y')+20)
                setProperty('mainMss.x',0)
                if uiType == 2 then
                    setProperty("timeLeftText.y", getProperty("timeBar.y")-9)
                end
            elseif uiType == 0 then
                setProperty(obj..'.alpha', 0)
                setProperty(objUI..'.alpha', 0)
                setProperty("timeLeftText.y", -2)
            elseif uiType == 3 then
                setProperty(obj..'.alpha', 0)
                setProperty("mainMss.alpha", 1)
                setProperty(objUI..'.alpha', 1)
                setProperty('mainMss.y',getProperty('timeLeftText.y')+30)
                screenCenter("mainMss", 'x')
                setProperty('mainMss.x',getProperty('mainMss.x')-7)
                setProperty("timeLeftText.y", -2)
            end
        end
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

function onCreatePost()
    health = (getHealth()*50)
    nr = (math.floor(rating*10000)/100)
    --Text Basics!
    luatxt("msText", 'ms', 100, 0, 0, 'other', 20, 'FFFFFF', '.', 'center', '.')
        screenCenter("msText",'xy')
        setProperty("msText.alpha", 0)
    luatxt("mainP", ("[Perfects] "..pfs), 0, 0, 0,'other',20,'00FFFF','y','left','.')
    luatxt("mainS", ("[Sicks] "..sks), 0, 0, 0,'other',20,'FF00FF','y','left','.')
    luatxt("mainG", ("[Goods] "..gds), 0, 0, 0,'other',20,'00FF00','y','left','.')
    luatxt("mainB", ("[Bads] "..bds), 0, 0, 0,'other',20,'FFFF00','y','left','.')
    luatxt("mainVB", ("[Bruh] "..brs), 0, 0, 0,'other',20,'FF7500','y','left','.')
    luatxt("mainMss", ("[Misses] "..misses), 0, 0, 0,'other',20,'FF0000','y','left','.')
    luatxt("mainhp", ("[Health] "..health), 0, 0, 0,'other',20,'00AAFF','y','left','.')
    luatxt("mainacc", (letter..' - '..nr.."%"), 1280, 0, 0,'other',30,'.','.','right','.')
    luatxt("mainsc", score, 1280, 0, 0,'other',20,'.','.','right','.')
    luatxt("maincom", comb, 0, 0, screenHeight-29,'other',30,'.','.','left','.')
    luatxt("timeLeftText", "0:00", 100, 0, -2, 'other', 32, 'FF00FF', '.', 'center', '.')
    --Text Positioning
    setProperty("mainVB.y",getProperty("mainVB.y")+20)
    setProperty('mainP.y',getProperty('mainVB.y')-80)
    setProperty('mainS.y',getProperty('mainVB.y')-60)
    setProperty('mainG.y',getProperty('mainVB.y')-40)
    setProperty('mainB.y',getProperty('mainVB.y')-20)
    setProperty('mainMss.y',getProperty('mainVB.y')+20)
    setProperty('mainhp.y',getProperty('mainVB.y')+40)
    setProperty('mainacc.y',0)
    setProperty('mainsc.y',30)
    setProperty('maincom.y',screenHeight-29)

    makeLuaSprite('mainbeat', 'me/popup/beatthing',40,getProperty('mainP.y')-60)
    setObjectCamera("mainbeat", 'other')
    scaleObject("mainbeat", 0.15, 0.15)
    addLuaSprite("mainbeat")

    setObjectOrder("mainacc", 107)
    setObjectOrder("mainsc", 108)
    setObjectOrder("maincom", 109)
    setObjectOrder("timeLeftText", 110)
    screenCenter("timeLeftText", 'x')
    tTy = getProperty('timeTxt.y')
    txtShit()
end

function txtShit()
    if position == 1 then
        txtSet('mainP',0,'left',("[Perfects] "..pfs),100)
        txtSet('mainS',0,'left',("[Sicks] "..sks),101)
        txtSet('mainG',0,'left',("[Goods] "..gds),102)
        txtSet('mainB',0,'left',("[Bads] "..bds),103)
        txtSet('mainVB',0,'left',("[Bruh] "..brs),104)
        txtSet('mainMss',0,'left',("[Misses] "..misses),105)
        txtSet('mainhp',0,'left',("[Health] "..health),106)
        setProperty("mainbeat.x", 40)
        mBeatX = 40
    elseif position == 2 then
        txtSet('mainP',1280,'right',(pfs.." [Perfects]"),100)
        txtSet('mainS',1280,'right',(sks.." [Sicks]"),101)
        txtSet('mainG',1280,'right',(gds.." [Goods]"),102)
        txtSet('mainB',1280,'right',(bds.." [Bads]"),103)
        txtSet('mainVB',1280,'right',(brs.." [Bruh]"),104)
        txtSet('mainMss',1280,'right',(misses.." [Misses]"),105)
        txtSet('mainhp',1280,'right',(health.." [Health]"),106)
        setProperty("mainbeat.x", 1200)
        mBeatX = 1200
    end
end

function onSongStart()
    local objects = {'mainP', 'mainS', 'mainG', 'mainB', 'mainVB', 'mainMss', 'mainhp', 'mainbeat'}
    if uiType == 0 then
        setProperty('healthBar.alpha', 1);
        setProperty('healthBarBG.alpha', 1);
        setProperty('iconP1.alpha', 1);
        setProperty('iconP2.alpha', 1);
        setProperty('scoreTxt.alpha', 1);
        setProperty('timeBar.visible', true)
        setProperty('timeTxt.y', tTy)
        setObjectCamera("timeTxt", 'hud')
        for _, obj in ipairs(wholeUI) do
            removeLuaText(obj)
            removeLuaSprite(obj)
        end
        runTimer('closeScript', 0.2)
    elseif uiType == 1 then
        setProperty('healthBar.alpha', 0);
        setProperty('healthBarBG.alpha', 0);
        setProperty('iconP1.alpha', 0);
        setProperty('iconP2.alpha', 0);
        setProperty('scoreTxt.alpha', 0);
        setProperty('timeBar.visible', false)
        for _, obj in ipairs(objects) do
            setProperty(obj .. ".alpha", 1)
        end
    elseif uiType == 2 then
        setProperty('healthBar.alpha', 1);
        setProperty('healthBarBG.alpha', 1);
        setProperty('iconP1.alpha', 1);
        setProperty('iconP2.alpha', 1);
        setProperty('scoreTxt.alpha', 1);
        setProperty('timeBar.visible', true)
        setProperty('timeTxt.visible', true)
        setProperty('timeTxt.y', tTy)
        for _, obj in ipairs(objects) do
            setProperty(obj .. ".alpha", 1)
        end
    elseif uiType == 3 then
        setProperty('healthBar.alpha', 1);
        setProperty('healthBarBG.alpha', 1);
        setProperty('iconP1.alpha', 1);
        setProperty('iconP2.alpha', 1);
        setProperty('scoreTxt.alpha', 0);
        setProperty('timeBar.visible', false)
        setProperty('timeTxt.visible', false)
        for _, obj in pairs({'mainP', 'mainS', 'mainG', 'mainB', 'mainVB', 'mainhp'}) do
            removeLuaText(obj)
        end
        removeLuaSprite("mainbeat")
    end
    allowCountdown = true
end

--This moves the rating text forward based on when the credits text show up, positions vary for the length of the credit names
function onCountdownTick(counter)
    allowCountdown = true
    if counter == 2 and uiType == 0 then
        close()
    end
end
function customRatingThing(m)
    comb = m and 0 or comb + 1
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
    setTextString("maincom", comb)
    txtShit()
end

function updHP()
    if allowCountdown then
        health = (getHealth()*50)
        if health >= 100 then
            health = 100
        end
        if health <= 100 then
            if position == 1 then
                setTextString("mainhp", ("[Health] "..health))
            elseif position == 2 then 
                setTextString("mainhp", (health.." [Health]"))
            end
        end
    end
end

function onUpdate()
    if getProperty('inCutscene') and not doneIt then
        setProperty("mainP.alpha", 0)
        setProperty("mainS.alpha", 0)
        setProperty("mainG.alpha", 0)
        setProperty("mainB.alpha", 0)
        setProperty("mainVB.alpha", 0)
        setProperty("mainMss.alpha", 0)
        setProperty("mainhp.alpha", 0)
        setProperty("mainsc.alpha", 0)
        setProperty("mainacc.alpha", 0)
        setProperty("maincom.alpha", 0)
        setProperty("mainbeat.alpha", 0)
        doneIt = true
    end
    if not getProperty('inCutscene') and doneIt then
        setProperty("mainP.alpha", 1)
        setProperty("mainS.alpha", 1)
        setProperty("mainG.alpha", 1)
        setProperty("mainB.alpha", 1)
        setProperty("mainVB.alpha", 1)
        setProperty("mainMss.alpha", 1)
        setProperty("mainhp.alpha", 1)
        setProperty("mainsc.alpha", 1)
        setProperty("mainacc.alpha", 1)
        setProperty("maincom.alpha", 1)
        setProperty("mainbeat.alpha", 1)
        doneIt = false
    end
     if (uiType == 1 and (getProperty('iconP1.alpha') == 1 or getProperty('healthBarBG.alpha') == 1 or getProperty('timeBar.visible') == true)) then
         setProperty('healthBar.alpha', 0);
         setProperty('healthBarBG.alpha', 0);
         setProperty('iconP1.alpha', 0);
         setProperty('iconP2.alpha', 0);
         setProperty('scoreTxt.alpha', 0);
         setProperty('timeBar.visible', false)
         setProperty('timeTxt.visible', false)
     elseif uiType == 3 and getProperty('scoreTxt.alpha') > 0 then
        setProperty('healthBar.alpha', 1);
        setProperty('healthBarBG.alpha', 1);
        setProperty('iconP1.alpha', 1);
        setProperty('iconP2.alpha', 1);
        setProperty('scoreTxt.alpha', 0);
        setProperty('timeBar.visible', false)
        setProperty('timeTxt.visible', false)
     elseif uiType == 2 then
        if not (getProperty("timeLeftText.y") == (getProperty("timeBar.y")-9)) then
            setProperty("timeLeftText.y", getProperty("timeBar.y")-9)
        end
        if getProperty("timeTxt.visible") then
            setProperty("timeTxt.visible", false)
        end
     end
     if allowCountdown then
         updHP()
     end
     setTextString("timeLeftText", getProperty("timeTxt.text"))
 end        

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if getPropertyFromGroup('notes',id,'rating') == 'perfect' then
        pfs = pfs+1
    end
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
    if not isSustainNote then
        customRatingThing(false)
        local ms = math.floor((getPropertyFromGroup('notes', id, 'strumTime') - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset'))*100)/100
        setProperty("msText.alpha", 1)
        setProperty("msText.x", getProperty('msText.x')+posXR)
        setProperty("msText.y", getProperty('msText.y')+posYR)
        setTextString("msText", ms..'ms')
        runTimer('hideMS',1.5)
        for _, value in pairs({'mainmtxtsx','mainmtxtsy','mainmtxtx','mainmtxty','maintxtsx','maintxtsy','maintxtx','maintxty'}) do
            cancelTween(value)
        end
        for _, setting in ipairs(combSettings) do
            if comb < setting.max then
                applyCombSettings(setting)
                break
            end
        end
        if comb >= 1000000 then
            setTextColor("maincom", "FF00FF")
        elseif comb < 1000000 then
            setTextColor("maincom", "FFFFFF")
        end
    end
    updHP()
end

function noteMiss(id, noteData, noteType, isSustainNote)
    customRatingThing(true)
    for _, value in pairs({'mainmtxtsx','mainmtxtsy','mainmtxtx','mainmtxty','maintxtsx','maintxtsy','maintxtx','maintxty'}) do
        cancelTween(value)
    end
    setProperty('maincom.scale.x', 0.25)
    setProperty('maincom.scale.y', 0.5)
    setProperty('maincom.x', -5)
    setProperty('maincom.y', screenHeight-25)
    doTweenX("mainmtxtsx", "maincom.scale", 1, 0.5, "expoOut")
    doTweenY("mainmtxtsy", "maincom.scale", 1, 0.5, "expoOut")
    doTweenX("mainmtxtx", "maincom", 0, 0.5, "expoOut")
    doTweenY("mainmtxty", "maincom", screenHeight-28, 0.5, "expoOut")
    updHP()
end

--When using credits, This makes the text go back after the credits.lua normal time length.
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'closeScript' then
        close()
    end
    if tag == 'hideMS' then
        setProperty("msText.alpha", 0)
    end
end

--@PringleKitten's Very Simple Custom Ratings!