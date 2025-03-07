local people = {
    'PringleKitten', -- Gameplay
    'Tanger' -- Composer
}

local credits = {
    'gameplayborder', 'gameplaybg', 'gameplaytext', 'gameplayperson', 'composerborder', 'composerbg', 'composertext', 'composerperson'
}

function onCreate()
    luaText('gameplayperson', 545, 105, 23, 'ff00ff', '000000', people[1])
    luaText('gameplaytext', 545, 75, 23, '00ff00', '000000', 'Gameplay')
    if getProperty("gameplaytext.width") < getProperty("gameplayperson.width") then
        setProperty("gameplaytext.x", getProperty("gameplayperson.x")+(getProperty("gameplayperson.width")-(getProperty("gameplayperson.width")/2)-(getProperty("gameplaytext.width")/2)))
        luaGraphic('gameplaybg', 545, 75, getTextWidth("gameplayperson"), 60, '000000')
    else
        luaGraphic('gameplaybg', 545, 75, getTextWidth("gameplaytext"), 60, '000000')
    end
    luaGraphic('gameplayborder', 540, 70, getProperty("gameplaybg.width")+10, 70, '00ffff')
    setObjectOrder("gameplayborder", 1)
    setObjectOrder("gameplaybg", 2)
    setObjectOrder("gameplaytext", 3)
    setObjectOrder("gameplayperson", 4)

    luaText('composerperson', 5, 685, 23, 'ffffff', '000000', people[2])
    luaText('composertext', 5, 655, 23, 'ff0000', '000000', 'Composer')
    if getProperty("composertext.width") < getProperty("composerperson.width") then
        setProperty("composertext.x", getProperty("composerperson.x")+(getProperty("composerperson.width")-(getProperty("composerperson.width")/2)-(getProperty("composertext.width")/2)))
        luaGraphic('composerbg', 5, 655, getTextWidth("composerperson"), 60, '000000')
    else
        luaGraphic('composerbg', 5, 655, getTextWidth("composertext"), 60, '000000')
    end
    luaGraphic('composerborder', 0, 650, getProperty("composerbg.width")+10, 70, '0000ff')
    setObjectOrder("composerborder", 1)
    setObjectOrder("composerbg", 2)
    setObjectOrder("composertext", 3)
    setObjectOrder("composerperson", 4)

    for _, credits in ipairs(credits) do
        setProperty(credits .. '.alpha', 0)
        setProperty(credits .. '.y', getProperty(credits .. '.y')-800)
    end
end

function onCountdownStarted()
    for _, credits in ipairs(credits) do
        setProperty(credits .. '.alpha', 1)
        doTweenY(credits..'move', credits, getProperty(credits .. '.y')+800, 0.5, "expoOut")
    end
end

function onBeatHit()
    if curBeat == 5 then
        for _, credits in ipairs(credits) do
            doTweenX(credits..'away', credits, getProperty(credits .. '.x')+1500, 1, "expoIn")
        end
    end
end

function onTweenCompleted(tag)
    for _, credits in ipairs(credits) do
        if tag == credits..'away' then
            removeLuaSprite(credits)
            close(true)
        end
    end
end

-- Making stuff but in one line

function luaGraphic(tag,xPos,yPos,width,height,color)
    makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, width, height, color)
	setObjectCamera(tag, 'other')
	addLuaSprite(tag)
end
function luaText(tag,xPos,yPos,size,colorA,colorB,text)
	makeLuaText(tag, text, 0, xPos, yPos)
	setTextSize(tag, size)
	setTextColor(tag, colorA)
	setTextBorder(tag, 2, colorB)
	setTextAlignment(tag, 'left')
	setObjectCamera(tag, 'other')
	addLuaText(tag)
end