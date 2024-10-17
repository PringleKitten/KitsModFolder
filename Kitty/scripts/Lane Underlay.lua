--Made by RamenDominoes
--Hope you like it! <3


local force = false --should mobile support be on no matter what?

local captions = true

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


function luatxt(tag,txt,w,x,y,cam,ts,tc,sc,f) -- set certain values to '.' for default or no value
    makeLuaText(tag,txt,w,x,y)
    setObjectCamera(tag,cam)
    setTextSize(tag, ts)
    if tc == '.' then
        tc = 'FFFFFF'
    end
    setTextColor(tag, tc)
    if sc ~= '.' then
        screenCenter(tag, sc)
    end
    if f == '.' then
        f = false
    end
    addLuaText(tag,f)
end

function luasprite(tag,path,x,y,cam,xs,ys,sfx,sfy,sc,f) -- set certain values to '.' for default or no value
    makeLuaSprite(tag,path,x,y)
    setObjectCamera(tag,cam)
    scaleObject(tag, xs, ys)
    setScrollFactor(tag, sfx, sfy)
    if sc ~= '.' then
        screenCenter(tag, sc)
    end
    if f == '.' then
        f = false
    end
    addLuaSprite(tag,f)
end

function onCreate()

	simpleishGraphic('BG', 0, 0, screenWidth, screenHeight, '06000e', 'other')

	simpleishText('Song Start', 'Begin Song?', screenWidth, 0, 90, 60, 'center', 'other')

	simpleishText('UnderLaySettingsHeader', 'UnderLay Settings', screenWidth, 0, 225, 60, 'center', 'other')

	simpleishText('UnderLayTypeSetting', 'UnderLay Type: [ '..underlayTypeSettings..' ]', screenWidth, 0, 360, 40, 'center', 'other')
	simpleishText('UnderLayOpacitySetting', 'UnderLay Opacity: [ '..visualLaneOpacity..'% ]', screenWidth, 0, 450, 40, 'center', 'other')

	simpleishText('AssistText', '(PlaceHolderText)', screenWidth, 0, 680, 30, 'center', 'other')
	setProperty('AssistText.alpha', 0.9)

	simpleishText('NavigationText', 'CONTROLS: "SPACE" to select | "BACKSPACE" to deselect | Arrow Keys to navigate', screenWidth, 0, 680, 25, 'center', 'other')

    if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
        bugged = true
    else
        bugged = false
    end
    if bugged or force then
		luasprite('up','me/buttons/button',(screenWidth/1.085)-120,(screenHeight/1.1625)-210,'other',0.5,0.5,0,0,'.',true)
		luasprite('down','me/buttons/button',getProperty('up.x'),getProperty('up.y')+110,'other',0.5,0.5,0,0,'.',true)
		luasprite('left','me/buttons/button',getProperty('up.x')-110,getProperty('up.y')+50,'other',0.5,0.5,0,0,'.',true)
		luasprite('right','me/buttons/button',getProperty('up.x')+110,getProperty('up.y')+50,'other',0.5,0.5,0,0,'.',true)
		luasprite('back','me/buttons/button',getProperty('up.x')-100,getProperty('up.y')-300,'other',0.5,0.5,0,0,'.',true)
		luasprite('space','me/buttons/button',getProperty('up.x')+100,getProperty('up.y')-300,'other',0.5,0.5,0,0,'.',true)
		luasprite('cc','me/buttons/button',getProperty('up.x')-1000,getProperty('up.y')-150,'other',0.5,0.5,0,0,'.',true)

		luatxt('txtup','Up', 0,(screenWidth/1.075)-100,(screenHeight/1.105)-210,'other',screenWidth/39,'.','.',true)
		luatxt('txtdown','Down', 0,getProperty('txtup.x')-20,getProperty('txtup.y')+110,'other',screenWidth/39,'.','.',true)
		luatxt('txtleft','Left', 0,getProperty('txtup.x')-130,getProperty('txtup.y')+50,'other',screenWidth/39,'.','.',true)
		luatxt('txtright','Right', 0,getProperty('txtup.x')+85,getProperty('txtup.y')+50,'other',screenWidth/39,'.','.',true)
		luatxt('txtback','Back', 0,getProperty('txtup.x')-120,getProperty('txtup.y')-300,'other',screenWidth/39,'.','.',true)
		luatxt('txtspace','Space', 0,getProperty('txtup.x')+75,getProperty('txtup.y')-300,'other',screenWidth/39,'.','.',true)
		luatxt('txtcc','CC', 0,getProperty('txtup.x')-1003,getProperty('txtup.y')-150,'other',screenWidth/39,'.','.',true)
	end
	luatxt('ifso','(If applicable)', 0,((screenWidth/1.075)-100)-1040,((screenHeight/1.105)-210)-20,'other',screenWidth/80,'808080','.',true)
	luatxt('captiontxt','Captions: true', 0,((screenWidth/1.075)-100)-1080,((screenHeight/1.105)-210)-50,'other',screenWidth/39,'00FF00','.',true)
end

function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		return Function_Continue
	end
end

function mouseOverlaps(tag, camera)
    x = getMouseX(camera or 'camHUD')
    y = getMouseY(camera or 'camHUD')
    return (x > getProperty(tag..'.x') and y > getProperty(tag..'.y') and x < (getProperty(tag..'.x') + getProperty(tag..'.width')) and y < (getProperty(tag..'.y') + getProperty(tag..'.height')))
end

