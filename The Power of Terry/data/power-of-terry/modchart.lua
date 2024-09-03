local defx = 0
local defy = 0
local newy = 0
local newx = 0
local ang = 0
local s = 0

local modchart = true

---------------------------------------------------------------------------------------------
--Go to bottom of script and read the comment I made to know how to use my custom function!--
---------------------------------------------------------------------------------------------

-----------------------------------------------------
-- T H E  W H O L E   E N T I R E   M O D C H A R T--
-----------------------------------------------------
function onStepHit()
    if modchart then
        setTextString("step", "curStep: "..curStep)
        if curStep > 1 and curStep < 4 then
            ox0 = getPropertyFromGroup('opponentStrums',0,'x')
            ox1 = getPropertyFromGroup('opponentStrums',1,'x')
            ox2 = getPropertyFromGroup('opponentStrums',2,'x')
            ox3 = getPropertyFromGroup('opponentStrums',3,'x')

            oy0 = getPropertyFromGroup('opponentStrums',0,'y')
            oy1 = getPropertyFromGroup('opponentStrums',1,'y')
            oy2 = getPropertyFromGroup('opponentStrums',2,'y')
            oy3 = getPropertyFromGroup('opponentStrums',3,'y')

            pX0 = getPropertyFromGroup('playerStrums', 0, 'x')
            pX1 = getPropertyFromGroup('playerStrums', 1, 'x')
            pX2 = getPropertyFromGroup('playerStrums', 2, 'x')
            pX3 = getPropertyFromGroup('playerStrums', 3, 'x')

            pY0 = getPropertyFromGroup('playerStrums', 0, 'y')
            pY1 = getPropertyFromGroup('playerStrums', 1, 'y')
            pY2 = getPropertyFromGroup('playerStrums', 2, 'y')
            pY3 = getPropertyFromGroup('playerStrums', 3, 'y')

            ang = getProperty('camHUD.angle')
        elseif curStep == 44 then 
            myTween('player','x',0.9,'expoIn',500)
            myTween('player','y',0.9,'expoIn',300)

            zm = 0.2
            doTweenZoom("ss", "camHUD", zm, 0.9, "expoIn")
        elseif curStep == 68 then
            cancelTween('ss')
            setProperty('camHUD.angle', 0)
            setProperty('camHUD.zoom', 3)
            myTween('player','rx',0)

            myTween('player','y',0,'linear',(screenHeight*1.25))
            myTween('player','ry',0.6)

            zm = 1
            doTweenZoom("ss", "camHUD", zm, 0.1, "expoIn")
        elseif curStep == 97 then
            noteSkin('BlackWhiteNote')
            myTween('player','x',0,'linear',screenWidth)
            myTween('player','x',0.2,'linear',ox0-(ox0-(ox0/2))-pX0)
        elseif curStep == 105 then
            myTween('player','rx',0.1)
        elseif curStep == 107 then
            noteSkin('Default')
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
function modchart(mc)
    modchart = mc
end

function onCreate()
    --Debugging for ModChart Help
    makeLuaText("step", "curStep: "..curStep, 0, 0.0, 0.0)
    addLuaText("step")
    setTextSize("step", 30)
    setObjectCamera("step", 'other')
end

function onUpdate()
    for i = 0,3 do        
        if getPropertyFromGroup('playerStrums', i, 'y') < screenHeight/2.15 then
            setPropertyFromGroup('playerStrums',i,'downScroll',false);
        end
        if getPropertyFromGroup('playerStrums', 0, 'y') > screenHeight/2.15 then
            setPropertyFromGroup('playerStrums',i,'downScroll',true);
        end
    end
end

---------------------------
--Custom Functions I made--
---------------------------

--This changes the note skin duh
function noteSkin(name,mh)
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if mh == '' then
            mh = 0.1
        end
        setPropertyFromGroup('playerStrums', i, 'texture', 'me/notes/'..name);
        setPropertyFromGroup('notes', i, 'texture', 'me/notes/'..name); --Change texture
        setPropertyFromGroup('unspawnNotes', i, 'texture', 'me/notes/'..name); --Change texture
        setPropertyFromGroup('notes', i, 'missHealth', mh); --Change amount of health to take when you miss
        setPropertyFromGroup('unspawnNotes', i, 'missHealth', mh); --Change amount of health to take when you miss
    end
end

function myTween(w,a,t,e,p)
    if t == 0 and e == '' or e == nil then
        e = 'linear'
    end
    if w == 'player' then
        if a == 'rx' and t == 0 then
            pS(true,false,'x')
        elseif a == 'ry' and t == 0 then
            pS(true,false,'y')
        elseif a == 'rx' and t > 0 then
            pS(true,true,'x',t,e,p)
        elseif a == 'ry' and t > 0 then
            pS(true,true,'y',t,e,p)
        elseif a == 'x' and t == 0 then
            pS(false,false,'x',t,e,p)
        elseif a == 'y' and t == 0 then
            pS(false,false,'y',t,e,p)
        elseif a == 'x' and t > 0 then
            pS(false,true,'x',t,e,p)
        elseif a == 'y' and t > 0 then
            pS(false,true,'y',t,e,p)
        end
    elseif w == 'opponent' then
        if a == 'rx' and t == 0 then
            oS(true,false,'x')
        elseif a == 'ry' and t == 0 then
            oS(true,false,'y')
        elseif a == 'rx' and t > 0 then
            oS(true,true,'x',t,e,p)
        elseif a == 'ry' and t > 0 then
            oS(true,true,'y',t,e,p)
        elseif a == 'x' and t == 0 then
            oS(false,false,'x',t,e,p)
        elseif a == 'y' and t == 0 then
            oS(false,false,'y',t,e,p)
        elseif a == 'x' and t > 0 then
            oS(false,true,'x',t,e,p)
        elseif a == 'y' and t > 0 then
            oS(false,true,'y',t,e,p)
        end
    end
