local angleshit = 1;
local anglevar = 1;
function onBeatHit()
    if curBeat >= 36 and curBeat <= 180 then
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
        setProperty('camHUD.angle',angleshit*3)
        setProperty('camGame.angle',angleshit*3)
        doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
        doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
    end
    if curBeat >= 184 and curBeat <= 344 then
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
        setProperty('camHUD.angle',angleshit*3)
        setProperty('camGame.angle',angleshit*3)
        doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
        doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
    end
end
function onUpdate()
    if curStep >= 141 and curStep < 712 then
        setPropertyFromClass('ClientPrefs', 'camZooms', true);
    elseif curStep > 714 and curStep < 732 then
        setPropertyFromClass('ClientPrefs', 'camZooms', false);
    end
    if curStep >= 735 and curStep < 1374 then
        setPropertyFromClass('ClientPrefs', 'camZooms', true);
    elseif curStep > 1375 then
        setPropertyFromClass('ClientPrefs', 'camZooms', false);
    end
    if curStep >= 1712 then
        setPropertyFromClass('ClientPrefs', 'camZooms', true);
    end
    if curStep < 15 then
        setPropertyFromClass('ClientPrefs', 'camZooms', false);
    end
end