-- CHECK THESE IF YOU"RE PROMPTED TO!!!!!
local visuals = true

local r1t = true
function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (Y)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == 'assetMovement' then
            bugged = true
        else
            bugged = false
        end
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true or (bugged and visuals) == true then
            if r1t then
                if getPropertyFromClass("ClientPrefs", "downScroll") == true or getPropertyFromClass("ClientPrefs", "middleScroll") == true then
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false)
                        setPropertyFromGroup('playerStrums',i,'downScroll',false)
                    end
                    r1t = false
                end
            end
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