function onUpdatePost()
    if not mechanicsAgain then
        close()
    end
    setProperty('camOne.x', getProperty("camOther.x"))
    setProperty('camOne.y', getProperty("camOther.y"))
    setProperty('camOne.zoom', getProperty('camHUD.zoom'))
    setProperty('camTwo.flashSprite.scaleX', 2)
    setProperty('camTwo.flashSprite.scaleY', 2)
    setProperty('camTwo.zoom', 0.5 * getProperty('camHUD.zoom'))
end
function onCountdownTick()
    runHaxeCode([[
        for (spr in game.members)
        {
            if (spr != null && Std.isOfType(spr, FlxSprite) && spr.graphic != null)
            {
                if (spr.graphic.key.indexOf('ready') != -1 || spr.graphic.key.indexOf('set') != -1 || spr.graphic.key.indexOf('go') != -1)
                {
                    spr.cameras = [camOne];
                }
            }
        }
    ]])
end
function onEvent(e,a,b)
    if e == '' then
        if a == 'sv' then
            local vt = {}
            for value in string.gmatch(b, '([^,]+)') do
                local number = loadstring("return " .. value)()
                table.insert(vt, number)
            end
            if vt[1] and vt[2] then
                setProperty('camTwo.y', -vt[1])
                doTweenY('sv', 'camTwo', getProperty('camTwo.y')+vt[1] , vt[2], 'linear')
            end
        end
    end
end
function onCountdownStarted()
    runHaxeCode([[
        comboGroup.cameras = [camOne];
        for (note in game.notes) {
            note.camera = game.camTwo;
        }
        for (note in game.unspawnNotes) {
            note.camera = game.camTwo;
        }
        for (i in 0...4) {
            playerStrums.members[i].cameras = [camOne];
        }
        grpNoteSplashes.cameras = [camOne];
    ]])
end