function opponentNoteHit()
        if difficulty >= 2 then
            health = getProperty('health')
            if getProperty('health') > 0.3 then
                setProperty('health', health- 0.014);
            end
        end
end

function goodNoteHit()        
    if difficulty >= 2 then
        health = getProperty('health')
    if getProperty('health') > 0.3 then
        setProperty('health', health+ 0.04);
    end
end
end