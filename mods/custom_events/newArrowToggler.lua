local ran = false
local ran1 = false
local xx1 = false
local xx2 = false
local xx3 = false
function onSongStart()
    dosx0 = defaultOpponentStrumX0
    dosx1 = defaultOpponentStrumX1
    dosx2 = defaultOpponentStrumX2
    dosx3 = defaultOpponentStrumX3
    dpsx0 = defaultPlayerStrumX0
    dpsx1 = defaultPlayerStrumX1
    dpsx2 = defaultPlayerStrumX2
    dpsx3 = defaultPlayerStrumX3
    dosy0 = defaultOpponentStrumY0
    dosy1 = defaultOpponentStrumY1
    dosy2 = defaultOpponentStrumY2
    dosy3 = defaultOpponentStrumY3
    dpsy0 = defaultPlayerStrumY0
    dpsy1 = defaultPlayerStrumY1
    dpsy2 = defaultPlayerStrumY2
    dpsy3 = defaultPlayerStrumY3
end
function onUpdate()
    if lk then
        songPos = getSongPosition()
        local currentBeat = (songPos/5000)*(curBpm/60)
        noteTweenY('defaultOpponentStrumY0', 0, defaultPlayerStrumY0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5);
        noteTweenY('defaultOpponentStrumY1', 1, defaultPlayerStrumY1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5);
        noteTweenY('defaultOpponentStrumY2', 2, defaultPlayerStrumY2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5);
        noteTweenY('defaultOpponentStrumY3', 3, defaultPlayerStrumY3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5);
        noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5);
        noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5);
        noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5);
        noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5);
        noteTweenX('defaultOpponentStrumX0', 0, defaultPlayerStrumX0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5);
        noteTweenX('defaultOpponentStrumX1', 1, defaultPlayerStrumX1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5);
        noteTweenX('defaultOpponentStrumX2', 2, defaultPlayerStrumX2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5);
        noteTweenX('defaultOpponentStrumX3', 3, defaultPlayerStrumX3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5);
        noteTweenX('defaultPlayerStrumX0', 4, defaultPlayerStrumX0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5);
        noteTweenX('defaultPlayerStrumX1', 5, defaultPlayerStrumX1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5);
        noteTweenX('defaultPlayerStrumX2', 6, defaultPlayerStrumX2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5);
        noteTweenX('defaultPlayerStrumX3', 7, defaultPlayerStrumX3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5);
    end
