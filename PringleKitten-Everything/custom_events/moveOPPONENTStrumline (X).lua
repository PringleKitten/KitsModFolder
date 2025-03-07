local r1t = true
function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false then
        close(true)
    end
end

function onEvent(name, value1, value2)
    if name == 'moveOPPONENTStrumline (X)' then
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
            oX1 = getPropertyFromGroup('opponentStrums', 0, 'x')
            oX2 = getPropertyFromGroup('opponentStrums', 1, 'x')
            oX3 = getPropertyFromGroup('opponentStrums', 2, 'x')
            oX4 = getPropertyFromGroup('opponentStrums', 3, 'x')
            if value1 ~= 0 then
                if value2 > 0.012 then
                    noteTweenX("oX",0,oX1+value1,value2,"quartInOut");
                    noteTweenX("oX1",1,oX2+value1,value2,"quartInOut");
                    noteTweenX("oX2",2,oX3+value1,value2,"quartInOut");
                    noteTweenX("oX3",3,oX4+value1,value2,"quartInOut");
                elseif value2 < 0.012 then
                    setPropertyFromGroup('opponentStrums',0,'x',oX1+value1);
                    setPropertyFromGroup('opponentStrums',1,'x',oX2+value1);
                    setPropertyFromGroup('opponentStrums',2,'x',oX3+value1);
                    setPropertyFromGroup('opponentStrums',3,'x',oX4+value1);
                end
            end
        end
    end
end