if not mechanicsAgain then
    close()
end
local dur = 0
function onBeatHit()
    if curBeat == 33 then
        moveValue = 50
        aBounce = true
    elseif curBeat == 60 then
        dur = 0.1
    elseif curBeat == 61 then
        dur = 0
        aBounce = false
        sv(false)
    elseif curBeat == 65 then
        moveValue = 200
        aBounce = true
    elseif curBeat == 92 then
        dur = 0.1
    elseif curBeat == 93 then
        dur = 0
        aBounce = false
        sv(false)
    elseif curBeat == 161 then
        moveValue = 200
        aBounce = true
    elseif curBeat == 189 then
        aBounce = false
        sv(false)
    elseif curBeat == 193 then
        aBounce = true
    elseif curBeat == 223 then
        aBounce = false
        sv(false)
    elseif curBeat == 225 then
        moveValue = 100
        aBounce = true
    elseif curBeat == 237 then
        aBounce = false
        sv(false)
    elseif curBeat == 241 then
        glitch = true
    elseif curBeat == 269 then
        glitch = false
        sv(false)
    elseif curBeat == 353 then
        moveValue = 50
        aBounce = true
    elseif curBeat == 385 then
        aBounce = false
        sv(false)
    elseif curBeat == 401 then
        aBounce = true
    elseif curBeat == 464 then
        aBounce = false
        sv(false)
    end
    if aBounce then
        sv(true)
        doTweenY('sv', 'camOne', -moveValue, 0.1, 'expoOut')
    end
    if glitch then
        sv(true)
        setProperty('camOne.y', -100)
        runTimer('g', 0.05)
    end
end
function onStepHit()
    if curStep == 250 then
        moveValue = 200
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 252 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 254 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 256 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 258 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 388 then
        moveValue = 250
        stepThing = true
    elseif curStep == 512 then
        stepThing = false
        sv(false)
    elseif curStep == 516 then
        stepThing = true
    elseif curStep == 628 then
        stepThing = false
        sv(false)
    elseif curStep == 634 then
        moveValue = 200
        sv(true)
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 636 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 638 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 640 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 642 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 762 then
        sv(true)
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 764 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 766 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 768 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 770 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1082 then
        moveValue = 200
        sv(true)
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1084 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1086 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1088 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1090 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1092 then
        moveValue = 150
        glitch2 = true
    elseif curStep == 1344 then
        glitch2 = false
    elseif curStep == 1540 then
        moveValue = 50
        sT2 = true
    elseif curStep == 1588 then
        sT2 = false
    elseif curStep == 1594 then
        moveValue = 200
        sv(true)
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1596 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1598 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1600 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1602 then
        setProperty('camOne.y', -moveValue)
        doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
    elseif curStep == 1860 then
        moveValue = 150
        glitch2 = true
    elseif curStep == 1972 then
        glitch2 = false
    end
    if stepThing and (curStep % 2 == 0) then
        if r then
            setProperty('camOne.y', moveValue)
            doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
            r = false
        else
            sv(true)
            setProperty('camOne.y', -moveValue)
            doTweenY('sv2', 'camOne', 0, 0.2, 'linear')
            r = true
        end
    end
    if glitch2 and (curStep % 2 == 0) then
        sv(true)
        setProperty('camOne.y', -100)
        runTimer('g', 0.15)
    end
    if sT2 and (curStep % 2 == 0) then
        sv(true)
        setProperty('camOne.y', moveValue)
        doTweenY('sv2', 'camOne', 0, 0.1, 'sineOut')
    end
end
function onTweenCompleted(t)
    if t == 'sv' then
        doTweenY('svb', 'camOne', 0, 0.28+dur, 'cubeIn')
    end
end
function onTimerCompleted(t)
    if t == 'g' then
        setProperty('camOne.y', 0)
    end
end
function sv(t)
    if t then
        runHaxeCode([[
            for (note in notes) {
                if (note.mustPress) {
                    note.cameras = [camOne];
                }
            }
        ]])
    else
        runHaxeCode([[
            for (note in notes) {
                if (note.mustPress) {
                    note.cameras = [camHUD];
                }
            }
        ]])
    end
end
function onCreatePost()
    setProperty('camOne'..'.flashSprite.scaleX', 2)
    setProperty('camOne'..'.flashSprite.scaleY', 2)
    setProperty('camOne.zoom', 0.5)
end