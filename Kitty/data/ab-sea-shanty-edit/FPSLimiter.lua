local fps = 120
function onSongStart()
  fps = getPropertyFromClass('flixel.FlxG', 'updateFramerate')
  setPropertyFromClass('flixel.FlxG', 'updateFramerate', 120)
  setPropertyFromClass('flixel.FlxG', 'drawFramerate', 120)
end

function onDestroy()
  setPropertyFromClass('flixel.FlxG', 'updateFramerate', fps)
  setPropertyFromClass('flixel.FlxG', 'drawFramerate', fps)
end
--This is set based off my performance, change it if you don't want to limit fps