local playerHealth = 6
function onCreate()
    setProperty('skipCountdown', true)
    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-full-invis');
    setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'nothing');
    setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'nothing');
    setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'nothing');
end

function onSongStart()
    local hpPositionx = 350
    local hpPositiony = 600
    makeLuaSprite('b6', 'me/popup/blue6', hpPositionx, hpPositiony)
    setObjectCamera('b6', 'hud')
    addLuaSprite('b6')

    makeLuaSprite('b5', 'me/popup/blue5', hpPositionx, hpPositiony)
    setObjectCamera('b5', 'hud')
    setProperty('b5.alpha', 0)
    addLuaSprite('b5')
    makeLuaSprite('b4', 'me/popup/blue4', hpPositionx, hpPositiony)
    setObjectCamera('b4', 'hud')
    setProperty('b4.alpha', 0)
    addLuaSprite('b4')
    makeLuaSprite('b3', 'me/popup/blue3', hpPositionx, hpPositiony)
    setObjectCamera('b3', 'hud')
    setProperty('b3.alpha', 0)
    addLuaSprite('b3')
    makeLuaSprite('b2', 'me/popup/blue2', hpPositionx, hpPositiony)
    setObjectCamera('b2', 'hud')
    setProperty('b2.alpha', 0)
    addLuaSprite('b2')
    makeLuaSprite('b1', 'me/popup/blue1', hpPositionx, hpPositiony)
    setObjectCamera('b1', 'hud')
    setProperty('b1.alpha', 0)
    addLuaSprite('b1')

    scaleObject('b6', 0.5, 0.5)
    scaleObject('b5', 0.5, 0.5)
    scaleObject('b4', 0.5, 0.5)
    scaleObject('b3', 0.5, 0.5)
    scaleObject('b2', 0.5, 0.5)
    scaleObject('b1', 0.5, 0.5)

    makeLuaText('deadText', 'You are Dead', 610, 0, 50)
    setTextSize('deadText', 32)
    setTextColor('deadText', 'ff0000')
    setObjectCamera('deadText', 'other')
    setProperty('deadText.alpha', 0)
    addLuaText('deadText')

    setProperty('healthGain', 0)
    setProperty('healthLoss', 0)
    setHealth(100/50)
    setProperty('camZoomingMult', 0)
end

local invincible = false

function noteMiss()
    if not invincible then
        playerHealth = playerHealth-1
        setProperty('b'..playerHealth..'.alpha', 1)
        setProperty('b'..(playerHealth+1)..'.alpha', 0)
        setHealth(100/50)
        if playerHealth == 0 and not practice then
            setHealth(0)
        elseif playerHealth == 0 and practice then
            setProperty('deadText.alpha', 1)
            close()
        end
        invincible = true
        runTimer('invincible', 2)
    end
end

function onUpdate()
    if curBeat < 1 then
        setProperty('timeBar.visible', false)
        setProperty('timeBarBG.visible', false)
        setProperty('timeTxt.visible', false)
        setProperty('iconP1.alpha', 0);
        setProperty('iconP2.alpha', 0);
        setProperty('healthBar.alpha', 0);
        setProperty('healthBarBG.alpha', 0);
        setProperty('timeBar.alpha', 0);
        setProperty('timeTxt.alpha', 0);
    end
end

local enterPressCount = 0
local waited = false
function onGameOverStart()
    makeLuaSprite('itsoverScreen', 'me/popup/itsover', 0, 0)
    setObjectCamera('itsoverScreen', 'other')
    setProperty('itsoverScreen.alpha', 0)
    addLuaSprite('itsoverScreen', true)
    startVideo('gameover/itsovervid', false)
    runTimer('itsoverLoop', runHaxeCode('game.videoCutscene.videoSprite.bitmap.length/1000;'))
    runTimer('wait', 4)
end

function onGameOverConfirmPre(retry)
    if enterPressCount == 3 then
        if waited then
            waited = false
            cancelTimer('itsoverLoop')
            stopSound('itsOLoop')
            startVideo('gameover/itsnotovervid', false, true)
            setProperty('itsoverScreen.alpha', 0)
            setObjectCamera('videoCutscene', 'game')
            enterPressCount = 4
            runTimer('restartSong1', 1)
            runTimer('wait', 0.3)
            return Function_Stop
        end
    elseif enterPressCount == 2 then
        if waited then
            waited = false
            cancelTimer('itsoverLoop')
            stopSound('itsOLoop')
            startVideo('gameover/noto3', false)
            setProperty('itsoverScreen.alpha', 0)
            enterPressCount = 3
            runTimer('itsoverLoop', runHaxeCode('game.videoCutscene.videoSprite.bitmap.length/1000;'))
            runTimer('wait', 0.3)
            return Function_Stop
        end
    elseif enterPressCount == 1 then
        if waited then
            waited = false
            cancelTimer('itsoverLoop')
            stopSound('itsOLoop')
            startVideo('gameover/noto2', false)
            setProperty('itsoverScreen.alpha', 0)
            enterPressCount = 2
            runTimer('itsoverLoop', runHaxeCode('game.videoCutscene.videoSprite.bitmap.length/1000;'))
            runTimer('wait', 0.3)
            return Function_Stop
        end
    elseif enterPressCount == 0 then
        if waited then
            waited = false
            cancelTimer('itsoverLoop')
            stopSound('itsOLoop')
            startVideo('gameover/noto1', false)
            setProperty('itsoverScreen.alpha', 0)
            enterPressCount = 1
            runTimer('itsoverLoop', runHaxeCode('game.videoCutscene.videoSprite.bitmap.length/1000;'))
            runTimer('wait', 0.3)
            return Function_Stop
        end
    end
    return Function_Stop
end

function onTimerCompleted(tag)
    if tag == 'wait' then
        waited = true
    end
    if tag == 'invincible' then
        invincible = false
    end
    if tag == 'restartSong1' then
        runTimer('restartSong2', (runHaxeCode('game.videoCutscene.videoSprite.bitmap.length/1000;')-3.6))
    end
    if tag == 'restartSong2' then
        restartSong()
    end
    if tag == 'itsoverLoop' then
        setProperty('itsoverScreen.alpha', 1)
        stopSound('itsOLoop')
        playSound('gameover/itsoverloopsound', 2, 'itsOLoop', true)
    end
end