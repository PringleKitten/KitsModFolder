function onBeatHit()
    if curStep >= 320 and curStep <= 576 then
        triggerEvent('Screen Shake', '0, 0', '0.08, 0.025'); 
        characterPlayAnim('bf', 'idle', true);
    end
    if curStep >= 886 and curStep <= 1144 then
        triggerEvent('Screen Shake', '0, 0', '0.08, 0.025'); 
        characterPlayAnim('bf', 'idle', true);
    end
    if curStep >= 1214 and curStep <= 1336 then
        triggerEvent('Screen Shake', '0, 0', '0.08, 0.025'); 
        characterPlayAnim('bf', 'idle', true);
    end
    if curStep >= 1756 and curStep <= 1884 then
        triggerEvent('Screen Shake', '0, 0', '0.08, 0.025'); 
        characterPlayAnim('bf', 'idle', true);
    end
end