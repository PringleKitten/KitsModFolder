callScript("scripts/LaneUnderlay", "noChoice")
callScript("scripts/ratings", "noChoice")

local cupAlertCreated = false
local cupAlertOfsX = 157
local cupAlertOfsY = -304
local alertCount = 0
local alertDestroyed = 0

local haveDodge = false
local haveAttack = false

local cardPercent = 0

local enableWarning = true
local pewdmg = 0
local barOffsetX = 0
local barOffsetY = 0
local fps = 0
local splashAlpha = 0
local defaultChrom = 0.001
local chromVal = 0.001
local scaleEffect = 1
local cupLimitedSongs = 4
local foundedBf = false
local foundedDad = false
local foundedGf = false
local nightmareStage = false
local ending = false
local hudShader = true
local enableSystem = true
local allowCountdown = true
local enableShader = true
local changeHealthBar = true
local healthBarStyle = ''
local barImage = ''
local IndieCrossCountDownStyle = ''
local curTarget = ''
local cupSongStyle = 'normal'
local texture = 'noteSplashes/noteSplashesCup'
--General Variables
local timePercent = 0
local GameOverActive = false
local enableEnd = true
local IndieCrossGameOverStyle = ''
local dialogeFound = ''
local dialogue = {
    "I've fought monsters 10 times your size!",
    "I'm surprised that you had the balls to fight me!",
    "It was too easy to defeat you!",
    "Time your dodges better, geese"
}
--Cuphead Variables
local GameOverState = 0
local CupSelection = 0
local AlphaCupEffect = 1
local EnabledCharacters = {
    'bf-ic-rain',
    'cuphead-pissed'
}
local people = {
    'PringleKitten', -- Gameplay
    'Orenji | longestsoloever' -- Composer
}
local credits = {
    'gameplayborder', 'gameplaybg', 'gameplaytext', 'gameplayperson', 'composerborder', 'composerbg', 'composertext', 'composerperson'
}
local splashes = {}
local splashAnims = {'note splash purple 1','note splash blue 1', 'note splash green 1','note splash red 1'}
local cameraOffsets = {
    default = 20
}
function onCreate()
    precacheImage('cup/cardfull')
    precacheImage('cup/Cardcrap')
    if downscroll then
        makeAnimatedLuaSprite('Cardcrap', 'cup/Cardcrap',1000,40);
    else
        makeAnimatedLuaSprite('Cardcrap', 'cup/Cardcrap',1000,screenHeight - 190);
    end
    
    addAnimationByPrefix('Cardcrap','Flipped','Card but flipped instance 1',1,true)
    addOffset('Cardcrap','Flipped',0,0)
    addAnimationByPrefix('Cardcrap','Filled','Card Filled instance 1',24,false);
    addOffset('Cardcrap','Filled',0,0)
    addAnimationByPrefix('Cardcrap','Parry','PARRY Card Pop out  instance 1',24,false);
    addOffset('Cardcrap','Parry',0,0)
    addAnimationByPrefix('Cardcrap','Normal','Card Normal Pop out instance 1',24,false);
    addOffset('Cardcrap','Normal',0,35)
    addAnimationByPrefix('Cardcrap','Used','Card Used instance 1',24,false);
    addOffset('Cardcrap','Used',0,0)
    setObjectCamera('Cardcrap','hud')
    playAnim('Cardcrap','Used',false)
    addLuaSprite('Cardcrap',true)
    
    makeLuaSprite('CardcrapGraphic','cup/cardfull',getProperty('Cardcrap.x'),getProperty('Cardcrap.y'))
    setObjectCamera('CardcrapGraphic','hud')
    setProperty('CardcrapGraphic.alpha',0.001)
    addLuaSprite('CardcrapGraphic',true)

    updateCard()
    setPropertyFromClass('backend.ClientPrefs','data.timeBarType','Song Name')
    if enableWarning then
        if not downscroll then
            precacheImage('cup/mozo')
        else
            precacheImage('cup/gay')
            cupAlertOfsY = 27
        end
    end
    setProperty('defaultCamZoom', 0.7)
    setProperty('camGame.zoom', 0.7)
    setProperty('vocals.volume', 0.6)
    makeAnimatedLuaSprite('MugMan','cup/Mugman Fucking dies',2000,1300)
    addAnimationByPrefix('MugMan','Walking','Mugman instance 1',24,false)
    addAnimationByPrefix('MugMan','Dead','MUGMANDEAD YES instance 1',24,false)
    playAnim('MugMan','Walking',false)
    setProperty('MugMan.alpha',0.001)
    updateHitbox('MugMan')
    addLuaSprite('MugMan',true)

    makeAnimatedLuaSprite('KnockOutText','cup/knock',125,200)
    addAnimationByPrefix('KnockOutText','Knock','A KNOCKOUT!',28,false)
    setObjectCamera('KnockOutText','hud')
    scaleObject('KnockOutText',0.9,0.9)
    setProperty('KnockOutText.alpha',0.001)
    addLuaSprite('KnockOutText',true)
    makeAnimatedLuaSprite('AttackButton','IC_Buttons',-6,245)
    addAnimationByPrefix('AttackButton','Static','Attack instance 1',24,true)
    addOffset('AttackButton','Static',0,0)
    addAnimationByPrefix('AttackButton','NA','AttackNA instance 1',30,false)
    addOffset('AttackButton','NA',0,25)
    
    setObjectCamera('AttackButton','hud')
    addLuaSprite('AttackButton',false)
    scaleObject('AttackButton',0.5,0.5)
    setProperty('AttackButton.alpha',0.5)
    playAnim('AttackButton','Static',true)
    if songName == 'knockout (metal cover)' then
        IndieCrossCountDownStyle = 'Cuphead'
        setProperty('introSoundsSuffix','-silence')
        makeAnimatedLuaSprite('CupTitle','cup/ready_wallop',-600,-100)
        addAnimationByPrefix('CupTitle','Ready?','Ready? WALLOP!',24,false)
        playAnim('CupTitle','Ready?',false)
        setObjectCamera('CupTitle','hud')
        
        makeAnimatedLuaSprite('CupThing','cup/the_thing2.0',-10,0)
        setScrollFactor('CupThing',0,0)
        addAnimationByPrefix('CupThing','BOOAppear','BOO instance 1',22,false)
        addAnimationByPrefix('CupThing','BOOBye','BOOBye instance 1',22,false)
        playAnim('CupThing','BOOAppear',false)
        scaleObject('CupThing',1.031,1.025)
        addLuaSprite('CupThing',true)
        setObjectCamera('CupThing', 'hud')
        cupSongStyle = 'angry'
        cupLimitedSongs = 1
        runTimer('CupReady',stepCrochet/ 1200 + 0.1)
        runTimer('CupThingBye',stepCrochet/ 1200 + 0.1)
        precacheImage('cup/ready_wallop')
        precacheImage('cup/the_thing2.0')
    end
    if enableSystem then
		splashAlpha = getPropertyFromClass('backend.ClientPrefs','data.splashAlpha')
	end
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
    local stage = getPropertyFromClass('states.PlayState','curStage')
    if string.match(stage,'field') == 'field' then
            setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'Cup/CupDeath');
            setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver');
            setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd');
            IndieCrossGameOverStyle = 'Cuphead'

            makeAnimatedLuaSprite('BfGhost','cup/BF_Ghost',0,0)
            addAnimationByPrefix('BfGhost','Death','thrtr instance 1',24,true)
            setProperty('BfGhost.alpha',0.001)
            addLuaSprite('BfGhost',true)

            makeLuaSprite('You re dead','cup/death',200,300)
            setObjectCamera('You re dead','other')
            scaleObject('You re dead',0.9,0.9)

            local cardTexture = 'cup/cuphead_death'
            if songName == 'knockout (metal cover)' then
                cardTexture = 'cup/cuphead_death2'
            end
            makeLuaSprite('CupBlackScreen',nil,0,0)
            makeGraphic('CupBlackScreen',screenWidth + 10,screenHeight + 10,'000000')
            setObjectCamera('CupBlackScreen','other')
            setProperty('CupBlackScreen.alpha',0.001)
            addLuaSprite('CupBlackScreen',false)

            makeLuaSprite('DeathCard',cardTexture,400,80)
            setObjectCamera('DeathCard','other')
            scaleObject('DeathCard',0.8,0.8)
            setProperty('DeathCard.angle',-55)
            setProperty('DeathCard.alpha',0)

            makeAnimatedLuaSprite('BfDeath','cup/NewCupheadrunAnim',getProperty('DeathCard.x') - 180,getProperty('DeathCard.y') + 128)
            addAnimationByPrefix('BfDeath','run','Run_cycle_gif copy instance 1',24,true)
            setObjectCamera('BfDeath','other')
            setProperty('BfDeath.alpha',0)
            scaleObject('BfDeath',0.5,0.5)

            makeAnimatedLuaSprite('CupRetryButton','cup/buttons',getProperty('DeathCard.x') + 230,getProperty('DeathCard.y') + 360)
            addAnimationByPrefix('CupRetryButton','Selected','retry white',24,true)
            addAnimationByPrefix('CupRetryButton','Normal','retry basic',24,true)
            setProperty('CupRetryButton.alpha',0)

            makeAnimatedLuaSprite('CupExitButton','cup/buttons',getProperty('DeathCard.x') + 175,getProperty('DeathCard.y') + 425)
            addAnimationByPrefix('CupExitButton','Normal','menu basic',24,true)
            addAnimationByPrefix('CupExitButton','Selected','menu white',24,true)
            setProperty('CupExitButton.alpha',0)
            setObjectCamera('CupExitButton','other')


            setObjectCamera('CupRetryButton','other')
            enableEnd = false
                
            if (songName == 'knockout (metal cover)') then
                dialogeFound = "You had your run, but now you're done!"
            end
            
            makeLuaText('CupText',"'"..dialogeFound.."'",500,getProperty('DeathCard.x') + 5,getProperty('DeathCard.y') + 255)
            setObjectCamera('CupText','other')
            setProperty('CupText.color',getColorFromHex('000000'))
            setTextBorder('CupText',0)
            setProperty('CupText.alpha',0)
            setTextFont('CupText','CupheadICFont.ttf')

            precacheImage('cup/BfGhost')
            precacheImage('cup/death')
            precacheImage('cup/cuphead_death')
            precacheImage('cup/NewCupheadrunAnim')
            precacheImage('cup/buttons')
    end
