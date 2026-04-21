function onBeatHit()
    if curBeat >= 0 and curBeat < 8 then
        pY1 = getPropertyFromGroup('playerStrums', 0, 'y')
        pY2 = getPropertyFromGroup('playerStrums', 1, 'y')
        pY3 = getPropertyFromGroup('playerStrums', 2, 'y')
        pY4 = getPropertyFromGroup('playerStrums', 3, 'y')
        pX1 = getPropertyFromGroup('playerStrums', 0, 'x')
        pX2 = getPropertyFromGroup('playerStrums', 1, 'x')
        pX3 = getPropertyFromGroup('playerStrums', 2, 'x')
        pX4 = getPropertyFromGroup('playerStrums', 3, 'x')
    end
    if curBeat == 208 then
        z = true
    elseif curBeat == 265 then
        z = false
    elseif curBeat == 308 then
        z = true
    elseif curBeat == 369 then
        z = false
    elseif curBeat == 372 then
        z = true
    elseif curBeat == 405 then
        z = false
    elseif curBeat == 420 then
        z = true
    elseif curBeat == 429 then
        z = false
    elseif curBeat == 644 then
        z = true
    elseif curBeat == 704 then
        z = false
    elseif curBeat == 708 then
        z = true
    elseif curBeat == 764 then
        z = false
    end

    if z then
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', 1.3)
        end
    end
end

function onStepHit()
    if curStep == 1088 then
        noteTweenY('bounce', 4, pY1+50, 0.3, 'backOut')
        noteTweenY('bounce1', 5, pY2+50, 0.3, 'backOut')
    elseif curStep == 1092 then
        noteTweenY('bounce', 6, pY3+50, 0.3, 'backOut')
        noteTweenY('bounce1', 7, pY4+50, 0.3, 'backOut')
    elseif curStep == 1096 then
        noteTweenX('bounce', 4, pX1-50, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2-25, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3+25, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4+50, 0.13, 'backOut')
    elseif curStep == 1098 then
        noteTweenX('bounce', 4, pX1-100, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2-50, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3+50, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4+100, 0.13, 'backOut')
    elseif curStep == 1100 then
        noteTweenX('bounce', 4, pX1, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4, 0.13, 'backOut')
        noteTweenY('1bounce', 4, pY1, 0.13, 'backOut')
        noteTweenY('1bounce1', 5, pY2, 0.13, 'backOut')
        noteTweenY('1bounce2', 6, pY3, 0.13, 'backOut')
        noteTweenY('1bounce3', 7, pY4, 0.13, 'backOut')
    elseif curStep == 2303 then
        noteTweenY('bounce', 4, pY1+50, 0.3, 'backOut')
        noteTweenY('bounce1', 5, pY2+50, 0.3, 'backOut')
    elseif curStep == 2307 then
        noteTweenY('bounce', 6, pY3+50, 0.3, 'backOut')
        noteTweenY('bounce1', 7, pY4+50, 0.3, 'backOut')
    elseif curStep == 2311 then
        noteTweenX('bounce', 4, pX1-50, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2-25, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3+25, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4+50, 0.13, 'backOut')
    elseif curStep == 2313 then
        noteTweenX('bounce', 4, pX1-100, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2-50, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3+50, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4+100, 0.13, 'backOut')
    elseif curStep == 2315 then
        noteTweenX('bounce', 4, pX1, 0.13, 'backOut')
        noteTweenX('bounce1', 5, pX2, 0.13, 'backOut')
        noteTweenX('bounce2', 6, pX3, 0.13, 'backOut')
        noteTweenX('bounce3', 7, pX4, 0.13, 'backOut')
        noteTweenY('1bounce', 4, pY1, 0.13, 'backOut')
        noteTweenY('1bounce1', 5, pY2, 0.13, 'backOut')
        noteTweenY('1bounce2', 6, pY3, 0.13, 'backOut')
        noteTweenY('1bounce3', 7, pY4, 0.13, 'backOut')
    end
end

function onUpdate()
    if z then
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'scale.x', mathlerp(getPropertyFromGroup('strumLineNotes', i, 'scale.x'), 0.7, 0.06))
        end
    end
end

function mathlerp(from,to,i)return from+(to-from)*i end