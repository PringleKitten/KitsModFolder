local defx = 0
local defy = 0
local newy = 0
local newx = 0
local ang = 0
local s = 0

local mdc = 'Enabled'
local modchart = true

function onCreate()
    makeLuaText("mc", ("ModChart: "..mdc), screenWidth, 0.0, screenHeight/1.25)
    setObjectCamera("mc", 'other')
    setTextColor("mc", "FF0000")
    setTextSize("mc", 60)
    screenCenter("mc", 'x')
    addLuaText("mc")

    makeLuaText("mct", "<Press T or F to choose>", screenWidth, 0.0, screenHeight/1.35)
    setObjectCamera("mct", 'other')
    setTextColor("mct", "00FF00")
    setTextSize("mct", 40)
    screenCenter("mct", 'x')
    addLuaText("mct")

    --Debugging for ModChart Help
    makeLuaText("step", "curStep: "..curStep, 0, 0.0, 0.0)
    addLuaText("step")
    setTextSize("step", 30)
    setObjectCamera("step", 'other')
end

-----------------------------------------------------
-- T H E  W H O L E   E N T I R E   M O D C H A R T--
-----------------------------------------------------
function onStepHit()
    if modchart then
        setTextString("step", "curStep: "..curStep)
        if curStep > 1 and curStep < 4 then
            pX0 = getPropertyFromGroup('playerStrums', 0, 'x')
            pX1 = getPropertyFromGroup('playerStrums', 1, 'x')
            pX2 = getPropertyFromGroup('playerStrums', 2, 'x')
            pX3 = getPropertyFromGroup('playerStrums', 3, 'x')

            pY0 = getPropertyFromGroup('playerStrums', 0, 'y')
            pY1 = getPropertyFromGroup('playerStrums', 1, 'y')
            pY2 = getPropertyFromGroup('playerStrums', 2, 'y')
            pY3 = getPropertyFromGroup('playerStrums', 3, 'y')

            ang = getProperty('camHUD.angle')
            setProperty('camZoomingMult', 0)
        elseif curStep == 44 then 
            tweenxX(400,0.9,'expoIn')
            tweenyY(250,0.9,'expoIn')

            zm = 0.2
            doTweenZoom("ss", "camHUD", zm, 0.9, "expoIn")
        elseif curStep == 68 then
            cancelTween('a')
            cancelTween('ss')
            setProperty('camHUD.angle', 0)
            pReset('x')
            tweenyY(screenHeight*1.25,0)
            setProperty('camHUD.zoom', 3)

            tweenyY(0,0.6,'linear')

            zm = 1
            doTweenZoom("ss", "camHUD", zm, 0.1, "expoIn")
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'ss' then
        setProperty("defaultCamUIZoom",zm)
        s = s+1
        if s == 1 then
            ang = -25
            setProperty('camHUD.angle', ang)
            doTweenAngle("a", "camHUD", ang-50, 1, "linear")

            zm = 3
            doTweenZoom("ss", 'camHUD', zm, 1, 'linear')
        end
    end
end

---------------------------------------
--All setup and stuff to make it work--
---------------------------------------
function onUpdate()
    if not allowCountdown then
        if keyboardJustPressed('T') then
            modchart = true
            mdc = 'Enabled'
            setTextString("mc", ("ModChart: "..mdc))
            setTextColor("mc", "FF0000")
        elseif keyboardJustPressed("F") then
            modchart = false
            mdc = 'Disabled'
            setTextString("mc", ("ModChart: "..mdc))
            setTextColor("mc", "00FFFF")
        end
        if keyboardJustPressed('SPACE') then
            removeLuaText("mc")
            removeLuaText("mct")
        end
    end

    for i = 0,3 do        
        if getPropertyFromGroup('playerStrums', i, 'y') < screenHeight/2.15 then
            setPropertyFromGroup('playerStrums',i,'downScroll',false);
        end

        if getPropertyFromGroup('playerStrums', 0, 'y') > screenHeight/2.15 then
            setPropertyFromGroup('playerStrums',i,'downScroll',true);
        end
    end
end

function tweenxX(p,t,e)
    if t == 0 then
        setPropertyFromGroup('playerStrums', 0, 'x',p)
        setPropertyFromGroup('playerStrums', 1, 'x',p)
        setPropertyFromGroup('playerStrums', 2, 'x',p)
        setPropertyFromGroup('playerStrums', 3, 'x',p)
    else
        noteTweenX('x0', 4, pX0+p, t, e)
        noteTweenX('x1', 5, pX1+p, t, e)
        noteTweenX('x2', 6, pX2+p, t, e)
        noteTweenX('x3', 7, pX3+p, t, e)
    end
end

function tweenyY(p,t,e)
    if t == 0 then
        setPropertyFromGroup('playerStrums', 0, 'y',p)
        setPropertyFromGroup('playerStrums', 1, 'y',p)
        setPropertyFromGroup('playerStrums', 2, 'y',p)
        setPropertyFromGroup('playerStrums', 3, 'y',p)
    else
        noteTweenY('y0', 4, pY0+p, t, e)
        noteTweenY('y1', 5, pY1+p, t, e)
        noteTweenY('y2', 6, pY2+p, t, e)
        noteTweenY('y3', 7, pY3+p, t, e)
    end
end

function pReset(l)
    if l == 'x' then
        setPropertyFromGroup('playerStrums', 0, 'x',pX0)
        setPropertyFromGroup('playerStrums', 1, 'x',pX1)
        setPropertyFromGroup('playerStrums', 2, 'x',pX2)
        setPropertyFromGroup('playerStrums', 3, 'x',pX3)
    elseif l == 'y' then
        setPropertyFromGroup('playerStrums', 0, 'y',pY0)
        setPropertyFromGroup('playerStrums', 1, 'y',pY1)
        setPropertyFromGroup('playerStrums', 2, 'y',pY2)
        setPropertyFromGroup('playerStrums', 3, 'y',pY3)
    end
end