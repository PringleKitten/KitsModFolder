local offset = 0
function onSongStart()
    setProperty('showRating', false);
    setProperty('showComboNum', false);
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',(offset+100)/1000)
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'abrushe', 'abrushe','camGame',1})
    end
end