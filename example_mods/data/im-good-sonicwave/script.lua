function onCreate()
    makeLuaSprite('dod', 'me/popup/dodge1', 500, 0)
    scaleObject('dod', 5, 5)
    addLuaSprite('dod', true)
    setProperty('showComboNum', false)
    setProperty('showRating', false)
end
function onSongStart()
    removeLuaSprite('dod')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'ded')
    callScript('scripts/videoSprite', 'makeVideoSprite', {'video1', 'sonicwave', -320, -180, 'camHUD'})
end