end
function onEvent(name, value1, value2)
    if name == "newArrowToggler" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            value1 = tonumber(value1);
            ALTdosx0 = defaultOpponentStrumX0
            ALTdosx1 = defaultOpponentStrumX1
            ALTdosx2 = defaultOpponentStrumX2
            ALTdosx3 = defaultOpponentStrumX3
            ALTdpsx0 = defaultPlayerStrumX0
            ALTdpsx1 = defaultPlayerStrumX1
            ALTdpsx2 = defaultPlayerStrumX2
            ALTdpsx3 = defaultPlayerStrumX3
            ALTdosy0 = defaultOpponentStrumY0
            ALTdosy1 = defaultOpponentStrumY1
            ALTdosy2 = defaultOpponentStrumY2
            ALTdosy3 = defaultOpponentStrumY3
            ALTdpsy0 = defaultPlayerStrumY0
            ALTdpsy1 = defaultPlayerStrumY1
            ALTdpsy2 = defaultPlayerStrumY2
            ALTdpsy3 = defaultPlayerStrumY3
            if value2 ~= "" then
                value2 = tonumber(value2);
                elseif value1 == 1 then
                    value2 = 0.15
                elseif value1 == 10 or value1 == 11 or value1 == 12 then
                    value2 = 0.1
                elseif value1 == 0 or value1 == 2 or value1 == 3 or value1 == 60 or value1 == 91 then
                    value2 = 0.2
            end
            --Change downscroll/upscroll
            if value1 == 1 then
                if ran then
                    for i=0,7 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                        noteTweenY("y1",0,50,value2,"cubeInOut");
                        noteTweenY("y2",1,50,value2,"cubeInOut");
                        noteTweenY("y3",2,50,value2,"cubeInOut");
                        noteTweenY("y4",3,50,value2,"cubeInOut");
                        noteTweenY("y5",4,50,value2,"cubeInOut");
                        noteTweenY("y6",5,50,value2,"cubeInOut");
                        noteTweenY("y7",6,50,value2,"cubeInOut");
                        noteTweenY("y8",7,50,value2,"cubeInOut");
                        defaultOpponentStrumY0 = dosy0
                        defaultOpponentStrumY1 = dosy1
                        defaultOpponentStrumY2 = dosy2
                        defaultOpponentStrumY3 = dosy3
                        defaultPlayerStrumY0 = dpsy0
                        defaultPlayerStrumY1 = dpsy1
                        defaultPlayerStrumY2 = dpsy2
                        defaultPlayerStrumY3 = dpsy3
                        doTweenY('hp', 'healthBar', 640, value2, 'cubeInOut');
                        doTweenY('hpI1', 'iconP1', 570, value2, 'cubeInOut');
                        doTweenY('hpI2', 'iconP2', 570, value2, 'cubeInOut');
                        ran = false
                    end
                else
                    for i=0,7 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                        noteTweenY("y1",0,550,value2,"cubeInOut");
                        noteTweenY("y2",1,550,value2,"cubeInOut");
                        noteTweenY("y3",2,550,value2,"cubeInOut");
                        noteTweenY("y4",3,550,value2,"cubeInOut");
                        noteTweenY("y5",4,550,value2,"cubeInOut");
                        noteTweenY("y6",5,550,value2,"cubeInOut");
                        noteTweenY("y7",6,550,value2,"cubeInOut");
                        noteTweenY("y8",7,550,value2,"cubeInOut");
                        defaultOpponentStrumY0 = 550
                        defaultOpponentStrumY1 = 550
                        defaultOpponentStrumY2 = 550
                        defaultOpponentStrumY3 = 550
                        defaultPlayerStrumY0 = 550
                        defaultPlayerStrumY1 = 550
                        defaultPlayerStrumY2 = 550
                        defaultPlayerStrumY3 = 550
                        doTweenY('hp', 'healthBar', 110, value2, 'cubeInOut');
                        doTweenY('hpI1', 'iconP1', 40, value2, 'cubeInOut');
                        doTweenY('hpI2', 'iconP2', 40, value2, 'cubeInOut');
                        ran = true
                    end
                end
            elseif value1 == 2 then --Swap Sides with Opponent
                if ran1 then
                    noteTweenX("x1",0,defaultOpponentStrumX0,value2,"cubeInOut");
                    noteTweenX("x2",1,defaultOpponentStrumX1,value2,"cubeInOut");
                    noteTweenX("x3",2,defaultOpponentStrumX2,value2,"cubeInOut");
                    noteTweenX("x4",3,defaultOpponentStrumX3,value2,"cubeInOut");
                    noteTweenX("x5",4,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x6",5,defaultPlayerStrumX1,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX2,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX3,value2,"cubeInOut");
                    defaultOpponentStrumX0 = dpsx0
                    defaultOpponentStrumX1 = dpsx1
                    defaultOpponentStrumX2 = dpsx2
                    defaultOpponentStrumX3 = dpsx3
                    defaultPlayerStrumX0 = dosx0
                    defaultPlayerStrumX1 = dosx1
                    defaultPlayerStrumX2 = dosx2
                    defaultPlayerStrumX3 = dosx3
                    ls = false
                    mdsc = false
                    ran1 = false
                else
                    noteTweenX("x1",0,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x2",1,defaultPlayerStrumX1,value2,"cubeInOut");
                    noteTweenX("x3",2,defaultPlayerStrumX2,value2,"cubeInOut");
                    noteTweenX("x4",3,defaultPlayerStrumX3,value2,"cubeInOut");
                    noteTweenX("x5",4,defaultOpponentStrumX0,value2,"cubeInOut");
                    noteTweenX("x6",5,defaultOpponentStrumX1,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultOpponentStrumX2,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultOpponentStrumX3,value2,"cubeInOut");
                    defaultOpponentStrumX0 = dosx0
                    defaultOpponentStrumX1 = dosx1
                    defaultOpponentStrumX2 = dosx2
                    defaultOpponentStrumX3 = dosx3
                    defaultPlayerStrumX0 = dpsx0
                    defaultPlayerStrumX1 = dpsx1
                    defaultPlayerStrumX2 = dpsx2
                    defaultPlayerStrumX3 = dpsx3

                    ls = true
                    mdsc = false
                    ran1 = true
                end
            elseif value1 == 3 then --Middle Scroll
                noteTweenAlpha("o1",0,0,0.5,"quartInOut");
                noteTweenAlpha("o2",1,0,0.5,"quartInOut");
                noteTweenAlpha("o3",2,0,0.5,"quartInOut");
                noteTweenAlpha("o4",3,0,0.5,"quartInOut");
                noteTweenX("x1",0,defaultOpponentStrumX0+75,value2,"cubeInOut");
                noteTweenX("x2",1,defaultOpponentStrumX1+75,value2,"cubeInOut");
                noteTweenX("x3",2,defaultPlayerStrumX2-79,value2,"cubeInOut");
                noteTweenX("x4",3,defaultPlayerStrumX3-79,value2,"cubeInOut");

                noteTweenX("x5",4,defaultPlayerStrumX0-323,value2,"cubeInOut");
                noteTweenX("x6",5,defaultPlayerStrumX1-323,value2,"cubeInOut");
                noteTweenX("x7",6,defaultPlayerStrumX2-323,value2,"cubeInOut");
                noteTweenX("x8",7,defaultPlayerStrumX3-323,value2,"cubeInOut");
                defaultPlayerStrumX0 = defaultPlayerStrumX0-323
                defaultPlayerStrumX1 = defaultPlayerStrumX1-323
                defaultPlayerStrumX2 = defaultPlayerStrumX2-323
                defaultPlayerStrumX3 = defaultPlayerStrumX3-323
                defaultOpponentStrumX0 = defaultOpponentStrumX0+75
                defaultOpponentStrumX1 = defaultOpponentStrumX1+75
                defaultOpponentStrumX2 = defaultPlayerStrumX2-79
                defaultOpponentStrumX3 = defaultPlayerStrumX3-79
                ls = false
                mdsc = true
            elseif value1 == 0 then
                    for i=0,7 do
                    setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                    setPropertyFromGroup('playerStrums',i,'downScroll',false);
                    noteTweenY("y1",0,dosy0,value2,"cubeInOut");
                    noteTweenY("y2",1,dosy1,value2,"cubeInOut");
                    noteTweenY("y3",2,dosy2,value2,"cubeInOut");
                    noteTweenY("y4",3,dosy3,value2,"cubeInOut");
                    noteTweenY("y5",4,dpsy0,value2,"cubeInOut");
                    noteTweenY("y6",5,dpsy1,value2,"cubeInOut");
                    noteTweenY("y7",6,dpsy2,value2,"cubeInOut");
                    noteTweenY("y8",7,dpsy3,value2,"cubeInOut");
                    doTweenY('hp', 'healthBar', 640, value2, 'cubeInOut');
                    doTweenY('hpI1', 'iconP1', 570, value2, 'cubeInOut');
                    doTweenY('hpI2', 'iconP2', 570, value2, 'cubeInOut');
                    noteTweenX("x1",0,defaultOpponentStrumX0,value2,"cubeInOut");
                    noteTweenX("x2",1,defaultOpponentStrumX1,value2,"cubeInOut");
                    noteTweenX("x3",2,defaultOpponentStrumX2,value2,"cubeInOut");
                    noteTweenX("x4",3,defaultOpponentStrumX3,value2,"cubeInOut");
                    noteTweenX("x5",4,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x6",5,defaultPlayerStrumX1,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX2,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX3,value2,"cubeInOut");
                    defaultPlayerStrumX0 = dpsx0
                    defaultPlayerStrumX1 = dpsx1
                    defaultPlayerStrumX2 = dpsx2
                    defaultPlayerStrumX3 = dpsx3
                    defaultOpponentStrumX0 = dosx0
                    defaultOpponentStrumX1 = dosx1
                    defaultOpponentStrumX2 = dosx2
                    defaultOpponentStrumX3 = dosx3
                    defaultOpponentStrumY0 = dosy0
                    defaultOpponentStrumY1 = dosy1
                    defaultOpponentStrumY2 = dosy2
                    defaultOpponentStrumY3 = dosy3
                    defaultPlayerStrumY0 = dpsy0
                    defaultPlayerStrumY1 = dpsy1
                    defaultPlayerStrumY2 = dpsy2
                    defaultPlayerStrumY3 = dpsy3

                    ls = false
                    mdsc = false
                    ran1 = false 
                    ran = false
                    end
            elseif value1 == 10 then
                if xx1 then
                    noteTweenX("x5",4,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX3,value2,"cubeInOut");
                    defaultPlayerStrumX0 = ALTdpsx0
                    defaultPlayerStrumX3 = ALTdpsx3
                    xx1 = false
                else
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,"cubeInOut");
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx1 = true
                end
            elseif value1 == 11 then
                if xx2 then
                    noteTweenX("x6",5,defaultPlayerStrumX1,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX2,value2,"cubeInOut");
                    defaultPlayerStrumX2 = ALTdpsx2
                    defaultPlayerStrumX1 = ALTdpsx1
                    xx2 = false
                else
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,"cubeInOut");
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX1 = ALTdpsx2
                   xx2 = true
                end
            elseif value1 == 12 then
                if xx3 then
                    noteTweenX("x5",4,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX3,value2,"cubeInOut");
                    noteTweenX("x6",5,defaultPlayerStrumX1,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX2,value2,"cubeInOut");
                    defaultPlayerStrumX0 = ALTdpsx0
                    defaultPlayerStrumX1 = ALTdpsx1
                    defaultPlayerStrumX2 = ALTdpsx2
                    defaultPlayerStrumX3 = ALTdpsx3
                    xx3 = false
                else
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,"cubeInOut");
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,"cubeInOut");
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,"cubeInOut");
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,"cubeInOut");
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX1 = ALTdpsx2
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx3 = true
                end
            elseif value1 == 0 then
                lk = false
                mdsc = false
                ran1 = false 
                defaultOpponentStrumX0 = dosx0
                defaultOpponentStrumX1 = dosx1
                defaultOpponentStrumX2 = dosx2
                defaultOpponentStrumX3 = dosx3
                defaultPlayerStrumX0 = dpsx0
                defaultPlayerStrumX1 = dpsx1
                defaultPlayerStrumX2 = dpsx2
                defaultPlayerStrumX3 = dpsx3
                defaultOpponentStrumY0 = dosy0
                defaultOpponentStrumY1 = dosy1
                defaultOpponentStrumY2 = dosy2
                defaultOpponentStrumY3 = dosy3
                defaultPlayerStrumY0 = dpsy0
                defaultPlayerStrumY1 = dpsy1
                defaultPlayerStrumY2 = dpsy2
                defaultPlayerStrumY3 = dpsy3
                cancelTween('x1');
                cancelTween('x2');
                cancelTween('x3');
                cancelTween('x4');
                cancelTween('x5');
                cancelTween('x6');
                cancelTween('x7');
                cancelTween('x8');
                cancelTween('y1');
                cancelTween('y2');
                cancelTween('y3');
                cancelTween('y4');
                cancelTween('y5');
                cancelTween('y6');
                cancelTween('y7');
                cancelTween('y8');
                cancelTween('hp');
                cancelTween('hpI1');
                cancelTween('hpI2');
                cancelTween('o1');
                cancelTween('o2');
                cancelTween('o3');
                cancelTween('o4');
                cancelTween('o5');
                cancelTween('o6');
                cancelTween('o7');
                cancelTween('o8');
                noteTweenX("x1",0,defaultOpponentStrumX0,value2,"cubeInOut");
                noteTweenX("x2",1,defaultOpponentStrumX1,value2,"cubeInOut");
                noteTweenX("x3",2,defaultOpponentStrumX2,value2,"cubeInOut");
                noteTweenX("x4",3,defaultOpponentStrumX3,value2,"cubeInOut");
                noteTweenX("x5",4,defaultPlayerStrumX0,value2,"cubeInOut");
                noteTweenX("x6",5,defaultPlayerStrumX1,value2,"cubeInOut");
                noteTweenX("x7",6,defaultPlayerStrumX2,value2,"cubeInOut");
                noteTweenX("x8",7,defaultPlayerStrumX3,value2,"cubeInOut");
                noteTweenY("y1",0,defaultOpponentStrumY0,value2,"cubeInOut");
                noteTweenY("y2",1,defaultOpponentStrumY1,value2,"cubeInOut");
                noteTweenY("y3",2,defaultOpponentStrumY2,value2,"cubeInOut");
                noteTweenY("y4",3,defaultOpponentStrumY3,value2,"cubeInOut");
                noteTweenY("y5",4,defaultPlayerStrumY0,value2,"cubeInOut");
                noteTweenY("y6",5,defaultPlayerStrumY1,value2,"cubeInOut");
                noteTweenY("y7",6,defaultPlayerStrumY2,value2,"cubeInOut");
                noteTweenY("y8",7,defaultPlayerStrumY3,value2,"cubeInOut");
                noteTweenAlpha("o1",0,1,value2,"quartInOut");
                noteTweenAlpha("o2",1,1,value2,"quartInOut");
                noteTweenAlpha("o3",2,1,value2,"quartInOut");
                noteTweenAlpha("o4",3,1,value2,"quartInOut");
                noteTweenAlpha("o5",4,1,value2,"quartInOut");
                noteTweenAlpha("o6",5,1,value2,"quartInOut");
                noteTweenAlpha("o7",6,1,value2,"quartInOut");
                noteTweenAlpha("o8",7,1,value2,"quartInOut");
                doTweenY('hp', 'healthBar', 640, value2, 'cubeInOut');
                doTweenY('hpI1', 'iconP1', 570, value2, 'cubeInOut');
                doTweenY('hpI2', 'iconP2', 570, value2, 'cubeInOut');
            elseif value1 == 90 then
                lk = true
            elseif value1 == 91 then
                lk = false
                cancelTween('defaultOpponentStrumX0');
                cancelTween('defaultOpponentStrumX1');
                cancelTween('defaultOpponentStrumX2');
                cancelTween('defaultOpponentStrumX3');
                cancelTween('defaultOpponentStrumY0');
                cancelTween('defaultOpponentStrumY1');
                cancelTween('defaultOpponentStrumY2');
                cancelTween('defaultOpponentStrumY3');
                cancelTween('defaultPlayerStrumX0');
                cancelTween('defaultPlayerStrumX1');
                cancelTween('defaultPlayerStrumX2');
                cancelTween('defaultPlayerStrumX3');
                cancelTween('defaultPlayerStrumY0');
                cancelTween('defaultPlayerStrumY1');
                cancelTween('defaultPlayerStrumY2');
                cancelTween('defaultPlayerStrumY3');
                cancelTween('hp');
                cancelTween('hpI1');
                cancelTween('hpI2');
                cancelTween('o1');
                cancelTween('o2');
                cancelTween('o3');
                cancelTween('o4');
                cancelTween('o5');
                cancelTween('o6');
                cancelTween('o7');
                cancelTween('o8');
                noteTweenX("defaultOpponentStrumX0",0,defaultOpponentStrumX0,value2,"cubeInOut");
                noteTweenX("defaultOpponentStrumX1",1,defaultOpponentStrumX1,value2,"cubeInOut");
                noteTweenX("defaultOpponentStrumX2",2,defaultOpponentStrumX2,value2,"cubeInOut");
                noteTweenX("defaultOpponentStrumX3",3,defaultOpponentStrumX3,value2,"cubeInOut");
                noteTweenX("defaultPlayerStrumX0",4,defaultPlayerStrumX0,value2,"cubeInOut");
                noteTweenX("defaultPlayerStrumX1",5,defaultPlayerStrumX1,value2,"cubeInOut");
                noteTweenX("defaultPlayerStrumX2",6,defaultPlayerStrumX2,value2,"cubeInOut");
                noteTweenX("defaultPlayerStrumX3",7,defaultPlayerStrumX3,value2,"cubeInOut");
                noteTweenY("defaultOpponentStrumY0",0,defaultOpponentStrumY0,value2,"cubeInOut");
                noteTweenY("defaultOpponentStrumY1",1,defaultOpponentStrumY1,value2,"cubeInOut");
                noteTweenY("defaultOpponentStrumY2",2,defaultOpponentStrumY2,value2,"cubeInOut");
                noteTweenY("defaultOpponentStrumY3",3,defaultOpponentStrumY3,value2,"cubeInOut");
                noteTweenY("defaultPlayerStrumY0",4,defaultPlayerStrumY0,value2,"cubeInOut");
                noteTweenY("defaultPlayerStrumY1",5,defaultPlayerStrumY1,value2,"cubeInOut");
                noteTweenY("defaultPlayerStrumY2",6,defaultPlayerStrumY2,value2,"cubeInOut");
                noteTweenY("defaultPlayerStrumY3",7,defaultPlayerStrumY3,value2,"cubeInOut");
            end
        end
    end
end