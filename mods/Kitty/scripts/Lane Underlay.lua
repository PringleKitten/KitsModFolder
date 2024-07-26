--Made by RamenDominoes
--Hope you like it! <3


allowCountdown = false
allowVerticalScroll = true
allowHorizontalScroll = false
visualLaneOpacity = 1 * 100

selectedBeginSong = true
	beginSongConfirm = 'YES'

selectedUnderlaySettings = false
	selectedUnderlayTypeSettings = false
		underlayTypeSettings = 'None' -- Options are 'None', 'Player Only', 'Player and Opponent'
	selectedUnderlayOpacitySettings = false


--------------------------------------------------------------------------------------
------------------------------Beginning of Script Set UP------------------------------
--------------------------------------------------------------------------------------

function simpleishGraphic(tag, xPos, yPos, graphicWidth, graphicHeight, color, camera)
	makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, graphicWidth, graphicHeight, color)
	setObjectCamera(tag, camera)
	addLuaSprite(tag)
end
function simpleishText(tag, text, textWidth, xPos, yPos, size, alignment, camera)
	makeLuaText(tag, text, textWidth, xPos, yPos)
	setTextSize(tag, size)
	setTextBorder(tag, 2, '838383')
	setTextAlignment(tag, alignment)
	setObjectCamera(tag, camera)
	addLuaText(tag)
end
function keyPress(key)
	return getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key)
end
--------------------------------------------------------------------------------------
---------------------------------End of Script Set Up---------------------------------
--------------------------------------------------------------------------------------

function onCreatePost()

	simpleishGraphic('BG', 0, 0, screenWidth, screenHeight, '06000e', 'other')

	simpleishText('Song Start', 'Begin Song?', screenWidth, 0, 90, 60, 'center', 'other')

	simpleishText('UnderLaySettingsHeader', 'UnderLay Settings', screenWidth, 0, 225, 60, 'center', 'other')

	simpleishText('UnderLayTypeSetting', 'UnderLay Type: [ '..underlayTypeSettings..' ]', screenWidth, 0, 360, 40, 'center', 'other')
	simpleishText('UnderLayOpacitySetting', 'UnderLay Opacity: [ '..visualLaneOpacity..'% ]', screenWidth, 0, 450, 40, 'center', 'other')

	simpleishText('AssistText', '(PlaceHolderText)', screenWidth, 0, 680, 30, 'center', 'other')
	setProperty('AssistText.alpha', 0.9)

	simpleishText('NavigationText', 'CONTROLS: "SPACE" to select | "BACKSPACE" to deselect | Arrow Keys to navigate', screenWidth, 0, 680, 25, 'center', 'other')

end

function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		return Function_Continue
	end
end

