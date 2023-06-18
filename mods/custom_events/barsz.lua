function onEvent(name, value1, value2)
    if name == 'barsz' then    
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 8888 then
            setObjectCamera('bars', 'hud')
        elseif value1 == 9999 then
            setObjectCamera('bars', 'other')
        else
            setProperty('bars.alpha', 1)
            doTweenY('ba', 'bars.scale', value1, value2, 'quadInOut')
        end
    end
end

function onUpdatePost()
    screenCenter('bars')
end