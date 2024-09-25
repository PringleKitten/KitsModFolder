function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (Y)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
            pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
            pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
            pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
            if value1 ~= 0 then
                noteTweenY("pY",4,pY1+value1,value2,"quartInOut");
                noteTweenY("pY1",5,pY2+value1,value2,"quartInOut");
                noteTweenY("pY2",6,pY3+value1,value2,"quartInOut");
                noteTweenY("pY3",7,pY4+value1,value2,"quartInOut");
            end
        end
    end
end