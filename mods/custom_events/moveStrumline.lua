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

-- Event notes hooks
function onEvent(name, value1, value2)
    if name == "MoveArrow" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        local tableee=mysplit(value2,", "); -- Splits value1 into a table
        value1 = tonumber(value1);
        tableee[1] = tonumber(tableee[1]);
        tableee[2] = tonumber(tableee[2]);
        tableee[3] = tonumber(tableee[3]);
        tableee[4] = tonumber(tableee[4]);
        tableee[5] = tonumber(tableee[5]);

        if value1 < 4 then
            notePosX = getPropertyFromGroup('opponentStrums', value1, 'x');
            notePosY = getPropertyFromGroup('opponentStrums', value1, 'y');
        else
            notee = value1 - 4;
            notePosX = getPropertyFromGroup('playerStrums', notee, 'x');
            notePosY = getPropertyFromGroup('playerStrums', notee, 'y');
        end

        newnotePosX = notePosX + tableee[1];
        newnotePosY = notePosY + tableee[2];

        duration = tableee[5];
        rotation = tableee[3];
        opacity = tableee[4];

function onEvent(name, value1, value2)
    if name == "moveStrumline" then
        local tableee=mysplit(value2,", "); -- Splits value1 into a table
        value1 = tonumber(value1);
        tableee[1] = tonumber(tableee[1]);
        tableee[2] = tonumber(tableee[2]);
        tableee[3] = tonumber(tableee[3]);
        tableee[4] = tonumber(tableee[4]);
        tableee[5] = tonumber(tableee[5]);

        if value1 < 4 then
            notePosX1 = noteTweenX('x4', 4, value2, 0.4, 'linear');
            notePosX2 = noteTweenX('x5', 5, value2+112, 0.4, 'linear');
            notePosX3 = noteTweenX('x6', 6, value2+224, 0.4, 'linear');
            notePosX4 = noteTweenX('x7', 7, value2+336, 0.4, 'linear');
            notePosY1 = noteTweenX('x4', 4, value2, 0.4, 'linear');
            notePosY2 = noteTweenX('x5', 5, value2+112, 0.4, 'linear');
            notePosY3 = noteTweenX('x6', 6, value2+224, 0.4, 'linear');
            notePosY4 = noteTweenX('x7', 7, value2+336, 0.4, 'linear');
            notePosX = getPropertyFromGroup('opponentStrums', value1, 'x');
            notePosY = getPropertyFromGroup('opponentStrums', value1, 'y');
        else
            notee = value1 - 4;
            notePosX = getPropertyFromGroup('playerStrums', notee, 'x');
            notePosY = getPropertyFromGroup('playerStrums', notee, 'y');
        end

        newnotePosX = notePosX + tableee[1];
        newnotePosY = notePosY + tableee[2];
        if value1 == "player" then
            noteTweenX('x4', 4, value2, 0.4, 'linear');
            noteTweenX('x5', 5, value2+112, 0.4, 'linear');
            noteTweenX('x6', 6, value2+224, 0.4, 'linear');
            noteTweenX('x7', 7, value2+336, 0.4, 'linear');
        elseif value1 == "opponent" then
            noteTweenX('x0', 0, value2, 0.4, 'linear');
            noteTweenX('x1', 1, value2+112, 0.4, 'linear');
            noteTweenX('x2', 2, value2+224, 0.4, 'linear');
            noteTweenX('x3', 3, value2+336, 0.4, 'linear');
        end
    end
end
