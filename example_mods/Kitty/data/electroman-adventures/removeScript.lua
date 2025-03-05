function onSongStart()
    runTimer("destroyScript",5,1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'destroyScript' then
        for i = 1,4 do
			removeLuaScript('Credit.lua')
            close(true)
		end
    end
end