end
function onCreatePost()
    for events = 0,getProperty('eventNotes.length')-1 do
        local eventName = getPropertyFromGroup('eventNotes',events,'event')
        if eventName == 'CupheadAttack' or eventName == 'CupheadDoubleAttack' then
            haveDodge = true
        elseif eventName == 'CupheadShooting' then
            haveAttack = true
        end
    end
    if haveAttack then
        makeAnimatedLuaSprite('AttackButton','IC_Buttons',-6,245)
        scaleObject('AttackButton',0.5,0.5)
        setProperty('AttackButton.alpha',0.5)
        addAnimationByPrefix('AttackButton','normal','Attack instance 1',0,true)
        addAnimationByPrefix('AttackButton','clicked','Attack Click instance 1',24,false)
        addAnimationByPrefix('AttackButton','NA','AttackNA instance 1',24,false)
        setObjectCamera('AttackButton','hud')
        setProperty('AttackButton.offset.x',0)
        setProperty('AttackButton.offset.y',0)
        playAnim('AttackButton','normal',false)
        addLuaSprite('AttackButton',false)
    end
    if haveDodge then
        makeAnimatedLuaSprite('DodgeButton','IC_Buttons',-6,335)
        scaleObject('DodgeButton',0.5,0.5)
        setProperty('DodgeButton.alpha',0.5)
        addAnimationByPrefix('DodgeButton','normal','Dodge instance 1',0,true)
        addAnimationByPrefix('DodgeButton','clicked','Dodge click instance 1',24,false)
        setObjectCamera('DodgeButton','hud')
        setProperty('DodgeButton.offset.x',0)
        setProperty('DodgeButton.offset.y',0)
        playAnim('DodgeButton','normal',false)
        addLuaSprite('DodgeButton',false)
    end
    local font = nil
    local size = getTextSize('scoreTxt')
    local border = nil
    local textY = 0

    if string.match(curStage,'field') then
        font = 'memphis.otf'
        textY = 3 
    end
    setTextString('timeTxt',string.upper(string.sub(songName,0,1))..string.sub(songName,2))
    if font ~= '' then
        setTextFont('scoreTxt',font)
        setTextFont('timeTxt',font)
    end
    setTextSize('scoreTxt',size)
    
    if border ~= nil then
        setTextBorder('scoreTxt',border,'000000')
        setTextBorder('timeTxt',border,'000000')
    end
    setTextSize('timeTxt',15)
    setProperty('timeTxt.offset.y',-10 + textY)
    setProperty('camGame.scroll.x',getProperty('dadGroup.x') + (getProperty('boyfriendGroup.x') - getProperty('dadGroup.x')) - screenWidth/2.0)
    setProperty('camGame.scroll.y',getProperty('dadGroup.y') - screenHeight/2.0)
    precacheImage(texture)
	if splashAlpha > 0 and enableSystem then
		precacheImage('noteSplashes/noteParry')
		makeAnimatedLuaSprite('noteSplashp', texture, 100, 100)
		addLuaSprite('noteSplashp',false)
		setProperty('noteSplashp.alpha',0.001)
	end
    if string.find(curStage,'field',0,true) ~= nil then
        for strumLineLength = 0,7 do
            setPropertyFromGroup('strumLineNotes', strumLineLength, 'texture','cup/Cuphead_NOTE_assets')
            setPropertyFromGroup('strumLineNotes', strumLineLength, 'useRGBShader',false)
        end
        for notesLength = 0,getProperty('unspawnNotes.length')-1 do
            if getPropertyFromGroup('unspawnNotes', notesLength, 'noteType') == '' and getPropertyFromGroup('unspawnNotes', notesLength, 'texture') ~= 'cup/Cuphead_NOTE_assets' then
                setPropertyFromGroup('unspawnNotes', notesLength, 'texture', 'cup/Cuphead_NOTE_assets');
                setPropertyFromGroup('unspawnNotes', notesLength, 'rgbShader.enabled', false);
            end
        end
    end
    if downscroll then
		setProperty('healthBar.y',getProperty('healthBar.y') - 30)
		setProperty('scoreTxt.y',getProperty('scoreTxt.y') - 30)
		setProperty('iconP1.y',getProperty('iconP1.y') - 30)
		setProperty('iconP2.y',getProperty('iconP2.y') - 30)
	end
	
    if stringStartsWith(curStage,'field') then
	    healthBarStyle = 'Cuphead'
		barImage = 'healthbar-ic/cuphealthbar'

		barOffsetX = 25
		barOffsetY = 18
	end
	if changeHealthBar == true then
		createCustomBar(barImage,barOffsetX,barOffsetY)
	end
    detectCharacter()
    if shadersEnabled then
        if songName == 'knockout (metal cover)' then
            defaultChrom = 0.0015
            chromVal = 0.001
            pewdmg = 0.0225
        end
        if enableShader then
            chromVal = defaultChrom
            if pewdmg == 0 then
                pewdmg = defaultChrom + 0.005
            end
            initLuaShader('ChromaticAberration')
            makeLuaSprite('chromShader')
            if not hudShader then
                runHaxeCode(
                    [[
                        var chromShader = game.createRuntimeShader("ChromaticAbberation");
                        game.camGame.setFilters([new ShaderFilter(chromShader)]);
                        game.getLuaObject('chromShader').shader = chromShader;
                        return;
                    ]]
                )
            else
                runHaxeCode(
                    [[
                        var chromShader = game.createRuntimeShader("ChromaticAbberation");
                        var shader = new ShaderFilter(chromShader);
                        game.camGame.setFilters([shader]);
                        game.camHUD.setFilters([shader]);
                        game.getLuaObject('chromShader').shader = chromShader;
                        return;
                    ]]
                )
            end
            setShaderFloat('chromShader','rOffset',chromVal)
            setShaderFloat('chromShader','bOffset',chromVal * -1)
        end
    end
