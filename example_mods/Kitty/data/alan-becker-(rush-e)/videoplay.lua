local videoName = 'abrushe'


local offset = 0
function onCountdownTick(counter)
    if counter == 0 then
        startVideo(videoName, false, true)
        setObjectCamera('videoCutscene','game')
        setProperty('videoCutscene.alpha', 0.1)
        setProperty('camGame.zoom',zoom)
    end
end
function onSongStart()
    offset = getPropertyFromClass('backend.ClientPrefs','data.noteOffset')

    setProperty('showRating', false)
    setProperty('showComboNum', false)

    runTimer('vid',(offset+100)/1000)
end

function onTimerCompleted(tag)
    if tag == 'vid' then
        callScript('scripts/videoSprite', 'makeVideoSprite', {videoName, videoName,'camGame',1})
        close()
    end
end