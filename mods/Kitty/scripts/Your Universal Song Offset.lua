offset = 125

function onCreate()
    setPropertyFromClass('ClientPrefs','noteOffset',offset) --Number is YOUR Song Offset
    if songName == 'marshmallow-(alone)' then
       setPropertyFromClass('ClientPrefs','noteOffset',offset-50) --Number is YOUR Song Offset
    end
end