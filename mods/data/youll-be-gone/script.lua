function onSongStart()
    if difficulty == 1 then
        setProperty('showComboNum', false)
        setProperty('showRating', false)
        callScript('scripts/videoSprite', 'makeVideoSprite', {'video2', 'ykg', -320, -180, 'camHUD'})
    end
end