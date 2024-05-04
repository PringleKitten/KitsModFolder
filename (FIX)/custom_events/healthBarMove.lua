function onEvent(name, value1, value2)
    if name == 'healthBarMove' then
        dX = getProperty('healthBar.x')
        dY = getProperty('healthBar.y')
        if value1 == 'left' then
            value1 = screenWidth/-5
        elseif value1 == 'center' then
            value1 = dX
        elseif value1 == 'right' then
            value1 = screenWidth/1.38
        end

        doTweenX('xBar', 'healthBar', value1, 0.2, 'circInOut')
        if value2 == null or value2 == '' then
        doTweenY('yBar', 'healthBar', screenHeight/2, 0.2, 'circInOut')
        else
        doTweenY('yBar', 'healthBar', value2, 0.2, 'circInOut')
        end
    end
end