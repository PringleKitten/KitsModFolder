function onUpdate(elapsed)
    if difficulty == 6 then
        --for 6-9k arrow movements on difficulty insane (or higher if I add more)
        if curStep >= 0 and curStep < 50000 then
            songPos = getSongPosition()
            local currentBeat = (songPos/3000)*(curBpm/15)

            noteTweenX(defaultPlayerStrumX0, 6, defaultPlayerStrumX0 - 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX1, 7, defaultPlayerStrumX1 - 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX2, 8, defaultPlayerStrumX2 - 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX3, 9, defaultPlayerStrumX3 - 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX4, 10, defaultPlayerStrumX4 - 100*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX5, 11, defaultPlayerStrumX5 - 100*math.sin((currentBeat+9*0.25)*math.pi), 0.4)
    
            noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX4, 4, defaultOpponentStrumX4 + 100*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX5, 5, defaultOpponentStrumX5 + 100*math.sin((currentBeat+9*0.25)*math.pi), 0.4)

		end
	else if difficulty <= 5 then
        --for 4k arrow movements on difficulties expert+ and lower
		if curStep >= 0 and curStep < 50000 then
			songPos = getSongPosition()
			local currentBeat = (songPos/3000)*(curBpm/15)
	
			noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
			noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
			noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

			noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

	end
end
end
end

--Function 2

function onBeatHit()
    --for every beat
    health = getProperty('health')
    if getProperty('health') > 0.2 then
    setProperty('health', health- 0.05);
    end
    local angleshit = 1;
local anglevar = 1;

function onBeatHit()
    if curBeat >= 0 then
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
end

--function 3

function opponentNoteHit()
    --for every arrow opponent hits
    health = getProperty('health')
    if getProperty('health') > 0.3 then
    setProperty('health', health- 0.1);
    end
    
end