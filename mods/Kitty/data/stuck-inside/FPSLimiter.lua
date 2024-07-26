local limit = 120

--Edit limit variable to whatever you want

function onCreate()
  fps = getPropertyFromClass('ClientPrefs', 'framerate')
  if fps > limit then
    setPropertyFromClass('ClientPrefs', 'framerate', limit)
  end
end

function onDestroy()
  setPropertyFromClass('ClientPrefs', 'framerate', fps)
end
--This is set based off my performance, change it if you don't want to limit fps