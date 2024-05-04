function onUpdate()
    if loop == 1 then
        setPropertyFromClass('Conductor', 'songPosition', newV1)
        setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('Conductor', 'songPosition'))
        setProperty('vocals.time', getPropertyFromClass('Conductor', 'songPosition'))
        loop = 3
    end
end
local newV1 = 0
function onEvent(name,value1,value2)
    if name == 'ChangeTime' then
        newV1 = (tonumber(value1)*1000)
        value2 = tonumber(value2)
        time = getPropertyFromClass('Conductor', 'songPosition')
        if newV1 < time then
            if value2 == 1 then
                loop = 1
                setPropertyFromClass('Conductor', 'songPosition', newV1)
                setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('Conductor', 'songPosition'))
                setProperty('vocals.time', getPropertyFromClass('Conductor', 'songPosition'))
            elseif value2 == 0 then
                if loop ~= 2 then
                    loop = 0
                end
                if loop == 0 then
                    setPropertyFromClass('Conductor', 'songPosition', newV1)
                    setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('Conductor', 'songPosition'))
                    setProperty('vocals.time', getPropertyFromClass('Conductor', 'songPosition'))
                end
            end
            if loop == 0 then
                loop = 2
            end
        else
            setPropertyFromClass('Conductor', 'songPosition', newV1)
            setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('Conductor', 'songPosition'))
            setProperty('vocals.time', getPropertyFromClass('Conductor', 'songPosition'))
        end
    end
end
