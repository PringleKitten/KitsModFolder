function onResume()
    callMethod('videoCutscene.resume')
end
function onPause()
    callMethod('videoCutscene.pause')
end
function makeVideoSprite(tag, videoPath,camera,zoom)
    startVideo(videoPath, false, true)
    setObjectCamera('videoCutscene',camera)
    if camera == 'hud' then
        setProperty('camHUD.zoom',zoom)
        setProperty('defaultCamUIZoom',zoom)
    elseif camera == 'game' then
        setProperty('camGame.zoom',zoom)
        setProperty('defaultCamZoom',zoom)
    elseif camera == 'other' then
        setProperty('camOther.zoom',zoom)
    end
end
function onDestroy()
    close()
end
function performanceD()
	close()
end