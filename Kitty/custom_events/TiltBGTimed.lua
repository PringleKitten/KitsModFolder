local ran = false
local ran1 = false
local thing = 1
local thing2 = 1
local event = 0
local v1 = false
local v2 = false
function onEvent(name, value1, value2)
    if name == "TiltBGTimed" then
        if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
            event = "TiltBGTimed"
            value1 = tonumber(value1);
            value2 = tonumber(value2);

            if value2 == nil and value1 ~= 1234 and value1 ~= 1111 then
                value2 = 0.3
            elseif value2 == nil then
                value2 = 0
            end

            if value2 > 0.011 then
                if value1 == 00 then
                    doTweenAngle('BGtween', 'camGame', 0, value2, 'linear');
                    ran = false
                elseif value1 == 1 then
                    if ran then
                        doTweenAngle('BG1tween', 'camGame', 10, value2, 'linear');
                        ran = false
                    else
                        doTweenAngle('BG1tween', 'camGame', -10, value2, 'linear');
                        ran = true
                    end
                elseif value1 == 2 then
                    if ran then
                        doTweenAngle('BG2tween', 'camGame', 30, value2, 'linear');
                        ran = false
                    else
                        doTweenAngle('BG2tween', 'camGame', -30, value2, 'linear');
                        ran = true
                    end
                elseif ran then
                    doTweenAngle('BG3tween', 'camGame', value1, value2, 'linear');
                    ran = false
                else
                    doTweenAngle('BG3tween', 'camGame', -value1, value2, 'linear');
                    ran = true
                end
            end
            if value1 == 1234 then
                v1 = true
            elseif value1 == 1111 then
                v1 = false
                if value2 < 0.011 then
                    setProperty('camGame.angle', 0);
                else
                    doTweenAngle("BG9tween", "camGame", 0, value2, "quadInOut")
                end
            elseif value2 < 0.011 and ran then
                setProperty('camGame.angle',value1)
                ran = false
            elseif value2 < 0.011 and not ran then
                setProperty('camGame.angle',-value1)
                ran = true
            end
        end
    end
end

function onBeatHit()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
        if v1 then
            thing2 = thing2 * -1
            doTweenAngle('rotate', 'camGame', thing2 * 5, crochet / 1000, 'quadInOut')
        end
    end
end