if not getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') then
    close()
end
local ran = false
local thing2 = 1
local v1 = false

function onEvent(name, value1, value2)
    if name == "TiltBGTimed" then
        value1 = tonumber(-value1)
        value2 = tonumber(value2)
        if value1 == 1234 then
            v1 = true
        elseif value1 == 1111 then
            v1 = false
            if value2 > 0.011 then
                doTweenAngle("bgGUIBruhtween", "camGame", 0, value2, "quadInOut")
            else
                setProperty('camGame.angle', 0)
            end
        end
        if value2 < 0.011 then
            if whar ~= value1 then
                lopping = false
            end
            if (value1 == newV) or lopping then
                lopping = true
                newV = -newV
                whar = value1
                setProperty('camGame.angle', newV)
            end
            if not lopping then
                newV = value1
                setProperty('camGame.angle', value1)
            end
        elseif value2 > 0.011 then
            if value1 == 0 then
                angle = 0
                newV = 0
                cV = 0
                ran = false
            elseif value1 == 1 then
                if value1 == cV then
                    angle = -10
                else
                    angle = 10
                end
            elseif value1 == 2 then
                if value1 == cV then
                    angle = -30
                else
                    angle = 30
                end
            elseif value1 == angle then
                angle = -value1
            else
                angle = value1
            end
            cV = value1
            doTweenAngle('bgGUI' .. tostring(value1) .. 'tween', 'camGame', angle, value2, 'linear')
            ran = not ran
        end
    end
end

function onBeatHit()
    thing2 = -thing2
    doTweenAngle('bgrotate', 'camGame', thing2 * 5, crochet / 1000, 'quadInOut')
end
