--Made by RamenDominoes
--Hope you like it! <3

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
function keyPress(key)
	return getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key)
end

--------------------------------------------------------------------------------------
---------------------------------Added by PringleKitten-------------------------------
--------------------------------------------------------------------------------------
function onCreatePost()
	setProperty('healthBar.alpha', 0);
	setProperty('healthBarBG.alpha', 0);
	setProperty('iconP1.alpha', 0);
	setProperty('iconP2.alpha', 0);
	setProperty('scoreTxt.alpha', 0);
	makeLuaText('testCaption', 'Captions will be here unless song forces middlescroll', 600, 0,500)
	addLuaText('testCaption')
	setTextSize('testCaption', 35)
	setTextAlignment('testCaption', 'center')
	setObjectCamera('testCaption', 'other')
	run1 = true
	if not forceMobile then
    	forceMobile = getPropertyFromClass("backend.ClientPrefs", "data.mobileMechanics")
	end

	if run1 then
		run1 = false
	callScript("custom_events/DodgeForBF", "cdal", {allowCountdown})

	simpleishGraphic('BG', 0, 0, screenWidth, screenHeight, '06000e', 'hud')

	simpleishText('Song Start', 'Begin Song?', screenWidth, 0, 90, 60, 'center', 'hud')

	simpleishText('UnderLaySettingsHeader', 'UnderLay Settings', screenWidth, 0, 225, 60, 'center', 'hud')

	simpleishText('UnderLayTypeSetting', 'UnderLay Type: [ '..underlayTypeSettings..' ]', screenWidth, 0, 360, 40, 'center', 'hud')
	simpleishText('UnderLayOpacitySetting', 'UnderLay Opacity: [ '..visualLaneOpacity..'% ]', screenWidth, 0, 450, 40, 'center', 'hud')

	simpleishText('AssistText', '(PlaceHolderText)', screenWidth, 0, 680, 30, 'center', 'hud')
	setProperty('AssistText.alpha', 0.9)

	simpleishText('NavigationText', 'CONTROLS: "SHIFT" = select | "BACKSPACE" = back | Nav = Up/Down | Left/Right = Rating Placement | Other: U,O', screenWidth, 0, 680, 25, 'center', 'hud')
	setTextSize("NavigationText", 19)
    if forceMobile then
		luasprite('up','me/buttons/button',(screenWidth/2),(screenHeight/1.1625)-90,'hud',0.5,0.5,0,0,'.',true)
		luasprite('down','me/buttons/button',getProperty('up.x')-110,getProperty('up.y'),'hud',0.5,0.5,0,0,'.',true)
		luasprite('left','me/buttons/button',getProperty('up.x')-220,getProperty('up.y'),'hud',0.5,0.5,0,0,'.',true)
		luasprite('right','me/buttons/button',getProperty('up.x')+110,getProperty('up.y'),'hud',0.5,0.5,0,0,'.',true)
		luasprite('back','me/buttons/button',1125,560,'hud',0.5,0.5,0,0,'.',true)
		luasprite('space','me/buttons/button',50,75,'hud',0.5,0.5,0,0,'.',true)
		luasprite('cc','me/buttons/button',1000,50,'hud',0.5,0.5,0,0,'.',true)
		luasprite('invert','me/buttons/button',30,525,'hud',0.5,0.5,0,0,'.',true)
		luasprite('uiBn','me/buttons/button',950,450,'hud',0.5,0.5,0,0,'.',true)
		luasprite('camBn','me/buttons/button',950,560,'hud',0.5,0.5,0,0,'.',true)

		luatxt('txtup','Up', 0,getProperty('up.x')+30,getProperty('up.y')+35,'hud',screenWidth/39,'.','.',true)
		luatxt('txtdown','Down', 0,getProperty('down.x')+10,getProperty('down.y')+35,'hud',screenWidth/39,'.','.',true)
		luatxt('txtleft','Left', 0,getProperty('left.x')+10,getProperty('left.y')+35,'hud',screenWidth/39,'.','.',true)
		luatxt('txtright','Right', 0,getProperty('right.x')+3,getProperty('right.y')+35,'hud',screenWidth/39,'.','.',true)
		luatxt('txtback','Back', 0,getProperty('back.x')+10,getProperty('back.y')+30,'hud',screenWidth/39,'.','.',true)
		luatxt('txtspace','Shift', 0,getProperty('space.x')+2,getProperty('space.y')+30,'hud',screenWidth/39,'.','.',true)
		luatxt('txtcc','CC', 0,getProperty('cc.x')+29,getProperty('cc.y')+33,'hud',screenWidth/39,'.','.',true)
		luatxt('txtinv','I', 0,getProperty('invert.x')+37,getProperty('invert.y')+30,'hud',screenWidth/39,'.','.',true)
		luatxt('txtuiBn','Ui?', 0,getProperty('uiBn.x')+22,getProperty('uiBn.y')+33,'hud',screenWidth/39,'.','.',true)

		luatxt('captiontxt','Captions: true', 0,getProperty('cc.x')-50,getProperty('cc.y')+100,'hud',screenWidth/39,'00FF00','.',true)
		luatxt('ifso','(If applicable)', 0,getProperty('captiontxt.x')+40,getProperty('captiontxt.y')+30,'hud',screenWidth/80,'808080','.',true)
		luatxt('keyy','PRESS C TO CHANGE',0,getProperty('ifso.x')-5,getProperty('ifso.y')+20,'hud',screenWidth/80,'00FFFF','.',true)
		luatxt('invertxt','Caption Placement: Opponent', 0,getProperty('invert.x')-20,getProperty('invert.y')+100,'hud',screenWidth/39,'00FF00','.',true)
		luatxt('keyyInv','PRESS I TO CHANGE', 0,getProperty('invert.x')-20,getProperty('invert.y')+130,'hud',screenWidth/80,'00FFFF','.',true)
		luatxt('uiStatement','Show Psych UI: '..'true', 0,getProperty('txtuiBn.x')+80,getProperty('txtuiBn.y'),'hud',screenWidth/80,'00FFFF','.',true)
	else
		luatxt('captiontxt','Captions: true', 0,950,150,'hud',screenWidth/39,'00FF00','.',true)
		luatxt('ifso','(If applicable)', 0,990,180,'hud',screenWidth/80,'808080','.',true)
		luatxt('keyy','PRESS C TO CHANGE',0,985,200,'hud',screenWidth/80,'00FFFF','.',true)
		luatxt('invertxt','Caption Placement: Opponent', 0,10,625,'hud',screenWidth/39,'00FF00','.',true)
		luatxt('keyyInv','PRESS I TO CHANGE', 0,10,655,'hud',screenWidth/80,'00FFFF','.',true)
		luatxt('uiStatement','Show Psych UI: true', 0,1052,483,'hud',screenWidth/80,'00FFFF','.',true)
		-- yes I know I don't need this again but it's easier cuz I got it synced together above the else so.
	end
	luatxt('txtcamBn','Other', 0,952,593,'hud',screenWidth/39,'.','.',true)
	setTextSize("uiStatement", 18)
	runTimer('disprCap',2)
