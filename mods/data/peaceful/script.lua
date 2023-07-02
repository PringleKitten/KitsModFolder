local midScroll = false
local angleshit = 1;
local anglevar = 1;
function onBeatHit()
    if ClientPrefs.assetMovement == true then
    if curBeat >= 28 and curBeat <= 154 then
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
        setProperty('camHUD.angle',angleshit*3)
        setProperty('camGame.angle',angleshit*3)
        doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
        doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
    end
    if curBeat >= 176 and curBeat <= 208 then
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
        setProperty('camHUD.angle',angleshit*3)
        setProperty('camGame.angle',angleshit*3)
        doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
        doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
    end
    if curBeat >= 240 and curBeat <= 364 then
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
        setProperty('camHUD.angle',angleshit*3)
        setProperty('camGame.angle',angleshit*3)
        doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
        doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
        doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
    end
end
end
function onCreate()
  midScroll = getPropertyFromClass('ClientPrefs', 'middleScroll');
  setPropertyFromClass('ClientPrefs', 'middleScroll', true);
end

function onDestroy()
    setPropertyFromClass('ClientPrefs', 'middleScroll', midScroll);
  end


function onSongStart()
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'visible', false)
    end
end

    --song crap beloww

function onUpdate(elapsed)
    if curBeat == 1 then
        makeLuaSprite('bg', 'me/creepystage/begin', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 12 then
        makeLuaSprite('bg', 'me/creepystage/begin1', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 28 then
        makeLuaSprite('bg', 'me/creepystage/a', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 60 then
        makeLuaSprite('bg', 'me/creepystage/a1', 160, -400);
        scaleObject('bg', 1.11, 1.11);

        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 92 then
        makeLuaSprite('bg', 'me/creepystage/a2', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 124 then
        makeLuaSprite('bg', 'me/creepystage/a3', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 158 then
        makeLuaSprite('bg', 'me/creepystage/b', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 176 then
        makeLuaSprite('bg', 'me/creepystage/c', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curStep == 771 then
        makeLuaSprite('bg', 'me/creepystage/d', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curStep == 773 then
        makeLuaSprite('bg', 'me/creepystage/c', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 194 then
        makeLuaSprite('bg', 'me/creepystage/d', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 208 then
        makeLuaSprite('bg', 'me/creepystage/e', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curStep == 851 then
        makeLuaSprite('bg', 'me/creepystage/e1', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curStep == 854 then
        makeLuaSprite('bg', 'me/creepystage/e2', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 216 then
        makeLuaSprite('bg', 'me/creepystage/e3', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 224 then
        makeLuaSprite('bg', 'me/creepystage/e4', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 232 then
        makeLuaSprite('bg', 'me/creepystage/e5', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 236 then
        makeLuaSprite('bg', 'me/creepystage/e6', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 238 then
        makeLuaSprite('bg', 'me/creepystage/e7', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 250 then
        makeLuaSprite('bg', 'me/creepystage/e8', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 260 then
        makeLuaSprite('bg', 'me/creepystage/e9', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 272 then
        makeLuaSprite('bg', 'me/creepystage/f', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 280 then
        makeLuaSprite('bg', 'me/creepystage/f1', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 290 then
        makeLuaSprite('bg', 'me/creepystage/f2', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 304 then
        makeLuaSprite('bg', 'me/creepystage/f3', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 320 then
        makeLuaSprite('bg', 'me/creepystage/f4', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 336 then
        makeLuaSprite('bg', 'me/creepystage/g', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 352 then
        makeLuaSprite('bg', 'me/creepystage/g1', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 366 then
        makeLuaSprite('bg', 'me/creepystage/hend', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curBeat == 370 then
        makeLuaSprite('bg', 'me/creepystage/hend1', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
    if curStep == 1486 then
        makeLuaSprite('bg', 'me/creepystage/hend2', 160, -400);
        scaleObject('bg', 1.11, 1.11);
    
        addLuaSprite('bg', false); -- ones ontop are on lower layers
    end
end