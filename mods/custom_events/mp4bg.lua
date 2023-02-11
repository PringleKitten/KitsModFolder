function onEvent(name, value1, value2)
    if name == "mp4bg" then
        callScript('scripts/videoSprite', 'makeVideoSprite', {'video1', value1, -320, -180, 'camHUD'});
    end
end