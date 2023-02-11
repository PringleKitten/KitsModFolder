local camzoom = false;

function onEvent(name, value1, value2)
   if name == 'Cam Zoom Toggle Small' then
   if camzoom == false then
   camzoom = true
   elseif camzoom == true then
   camzoom = false
   end
   end
end

function onBeatHit()
   if camzoom == true then
   triggerEvent('Add Camera Zoom', 0.08, 0.035);
   end
end