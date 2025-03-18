if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
    close()
end
local ran = false
local ran1 = false
local thing = 1
local thing2 = 1
local v1 = false
local v2 = false
local value1a = 0
local value2a = 0

function tiltCamera(camera, value, ranVar)
    local angle = 0
    if value == 00 then
        angle = 0
        ranVar = false
        if camera == 'camHUD' then v1 = false elseif camera == 'camGame' then v2 = false end
    elseif value == 1 then
        angle = ranVar and 10 or -10
    elseif value == 2 then
        angle = ranVar and 30 or -30
    elseif value == 1234 then
        if camera == 'camHUD' then v1 = true elseif camera == 'camGame' then v2 = true end
        return ranVar
    elseif value == 1111 then
        angle = 0
        if camera == 'camHUD' then v1 = false elseif camera == 'camGame' then v2 = false end
    else
        angle = ranVar and value or -value
    end

    if value ~= 1234 then
        doTweenAngle('GUI' .. camera .. 'tween', camera, angle, 0.3, 'bounceOut')
        ranVar = not ranVar
    end

    return ranVar
end

function onEvent(name, value1, value2)
    if name == "Tilt" then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        ran = tiltCamera('camHUD', value1, ran)
        ran1 = tiltCamera('camGame', value2, ran1)
    end
end

function onBeatHit()
    if v2 then
        thing = -thing
        doTweenAngle('rotate', 'camGame', thing * 5, crochet / 1000, 'quadInOut')
    end
    if v1 then
        thing2 = -thing2
        doTweenAngle('rotate', 'camHUD', thing2 * 5, crochet / 1000, 'quadInOut')
    end
end




