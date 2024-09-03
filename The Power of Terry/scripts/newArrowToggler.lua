function onCreatePost()
    script = false
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        dscrolm = getPropertyFromClass('ClientPrefs', 'downScroll')
        mscrolm = getPropertyFromClass('ClientPrefs', 'middleScroll')
        dscrol = getPropertyFromClass('ClientPrefs', 'downScroll')
        mscrol = getPropertyFromClass('ClientPrefs', 'middleScroll')
        script = true

    --if downscroll then
    --    noteTweenY('0', 0, 50,0.001)
    --    noteTweenY('1', 1, 50,0.001)
    --    noteTweenY('2', 2, 50,0.001)
    --    noteTweenY('3', 3, 50,0.001)
    --    noteTweenY('4', 4, 50,0.001)
    --    noteTweenY('5', 5, 50,0.001)
    --    noteTweenY('6', 6, 50,0.001)
    --    noteTweenY('7', 7, 50,0.001)
    --    doTweenY('hp', 'healthBar', 640, 0.001, curtwm);
    --    doTweenY('hpI1', 'iconP1', 570, 0.001, curtwm);
    --    doTweenY('hpI2', 'iconP2', 570, 0.001, curtwm);
    --    doTweenY('scoretxt', 'scoreTxt', 680, 0.001, curtwm);
    --    setProperty('timeTxt.y', 19);
    --    setProperty('timeBar.y', 31.25);
    --    setProperty('timeBarBG.y', 27.25);
    --    setPropertyFromClass('ClientPrefs','downScroll', false)
    --end
    --for i=0,3 do
    --setPropertyFromGroup('opponentStrums',i,'downScroll',false);
    --setPropertyFromGroup('playerStrums',i,'downScroll',false);
    --end
    --if middlescroll then
    --    noteTweenX('defaultOpponentStrumX0', 0, defaultPlayerStrumX0-323, 0.001);
    --    noteTweenX('defaultOpponentStrumX1', 1, defaultPlayerStrumX1-323, 0.001);
    --    noteTweenX('defaultOpponentStrumX2', 2, defaultPlayerStrumX2-323, 0.001);
    --    noteTweenX('defaultOpponentStrumX3', 3, defaultPlayerStrumX3-323, 0.001);
--
    --    noteTweenX('defaultPlayerStrumX0', 4, defaultPlayerStrumX0+323, 0.001);
    --    noteTweenX('defaultPlayerStrumX1', 5, defaultPlayerStrumX1+323, 0.001);
    --    noteTweenX('defaultPlayerStrumX2', 6, defaultPlayerStrumX2+323, 0.001);
    --    noteTweenX('defaultPlayerStrumX3', 7, defaultPlayerStrumX3+323, 0.001);
    --    setPropertyFromClass('ClientPrefs','midScroll', false)
    --end
    end
end

