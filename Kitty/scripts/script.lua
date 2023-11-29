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
    setProperty('skipArrowStartTween', true)
    noteTweenAlpha("o1",0,0.5,0.001,"quartInOut")
    noteTweenAlpha("o2",1,0.5,0.001,"quartInOut")
    noteTweenAlpha("o3",2,0.5,0.001,"quartInOut")
    noteTweenAlpha("o4",3,0.5,0.001,"quartInOut")
end

function onSongStart()
    dpsx0 = getPropertyFromGroup('playerStrums', 0, 'x')
    dpsx1 = getPropertyFromGroup('playerStrums', 1, 'x')
    dpsx2 = getPropertyFromGroup('playerStrums', 2, 'x')
    dpsx3 = getPropertyFromGroup('playerStrums', 3, 'x')
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
    setPropertyFromClass('ClientPrefs', 'hudZoomSections', true)
    setPropertyFromClass('ClientPrefs', 'bgZoomSections', true)
    setProperty('camZooms', true)
end

local customzoom = false

function onEvent(name, value1, value2)
    if name == 'newArrowToggler' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 3 then
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