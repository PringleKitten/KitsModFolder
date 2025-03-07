local rr = false
local goBack = false
function onSongStart()
    A4 = getPropertyFromGroup('playerStrums', 0, 'angle')
    A5 = getPropertyFromGroup('playerStrums', 1, 'angle')
    A6 = getPropertyFromGroup('playerStrums', 2, 'angle')
    A7 = getPropertyFromGroup('playerStrums', 3, 'angle')
    X4 = getPropertyFromGroup('playerStrums', 0, 'x')
    X5 = getPropertyFromGroup('playerStrums', 1, 'x')
    X6 = getPropertyFromGroup('playerStrums', 2, 'x')
    X7 = getPropertyFromGroup('playerStrums', 3, 'x')
    Y4 = getPropertyFromGroup('playerStrums', 0, 'y')
    Y5 = getPropertyFromGroup('playerStrums', 1, 'y')
    Y6 = getPropertyFromGroup('playerStrums', 2, 'y')
    Y7 = getPropertyFromGroup('playerStrums', 3, 'y')

    --setPropertyFromGroup('opponentStrums', 1, 'x', getPropertyFromClass("opponentStrums", 0, 'x')+0.5)
    --setPropertyFromGroup('opponentStrums', 2, 'x', getPropertyFromClass("opponentStrums", 1, 'x')+0.5)
    --setPropertyFromGroup('opponentStrums', 3, 'x', getPropertyFromClass("opponentStrums", 2, 'x')+0.5)
end

function tweenXN(d)
    noteTweenX("4x", 4, X4+xx4, d, "circOut")
    noteTweenX("5x", 5, X5+xx5, d, "circOut")
    noteTweenX("6x", 6, X6+xx6, d, "circOut")
    noteTweenX("7x", 7, X7+xx7, d, "circOut")
end

function tweenYN(d)
    noteTweenY("4y", 4, Y4+yy4, d, "circOut")
    noteTweenY("5y", 5, Y5+yy5, d, "circOut")
    noteTweenY("6y", 6, Y6+yy6, d, "circOut")
    noteTweenY("7y", 7, Y7+yy7, d, "circOut")
end

function tweenYNF(d)
    noteTweenY("4yF", 4, Y4+yy4, d, "circOut")
    noteTweenY("5yF", 5, Y5+yy5, d, "circOut")
    noteTweenY("6yF", 6, Y6+yy6, d, "circOut")
    noteTweenY("7yF", 7, Y7+yy7, d, "circOut")
end

function tweenAN(d)
    noteTweenAngle("4a", 4, A4+aa4, d, "circOut")
    noteTweenAngle("5a", 5, A5+aa5, d, "circOut")
    noteTweenAngle("6a", 6, A6+aa6, d, "circOut")
    noteTweenAngle("7a", 7, A7+aa7, d, "circOut")
end

function onBeatHit()
    if curBeat == 6 then
        setProperty("camZoomsBg", true)
        setProperty("camZoomsHud", true)
    elseif curBeat == 68 then
        xx4 = -500
        xx5 = -500
        xx6 = -500
        xx7 = -500
        aa4 = -360
        aa5 = -360
        aa6 = -360
        aa7 = -360
        tweenAN(0.2)
        tweenXN(0.2)
    elseif curBeat == 78 then
        xx4 = 500
        xx5 = 500
        xx6 = 500
        xx7 = 500
        aa4 = 360
        aa5 = 360
        aa6 = 360
        aa7 = 360
        tweenAN(0.7)
        tweenXN(0.5)
    elseif curBeat == 90 then
        setPropertyFromGroup('playerStrums', 0, 'angle', 0)
        setPropertyFromGroup('playerStrums', 1, 'angle', 0)
        setPropertyFromGroup('playerStrums', 2, 'angle', 0)
        setPropertyFromGroup('playerStrums', 3, 'angle', 0)
    elseif curBeat >= 100 and curBeat <= 127 then
        if rr3 then
            yy7 = -40
            yy6 = 40
            yy5 = 0
            rr4 = true
            rr3 = false
            rr = false
        elseif rr2 then
            yy6 = -40
            yy5 = 40
            yy4 = 0
            rr2 = false
            rr3 = true
        elseif rr1 then
            if rr4 then
                yy7 = 0
                rr4 = false
            end
            yy4 = 40
            yy5 = -40
            rr1 = false
            rr2 = true
        elseif not rr then
            if rr4 then
                yy7 = 40
                yy6 = 0
            else
                yy5 = 0
                yy6 = 0
                yy7 = 0
            end
            yy4 = -40
            rr = true
            rr1 = true
        end
        tweenYN(0.2)
    elseif curBeat == 128 then
        yy4 = 0
        yy5 = 0
        yy6 = 0
        yy7 = 40
        tweenYN(0.2)
    elseif curBeat >= 132 and curBeat < 196 then
        goBack = true
        yy4 = -20
        yy5 = -20
        yy6 = -20
        yy7 = -20
        tweenYN(0.15)
        if not rr then
            xx4 = -40
            xx5 = -20
            xx6 = 20
            xx7 = 40
            aa4 = -45
            aa5 = -45
            aa6 = 45
            aa7 = 45
            if aa then
                aa4 = 45
                aa5 = 45
                aa6 = -45
                aa7 = -45
            end
            tweenAN(0.2)
            tweenXN(0.2)
            rr = true
        elseif rr then
            xx4 = -xx4
            xx5 = -xx5
            xx6 = -xx6
            xx7 = -xx7
            aa4 = -aa4
            aa5 = -aa5
            aa6 = -aa6
            aa7 = -aa7
            if aa then
                aa = false
            else
                aa = true
            end
            tweenAN(0.2)
            tweenXN(0.2)
            rr = false
        end
    elseif curBeat >= 196 then
        goBack = false
    end
end

function onTweenCompleted(tag, vars)
    if tag == '4a' then
        A4 = getPropertyFromGroup('playerStrums', 0, 'angle')
        A5 = getPropertyFromGroup('playerStrums', 1, 'angle')
        A6 = getPropertyFromGroup('playerStrums', 2, 'angle')
        A7 = getPropertyFromGroup('playerStrums', 3, 'angle')
    end
    if tag == '4x' then
        X4 = getPropertyFromGroup('playerStrums', 0, 'x')
        X5 = getPropertyFromGroup('playerStrums', 1, 'x')
        X6 = getPropertyFromGroup('playerStrums', 2, 'x')
        X7 = getPropertyFromGroup('playerStrums', 3, 'x')
    end
    if tag == '4y' then
        Y4 = getPropertyFromGroup('playerStrums', 0, 'y')
        Y5 = getPropertyFromGroup('playerStrums', 1, 'y')
        Y6 = getPropertyFromGroup('playerStrums', 2, 'y')
        Y7 = getPropertyFromGroup('playerStrums', 3, 'y')
        if goBack then
            yy4 = -yy4
            yy5 = -yy5
            yy6 = -yy6
            yy7 = -yy7
            tweenYNF(0.15)
        end
    end
    if tag == '4yF' then
        Y4 = getPropertyFromGroup('playerStrums', 0, 'y')
        Y5 = getPropertyFromGroup('playerStrums', 1, 'y')
        Y6 = getPropertyFromGroup('playerStrums', 2, 'y')
        Y7 = getPropertyFromGroup('playerStrums', 3, 'y')
    end
end