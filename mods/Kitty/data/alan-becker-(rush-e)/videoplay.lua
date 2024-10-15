local offset = 0
function onSongStart()
    setProperty('showRating', false);
    setProperty('showComboNum', false);
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',(offset+100)/1000)
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'abrushe', 'abrushe', 62, -191, 'camGame', 0.7404, 0.7408})
    end
end