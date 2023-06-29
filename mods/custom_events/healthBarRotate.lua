function onEvent(name, value1, value2)
    if name == 'healthBarRotate' then
        doTweenAngle('rr', 'healthBar', value1, value2, 'circInOut')
        setProperty('iconP1.alpha', 0)
        setProperty('iconP2.alpha', 0)
        if value1 ~= 0 then
            a = true
        else
            a = false
        end
    end
end

function onUpdate()
    if a then
        setProperty('iconP1.alpha', 0)
        setProperty('iconP2.alpha', 0)
    end
end