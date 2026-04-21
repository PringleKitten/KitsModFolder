function onCreate()
    setProperty("defaultCamZoom",0.8)
    doTweenZoom('camzA','camGame',0.8,0.1,'sineInOut')
end
function onTweenCompleted(name)
	if name == 'camzA' then
  		setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
	end
end