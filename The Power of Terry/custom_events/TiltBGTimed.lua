local ran = false
local ran1 = false
local thing = 1
local thing2 = 1
local event = 0
local v1 = false
local v2 = false
function onEvent(name, value1, value2)
    if name == "TiltBGTimed" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        event = "TiltBGTimed"
        value1 = tonumber(value1) or 0;
        value2 = tonumber(value2) or 0;
        if value2 > 0.012 then
        if value1 == 00 then
            doTweenAngle('GUI4tween', 'camGame', 0, value2, 'bounceOut');
            ran1 = false
        elseif value2 == 1 then
            if ran1 then
                doTweenAngle('GUI5tween', 'camGame', 10, value2, 'bounceOut');
                ran1 = false
            else
                doTweenAngle('GUI5tween', 'camGame', -10, value2, 'bounceOut');
                ran1 = true
            end
        elseif value1 == 2 then
            if ran1 then
                doTweenAngle('GUI6tween', 'camGame', 30, value2, 'bounceOut');
                ran1 = false
            else
                doTweenAngle('GUI6tween', 'camGame', -30, value2, 'bounceOut');
                ran1 = true
            end
        elseif value1 == 1234 then
            v2 = true
        elseif value1 == 1111 then
            v2 = false
            value1 = 0
            value2 = 0
        elseif ran then
                doTweenAngle('GUI7tween', 'camGame', value1, value2, 'bounceOut');
                ran1 = false
            else
                doTweenAngle('GUI7tween', 'camGame', -value1, value2, 'bounceOut');
                ran1 = true
        end
    elseif ran then
        setProperty('camGame.angle',value1)
        ran = false
    else
        setProperty('camHUD.angle',-value1)
        ran = true
    end
    end
end
end

function onBeatHit()
    if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        if v2 then
            thing = thing * -1
            doTweenAngle('rotate', 'camHUD', thing * 5, crochet / 1000, 'quadInOut')
        end
    end
end



