--Function 1
function onUpdate(elapsed)
--I DON'T KNOW WHY SOMEONE HELP ME FIX THIS >> The arrows move like normal but when the event ends, the arrows DO stop but they SQUISH TOGETHER 

--1st Beat drop


    if difficulty == 5 then     --for 6-9k arrow movements on difficulty insane (or higher if I add more)
        if curStep >= 944 and curStep < 1968 then --When to run the arrow movements
            songPos = getSongPosition()
            local currentBeat = (songPos/3000)*(curBpm/15)

            noteTweenX(defaultPlayerStrumX0, 6, defaultPlayerStrumX0 - 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
            noteTweenX(defaultPlayerStrumX1, 7, defaultPlayerStrumX1 - 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
            noteTweenX(defaultPlayerStrumX2, 8, defaultPlayerStrumX2 - 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX3, 9, defaultPlayerStrumX3 - 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX4, 10, defaultPlayerStrumX4 - 500*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX5, 11, defaultPlayerStrumX5 - 500*math.sin((currentBeat+9*0.25)*math.pi), 0.4)
    
            noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX4, 4, defaultOpponentStrumX4 + 500*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX5, 5, defaultOpponentStrumX5 + 500*math.sin((currentBeat+9*0.25)*math.pi), 0.4)
		end
    end
	if difficulty <= 4 then    --for 4k arrow movements on difficulties expert+ and lower
		if curStep >= 944 and curStep < 1968 then --When to run the arrow movements
			songPos = getSongPosition()
			local currentBeat = (songPos/3000)*(curBpm/15)
	
			noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
			noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
			noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

			noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
        end
    end --End if difficulty


--2nd beat drop


    if difficulty == 5 then
        if curStep >= 2720 and curStep < 3744 then --When to run the arrow movements
            songPos = getSongPosition()
            local currentBeat = (songPos/3000)*(curBpm/15)

            noteTweenX(defaultPlayerStrumX0, 6, defaultPlayerStrumX0 - 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
            noteTweenX(defaultPlayerStrumX1, 7, defaultPlayerStrumX1 - 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
            noteTweenX(defaultPlayerStrumX2, 8, defaultPlayerStrumX2 - 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX3, 9, defaultPlayerStrumX3 - 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX4, 10, defaultPlayerStrumX4 - 500*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX5, 11, defaultPlayerStrumX5 - 500*math.sin((currentBeat+9*0.25)*math.pi), 0.4)

            noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX4, 4, defaultOpponentStrumX4 + 500*math.sin((currentBeat+8*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX5, 5, defaultOpponentStrumX5 + 500*math.sin((currentBeat+9*0.25)*math.pi), 0.4)

        else
            songPos = getSongPosition()
            local currentBeat = (songPos/3000)*(curBpm/15)

            noteTweenX(defaultPlayerStrumX0, 6, defaultPlayerStrumX0 - 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
            noteTweenX(defaultPlayerStrumX1, 7, defaultPlayerStrumX1 - 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
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
    end
    if difficulty <= 4 then    --for 4k arrow movements on difficulties expert+ and lower
        if curStep >= 2720 and curStep < 3744 then --When to run the arrow movements
            songPos = getSongPosition()
            local currentBeat = (songPos/3000)*(curBpm/15)

            noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
            noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
            noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

            noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 500*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 500*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 500*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
            noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 500*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

        else
            songPos = getSongPosition()
			local currentBeat = (songPos/3000)*(curBpm/15)
	
			noteTweenX(defaultPlayerStrumX0, 4, defaultPlayerStrumX0 - 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4) --The 500 Variable is how big the arrow movements are
			noteTweenX(defaultPlayerStrumX1, 5, defaultPlayerStrumX1 - 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4) --The 0.4 Variable is how fast the arrows move
			noteTweenX(defaultPlayerStrumX2, 6, defaultPlayerStrumX2 - 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultPlayerStrumX3, 7, defaultPlayerStrumX3 - 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)

			noteTweenX(defaultOpponentStrumX0, 0, defaultOpponentStrumX0 + 100*math.sin((currentBeat+4*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX1, 1, defaultOpponentStrumX1 + 100*math.sin((currentBeat+5*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX2, 2, defaultOpponentStrumX2 + 100*math.sin((currentBeat+6*0.25)*math.pi), 0.4)
			noteTweenX(defaultOpponentStrumX3, 3, defaultOpponentStrumX3 + 100*math.sin((currentBeat+7*0.25)*math.pi), 0.4)
        end
    end
end --End this function
--


--Function 2
function onBeatHit() --Each beat do...
    if difficulty == 5 then --If Insane difficulty do...
        if curStep >= 944 and curStep < 1968 then --if song is in cutStep () do...
            health = getProperty('health') --Hurt player VV
            if getProperty('health') > 0.2 then
               setProperty('health', health- 0.05);
             end
        end --End curStep checker
        if curStep >= 2720 and curStep < 3744 then --New curStep checker
            health = getProperty('health')
            if getProperty('health') > 0.2 then
                setProperty('health', health- 0.05);
            end
        end --End curStep checker
    end --End difficulty checker
end --End this function
--


--Function 3