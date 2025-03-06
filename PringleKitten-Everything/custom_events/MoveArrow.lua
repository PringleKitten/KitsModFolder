local r1t = true
function mysplit (inputstr, sep)
    if getPropertyFromClass("backend.ClientPrefs", "data.assetMovement") then
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
        if getPropertyFromClass("backend.ClientPrefs", "data.assetMovement") then
            if r1t then
                if getPropertyFromClass("ClientPrefs", "downScroll") == true or getPropertyFromClass("ClientPrefs", "middleScroll") == true then
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false)
                        setPropertyFromGroup('playerStrums',i,'downScroll',false)
                    end
                    r1t = false
                end
            end

            local tableee=mysplit(value2,", "); -- Splits value1 into a table
            value1 = tonumber(value1);
            if tableee[1] == tonumber(tableee[1]) and tableee[2] == tonumber(tableee[2]) then
                tableee[1] = tonumber(tableee[1]);
                tableee[2] = tonumber(tableee[2]);
            else
                tableee[1] = tableee[1]
                tableee[2] = tableee[2]
            end
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
            if value1 == 0 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx1",0,newnotePosX,duration,"quartInOut");
                    noteTweenY("my1",0,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr1",0,rotation,duration, "quartInOut");
                noteTweenAlpha("mo1",0,opacity,duration,"quartInOut");
            end
            if value1 == 1 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx2",1,newnotePosX,duration,"quartInOut");
                    noteTweenY("my2",1,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr2",1,rotation,duration, "quartInOut");
                noteTweenAlpha("mo2",1,opacity,duration,"quartInOut");
            end
            if value1 == 2 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx3",2,newnotePosX,duration,"quartInOut");
                    noteTweenY("my3",2,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr3",2,rotation,duration, "quartInOut");
                noteTweenAlpha("mo3",2,opacity,duration,"quartInOut");
            end
            if value1 == 3 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx4",3,newnotePosX,duration,"quartInOut");
                    noteTweenY("my4",3,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr4",3,rotation,duration, "quartInOut");
                noteTweenAlpha("mo4",3,opacity,duration,"quartInOut");
            end
            if value1 == 4 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx5",4,newnotePosX,duration,"quartInOut");
                    noteTweenY("my5",4,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr5",4,rotation,duration, "quartInOut");
                noteTweenAlpha("mo5",4,opacity,duration,"quartInOut");
            end
            if value1 == 5 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx6",5,newnotePosX,duration,"quartInOut");
                    noteTweenY("my6",5,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr6",5,rotation,duration, "quartInOut");
                noteTweenAlpha("mo6",5,opacity,duration,"quartInOut");
            end
            if value1 == 6 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx7",6,newnotePosX,duration,"quartInOut");
                    noteTweenY("my7",6,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr7",6,rotation,duration, "quartInOut");
                noteTweenAlpha("mo7",6,opacity,duration,"quartInOut");
            end
            if value1 == 7 then
                if (tableee[1] ~= '00' and tableee[2] ~= '00') then
                    noteTweenX("mx8",7,newnotePosX,duration,"quartInOut");
                    noteTweenY("my8",7,newnotePosY,duration,"quartInOut");
                end
                noteTweenAngle("mr8",7,rotation,duration, "quartInOut");
                noteTweenAlpha("mo8",7,opacity,duration,"quartInOut");
            end
        end
    end
end