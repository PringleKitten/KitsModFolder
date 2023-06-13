local stopcam = false
local stopui = false
function onCreate()
    setProperty('skipArrowStartTween', true)
    noteTweenAlpha("o1",0,0.5,0.001,"quartInOut")
    noteTweenAlpha("o2",1,0.5,0.001,"quartInOut")
    noteTweenAlpha("o3",2,0.5,0.001,"quartInOut")
    noteTweenAlpha("o4",3,0.5,0.001,"quartInOut")
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        if songName == "party-rock" then 
            setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false) 
        end
    end
end

function opponentNoteHit()
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        if week == 'geometrydash' then
            health = getProperty('health')
            if getProperty('health') > 0.3 then
                setProperty('health', health- 0.02)
            end
        end
    end
end

function goodNoteHit()
    if songName == "losing-my-mind" then
    else
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
end

function noteMiss()
    if songName == "losing-my-mind" then
    else
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
end

function onSongStart()
    doTweenZoom('camz','camHUD',1,0.01,'sineInOut')
    setProperty("defaultCamUIZoom",getProperty('camHUD.zoom')) 
    setPropertyFromClass("openfl.Lib", "application.window.title", songName)
    setPropertyFromClass('ClientPrefs', 'hudZoomSections', true)
    setPropertyFromClass('ClientPrefs', 'bgZoomSections', true)
    setProperty('camZooms', true)
end

local customzoom = false

function onEvent(name, value1, value2)
    if name == "customzoomtoggle" then
        value1 = tonumber(value1)
        if value1 == 1 then
            customzoom = true
        else
            customzoom = false
        end
    end

    if name == "nozoom" then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 1 then
            stopcam = true
        else
            stopcam = false
            setProperty('camZoomingMult', 1)
        end
        if value2 == 1 then
            stopui = true
        else
            stopui = false
            setProperty('camZoomingMult', 1)
        end
        if stopui then
            setProperty('camZoomingMult', 0)
        end
        if stopcam then
            setProperty('camZoomingMult', 0)
        end
    end
end

function onSectionHit()
    if customzoom then
        if stopui == false then
            doTweenZoom('tweeningZoom', 'camHUD', 1.25, 0.07, 'quadOut')
        end
        if stopcam == false then
            doTweenZoom('tweeningZoomin', 'camGame', 1.25, 0.07, 'quadOut')
        end
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
end