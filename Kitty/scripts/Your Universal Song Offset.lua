offset = 150
local c = false -- set to True to use custom offsets

function onCreate()
    if not c then
        offset = getPropertyFromClass('ClientPrefs','noteOffset')
    elseif c then
    setPropertyFromClass('ClientPrefs','noteOffset',offset) --Number is YOUR Song Offset
    end
    if songName == 'marshmallow-(alone)' then
       setPropertyFromClass('ClientPrefs','noteOffset',offset-50) --Number is YOUR Song Offset
    end
end