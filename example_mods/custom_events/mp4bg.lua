function onEvent(name, value1, value2)
    if name == "mp4bg" then
        if value1 == 1 then
            callScript('scripts/videoSprite', 'makeVideoSprite', {value2, value1, -320, -180, 'camHUD'});
        elseif value1 == 2 then
            startVideo(value2)
            setProperty('inCutscene', false);
            startCountdown()
        end
    end
end