local offset = 0
function onSongStart()
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',offset/1000)
    
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'platy', 'platy', 382, -11.2, 'camGame', 1.111, 1.1105})
    end
end