function buttonStuff()
	if getPropertyFromClass('ClientPrefs', 'mechanics') == 'mechanics' then
        bugged = true
    else
        bugged = false
    end
    if bugged or force then
    	if mouseOverlaps('space', 'camOther') and mouseClicked("left") then
    	    spc = true
    	end
    	if mouseOverlaps('up', 'camOther') and mouseClicked("left") then
    	    bbck = false
    	    brgh = false
    	    blft = false
    	    bdwn = false
    	    bup = true
    	elseif mouseOverlaps('down', 'camOther') and mouseClicked("left") then
    	    bbck = false
    	    brgh = false
    	    blft = false
    	    bdwn = true
    	    bup = false
    	elseif mouseOverlaps('left', 'camOther') and mouseClicked("left") then
    	    bbck = false
    	    brgh = false
    	    blft = true
    	    bdwn = false
    	    bup = false
    	elseif mouseOverlaps('right', 'camOther') and mouseClicked("left") then
    	    bbck = false
    	    brgh = true
    	    blft = false
    	    bdwn = false
    	    bup = false
    	elseif mouseOverlaps('back', 'camOther') and mouseClicked("left") then
    	    bbck = true
    	    brgh = false
    	    blft = false
    	    bdwn = false
    	    bup = false
    	end
	end
	if bugged or force then
		if ((mouseOverlaps('cc', 'camOther') and mouseClicked("left")) or keyPress('C')) and not captions then
			captions = true
			setTextColor("captiontxt", "00FF00")
			setTextString('captiontxt','Captions: true')
		elseif ((mouseOverlaps('cc', 'camOther') and mouseClicked("left")) or keyPress('C')) and captions then
			captions = false
			setTextColor("captiontxt", "FF0000")
			setTextString('captiontxt','Captions: false')
		end
	else
		if keyPress('C') and not captions then
			captions = true
			setTextColor("captiontxt", "00FF00")
			setTextString('captiontxt','Captions: true')
		elseif keyPress('C') and captions then
			captions = false
			setTextColor("captiontxt", "FF0000")
			setTextString('captiontxt','Captions: false')
		end
	end
end

function onUpdate()
	if not allowCountdown then
        buttonStuff()

	if (keyPress('SPACE') or spc) and selectedBeginSong then
		for _, value in pairs({'txtup','txtdown','txtleft','txtright','txtback','txtspace','txtcc','captiontxt','ifso'}) do
            removeLuaText(value)
        end
        for _, value in pairs({'up','down','left','right','back','space','cc'}) do
            removeLuaSprite(value)
        end
		callScript("scripts/makeCaption", "captionson",{captions})
		allowCountdown = true
		startCountdown()

	elseif (keyPress('SPACE') or spc) and allowVerticalScroll and selectedUnderlaySettings then
		selectedUnderlaySettings = false
		selectedUnderlayTypeSettings = true
		allowHorizontalScroll = true

	elseif (keyPress('BACKSPACE') or bbck) and not selectedBeginSong and allowVerticalScroll and selectedUnderlayTypeSettings then
		selectedUnderlaySettings = true
		selectedUnderlayTypeSettings = false
		allowHorizontalScroll = false
	elseif (keyPress('BACKSPACE') or bbck) and not selectedBeginSong and allowVerticalScroll and selectedUnderlayOpacitySettings then
		selectedUnderlaySettings = true
		selectedUnderlayOpacitySettings = false
		allowHorizontalScroll = false
	end


	if (keyPress('UP') or bup) and allowVerticalScroll and selectedBeginSong then
		selectedBeginSong = false
		selectedUnderlaySettings = true
	elseif (keyPress('UP') or bup) and allowVerticalScroll and selectedUnderlaySettings then
		selectedBeginSong = true
		selectedUnderlaySettings = false

		elseif (keyPress('UP') or bup) and allowVerticalScroll and selectedUnderlayTypeSettings then
			selectedUnderlayTypeSettings = false
			selectedUnderlayOpacitySettings = true
		elseif (keyPress('UP') or bup) and allowVerticalScroll and selectedUnderlayOpacitySettings then
			selectedUnderlayTypeSettings = true
			selectedUnderlayOpacitySettings = false

	elseif (keyPress('DOWN') or bdwn) and allowVerticalScroll and selectedBeginSong then
		selectedBeginSong = false
		selectedUnderlaySettings = true
	elseif (keyPress('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlaySettings then
		selectedBeginSong = true
		selectedUnderlaySettings = false

		elseif (keyPress('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlayTypeSettings then
			selectedUnderlayTypeSettings = false
			selectedUnderlayOpacitySettings = true
		elseif (keyPress('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlayOpacitySettings then
			selectedUnderlayTypeSettings = true
			selectedUnderlayOpacitySettings = false


	elseif (keyPress('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
		underlayTypeSettings = 'Player and Opponent'
	elseif (keyPress('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
		underlayTypeSettings = 'Player Only'
	elseif (keyPress('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
		underlayTypeSettings = 'None'

		elseif (keyPress('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayOpacitySettings then
			visualLaneOpacity = (visualLaneOpacity - (0.1 * 100))
			if visualLaneOpacity < (0.1 * 100) then
				visualLaneOpacity = 0
			end
		elseif (keyPress('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayOpacitySettings then
			visualLaneOpacity = (visualLaneOpacity + (0.1 * 100))
			if visualLaneOpacity > (0.9 * 100) then
				visualLaneOpacity = 100
			end

	elseif (keyPress('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
		underlayTypeSettings = 'Player Only'
	elseif (keyPress('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
		underlayTypeSettings = 'Player and Opponent'
	elseif (keyPress('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
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
		bup = false
		bdwn = false
		brgh = false
		blft = false
		spc = false
		bbck = false
	end
end