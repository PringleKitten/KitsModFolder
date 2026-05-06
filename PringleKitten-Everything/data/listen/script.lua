local videoName = 'amanda'


local offset = 0
function onCountdownStarted()
    startVideo(videoName, false, true, false, false)
    
end
function onSongStart()
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')

    setProperty('showRating', false);
    setProperty('showComboNum', false);

    runTimer('vid',(offset+100)/1000)
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {videoName, videoName,'camGame',1})
        close(true)
    end
end