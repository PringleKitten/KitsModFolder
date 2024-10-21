--CHECK THESE WHEN YOU CAN FOR CUSTOM OPTIONS WITHOUT MY ENGINE
local force = false --Should mobile support be enabled at all times?
local visuals = true --MOST arrow movements?
local healthDrain = true
local mechanics = true --Regular Dodge
local mechanics2 = true -- Set to false if you dont want stuff like hitting custom keys to dodge to work no matter what(mobile user issues without a physical keyboard)
local penalizeanyway = false -- If you have a bad rating, this will penalize you like in Kade Engine

local botherme = true -- Set to false to SHUT UP THE PRINT


local bugged = false
local kadezoom = false
local stopui = false
local stopcam = false
local czm = 1
local czmu = 1
local czmc = 1
local mdsc = false
local ls = false

function capps(capsst)
    captions = capsst
end


function onCreatePost()
    callScript("scripts/LaneUnderlay", "getVarr", {force})
    callScript("custom_events/customDodgeKey", "getVarr", {mechanics2})
    callScript("custom_events/hitkey", "getVarr", {mechanics2})
    callScript("custom_events/DodgeEvent", "getVarr", {mechanics,force})
    callScript("custom_events/DodgeForBF", "getVarr", {mechanics,force})
    callScript("custom_events/DrainConstant", "getVarr", {healthDrain})
    callScript("custom_events/DrainHP", "getVarr", {healthDrain})
    callScript("custom_events/DrainOnBeat", "getVarr", {healthDrain})
    callScript("custom_events/DrainOnEvent", "getVarr", {healthDrain})
    callScript("custom_events/DrainOnStep", "getVarr", {healthDrain})
    callScript("custom_events/MoveArrow", "getVarr", {visuals})
    callScript("custom_events/moveOPPONENTStrumline (X)", "getVarr", {visuals})
    callScript("custom_events/moveOPPONENTStrumline (Y)", "getVarr", {visuals})
    callScript("custom_events/movePLAYERStrumline (X)", "getVarr", {visuals})
    callScript("custom_events/movePLAYERStrumline (Y)", "getVarr", {visuals})
    callScript("custom_events/moveStrumline", "getVarr", {visuals})
    callScript("custom_events/newArrowToggler", "getVarr", {visuals})
    callScript("custom_events/Tilt", "getVarr", {visuals})
    callScript("custom_events/TiltBGTimed", "getVarr", {visuals})
    callScript("custom_events/TiltHudTimed", "getVarr", {visuals})
    callScript("scripts/eventConvertScript", "getVarr", {visuals})
    callScript("custom_events/transparenthelp", "getVarr", {visuals,botherme})
    callScript("scripts/makeCaption", "invt", {ls})
    callScript("scripts/makeCaption", "middcs", {mdsc})
    setProperty('skipArrowStartTween', true)
    setProperty('healthBar.numDivisions', 10000)
end

function onSongStart()
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
    ls = false
        makeLuaText("drawfps", drawf, 0, 0.0, 0.0)
        setTextSize("drawfps", 20)
        setObjectCamera("drawfps", 'other')
        addLuaText("drawfps")
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' and botherme then
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
        debugPrint('Different engine recognized? WILL NOT penalize player for bad ratings unless you change the setting to (local penalizeanyway = true) in mods/kitty/scripts/script.lua!')
        bugged = true
    elseif not botherme and getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' then
        bugged = true
    end
    if getPropertyFromClass('ClientPrefs','assetMovement') == 'assetMovement' and botherme then
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
        debugPrint('Different engine recognized? Modcharts will CONTINUE to be used unless you change the setting to (local visuals = false) in mods/kitty/scripts/script.lua!')        
        bugged = true
    elseif not botherme and getPropertyFromClass('ClientPrefs','assetMovement') == 'assetMovement' then
        bugged = true
    end
    if getPropertyFromClass('ClientPrefs','mechanics') == 'mechanics' and botherme then
        debugPrint('-- You WILL continue to see this message unless you set (local botherme) in scripts/script.lua to false! --')
        debugPrint('Different engine recognized? Mechanics will CONTINUE to be used unless you change the setting to (local mechanics = false) in mods/kitty/scripts/script.lua!')
        bugged = true
    elseif not botherme and getPropertyFromClass('ClientPrefs','mechanics') == 'mechanics' then
        bugged = true
    end
    debugPrint('- - -')
    debugPrint('Current Offset: ','(',offset,')')
    debugPrint('- - -')
    debugPrint(' | ')
    debugPrint(' | ')
    doTweenZoom('camz','camHUD',1,0.01,'sineInOut')
    setProperty("defaultCamUIZoom",getProperty('camHUD.zoom')) 
    setPropertyFromClass("openfl.Lib", "application.window.title", songName)
    if getProperty('defaultCamUIZoom') ~= 'defaultCamUIZoom' then
        dcuiz = getProperty('defaultCamUIZoom')
    end
    dcgz = getProperty('defaultCamZoom')
    czm = getProperty('camZoomingMult')
    callScript("custom_events/CZoom Custom Toggle", "getVarr", {bugged})
    callScript("custom_events/Add Camera Zoom Edit", "getVarr", {bugged})
