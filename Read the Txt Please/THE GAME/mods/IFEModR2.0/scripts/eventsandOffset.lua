offset = 75 -- Game Offset
local c = false -- Use Custom Offset Script
local customFPS = true -- Use my Custom FPS Text
local newOff = 0
local target = 60
local zv1,zv2 = 0,0
local go = false
local doIt = false
local st = false
local noDoBop = false
local ltxT = 'fpsDrawer'
function onCreate()
	if not c then
        offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')
    elseif c then
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset)
    end
    for _, curS in pairs({'song1','song2'}) do
        if songName == curS then
            newOff = 0 --Number is YOUR Song Offset
        end
    end
    if newOff ~= 0 then
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset+newOff)
    end
	makeLuaText('st', 'l', '800', 400,450)
    addLuaText('st')
    setTextSize('st', 50)
    setTextAlignment('st', 'center')
    setProperty('st.x', (screenWidth/2)-(getProperty('st.width')/2))
    setObjectCamera('st', 'other')
    setProperty('st.alpha', 0)
end
function onCreatePost()
    setProperty('skipArrowStartTween', true)
    setPropertyFromClass('flixel.FlxG', 'fixedTimestep', false)
    -- This stuff I wanna change if I ever move notes around
    invt(ls)
    middcs(mdsc)
    if customFPS then
        target = getPropertyFromClass('backend.ClientPrefs', 'data.framerate')
        setPropertyFromClass("Main", "fpsVar.visible", false)
        makeLuaText(ltxT,'',0,0,0)
        setObjectCamera(ltxT,'other')
        setTextSize(ltxT, 20)
        setTextColor(ltxT, '00ff00')
        setTextAlignment(ltxT, 'left')
        addLuaText(ltxT,false)
    end
end
function onUpdate()
    if not dontLookForPos then
        og1 = getProperty('iconP1.y')
        og2 = getProperty('iconP2.y')
    end
	if st then
		doTweenAlpha('st', 'st', 1, 0.2, 'linear')
	else
		doTweenAlpha('st', 'st', 0, 0.2, 'linear')
	end
end
function onUpdatePost()
    if customFPS then
        if go then
            local fpsText = getPropertyFromClass("Main", "fpsVar.text")
            local fpsOnly = string.match(fpsText, "FPS:%s*(%d+)")
            local fpsInt = tonumber(fpsOnly)
            cur = fpsInt
            if fpsInt == target then
                setTextColor(ltxT, 'ffffff')
            elseif fpsInt > (target - target/4) and fpsInt ~= target then
                setTextColor(ltxT, '00ff00')
            elseif fpsInt > (target - target/2) then
                setTextColor(ltxT, 'ff9000')
            elseif fpsInt < (target - target/2) then
                setTextColor(ltxT, 'ff0000')
            end
            setTextString("fpsDrawer", fpsInt)
        end
    end
end
function onSongStart()
    og1 = getProperty('iconP1.y')
    og2 = getProperty('iconP2.y')
    go = true
    debugPrint('')
    debugPrint('Song Added Offset: '..'('..newOff..')')
    debugPrint('User Offset: '..'('..offset-newOff..')')
    debugPrint('')
    debugPrint('')
    debugPrint('')
end
function onEvent(n,v1,v2)
    if ccaptions then
        cv2 = tonumber(v2)
		if n == 'makeCaption' and cv2 ~= 0 then
			runTimer('captionLength', cv2, 0)
			setTextString('captionText', v1)
			--if songName == '' then
			if v2 >= 0.05 then
				doTweenAlpha('captionAlpha', 'captionText', 1, 0.1, 'linear')
			else
				setProperty('captionText.alpha', 1)
			end
			--end
		elseif n == 'makeCaption' and cv2 == 0 then
			debugPrint('Hey bro, dont put 0 in value 2 please, game says no no no!')
		end
	end
    if n == 'nz' then
        av1 = tonumber(v1)
        av2 = tonumber(v2)
        if av1 == 1 then
            setProperty('camZoomsHud', false)
        elseif av1 == 2 then
            setProperty('camZoomsHud', true)
        end
        if av2 == 1 then
            setProperty('camZoomsBg', false)
        elseif av2 == 2 then
            setProperty('camZoomsBg', true)
        end
    end
    if n == 'makeText' then
		runTimer('stt', v2, 0)
		setTextString('st', v1)
		st = true
	end
    if n == 'beatZoom' then
        zv1 = tonumber(v1)
        zv2 = tonumber(v2)
        if doIt then
            doIt = false
        else
            doIt = true
        end
    end
    if n == 'Add Camera Zoom Edit' then
      bv1 = tonumber(v1) or 0
      bv2 = tonumber(v2) or 0
      setProperty('camGame.zoom',getProperty("camGame.zoom")+bv2)
      setProperty('camHUD.zoom',getProperty("camHUD.zoom")+bv1)
   end
end
function onBeatHit()
    if not noDoBop then
        scaleObject('iconP1', 1.2, 1.2)
        scaleObject('iconP2', 1.2, 1.2)
        setProperty('iconP1.y', getProperty('iconP1.y')+15)
        setProperty('iconP2.y', getProperty('iconP2.y')+15)
        startTween('i1bopx', 'iconP1.scale', {x = 1, y = 1}, 0.2, {ease = 'sineOut'})
        startTween('i2bopx', 'iconP2.scale', {x = 1, y = 1}, 0.2, {ease = 'sineOut'})
        startTween('i1bopy', 'iconP1.scale', {x = 1, y = 1}, 0.2, {ease = 'sineOut'})
        startTween('i2bopy', 'iconP2.scale', {x = 1, y = 1}, 0.2, {ease = 'sineOut'})
        doTweenY('ip1y', 'iconP1', og1, 0.2, 'sineOut')
        doTweenY('ip2y', 'iconP2', og2, 0.2, 'sineOut')
        dontLookForPos = true
    end
    if doIt then
        setProperty('camZoomsBg', false)
        setProperty('camZoomsHud', false)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + zv1)
        setProperty('camGame.zoom', getProperty('camGame.zoom') + zv2)
    end
end
function onTweenCompleted(t)
    if t == 'ip1y' then
        dontLookForPos = false
    end
end
function onTimerCompleted(tag)
    if ccaptions then
		if tag == 'captionLength' then
			if v2 > 0.05 then
				doTweenAlpha('captionAlpha', 'captionText', 0, 0.1, 'linear')
			end
		end
	end
	if tag == 'stt' then
		st = false
	end
end
function onDestroy()
    if c then
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset)
    end
    close()
end
function performanceD()
	close()
end
function noBopBruh(noBop)
    noDoBop = noBop
end
function invt(t)
	ls = t
	captionson(ccaptions)
end
function middcs(ts)
	mid = ts
	captionson(ccaptions)
end
function captionson(capen)
	ccaptions = capen
	if ccaptions then
		makeLuaText('captionText', 'l', 600, 0,500)
    	addLuaText('captionText')
    	setTextSize('captionText', 35)
    	setTextAlignment('captionText', 'center')
    	setProperty('captionText.x', (screenWidth/2)-(getProperty('captionText.width')/2))
    	setObjectCamera('captionText', 'other')
    	setProperty('captionText.alpha', 0)
	end
	if mid and not ls then
		screenCenter("captionText", 'x')
	elseif ls and not mid then
		setProperty("captionText.x", 630)
	elseif not ls and not mid then
		setProperty("captionText.x", 0)
	elseif mid and ls then
		screenCenter("captionText", 'x')
	end
end
--@PringleKitten