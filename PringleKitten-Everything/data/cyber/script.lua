--Function 1
--Start
function opponentNoteHit()
    if difficulty <= 3 then --Expert+ mode or Lower but greater than Se mode
        if difficulty >= 1 then 
            health = getProperty('health')
            if getProperty('health') > 0.1 then
                setProperty('health', health- 0.01);
            end
        end
    elseif difficulty == 6 then --Insane mode
            health = getProperty('health')
            if getProperty('health') > 0.1 then
                setProperty('health', health- 0.2);
            end
    end --End Function --End If()
end --End function
--End

--Function 2