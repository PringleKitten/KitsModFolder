if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
    close()
end
local r1t = true

function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (Y)' then
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
        pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
        pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
        pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
        pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
        if value1 ~= 0 then
            if value2 > 0.012 then
                noteTweenY("pY",4,pY1+value1,value2,"quartInOut");
                noteTweenY("pY1",5,pY2+value1,value2,"quartInOut");
                noteTweenY("pY2",6,pY3+value1,value2,"quartInOut");
                noteTweenY("pY3",7,pY4+value1,value2,"quartInOut");
            elseif value2 < 0.012 then
                setPropertyFromGroup('playerStrums',0,'y',pY1+value1);
                setPropertyFromGroup('playerStrums',1,'y',pY2+value1);
                setPropertyFromGroup('playerStrums',2,'y',pY3+value1);
                setPropertyFromGroup('playerStrums',3,'y',pY4+value1);
            end
        end
    end
end