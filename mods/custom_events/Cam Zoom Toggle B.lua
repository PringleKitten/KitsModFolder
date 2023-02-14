local camzoom = false;

function onEvent(name, value1, value2)
   if name == 'Cam Zoom Toggle B' then
   if camzoom == false then
   camzoom = true
   elseif camzoom == true then
   camzoom = false
   end
   end
end

function onBeatHit()
   if camzoom == true then
      triggerEvent('Add Camera Zoom', 0.24, 0.18);
      health = getProperty('health')
      if ClientPrefs.healthDrain = true then
      setProperty('health', health- 0.08);
      end
      characterPlayAnim('bf', 'idle', true);
   end
end