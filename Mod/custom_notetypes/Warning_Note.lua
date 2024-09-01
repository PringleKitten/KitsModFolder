function onCreate()
    --Iterate over all notes
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Warning_Note' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'me/notes/Warning_Note'); --Change texture
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.6); --Change amount of health to take when you miss
        end
    end
end