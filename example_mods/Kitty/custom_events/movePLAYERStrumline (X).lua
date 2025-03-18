if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
    close()
end
local r1t = true

function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (X)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if r1t then
            if getPropertyFromClass("backend.ClientPrefs", "data.downScroll") == true or getPropertyFromClass("backend.ClientPrefs", "data.middleScroll") == true then
                debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                r1t = false
            end
        end
        pX1 = getPropertyFromGroup('playerStrums', 0, 'x')
        pX2 = getPropertyFromGroup('playerStrums', 1, 'x')
        pX3 = getPropertyFromGroup('playerStrums', 2, 'x')
        pX4 = getPropertyFromGroup('playerStrums', 3, 'x')
        if value1 ~= 0 then
            if value2 > 0.012 then
                noteTweenX("pX",4,pX1+value1,value2,"quartInOut");
                noteTweenX("pX1",5,pX2+value1,value2,"quartInOut");
                noteTweenX("pX2",6,pX3+value1,value2,"quartInOut");
                noteTweenX("pX3",7,pX4+value1,value2,"quartInOut");
            elseif value2 < 0.012 or value2 == 0 then
                setPropertyFromGroup('playerStrums',0,'x',pX1+value1);
                setPropertyFromGroup('playerStrums',1,'x',pX2+value1);
                setPropertyFromGroup('playerStrums',2,'x',pX3+value1);
                setPropertyFromGroup('playerStrums',3,'x',pX4+value1);
            end
        end
    end
end