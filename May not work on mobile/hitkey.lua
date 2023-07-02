require 'math'
math.randomseed(os.time())

hitkey = 'False'
keys = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','S','T','U','V','W','X','Y','Z'}
keytopress = 'A'

function onCreate()

	makeLuaText('pressit', 'HIT THE KEY!', '300', 400,200)
	addLuaText('pressit')
	setTextSize('pressit', 40)
	setProperty('pressit.x', (screenWidth/2)-(getProperty('pressit.width')/2))

	makeLuaText('key', keytopress, '300', 400,250)
	addLuaText('key')
	setTextSize('key', 120)

	makeLuaText('timer', '1', '300', 400,450)
	addLuaText('timer')
	setTextSize('timer', 40)

end

function onUpdate()

	setTextString('key', keytopress)
	setProperty('timer.x', (screenWidth/2)-(getProperty('timer.width')/2))
	
	setProperty('key.x', (screenWidth/2)-(getProperty('key.width')/2))
	setProperty('key.y', (screenHeight/2)-(getProperty('key.height')/2))


	if hitkey == 'True' then
		if keytopress == 'R' then
			setProperty('boyfriend.stunned', true)
		end
		setProperty('pressit.alpha', 1)
		setProperty('key.alpha', 1)
		setProperty('timer.alpha', 1)
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.' .. keytopress) then
			hitkey = 'False'
		end
		if FinalBeat - curBeat <= 0 and hitkey == 'True' then
			setProperty('health', -1)
		end
	else
		setProperty('pressit.alpha', 0)
		setProperty('key.alpha', 0)
		setProperty('timer.alpha', 0)
		setProperty('boyfriend.stunned', false)
	end

end

function onEvent(name, value1, value2)
	if name == 'hitkey' then

		
		setTextAlignment('pressit', 'center')

		time = value1
		keytopress = value2
		if keytopress == '' or keytopress == nil then
			keytopress = keys[math.random(1,table.getn(keys))]
		end
		runTimer('hitkey', 1/240, 0)
		hitkey = 'True'
		oldBeat = curBeat
		FinalBeat = oldBeat + time
		setTextString('timer', time)

end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hitkey' then

		setTextString('timer', loopsLeft)
		setTextString('timer', FinalBeat - curBeat)

	end
end