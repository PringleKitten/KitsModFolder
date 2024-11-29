offset = 75
local newOff = 0
local c = true -- set to True to use custom offsets

function onCreate()
    if not c then
        offset = getPropertyFromClass('ClientPrefs','noteOffset')
    elseif c then
        setPropertyFromClass('ClientPrefs','noteOffset',offset) --Number is YOUR Song Offset
    end
    for _, curS in pairs({'marshmallow-(alone)','alan-becker-(sea-shanty-edit)','alan-becker-(sea-shanty)'}) do
        if songName == curS then
            newOff = -75 --Number is YOUR Song Offset
        elseif songName == 'sandstorm' or songName == 'anjer-remix-(manifest)' or songName == 'the-living-tombstone-(FNaF1)' then
            newOff = -25 --Number is YOUR Song Offset
        elseif songName == 'TON-GD-Level' or songName == 'alan-becker-(rush-e)' or songName == 'run-run' then
            newOff = -50 --Number is YOUR Song Offset
        elseif songName == 'cg5-(stuck-inside)' then
            newOff = -75 --Number is YOUR Song Offset
        elseif songName == 'Stress' or songName == 'Ugh' then
            newOff = 50 --Number is YOUR Song Offset
        end
    end
    if newOff ~= 0 then
        setPropertyFromClass('ClientPrefs','noteOffset',offset+newOff)
    end
end

function onCreatePost()
    if newOff ~= 0 then
        callScript("scripts/script", "offnewch", {newOff})
    else
        callScript("scripts/script", "offnewch", {0})
    end
end

function onDestroy()
    if c then
        setPropertyFromClass('ClientPrefs','noteOffset',offset)
    end
end