function onSongStart()
   --defaultOpponentStrumX0 = defaultPlayerStrumX0-323
   --defaultOpponentStrumX1 = defaultPlayerStrumX1-323
   --defaultOpponentStrumX2 = defaultPlayerStrumX2-323
   --defaultOpponentStrumX3 = defaultPlayerStrumX3-323
   --defaultPlayerStrumX0 = defaultPlayerStrumX0+323
   --defaultPlayerStrumX1 = defaultPlayerStrumX1+323
   --defaultPlayerStrumX2 = defaultPlayerStrumX2+323
   --defaultPlayerStrumX3 = defaultPlayerStrumX3+323
   --defaultOpponentStrumY0 = 50
   --defaultOpponentStrumY1 = 50
   --defaultOpponentStrumY2 = 50
   --defaultOpponentStrumY3 = 50
   --defaultPlayerStrumY0 = 50
   --defaultPlayerStrumY1 = 50
   --defaultPlayerStrumY2 = 50
   --defaultPlayerStrumY3 = 50
   setPropertyFromGroup('opponentStrums',0,'x',167);
   setPropertyFromGroup('opponentStrums',1,'x',279);
   setPropertyFromGroup('opponentStrums',2,'x',237);
   setPropertyFromGroup('opponentStrums',3,'x',349);
   setPropertyFromGroup('playerStrums',0,'x',409);
   setPropertyFromGroup('playerStrums',1,'x',521);
   setPropertyFromGroup('playerStrums',2,'x',633);
   setPropertyFromGroup('playerStrums',3,'x',745);

   for i = 0,3 do
    setPropertyFromGroup('opponentStrums',i,'downScroll',false);
    setPropertyFromGroup('playerStrums',i,'downScroll',false);
    setPropertyFromGroup('playerStrums',i,'y',50);
    setPropertyFromGroup('opponentStrums',i,'y',50);
   end
    defaultPlayerStrumX0 = 409
    defaultPlayerStrumX1 = 521
    defaultPlayerStrumX2 = 633
    defaultPlayerStrumX3 = 745
    defaultPlayerStrumY0 = 50
    defaultPlayerStrumY1 = 50
    defaultPlayerStrumY2 = 50
    defaultPlayerStrumY3 = 50
    defaultOpponentStrumX0 = 167
    defaultOpponentStrumX1 = 279
    defaultOpponentStrumX2 = 237
    defaultOpponentStrumX3 = 349
    defaultOpponentStrumY0 = 50
    defaultOpponentStrumY1 = 50
    defaultOpponentStrumY2 = 50
    defaultOpponentStrumY3 = 50
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
    curtwm = curtwm
    ls = false
    mdsc = true
    ran2 = true
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
        if script then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
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
            if songName == 'Octagon of Destiny' then
                curtwm = 'linear'
            else
                curtwm = 'cubeInOut'
            end
            if value2 == "" or value2 == nil or value2 == null then
                if value1 == 1 then
                    value2 = 0.15
                elseif value1 == 10 or value1 == 11 or value1 == 12 then
                    value2 = 0.1
                elseif value1 == 0 or value1 == 2 or value1 == 3 or value1 == 60 or value1 == 91 then
                    value2 = 0.2
                end
            end
            --Change downscroll/upscroll
            if value1 == 1 then
                if ran or dscrol then
                    for i=0,7 do
                        if value2 > 0.012 then
                            noteTweenY("y1",0,50,value2,curtwm);
                            noteTweenY("y2",1,50,value2,curtwm);
                            noteTweenY("y3",2,50,value2,curtwm);
                            noteTweenY("y4",3,50,value2,curtwm);
                            noteTweenY("y5",4,50,value2,curtwm);
                            noteTweenY("y6",5,50,value2,curtwm);
                            noteTweenY("y7",6,50,value2,curtwm);
                            noteTweenY("y8",7,50,value2,curtwm);
                            setProperty('healthBar.y',640);
                            setProperty('healthBarBG.y',840);
                            setProperty('iconP1.y',570);
                            setProperty('iconP2.y',570);
                            doTweenY('scoretxt', 'scoreTxt', 680, value2, curtwm);
                        elseif value2 < 0.012 or value2 == 0 then
                            setPropertyFromGroup('opponentStrums',i,'y',50);
                            setPropertyFromGroup('playerStrums',i,'y',50);
                            setProperty('healthBar.y',640);
                            setProperty('healthBarBG.y',840);
                            setProperty('iconP1.y',570);
                            setProperty('iconP2.y',570);
                            setProperty('scoretxt.y', 680);
                        end
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                        setProperty('timeTxt.y', 19);
                        setProperty('timeBar.y', 31.25);
                        setProperty('timeBarBG.y', 27.25);
                        defaultOpponentStrumY0 = dosy0
                        defaultOpponentStrumY1 = dosy1
                        defaultOpponentStrumY2 = dosy2
                        defaultOpponentStrumY3 = dosy3
                        defaultPlayerStrumY0 = dpsy0
                        defaultPlayerStrumY1 = dpsy1
                        defaultPlayerStrumY2 = dpsy2
                        defaultPlayerStrumY3 = dpsy3
                        ran = false
                        dscrol = false
                    end
                else
                    for i=0,7 do
                        if value2 > 0.012 then
                            noteTweenY("y1",0,550,value2,curtwm);
                            noteTweenY("y2",1,550,value2,curtwm);
                            noteTweenY("y3",2,550,value2,curtwm);
                            noteTweenY("y4",3,550,value2,curtwm);
                            noteTweenY("y5",4,550,value2,curtwm);
                            noteTweenY("y6",5,550,value2,curtwm);
                            noteTweenY("y7",6,550,value2,curtwm);
                            noteTweenY("y8",7,550,value2,curtwm);
                            setProperty('healthBar.y',80);
                            setProperty('healthBarBG.y',80);
                            setProperty('iconP1.y',10);
                            setProperty('iconP2.y',10);
                            doTweenY('scoretxt', 'scoreTxt',120, 0.001, curtwm);
                        elseif value2 < 0.012 or value2 == 0 then
                            setPropertyFromGroup('opponentStrums',i,'y',550);
                            setPropertyFromGroup('playerStrums',i,'y',550);
                            setProperty('healthBar.y',80);
                            setProperty('healthBarBG.y',80);
                            setProperty('iconP1.y',10);
                            setProperty('iconP2.y',10);
                            setProperty('scoretxt.y', 120);
                        end
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                        setProperty('timeTxt.y', 680);
                        setProperty('timeBar.y', 692.25);
                        setProperty('timeBarBG.y', 688.25);
                        defaultOpponentStrumY0 = 550
                        defaultOpponentStrumY1 = 550
                        defaultOpponentStrumY2 = 550
                        defaultOpponentStrumY3 = 550
                        defaultPlayerStrumY0 = 550
                        defaultPlayerStrumY1 = 550
                        defaultPlayerStrumY2 = 550
                        defaultPlayerStrumY3 = 550
                        ran = true
                        dscrol = true
                    end
                end
            elseif value1 == 111 then
                if ranm or dscrol then
                    for i=0,7 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                        ranm = false
                        dscrol = false
                    end
                else
                    for i=0,7 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                        ranm = true
                        dscrol = true
                    end
                end
            elseif value1 == 2 then --Swap Sides with Opponent
                if ran1 then
                    if value2 > 0.012 then
                        noteTweenX("x1",0,defaultOpponentStrumX0,value2,curtwm);
                        noteTweenX("x2",1,defaultOpponentStrumX1,value2,curtwm);
                        noteTweenX("x3",2,defaultOpponentStrumX2,value2,curtwm);
                        noteTweenX("x4",3,defaultOpponentStrumX3,value2,curtwm);
                        noteTweenX("x5",4,defaultPlayerStrumX0,value2,curtwm);
                        noteTweenX("x6",5,defaultPlayerStrumX1,value2,curtwm);
                        noteTweenX("x7",6,defaultPlayerStrumX2,value2,curtwm);
                        noteTweenX("x8",7,defaultPlayerStrumX3,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'x',defaultOpponentStrumX0);
                        setPropertyFromGroup('opponentStrums',1,'x',defaultOpponentStrumX1);
                        setPropertyFromGroup('opponentStrums',2,'x',defaultOpponentStrumX2);
                        setPropertyFromGroup('opponentStrums',3,'x',defaultOpponentStrumX3);
                        setPropertyFromGroup('playerStrums',0,'x',defaultPlayerStrumX0);
                        setPropertyFromGroup('playerStrums',1,'x',defaultPlayerStrumX1);
                        setPropertyFromGroup('playerStrums',2,'x',defaultPlayerStrumX2);
                        setPropertyFromGroup('playerStrums',3,'x',defaultPlayerStrumX3);
                    end
                    defaultOpponentStrumX0 = dosx0
                    defaultOpponentStrumX1 = dosx1
                    defaultOpponentStrumX2 = dosx2
                    defaultOpponentStrumX3 = dosx3
                    defaultPlayerStrumX0 = dpsx0
                    defaultPlayerStrumX1 = dpsx1
                    defaultPlayerStrumX2 = dpsx2
                    defaultPlayerStrumX3 = dpsx3
                    ls = false
                    mdsc = false
                    ran1 = false
                else
                    if value2 > 0.012 then
                        noteTweenX("x1",0,defaultPlayerStrumX0,value2,curtwm);
                        noteTweenX("x2",1,defaultPlayerStrumX1,value2,curtwm);
                        noteTweenX("x3",2,defaultPlayerStrumX2,value2,curtwm);
                        noteTweenX("x4",3,defaultPlayerStrumX3,value2,curtwm);
                        noteTweenX("x5",4,defaultOpponentStrumX0,value2,curtwm);
                        noteTweenX("x6",5,defaultOpponentStrumX1,value2,curtwm);
                        noteTweenX("x7",6,defaultOpponentStrumX2,value2,curtwm);
                        noteTweenX("x8",7,defaultOpponentStrumX3,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'x',defaultPlayerStrumX0);
                        setPropertyFromGroup('opponentStrums',1,'x',defaultPlayerStrumX1);
                        setPropertyFromGroup('opponentStrums',2,'x',defaultPlayerStrumX2);
                        setPropertyFromGroup('opponentStrums',3,'x',defaultPlayerStrumX3);
                        setPropertyFromGroup('playerStrums',0,'x',defaultOpponentStrumX0);
                        setPropertyFromGroup('playerStrums',1,'x',defaultOpponentStrumX1);
                        setPropertyFromGroup('playerStrums',2,'x',defaultOpponentStrumX2);
                        setPropertyFromGroup('playerStrums',3,'x',defaultOpponentStrumX3);
                    end
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
                if ran2 then
                    if value2 > 0.012 then
                        noteTweenX("x1",0,dosx0,value2,curtwm);
                        noteTweenX("x2",1,dosx1,value2,curtwm);
                        noteTweenX("x3",2,dosx2,value2,curtwm);
                        noteTweenX("x4",3,dosx3,value2,curtwm);

                        noteTweenX("x5",4,dpsx0,value2,curtwm);
                        noteTweenX("x6",5,dpsx1,value2,curtwm);
                        noteTweenX("x7",6,dpsx2,value2,curtwm);
                        noteTweenX("x8",7,dpsx3,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'x',dosx0);
                        setPropertyFromGroup('opponentStrums',1,'x',dosx1);
                        setPropertyFromGroup('opponentStrums',2,'x',dosx2);
                        setPropertyFromGroup('opponentStrums',3,'x',dosx3);
                        setPropertyFromGroup('playerStrums',0,'x',dpsx0);
                        setPropertyFromGroup('playerStrums',1,'x',dpsx1);
                        setPropertyFromGroup('playerStrums',2,'x',dpsx2);
                        setPropertyFromGroup('playerStrums',3,'x',dpsx3);
                    end
                    noteTweenAlpha("o1",0,1,0.5,"quartInOut");
                    noteTweenAlpha("o2",1,1,0.5,"quartInOut");
                    noteTweenAlpha("o3",2,1,0.5,"quartInOut");
                    noteTweenAlpha("o4",3,1,0.5,"quartInOut");
                    defaultPlayerStrumX0 = dpsx0
                    defaultPlayerStrumX1 = dpsx1
                    defaultPlayerStrumX2 = dpsx2
                    defaultPlayerStrumX3 = dpsx3
                    defaultOpponentStrumX0 = dosx0
                    defaultOpponentStrumX1 = dosx1
                    defaultOpponentStrumX2 = dosx2
                    defaultOpponentStrumX3 = dosx3
                    ls = false
                    mdsc = false
                    ran2 = false
                else
                    if value2 > 0.012 then
                        noteTweenX("x1",0,dosx0+75,value2,curtwm);
                        noteTweenX("x2",1,dosx1+75,value2,curtwm);
                        noteTweenX("x3",2,dpsx2-79,value2,curtwm);
                        noteTweenX("x4",3,dpsx3-79,value2,curtwm);

                        noteTweenX("x5",4,dpsx0-323,value2,curtwm);
                        noteTweenX("x6",5,dpsx1-323,value2,curtwm);
                        noteTweenX("x7",6,dpsx2-323,value2,curtwm);
                        noteTweenX("x8",7,dpsx3-323,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'x',dosx0+75);
                        setPropertyFromGroup('opponentStrums',1,'x',dosx1+75);
                        setPropertyFromGroup('opponentStrums',2,'x',dpsx2-79);
                        setPropertyFromGroup('opponentStrums',3,'x',dpsx3-79);
                        setPropertyFromGroup('playerStrums',0,'x',dpsx0-323);
                        setPropertyFromGroup('playerStrums',1,'x',dpsx1-323);
                        setPropertyFromGroup('playerStrums',2,'x',dpsx2-323);
                        setPropertyFromGroup('playerStrums',3,'x',dpsx3-323);
                    end
                    noteTweenAlpha("o1",0,0,0.5,"quartInOut");
                    noteTweenAlpha("o2",1,0,0.5,"quartInOut");
                    noteTweenAlpha("o3",2,0,0.5,"quartInOut");
                    noteTweenAlpha("o4",3,0,0.5,"quartInOut");
                    defaultPlayerStrumX0 = dpsx0-323
                    defaultPlayerStrumX1 = dpsx1-323
                    defaultPlayerStrumX2 = dpsx2-323
                    defaultPlayerStrumX3 = dpsx3-323
                    defaultOpponentStrumX0 = dosx0+75
                    defaultOpponentStrumX1 = dosx1+75
                    defaultOpponentStrumX2 = dpsx2-79
                    defaultOpponentStrumX3 = dpsx3-79
                    ls = false
                    mdsc = true
                    ran2 = true
                end
            elseif value1 == 33 then --Middle Scroll
                    if value2 > 0.012 then
                        noteTweenAlpha("o1",0,0,0.5,"quartInOut");
                        noteTweenAlpha("o2",1,0,0.5,"quartInOut");
                        noteTweenAlpha("o3",2,0,0.5,"quartInOut");
                        noteTweenAlpha("o4",3,0,0.5,"quartInOut");
                        noteTweenX("x1",0,dosx0+75,value2,curtwm);
                        noteTweenX("x2",1,dosx1+75,value2,curtwm);
                        noteTweenX("x3",2,dpsx2-79,value2,curtwm);
                        noteTweenX("x4",3,dpsx3-79,value2,curtwm);

                        noteTweenX("x5",4,dpsx0-323,value2,curtwm);
                        noteTweenX("x6",5,dpsx1-323,value2,curtwm);
                        noteTweenX("x7",6,dpsx2-323,value2,curtwm);
                        noteTweenX("x8",7,dpsx3-323,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'x',dosx0+75);
                        setPropertyFromGroup('opponentStrums',1,'x',dosx1+75);
                        setPropertyFromGroup('opponentStrums',2,'x',dpsx2-79);
                        setPropertyFromGroup('opponentStrums',3,'x',dpsx3-79);
                        setPropertyFromGroup('playerStrums',0,'x',dpsx0-323);
                        setPropertyFromGroup('playerStrums',1,'x',dpsx1-323);
                        setPropertyFromGroup('playerStrums',2,'x',dpsx2-323);
                        setPropertyFromGroup('playerStrums',3,'x',dpsx3-323);
                        setPropertyFromGroup('opponentStrums',0,'alpha',0);
                        setPropertyFromGroup('opponentStrums',1,'alpha',0);
                        setPropertyFromGroup('opponentStrums',2,'alpha',0);
                        setPropertyFromGroup('opponentStrums',3,'alpha',0);
                    end
                    defaultPlayerStrumX0 = dpsx0-323
                    defaultPlayerStrumX1 = dpsx1-323
                    defaultPlayerStrumX2 = dpsx2-323
                    defaultPlayerStrumX3 = dpsx3-323
                    defaultOpponentStrumX0 = dosx0+75
                    defaultOpponentStrumX1 = dosx1+75
                    defaultOpponentStrumX2 = dpsx2-79
                    defaultOpponentStrumX3 = dpsx3-79
                    ls = false
                    mdsc = true
                    ran2 = true
            elseif value1 == 0 then
                for i=0,7 do
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
                    if dscrolm == false then
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                        doTweenY('hp', 'healthBar', 640, value2, curtwm);
                        doTweenY('hpI1', 'iconP1', 570, value2, curtwm);
                        doTweenY('hpI2', 'iconP2', 570, value2, curtwm);
                        doTweenY('scoretxt', 'scoreTxt', 680, 0.001, curtwm);
                        setProperty('timeTxt.y', 19);
                        setProperty('timeBar.y', 31.25);
                        setProperty('timeBarBG.y', 27.25);
                    else
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                        doTweenY('hp', 'healthBar', 80, value2, curtwm);
                        doTweenY('hpI1', 'iconP1', 10, value2, curtwm);
                        doTweenY('hpI2', 'iconP2', 10, value2, curtwm);
                        doTweenY('scoretxt', 'scoreTxt',120, value2, curtwm);
                        setProperty('timeTxt.y', 680);
                        setProperty('timeBar.y', 692.25);
                        setProperty('timeBarBG.y', 688.25);
                    end
                    if value2 > 0.012 then
                        noteTweenY("y1",0,dosy0,value2,curtwm);
                        noteTweenY("y2",1,dosy1,value2,curtwm);
                        noteTweenY("y3",2,dosy2,value2,curtwm);
                        noteTweenY("y4",3,dosy3,value2,curtwm);
                        noteTweenY("y5",4,dpsy0,value2,curtwm);
                        noteTweenY("y6",5,dpsy1,value2,curtwm);
                        noteTweenY("y7",6,dpsy2,value2,curtwm);
                        noteTweenY("y8",7,dpsy3,value2,curtwm);
                        noteTweenX("x1",0,defaultOpponentStrumX0,value2,curtwm);
                        noteTweenX("x2",1,defaultOpponentStrumX1,value2,curtwm);
                        noteTweenX("x3",2,defaultOpponentStrumX2,value2,curtwm);
                        noteTweenX("x4",3,defaultOpponentStrumX3,value2,curtwm);
                        noteTweenX("x5",4,defaultPlayerStrumX0,value2,curtwm);
                        noteTweenX("x6",5,defaultPlayerStrumX1,value2,curtwm);
                        noteTweenX("x7",6,defaultPlayerStrumX2,value2,curtwm);
                        noteTweenX("x8",7,defaultPlayerStrumX3,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'y',dosy0);
                        setPropertyFromGroup('opponentStrums',1,'y',dosy1);
                        setPropertyFromGroup('opponentStrums',2,'y',dosy2);
                        setPropertyFromGroup('opponentStrums',3,'y',dosy3);
                        setPropertyFromGroup('playerStrums',0,'y',dpsy0);
                        setPropertyFromGroup('playerStrums',1,'y',dpsy1);
                        setPropertyFromGroup('playerStrums',2,'y',dpsy2);
                        setPropertyFromGroup('playerStrums',3,'y',dpsy3);
                        setPropertyFromGroup('opponentStrums',0,'x',defaultOpponentStrumX0);
                        setPropertyFromGroup('opponentStrums',1,'x',defaultOpponentStrumX1);
                        setPropertyFromGroup('opponentStrums',2,'x',defaultOpponentStrumX2);
                        setPropertyFromGroup('opponentStrums',3,'x',defaultOpponentStrumX3);
                        setPropertyFromGroup('playerStrums',0,'x',defaultPlayerStrumX0);
                        setPropertyFromGroup('playerStrums',1,'x',defaultPlayerStrumX1);
                        setPropertyFromGroup('playerStrums',2,'x',defaultPlayerStrumX2);
                        setPropertyFromGroup('playerStrums',3,'x',defaultPlayerStrumX3);
                        setProperty('healthBar.y',640);
                        setProperty('healthBarBG.y',840);
                        setProperty('iconP1.y',570);
                        setProperty('iconP2.y',570);
                        setProperty('scoretxt.y', 120);
                    end
                    ls = false
                    mdsc = false
                    ran1 = false 
                    ran2 = false
                    ran = false
                    dscrol = false
                    mscrol = false
                    ranm = false
                end
            elseif value1 == 10 then
                if xx1 then
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx1 = false
                else
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx1 = true
                end
            elseif value1 == 11 then
                if xx2 then
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX1 = ALTdpsx2
                    xx2 = false
                else
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX1 = ALTdpsx2
                   xx2 = true
                end
            elseif value1 == 12 then
                if xx3 then
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,curtwm);
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX1 = ALTdpsx2
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx3 = false
                else
                    noteTweenX("x5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("x8",7,defaultPlayerStrumX0,value2,curtwm);
                    noteTweenX("x6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("x7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX1 = ALTdpsx2
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx3 = true
                end
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
                noteTweenX("defaultOpponentStrumX0",0,defaultOpponentStrumX0,value2,curtwm);
                noteTweenX("defaultOpponentStrumX1",1,defaultOpponentStrumX1,value2,curtwm);
                noteTweenX("defaultOpponentStrumX2",2,defaultOpponentStrumX2,value2,curtwm);
                noteTweenX("defaultOpponentStrumX3",3,defaultOpponentStrumX3,value2,curtwm);
                noteTweenX("defaultPlayerStrumX0",4,defaultPlayerStrumX0,value2,curtwm);
                noteTweenX("defaultPlayerStrumX1",5,defaultPlayerStrumX1,value2,curtwm);
                noteTweenX("defaultPlayerStrumX2",6,defaultPlayerStrumX2,value2,curtwm);
                noteTweenX("defaultPlayerStrumX3",7,defaultPlayerStrumX3,value2,curtwm);
                noteTweenY("defaultOpponentStrumY0",0,defaultOpponentStrumY0,value2,curtwm);
                noteTweenY("defaultOpponentStrumY1",1,defaultOpponentStrumY1,value2,curtwm);
                noteTweenY("defaultOpponentStrumY2",2,defaultOpponentStrumY2,value2,curtwm);
                noteTweenY("defaultOpponentStrumY3",3,defaultOpponentStrumY3,value2,curtwm);
                noteTweenY("defaultPlayerStrumY0",4,defaultPlayerStrumY0,value2,curtwm);
                noteTweenY("defaultPlayerStrumY1",5,defaultPlayerStrumY1,value2,curtwm);
                noteTweenY("defaultPlayerStrumY2",6,defaultPlayerStrumY2,value2,curtwm);
                noteTweenY("defaultPlayerStrumY3",7,defaultPlayerStrumY3,value2,curtwm);
            end
        end
    end
end