local doZoomBeat, camzBg, camzBgb, hudZooming, gameZooming, stopcam, stopui, anywayG, anywayU = false, false, false, false, false, false, false, false, false
local v1, v2 = 0, 0

function onUpdate()
    if gameZooming then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
    end
end

function onEvent(name, value1, value2)
    value1, value2 = tonumber(value1), tonumber(value2)
    if name == 'CZoom Custom Toggle' then
        doZoomBeat = not doZoomBeat
        v1, v2 = value1, value2
    elseif name == "nozoom" then
        local function setCamZoom(val, stop, anyway, prop)
            stop = val ~= 0
            anyway = val == 2
            setProperty(prop, val == 0)
            return stop, anyway
        end
        stopcam, anywayG = setCamZoom(value1, stopcam, anywayG, 'camZoomsBg')
        stopui, anywayU = setCamZoom(value2, stopui, anywayU, 'camZoomsHud')
    elseif name == "Add Camera Zoom" then
        if stopcam and anywayG then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + value1)
        end
        if stopui and anywayU then
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + value2)
        end        
    elseif name == "Set_Cam_Zoom" or name == "setcamzoomb" then
        local isSetCamZoom = name == "Set_Cam_Zoom"
        if value2 == nil or value2 < 0.012 then
            setProperty('camGame.zoom', value1)
            setProperty('defaultCamZoom', value1)
        else
            local ocamz = isSetCamZoom and 'ocamzBg' or 'ocamzBgb'
            if gameZooming then
                setProperty('defaultCamZoom', getProperty('camGame.zoom'))
                setProperty('camZoomsBg', _G[ocamz])
                gameZooming = false
            else
                _G[ocamz] = getProperty('camZoomsBg')
            end
            _G[isSetCamZoom and 'camzBg' or 'camzBgb'] = getProperty('camZoomsBg')
            setProperty('camZoomsBg', false)
            local duration = isSetCamZoom and value2 or ((value2 + 1) * (60 / getPropertyFromClass('backend.Conductor', 'bpm')) * 250) / 1000
            doTweenZoom(isSetCamZoom and 'camzs' or 'camzb', 'camGame', value1, duration, 'sineInOut')
            gameZooming = true
        end
    end
end

function onTweenCompleted(name)
    if name == 'camzs' or name == 'camzb' then
        gameZooming = false
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
        setProperty('camZoomsBg', name == 'camzs' and camzBg or camzBgb)
    end
end

function onBeatHit()
    if doZoomBeat then
        local vv1 = hudZooming and 0 or ((stopui and anywayU) or not stopui) and v1 or 0
        local vv2 = gameZooming and 0 or ((stopcam and anywayG) or not stopcam) and v2 or 0
        setProperty('camGame.zoom', getProperty("camGame.zoom") + vv2)
        setProperty('camHUD.zoom', getProperty("camHUD.zoom") + vv1)
    end
end

function onDestroy()
    close(true)
end