end
	callScript("scripts/ratings", "ratingPosFunc")
end

local inv = false
local captions = true

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

--------------------------------------------------------------------------------------
---------------------------------End of Script Set Up---------------------------------
--------------------------------------------------------------------------------------
local cam = 'other'
local ui = true
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

function onTimerCompleted(tag)
	if tag == 'disprCap' then
		setProperty("testCaption.alpha", 0)
	end
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
		if ((mouseOverlaps('cc', 'camOther') and mouseClicked("left")) or keyPress('C')) and not captions then
			captions = true
			doTweenAlpha("intxta", "invertxt", 1, 0.2, "linear")
			doTweenAlpha("keyyInva", "keyyInv", 1, 0.2, "linear")
			doTweenAlpha("intxtabtn", "txtinv", 1, 0.2, "linear")
			doTweenAlpha("keyyInvabtn", "invert", 1, 0.2, "linear")
			setTextColor("captiontxt", "00FF00")
			setTextString('captiontxt','Captions: true')
			makeLuaText('testCaption', 'Captions will be here unless song forces middlescroll', 600, 0,500)
			addLuaText('testCaption')
			setTextSize('testCaption', 35)
			setTextAlignment('testCaption', 'center')
			setProperty('testCaption.x', (screenWidth/2)-(getProperty('testCaption.width')/2))
			setObjectCamera('testCaption', 'other')
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif ((mouseOverlaps('cc', 'camOther') and mouseClicked("left")) or keyPress('C')) and captions then
			captions = false
			doTweenAlpha("intxta", "invertxt", 0, 0.2, "linear")
			doTweenAlpha("keyyInva", "keyyInv", 0, 0.2, "linear")
			doTweenAlpha("intxtabtn", "txtinv", 0, 0.2, "linear")
			doTweenAlpha("keyyInvabtn", "invert", 0, 0.2, "linear")
			setTextColor("captiontxt", "FF0000")
			setTextString('captiontxt','Captions: false')
			removeLuaText("testCaption")
		elseif ((mouseOverlaps('invert', 'camOther') and mouseClicked("left")) or keyPress('I')) and inv == 'center' then
			inv = true
			callScript("scripts/makeCaption", "invt", {true})
			setTextString('invertxt','Caption Placement: Player')
			setProperty("testCaption.x", 630)
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif ((mouseOverlaps('invert', 'camOther') and mouseClicked("left")) or keyPress('I')) and inv then
			inv = false
			callScript("scripts/makeCaption", "invt", {false})
			setTextString('invertxt','Caption Placement: Opponent')
			setProperty("testCaption.x", 0)
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif ((mouseOverlaps('invert', 'camOther') and mouseClicked("left")) or keyPress('I')) and not inv then
			inv = 'center'
			callScript("scripts/makeCaption", "middcs", {true})
			setTextString('invertxt','Caption Placement: Center')
			screenCenter("testCaption", 'x')
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPress('U')) and ui then
			ui = false
			setTextString('uiStatement','Show Psych UI: false')
		elseif ((mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or keyPress('U')) and not ui then
			ui = true
			setTextString('uiStatement','Show Psych UI: true')
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPress('O')) and cam == 'other' then
			cam = 'game'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPress('O')) and cam == 'game' then
			cam = 'hud'
			setTextString("txtcamBn", cam)
		elseif ((mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) or keyPress('O')) and cam == 'hud' then
			cam = 'other'
			setTextString("txtcamBn", cam)
		end
		if (mouseOverlaps('uiBn', 'camOther') and mouseClicked("left")) or (mouseOverlaps('camBn', 'camOther') and mouseClicked("left")) then
			callScript("scripts/ratings", "rtsSetup",{cam,ui})
		end
	else
		if keyPress('C') and not captions then
			captions = true
			doTweenAlpha("intxta", "invertxt", 1, 0.2, "linear")
			doTweenAlpha("keyyInva", "keyyInv", 1, 0.2, "linear")
			setTextColor("captiontxt", "00FF00")
			setTextString('captiontxt','Captions: true')
			makeLuaText('testCaption', 'Captions will be here unless song forces middlescroll', 600, 0,500)
			addLuaText('testCaption')
			setTextSize('testCaption', 35)
			setTextAlignment('testCaption', 'center')
			setProperty('testCaption.x', (screenWidth/2)-(getProperty('testCaption.width')/2))
			setObjectCamera('testCaption', 'other')
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif keyPress('C') and captions then
			captions = false
			doTweenAlpha("intxta", "invertxt", 0, 0.2, "linear")
			doTweenAlpha("keyyInva", "keyyInv", 0, 0.2, "linear")
			setTextColor("captiontxt", "FF0000")
			setTextString('captiontxt','Captions: false')
			removeLuaText("testCaption")
		end
		if keyPress('I') and inv == 'center' then
			inv = true
			callScript("scripts/makeCaption", "invt", {true})
			callScript("scripts/makeCaption", "middcs", {false})
			setTextString('invertxt','Caption Placement: Player')
			setProperty("testCaption.x", 630)
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif keyPress('I') and inv then
			inv = false
			callScript("scripts/makeCaption", "middcs", {false})
			setTextString('invertxt','Caption Placement: Opponent')
			setProperty("testCaption.x", 0)
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		elseif keyPress('I') and not inv then
			inv = 'center'
			callScript("scripts/makeCaption", "middcs", {true})
			setTextString('invertxt','Caption Placement: Center')
			screenCenter("testCaption", 'x')
			setProperty("testCaption.alpha", 1)
			runTimer('disprCap',2)
		end
		if keyPress('U') and ui then
			ui = false
			setTextString('uiStatement','Show Psych UI: false')
		elseif keyPress('U') and not ui then
			ui = true
			setTextString('uiStatement','Show Psych UI: true')
		end
		if keyPress('O') and cam == 'other' then
			cam = 'game'
			setTextString("txtcamBn", cam)
		elseif keyPress('O') and cam == 'game' then
			cam = 'hud'
			setTextString("txtcamBn", cam)
		elseif keyPress('O') and cam == 'hud' then
			cam = 'other'
			setTextString("txtcamBn", cam)
		end
	end
	if keyPress('U') or keyPress('O') then
		callScript("scripts/ratings", "rtsSetup",{cam,ui})
	end