function onUpdate()
	if keyPress('SPACE') and selectedBeginSong then
		allowCountdown = true
		startCountdown()

	elseif keyPress('SPACE') and allowVerticalScroll and selectedUnderlaySettings then
		selectedUnderlaySettings = false
		selectedUnderlayTypeSettings = true
		allowHorizontalScroll = true

	elseif keyPress('BACKSPACE') and not selectedBeginSong and allowVerticalScroll and selectedUnderlayTypeSettings then
		selectedUnderlaySettings = true
		selectedUnderlayTypeSettings = false
		allowHorizontalScroll = false
	elseif keyPress('BACKSPACE') and not selectedBeginSong and allowVerticalScroll and selectedUnderlayOpacitySettings then
		selectedUnderlaySettings = true
		selectedUnderlayOpacitySettings = false
		allowHorizontalScroll = false
	end


	if keyPress('UP') and allowVerticalScroll and selectedBeginSong then
		selectedBeginSong = false
		selectedUnderlaySettings = true
	elseif keyPress('UP') and allowVerticalScroll and selectedUnderlaySettings then
		selectedBeginSong = true
		selectedUnderlaySettings = false

		elseif keyPress('UP') and allowVerticalScroll and selectedUnderlayTypeSettings then
			selectedUnderlayTypeSettings = false
			selectedUnderlayOpacitySettings = true
		elseif keyPress('UP') and allowVerticalScroll and selectedUnderlayOpacitySettings then
			selectedUnderlayTypeSettings = true
			selectedUnderlayOpacitySettings = false

	elseif keyPress('DOWN') and allowVerticalScroll and selectedBeginSong then
		selectedBeginSong = false
		selectedUnderlaySettings = true
	elseif keyPress('DOWN') and allowVerticalScroll and selectedUnderlaySettings then
		selectedBeginSong = true
		selectedUnderlaySettings = false

		elseif keyPress('DOWN') and allowVerticalScroll and selectedUnderlayTypeSettings then
			selectedUnderlayTypeSettings = false
			selectedUnderlayOpacitySettings = true
		elseif keyPress('DOWN') and allowVerticalScroll and selectedUnderlayOpacitySettings then
			selectedUnderlayTypeSettings = true
			selectedUnderlayOpacitySettings = false


	elseif keyPress('LEFT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
		underlayTypeSettings = 'Player and Opponent'
	elseif keyPress('LEFT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
		underlayTypeSettings = 'Player Only'
	elseif keyPress('LEFT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
		underlayTypeSettings = 'None'

		elseif keyPress('LEFT') and allowHorizontalScroll and selectedUnderlayOpacitySettings then
			visualLaneOpacity = (visualLaneOpacity - (0.1 * 100))
			if visualLaneOpacity < (0.1 * 100) then
				visualLaneOpacity = 0
			end
		elseif keyPress('RIGHT') and allowHorizontalScroll and selectedUnderlayOpacitySettings then
			visualLaneOpacity = (visualLaneOpacity + (0.1 * 100))
			if visualLaneOpacity > (0.9 * 100) then
				visualLaneOpacity = 100
			end

	elseif keyPress('RIGHT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
		underlayTypeSettings = 'Player Only'
	elseif keyPress('RIGHT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
		underlayTypeSettings = 'Player and Opponent'
	elseif keyPress('RIGHT') and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
		underlayTypeSettings = 'None'
	end


	if selectedBeginSong then
		setTextString('Song Start', '> Begin Song? <')
		setProperty('Song Start.alpha', 1)
		setTextString('AssistText', '(Select to begin the song!)')
		setProperty('AssistText.y', getProperty('Song Start.y') + 80)
	elseif not selectedBeginSong then
		setTextString('Song Start', 'Begin Song?')
		setProperty('Song Start.alpha', 0.5)
	end


	if selectedUnderlaySettings then
		setTextString('UnderLaySettingsHeader', '> UnderLay Settings <')
		setProperty('UnderLaySettingsHeader.alpha', 1)
		setTextString('AssistText', '(Select to edit the Underlay Settings!)')
		setProperty('AssistText.y', getProperty('UnderLaySettingsHeader.y') + 80)
	elseif not selectedUnderlaySettings then
		setTextString('UnderLaySettingsHeader', 'UnderLay Settings')
		setProperty('UnderLaySettingsHeader.alpha', 0.5)
	end

		if selectedUnderlayTypeSettings then
			setTextString('UnderLayTypeSetting', '> UnderLay Type: [ '..underlayTypeSettings..' ] <')
			setProperty('UnderLayTypeSetting.alpha', 1)
			setTextString('AssistText', '(Choose the UnderLay Type!)')
			setProperty('AssistText.y', getProperty('UnderLayTypeSetting.y') + 50)
		elseif not selectedUnderlayTypeSettings then
			setTextString('UnderLayTypeSetting', 'UnderLay Type: [ '..underlayTypeSettings..' ]')
			setProperty('UnderLayTypeSetting.alpha', 0.5)
		end

		realLaneOpacity = visualLaneOpacity / 100

			if underlayTypeSettings == 'None' then
				for Strums = 0,3 do
					removeLuaSprite('UnderLayOpponent'..Strums)
				end
				for Strums = 4,7 do
					removeLuaSprite('UnderLayPlayer'..Strums)
				end

			elseif underlayTypeSettings == 'Player Only' then
				for Strums = 4,7 do
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'HUD')
					setProperty('UnderLayPlayer'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 0,3 do
					removeLuaSprite('UnderLayOpponent'..Strums)
				end

			elseif underlayTypeSettings == 'Player and Opponent' then
				for Strums = 0,3 do
					simpleishGraphic('UnderLayOpponent'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'HUD')
					setProperty('UnderLayOpponent'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 4,7 do
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'HUD')
					setProperty('UnderLayPlayer'..Strums..'.alpha', realLaneOpacity)
				end
			end

		if selectedUnderlayOpacitySettings then
			setTextString('UnderLayOpacitySetting','> UnderLay Opacity: [ '..visualLaneOpacity..'% ] <')
			setProperty('UnderLayOpacitySetting.alpha', 1)
			setTextString('AssistText', "(Choose the UnderLay's opacity!)")
			setProperty('AssistText.y', getProperty('UnderLayOpacitySetting.y') + 50)
		elseif not selectedUnderlayOpacitySettings then
			setTextString('UnderLayOpacitySetting','UnderLay Opacity: [ '..visualLaneOpacity..'% ]')
			setProperty('UnderLayOpacitySetting.alpha', 0.5)
		end

		if allowCountdown then

			allowVerticalScroll = false
			allowHorizontalScroll = false
			doTweenAlpha('BG', 'BG', 0, 1)

			setProperty('Song Start.visible', false)
			setProperty('UnderLaySettingsHeader.visible', false)
			setProperty('UnderLayTypeSetting.visible', false)
			setProperty('UnderLayOpacitySetting.visible', false)
			setProperty('AssistText.visible', false)
			setProperty('NavigationText.visible', false)

		end

end