end
function onUpdate(el)
    local cardAnim = getProperty('Cardcrap.animation.curAnim.name')
    if (getProperty('Cardcrap.animation.curAnim.finished')) then
        if (cardAnim  == 'Used') and cardPercent == -1 then
            cardPercent = 0
            updateCard()
        elseif (cardAnim == 'Parry') then
            playAnim('Cardcrap','Flipped',true)
        end
    end
    if haveDodge and doITD then
        if keyboardJustPressed('SPACE') then
            playAnim('DodgeButton','clicked',true)
            setProperty('DodgeButton.offset.x',-5)
            setProperty('DodgeButton.offset.y',-7)
            runTimer('animBack', 0.2)
            doITD = false
        end
    end
    if haveAttack and doITA then
        if keyboardJustPressed('SHIFT') then
            playAnim('AttackButton','clicked',true)
            setProperty('AttackButton.offset.x',-7)
            setProperty('AttackButton.offset.y',-5)
            runTimer('animBackS', 0.2)
            doITA = false
        end
    end
    if alertCount > alertDestroyed then
        for alerts = alertDestroyed,alertCount-1 do
            local name = 'CupAlert'..alerts
            setProperty(name..'.x',getProperty('healthBar.x') + cupAlertOfsX)
            setProperty(name..'.y',getProperty('healthBar.y') + cupAlertOfsY)
            setProperty(name..'.angle',getProperty('healthBar.angle'))
            if getProperty(name..'.animation.curAnim.finished') then
                removeLuaSprite(name,true)
                alertDestroyed = alertDestroyed + 1
            end
        end
    end
    if luaSpriteExists('KnockOutText') and getProperty('KnockOutText.animation.curAnim.finished') and getProperty('KnockOutText.alpha') == 1 and not ending then
        doTweenAlpha('KnockBye','KnockOutText',0,1,'LinearOut')
        ending = true
    end
    if getProperty('AttackButton.animation.curAnim.finished') then
        playAnim('AttackButton','Static',true)
    end
    if IndieCrossCountDownStyle == 'Cuphead' then
        if getProperty('CupTitle.animation.curAnim.finished') == true then
            removeLuaSprite('CupTitle',true)
        end
        if getProperty('CupThing.animation.curAnim.finished') == true then
            if getProperty('CupThing.animation.curAnim.name') == 'BOOBye' then
                allowEnd = true
                endSong(true)
            end
            if getProperty('CupThing.animation.curAnim.name') == 'BOOAppear' then
                removeLuaSprite('CupThing',false)
            end
        end
    end
    for splash = 1,#splashes do
		if luaSpriteExists(splashes[splash][3]) and getProperty(splashes[splash][3]..'.animation.curAnim.finished') == true then
			setProperty(splashes[splash][3]..'.visible',false)
		end
	end
	for i = 0, getProperty('grpNoteSplashes.length') - 1 do
        setPropertyFromGroup('grpNoteSplashes', i, 'alpha', 0)
    end
    if IndieCrossGameOverStyle == 'Cuphead' then
        setProperty('CupExitButton.angle',getProperty('DeathCard.angle'))
        setProperty('CupRetryButton.angle',getProperty('DeathCard.angle'))
        setProperty('BfDeath.angle',getProperty('DeathCard.angle'))
        setProperty('CupText.angle',getProperty('DeathCard.angle'))

        if GameOverActive then
            setProperty('dad.animation.curAnim.frameRate',0)
            cameraSetTarget('boyfriend')
            setProperty('BfGhost.y',getProperty('BfGhost.y') - 4)

            for notesLength = 0, getProperty('notes.length')-1 do
                setPropertyFromGroup('notes', notesLength, 'active', false)
                setPropertyFromGroup('notes', notesLength, 'canBeHit', false)
            end
            for eventNotes = 0, getProperty('eventNotes.length')-1 do
                removeFromGroup('eventNotes', eventNotes, false)
                removeFromGroup('eventNotes', eventNotes, false)
            end
        end

        if GameOverState == 1 then
            for strumLineNotes = 0, 3 do
                setPropertyFromGroup('playerStrums', strumLineNotes, 'alpha', AlphaCupEffect)
                setPropertyFromGroup('opponentStrums', strumLineNotes, 'alpha', AlphaCupEffect)
            end
            for notesLength = 0, getProperty('notes.length')-1 do
                setPropertyFromGroup('notes', notesLength, 'alpha', AlphaCupEffect)
            end
        end

        if GameOverState == 2 then
            if CupSelection == 0 then
                playAnim('CupRetryButton','Selected')
                playAnim('CupExitButton','Normal')
                if keyJustPressed('up') or keyJustPressed('down') then
                    playSound('Cup/select', 0.5)
                    CupSelection = 1
                end
        
                if keyJustPressed('accept') or keyJustPressed('right') then
                    playSound('Cup/select', 0.5)
                    restartSong(false)
                end
            else
                playAnim('CupRetryButton','Normal')
                playAnim('CupExitButton','Selected')
                if keyJustPressed('up') or keyJustPressed('down') then
                    playSound('Cup/select', 0.5)
                    CupSelection = 0
                end
                if keyJustPressed('accept') or keyJustPressed('esc') or keyJustPressed('back') or keyJustPressed('left') then
                    playSound('Cup/select', 0.5)
                    exitSong(false);
                end
            end
        end
    end
    if version < '0.7' and luaSpriteExists('chromTween') then
        setChromShader(getProperty('chromTween.x'))
    end
