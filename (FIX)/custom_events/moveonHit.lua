local o = false
local k = false
function onEvent(name,value1, value2)
    if name == 'newArrowToggler' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value1 == 0 then
            ran1 = false
            mdsc = false
            ls = false
        elseif value1 == 3 then
            mdsc = true
        elseif value1 == 2 then
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
    if name == 'moveonHit' then
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
    end
end

local l = 0
local d = 0
local u = 0
local r = 0
function goodNoteHit(id, noteData, noteType, isSustainNote)
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
    if mdsc then

        if l == 1 then
            cancelTween('nl')
            cancelTween('rnl')
            setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0-323)
            noteTweenX("nl",4,defaultPlayerStrumX0-398,0.07,"bounceInOut");
            l = 0
            r = 0
        end
        if d == 1 then
            cancelTween('nd')
            cancelTween('rnd')
            setPropertyFromGroup('playerStrums', 1, 'y', defaultPlayerStrumY1)
            noteTweenY("nd",5,defaultPlayerStrumY1+70,0.07,"bounceInOut");
            d = 0
            u = 0
        end
        if u == 1 then
            cancelTween('nu')
            cancelTween('rnu')
            setPropertyFromGroup('playerStrums', 2, 'y', defaultPlayerStrumY2)
            noteTweenY("nu",6,defaultPlayerStrumY2-70,0.07,"bounceInOut");
            u = 0
            d = 0
        end
        if r == 1 then
            cancelTween('nr')
            cancelTween('rnr')
            setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3-323)
            noteTweenX("nr",7,defaultPlayerStrumX3-248,0.07,"bounceInOut");
            r = 0
            l = 0
        end
    end
    if ls then

        if l == 1 then
            cancelTween('nl')
            cancelTween('rnl')
            setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0)
            noteTweenX("nl",4,defaultOpponentStrumX0-75,0.07,"bounceInOut");
            l = 0
            r = 0
        end
        if d == 1 then
            cancelTween('nd')
            cancelTween('rnd')
            setPropertyFromGroup('playerStrums', 1, 'y', defaultPlayerStrumY1)
            noteTweenY("nd",5,defaultOpponentStrumY1+70,0.07,"bounceInOut");
            d = 0
            u = 0
        end
        if u == 1 then
            cancelTween('nu')
            cancelTween('rnu')
            setPropertyFromGroup('playerStrums', 2, 'y', defaultPlayerStrumY2)
            noteTweenY("nu",6,defaultOpponentStrumY2-70,0.07,"bounceInOut");
            u = 0
            d = 0
        end
        if r == 1 then
            cancelTween('nr')
            cancelTween('rnr')
            setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3)
            noteTweenX("nr",7,defaultOpponentStrumX3+75,0.07,"bounceInOut");
            r = 0
            l = 0
        end
    end
    if not ls and not mdsc then

        if l == 1 then
            cancelTween('nl')
            cancelTween('rnl')
            setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0)
            noteTweenX("nl",4,defaultPlayerStrumX0-75,0.07,"bounceInOut");
            l = 0
            r = 0
        end
        if d == 1 then
            cancelTween('nd')
            cancelTween('rnd')
            setPropertyFromGroup('playerStrums', 1, 'y', defaultPlayerStrumY1)
            noteTweenY("nd",5,defaultPlayerStrumY1+70,0.07,"bounceInOut");
            d = 0
            u = 0
        end
        if u == 1 then
            cancelTween('nu')
            cancelTween('rnu')
            setPropertyFromGroup('playerStrums', 2, 'y', defaultPlayerStrumY2)
            noteTweenY("nu",6,defaultPlayerStrumY2-70,0.07,"bounceInOut");
            u = 0
            d = 0
        end
        if r == 1 then
            cancelTween('nr')
            cancelTween('rnr')
            setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3)
            noteTweenX("nr",7,defaultPlayerStrumX3+75,0.07,"bounceInOut");
            r = 0
            l = 0
        end
    end
