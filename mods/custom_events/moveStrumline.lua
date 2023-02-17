function mysplit (inputstr, sep)
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        if sep == nil then
            sep = "%s";
        end
        local t={};
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str);
        end
        return t;
    end
end

function onEvent(name, value1, value2)
    if name == "moveStrumline" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            local tableee=mysplit(value2,", ") -- Splits value1 into a table
            
            tableee[1] = tonumber(tableee[1])
            tableee[2] = tonumber(tableee[2])

            if value1 == "opponent" then
                notePosX1 = getPropertyFromGroup('opponentStrums', 0, 'x')
                notePosX2 = getPropertyFromGroup('opponentStrums', 1, 'x')
                notePosX3 = getPropertyFromGroup('opponentStrums', 2, 'x')
                notePosX4 = getPropertyFromGroup('opponentStrums', 3, 'x')
                notePosY1 = getPropertyFromGroup('opponentStrums', 0, 'y')
                notePosY2 = getPropertyFromGroup('opponentStrums', 1, 'y')
                notePosY3 = getPropertyFromGroup('opponentStrums', 2, 'y')
                notePosY4 = getPropertyFromGroup('opponentStrums', 3, 'y')
            elseif value1 == "player" then
                notee = value1 - 4
                notePosX5 = getPropertyFromGroup('playerStrums', 0, 'x')
                notePosX6 = getPropertyFromGroup('playerStrums', 1, 'x')
                notePosX7 = getPropertyFromGroup('playerStrums', 2, 'x')
                notePosX8 = getPropertyFromGroup('playerStrums', 3, 'x')
                notePosY5 = getPropertyFromGroup('playerStrums', 0, 'y')
                notePosY6 = getPropertyFromGroup('playerStrums', 1, 'y')
                notePosY7 = getPropertyFromGroup('playerStrums', 2, 'y')
                notePosY8 = getPropertyFromGroup('playerStrums', 3, 'y')
            end

            newnotePosX1 = notePosX1 + tableee[1]
            newnotePosX2 = notePosX2 + tableee[1]
            newnotePosX3 = notePosX3 + tableee[1]
            newnotePosX4 = notePosX4 + tableee[1]
            newnotePosX5 = notePosX5 + tableee[1]
            newnotePosX6 = notePosX6 + tableee[1]
            newnotePosX7 = notePosX7 + tableee[1]
            newnotePosX8 = notePosX8 + tableee[1]
            newnotePosY1 = notePosY1 + tableee[2]
            newnotePosY2 = notePosY2 + tableee[2]
            newnotePosY3 = notePosY3 + tableee[2]
            newnotePosY4 = notePosY4 + tableee[2]
            newnotePosY5 = notePosY5 + tableee[2]
            newnotePosY6 = notePosY6 + tableee[2]
            newnotePosY7 = notePosY7 + tableee[2]
            newnotePosY8 = notePosY8 + tableee[2]
            if value1 == "player" then
                noteTweenX('x4', 4, newnotePosX5, 0.4, 'linear')
                noteTweenX('x5', 5, newnotePosX6+112, 0.4, 'linear')
                noteTweenX('x6', 6, newnotePosX7+224, 0.4, 'linear')
                noteTweenX('x7', 7, newnotePosX8+336, 0.4, 'linear')
                noteTweenY('y4', 4, newnotePosY5, 0.4, 'linear')
                noteTweenY('y5', 5, newnotePosY6+112, 0.4, 'linear')
                noteTweenY('y6', 6, newnotePosY7+224, 0.4, 'linear')
                noteTweenY('y7', 7, newnotePosY8+336, 0.4, 'linear')
            elseif value1 == "opponent" then
                noteTweenX('x0', 0, newnotePosX1, 0.4, 'linear')
                noteTweenX('x1', 1, newnotePosX2+112, 0.4, 'linear')
                noteTweenX('x2', 2, newnotePosX3+224, 0.4, 'linear')
                noteTweenX('x3', 3, newnotePosX4+336, 0.4, 'linear')
                noteTweenY('y0', 0, newnotePosY1, 0.4, 'linear')
                noteTweenY('y1', 1, newnotePosY2+112, 0.4, 'linear')
                noteTweenY('y2', 2, newnotePosY3+224, 0.4, 'linear')
                noteTweenY('y3', 3, newnotePosY4+336, 0.4, 'linear')
            end
        end
    end
end