end

--This manipulates playerStrums
function pS(r,tw,a,t,e,p)
    if r and not tw and a == 'x' then
        setPropertyFromGroup('playerStrums', 0, 'x',pX0)
        setPropertyFromGroup('playerStrums', 1, 'x',pX1)
        setPropertyFromGroup('playerStrums', 2, 'x',pX2)
        setPropertyFromGroup('playerStrums', 3, 'x',pX3)
    elseif r and not tw and a == 'y' then
        setPropertyFromGroup('playerStrums', 0, 'y',pY0)
        setPropertyFromGroup('playerStrums', 1, 'y',pY1)
        setPropertyFromGroup('playerStrums', 2, 'y',pY2)
        setPropertyFromGroup('playerStrums', 3, 'y',pY3)
    elseif not r and not tw and a == 'x' then
        setPropertyFromGroup('playerStrums', 0, 'x',pX0+p)
        setPropertyFromGroup('playerStrums', 1, 'x',pX1+p+112)
        setPropertyFromGroup('playerStrums', 2, 'x',pX2+p+224)
        setPropertyFromGroup('playerStrums', 3, 'x',pX3+p+336)
    elseif not r and not tw and a == 'y' then
        setPropertyFromGroup('playerStrums', 0, 'y',pY0+p)
        setPropertyFromGroup('playerStrums', 1, 'y',pY1+p)
        setPropertyFromGroup('playerStrums', 2, 'y',pY2+p)
        setPropertyFromGroup('playerStrums', 3, 'y',pY3+p)
    elseif r and tw and a == 'y' then
        noteTweenY('y0', 4, pY0, t, e)
        noteTweenY('y1', 5, pY1, t, e)
        noteTweenY('y2', 6, pY2, t, e)
        noteTweenY('y3', 7, pY3, t, e)
    elseif r and tw and a == 'x' then
        noteTweenX('x0', 4, pX0, t, e)
        noteTweenX('x1', 5, pX1, t, e)
        noteTweenX('x2', 6, pX2, t, e)
        noteTweenX('x3', 7, pX3, t, e)
    elseif not r and tw and a == 'y' then
        noteTweenY('y0', 4, pY0+p, t, e)
        noteTweenY('y1', 5, pY1+p, t, e)
        noteTweenY('y2', 6, pY2+p, t, e)
        noteTweenY('y3', 7, pY3+p, t, e)
    elseif not r and tw and a == 'x' then
        noteTweenX('x0', 4, pX0+p, t, e)
        noteTweenX('x1', 5, pX1+p, t, e)
        noteTweenX('x2', 6, pX2+p, t, e)
        noteTweenX('x3', 7, pX3+p, t, e)
    end
end

--This manipulates opponentStrums
function oS(r,tw,a,t,e,p)
    if r and not tw and a == 'x' then
        setPropertyFromGroup('opopnentStrums', 0, 'x',ox0)
        setPropertyFromGroup('opopnentStrums', 1, 'x',ox1)
        setPropertyFromGroup('opopnentStrums', 2, 'x',ox2)
        setPropertyFromGroup('opopnentStrums', 3, 'x',ox3)
    elseif r and not tw and a == 'y' then
        setPropertyFromGroup('opponentStrums', 0, 'y',oy0)
        setPropertyFromGroup('opponentStrums', 1, 'y',oy1)
        setPropertyFromGroup('opponentStrums', 2, 'y',oy2)
        setPropertyFromGroup('opponentStrums', 3, 'y',oy3)
    elseif not r and not tw and a == 'x' then
        setPropertyFromGroup('opponentStrums', 0, 'x',ox0+p)
        setPropertyFromGroup('opponentStrums', 1, 'x',ox1+p+112)
        setPropertyFromGroup('opponentStrums', 2, 'x',ox2+p+224)
        setPropertyFromGroup('opponentStrums', 3, 'x',ox3+p+336)
    elseif not r and not tw and a == 'y' then
        setPropertyFromGroup('opponentStrums', 0, 'y',oy0+p)
        setPropertyFromGroup('opponentStrums', 1, 'y',oy1+p)
        setPropertyFromGroup('opponentStrums', 2, 'y',oy2+p)
        setPropertyFromGroup('opponentStrums', 3, 'y',oy3+p)
    elseif r and tw and a == 'y' then
        noteTweenY('oy0', 0, oy0, t, e)
        noteTweenY('oy1', 1, oy1, t, e)
        noteTweenY('oy2', 2, oy2, t, e)
        noteTweenY('oy3', 3, oy3, t, e)
    elseif r and tw and a == 'x' then
        noteTweenX('ox0', 0, ox0, t, e)
        noteTweenX('ox1', 1, ox1, t, e)
        noteTweenX('ox2', 2, ox2, t, e)
        noteTweenX('ox3', 3, ox3, t, e)
    elseif not r and tw and a == 'y' then
        noteTweenY('oy0', 0, oy0+p, t, e)
        noteTweenY('oy1', 1, oy1+p, t, e)
        noteTweenY('oy2', 2, oy2+p, t, e)
        noteTweenY('oy3', 3, oy3+p, t, e)
    elseif not r and tw and a == 'x' then
        noteTweenX('ox0', 0, ox0+p, t, e)
        noteTweenX('ox1', 1, ox1+p, t, e)
        noteTweenX('ox2', 2, ox2+p, t, e)
        noteTweenX('ox3', 3, ox3+p, t, e)
    end
end