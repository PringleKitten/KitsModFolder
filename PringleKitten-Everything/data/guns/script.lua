local allowCountdown = false
function onStartCountdown()
	if not allowCountdown and not seenCutscene then --Block the first countdown
		setProperty('inCutscene', true);
		startVideo('gunsCutscene');
		setObjectCamera('videoCutscene','other')
		setProperty('canPause', true)
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onCountdownTick(counter)
	if counter == 0 then
		setProperty('inCutscene', false);
    	callMethod('remove', {instanceArg('videoCutscene'), true})
		removeLuaSprite("videoCutscene")
		setProperty('canPause', true)
		close()
	end
end