function onSongStart()
    if difficulty == 1 then
        setProperty('showComboNum', false)
        setProperty('showRating', false)
        callScript('scripts/videoSprite', 'makeVideoSprite', {'video29', 'ykg', -320, -180, 'camHUD',1,1})
    end
end