local camzoom = false;
local v1 = 0
local v2 = 0

function getVarr(bu)
   bugged = bu
end

function onEvent(name, value1, value2)
   if name == 'CustomZoom Up' then
      value1 = tonumber(value1)
      value2 = tonumber(value2)
      v1 = value1
      v2 = value2
      if camzoom == false then
         camzoom = true
         runTimer("zoomCam", 0.025)
      elseif camzoom == true then
         camzoom = false
      end
      if bugged then
         v1 = (v1/2)
         v2 = (v2/2)
      end
      fpss = getPropertyFromClass('flixel.FlxG', 'drawFramerate')
      if not bugged and fpss > 230 then
         v1 = value1
         v2 = value2
      elseif not bugged and fpss > 178 and fpss < 210 then
         v1 = (value1/1.3)
         v2 = (value2/1.3)
      elseif not bugged and fpss > 130 and fpss < 175 then
         v1 = (value1/1.5)
         v2 = (value2/1.5)
      elseif not bugged and fpss > 90 and fpss < 130 then
            v1 = (value1/1.7)
            v2 = (value2/1.7)
      elseif not bugged and fpss < 90 then
         v1 = (value1/1.9)
         v2 = (value2/1.9)
      end
   end
end

function onTimerCompleted(tag)
   if tag == 'zoomCam' then
      triggerEvent('Add Camera Zoom', v1, v2);
      if camzoom then
         runTimer("zoomCam", 0.025)
      end
   end
end