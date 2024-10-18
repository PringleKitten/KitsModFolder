function getVarr(vis)
    visuals = vis
end
local r1t = true
function onEvent(name, value1, value2)
    if name == 'moveOPPONENTStrumline (X)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == 'assetMovement' then
            bugged = true
        else
            bugged = false
        end
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true or (bugged and visuals) then
            if r1t then
                if getPropertyFromClass("ClientPrefs", "downScroll") == true or getPropertyFromClass("ClientPrefs", "middleScroll") == true then
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in clientPrefs so you dont have visual bugs!')
                    r1t = false
                end
            end
            oX1 = getPropertyFromGroup('opponentStrums', 0, 'x')
            oX2 = getPropertyFromGroup('opponentStrums', 1, 'x')
            oX3 = getPropertyFromGroup('opponentStrums', 2, 'x')
            oX4 = getPropertyFromGroup('opponentStrums', 3, 'x')
            if value1 ~= 0 then
                noteTweenX("oX",0,oX1+value1,value2,"quartInOut");
                noteTweenX("oX1",1,oX2+value1,value2,"quartInOut");
                noteTweenX("oX2",2,oX3+value1,value2,"quartInOut");
                noteTweenX("oX3",3,oX4+value1,value2,"quartInOut");
            end
        end
    end
end