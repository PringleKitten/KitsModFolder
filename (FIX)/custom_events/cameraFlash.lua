c = 'FFFFFF'
s = 0.8
function onEvent(n,v1,v2)
    if n == 'cameraFlash' then
        if v1 ~= '' then
            c = v1
        end
        if v2 ~= '' then
            s = tonumber(v2)
        end
        cameraFlash('game','0xFF'..c,s,true)
    end
end