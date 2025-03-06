local offset = 0
function onSongStart()
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',offset/1000)
    
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'etouch', 'etouch','game',0.8})
    end
end