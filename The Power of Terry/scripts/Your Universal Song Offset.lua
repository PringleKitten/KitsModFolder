offset = 75

function onCreate()
    setPropertyFromClass('ClientPrefs','noteOffset',offset) --Number is YOUR Song Offset
    if songName == 'mm-alone' then
       setPropertyFromClass('ClientPrefs','noteOffset',offset-20) --Number is YOUR Song Offset
    end
end