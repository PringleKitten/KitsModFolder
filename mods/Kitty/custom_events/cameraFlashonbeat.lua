c = 'FFFFFF'
s = 0.8
function onEvent(n,v1,v2)
    if n == 'cameraFlashonbeat' then
        if not run then
            run = true
        else
            run = false
        end
        if v1 ~= '' then
            c = v1
        end
        if v2 ~= '' then
            s = tonumber(v2)
        end
    end
end

function onBeatHit()
    if run then
        cameraFlash('game','0xFF'..c,s,true)
    end
end