-- CHECK THESE IF YOU"RE PROMPTED TO!!!!!
local visuals = true

local r1t = true
function onEvent(name, value1, value2)
    if name == 'movePLAYERStrumline (X)' then
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
            pX1 = getPropertyFromGroup('playerStrums', 0, 'x')
            pX2 = getPropertyFromGroup('playerStrums', 1, 'x')
            pX3 = getPropertyFromGroup('playerStrums', 2, 'x')
            pX4 = getPropertyFromGroup('playerStrums', 3, 'x')
            if value1 ~= 0 then
                noteTweenX("pX",4,pX1+value1,value2,"quartInOut");
                noteTweenX("pX1",5,pX2+value1,value2,"quartInOut");
                noteTweenX("pX2",6,pX3+value1,value2,"quartInOut");
                noteTweenX("pX3",7,pX4+value1,value2,"quartInOut");
            end
        end
    end
end