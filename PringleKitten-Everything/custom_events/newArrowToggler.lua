
local script = false
function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
        dscrolm = getPropertyFromClass('backend.ClientPrefs', 'data.downScroll')
        mscrolm = getPropertyFromClass('backend.ClientPrefs', 'data.middleScroll')
        dscrol = getPropertyFromClass('backend.ClientPrefs', 'data.downScroll')
        mscrol = getPropertyFromClass('backend.ClientPrefs', 'data.middleScroll')
        script = true
    else
        close(true)
    end
end

function onSongStart()
    if dscrolm or mscrolm then
        debugPrint('TURN OFF MIDDLESCROLL IF YOU GET VISUAL BUGS. IF STILL PERSISTS TURN OFF DOWNSCROLL. SORRY!')
        debugPrint('TURN OFF MIDDLESCROLL IF YOU GET VISUAL BUGS. IF STILL PERSISTS TURN OFF DOWNSCROLL. SORRY!')
        debugPrint('TURN OFF MIDDLESCROLL IF YOU GET VISUAL BUGS. IF STILL PERSISTS TURN OFF DOWNSCROLL. SORRY!')
    end
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
end
function onUpdate()
    if lk then
        songPos = getSongPosition()
        local currentBeat = (songPos/5000)*(curBpm/60)
        noteTweenY('nAdefaultOpponentStrumY0', 0, defaultPlayerStrumY0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultOpponentStrumY1', 1, defaultPlayerStrumY1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultOpponentStrumY2', 2, defaultPlayerStrumY2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultOpponentStrumY3', 3, defaultPlayerStrumY3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5);
        noteTweenY('nAdefaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultOpponentStrumX0', 0, defaultPlayerStrumX0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultOpponentStrumX1', 1, defaultPlayerStrumX1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultOpponentStrumX2', 2, defaultPlayerStrumX2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultOpponentStrumX3', 3, defaultPlayerStrumX3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultPlayerStrumX0', 4, defaultPlayerStrumX0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultPlayerStrumX1', 5, defaultPlayerStrumX1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultPlayerStrumX2', 6, defaultPlayerStrumX2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5);
        noteTweenX('nAdefaultPlayerStrumX3', 7, defaultPlayerStrumX3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5);
    end
end
function onEvent(name, value1, value2)
    if name == "newArrowToggler" then
        if script then
            value1 = tonumber(value1);
            value2 = tonumber(value2);
            local allTweens = {
                'nAdefaultOpponentStrumX0', 'nAdefaultOpponentStrumX1', 'nAdefaultOpponentStrumX2', 'nAdefaultOpponentStrumX3',
                'nAdefaultOpponentStrumY0', 'nAdefaultOpponentStrumY1', 'nAdefaultOpponentStrumY2', 'nAdefaultOpponentStrumY3',
                'nAdefaultPlayerStrumX0', 'nAdefaultPlayerStrumX1', 'nAdefaultPlayerStrumX2', 'nAdefaultPlayerStrumX3',
                'nAdefaultPlayerStrumY0', 'nAdefaultPlayerStrumY1', 'nAdefaultPlayerStrumY2', 'nAdefaultPlayerStrumY3',
                'nAhp', 'nAhpI1', 'nAhpI2',
                'nAo1', 'nAo2', 'nAo3', 'nAo4', 'nAo5', 'nAo6', 'nAo7', 'nAo8',
                'nAx1', 'nAx2', 'nAx3', 'nAx4', 'nAx5', 'nAx6', 'nAx7', 'nAx8',
                'nAy1', 'nAy2', 'nAy3', 'nAy4', 'nAy5', 'nAy6', 'nAy7', 'nAy8'
            }
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
                    if value2 > 0.012 then
                        noteTweenY('nAy1',0,50,value2,curtwm);
                        noteTweenY('nAy2',1,50,value2,curtwm);
                        noteTweenY('nAy3',2,50,value2,curtwm);
                        noteTweenY('nAy4',3,50,value2,curtwm);
                        noteTweenY('nAy5',4,50,value2,curtwm);
                        noteTweenY('nAy6',5,50,value2,curtwm);
                        noteTweenY('nAy7',6,50,value2,curtwm);
                        noteTweenY('nAy8',7,50,value2,curtwm);
                        setProperty('healthBar.y',640);
                        setProperty('healthBarBG.y',840);
                        setProperty('iconP1.y',570);
                        setProperty('iconP2.y',570);
                        doTweenY('nAscoretxt', 'scoreTxt', 680, value2, curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        for i = 0,3 do
                            setPropertyFromGroup('opponentStrums',i,'y',50);
                            setPropertyFromGroup('playerStrums',i,'y',50);
                        end
                        setProperty('healthBar.y',640);
                        setProperty('healthBarBG.y',840);
                        setProperty('iconP1.y',570);
                        setProperty('iconP2.y',570);
                        setProperty('scoretxt.y', 680);
                    end
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                    end
                    setProperty('timeTxt.y', 19);
                    setProperty('timeBar.y', 27);
                    setProperty('timeBarBG.y', 23);
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
                else
                    if value2 > 0.012 then
                        noteTweenY('nAy1',0,560,value2,curtwm);
                        noteTweenY('nAy2',1,560,value2,curtwm);
                        noteTweenY('nAy3',2,560,value2,curtwm);
                        noteTweenY('nAy4',3,560,value2,curtwm);
                        noteTweenY('nAy5',4,560,value2,curtwm);
                        noteTweenY('nAy6',5,560,value2,curtwm);
                        noteTweenY('nAy7',6,560,value2,curtwm);
                        noteTweenY('nAy8',7,560,value2,curtwm);
                        setProperty('healthBar.y',80);
                        setProperty('healthBarBG.y',80);
                        setProperty('iconP1.y',10);
                        setProperty('iconP2.y',10);
                        doTweenY('nAscoretxt', 'scoreTxt',120, 0.001, curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        for i = 0,3 do
                            setPropertyFromGroup('opponentStrums',i,'y',560);
                            setPropertyFromGroup('playerStrums',i,'y',560);
                        end
                        setProperty('healthBar.y',80);
                        setProperty('healthBarBG.y',80);
                        setProperty('iconP1.y',10);
                        setProperty('iconP2.y',10);
                        setProperty('scoretxt.y', 120);
                    end
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                    end
                    setProperty('timeTxt.y', 668);
                    setProperty('timeBar.y', 676);
                    setProperty('timeBarBG.y', 684);
                    defaultOpponentStrumY0 = 560
                    defaultOpponentStrumY1 = 560
                    defaultOpponentStrumY2 = 560
                    defaultOpponentStrumY3 = 560
                    defaultPlayerStrumY0 = 560
                    defaultPlayerStrumY1 = 560
                    defaultPlayerStrumY2 = 560
                    defaultPlayerStrumY3 = 560
                    ran = true
                    dscrol = true
                end
            elseif value1 == 111 then
                if ranm or dscrol then
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                        setPropertyFromGroup('playerStrums',i,'downScroll',false);
                    end
                    ranm = false
                    dscrol = false
                else
                    for i = 0,3 do
                        setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                        setPropertyFromGroup('playerStrums',i,'downScroll',true);
                    end
                    ranm = true
                    dscrol = true
                end
            elseif value1 == 2 then --Swap Sides with Opponent
                if ran1 then
                    if value2 > 0.012 then
                        noteTweenX("nAx1",0,defaultOpponentStrumX0,value2,curtwm);
                        noteTweenX("nAx2",1,defaultOpponentStrumX1,value2,curtwm);
                        noteTweenX("nAx3",2,defaultOpponentStrumX2,value2,curtwm);
                        noteTweenX("nAx4",3,defaultOpponentStrumX3,value2,curtwm);
                        noteTweenX("nAx5",4,defaultPlayerStrumX0,value2,curtwm);
                        noteTweenX("nAx6",5,defaultPlayerStrumX1,value2,curtwm);
                        noteTweenX("nAx7",6,defaultPlayerStrumX2,value2,curtwm);
                        noteTweenX("nAx8",7,defaultPlayerStrumX3,value2,curtwm);
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
                        noteTweenX("nAx1",0,defaultPlayerStrumX0,value2,curtwm);
                        noteTweenX("nAx2",1,defaultPlayerStrumX1,value2,curtwm);
                        noteTweenX("nAx3",2,defaultPlayerStrumX2,value2,curtwm);
                        noteTweenX("nAx4",3,defaultPlayerStrumX3,value2,curtwm);
                        noteTweenX("nAx5",4,defaultOpponentStrumX0,value2,curtwm);
                        noteTweenX("nAx6",5,defaultOpponentStrumX1,value2,curtwm);
                        noteTweenX("nAx7",6,defaultOpponentStrumX2,value2,curtwm);
                        noteTweenX("nAx8",7,defaultOpponentStrumX3,value2,curtwm);
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
                        noteTweenX("nAx1",0,dosx0,value2,curtwm);
                        noteTweenX("nAx2",1,dosx1,value2,curtwm);
                        noteTweenX("nAx3",2,dosx2,value2,curtwm);
                        noteTweenX("nAx4",3,dosx3,value2,curtwm);
                    
                        noteTweenX("nAx5",4,dpsx0,value2,curtwm);
                        noteTweenX("nAx6",5,dpsx1,value2,curtwm);
                        noteTweenX("nAx7",6,dpsx2,value2,curtwm);
                        noteTweenX("nAx8",7,dpsx3,value2,curtwm);
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
                        noteTweenX("nAx1",0,dosx0+75,value2,curtwm);
                        noteTweenX("nAx2",1,dosx1+75,value2,curtwm);
                        noteTweenX("nAx3",2,dpsx2-79,value2,curtwm);
                        noteTweenX("nAx4",3,dpsx3-79,value2,curtwm);
                    
                        noteTweenX("nAx5",4,dpsx0-323,value2,curtwm);
                        noteTweenX("nAx6",5,dpsx1-323,value2,curtwm);
                        noteTweenX("nAx7",6,dpsx2-323,value2,curtwm);
                        noteTweenX("nAx8",7,dpsx3-323,value2,curtwm);
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
                        noteTweenAlpha("nAo1",0,0,0.5,"quartInOut");
                        noteTweenAlpha("nAo2",1,0,0.5,"quartInOut");
                        noteTweenAlpha("nAo3",2,0,0.5,"quartInOut");
                        noteTweenAlpha("nAo4",3,0,0.5,"quartInOut");
                        noteTweenX("nAx1",0,dosx0+75,value2,curtwm);
                        noteTweenX("nAx2",1,dosx1+75,value2,curtwm);
                        noteTweenX("nAx3",2,dpsx2-79,value2,curtwm);
                        noteTweenX("nAx4",3,dpsx3-79,value2,curtwm);
                    
                        noteTweenX("nAx5",4,dpsx0-323,value2,curtwm);
                        noteTweenX("nAx6",5,dpsx1-323,value2,curtwm);
                        noteTweenX("nAx7",6,dpsx2-323,value2,curtwm);
                        noteTweenX("nAx8",7,dpsx3-323,value2,curtwm);
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
                for _, tweenName in ipairs(allTweens) do
                    cancelTween(tweenName)
                end
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
                        for i = 0,3 do
                            setPropertyFromGroup('opponentStrums',i,'downScroll',false);
                            setPropertyFromGroup('playerStrums',i,'downScroll',false);
                        end
                        doTweenY('nAhp', 'healthBar', 640, value2, curtwm);
                        doTweenY('nAhpI1', 'iconP1', 570, value2, curtwm);
                        doTweenY('nAhpI2', 'iconP2', 570, value2, curtwm);
                        doTweenY('nAscoretxt', 'scoreTxt', 680, 0.001, curtwm);
                        setProperty('timeTxt.y', 19);
                        setProperty('timeBar.y', 27);
                        setProperty('timeBarBG.y', 23);
                    else
                        for i = 0,3 do
                            setPropertyFromGroup('opponentStrums',i,'downScroll',true);
                            setPropertyFromGroup('playerStrums',i,'downScroll',true);
                        end
                        doTweenY('nAhp', 'healthBar', 80, value2, curtwm);
                        doTweenY('nAhpI1', 'iconP1', 10, value2, curtwm);
                        doTweenY('nAhpI2', 'iconP2', 10, value2, curtwm);
                        doTweenY('nAscoretxt', 'scoreTxt',120, value2, curtwm);
                        setProperty('timeTxt.y', 668);
                        setProperty('timeBar.y', 676);
                        setProperty('timeBarBG.y', 684);
                    end
                    if value2 > 0.012 then
                        noteTweenY("nAy1",0,dosy0,value2,curtwm);
                        noteTweenY("nAy2",1,dosy1,value2,curtwm);
                        noteTweenY("nAy3",2,dosy2,value2,curtwm);
                        noteTweenY("nAy4",3,dosy3,value2,curtwm);
                        noteTweenY("nAy5",4,dpsy0,value2,curtwm);
                        noteTweenY("nAy6",5,dpsy1,value2,curtwm);
                        noteTweenY("nAy7",6,dpsy2,value2,curtwm);
                        noteTweenY("nAy8",7,dpsy3,value2,curtwm);
                        noteTweenX("nAx1",0,dosx0,value2,curtwm);
                        noteTweenX("nAx2",1,dosx1,value2,curtwm);
                        noteTweenX("nAx3",2,dosx2,value2,curtwm);
                        noteTweenX("nAx4",3,dosx3,value2,curtwm);
                        noteTweenX("nAx5",4,dpsx0,value2,curtwm);
                        noteTweenX("nAx6",5,dpsx1,value2,curtwm);
                        noteTweenX("nAx7",6,dpsx2,value2,curtwm);
                        noteTweenX("nAx8",7,dpsx3,value2,curtwm);
                    elseif value2 < 0.012 or value2 == 0 then
                        setPropertyFromGroup('opponentStrums',0,'y',50);
                        setPropertyFromGroup('opponentStrums',1,'y',50);
                        setPropertyFromGroup('opponentStrums',2,'y',50);
                        setPropertyFromGroup('opponentStrums',3,'y',50);
                        setPropertyFromGroup('playerStrums',0,'y',50);
                        setPropertyFromGroup('playerStrums',1,'y',50);
                        setPropertyFromGroup('playerStrums',2,'y',50);
                        setPropertyFromGroup('playerStrums',3,'y',50);
                        setPropertyFromGroup('opponentStrums',0,'x',dosx0);
                        setPropertyFromGroup('opponentStrums',1,'x',dosx1);
                        setPropertyFromGroup('opponentStrums',2,'x',dosx2);
                        setPropertyFromGroup('opponentStrums',3,'x',dosx3);
                        setPropertyFromGroup('playerStrums',0,'x',dpsx0);
                        setPropertyFromGroup('playerStrums',1,'x',dpsx1);
                        setPropertyFromGroup('playerStrums',2,'x',dpsx2);
                        setPropertyFromGroup('playerStrums',3,'x',dpsx3);
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
            elseif value1 == 10 then
                if xx1 then
                    noteTweenX("nAx5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("nAx8",7,defaultPlayerStrumX0,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx1 = false
                else
                    noteTweenX("nAx5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("nAx8",7,defaultPlayerStrumX0,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx1 = true
                end
            elseif value1 == 11 then
                if xx2 then
                    noteTweenX("nAx6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("nAx7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX1 = ALTdpsx2
                    xx2 = false
                else
                    noteTweenX("nAx6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("nAx7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX1 = ALTdpsx2
                   xx2 = true
                end
            elseif value1 == 12 then
                if xx3 then
                    noteTweenX("nAx5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("nAx8",7,defaultPlayerStrumX0,value2,curtwm);
                    noteTweenX("nAx6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("nAx7",6,defaultPlayerStrumX1,value2,curtwm);
                    defaultPlayerStrumX0 = ALTdpsx3
                    defaultPlayerStrumX1 = ALTdpsx2
                    defaultPlayerStrumX2 = ALTdpsx1
                    defaultPlayerStrumX3 = ALTdpsx0
                    xx3 = false
                else
                    noteTweenX("nAx5",4,defaultPlayerStrumX3,value2,curtwm);
                    noteTweenX("nAx8",7,defaultPlayerStrumX0,value2,curtwm);
                    noteTweenX("nAx6",5,defaultPlayerStrumX2,value2,curtwm);
                    noteTweenX("nAx7",6,defaultPlayerStrumX1,value2,curtwm);
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
                for _, tweenName in ipairs(allTweens) do
                    cancelTween(tweenName)
                end
                noteTweenX("nAdefaultOpponentStrumX0",0,defaultOpponentStrumX0,value2,curtwm);
                noteTweenX("nAdefaultOpponentStrumX1",1,defaultOpponentStrumX1,value2,curtwm);
                noteTweenX("nAdefaultOpponentStrumX2",2,defaultOpponentStrumX2,value2,curtwm);
                noteTweenX("nAdefaultOpponentStrumX3",3,defaultOpponentStrumX3,value2,curtwm);
                noteTweenX("nAdefaultPlayerStrumX0",4,defaultPlayerStrumX0,value2,curtwm);
                noteTweenX("nAdefaultPlayerStrumX1",5,defaultPlayerStrumX1,value2,curtwm);
                noteTweenX("nAdefaultPlayerStrumX2",6,defaultPlayerStrumX2,value2,curtwm);
                noteTweenX("nAdefaultPlayerStrumX3",7,defaultPlayerStrumX3,value2,curtwm);
                noteTweenY("nAdefaultOpponentStrumY0",0,defaultOpponentStrumY0,value2,curtwm);
                noteTweenY("nAdefaultOpponentStrumY1",1,defaultOpponentStrumY1,value2,curtwm);
                noteTweenY("nAdefaultOpponentStrumY2",2,defaultOpponentStrumY2,value2,curtwm);
                noteTweenY("nAdefaultOpponentStrumY3",3,defaultOpponentStrumY3,value2,curtwm);
                noteTweenY("nAdefaultPlayerStrumY0",4,defaultPlayerStrumY0,value2,curtwm);
                noteTweenY("nAdefaultPlayerStrumY1",5,defaultPlayerStrumY1,value2,curtwm);
                noteTweenY("nAdefaultPlayerStrumY2",6,defaultPlayerStrumY2,value2,curtwm);
                noteTweenY("nAdefaultPlayerStrumY3",7,defaultPlayerStrumY3,value2,curtwm);
            end
        end
    end
end