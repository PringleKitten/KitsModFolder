function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'bf' then
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.023'); --Default value is: 0.023, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.2'); --Default value is: 0.0475, health lost on miss
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
	waitbf = 0.1
	--debugPrint('Script started!')
end

-- Function called when you hit a note (after note hit calculations)
-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
-- noteType: The note type string/tag
-- isSustainNote: If it's a hold note, can be either true or false

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'bf' then
	 --[[setProperty('camFollow.x', getProperty('bf.x')+400);
	 --Uncomment This To Move The Camera Towards Your Char. You Can Edit The Above Number]]--
	 if direction == 2 then
	 objectPlayAnimation('bf', 'singUP0', true)
	 setProperty('bf.offset.x', -6)
	 setProperty('bf.offset.y', 151)
	 end
	 if direction == 1 then
	 objectPlayAnimation('bf', 'singDOWN0', true)
	 setProperty('bf.offset.x', -101)
	 setProperty('bf.offset.y', -35)
	 end
	 if direction == 0 then
	 objectPlayAnimation('bf', 'singLEFT0', true)
	 setProperty('bf.offset.x', -8)
	 setProperty('bf.offset.y', 25)
	 end
	 if direction == 3 then
	 objectPlayAnimation('bf', 'singRIGHT0', true)
	 setProperty('bf.offset.x', 144)
	 setProperty('bf.offset.y', -91)
	 end
	end
end