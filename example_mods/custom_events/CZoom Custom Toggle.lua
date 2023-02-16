local camzoom = false;
local v1 = 0
local v2 = 0
function onEvent(name, value1, value2)
   if name == 'CZoom Custom Toggle' then
      value1 = tonumber(value1)
      value2 = tonumber(value2)
      v1 = value1
      v2 = value2
      if camzoom == false then
         camzoom = true
      elseif camzoom == true then
         camzoom = false
      end
   end
end

function onBeatHit()
   if camzoom == true then
      triggerEvent('Add Camera Zoom', v1, v2);
   end
end