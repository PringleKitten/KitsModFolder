function onCreate()
    --Iterate over all notes
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'invnote' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'me/notes/invnote'); --Change texture
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0); --Change amount of health to take when you miss
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
        end
    end
end