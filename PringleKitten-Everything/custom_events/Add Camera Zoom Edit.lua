function onEvent(name, value1, value2)
   if name == 'Add Camera Zoom Edit' then
      v1 = tonumber(value1)
      v2 = tonumber(value2)
      setProperty('camGame.zoom',getProperty("camGame.zoom")+v2)
      setProperty('camHUD.zoom',getProperty("camHUD.zoom")+v1)
   end
end