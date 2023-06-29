local stopcam = false
local stopui = false
function onUpdate()
    if runHaxeCode("return FlxG.keys.firstJustPressed();") then
        if songName ~= 'listen' then
            f = runHaxeCode("return FlxG.keys.firstJustPressed();")

            if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then
                uhoh = 1
            elseif uhoh == 1 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.E') then
                uhoh = 2
            
            elseif uhoh == 2 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.B') then
                uhoh = 3
            
            elseif uhoh == 3 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.E') then
                uhoh = 4
            
            elseif uhoh == 4 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.C') then
                uhoh = 5
            
            elseif uhoh == 5 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.C') then
                uhoh = 6
            
            elseif uhoh == 6 and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.A') then
                loadSong('listen', 1);
            elseif f > 0 then
                    if f ~= 82 and f ~= 69 and f ~= 66 and f ~= 67 and f ~= 65 then
                        uhoh = 0
                    end
                end
        end
    end
end

function onCreate()
    setProperty('skipArrowStartTween', true)
    makeLuaText('st', 'l', '800', 400,450)
    addLuaText('st')
    setTextSize('st', 50)
    setTextAlignment('st', 'center')
    setProperty('st.x', (screenWidth/2)-(getProperty('st.width')/2))
    setObjectCamera('st', 'other')
    setProperty('st.alpha', 0)
    makeLuaSprite('bars', 'me/popup/bars', 0,0)
    setObjectCamera('bars', 'other')
    addLuaSprite('bars')
    setProperty('bars.scale.x', 2)
    setProperty('bars.scale.y', 2)
    setProperty('bars.alpha', 0)
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
            --doTweenZoom('tweeningZoom', 'camHUD', 1.25, 0.07, 'quadOut')
        end
        if stopcam == false then
            --doTweenZoom('tweeningZoomin', 'camGame', 1.25, 0.07, 'quadOut')
        end
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
end

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