end
function onUpdatePost()
    if enableSystem and not getProperty('isCameraOnForcedPos') then
        local ofs = 0
        local ofsX = 0
        local ofsY = 0
        
        if cameraOffsets[curTarget] == nil then
            ofs = cameraOffsets.default
        else
            ofs = cameraOffsets[curTarget]
        end
        local anim = getProperty(curTarget..'.animation.curAnim.name')
        if stringStartsWith(anim,'singLEFT') then
            ofsX = -ofs
        elseif stringStartsWith(anim,'singDOWN') then
            ofsY = ofs
        elseif stringStartsWith(anim,'singUP') then
            ofsY = -ofs
        elseif stringStartsWith(anim,'singRIGHT') then
            ofsX = ofs
        end
        if curStage == 'factory-run' then
            setProperty('camFollow.x',getProperty('dadGroup.x')+700+ofsX)
            setProperty('camFollow.y',1300+ofsY)
        else
            setProperty('camFollow.x',getCharX(curTarget)+ofsX)
            setProperty('camFollow.y',getCharY(curTarget)+ofsY)
        end
        
    end
end
function onStartCountdown()
    return Function_Continue;
end
function onCountdownStarted()
    for _, credits in ipairs(credits) do
        setProperty(credits .. '.alpha', 1)
        doTweenY(credits..'move', credits, getProperty(credits .. '.y')+800, 0.5, "expoOut")
    end
