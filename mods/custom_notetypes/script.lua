-- Script made by Catbrother Everything with help by NardBruh. Credit is not needed but would be nice! :)
function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('Pico', 'idle');
	end
end

lastNote = {0, ""}

function opponentNoteHit(id,d,t,s)

    lastNote[1] = d
    lastNote[2] = t
    
    if lastNote[2] == "3rd_Player" then -- Change "No Animation" to be your note type, usually you can just keep it as no anim assuming you arent using it elsewhere
	objectPlayAnimation('Pico', lastNote[1]);
    end
end