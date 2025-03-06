function onCreate()
    --Iterate over all notes
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Down_Note_Alt' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'me/notes/Down_Note_Alt'); --Change texture
        end
    end
end