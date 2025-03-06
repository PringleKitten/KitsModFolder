local offset = 0
function onSongStart()
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',((offset-75)/1000))
    
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'octod', 'octagon','camGame',1})
    end
end