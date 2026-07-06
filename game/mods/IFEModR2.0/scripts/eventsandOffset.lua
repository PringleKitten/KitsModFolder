local customFPS = true -- Use my Custom FPS Text
local target = 60
local zv1,zv2 = 0,0
local go = false
local doIt = false
local st = false
local noDoBop = false
local ltxT = 'fpsDrawer'
function onCreate()
	makeLuaText('st', 'l', '800', 400,450)
    addLuaText('st')
    setTextSize('st', 50)
    setTextAlignment('st', 'center')
    setProperty('st.x', (screenWidth/2)-(getProperty('st.width')/2))
    setObjectCamera('st', 'other')
    setProperty('st.alpha', 0)
end
function onCreatePost()
    if getProperty('boyfriend.curCharacter') == 'blueBar' then
        setProperty('iconP1.visible', false)
    end
    if getProperty('dad.curCharacter') == 'redBar' then -- should be opponent
        setProperty('iconP2.visible', false)
    end
    setProperty('skipArrowStartTween', true)
    setPropertyFromClass('flixel.FlxG', 'fixedTimestep', false)
    -- This stuff I wanna change if I ever move notes around
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
widthP1 = 0
widthP2 = 0

t = 0
delta = 0
function lerp(a, b, x)
    return a + (b - a) * x
end
function updateIcons()
    setProperty('iconP1.scale.x', 1 + widthP1)
    setProperty('iconP2.scale.x', 1 + widthP2)
    local baseY = getProperty('healthBar.y') - 150
    local p1ScaleY = (getProperty("iconP1.scale.y") - 1) / -2 + 1
    local p2ScaleY = (getProperty("iconP2.scale.y") - 1) / -2 + 1
    setProperty("iconP1.scale.y", p1ScaleY)
    setProperty("iconP2.scale.y", p2ScaleY)
    setProperty("iconP1.y", baseY + (p1ScaleY * 75))
    setProperty("iconP2.y", baseY + (p2ScaleY * 75))
end
function onUpdate()
	if st then
		doTweenAlpha('st', 'st', 1, 0.2, 'linear')
	else
		doTweenAlpha('st', 'st', 0, 0.2, 'linear')
	end
end
function onUpdatePost(elapsed)
    updateIcons()
    t = t + elapsed
    delta = t / 0.9
    if delta > 1 then
        delta = 1
    end
    widthP1 = lerp(widthP1, 0, delta)
    widthP2 = lerp(widthP2, 0, delta)
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
    debugPrint('Song Added Offset: '..'('..getProperty('SONG.offset')..')') -- offset of the song json not the offset you set in the menu
    debugPrint('User Offset: '..'('..offset..')')
    debugPrint('')
    debugPrint('')
    debugPrint('')
end
local nogz = false
local nohz = false
function onEvent(n,v1,v2)
    if n == 'nz' then
        av1 = tonumber(v1)
        av2 = tonumber(v2)
        if av1 == 1 then
            setProperty('camZoomsHud', false)
            nohz = true
        elseif av1 == 2 then
            setProperty('camZoomsHud', true)
            nohz = false
        end
        if av2 == 1 then
            setProperty('camZoomsBg', false)
            nogz = true
        elseif av2 == 2 then
            setProperty('camZoomsBg', true)
            nogz = false
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
    local bounceStr = (getProperty('healthBar.percent') * 0.01) - 0.5
    widthP1 = 0.55 * (1 + bounceStr)
    widthP2 = 0.55 * (1 - bounceStr)
    t = 0
    updateIcons()
    end
    if doIt then
        setProperty('camZoomsBg', false)
        setProperty('camZoomsHud', false)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + zv1)
        setProperty('camGame.zoom', getProperty('camGame.zoom') + zv2)
    else
        if not nohz then
            setProperty('camZoomsBg', true)
        end
        if not nogz then
            setProperty('camZoomsHud', true)
        end
    end
end
function onTimerCompleted(tag)
	if tag == 'stt' then
		st = false
	end
end
function onDestroy()
    close()
end
function performanceD()
	close()
end
function noBopBruh(noBop)
    noDoBop = noBop
end
--@PringleKitten