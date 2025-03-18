offset = 100
local newOff = 0
local c = true -- set to True to use custom offsets

function onCreate()
    if not c then
        offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')
    elseif c then
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset) --Number is YOUR Song Offset
    end
    for _, curS in pairs({'alan-becker-(sea-shanty-edit)','alan-becker-(sea-shanty)'}) do
        if songName == curS then
            newOff = -25 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'TON-GD-Level','alan-becker-(rush-e)','run-run'}) do
        if songName == curS then
            newOff = -25 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'marshmallow-(alone)',}) do
        if songName == curS then
            newOff = -50 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'sandstorm','the-living-tombstone-(FNaF1)'}) do
        if songName == curS then
            newOff = 0 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'cg5-(stuck-inside)'}) do
        if songName == curS then
            newOff = -70 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'Ugh'}) do
        if songName == curS then
            newOff = 75 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'electroman-adventures','everytime-we-touch'}) do
        if songName == curS then
            newOff = 35 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'Stress'}) do
        if songName == curS then
            newOff = 60 --Number is YOUR Song Offset
        end
    end
    for _, curS in pairs({'Octagon of Destiny'}) do
        if songName == curS then
            newOff = -10 --Number is YOUR Song Offset
        end
    end

    if newOff ~= 0 then
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset+newOff)
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
        setPropertyFromClass('backend.ClientPrefs','data.noteOffset',offset)
    end
    close()
end