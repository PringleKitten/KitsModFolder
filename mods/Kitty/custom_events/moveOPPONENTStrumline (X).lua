-- CHECK THESE IF YOU"RE PROMPTED TO!!!!!
local visuals = true

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
        setProperty('healthBar.y',640);
        setProperty('healthBarBG.y',840);
        setProperty('iconP1.y',570);
        setProperty('iconP2.y',570);
        setProperty('scoreTxt.y', 680);
        setProperty('timeTxt.y', 19);
        setProperty('timeBar.y', 31.25);
        setProperty('timeBarBG.y', 27.25);
        setPropertyFromGroup('opponentStrums',0,'y',dosy0);
        setPropertyFromGroup('opponentStrums',1,'y',dosy1);
        setPropertyFromGroup('opponentStrums',2,'y',dosy2);
        setPropertyFromGroup('opponentStrums',3,'y',dosy3);
        setPropertyFromGroup('playerStrums',0,'y',dpsy0);
        setPropertyFromGroup('playerStrums',1,'y',dpsy1);
        setPropertyFromGroup('playerStrums',2,'y',dpsy2);
        setPropertyFromGroup('playerStrums',3,'y',dpsy3);
        setPropertyFromGroup('opponentStrums',0,'x',dosx0);
        setPropertyFromGroup('opponentStrums',1,'x',dosx1);
        setPropertyFromGroup('opponentStrums',2,'x',dosx2);
        setPropertyFromGroup('opponentStrums',3,'x',dosx3);
        setPropertyFromGroup('playerStrums',0,'x',dpsx0);
        setPropertyFromGroup('playerStrums',1,'x',dpsx1);
        setPropertyFromGroup('playerStrums',2,'x',dpsx2);
        setPropertyFromGroup('playerStrums',3,'x',dpsx3);
        r1t = false
    end end
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