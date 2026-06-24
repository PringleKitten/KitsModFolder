function noChoice()
	close()
end
--Made by RamenDominoes edited by PringleKitten
allowCountdown = false
allowVerticalScroll = true
allowHorizontalScroll = false
visualLaneOpacity = 1 * 100

local positionn = 0
local forceMobile = false

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
function keyPressM(key)
	return getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key)
end

--------------------------------------------------------------------------------------
---------------------------------Added by PringleKitten-------------------------------
--------------------------------------------------------------------------------------

local cam = 'other'
local ui = 0
function onCreatePost()
	setProperty('healthBar.alpha', 0);
	setProperty('healthBarBG.alpha', 0);
	setProperty('iconP1.alpha', 0);
	setProperty('iconP2.alpha', 0);
	setProperty('scoreTxt.alpha', 0);
	run1 = true
	if not forceMobile then
    	forceMobile = getPropertyFromClass("backend.ClientPrefs", "data.mobileMechanics")
	end

	if run1 then
		run1 = false

	simpleishGraphic('BG', 0, 0, screenWidth, screenHeight, '06000e', 'two')

	simpleishText('Song Start', 'Begin Song?', screenWidth, 0, 90, 60, 'center', 'two')

	simpleishText('UnderLaySettingsHeader', 'UnderLay Settings', screenWidth, 0, 225, 60, 'center', 'two')

	simpleishText('UnderLayTypeSetting', 'UnderLay Type: [ '..underlayTypeSettings..' ]', screenWidth, 0, 360, 40, 'center', 'two')
	simpleishText('UnderLayOpacitySetting', 'UnderLay Opacity: [ '..visualLaneOpacity..'% ]', screenWidth, 0, 450, 40, 'center', 'two')

	simpleishText('AssistText', '(PlaceHolderText)', screenWidth, 0, 680, 30, 'center', 'two')
	setProperty('AssistText.alpha', 0.9)

	simpleishText('NavigationText', 'CONTROLS: "SHIFT" = select | "BACKSPACE" = back | Nav = Up/Down | Left/Right = Rating Placement | Other: U,O', screenWidth, 0, 680, 25, 'center', 'two')
	setTextSize("NavigationText", 19)
    if forceMobile then
		luasprite('up','me/buttons/button',(screenWidth/2),(screenHeight/1.1625)-90,'two',0.5,0.5,0,0,'.',true)
		luasprite('down','me/buttons/button',getProperty('up.x')-110,getProperty('up.y'),'two',0.5,0.5,0,0,'.',true)
		luasprite('left','me/buttons/button',getProperty('up.x')-220,getProperty('up.y'),'two',0.5,0.5,0,0,'.',true)
		luasprite('right','me/buttons/button',getProperty('up.x')+110,getProperty('up.y'),'two',0.5,0.5,0,0,'.',true)
		luasprite('back','me/buttons/button',1125,560,'two',0.5,0.5,0,0,'.',true)
		luasprite('space','me/buttons/button',50,75,'two',0.5,0.5,0,0,'.',true)
		luasprite('uiBn','me/buttons/button',950,450,'two',0.5,0.5,0,0,'.',true)
		luasprite('camBn','me/buttons/button',950,560,'two',0.5,0.5,0,0,'.',true)

		luatxt('txtup','Up', 0,getProperty('up.x')+30,getProperty('up.y')+35,'two',screenWidth/39,'.','.',true)
		luatxt('txtdown','Down', 0,getProperty('down.x')+10,getProperty('down.y')+35,'two',screenWidth/39,'.','.',true)
		luatxt('txtleft','Left', 0,getProperty('left.x')+10,getProperty('left.y')+35,'two',screenWidth/39,'.','.',true)
		luatxt('txtright','Right', 0,getProperty('right.x')+3,getProperty('right.y')+35,'two',screenWidth/39,'.','.',true)
		luatxt('txtback','Back', 0,getProperty('back.x')+10,getProperty('back.y')+30,'two',screenWidth/39,'.','.',true)
		luatxt('txtspace','Shift', 0,getProperty('space.x')+2,getProperty('space.y')+30,'two',screenWidth/39,'.','.',true)
		luatxt('txtuiBn','Ui?', 0,getProperty('uiBn.x')+22,getProperty('uiBn.y')+33,'two',screenWidth/39,'.','.',true)

		luatxt('uiStatement','UI: '..'Psych', 0,getProperty('txtuiBn.x')+80,getProperty('txtuiBn.y'),'two',screenWidth/80,'00FFFF','.',true)
	else
		luatxt('uiStatement','UI: Psych', 0,1052,483,'two',screenWidth/80,'00FFFF','.',true)
	end
	luatxt('txtcamBn','Other', 0,952,593,'two',screenWidth/39,'.','.',true)
	setTextSize("uiStatement", 18)
