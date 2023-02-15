local thing = 1

function onBeatHit()
    objectPlayAnimation('bf', 'idle', false);
    setProperty('bf.offset.x',0)
    setProperty('bf.offset.y', 0)
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
    if curBeat >= 40 then
        thing = thing * -1
        doTweenAngle('rotate', 'camHUD', thing * 5, crochet / 1000, 'quadInOut')
    end
end
end
function onCreate()
    --Put It In Your Songs Data Folder
    --replace With Your Desired Characters And Anims
    makeAnimatedLuaSprite('bf','characters/BOYFRIEND',-170 , 330);
    setProperty('bf.flipX', true); --ithink
    luaSpriteAddAnimationByPrefix('bf', 'idle', 'BF idle dance', 32, false);
    luaSpriteAddAnimationByPrefix('bf', 'singUP', 'BF NOTE UP0', 32, false);
    luaSpriteAddAnimationByPrefix('bf', 'singDOWN', 'BF NOTE DOWN0', 32, false);
    luaSpriteAddAnimationByPrefix('bf', 'singLEFT', 'BF NOTE LEFT0', 32, false);
    luaSpriteAddAnimationByPrefix('bf', 'singRIGHT', 'BF NOTE RIGHT0', 32, false);
    addLuaSprite('bf', true);
   end