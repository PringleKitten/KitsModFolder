local offset = 0
function onSongStart()
    offset = getPropertyFromClass('ClientPrefs','noteOffset')
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    runTimer('vid',((offset-75)/1000))
    debugPrint('Current Offset: ','(',offset,')')
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'octod', 'octagon', 382, -11.2, 'camGame', 1.111, 1.1105})
    end
end