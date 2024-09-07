local defx = 0
local defy = 0
local newy = 0
local newx = 0
local ang = 0
local s = 0

local modchart = true

-----------------------------------------------------
-- T H E  W H O L E   E N T I R E   M O D C H A R T--
-----------------------------------------------------
function onStepHit()
    if songName == 'power-of-terry' then
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
                myTween('player','x',0,0.9,'expoIn',500)
                myTween('player','y',0,0.9,'expoIn',300)

                zm = 0.2
                doTweenZoom("ss", "camHUD", zm, 0.9, "expoIn")
            elseif curStep == 68 then
                cancelTween('ss')
                setProperty('camHUD.angle', 0)
                setProperty('camHUD.zoom', 3)
                myTween('player','rx',0,0)

                myTween('player','y',0,0,'linear',(screenHeight*1.25))
                myTween('player','ry',-100,0.6)

                zm = 0.8
                doTweenZoom("ss", "camHUD", zm, 0.2, "expoIn")
            elseif curStep == 97 then
                noteSkin('BlackWhiteNote')
                myTween('player','x',0,0,'linear',screenWidth/1.5)
                myTween('player','x',0,0.4,'linear',screenWidth-screenWidth*1.4)
            elseif curStep == 105 then
                myTween('player','rx',0,0.15)
            elseif curStep == 108 then
                noteSkin('Default')
            elseif curStep == 114 then
                myTween('player','ry',0,0.2)

                zm = 1
                doTweenZoom("ssX", "camHUD", zm, 0.2, "expoIn")
            elseif curStep == 121 then
                myTween('player','x',0,0.2,'linear',screenWidth-screenWidth*1.4)
            elseif curStep == 125 then
                myTween('player','x',0,0,'linear',screenWidth/1.4)
                myTween('player','rx',0,0,'linear')
            elseif curStep == 131 then
                myTween('player','x',0,0.1,'linear',screenWidth-screenWidth/1.5)
                myTween('player','y',0,0.1,'linear',screenHeight/2)
                
                zm = 0.3
                doTweenZoom("ssX", 'camHUD', zm, 0.1, 'linear')
            elseif curStep == 134 then
                zm = 1
                doTweenZoom("ssX", 'camHUD', zm, 0.2, 'linear')
                myTween('player','rx',0,0,'linear')
                myTween('player','y',0,0,'linear',screenHeight/1.05)
            elseif curStep == 135 then
                myTween('player','ry',0,0.2,'linear')
            end
        end
    end
end

local s = 0
function onTweenCompleted(tag)
    if tag == 'ssX' then
        setProperty("defaultCamUIZoom",zm)
    end
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
function modccc(mc)
    modchart = mc
end

function onCreate()
    --Debugging for ModChart Help
    makeLuaText("step", "curStep: "..curStep, 0, 0.0, 0.0)
    addLuaText("step")
    setTextSize("step", 30)
    setObjectCamera("step", 'other')
    precacheImage("me/notes/BlackWhiteNote")
    precacheImage("me/notes/Default")
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

local repeatmAybe = false
--This changes the note skin duh
function noteSkin(name,mh)
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if mh == '' then
            mh = 0.1
        end
        setPropertyFromGroup('playerStrums', i, 'texture', 'me/notes/'..name);
        setPropertyFromGroup('notes', i, 'texture', 'me/notes/'..name); --Change texture
    end
    if name ~= 'Default' then
        runTimer("noteLoad",1)
        repeatmAybe = true
    else
        repeatmAybe = false
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'noteLoad' then
        setPropertyFromGroup('notes', i, 'texture', 'me/notes/'..name); --Change texture
        if repeatmAybe then
            runTimer('noteLoad',1)
        end
    end
end

function myTween(w,a,o,t,e,p)
    if t == 0 and e == '' or e == nil then
        e = 'linear'
    end
    if w == 'player' then
        if a == 'rx' and t == 0 then
            pS(true,false,'x',o)
        elseif a == 'ry' and t == 0 then
            pS(true,false,'y',o)
        elseif a == 'rx' and t > 0 then
            pS(true,true,'x',o,t,e)
        elseif a == 'ry' and t > 0 then
            pS(true,true,'y',o,t,e)
        elseif a == 'x' and t == 0 then
            pS(false,false,'x',o,t,e,p)
        elseif a == 'y' and t == 0 then
            pS(false,false,'y',o,t,e,p)
        elseif a == 'x' and t > 0 then
            pS(false,true,'x',o,t,e,p)
        elseif a == 'y' and t > 0 then
            pS(false,true,'y',o,t,e,p)
        end
    elseif w == 'opponent' then
        if a == 'rx' and t == 0 then
            oS(true,false,'x',o)
        elseif a == 'ry' and t == 0 then
            oS(true,false,'y',o)
        elseif a == 'rx' and t > 0 then
            oS(true,true,'x',o,t,e)
        elseif a == 'ry' and t > 0 then
            oS(true,true,'y',o,t,e)
        elseif a == 'x' and t == 0 then
            oS(false,false,'x',o,t,e,p)
        elseif a == 'y' and t == 0 then
            oS(false,false,'y',o,t,e,p)
        elseif a == 'x' and t > 0 then
            oS(false,true,'x',o,t,e,p)
        elseif a == 'y' and t > 0 then
            oS(false,true,'y',o,t,e,p)
        end
    end
end

