local r1t = true
function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false then
        close(true)
    end
end

function onEvent(name, value1, value2)
    if name == 'moveOPPONENTStrumline (Y)' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
            if r1t then
                if getPropertyFromClass("ClientPrefs", "downScroll") == true or getPropertyFromClass("ClientPrefs", "middleScroll") == true then
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    debugPrint('Hey bro, turn off downscroll or middlescroll in ClientPrefs so you dont have visual bugs!')
                    r1t = false
                end
            end
            oY1 = getPropertyFromGroup('opponentStrums', 0, 'y')
            oY2 = getPropertyFromGroup('opponentStrums', 1, 'y')
            oY3 = getPropertyFromGroup('opponentStrums', 2, 'y')
            oY4 = getPropertyFromGroup('opponentStrums', 3, 'y')
            if value1 ~= 0 then
                if value2 > 0.012 then
                    noteTweenY("oY",0,oY1+value1,value2,"quartInOut");
                    noteTweenY("oY1",1,oY2+value1,value2,"quartInOut");
                    noteTweenY("oY2",2,oY3+value1,value2,"quartInOut");
                    noteTweenY("oY3",3,oY4+value1,value2,"quartInOut");
                elseif value2 < 0.012 then
                    setPropertyFromGroup('opponentStrums',0,'y',oY1+value1);
                    setPropertyFromGroup('opponentStrums',1,'y',oY2+value1);
                    setPropertyFromGroup('opponentStrums',2,'y',oY3+value1);
                    setPropertyFromGroup('opponentStrums',3,'y',oY4+value1);
                end
            end
        end
    end
end