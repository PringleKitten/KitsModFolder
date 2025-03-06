function makeVideoSprite(tag, videoPath,camera,zoom)
    amieven = getProperty('camZooming')
    startVideo(videoPath)
    setObjectCamera('videoCutscene',camera)
    screenCenter(videoPath)
    setProperty('canPause', true)
    setProperty('inCutscene', false)
    setProperty("camZooming", true)
    setProperty('camGame.zoom',zoom)
    setProperty('defaultCamZoom',zoom)
    setProperty("camZooming", amieven)
end

function onDestroy()
    setProperty('inCutscene', false);
    callMethod('remove', {instanceArg('videoCutscene'), true})
    removeLuaSprite("videoCutscene")
    setProperty('canPause', true)
end
function onPause()
    callMethod('videoCutscene.pause')
end

function onResume()
    callMethod('videoCutscene.resume')
end