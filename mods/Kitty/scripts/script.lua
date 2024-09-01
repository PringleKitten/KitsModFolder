local kadezoom = false
local stopui = false
local stopcam = false
local czm = 1
local czmu = 1
local czmc = 1

function onCreate()
    setProperty('skipArrowStartTween', true)
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

    setProperty('camHUD.zoom', 1)
    setProperty("defaultCamUIZoom",1) 
    setPropertyFromClass("openfl.Lib", "application.window.title", songName)
    dcuiz = getProperty('defaultCamUIZoom')
    dcgz = getProperty('defaultCamZoom')
    czm = getProperty('camZoomingMult')
end

function goodNoteHit()
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true then
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
    if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true then
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
            noteTweenX("oX2",2,dpsx2-79,value2,"cubeInOut");
            noteTweenX("oX3",3,dpsx3-79,value2,"cubeInOut");
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