local Dodged = false
local canDodge = false
local DodgeTime = 0
local twice = 0
local count = 0
local ran = 0
local go = false
function onCreate()
    precacheImage('me/anim/slash')
    precacheSound('DODGEbf')
end

function onEvent(name, value1, value2)
    if name == "DodgeForBF" then
        if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
            --Get Dodge time
            DodgeTime = (value1)
            Dodged = false
            names = name
            --Make Dodge Sprite
            makeAnimatedLuaSprite('ssl', 'me/anim/slash', 600, 550)
            addAnimationByPrefix('ssl', 'slash', 'slash anim', 120, false)
            addLuaSprite('ssl', true)
            setProperty('ssl.scale.x', 4)
            setProperty('ssl.scale.y', 4)
            --Set values so you can dodge
            playSound('DODGEbf')
            canDodge = true
            runTimer('Died', DodgeTime)
            twice = twice+1
        end
	end
end

function onUpdate()
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
        if getProperty('ssl.animation.curAnim.finished') then
            removeLuaSprite('ssl')
        end
        if twice == 2 then
            twice = 0
            setProperty('health', getProperty('health')-.8)
        end
        if (canDodge == true and keyJustPressed('space')) or (botPlay == true and canDodge == true) then
            Dodged = true
            twice = 0
            if song == 'run-run' and count < 3 then
                triggerEvent('Play Animation','dodge', 'bf')
            elseif song ~= 'run-run' then
                triggerEvent('Play Animation','dodge', 'bf')
            end
            canDodge = false
            setProperty('health', getProperty('health')+.1)
        elseif (canDodge == false and keyJustPressed('space')) then
            if songName == 'run-run' and count < 3 then
                triggerEvent('Play Animation','hurt', 'bf')
            elseif songName ~= 'run-run' then
                triggerEvent('Play Animation','hurt', 'bf')
            end
            setProperty('health', getProperty('health')-.3)
            count = count + 1
            go = true
        end
    end
end



function onTimerCompleted(tag, loops, loopsLeft)
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
        if tag == 'bfff' then
            triggerEvent('Change Character', 'bf', 'bfghost')
        end
        if tag == 'Died' and Dodged == false then
            count = count + 1
            if songName == 'run-run' and count < 3 then
                triggerEvent('Play Animation','hurt', 'bf')
            elseif songName ~= 'run-run' then
                triggerEvent('Play Animation','hurt', 'bf')
            end
            go = true
            setProperty('health', getProperty('health')-.8)
            removeLuaSprite('ssl')
            canDodge = false
            twice = 0
        elseif tag == 'Died' and Dodged == true then
            Dodged = false
            canDodge = false
            removeLuaSprite('ssl')
            twice = 0

        end
    end
end

function onUpdatePost()
    if songName == 'run-run' and count >= 3 then
        if go then
            if getProperty('bf.animation.curAnim.finished') then
                ran = ran + 1
                if ran <= 1 then
                    triggerEvent('Change Character', 'bf', 'bf-dead')
                    triggerEvent('Play Animation', 'firstDeath', 'bf')
                    runTimer('bfff', 2.2)
                end
            end
            go = false
        end
    end
end