--This manipulates playerStrums
function pS(r,tw,a,o,t,e,p)
    if r and not tw and a == 'x' then
        setPropertyFromGroup('playerStrums', 0, 'x',pX0+o)
        setPropertyFromGroup('playerStrums', 1, 'x',pX1+o)
        setPropertyFromGroup('playerStrums', 2, 'x',pX2+o)
        setPropertyFromGroup('playerStrums', 3, 'x',pX3+o)
    elseif r and not tw and a == 'y' then
        setPropertyFromGroup('playerStrums', 0, 'y',pY0+o)
        setPropertyFromGroup('playerStrums', 1, 'y',pY1+o)
        setPropertyFromGroup('playerStrums', 2, 'y',pY2+o)
        setPropertyFromGroup('playerStrums', 3, 'y',pY3+o)
    elseif not r and not tw and a == 'x' then
        setPropertyFromGroup('playerStrums', 0, 'x',pX0+p+o)
        setPropertyFromGroup('playerStrums', 1, 'x',pX1+p+o)
        setPropertyFromGroup('playerStrums', 2, 'x',pX2+p+o)
        setPropertyFromGroup('playerStrums', 3, 'x',pX3+p+o)
    elseif not r and not tw and a == 'y' then
        setPropertyFromGroup('playerStrums', 0, 'y',pY0+p+o)
        setPropertyFromGroup('playerStrums', 1, 'y',pY1+p+o)
        setPropertyFromGroup('playerStrums', 2, 'y',pY2+p+o)
        setPropertyFromGroup('playerStrums', 3, 'y',pY3+p+o)
    elseif r and tw and a == 'y' then
        noteTweenY('y0', 4, pY0+o, t, e)
        noteTweenY('y1', 5, pY1+o, t, e)
        noteTweenY('y2', 6, pY2+o, t, e)
        noteTweenY('y3', 7, pY3+o, t, e)
    elseif r and tw and a == 'x' then
        noteTweenX('x0', 4, pX0+o, t, e)
        noteTweenX('x1', 5, pX1+o, t, e)
        noteTweenX('x2', 6, pX2+o, t, e)
        noteTweenX('x3', 7, pX3+o, t, e)
    elseif not r and tw and a == 'y' then
        noteTweenY('y0', 4, pY0+p+o, t, e)
        noteTweenY('y1', 5, pY1+p+o, t, e)
        noteTweenY('y2', 6, pY2+p+o, t, e)
        noteTweenY('y3', 7, pY3+p+o, t, e)
    elseif not r and tw and a == 'x' then
        noteTweenX('x0', 4, pX0+p+o, t, e)
        noteTweenX('x1', 5, pX1+p+o, t, e)
        noteTweenX('x2', 6, pX2+p+o, t, e)
        noteTweenX('x3', 7, pX3+p+o, t, e)
    end
end

--This manipulates opponentStrums
function oS(r,tw,a,o,t,e,p)
    if r and not tw and a == 'x' then
        setPropertyFromGroup('opopnentStrums', 0, 'x',ox0+o)
        setPropertyFromGroup('opopnentStrums', 1, 'x',ox1+o)
        setPropertyFromGroup('opopnentStrums', 2, 'x',ox2+o)
        setPropertyFromGroup('opopnentStrums', 3, 'x',ox3+o)
    elseif r and not tw and a == 'y' then
        setPropertyFromGroup('opponentStrums', 0, 'y',oy0+o)
        setPropertyFromGroup('opponentStrums', 1, 'y',oy1+o)
        setPropertyFromGroup('opponentStrums', 2, 'y',oy2+o)
        setPropertyFromGroup('opponentStrums', 3, 'y',oy3+o)
    elseif not r and not tw and a == 'x' then
        setPropertyFromGroup('opponentStrums', 0, 'x',ox0+p+o)
        setPropertyFromGroup('opponentStrums', 1, 'x',ox1+p+o)
        setPropertyFromGroup('opponentStrums', 2, 'x',ox2+p+o)
        setPropertyFromGroup('opponentStrums', 3, 'x',ox3+p+o)
    elseif not r and not tw and a == 'y' then
        setPropertyFromGroup('opponentStrums', 0, 'y',oy0+p+o)
        setPropertyFromGroup('opponentStrums', 1, 'y',oy1+p+o)
        setPropertyFromGroup('opponentStrums', 2, 'y',oy2+p+o)
        setPropertyFromGroup('opponentStrums', 3, 'y',oy3+p+o)
    elseif r and tw and a == 'y' then
        noteTweenY('oy0', 0, oy0+o, t, e)
        noteTweenY('oy1', 1, oy1+o, t, e)
        noteTweenY('oy2', 2, oy2+o, t, e)
        noteTweenY('oy3', 3, oy3+o, t, e)
    elseif r and tw and a == 'x' then
        noteTweenX('ox0', 0, ox0+o, t, e)
        noteTweenX('ox1', 1, ox1+o, t, e)
        noteTweenX('ox2', 2, ox2+o, t, e)
        noteTweenX('ox3', 3, ox3+o, t, e)
    elseif not r and tw and a == 'y' then
        noteTweenY('oy0', 0, oy0+p+o, t, e)
        noteTweenY('oy1', 1, oy1+p+o, t, e)
        noteTweenY('oy2', 2, oy2+p+o, t, e)
        noteTweenY('oy3', 3, oy3+p+o, t, e)
    elseif not r and tw and a == 'x' then
        noteTweenX('ox0', 0, ox0+p+o, t, e)
        noteTweenX('ox1', 1, ox1+p+o, t, e)
        noteTweenX('ox2', 2, ox2+p+o, t, e)
        noteTweenX('ox3', 3, ox3+p+o, t, e)
    end
end