end
function onCountdownTick(counter)
    if IndieCrossCountDownStyle == 'Cuphead' then
        if counter > 0 then
            if counter == 1 then
                setProperty('countdownReady.visible',false)
            elseif counter == 2 then
                setProperty('countdownSet.visible',false)
            elseif counter == 3 then
                setProperty('countdownGo.visible',false)
            end
        end
    end
end
function onSongStart()
    if timeBarType ~= 'Disabled' then
        scaleObject('timeBar',1.5,1,false)
        setProperty('timeBar.rightBar.color',getColorFromHex('808080'))
        updateBarColor()
    end
end
function onUpdateScore()
    local ratingS = getProperty('ratingFC')
    if ratingS ~= '' then
        ratingS = '('..getProperty('ratingFC')..')'
    else
        ratingS = 'N/A'
    end
    local score = getProperty('songScore')
    local misses = getProperty('songMisses')
    local rating = math.floor(getProperty('ratingPercent') * 10000)/100
end
function onStepHit()
    if curStep == 1150 then
        playAnim('MugMan','Walking',true)
        setProperty('MugMan.alpha',1)
    elseif curStep == 1174 then
        playAnim('MugMan','Dead',false)
        playSound('Cup/CupHurt', 0.5)
        setProperty('KnockOutText.alpha',1)
        playAnim('KnockOutText','Knock',true)
        callScript('data/knockout-(metal-cover)/customevents','shotHit',{'MugMan'})
    end
