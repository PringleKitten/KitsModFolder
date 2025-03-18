function onCreatePost()
    if buildTarget == 'windows' and difficultyName == 'Insanity' then
        luaGraphic('RED', 0, 0, 1280, 720, 'CC0000')
        makeLuaText('warning', 'Warning, if you downloaded this anywhere other than the OFFICIAL Gamebanana Link, you may be in danger. \n This song runs Windows Powershell scripts that are a powerful tool. \n If you are asked for Admin, or you think you aren\'t safe, \n PLEASE download from the official Gamebanana Page at \n https://gamebanana.com/mods/355577 \n \n Type \"OK\" if you acknowledge', 1280, 5, 60)
        setTextColor('warning', 'FFFF00')
        setTextSize('warning', 48)
        setObjectCamera('warning', 'other')
        setObjectOrder('warning', 500)
        addLuaText('warning', true)
    else
        callScript('scripts/LaneUnderlay', 'sawDisclaimer', {true})
        close()
    end
end

function onUpdatePost()
    allowCountdown = false
    if keyboardJustPressed('O') then
        O = true
    end
    if keyboardJustPressed('K') and O then
        removeLuaSprite('RED')
        removeLuaText('warning')
        callScript('scripts/LaneUnderlay', 'sawDisclaimer', {true})
        close()
    end
end

function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		return Function_Continue
	end
end

function luaGraphic(tag,xPos,yPos,width,height,color)
    makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, width, height, color)
    setScrollFactor(tag, 0.0, 0.0)
	setObjectCamera(tag, 'other')
    setObjectOrder(tag, 499)
    setProperty(tag..'.alpha', 1)
	addLuaSprite(tag, true)
end