function onCreate()
    --Iterate over all notes
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Flame_Note' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'me/notes/Flame_Note'); --Change texture
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 1); --Change amount of health to take when you miss
        end
    end
end
function noteMiss(id, direction, noteType, isSustainNote)
    if noteType == "Flame_Note" then
        characterPlayAnim('bf', 'hey', true)
    end
end