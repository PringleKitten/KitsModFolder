local angleshit = 1;
local anglevar = 1;
function onBeatHit()
    if curBeat >= 176 then
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

function opponentNoteHit()
    if curBeat >= 174 then
        health = getProperty('health')
        if getProperty('health') > 0.4 then
        setProperty('health', health- 0.05);
        end
    end
end