end

function goodNoteHit()
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == 'ratingPenalty' then
        bugged = true
    else
        bugged = false
    end
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true or (bugged and penalizeanyway) then
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
        bugged = true
    else
        bugged = false
    end
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true or (bugged and penalizeanyway) then
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
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == 'assetMovement' then
        bugged = true
    else
        bugged = false
    end
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true or (bugged and visuals) then
        if name == 'newArrowToggler' then
            value1 = tonumber(value1)
            value2 = tonumber(value2)
            if value1 == 3 or value1 == 33 then
                mdsc = true
            elseif value1 == 2 and not ls then
                mdsc = false
                ls = true
            elseif value1 == 2 and ls then
                ls = false
                mdsc = false
            end
            callScript("scripts/makeCaption", "invt", {ls})
            callScript("scripts/makeCaption", "middcs", {mdsc})
        end
        if name == 'movePLAYERStrumline (X)' then
            value1 = tonumber(value1)
            value2 = tonumber(value2)
            if value1 == 0 and mdsc then
                noteTweenX("pX",4,dpsx0-323,value2,"cubeInOut");
                noteTweenX("pX1",5,dpsx1-323,value2,"cubeInOut");
                noteTweenX("pX2",6,dpsx2-323,value2,"cubeInOut");
                noteTweenX("pX3",7,dpsx3-323,value2,"cubeInOut");
            elseif value1 == 0 and not mdsc then
                noteTweenX("pX",4,dpsx0,value2,"cubeInOut");
                noteTweenX("pX1",5,dpsx1,value2,"cubeInOut");
                noteTweenX("pX2",6,dpsx2,value2,"cubeInOut");
                noteTweenX("pX3",7,dpsx3,value2,"cubeInOut");
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
                noteTweenY("pY",4,dpsy0,value2,"cubeInOut");
                noteTweenY("pY1",5,dpsy1,value2,"cubeInOut");
                noteTweenY("pY2",6,dpsy2,value2,"cubeInOut");
                noteTweenY("pY3",7,dpsy3,value2,"cubeInOut");
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
    end
    if name == "hudzoom" then 
        value1 = tonumber(value1)
        value2 = tonumber(value2) 
        if bugged then
            bugdone = false
        end
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
        elseif value1 == 0 then
            stopcam = false
            czmc = 1
            setProperty('camZoomingMult', 1)
        end
        if value2 == 1 then
            stopui = true
            czmu = 0
            setProperty('camZoomingMult', 0)
        elseif value2 == 0 then
            stopui = false
            czmu = 1
            setProperty('camZoomingMult', 1)
        end
    end
end

function onUpdate(elapsed)
    drawf = getPropertyFromClass("Main", "fpsVar.text")
    setTextString("drawfps", drawf)
    el = elapsed
    if kadezoom == true then
        if stopui == false then
            doTweenZoom('tweeningZoom', 'camHUD', dcuiz, 0.15, 'quadOut')
        end
        if stopcam == false then
            doTweenZoom('tweeningZoomin', 'camGame', dcgz, 0.15, 'quadOut')
        end
    end
    if bugdone then
        debugPrint(bugdone,bugged,lastZOOM)
        setProperty("camHUD.zoom",lastZOOM)
        doTweenZoom("tweeningZoom", "camHUD", lastZOOM, 0.0, "linear")
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
        if not bugged then
            setProperty("defaultCamUIZoom",getProperty('camHUD.zoom'))
        end
        lastZOOM = getProperty('camHUD.zoom')
        if bugged and lastZOOM ~= 1 then
            bugdone = true
        end
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
end

--This below makes the Health Bar move Smoothly

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