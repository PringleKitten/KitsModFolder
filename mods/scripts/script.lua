local stopcam = false
local stopui = false
function onCreate()
    setProperty('skipArrowStartTween', true)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", true)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    if songname == "party-rock" then 
        setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false) 
        setPropertyFromClass("openfl.Lib", "application.window.width", screenWidth/1.5)
        setPropertyFromClass("openfl.Lib", "application.window.height", screenHeight/1.5) 
    end
end
function opponentNoteHit()
    if week <= 3 then
        if difficulty >= 2 then
            health = getProperty('health')
            if getProperty('health') > 0.3 then
                setProperty('health', health- 0.014);
            end
        end
    end
end

function opponentNoteHit()
    if week == 'geometrydash' then
        health = getProperty('health')
        if getProperty('health') > 0.3 then
            setProperty('health', health- 0.02);
        end
    end
end

function goodNoteHit()
    if songName == "losing-my-mind" then
    else
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

function noteMiss()
    if songName == "losing-my-mind" then
    else
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

function onSongStart()
    noteTweenAlpha("o1",0,0.5,0.001,"quartInOut");
    noteTweenAlpha("o2",1,0.5,0.001,"quartInOut");
    noteTweenAlpha("o3",2,0.5,0.001,"quartInOut");
    noteTweenAlpha("o4",3,0.5,0.001,"quartInOut");
    setPropertyFromClass('ClientPrefs', 'camZooms', true);
    setPropertyFromClass("openfl.Lib", "application.window.title", songName);
end

function onDestroy()
    setPropertyFromClass("openfl.lib", "application.window.borderless", false)
    setPropertyFromClass("openfl.Lib", "application.window.x", 0)
    setPropertyFromClass("openfl.Lib", "application.window.y", 25)
end
local el = 0
function onSectionHit()
    if stopui == false then
        doTweenZoom('tweeningZoom', 'camHUD', 1.25, 0.07, 'quadOut')
    end
    if stopcam == false then
        doTweenZoom('tweeningZoomin', 'camGame', 1.25, 0.07, 'quadOut')
    end
end

function onUpdate(elapsed)
    el = elapsed
    if stopui == false then
        doTweenZoom('tweeningZoom', 'camHUD', 1, 0.15, 'quadOut')
    else
        doTweenZoom('tweeningZoom', 'camHUD', 1, el, 'quadOut')
    end
    if stopcam == false then
        doTweenZoom('tweeningZoomin', 'camGame', 1, 0.15, 'quadOut')
    else
        doTweenZoom('tweeningZoomin', 'camGame', 1, el, 'quadOut')
    end
end

function onEvent(name, value1, value2)
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
            doTweenZoom('tweeningZoom', 'camHUD', 1, el, 'quadOut')
        end
        if stopcam then
            doTweenZoom('tweeningZoomin', 'camGame', 1, el, 'quadOut')
        end
    end
end
