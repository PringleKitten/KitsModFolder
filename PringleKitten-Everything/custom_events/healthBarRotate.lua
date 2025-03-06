function onEvent(name, value1, value2)
    if name == 'healthBarRotate' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        doTweenAngle('rr', 'healthBar', value1, value2, 'circInOut')
        setProperty('iconP1.alpha', 0)
        setProperty('iconP2.alpha', 0)
        if value1 ~= 0 then
            setProperty('iconP1.alpha', 0)
            setProperty('iconP2.alpha', 0)
        elseif value1 == 0 then
            setProperty('iconP1.alpha', 1)
            setProperty('iconP2.alpha', 1)
        end
    end
end