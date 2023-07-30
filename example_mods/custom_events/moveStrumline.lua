


function onEvent(name, value1, value2)
    if name == 'moveStrumline' then
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
        if value1 == "oX" then
                noteTweenX("oX",0,oX1+value2,0.2,"quartInOut");
                noteTweenX("oX1",1,oX2+value2,0.2,"quartInOut");
                noteTweenX("oX2",2,oX3+value2,0.2,"quartInOut");
                noteTweenX("oX3",3,oX4+value2,0.2,"quartInOut");
        elseif value1 == "pX" then
            noteTweenX("pX",4,pX1+value2,0.2,"quartInOut");
            noteTweenX("pX1",5,pX2+value2,0.2,"quartInOut");
            noteTweenX("pX2",6,pX3+value2,0.2,"quartInOut");
            noteTweenX("pX3",7,pX4+value2,0.2,"quartInOut");
        elseif value1 == "pY" then
            noteTweenY("pY",4,pY1+value2,0.2,"quartInOut");
            noteTweenY("pY1",5,pY2+value2,0.2,"quartInOut");
            noteTweenY("pY2",6,pY3+value2,0.2,"quartInOut");
            noteTweenY("pY3",7,pY4+value2,0.2,"quartInOut");
        elseif value1 == "oY" then
            noteTweenY("oY",0,oY1+value2,0.2,"quartInOut");
            noteTweenY("oY1",1,oY2+value2,0.2,"quartInOut");
            noteTweenY("oY2",2,oY3+value2,0.2,"quartInOut");
            noteTweenY("oY3",3,oY4+value2,0.2,"quartInOut");
        elseif value1 == "bX" then
            noteTweenX("oX",0,oX1+value2,0.2,"quartInOut");
            noteTweenX("oX1",1,oX2+value2,0.2,"quartInOut");
            noteTweenX("oX2",2,oX3+value2,0.2,"quartInOut");
            noteTweenX("oX3",3,oX4+value2,0.2,"quartInOut");
            noteTweenX("pX",4,pX1+value2,0.2,"quartInOut");
            noteTweenX("pX1",5,pX2+value2,0.2,"quartInOut");
            noteTweenX("pX2",6,pX3+value2,0.2,"quartInOut");
            noteTweenX("pX3",7,pX4+value2,0.2,"quartInOut");
        elseif value1 == "bY" then
            noteTweenY("oY",0,oY1+value2,0.2,"quartInOut");
            noteTweenY("oY1",1,oY2+value2,0.2,"quartInOut");
            noteTweenY("oY2",2,oY3+value2,0.2,"quartInOut");
            noteTweenY("oY3",3,oY4+value2,0.2,"quartInOut");
            noteTweenY("pY",4,pY1+value2,0.2,"quartInOut");
            noteTweenY("pY1",5,pY2+value2,0.2,"quartInOut");
            noteTweenY("pY2",6,pY3+value2,0.2,"quartInOut");
            noteTweenY("pY3",7,pY4+value2,0.2,"quartInOut");
        end
    end
end












--function mysplit (inputstr, sep)
--    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
--        if sep == nil then
--            sep = "%s";
--        end
--        local t={};
--        for str in string.gmatch(inputstr, "([^"..sep.."]+)") note
--            table.insert(t, str);
--        end
--        return t;
--    end
--end
--function onEvent(name, value1, value2)
--    if name == "moveStrumline" then
--        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
--            value1 = tonumber(value1)
--            value2 = tonumber(value2)
--            local tableee=mysplit(value2,", ") -- Splits value1 into a table
--            
--            tableee[1] = tonumber(tableee[1])
--            tableee[2] = tonumber(tableee[2])
--
--            if value1 == 1 then
--                for i = 4,7 note
--                noteTweenX('x1', 4, stf, 0.4, 'quartInOut')
--                noteTweenY('y1', 5, stf, 0.4, 'quartInOut')
--                end
--            elseif value1 == 2 then
--                for i = 0,3 note
--                noteTweenX('x0', i, tableee[1], 0.4, 'quartInOut')
--                noteTweenY('y0', i, tableee[2], 0.4, 'quartInOut')
--                end
--            end
--        end
--    end
--end