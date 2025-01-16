function onEvent(name,value1, value2)
    if name == 'ArrowToggling' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value2 == 0 or value2 == 60 then
            ran1 = false
            mdsc = false
        elseif value2 == 3 then
            mdsc = true
        elseif value2 == 1 then
            if ran1 then
                ls = false
                mdsc = false
                ran1 = false
            else
                ls = true
                mdsc = false
                ran1 = true
            end
        end
    end
    if name == 'movehudonhit' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 1 then
            k = true
            o = false
        elseif value1 == 2 then
            o = true
            k = false
        elseif value1 == 3 then
            o = true
            k = true
        elseif value1 == 0 then
            k = false
            o = false
        end
        st = value2
    end
end

local l = 0
local d = 0
local u = 0
local r = 0
function goodNoteHit(noteData)
    if k then
        if noteData == 0 then
            l = 1
        end
        if noteData == 1 then
            d = 1
        end
        if noteData == 2 then
            u = 1
        end
        if noteData == 3 then
            r = 1
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if o then
    if noteData == 0 then
        l = 1
    end
    if noteData == 1 then
        d = 1
    end
    if noteData == 2 then
        u = 1
    end
    if noteData == 3 then
        r = 1
    end
end
end

function onUpdate()
    if l == 1 then
        cancelTween('hr')
        cancelTween('hl')
        cancelTween('rhl')
        cancelTween('rhr')
        setProperty('camHUD.x', 0)
        doTweenX('hl', 'camHUD', -st, 0.08, 'bounceOut')
        l = 0
        r = 0
    end
    if d == 1 then
        cancelTween('hu')
        cancelTween('hd')
        cancelTween('rhd')
        cancelTween('rhu')
        setProperty('camHUD.y', 0)
        doTweenY('hd', 'camHUD', st, 0.08, 'bounceOut')
        d = 0
        u = 0
    end
    if u == 1 then
        cancelTween('hu')
        cancelTween('hd')
        cancelTween('rhu')
        cancelTween('rhd')
        setProperty('camHUD.y', 0)
        doTweenY('hu', 'camHUD', -st, 0.08, 'bounceOut')
        u = 0
        d = 0
    end
    if r == 1 then
        cancelTween('hl')
        cancelTween('hr')
        cancelTween('rhr')
        cancelTween('rhl')
        setProperty('camHUD.x', 0)
        doTweenX('hr', 'camHUD', st, 0.08, 'bounceOut')
        r = 0
        l = 0
    end
end

function onTweenCompleted(tag)
    if tag == 'hl' then
        cancelTween('hr')
        cancelTween('hl')
        cancelTween('rhl')
        cancelTween('rhr')
        doTweenX('rhl', 'camHUD', 0, 0.08, 'bounceOut')
    end
    if tag == 'hd' then
        cancelTween('hu')
        cancelTween('hd')
        cancelTween('rhd')
        cancelTween('rhu')
        doTweenY('rhd', 'camHUD', 0, 0.08, 'bounceOut')
    end
    if tag == 'hu' then
        cancelTween('hu')
        cancelTween('hd')
        cancelTween('rhu')
        cancelTween('rhd')
        doTweenY('rhu', 'camHUD', 0, 0.08, 'bounceOut')
    end
    if tag == 'hr' then
        cancelTween('hl')
        cancelTween('hr')
        cancelTween('rhr')
        cancelTween('rhl')
        doTweenX('rhr', 'camHUD', 0, 0.08, 'bounceOut')
    end
end