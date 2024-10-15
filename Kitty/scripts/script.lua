--CHECK THESE WHEN YOU CAN FOR CUSTOM OPTIONS WITHOUT MY ENGINE
local penalizeanyway = false -- If you have a bad rating, this will penalize you like in Kade Engine
local botherme = true


local bugged = false
local kadezoom = false
local stopui = false
local stopcam = false
local czm = 1
local czmu = 1
local czmc = 1
function onCreate()
    precacheImage('me/popup/bars')
    setProperty('skipArrowStartTween', true)
    makeLuaText('st', 'l', '800', 400,450)
    addLuaText('st')
    setTextSize('st', 50)
    setTextAlignment('st', 'center')
    setProperty('st.x', (screenWidth/2)-(getProperty('st.width')/2))
    setObjectCamera('st', 'other')
    setProperty('st.alpha', 0)
    makeLuaSprite('bars', 'me/popup/bars', 0,0)
    setObjectCamera('bars', 'hud')
    addLuaSprite('bars')
    setProperty('bars.scale.x', 2)
    setProperty('bars.scale.y', 2)
    setProperty('bars.alpha', 0)
end

function onSongStart()
        makeLuaText("drawfps", drawf, 0, 0.0, 0.0)
        setTextSize("drawfps", 20)
        setObjectCamera("drawfps", 'other')
        addLuaText("drawfps")
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' and botherme then
        debugPrint('Different engine recognized? WILL NOT penalize player for bad ratings unless you change the setting to (local penalizeanyway = true) in mods/kitty/scripts/script.lua!')
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
    end
    if getPropertyFromClass('ClientPrefs','assetMovement') == 'assetMovement' and botherme then
        debugPrint('Different engine recognized? Modcharts will CONTINUE to be used unless you change the setting to (local visuals = false) in...')
        debugPrint('Modchart Scripts: (scripts/eventConvertScript) (custom_events/  MoveArrow - or moveOPPONENT(or PLAYER)Strumline(X)(Y) - or moveStrumline - or newArrowToggler - or Tilt - or WindowCrap(or Dance)')
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
    end
    if getPropertyFromClass('ClientPrefs','mechanics') == 'mechanics' and botherme then
        debugPrint('Different engine recognized? Mechanics will CONTINUE to be used unless you change the setting to (local mechanics = false) in...')
        debugPrint('Mechanic Scripts: (custom_events/  customDodgeKey - or DodgeEvent(or ForBF) - or hitkey')
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
    end
    debugPrint('- - -')
    debugPrint('Current Offset: ','(',offset,')')
    debugPrint('- - -')
    debugPrint(' | ')
    debugPrint(' | ')
    dpsx0 = getPropertyFromGroup('playerStrums', 0, 'x')
    dpsx1 = getPropertyFromGroup('playerStrums', 1, 'x')
    dpsx2 = getPropertyFromGroup('playerStrums', 2, 'x')
    dpsx3 = getPropertyFromGroup('playerStrums', 3, 'x')
    dosx0 = getPropertyFromGroup('opponentStrums', 0, 'x')
    dosx1 = getPropertyFromGroup('opponentStrums', 1, 'x')
    dosx2 = getPropertyFromGroup('opponentStrums', 2, 'x')
    dosx3 = getPropertyFromGroup('opponentStrums', 3, 'x')
    dpsy0 = getPropertyFromGroup('playerStrums', 0, 'y')
    dpsy1 = getPropertyFromGroup('playerStrums', 1, 'y')
    dpsy2 = getPropertyFromGroup('playerStrums', 2, 'y')
    dpsy3 = getPropertyFromGroup('playerStrums', 3, 'y')
    dosy0 = getPropertyFromGroup('opponentStrums', 0, 'y')
    dosy1 = getPropertyFromGroup('opponentStrums', 1, 'y')
    dosy2 = getPropertyFromGroup('opponentStrums', 2, 'y')
    dosy3 = getPropertyFromGroup('opponentStrums', 3, 'y')
    setProperty('bars.alpha', 1);
    doTweenY('ba', 'bars.scale', 1.1, 1, 'quadInOut')
    setObjectCamera('bars', 'other')
    setObjectCamera('bars', 'hud')
    screenCenter('bars')
    setProperty('bars.alpha', 0)
    doTweenY('ba', 'bars.scale', 3, 0.1, 'quadInOut')
    doTweenZoom('camz','camHUD',1,0.01,'sineInOut')
    setProperty("defaultCamUIZoom",getProperty('camHUD.zoom')) 
    setPropertyFromClass("openfl.Lib", "application.window.title", songName)
    if getProperty('defaultCamUIZoom') ~= 'defaultCamUIZoom' then
        dcuiz = getProperty('defaultCamUIZoom')
    end
    dcgz = getProperty('defaultCamZoom')
    czm = getProperty('camZoomingMult')
