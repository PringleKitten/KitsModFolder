local hiding = true
local gO = false
function onCreate()
    if shadersEnabled then
        luaSprite('vignettepgk', 0, 0, 12,12, 0, 0, 'game', 'xy', 100)
        luaSprite('blackScreen', 0, 0, 4,4, 0, 0, 'other', 'n', 101)

        luaGraphic('vignetOuterTop', getProperty('lS-vignettepgk.x')-1500, 0, 7500, 2500, '000000')
        luaGraphic('vignetOuterLeft', 0, getProperty('vignetOuterTop.y'), 3400, 5000, '000000')
        luaGraphic('vignetOuterRight', 0, getProperty('lS-vignettepgk.y')-1000, 3400, 5000, '000000')
        luaGraphic('vignetOuterBottom', getProperty('lS-vignettepgk.x')-1500, 0, 7500, 2500, '000000')
    else
        close(true)
    end
end

function luaGraphic(tag,xPos,yPos,width,height,color)
    makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, width, height, color)
    setScrollFactor(tag, 0.0, 0.0)
	setObjectCamera(tag, 'game')
    setProperty(tag..'.alpha', 0)
	addLuaSprite(tag, true)
end

function luaSprite(tag, xPos, yPos, xw, yh, sF, aA, C, sC, oO)
    local nTag = 'lS-'..tag
    makeLuaSprite(nTag, 'me/popup/'..tag,xPos,yPos)
    setObjectCamera(nTag, C)
    setScrollFactor(nTag, sF, sF)
    setObjectOrder(nTag, oO)
    scaleObject(nTag, xw,yh)
    setProperty(nTag..".alpha", aA)
    if sC ~= 'n' then
        screenCenter(nTag, sC)
    end
end

function onEvent(name, value1, value2)
    if name == "vpgk" then
        if value2 ~= 'black' or value2 ~= 'blacktween' or value2 ~= 'noblacktween' or value2 ~= 'noblack' then
		    sizea = tonumber(value1)
            cancelTween("stpoo")
        end
        if value1 == 'hide' or value2 == 'hide' then
            hiding = true
            local objects = {"lS-vignettepgk", "vignetOuterTop", "vignetOuterLeft", "vignetOuterRight", "vignetOuterBottom"}

            for i, object in ipairs(objects) do
                doTweenAlpha("stpoo"..i, object, 0, 1, "circOut")
            end
            doTweenX("sizerTwx", "lS-vignettepgk.scale", sizea, 1, 'expoOut')
            doTweenY("sizerTwy", "lS-vignettepgk.scale", sizea, 1, 'expoOut')
            gO = true
        end
        if value2 ~= 'hide' then
            hiding = false
            local objects = {"lS-vignettepgk", "vignetOuterTop", "vignetOuterLeft", "vignetOuterRight", "vignetOuterBottom"}

            for _, object in ipairs(objects) do
                setProperty(object..'.alpha', 1)
            end
            doTweenX("sizerTwx", "lS-vignettepgk.scale", sizea, 1, 'expoOut')
            doTweenY("sizerTwy", "lS-vignettepgk.scale", sizea, 1, 'expoOut')
            gO = true
        end
        if value2 == 'black' then
            setProperty('lS-blackScreen.alpha', 1)
        elseif value2 == 'blacktween' then
            doTweenAlpha("blackb", "lS-blackScreen", 1, value1, "linear")
        elseif value2 == 'noblack' then
            setProperty('lS-blackScreen.alpha', 1)
        elseif value2 == 'noblacktween' then
            doTweenAlpha("blackb", "lS-blackScreen", 0, value1, "linear")
        end
    end
end

function onUpdate()
    if gO then
        setProperty("vignetOuterTop.y", -1*(109.9*getProperty('lS-vignettepgk.scale.y')+2141))
        setProperty("vignetOuterLeft.x", -1*(198*getProperty('lS-vignettepgk.scale.x')+2765))
        setProperty("vignetOuterRight.x", (198*getProperty('lS-vignettepgk.scale.x')+645))
        setProperty("vignetOuterBottom.y", (109.9*getProperty('lS-vignettepgk.scale.y')+360))
    end
end

function onTweenCompleted(tag)
    if tag == 'sizerTwx' then
        gO = false
    end
end