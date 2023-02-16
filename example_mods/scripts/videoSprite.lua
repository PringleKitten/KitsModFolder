function onCreate()
    addHaxeLibrary('MP4Handler', 'vlc')
    addHaxeLibrary('Event', 'openfl.events')
end
local videoSprites = {}
function makeVideoSprite(tag, videoPath, x, y, camera)
    makeLuaSprite(tag, '', x, y)
    setObjectCamera(tag, camera)
    addLuaSprite(tag, false)
    scaleObject(tag, 0.667, 0.667)
    runHaxeCode([[
        ]]..tag..[[= new MP4Handler();
        ]]..tag..[[.playVideo(Paths.video("]]..videoPath..[["));
        ]]..tag..[[.visible = false; 
        FlxG.stage.removeEventListener("enterFrame", ]]..tag..[[.update);
        ]]..tag..[[.finishCallback = function()
            { 
                game.getLuaObject("]]..tag..[[").visible = false; 
            }

    ]])
    table.insert(videoSprites, tag)
    --debugPrint('bro the video has been started!')
end
function onUpdatePost()
    for _, __ in pairs(videoSprites) do
        runHaxeCode([[
            if (game.getLuaObject("]]..__..[[") != null)
            {
            game.getLuaObject("]]..__..[[").loadGraphic(]]..__..[[.bitmapData);
            ]]..__..[[.volume = FlxG.sound.volume + 0.4;
            }
        ]])
    end
end
function onPause()
    for _, __ in pairs(videoSprites) do
        runHaxeCode([[
            ]]..__..[[.pause();
        ]])
    end
end
function onResume()
    for _, __ in pairs(videoSprites) do
        runHaxeCode([[
            ]]..__..[[.resume();
        ]])
    end
end