end

function goodNoteHit()
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' then
        penalizeanyway = false
        bugged = true
    end
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true and penalizeanyway then
        if getProperty('ratingPercent') < 0.9 and getProperty('ratingPercent') > 0.85 then
            setProperty('health', getProperty('health') + 0.01)
        elseif getProperty('ratingPercent') < 0.85 and getProperty('ratingPercent') > 0.8 then
            setProperty('health', getProperty('health') + 0.02)
        elseif getProperty('ratingPercent') < 0.8 and getProperty('ratingPercent') > 0.75 then
            setProperty('health', getProperty('health') + 0.03)
        elseif getProperty('ratingPercent') < 0.7 and getProperty('ratingPercent') > 0.65 then
            setProperty('health', getProperty('health') + 0.04)
        elseif getProperty('ratingPercent') < 0.6 and getProperty('ratingPercent') > 0 then
            setProperty('health', getProperty('health') + 0.05)
        end
    end
end

function noteMiss()
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' then
        penalizeanyway = false
        bugged = true
    end
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true and penalizeanyway then
        if getProperty('ratingPercent') < 0.86 and getProperty('ratingPercent') > 0.8 then
            setProperty('health', getProperty('health') - 0.1)
        elseif getProperty('ratingPercent') < 0.78 and getProperty('ratingPercent') > 0.7 then
            setProperty('health', getProperty('health') - 0.12)
        elseif getProperty('ratingPercent') < 0.67 and getProperty('ratingPercent') > 0.63 then
            setProperty('health', getProperty('health') - 0.16)
        elseif getProperty('ratingPercent') < 0.6 and getProperty('ratingPercent') > 0.55 then
            setProperty('health', getProperty('health') - 0.2)
        elseif getProperty('ratingPercent') < 0.53 and getProperty('ratingPercent') > 0 then
            setProperty('health', getProperty('health') - 0.23)
        end
    end
end

function onEvent(name, value1, value2)
    if name == 'newArrowToggler' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 3 or value1 == 33 then
            mdsc = true
        elseif value1 == 2 then
            mdsc = false
            ls = true
        end
    end
    if name == 'movePLAYERStrumline (X)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 0 and mdsc then
            noteTweenX("pX",4,dosx0-323,value2,"cubeInOut");
            noteTweenX("pX1",5,dosx1-323,value2,"cubeInOut");
            noteTweenX("pX2",6,dosx2-323,value2,"cubeInOut");
            noteTweenX("pX3",7,dosx3-323,value2,"cubeInOut");
        elseif value1 == 0 and not mdsc then
            noteTweenX("pX",4,dosx0,value2,"cubeInOut");
            noteTweenX("pX1",5,dosx1,value2,"cubeInOut");
            noteTweenX("pX2",6,dosx2,value2,"cubeInOut");
            noteTweenX("pX3",7,dosx3,value2,"cubeInOut");
        elseif value1 == 0 and ls then
            noteTweenX("pX",4,defaultOpponentStrumX0,value2,"cubeInOut");
            noteTweenX("pX1",5,defaultOpponentStrumX1,value2,"cubeInOut");
            noteTweenX("pX2",6,defaultOpponentStrumX2,value2,"cubeInOut");
            noteTweenX("pX3",7,defaultOpponentStrumX3,value2,"cubeInOut");
        end
    end
    if name == 'movePLAYERStrumline (Y)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 0 then
            noteTweenY("pY",4,dosy0,value2,"cubeInOut");
            noteTweenY("pY1",5,dosy1,value2,"cubeInOut");
            noteTweenY("pY2",6,dosy2,value2,"cubeInOut");
            noteTweenY("pY3",7,dosy3,value2,"cubeInOut");
        end
    end
    if name == 'moveOPPONENTStrumline (Y)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 0 then
            noteTweenY("oY",4,dosy0,value2,"cubeInOut");
            noteTweenY("oY1",5,dosy1,value2,"cubeInOut");
            noteTweenY("oY2",6,dosy2,value2,"cubeInOut");
            noteTweenY("oY3",7,dosy3,value2,"cubeInOut");
        end
    end
    if name == 'moveOPPONENTStrumline (X)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 0 and mdsc then
            noteTweenX("oX",0,dosx0+75,value2,"cubeInOut");
            noteTweenX("oX1",1,dosx1+75,value2,"cubeInOut");
            noteTweenX("oX2",2,dosx2-79,value2,"cubeInOut");
            noteTweenX("oX3",3,dosx3-79,value2,"cubeInOut");
        elseif value1 == 0 and not mdsc then
            noteTweenX("oX",0,dosx0,value2,"cubeInOut");
            noteTweenX("oX1",1,dosx1,value2,"cubeInOut");
            noteTweenX("oX2",2,dosx2,value2,"cubeInOut");
            noteTweenX("oX3",3,dosx3,value2,"cubeInOut");
        elseif value1 == 0 and ls then
            noteTweenX("oX",0,defaultPlayerStrumX0,value2,"cubeInOut");
            noteTweenX("oX1",1,defaultPlayerStrumX1,value2,"cubeInOut");
            noteTweenX("oX2",2,defaultPlayerStrumX2,value2,"cubeInOut");
            noteTweenX("oX3",3,defaultPlayerStrumX3,value2,"cubeInOut");
        end
    end
    if name == "hudzoom" then 
        value1 = tonumber(value1)
        value2 = tonumber(value2)       
        if value2 == '' then
			doTweenZoom('camzz','camHUD',tonumber(value1),0.01,'sineInOut')
	    else
            doTweenZoom('camzz','camHUD',tonumber(value1),tonumber(value2),'sineInOut')
	    end
    end
    if not bugged then
        if name == "kadezoomtoggle" then
            value1 = tonumber(value1)
            value2 = tonumber(value2)
            if value1 == 1 then
                czm = 0
                kadezoom = true
            else
                kadezoom = false
                czm = 1
            end
            setProperty('camZoomingMult', czm)
        end
    end
    if name == "nozoom" then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 1 then
            stopcam = true
            czmc = 0
            setProperty('camZoomingMult', 0)
            --setPropertyFromClass('ClientPrefs', 'bgZoomSections', false)--WHY ARENT THESE WORKING?!!?
            --debugPrint('czm = 0 due to event')
        elseif value1 == 0 then
            stopcam = false
            czmc = 1
            setProperty('camZoomingMult', 1)
            --setPropertyFromClass('ClientPrefs', 'bgZoomSections', true)--WHY ARENT THESE WORKING?!!?
        end
        if value2 == 1 then
            stopui = true
            czmu = 0
            setProperty('camZoomingMult', 0)
            --setPropertyFromClass('ClientPrefs', 'hudZoomSections', false) --WHY ARENT THESE WORKING?!!?
        elseif value2 == 0 then
            stopui = false
            czmu = 1
            setProperty('camZoomingMult', 1)
            --setPropertyFromClass('ClientPrefs', 'hudZoomSections', true) --WHY ARENT THESE WORKING?!!?
        end
    end