end
function onBeatHit()
    if curBeat >= 5 and not r then
        for _, credits in ipairs(credits) do
            doTweenX(credits..'away', credits, getProperty(credits .. '.x')+1500, 1, "expoIn")
        end
        r = true
    end
end
function onEvent(name,v1,v2)
    if name == 'CupheadAttack' or name == 'CupheadDoubleAttack' then
        shaderTween(pewdmg,0.3,'linear')
    end
    if name == 'Change Character' then
        detectCharacter()
    end
end
function opponentNoteHit(id,dir,typeE,sus)
    setProperty('vocals.volume', 0.6)
    if sus then
        if not detectGf(false) and typeE ~= 'GF Sing' then
            if foundedDad and stringStartsWith(getProperty('dad.animation.curAnim.name'),'sing') then
                setProperty('dad.animation.curAnim.curFrame',2)
            end
        else
            gfAnim()
        end
    end
    if nightmareStage then
        local force = math.random((defaultChrom + 0.05)*100,((defaultChrom + 0.08)*100))/1100
        if sus then
            force = force - 0.002
        end
        shaderTween(force,0.15,'linear')
    end
end
function goodNoteHit(id, direction, noteType, isSustainNote)
    if cardPercent ~= -1 and cardPercent < 1 then
        if noteType == 'Parry Note' then
            setCardPercent(1)
            attackT()
        else
            setCardPercent(cardPercent + 0.005)
        end
    end
    setProperty('vocals.volume', 0.6)
    if splashAlpha > 0 and getPropertyFromGroup('notes',id,'rating') == 'sick' or getPropertyFromGroup('notes',id,'rating') == 'perfect' and enableSystem then
		spawnSplash(direction,noteType)
	end
    if isSustainNote then
        if not detectGf(true) and noteType ~= 'GF Sing' then
            if foundedBf and stringStartsWith(getProperty('boyfriend.animation.curAnim.name'),'sing') then
                setProperty('boyfriend.animation.curAnim.curFrame',2)
            end
        else
            gfAnim()
        end
    end
end
function onPause()
    if GameOverActive and IndieCrossGameOverStyle == 'Cuphead' then
        return Function_Stop
    end
end
function onGameOver()
    local curTimer = getSongPosition()
    local songLength = getProperty('songLength')
    timePercent = curTimer/songLength
    if not GameOverActive and IndieCrossGameOverStyle == 'Cuphead' then
        setProperty('camHUD.alpha',0.7)
        cameraShake('camGame',0.01,0.3)
        cameraShake('camHUD',0.01,0.3)
        cameraShake('camOther',0.01,0.3)
        setProperty('CupBlackScreen.alpha',0.4)
        playSound('Cup/CupDeath', 0.5)
        setProperty('boyfriend.visible',false)
        setProperty('BfGhost.alpha',1)
        setProperty('BfGhost.x',getProperty('boyfriend.x'))
        setProperty('BfGhost.y',getProperty('boyfriend.y'))
        addLuaSprite('You re dead',false)
        runTimer('GameOverText',2)
        GameOverActive = true
        addLuaSprite('DeathCard',true)
        addLuaSprite('CupExitButton',true)
        addLuaSprite('CupRetryButton',true)
        addLuaSprite('BfDeath',true)
        addLuaText('CupText',true)
        setPropertyFromClass('states.PlayState', 'instance.generatedMusic', false)
        setPropertyFromClass('states.PlayState', 'instance.vocals.volume', 0)
        setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
        timePercent = curTimer/songLength
        return Function_Stop;
    end
    if GameOverActive then
        return Function_Stop
    end
    return Function_Continue;
end
function onEndSong()
    if allowEnd == false then
        addLuaSprite('CupThing',true)
        playAnim('CupThing','BOOBye',true)
    end
    if GameOverActive and not enableEnd and IndieCrossGameOverStyle == 'Cuphead' then
        return Function_Stop;
    end
    return Function_Continue;
