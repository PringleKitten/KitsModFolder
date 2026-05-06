function onCreatePost()
    opY1 = getPropertyFromGroup('playerStrums', 0, 'y')
    opY2 = getPropertyFromGroup('playerStrums', 1, 'y')
    opY3 = getPropertyFromGroup('playerStrums', 2, 'y')
    opY4 = getPropertyFromGroup('playerStrums', 3, 'y')
end

function onBeatHit()
    if curBeat == 81 then
        doTweenZoom('out', 'hud', 0.01, 6.3, 'sineIn')
    elseif curBeat == 97 then
        z = true
    elseif curBeat == 129 then
        z = false
    elseif curBeat == 137 then
        z = true
    elseif curBeat == 225 then
        z = false
    elseif curBeat == 305 then
        doTweenZoom('out', 'hud', 0.01, 6.3, 'sineIn')
    elseif curBeat == 321 then
        z = true
    elseif curBeat == 353 then
        z = false
    elseif curBeat == 361 then
        z = true
    elseif curBeat == 381 then
        z = false
    end

    if z then
        doTweenZoom('bop', 'hud', 1.1, 0.07, 'sineOut')
    end
end

function onStepHit()
    pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
    pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
    pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
    pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
    if curStep == 379 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 381 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 383 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 385 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 387 then
        noteTweenY("pY0",4,opY1,0.2,"backIn");
        noteTweenY("pY1",5,opY2,0.2,"backIn");
        noteTweenY("pY2",6,opY3,0.2,"backIn");
        noteTweenY("pY3",7,opY4,0.2,"backIn");
    elseif curStep == 1275 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 1277 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 1279 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 1281 then
        noteTweenY("pY0",4,pY1+125,0.2,"backIn");
        noteTweenY("pY1",5,pY2+125,0.2,"backIn");
        noteTweenY("pY2",6,pY3+125,0.2,"backIn");
        noteTweenY("pY3",7,pY4+125,0.2,"backIn");
    elseif curStep == 1283 then
        noteTweenY("pY0",4,opY1,0.2,"backIn");
        noteTweenY("pY1",5,opY2,0.2,"backIn");
        noteTweenY("pY2",6,opY3,0.2,"backIn");
        noteTweenY("pY3",7,opY4,0.2,"backIn");
    end
end

function onTweenCompleted(tag)
    if tag == 'bop' then
        doTweenZoom('bopE', 'hud', 1, 0.33, 'sineIn')
    end
end

function DOWN(arrow)
    setProperty('healthBar.y',40);
    setProperty('healthBarBG.y',40);
    setPropertyFromGroup('opponentStrums',arrow,'downScroll',true);
    setPropertyFromGroup('playerStrums',arrow,'downScroll',true);
end
function UP(arrow)
    setProperty('healthBar.y',680);
    setProperty('healthBarBG.y',880);
    setPropertyFromGroup('opponentStrums',arrow,'downScroll',false);
    setPropertyFromGroup('playerStrums',arrow,'downScroll',false);
end

function onUpdate()
    if getPropertyFromGroup('playerStrums', 0, 'y') > screenHeight/2 then
        DOWN(0)
    else
        UP(0)
    end
    if getPropertyFromGroup('playerStrums', 1, 'y') > screenHeight/2 then
        DOWN(1)
    else
        UP(1)
    end
    if getPropertyFromGroup('playerStrums', 2, 'y') > screenHeight/2 then
        DOWN(2)
    else
        UP(2)
    end
    if getPropertyFromGroup('playerStrums', 3, 'y') > screenHeight/2 then
        DOWN(3)
    else
        UP(3)
    end
end