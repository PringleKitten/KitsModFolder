--Function 2
function onBeatHit() --Each beat do...
    if difficulty == 5 then --If Insane difficulty do...
        if curStep >= 944 and curStep < 1968 then --if song is in cutStep () do...
            health = getProperty('health') --Hurt player VV
            if getProperty('health') > 0.2 then
               setProperty('health', health- 0.05);
             end
        end --End curStep checker
        if curStep >= 2720 and curStep < 3744 then --New curStep checker
            health = getProperty('health')
            if getProperty('health') > 0.2 then
                setProperty('health', health- 0.05);
            end
        end --End curStep checker
    end --End difficulty checker
end --End this function
--


--Function 3