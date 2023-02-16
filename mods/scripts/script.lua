local stopcam = false
local stopui = false
function onCreate()
    setProperty('skipArrowStartTween', true)
    noteTweenAlpha("o1",0,0.5,0.001,"quartInOut");
    noteTweenAlpha("o2",1,0.5,0.001,"quartInOut");
    noteTweenAlpha("o3",2,0.5,0.001,"quartInOut");
    noteTweenAlpha("o4",3,0.5,0.001,"quartInOut");
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/4)
    setPropertyFromClass("openfl.Lib", "application.window.height", screenheight/2.25)
    setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/2.25)
    setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/2.25)
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
    if songname == "party-rock" then 
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false) 
    end
end
end

function opponentNoteHit()
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
    if week == 'geometrydash' then
        health = getProperty('health')
        if getProperty('health') > 0.3 then
            setProperty('health', health- 0.02);
        end
    end
end
end

function goodNoteHit()

    if songName == "losing-my-mind" then
    else
        if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true then
    if getProperty('ratingPercent') < 0.9 and getProperty('ratingPercent') > 0.85 then
        setProperty('health', getProperty('health') + 0.01);
    elseif getProperty('ratingPercent') < 0.85 and getProperty('ratingPercent') > 0.8 then
        setProperty('health', getProperty('health') + 0.02);
    elseif getProperty('ratingPercent') < 0.8 and getProperty('ratingPercent') > 0.75 then
        setProperty('health', getProperty('health') + 0.03);
    elseif getProperty('ratingPercent') < 0.7 and getProperty('ratingPercent') > 0.65 then
        setProperty('health', getProperty('health') + 0.04);
    elseif getProperty('ratingPercent') < 0.6 and getProperty('ratingPercent') > 0 then
        setProperty('health', getProperty('health') + 0.05);
    end
    end
end
end

function noteMiss()
    if songName == "losing-my-mind" then
    else
        if getPropertyFromClass('ClientPrefs', 'ratingPenalty') == true then
    if getProperty('ratingPercent') < 0.86 and getProperty('ratingPercent') > 0.8 then
        setProperty('health', getProperty('health') - 0.1);
    elseif getProperty('ratingPercent') < 0.78 and getProperty('ratingPercent') > 0.7 then
        setProperty('health', getProperty('health') - 0.12);
    elseif getProperty('ratingPercent') < 0.67 and getProperty('ratingPercent') > 0.63 then
        setProperty('health', getProperty('health') - 0.16);
    elseif getProperty('ratingPercent') < 0.6 and getProperty('ratingPercent') > 0.55 then
        setProperty('health', getProperty('health') - 0.2);
    elseif getProperty('ratingPercent') < 0.53 and getProperty('ratingPercent') > 0 then
        setProperty('health', getProperty('health') - 0.23);
    end
    end
end
end

function onSongStart()
    setPropertyFromClass('ClientPrefs', 'camZooms', true);
    setPropertyFromClass("openfl.Lib", "application.window.title", songName);
end

function onDestroy()
    setPropertyFromClass("openfl.lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.x", 0)
    setPropertyFromClass("openfl.Lib", "application.window.y", 25)
end
local el = 0
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
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        if value1 == 1 then
            stopcam = true
        else
            stopcam = false
        end
        if value2 == 1 then
            stopui = true
        else
            stopui = false
        end
        if stopui then
            setPropertyFromClass('ClientPrefs', 'hudZoomSections', false)
        end
        if stopcam then
            setPropertyFromClass('ClientPrefs', 'bgZoomSections', false)
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

function onUpdate(elapsed)
    el = elapsed
    if customzoom then
    if stopui == false then
        doTweenZoom('tweeningZoom', 'camHUD', 1, 0.15, 'quadOut')
    end
    if stopcam == false then
        doTweenZoom('tweeningZoomin', 'camGame', 1, 0.15, 'quadOut')
    end
end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.x", screenWidth/2.25)
    setPropertyFromClass("openfl.Lib", "application.window.y", screenHeight/2.25)
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.width", 853.9)
    setPropertyFromClass("openfl.Lib", "application.window.height", 480)
end