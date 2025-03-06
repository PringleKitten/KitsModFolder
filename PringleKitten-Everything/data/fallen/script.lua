local angleshit = 1;
local anglevar = 1;
function onBeatHit()
    if curBeat >= 96 and curBeat <= 158 then
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
    if curStep == 0 then -- First time
        setPropertyFromClass('ClientPrefs', 'camZooms', false);
    elseif curStep == 4 then
        setPropertyFromClass('ClientPrefs', 'camZooms', true);
    end
end

function opponentNoteHit()
    health = getProperty('health')
    if getProperty('health') > 0.6 then
        setProperty('health', health- 0.01);
    end
    if curBeat >= 96 and curBeat <= 158 then
        cameraShake('cam', '0.002', '0.1')
        cameraShake('hud', '0.002', '0.1')
        health = getProperty('health')
        if getProperty('health') > 0.2 then
            setProperty('health', health- 0.07);
        end
    end
end