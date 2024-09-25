local ran = false
local ran1 = false
local thing = 1
local thing2 = 1
local event = 0
local v1 = false
local v2 = false
function onEvent(name, value1, value2)
    if name == "TiltHudTimed" then
        if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
        event = "TiltHudTimed"
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        if value2 > 0.012 or value2 == "" then
            if value1 == 00 then
                doTweenAngle('GUItween', 'camHUD', 0, value2, 'bounceOut');
                ran = false
            elseif value1 == 1 then
                if ran then
                    doTweenAngle('GUI1tween', 'camHUD', 10, value2, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI1tween', 'camHUD', -10, value2, 'bounceOut');
                    ran = true
                end
            elseif value1 == 2 then
                if ran then
                    doTweenAngle('GUI2tween', 'camHUD', 30, value2, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI2tween', 'camHUD', -30, value2, 'bounceOut');
                    ran = true
                end
            elseif value1 == 1234 then
                v1 = true
            elseif value1 == 1111 then
                v1 = false
                value1 = 0
                value2 = 0
                doTweenAngle('GUI2tween', 'camHUD', 0, value2, 'bounceOut');
            elseif ran then
                    doTweenAngle('GUI3tween', 'camHUD', 0+value1, value2, 'bounceOut');
                    ran = false
                else
                    doTweenAngle('GUI3tween', 'camHUD', -value1, value2, 'bounceOut');
                    ran = true
            end
        elseif ran then
            setProperty('camHUD.angle',value1)
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
        if v1 then
            thing2 = thing2 * -1
            doTweenAngle('rotate', 'camHUD', thing2 * 5, crochet / 1000, 'quadInOut')
        end
    end
end



