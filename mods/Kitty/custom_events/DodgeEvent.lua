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
        if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
            --Get Dodge time
            DodgeTime = (value1)
            Dodged = false
            names = name
            --Make Dodge Sprite
            makeLuaSprite('dodge', 'me/popup/dodge', 450, 250)
            setObjectCamera('dodge', 'other')
            scaleLuaSprite('dodge', 1.55, 1.55) 
            addLuaSprite('dodge', true) 
            --Set values so you can dodge
            if not songName == 'ab-rushe' then
            playSound('DODGE')
            end
            canDodge = true
            runTimer('Died', DodgeTime)
            twice = twice+1
        end
	end
end

function onUpdate()
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
    if twice == 2 then
        twice = 0
        setProperty('health', getProperty('health')-.8)
        removeLuaSprite('dodge')
    end
    if (canDodge == true and keyJustPressed('space')) or (botPlay == true and canDodge == true) then
        Dodged = true
        twice = 0
        removeLuaSprite('dodge')
        canDodge = false
        setProperty('health', getProperty('health')+.1)
    elseif (canDodge == false and keyJustPressed('space')) then
        setProperty('health', getProperty('health')-.3)
    end
end
end



function onTimerCompleted(tag, loops, loopsLeft)
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
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