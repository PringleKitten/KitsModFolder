function onCreate()
    --variables
    Dodged = false;
    canDodge = false;
    DodgeTime = 0;
    twice = 0;
    precacheImage('spacebar');
    precacheSound('DODGE');
    precacheImage('dodge1');
end

function onEvent(name, value1, value2)
    if name == "DodgeEvent" then
        --Get Dodge time
        DodgeTime = (value1);
        Dodged = false;
        
        --Make Dodge Sprite
        makeLuaSprite('spacebar', 'me/popup/spacebar', 200, 200);
        setObjectCamera('spacebar', 'other');
        scaleLuaSprite('spacebar', 10, 10); 
        addLuaSprite('spacebar', true); 
        
        --Set values so you can dodge
        playSound('DODGE');
        canDodge = true;
        runTimer('Died', DodgeTime);
        twice = twice+1;
        
	end
end

function onUpdate()
    --debugPrint(canDodge,botPlay)
    if twice == 2 then
        twice = 0
        setProperty('health', getProperty('health')-.8);
        removeLuaSprite('spacebar');
    end
    if (canDodge == true and keyPressed('space')) or (botPlay == true and canDodge == true) then
        Dodged = true;
        twice = 0;
        removeLuaSprite('spacebar');
        canDodge = false
        setProperty('health', getProperty('health')+.06)
    end

end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'Died' and Dodged == false then
        setProperty('health', getProperty('health')-.8);
        removeLuaSprite('spacebar');
        twice = 0
    elseif tag == 'Died' and Dodged == true then
        Dodged = false
        removeLuaSprite('spacebar');
        twice = 0

    end
end