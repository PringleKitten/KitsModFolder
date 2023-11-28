
function onEvent(name,value1,value2)
    if name == 'hudbounce' then
        value1 = tonumber(value1)
        if value1 == 1 then
            yes = true
        elseif value1 == 0 then
            yes = false
            setProperty('camHUD.angle',0)
            setProperty('camHUD.x',0)
            setProperty('camHUD.y',0)
            doTweenY('rir', 'camHUD', 0, stepCrochet*0.002, 'sineIn')
            doTweenY('ryr', 'camGame.scroll', 0, stepCrochet*0.002, 'sineIn')
        elseif value1 == 5 then
            bounce = true
        end
    end
end

function onBeatHit()
    if yes or bounce then
	if curBeat > 0 then

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
	else
		setProperty('camHUD.angle',0)
		setProperty('camHUD.x',0)
		setProperty('camHUD.x',0)
	end
    bounce = false
end
end

function onStepHit()
    if yes or bounce then
	if curBeat > 0 then
		if curStep % 4 == 0 then
			doTweenY('rrr', 'camHUD', -15, stepCrochet*0.002, 'circOut')
			doTweenY('rtr', 'camGame.scroll', 0, stepCrochet*0.002, 'sineIn')
		end
		if curStep % 4 == 2 then
			doTweenY('rir', 'camHUD', 0, stepCrochet*0.002, 'sineIn')
			doTweenY('ryr', 'camGame.scroll', 0, stepCrochet*0.002, 'sineIn')
            bounce = false
		end
	end
end
end