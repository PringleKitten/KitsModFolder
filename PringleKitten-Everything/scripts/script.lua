-- Script setup --
local stopui = false
local stopcam = false
local mdsc = false
local ls = false

function capps(capsst)
    captions = capsst
end

function offnewch(ossf)
    changeOffset = ossf
end


function onCreatePost()
    setProperty('camZoomingMult',1)
    callScript("scripts/makeCaption", "invt", {ls})
    callScript("scripts/makeCaption", "middcs", {mdsc})
    callScript("scripts/makeCaptionbystep", "invt", {ls})
    callScript("scripts/makeCaptionbystep", "middcs", {mdsc})
    setProperty('skipArrowStartTween', true)
    setProperty('healthBar.numDivisions', 10000)
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false then
        close(true)
    end
end

function onSongStart()
    ls = false
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')-changeOffset
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
    debugPrint('- - -')
    debugPrint('Song Offset to Mains: '..'('..changeOffset..')')
    debugPrint('Main Offset: '..'('..offset..')')
    debugPrint('- - -')
    debugPrint(' | ')
    debugPrint(' | ')
end

function onEvent(name, value1, value2)
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
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
            callScript("scripts/makeCaptionbystep", "invt", {ls})
            callScript("scripts/makeCaptionbystep", "middcs", {mdsc})
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
        if value2 == '' or value2 < 0.011 then
            setProperty('camHUD.zoom',value1)
			setProperty('defaultCamUIZoom',value1)
	    else
            wasItOn = getProperty('camZoomsHud')
            setProperty('camZoomsHud', false)
            doTweenZoom('camzzh','camHUD',value1,value2,'sineInOut')
            tryingToZoom = true
            callScript("custom_events/CZoom Custom Toggle", "hudInMove", {true})
	    end
    end
end

function onUpdate(elapsed)
    el = elapsed
    if tryingToZoom then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom'))
    end
end

function onTweenCompleted(name)
    if name == 'camzzh' then
        setProperty("defaultCamUIZoom",getProperty('camHUD.zoom'))
        callScript("custom_events/CZoom Custom Toggle", "hudInMove", {false, wasItOn})
        setProperty('camZoomsHud', wasItOn)
        tryingToZoom = false
    end
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