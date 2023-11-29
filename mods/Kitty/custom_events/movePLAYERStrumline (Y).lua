function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (Y)' then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            oX1 = getPropertyFromGroup('opponentStrums', 0, 'x')
            oX2 = getPropertyFromGroup('opponentStrums', 1, 'x')
            oX3 = getPropertyFromGroup('opponentStrums', 2, 'x')
            oX4 = getPropertyFromGroup('opponentStrums', 3, 'x')
            oY1 = getPropertyFromGroup('opponentStrums', 0, 'y')
            oY2 = getPropertyFromGroup('opponentStrums', 1, 'y')
            oY3 = getPropertyFromGroup('opponentStrums', 2, 'y')
            oY4 = getPropertyFromGroup('opponentStrums', 3, 'y')
            pX1 = getPropertyFromGroup('playerStrums', 0, 'x')
            pX2 = getPropertyFromGroup('playerStrums', 1, 'x')
            pX3 = getPropertyFromGroup('playerStrums', 2, 'x')
            pX4 = getPropertyFromGroup('playerStrums', 3, 'x')
            pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
            pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
            pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
            pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
            if value1 == 0 then
                noteTweenY("pY",4,pY1,value2,"quartInOut");
                noteTweenY("pY1",5,pY2,value2,"quartInOut");
                noteTweenY("pY2",6,pY3,value2,"quartInOut");
                noteTweenY("pY3",7,pY4,value2,"quartInOut"); 
            else
                noteTweenY("pY",4,pY1+value1,value2,"quartInOut");
                noteTweenY("pY1",5,pY2+value1,value2,"quartInOut");
                noteTweenY("pY2",6,pY3+value1,value2,"quartInOut");
                noteTweenY("pY3",7,pY4+value1,value2,"quartInOut");
            end
        end
    end
end