end
	callScript("scripts/ratings", "ratingPosFunc")
	callScript("scripts/ratings", "rtsSetup",{cam,ui})
end

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
function onSongStart()
	close()
end

--------------------------------------------------------------------------------------
---------------------------------End of Script Set Up---------------------------------
--------------------------------------------------------------------------------------

function onStartCountdown()
	if not allowCountdown then
		return Function_Stop
	elseif allowCountdown then
		setProperty('healthBar.alpha', 1);
		setProperty('healthBarBG.alpha', 1);
		setProperty('iconP1.alpha', 1);
		setProperty('iconP2.alpha', 1);
		setProperty('scoreTxt.alpha', 1);
		return Function_Continue
	end
end

function mouseOverlaps(tag, camera)
    x = getMouseX(camera or 'camHUD')
    y = getMouseY(camera or 'camHUD')
    return (x > getProperty(tag..'.x') and y > getProperty(tag..'.y') and x < (getProperty(tag..'.x') + getProperty(tag..'.width')) and y < (getProperty(tag..'.y') + getProperty(tag..'.height')))
end

function buttonStuff()
    if forceMobile then
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
	if forceMobile then
		if ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPressM('U')) and ui == 0 then
			ui = 1
			setTextString('uiStatement','UI: IFE')
		elseif ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPressM('U')) and ui == 1 then
			ui = 2
			setTextString('uiStatement','UI: Psych+IFE')
		elseif ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPressM('U')) and ui == 2 then
			ui = 3
			setTextString('uiStatement','UI: Psych+IFE V2')
		elseif ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPressM('U')) and ui == 3 then
			ui = 0
			setTextString('uiStatement','UI: Psych')
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'two' then
			cam = 'game'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'game' then
			cam = 'hud'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'hud' then
			cam = 'other'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'other' then
			cam = 'one'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'one' then
			cam = 'two'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPressM('O')) and cam == 'two' then
			cam = 'three'
			setTextString("txtcamBn", cam)
		end
		if (mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or (mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) then
			callScript("scripts/ratings", "rtsSetup",{cam,ui})
		end
	else
		if keyPressM('U') and ui == 0 then
			ui = 1
			setTextString('uiStatement','UI: IFE')
		elseif keyPressM('U') and ui == 1 then
			ui = 2
			setTextString('uiStatement','UI: Psych+IFE')
		elseif keyPressM('U') and ui == 2 then
			ui = 3
			setTextString('uiStatement','UI: Psych+IFE V2')
		elseif keyPressM('U') and ui == 3 then
			ui = 0
			setTextString('uiStatement','UI: Psych')
		end
		if keyPressM('O') and cam == 'three' then
			cam = 'game'
			setTextString("txtcamBn", cam)
		elseif keyPressM('O') and cam == 'game' then
			cam = 'hud'
			setTextString("txtcamBn", cam)
		elseif keyPressM('O') and cam == 'hud' then
			cam = 'other'
			setTextString("txtcamBn", cam)
		elseif keyPressM('O') and cam == 'other' then
			cam = 'one'
			setTextString("txtcamBn", cam)
		elseif keyPressM('O') and cam == 'one' then
			cam = 'two'
			setTextString("txtcamBn", cam)
		elseif keyPressM('O') and cam == 'two' then
			cam = 'three'
			setTextString("txtcamBn", cam)
		end
	end
	if keyPressM('U') or keyPressM('O') then
		callScript("scripts/ratings", "rtsSetup",{cam,ui})
	end
end

function onUpdate()
	if getProperty('inCutscene') and not doneIt2 then
        doneIt2 = true
    end
    if not getProperty('inCutscene') and doneIt2 then
        doneIt2 = false
    end
	if not (getProperty('inCutscene') or (getProperty('videoCutscene') or getProperty('videoCutscene.isPlaying'))) then
		if not allowCountdown then
    	    buttonStuff()
			if selectedBeginSong or selectedUnderlaySettings then
				if keyPressM('LEFT') or blft then
					callScript("scripts/ratings", "ratingPosFunc",{0})
					blft = false
					brgh = false
				elseif keyPressM('RIGHT') or brgh then
					callScript("scripts/ratings", "ratingPosFunc",{1})
					brgh = false
					blft = false
				end
			end
			if (keyPressM('SHIFT') or spc) and selectedBeginSong then
				for _, value in pairs({'uiStatement','txtuiBn','txtcamBn','txtup','txtdown','txtleft','txtright','txtback','txtspace','ifso','keyy'}) do
    		        removeLuaText(value)
    		    end
    		    for _, value in pairs({'uiBn','camBn','up','down','left','right','back','space'}) do
    		        removeLuaSprite(value)
    		    end
				callScript("scripts/ratings", "rtsSetup",{cam,ui})
				allowCountdown = true
				startCountdown()

			elseif (keyPressM('SHIFT') or spc) and allowVerticalScroll and selectedUnderlaySettings then
				selectedUnderlaySettings = false
				selectedUnderlayTypeSettings = true
				allowHorizontalScroll = true

			elseif (keyPressM('BACKSPACE') or bbck) and not selectedBeginSong and allowVerticalScroll and selectedUnderlayTypeSettings then
				selectedUnderlaySettings = true
				selectedUnderlayTypeSettings = false
				allowHorizontalScroll = false
			elseif (keyPressM('BACKSPACE') or bbck) and not selectedBeginSong and allowVerticalScroll and selectedUnderlayOpacitySettings then
				selectedUnderlaySettings = true
				selectedUnderlayOpacitySettings = false
				allowHorizontalScroll = false
			end


			if (keyPressM('UP') or bup) and allowVerticalScroll and selectedBeginSong then
				selectedBeginSong = false
				selectedUnderlaySettings = true
			elseif (keyPressM('UP') or bup) and allowVerticalScroll and selectedUnderlaySettings then
				selectedBeginSong = true
				selectedUnderlaySettings = false

				elseif (keyPressM('UP') or bup) and allowVerticalScroll and selectedUnderlayTypeSettings then
					selectedUnderlayTypeSettings = false
					selectedUnderlayOpacitySettings = true
				elseif (keyPressM('UP') or bup) and allowVerticalScroll and selectedUnderlayOpacitySettings then
					selectedUnderlayTypeSettings = true
					selectedUnderlayOpacitySettings = false

			elseif (keyPressM('DOWN') or bdwn) and allowVerticalScroll and selectedBeginSong then
				selectedBeginSong = false
				selectedUnderlaySettings = true
			elseif (keyPressM('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlaySettings then
				selectedBeginSong = true
				selectedUnderlaySettings = false
			elseif (keyPressM('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlayTypeSettings then
				selectedUnderlayTypeSettings = false
				selectedUnderlayOpacitySettings = true
			elseif (keyPressM('DOWN') or bdwn) and allowVerticalScroll and selectedUnderlayOpacitySettings then
				selectedUnderlayTypeSettings = true
				selectedUnderlayOpacitySettings = false
			elseif (keyPressM('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
				underlayTypeSettings = 'Player and Opponent'
			elseif (keyPressM('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
				underlayTypeSettings = 'Player Only'
			elseif (keyPressM('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
			underlayTypeSettings = 'None'
			elseif (keyPressM('LEFT') or blft) and allowHorizontalScroll and selectedUnderlayOpacitySettings then
				visualLaneOpacity = (visualLaneOpacity - (0.1 * 100))
				if visualLaneOpacity < (0.1 * 100) then
					visualLaneOpacity = 0
				end
			elseif (keyPressM('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayOpacitySettings then
				visualLaneOpacity = (visualLaneOpacity + (0.1 * 100))
				if visualLaneOpacity > (0.9 * 100) then
					visualLaneOpacity = 100
				end
			elseif (keyPressM('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'None' then
				underlayTypeSettings = 'Player Only'
			elseif (keyPressM('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player Only' then
				underlayTypeSettings = 'Player and Opponent'
			elseif (keyPressM('RIGHT') or brgh) and allowHorizontalScroll and selectedUnderlayTypeSettings and underlayTypeSettings == 'Player and Opponent' then
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
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'two')
					setProperty('UnderLayPlayer'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 0,3 do
					removeLuaSprite('UnderLayOpponent'..Strums)
				end
			elseif underlayTypeSettings == 'Player and Opponent' then
				for Strums = 0,3 do
					simpleishGraphic('UnderLayOpponent'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'two')
					setProperty('UnderLayOpponent'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 4,7 do
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'two')
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
end