local offset = 0
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
    noteTweenAlpha("o1",0,0,0.5,"quartInOut");
    noteTweenAlpha("o2",1,0,0.5,"quartInOut");
    noteTweenAlpha("o3",2,0,0.5,"quartInOut");
    noteTweenAlpha("o4",3,0,0.5,"quartInOut");
    noteTweenX("x1",0,dosx0+75,0.01,'cubeInOut');
    noteTweenX("x2",1,dosx1+75,0.01,'cubeInOut');
    noteTweenX("x3",2,dpsx2-79,0.01,'cubeInOut');
    noteTweenX("x4",3,dpsx3-79,0.01,'cubeInOut');
    noteTweenX("x5",4,dpsx0-323,0.01,'cubeInOut');
    noteTweenX("x6",5,dpsx1-323,0.01,'cubeInOut');
    noteTweenX("x7",6,dpsx2-323,0.01,'cubeInOut');
    noteTweenX("x8",7,dpsx3-323,0.01,'cubeInOut');
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
    setProperty('healthBar.alpha', 0);
    setProperty('healthBarBG.alpha', 0);
    setProperty('iconP1.alpha', 0);
    setProperty('iconP2.alpha', 0);
    setProperty('timeBar.alpha', 0);
    setProperty('timeTxt.alpha', 0);
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('showRating', false);
    setProperty('showComboNum', false);
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',offset/1000)
    debugPrint('Current Offset: ','(',offset,')')
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'absse', 'absse', 475.5, -371.25, 'camGame', 0.5552, 0.5552})
    end
end

function onBeatHit()
    if curStep > 31 then
        setProperty('camHUD.angle', 0)
        doTweenAngle('GUI3tween', 'camHUD', -7, 0.845, 'easeOut');
    end
end