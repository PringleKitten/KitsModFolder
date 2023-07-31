function onSongStart()
    oY1 = getPropertyFromGroup('opponentStrums', 0, 'y')
    oY2 = getPropertyFromGroup('opponentStrums', 1, 'y')
    oY3 = getPropertyFromGroup('opponentStrums', 2, 'y')
    oY4 = getPropertyFromGroup('opponentStrums', 3, 'y')
    pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
    pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
    pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
    pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
end
function onEvent(name, value1, value2)
    if name == 'barsz' then    
        value1 = tonumber(value1);
        value2 = tonumber(value2)
        if value1 == 1 then
            setProperty('bars.alpha', 1);
            doTweenY('ba', 'bars.scale', 1.1, value2, 'quadInOut')
            if hide then
                noteTweenY("oY",0,oY1+90,value2,"quartInOut");
                noteTweenY("oY1",1,oY2+90,value2,"quartInOut");
                noteTweenY("oY2",2,oY3+90,value2,"quartInOut");
                noteTweenY("oY3",3,oY4+90,value2,"quartInOut");
                noteTweenY("pY",4,pY1+90,value2,"quartInOut");
                noteTweenY("pY1",5,pY2+90,value2,"quartInOut");
                noteTweenY("pY2",6,pY3+90,value2,"quartInOut");
                noteTweenY("pY3",7,pY4+90,value2,"quartInOut");
            end
        elseif value1 == 0 then
            doTweenY('ba1', 'bars.scale', 3, value2, 'quadInOut')
            if hide then
                noteTweenY("oY",0,oY1,value2,"quartInOut");
                noteTweenY("oY1",1,oY2,value2,"quartInOut");
                noteTweenY("oY2",2,oY3,value2,"quartInOut");
                noteTweenY("oY3",3,oY4,value2,"quartInOut");
                noteTweenY("pY",4,pY1,value2,"quartInOut");
                noteTweenY("pY1",5,pY2,value2,"quartInOut");
                noteTweenY("pY2",6,pY3,value2,"quartInOut");
                noteTweenY("pY3",7,pY4,value2,"quartInOut");
            end
        end
        if value1 == 8888 then
            hide = false
            setObjectCamera('bars', 'hud')
        elseif value1 == 9999 then
            hide = true
            setObjectCamera('bars', 'other')
        end
    end
end

function onUpdatePost()
    screenCenter('bars')
end

function onTweenCompleted(tag)
    if tag == 'ba1' then
        setProperty('bars.alpha', 0)
    end
end