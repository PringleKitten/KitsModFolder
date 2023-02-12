local names = "Dodgeeeeee"
local a2 = 0
local a1 = 0
local run = false
local Dodged = false
local canDodge = false
local DodgeTime = 0
local twice = 0
function onCreate()
    precacheImage('spacebar')
    precacheSound('DODGE')
    precacheImage('dodge1')
end

function onEvent(name, value1, value2)
    if name == "DodgeEvent" then
            if value2 == 1 then
                run = true
            else
                run = false
            end
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        a1 = value1
        a2 = value2
        if not (value2 == 1) then
            --Get Dodge time
            DodgeTime = (value1)
            Dodged = false
            names = name
            --Make Dodge Sprite
            makeLuaSprite('spacebar', 'me/popup/spacebar', 200, 200)
            setObjectCamera('spacebar', 'other')
            scaleLuaSprite('spacebar', 10, 10) 
            addLuaSprite('spacebar', true) 
            --Set values so you can dodge
            playSound('DODGE')
            canDodge = true
            runTimer('Died', DodgeTime)
            twice = twice+1
        end
	end
end
function onBeatHit()
    if run == true then
        --Get Dodge time
        DodgeTime = (a1)
        Dodged = false
        
        --Make Dodge Sprite
        makeLuaSprite('spacebar', 'me/popup/spacebar', 200, 200)
        setObjectCamera('spacebar', 'other')
        scaleLuaSprite('spacebar', 10, 10) 
        addLuaSprite('spacebar', true) 
        
        --Set values so you can dodge
        playSound('DODGE')
        canDodge = true
        runTimer('Died', DodgeTime)
        twice = twice+1
    end
end

function onUpdate()
    if twice == 2 then
        twice = 0
        setProperty('health', getProperty('health')-.8)
        removeLuaSprite('spacebar')
    end
    if (canDodge == true and keyPressed('space')) or (botPlay == true and canDodge == true) then
        Dodged = true
        twice = 0
        removeLuaSprite('spacebar')
        canDodge = false
        setProperty('health', getProperty('health')+.1)
    elseif (canDodge == false and keyJustPressed('space')) then
        setProperty('health', getProperty('health')-.1)
    end
end



function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'Died' and Dodged == false then
        setProperty('health', getProperty('health')-.8)
        removeLuaSprite('spacebar')
        twice = 0
    elseif tag == 'Died' and Dodged == true then
        Dodged = false
        removeLuaSprite('spacebar')
        twice = 0

    end
end