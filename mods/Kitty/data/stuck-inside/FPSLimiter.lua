local fps = 60
function onSongStart()
  fps = getPropertyFromClass('flixel.FlxG', 'updateFramerate')
  setPropertyFromClass('flixel.FlxG', 'updateFramerate', 60)
  setPropertyFromClass('flixel.FlxG', 'drawFramerate', 60)
end

function onDestroy()
  setPropertyFromClass('flixel.FlxG', 'updateFramerate', fps)
  setPropertyFromClass('flixel.FlxG', 'drawFramerate', fps)
end
--This is set based off my performance, change it if you don't want to limit fps