


function onEvent(name, value1, value2)
    if name == 'moveStrumline' then
        l = getPropertyFromGroup('playerStrums', 4)
        d = getPropertyFromGroup('playerStrums', 5)
        u
        r
        if value1 == "oX" then
            for i = 0,3 do

                noteTweenX(i,i,value2+(),0.2,"quartInOut");
            end
        elseif value1 == "pX" then
            for i = 4,7 do
                noteTweenX(i,i,value2,0.2,"quartInOut");
            end
        elseif value1 == "pY" then
            for i = 4,7 do
                noteTweenY(i,i,value2,0.2,"quartInOut");
            end
        elseif value1 == "oY" then
            for i = 0,3 do
                noteTweenY(i,i,value2,0.2,"quartInOut");
            end
        end
    end
end












--function mysplit (inputstr, sep)
--    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
--        if sep == nil then
--            sep = "%s";
--        end
--        local t={};
--        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
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
--                for i = 4,7 do
--                noteTweenX('x1', 4, stf, 0.4, 'linear')
--                noteTweenY('y1', 5, stf, 0.4, 'linear')
--                end
--            elseif value1 == 2 then
--                for i = 0,3 do
--                noteTweenX('x0', i, tableee[1], 0.4, 'linear')
--                noteTweenY('y0', i, tableee[2], 0.4, 'linear')
--                end
--            end
--        end
--    end
--end