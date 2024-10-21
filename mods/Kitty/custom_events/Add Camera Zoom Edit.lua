function getVarr(bu)
   bugged = bu
end

function onEvent(name, value1, value2)
   if name == 'Add Camera Zoom Edit' then
      value1 = tonumber(value1)
      value2 = tonumber(value2)
      v1 = value1
      v2 = value2
      if bugged then
         v1 = (value1/3.9)
         v2 = (value2/3.9)
      end
      fpss = getPropertyFromClass('flixel.FlxG', 'drawFramerate')
      if not bugged and fpss > 230 then
         v1 = value1
         v2 = value2
      elseif not bugged and fpss > 178 and fpss < 210 then
         v1 = (value1/1.3)
         v2 = (value2/1.3)
      elseif not bugged and fpss > 130 and fpss < 175 then
         v1 = (value1/1.7)
         v2 = (value2/1.7)
      elseif not bugged and fpss > 90 and fpss < 130 then
            v1 = (value1/2.7)
            v2 = (value2/2.7)
      elseif not bugged and fpss < 90 then
         v1 = (value1/3.8)
         v2 = (value2/3.8)
      end
      triggerEvent('Add Camera Zoom', v1, v2);
   end
end