end
function onTimerCompleted(tag)
    if tag == 'animBack' then
        playAnim('DodgeButton','normal',true)
        setProperty('DodgeButton.offset.x',0)
        setProperty('DodgeButton.offset.y',0)
    end
    if tag == 'animBackS' then
        setProperty('AttackButton.offset.x',0)
        setProperty('AttackButton.offset.y',0)
        playAnim('AttackButton','normal',true)
    end
    if tag == 'CupReady' then
        local cupRandomSongs = math.random(0,1)
        playSound('Cup/intros/angry/'..cupRandomSongs, 0.5)
        addLuaSprite('CupTitle',true)
        runTimer('CupTitleDestroy',4)
    elseif tag == 'CupThingBye' then
        setProperty('CupThing.animation.curAnim.frameRate',22)
    end
    if tag == 'GameOverText' then
        GameOverState = 1
        doTweenAlpha('heyDeathCard','DeathCard',1,0.6,'linear')
        doTweenAlpha('camHUDBye','camHUD',0,0.3,'linear')
        doTweenAlpha('byeDeathText','You re dead',0,0.3,'linear')
        doTweenAngle('DeathCardAngle','DeathCard',-10,0.7,'cubeOut')
    end
    if string.match(tag,'gasSound') then--timer used in SansGastar script, in Burning in Hell song
        shaderTween(0.025,0.4,'circOut')
    end
end
function onTweenCompleted(tag)
    if tag == 'KnockBye' then
        removeLuaSprite('KnockOutText',true)
    end
    if tag == 'DeathCardAngle' then
        GameOverState = 2
        doTweenAlpha('heyRetryButton','CupRetryButton',1,0.5,'linear')
        doTweenAlpha('heyExitButton','CupExitButton',1,0.5,'linear')
        doTweenAlpha('heyBfRunBlue','BfDeath',1,0.5,'linear')
        doTweenAlpha('heyCupText','CupText',1,0.5,'linear')
        doTweenX('BfRunX','BfDeath',getProperty('DeathCard.x') + (-180 + (295 * timePercent)),1.5,'sineOut')
        doTweenY('BfRunY','BfDeath',getProperty('DeathCard.y') + (128 - (52 * timePercent)),1.5,'sineOut')
    end
    for _, credits in ipairs(credits) do
        if tag == credits..'away' then
            removeLuaSprite(credits)
        end
    end
    if string.match(tag,'chromTweenShader') and version < '0.7' then
        removeLuaSprite('chromTween',true)
    end
end
function onDestroy()
    setPropertyFromClass('backend.ClientPrefs','data.timeBarType',timeBarType)
end
function setCardPercent(percent)
    if cardPercent < 1 and percent >= 1 then
        setProperty('CardcrapGraphic.alpha',0)
        setProperty('Cardcrap.alpha',1)
        playAnim('Cardcrap','Normal',false)
    else
        if cardPercent < 0 then
            setProperty('CardcrapGraphic.alpha',1)
            setProperty('Cardcrap.alpha',0)
        end
    end
    cardPercent = percent
    updateCard()
end
function updateCard()
    if cardPercent < 1 then
        if cardPercent <= 0 then
            setProperty('CardcrapGraphic.alpha',0)
        else
            loadGraphic('CardcrapGraphic','cup/cardfull',97,math.floor(144*cardPercent))
            setProperty('CardcrapGraphic.y',getProperty('Cardcrap.y') + math.floor(144 * (1 -cardPercent)))
            setProperty('CardcrapGraphic.alpha',1)
        end
    end
end
function unfillCard()
    playAnim('Cardcrap','Used',false)
    cardPercent = -1
end
function dodgeT()
    doITD = true
end
function attackT()
    doITA = true
end
function rgbToHex(array)
	return getColorFromHex(string.format('%.2x%.2x%.2x', array[1], array[2], array[3]))
end
function updateBarColor()
    local color = ''
    color = rgbToHex(getProperty('dad.healthColorArray'))
    setProperty('timeBar.leftBar.color',color)
end
function createAlert()
    if enableWarning then
        local name = 'CupAlert'..alertCount
        if not downscroll then
            makeAnimatedLuaSprite(name,'cup/mozo',500,340)
        else
            makeAnimatedLuaSprite(name,'cup/gay',500,110)
        end
        addAnimationByPrefix(name,'Alert','YTJT instance 1',24,false)
        setObjectCamera(name,'hud')
        addLuaSprite(name,true)
        alertCount = alertCount + 1
        playSound('Cup/don',1,'cupAlert', 0.5)
    end
end
function detectGf(forBf)
    if not gfSection or gfSection and mustHitSection ~= forBf then
        return false
    end
    return true
end
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
function createCustomBar(image,offsetX,offsetY)
	offsetX = offsetX - 5
	offsetY = offsetY - 1.5
	runHaxeCode(
		[[
			game.healthBar.bg.loadGraphic(Paths.image(']]..image..[['));
			game.healthBar.bg.offset.set(]]..offsetX..','..offsetY..[[);
			game.healthBar.leftBar.scale.set(1,3);
			game.healthBar.rightBar.scale.set(1,3);
			return;
		]]
	)	