end

function onUpdate(elapsed)
    drawf = getPropertyFromClass("Main", "fpsVar.text")
    setTextString("drawfps", drawf)
    el = elapsed
    --debugPrint('onupdate','|',czm)
    if kadezoom == true then
        if stopui == false then
            doTweenZoom('tweeningZoom', 'camHUD', dcuiz, 0.15, 'quadOut')
        end
        if stopcam == false then
            doTweenZoom('tweeningZoomin', 'camGame', dcgz, 0.15, 'quadOut')
        end
    end
end

function onSectionHit()
    if kadezoom == true then
        if stopui == false then
            doTweenZoom('tweeningZoom', 'camHUD', czmu+0.08, 0.06, 'quadOut')
        end
        if stopcam == false then
            doTweenZoom('tweeningZoomin', 'camGame', czmc+0.08, 0.06, 'quadOut')
        end
    end
end

function onTweenCompleted(name)
    if name == 'camzz' then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom')) 
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
end

--This below makes the Health Bar move Smoothly
    function onCreatePost()
        setProperty('healthBar.numDivisions', 10000)
    end
    local flip = false
    local percent = 50
    function onUpdatePost(e)
        flip = getProperty('healthBar.flipX') or getProperty('healthBar.angle') == 180 or getProperty('healthBar.scale.x') == -1

        percent = math.lerp(percent, math.max((getProperty('health') * 50), 0), (e * 10))
        setProperty('healthBar.percent', percent)
        if percent > 100 then percent = 100 end

        local usePer = (flip and percent or remap(percent, 0, 100, 100, 0)) * 0.01
        local part1 = getProperty('healthBar.x') + ((getProperty('healthBar.width')) * usePer)
        local iconParts = {part1 + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26, part1 - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2}

        for i = 1, 2 do
            setProperty('iconP'..i..'.x', iconParts[flip and ((i % 2) + 1) or i])
            setProperty('iconP'..i..'.flipX', flip)
        end
    end

    function math.lerp(a, b, t)
        return (b - a) * t + a;
    end

    function remap(v, str1, stp1, str2, stp2)
    	return str2 + (v - str1) * ((stp2 - str2) / (stp1 - str1));
    end

--@PringleKitten