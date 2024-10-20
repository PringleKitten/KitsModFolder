function getVarr(mec,fo)
    mechanics = mec
    force = fo
end

function cdal(al)
    allowCountdown = al
end

function luasprite(tag,path,x,y,cam,xs,ys,sfx,sfy,sc,f) -- set certain values to '.' for default or no value
    makeLuaSprite(tag,path,x,y)
    setObjectCamera(tag,cam)
    scaleObject(tag, xs, ys)
    setScrollFactor(tag, sfx, sfy)
    if sc ~= '.' then
        screenCenter(tag, sc)
    end
    if f == '.' then
        f = false
    end
    addLuaSprite(tag,f)
end

function onSongStart()
    if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
        bugged = true
    else
        bugged = false
    end
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true or (bugged and mechanics) or force then
        luasprite('ddgg','me/buttons/sbutton',0,580,'other',0.7,0.7,0,0,'.',true)
    end
end

function mouseOverlaps(tag, camera)
    x = getMouseX(camera or 'camHUD')
    y = getMouseY(camera or 'camHUD')
    return (x > getProperty(tag..'.x') and y > getProperty(tag..'.y') and x < (getProperty(tag..'.x') + getProperty(tag..'.width')) and y < (getProperty(tag..'.y') + getProperty(tag..'.height')))
end

local Dodged = false
local canDodge = false
local DodgeTime = 0
local twice = 0

function onCreate()
    precacheImage('dodge')
    precacheSound('DODGE')
end


function onEvent(name, value1, value2)
    if name == "DodgeEvent" then
        if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
            bugged = true
        else
            bugged = false
        end
            if getPropertyFromClass('ClientPrefs', 'mechanics') == true or (bugged and mechanics) == true then
            --Get Dodge time
            DodgeTime = (value1)
            Dodged = false
            names = name
            --Make Dodge Sprite
            makeLuaSprite('dodge', 'me/popup/dodge', 450, 250)
            setObjectCamera('dodge', 'other')
            scaleObject('dodge', 1.55, 1.55) 
            addLuaSprite('dodge', true) 
            --Set values so you can dodge
            if not songName == 'alan-becker-(rush-e)' then
            playSound('DODGE')
            end
            canDodge = true
            runTimer('Died', DodgeTime)
            twice = twice+1
        end
	end
end

function onUpdate()
    if allowCountdown then
        if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
            bugged = true
        else
            bugged = false
        end
        if getPropertyFromClass('ClientPrefs', 'mechanics') == true or (bugged and mechanics) then
            if bugged or force then
                if mouseOverlaps('ddgg', 'camOther') and mouseClicked("left") then
                    sdgd = true
                else
                    sdgd = false
                end
            end
            if twice == 2 then
                twice = 0
                setProperty('health', getProperty('health')-.8)
                removeLuaSprite('dodge')
            end
            if (canDodge == true and (keyJustPressed('space') or sdgd)) or (botPlay == true and canDodge == true) then
                Dodged = true
                twice = 0
                removeLuaSprite('dodge')
                canDodge = false
                setProperty('health', getProperty('health')+.1)
            elseif (canDodge == false and (keyJustPressed('space') or sdgd)) then
                setProperty('health', getProperty('health')-.3)
            end
        end
    end
end



function onTimerCompleted(tag, loops, loopsLeft)
    if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
        bugged = true
    else
        bugged = false
    end
        if getPropertyFromClass('ClientPrefs', 'mechanics') == true or (bugged and mechanics) == true then
    if tag == 'Died' and Dodged == false then
        setProperty('health', getProperty('health')-.8)
        removeLuaSprite('dodge')
        twice = 0
    elseif tag == 'Died' and Dodged == true then
        Dodged = false
        removeLuaSprite('dodge')
        twice = 0

    end
end
end