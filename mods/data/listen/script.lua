function onSongStart()
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    callScript('scripts/videoSprite', 'makeVideoSprite', {'videso1', 'amanda', 0, 0, 'camHUD', 1, 1})
end