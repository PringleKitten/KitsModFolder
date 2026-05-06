function performanceD()
	close()
end
function makeVideoSprite(tag, videoPath,camera,zoom)
    amieven = getProperty('camZooming')
    startVideo(videoPath, false, true)
    setObjectCamera('videoCutscene',camera)
    screenCenter(videoPath)
    setProperty("camZooming", true)
    setProperty('camGame.zoom',zoom)
    setProperty('defaultCamZoom',zoom)
    setProperty("camZooming", amieven)
end

function onDestroy()
    close()
end
function onPause()
    callMethod('videoCutscene.pause')
end

function onResume()
    callMethod('videoCutscene.resume')
end