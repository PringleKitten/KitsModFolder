function onEvent(name, value1, value2)
    if name == 'barsz' then    
        value1 = tonumber(value1);
        value2 = tonumber(value2)
        if value1 == 1 then
            setProperty('bars.alpha', 1);
            doTweenY('ba', 'bars.scale', 1, value2, 'quadInOut')
        elseif value1 == 0 then
            doTweenY('ba1', 'bars.scale', 0, value2, 'quadInOut')
        end
        if value1 == 8888 then
            setObjectCamera('bars', 'hud')
        elseif value1 == 9999 then
            setObjectCamera('bars', 'other')
        end
    end
end

function onUpdatePost()
    screenCenter('bars')
end

function onTweenCompleted(tag)
    if tag == 'ba1' then
        setProperty('bars.alpha', 0)
    end
end