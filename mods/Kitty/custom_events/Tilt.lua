local ran = false
local ran1 = false
local thing = 1
local thing2 = 1
local event = 0
local v1 = false
local v2 = false
function onEvent(name, value1, value2)
    if name == "Tilt" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
            event = "Tilt"
            value1 = tonumber(value1) or 0;
            value2 = tonumber(value2) or 0;
            if value1 == 00 then
                doTweenAngle('GUItween', 'camHUD', 0, 0.3, 'bounceOut');
                ran = false
            elseif value1 == 1 then
                if ran then
                    doTweenAngle('GUI1tween', 'camHUD', 10, 0.3, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI1tween', 'camHUD', -10, 0.3, 'bounceOut');
                    ran = true
                end
            elseif value1 == 2 then
                if ran then
                    doTweenAngle('GUI2tween', 'camHUD', 30, 0.3, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI2tween', 'camHUD', -30, 0.3, 'bounceOut');
                    ran = true
                end
            elseif value1 == 1234 then
                v1 = true
            elseif value1 == 1111 then
                v1 = false
                value1 = 0
                value2 = 0
                doTweenAngle('GUI2tween', 'camHUD', 0, 0.3, 'bounceOut');
            elseif ran then
                    doTweenAngle('GUI3tween', 'camHUD', value1, 0.3, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI3tween', 'camHUD', -value1, 0.3, 'bounceOut');
                    ran = true
            end
            if value2 == 00 then
                doTweenAngle('GUI4tween', 'camGame', 0, 0.3, 'bounceOut');
                ran1 = false
            elseif value2 == 1 then
                if ran1 then
                    doTweenAngle('GUI5tween', 'camGame', 10, 0.3, 'bounceOut');
                    ran1 = false
                else
                    doTweenAngle('GUI5tween', 'camGame', -10, 0.3, 'bounceOut');
                    ran1 = true
                end
            elseif value2 == 2 then
                if ran1 then
                    doTweenAngle('GUI6tween', 'camGame', 30, 0.3, 'bounceOut');
                    ran1 = false
                else
                    doTweenAngle('GUI6tween', 'camGame', -30, 0.3, 'bounceOut');
                    ran1 = true
                end
            elseif value2 == 1234 then
                v2 = true
            elseif value2 == 1111 then
                v2 = false
                value1 = 0
                value2 = 0
            elseif ran then
                    doTweenAngle('GUI7tween', 'camGame', value2, 0.3, 'bounceOut');
                    ran1 = false
                else
                    doTweenAngle('GUI7tween', 'camGame', -value2, 0.3, 'bounceOut');
                    ran1 = true
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
        if v1 then
            thing2 = thing2 * -1
            doTweenAngle('rotate', 'camHUD', thing2 * 5, crochet / 1000, 'quadInOut')
        end
    end
end