end

function onTweenCompleted(tag)
    if mdsc then

        if tag == 'nl' then
            noteTweenX('rnl',4,defaultPlayerStrumX0-323,0.07,"bounceInOut");
        end
        if tag == 'nd' then
            noteTweenY("rnd",5,defaultPlayerStrumY1,0.07,"bounceInOut");
        end
        if tag == 'nu' then
            noteTweenY("rnu",6,defaultPlayerStrumY2,0.07,"bounceInOut");
        end
        if tag == 'nr' then
            noteTweenX('rnr',7,defaultPlayerStrumX3-323,0.07,"bounceInOut");
        end
    end
    if ls then

        if tag == 'nl' then
            noteTweenX("rnl",4,defaultOpponentStrumX0,0.07,"bounceInOut");
        end
        if tag == 'nd' then
            noteTweenX("rnd",5,defaultOpponentStrumX1,0.07,"bounceInOut");
        end
        if tag == 'nu' then
            noteTweenX("rnu",6,defaultOpponentStrumX2,0.07,"bounceInOut");
        end
        if tag == 'nr' then
            noteTweenX("rnr",7,defaultOpponentStrumX3,0.07,"bounceInOut");
        end
    end
    if not ls and not mdsc then

        if tag == 'nl' then
            noteTweenX("rnl",4,defaultPlayerStrumX0,0.07,"bounceInOut");
        end
        if tag == 'nd' then
            noteTweenY("rnd",5,defaultPlayerStrumY1,0.07,"bounceInOut");
        end
        if tag == 'nu' then
            noteTweenY("rnu",6,defaultPlayerStrumY2,0.07,"bounceInOut");
        end
        if tag == 'nr' then
            noteTweenX("rnr",7,defaultPlayerStrumX3,0.07,"bounceInOut");
        end
    end
end

--noteTweenX('x5',4,defaultPlayerStrumX0,0.07,"bounceInOut");
--noteTweenX('x6',5,defaultPlayerStrumX1,0.07,"bounceInOut");
--noteTweenX('x7',6,defaultPlayerStrumX2,0.07,"bounceInOut");
--noteTweenX('x8',7,defaultPlayerStrumX3,0.07,"bounceInOut");

--noteTweenX("x5",4,defaultPlayerStrumX0-323,0.07,"bounceInOut");
--noteTweenX("x6",5,defaultPlayerStrumX1-323,0.07,"bounceInOut");
--noteTweenX("x7",6,defaultPlayerStrumX2-323,0.07,"bounceInOut");
--noteTweenX("x8",7,defaultPlayerStrumX3-323,0.07,"bounceInOut");

--noteTweenY('y5',4,defaultPlayerStrumY0,0.07,"bounceInOut");
--noteTweenY('y6',5,defaultPlayerStrumY1,0.07,"bounceInOut");
--noteTweenY('y7',6,defaultPlayerStrumY2,0.07,"bounceInOut");
--noteTweenY('y8',7,defaultPlayerStrumY3,0.07,"bounceInOut");

--noteTweenX("x1",0,defaultPlayerStrumX0,0.07,"bounceInOut");
--noteTweenX("x2",1,defaultPlayerStrumX1,0.07,"bounceInOut");
--noteTweenX("x3",2,defaultPlayerStrumX2,0.07,"bounceInOut");
--noteTweenX("x4",3,defaultPlayerStrumX3,0.07,"bounceInOut");
--noteTweenX("x5",4,defaultOpponentStrumX0,0.07,"bounceInOut");
--noteTweenX("x6",5,defaultOpponentStrumX1,0.07,"bounceInOut");
--noteTweenX("x7",6,defaultOpponentStrumX2,0.07,"bounceInOut");
--noteTweenX("x8",7,defaultOpponentStrumX3,0.07,"bounceInOut");