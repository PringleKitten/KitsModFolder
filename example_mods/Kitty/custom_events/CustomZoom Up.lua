local camzoom = false;
local v1 = 0
local v2 = 0

function onEvent(name, value1, value2)
   if name == 'CustomZoom Up' then
      v1 = tonumber(value1)
      v2 = tonumber(value2)
      if camzoom == false then
         camzoom = true
         runTimer("zoomCam", 0.025)
      elseif camzoom == true then
         camzoom = false
      end
   end
end

function onTimerCompleted(tag)
   if tag == 'zoomCam' then
      setProperty('camGame.zoom',getProperty("camGame.zoom")+v2)
      setProperty('camHUD.zoom',getProperty("camHUD.zoom")+v1)
      if camzoom then
         runTimer("zoomCam", 0.025)
      end
   end
end