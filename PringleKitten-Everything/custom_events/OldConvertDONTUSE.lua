local c1 = false;
local c2 = false
function onEvent(name, value1, value2)
   if name == "OldConvertDONTUSE" then
      value1 = tonumber(value1)
      value2 = tonumber(value2)
      if value1 == 1 then
         if c1 == false then
            c1 = true
         else
            c1 = false
         end
      elseif value1 == 2 then
         if c2 == false then
            c2 = true
         else
            c2 = false
         end
      end
   end
end

function onBeatHit()
   if c1 == true then
      triggerEvent('Add Camera Zoom', 0.03, 0.05);
   end
   if c2 == true then
      triggerEvent('Add Camera Zoom', 0.1, 0.1);
   end
end