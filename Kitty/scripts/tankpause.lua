local varmath = 0
local countdww =  {"go", "set", "ready"}
local pixelvar = {"pixelUI/date-pixel", "pixelUI/set-pixel", "pixelUI/ready-pixel"}

function onCreatePost()
	if week == 'week7' then
		doScript = true
		for intro = 1, 3 do
			if getProperty('isPixelStage') == true then --no fucking idea why it works like this
				makeLuaSprite('introshit'..intro, pixelvar[intro], -6900, -6900)
				scaleObject('introshit'..intro, 2, 2)
				setProperty('introshit'..intro..'.antialiasing', false)
				scaleObject('introshit'..intro, 6, 6)
				
			else 
				makeLuaSprite('introshit'..intro, countdww[intro], -6900, -6900)
				
			end
			
			makeLuaSprite('thingsy', nil, 0, 0)
			makeGraphic('thingsy', screenWidth, screenHeight, '000000')
			setProperty('thingsy.alpha', 0)
				
			setObjectCamera('thingsy', 'other')
			setObjectCamera('introshit'..intro, 'other')
			addLuaSprite('thingsy', true)
			addLuaSprite('introshit'..intro, true)
		end
end

function onUpdate()
	if pawse then
		setPropertyFromClass('Conductor', 'songPosition',currentpausepos)
		setPropertyFromClass('flixel.FlxG', 'sound.music.time',currentpausepos)
		setProperty('vocals.time',currentpausepos)
		--DO   NOT   DELETE   THIS--
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
		setProperty('vocals.volume', 0)
		--THIS--
	end	end
end

function onPause()
	if doScript then
	if pawse then
		cameraShake('camGame', 0.008, 0.1)
		playSound('ANGRY')
		return Function_Stop
	else
		if curBeat > 0	then
			currentpausepos = getPropertyFromClass('Conductor', 'songPosition')
			cancelTween('bckgp')
			setProperty('thingsy.alpha', 0)
		end
	end end
end

function onResume()
	if doScript then
	if curBeat > 1 then
		if not pawse then
			pausecurcountdown = 4
			runTimer('ptime', varmath)
			setProperty('thingsy.alpha', 0.6)
			pawse = true
		end
	end end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if doScript then
	varmath = (1 / ((bpm) / 60))
	if tag == 'ptime' then
		if pausecurcountdown > 0 then	
			screenCenter('introshit'..(pausecurcountdown+1), 'xy')
			doTweenAlpha('leintro'..pausecurcountdown,'introshit'..(pausecurcountdown+1), 0 , varmath)
			
			if getProperty('isPixelStage') == true then  --no fucking idea why it works like this
				playSound('intro'..(pausecurcountdown)..'-pixel')
				
			else
				playSound('intro'..(pausecurcountdown))
			end
		end
		
		if pausecurcountdown == 4 then		
			doTweenAlpha('bckgp','thingsy', 0, varmath * 6, 'quartInOut')	
			
			for intro = 1, 3 do
				setProperty('introshit'..intro..'.x' , 6900)
				setProperty('introshit'..intro..'.alpha' , 1)
			end
		end
		
		if pausecurcountdown == 0 then	
			if getProperty('isPixelStage') == true then --no fucking idea why it works like this
				playSound('introGo-pixel')
			else
				playSound('introGo')
			end
			screenCenter('introshit1', 'xy')
			runTimer('st', varmath)
			doTweenAlpha('GO','introshit1', 0 , varmath)
		end
		
			if pausecurcountdown ~= 0 then	
			runTimer('ptime', varmath)
			pausecurcountdown = pausecurcountdown - 1
			
		end
	end
	if tag == 'st' then
			pawse = false
			setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 1)
			setProperty('vocals.volume', 1)
	end end
end