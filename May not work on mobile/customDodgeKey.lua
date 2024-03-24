local youDoge = false
local Doge = false

function onEvent(name,value1,value2)
    if name == 'customDodgeKey' then
        if getPropertyFromClass('ClientPrefs', 'mechanics') then
            myKeyPressed = keyboardPressed(value1)
            --              ^this^ can be changed so it only runs when it is JUST pressed and NOT held down yada yada yada
            -- but gotta change the 'keyboardPressed(value1)' part to what you want, 
            -- dont change the variable name 'myKeyPressed' unless you wanna mess with the rest of the code that rely on that specific name.
            myKeyReleased = keyboardReleased(value1)
            -- Same goes for this ^function^
            youDoge = false
            Doge = true
                runTimer('Dbed', value2)
        end
    end
end

function onUpdate()
    if Doge and myKeyPressed or (botPlay and Doge) then
        youDoge = true
    end
    if myKeyReleased and Doge and youDoge == false then
        youDoge = false
        Doge = false
        setProperty('health', setProperty('health', 0))
    end
    if myKeyReleased and youDoge then
        youDoge = true
        Doge = false
        setProperty('health', getProperty('health')+.1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if getPropertyFromClass('ClientPrefs', 'mechanics') then
        if tag == 'Dbed' and youDoge == false then
            setProperty('health', 0)
        end
    end
end