end
function hasSplash(direction,noteType)
	for splash = 1,#splashes do
		if splashes[splash][1] == noteType and splashes[splash][2] == direction and getProperty(splashes[splash][3]..'.animation.curAnim.finished') == true then
			playAnim(splashes[splash][3],'anim',true)
			setProperty(splashes[splash][3]..'.visible',true)
			setProperty(splashes[splash][3]..'.x',getPropertyFromGroup('playerStrums',direction,'x'))
			setProperty(splashes[splash][3]..'.y',getPropertyFromGroup('playerStrums',direction,'y'))
			return true
		end
	end
	return false
end
function spawnSplash(direction, noteType)
	if not hasSplash(direction,noteType) then
		local name = 'noteSplash'..#splashes
		local file = texture
		local scaleX = 1
		local scaleY = 1
		local anim = splashAnims[direction+1]
		
		local speed = 36
		local offsetX = 85
		local offsetY = 80
		local color
		if noteType == 'Parry Note' then
			file = 'noteSplashes/noteParry'
			offsetX = 210
			offsetY = 240
			scaleX = 0.8
			scaleY = 0.8
			anim = 'ParryFX'
		end
		makeAnimatedLuaSprite(name, file, getPropertyFromGroup('playerStrums', direction, 'x'), getPropertyFromGroup('playerStrums', direction, 'y'))
		scaleObject(name,scaleX,scaleY)
		addAnimationByPrefix(name, 'anim', anim, speed, false)
		setObjectCamera(name, 'hud')
		runHaxeCode(
			[[
				game.noteGroup.insert(game.noteGroup.members.indexOf(game.grpNoteSplashes),game.getLuaObject("]]..name..[["));
				return;
			]]
		)
		setProperty(name..'.offset.x', offsetX)
		setProperty(name..'.offset.y', offsetY)
		setProperty(name..'.alpha', 0.6)

		if color ~= nil then
			setProperty(name..'.color',color)
		end
		table.insert(splashes,{noteType,direction,name})
	end
end
function getCharX(character,isPlayer)
    local offset = 0
    if isPlayer == nil then
        isPlayer = (character == 'boyfriend')
    end
    if character == 'dad' then
        offset = getProperty('opponentCameraOffset[0]')

    elseif character == 'gf' then
        offset = offset - 150 + getProperty('girlfriendCameraOffset[0]')--- "-150" because gf is not a player, the game adds 150 at position x if the focused character is not a player

    elseif character == 'boyfriend' then
        offset = offset + getProperty('boyfriendCameraOffset[0]')

    end
    if isPlayer then
        offset = offset - 100 - getProperty(character..'.cameraPosition[0]')
    else
        offset = offset + 150  + getProperty(character..'.cameraPosition[0]')
    end
    return getMidpointX(character) + offset
end
function getCharY(character)
    local offset = 0
    if character == 'gf' then
        offset = getProperty('girlfriendCameraOffset[1]')
    else
        offset = -100
        if character == 'dad' then
            offset = offset + getProperty('opponentCameraOffset[1]')
        elseif character == 'boyfriend' then
            offset = offset + getProperty('boyfriendCameraOffset[1]')
        end
    end
    return getMidpointY(character) + getProperty(character..'.cameraPosition[1]') + offset
end
function onMoveCamera(focus)
    curTarget = focus
end
function detectCharacter()
    foundedBf = false
    foundedDad = false
    foundedGf = false
    for Characters = 0,#EnabledCharacters do
        if getProperty('boyfriend.curCharacter') == EnabledCharacters[Characters] then
            foundedBf = true
        end
        if getProperty('dad.curCharacter') == EnabledCharacters[Characters] then
            foundedDad = true
        end
        if getProperty('gf.curCharacter') == EnabledCharacters[Characters] then
            foundedGf = true
        end
    end
end
function gfAnim()
    if foundedGf and stringStartsWith(getProperty('gf.animation.curAnim.name'),'sing') then
        setProperty('gf.animation.curAnim.curFrame',2)
    end
end
function setChromShader(value)
    setShaderFloat('chromShader','rOffset',value)
    setShaderFloat('chromShader','bOffset',value * -1)
end
function shaderTween(shader,speed,easing)
    if enableShader then
        cancelTween('chromTweenShader')
        
        chromVal = shader
        makeLuaSprite('chromTween',nil,chromVal,0)
        if version >= '0.7' then
            startTween('chromTweenShader','chromTween',{x = defaultChrom},speed,{ease = easing,onUpdate = 'onChromTween'})
        else
            doTweenX('chromTweenShader','chromTween',0,speed,easing)
        end
    end
end
function onChromTween()
    setChromShader(getProperty('chromTween.x'))
end