end

function onUpdate()
	if not (getProperty('inCutscene') or (getProperty('videoCutscene') or getProperty('videoCutscene.isPlaying'))) then
	if not allowCountdown then
        buttonStuff()

	if selectedBeginSong or selectedUnderlaySettings then
		if keyPress('LEFT') or blft then
			callScript("scripts/ratings", "ratingPosFunc",{0})
			blft = false
			brgh = false
		elseif keyPress('RIGHT') or brgh then
			callScript("scripts/ratings", "ratingPosFunc",{1})
			brgh = false
			blft = false
		end
	end

	if (keyPress('SHIFT') or spc) and selectedBeginSong then
		for _, value in pairs({'uiStatement','txtuiBn','txtcamBn','txtup','testCaption','txtdown','txtleft','txtright','txtback','txtspace','txtcc','captiontxt','ifso','keyy','keyyInv','invertxt','txtinv'}) do
            removeLuaText(value)
        end
        for _, value in pairs({'uiBn','camBn','up','down','left','right','back','space','cc','invert'}) do
            removeLuaSprite(value)
        end

		if inv == 'center' then
			callScript("scripts/makeCaption", "middcs", {true})
			callScript("scripts/makeCaptionbystep", "middcs", {true})
			callScript("scripts/makeCaption", "invt", {false})
			callScript("scripts/makeCaptionbystep", "invt", {false})
		else
			callScript("scripts/makeCaption", "middcs", {false})
			callScript("scripts/makeCaptionbystep", "middcs", {false})
			callScript("scripts/makeCaption", "invt", {inv})
			callScript("scripts/makeCaptionbystep", "invt", {inv})
		end
		callScript("scripts/makeCaption", "captionson",{captions})
		callScript("scripts/makeCaptionbystep", "captionson",{captions})
		callScript("scripts/script", "capps",{captions})
		callScript("scripts/ratings", "rtsSetup",{cam,ui})
		allowCountdown = true
		startCountdown()

	elseif (keyPress('SHIFT') or spc) and allowVerticalScroll and selectedUnderlaySettings then
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
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'hud')
					setProperty('UnderLayPlayer'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 0,3 do
					removeLuaSprite('UnderLayOpponent'..Strums)
				end

			elseif underlayTypeSettings == 'Player and Opponent' then
				for Strums = 0,3 do
					simpleishGraphic('UnderLayOpponent'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'hud')
					setProperty('UnderLayOpponent'..Strums..'.alpha', realLaneOpacity)
				end
				for Strums = 4,7 do
					simpleishGraphic('UnderLayPlayer'..Strums, getPropertyFromGroup('strumLineNotes', Strums, 'x'), 0, 112, screenHeight, '000000', 'hud')
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

function onSongStart()
	callScript("custom_events/DodgeForBF", "cdal", {allowCountdown})
	callScript("custom_events/DodgeEvent", "cdal", {allowCountdown})
end