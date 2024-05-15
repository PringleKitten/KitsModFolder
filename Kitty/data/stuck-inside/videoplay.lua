local offset = 0
function onSongStart()
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',offset/1000)
    debugPrint('Current Offset: ','(',offset,')')
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'stuck', 'stuck', 62, -191, 'camGame', 0.7404, 0.7408})
    end
end