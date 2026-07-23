local stz = 0
local z2 = 0
local d2 = 0
local e2 = ''
local zh2 = 0
local dh2 = 0
local eh2 = ''
function onEvent(n,v1,v2)
    if n == '' then
        if v1 == 'zoomZ' then
            local args = {}
            for num in string.gmatch(v2, '([^,]+)') do
                table.insert(args, num:match("^%s*(.-)%s*$"))
            end
            local zoom1 = tonumber(args[1]) or getProperty('camGame.zoom')
            local duration1 = tonumber(args[2]) or 0
            local ease1 = args[3] or 'linear'
            local zoom2 = tonumber(args[4]) or nil
            local duration2 = tonumber(args[5]) or nil
            local ease2 = args[6] or 'linear'
            z2 = zoom2
            d2 = duration2
            e2 = ease2
            cancelTween('zz2')
            cancelTween('zz')
            if duration1 == 0 then
                setProperty('camGame.zoom', zoom1)
                doTweenZoom('zz', 'game', zoom2, duration2, ease2)
            else
                doTweenZoom('zz', 'game', zoom1, duration1, ease1)
            end
        end
        if v1 == 'zoomH' then
            local args = {}
            for num in string.gmatch(v2, '([^,]+)') do
                table.insert(args, num:match("^%s*(.-)%s*$"))
            end
            local zoom1 = tonumber(args[1]) or getProperty('camHUD.zoom')
            local duration1 = tonumber(args[2]) or 0
            local ease1 = args[3] or 'linear'
            local zoom2 = tonumber(args[4]) or nil
            local duration2 = tonumber(args[5]) or nil
            local ease2 = args[6] or 'linear'
            zh2 = zoom2
            dh2 = duration2
            eh2 = ease2
            cancelTween('cz')
            cancelTween('cz2')
            if duration1 == 0 then
                setProperty('camHUD.zoom', zoom1)
                doTweenZoom('cz', 'hud', zoom2, duration2, ease2)
            else
                doTweenZoom('cz', 'hud', zoom1, duration1, ease1)
            end
        end
        if v1 == 'sz2' then
            stz = stz+1
            setProperty('camGame.zoom', v2)
            doTweenZoom('sz2', 'game', 1, 0.3, 'sineOut')
            if stz == 2 then
                setProperty('camHUD.zoom', v2+.1)
                doTweenZoom('sz2h', 'hud', 1, 0.5, 'sineOut')
                stz = 0
            end
        end
    end
end
function onUpdate()
    setProperty('defaultCamZoom', getProperty('camGame.zoom'))
    setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
end
function onTweenCompleted(t)
    if t == 'zz' then
        if d2 == 0 then
            setProperty('camGame.zoom', z2)
        else
            doTweenZoom('zz2', 'game', z2, d2, e2)
        end
    end
    if t == 'cz' then
        if dh2 == 0 then
            setProperty('camHUD.zoom', zh2)
        else
            doTweenZoom('cz2', 'HUD', zh2, dh2, eh2)
        end
    end
    if t == 'sz' then
        doTweenZoom('cz', 'game', 1, 1.5, 'sineOut')
    end
end