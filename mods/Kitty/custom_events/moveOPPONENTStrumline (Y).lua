function getVarr(vis)
    visuals = vis
end
local r1t = true
function onEvent(name, value1, value2)
    if name == 'moveOPPONENTStrumline (Y)' then
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
            oY1 = getPropertyFromGroup('opponentStrums', 0, 'y')
            oY2 = getPropertyFromGroup('opponentStrums', 1, 'y')
            oY3 = getPropertyFromGroup('opponentStrums', 2, 'y')
            oY4 = getPropertyFromGroup('opponentStrums', 3, 'y')
            if value1 ~= 0 then
                noteTweenY("oY",0,oY1+value1,value2,"quartInOut");
                noteTweenY("oY1",1,oY2+value1,value2,"quartInOut");
                noteTweenY("oY2",2,oY3+value1,value2,"quartInOut");
                noteTweenY("oY3",3,oY4+value1,value2,"quartInOut");
            end
        end
    end
end