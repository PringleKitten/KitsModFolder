function onSongStart()
    setProperty('showComboNum', false)
    setProperty('showRating', false)
    callScript('scripts/videoSpriteOld', 'makeVideoSprite', {'videso1', 'amanda', 382, -11.2, 'camGame', 1.111, 1.1105})
end