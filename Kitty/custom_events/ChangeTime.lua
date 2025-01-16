function onUpdate()
    if loop == 1 then
        setPropertyFromClass('backend.Condutor', 'songPosition', newV1)
        setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
        setProperty('vocals.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
        loop = 3
    end
end
local newV1 = 0
function onEvent(name,value1,value2)
    if name == 'ChangeTime' then
        newV1 = (tonumber(value1)*1000)
        value2 = tonumber(value2)
        time = getPropertyFromClass('backend.Condutor', 'songPosition')
        if newV1 < time then
            if value2 == 1 then
                loop = 1
                setPropertyFromClass('backend.Condutor', 'songPosition', newV1)
                setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
                setProperty('vocals.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
            elseif value2 == 0 then
                if loop ~= 2 then
                    loop = 0
                end
                if loop == 0 then
                    setPropertyFromClass('backend.Condutor', 'songPosition', newV1)
                    setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
                    setProperty('vocals.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
                end
            end
            if loop == 0 then
                loop = 2
            end
        else
            setPropertyFromClass('backend.Condutor', 'songPosition', newV1)
            setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
            setProperty('vocals.time', getPropertyFromClass('backend.Condutor', 'songPosition'))
        end
    end
end
