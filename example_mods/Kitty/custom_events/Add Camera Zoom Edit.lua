function onEvent(name, value1, value2)
   if name == 'Add Camera Zoom Edit' then
      v1 = tonumber(value1) or 0
      v2 = tonumber(value2) or 0
      setProperty('camGame.zoom',getProperty("camGame.zoom")+v2)
      setProperty('camHUD.zoom',getProperty("camHUD.zoom")+v1)
   end
end