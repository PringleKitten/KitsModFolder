local ran = false
local ran1 = false
local xx1 = false
local xx2 = false
local xx3 = false
local camzoomN = false
local camzoomS = false
local camzoomB = false
function onEvent(name, value1, value2)
    value1 = tonumber(value1);
    value2 = tonumber(value2);
   if name == "ArrowToggling" then
       if getPropertyFromClass('ClientPrefs', 'assetMovement') == true then
           --Change downscroll/upscroll
           if value1 == 1 then
               if ran then
                   for i=0,7 do
                       setPropertyFromGroup('opponentStrums',i,'downScroll',false)
                       setPropertyFromGroup('playerStrums',i,'downScroll',false)
                       noteTweenY("y1",0,50,0.15,"cubeInOut");
                       noteTweenY("y2",1,50,0.15,"cubeInOut");
                       noteTweenY("y3",2,50,0.15,"cubeInOut");
                       noteTweenY("y4",3,50,0.15,"cubeInOut");
                       noteTweenY("y5",4,50,0.15,"cubeInOut");
                       noteTweenY("y6",5,50,0.15,"cubeInOut");
                       noteTweenY("y7",6,50,0.15,"cubeInOut");
                       noteTweenY("y8",7,50,0.15,"cubeInOut");
                       setProperty('healthBar.y', 640)
                       setProperty('iconP1.y',570)
                       setProperty('iconP2.y', 570)
                       ran = false
                   end
               else
                   for i=0,7 do
                       setPropertyFromGroup('opponentStrums',i,'downScroll',true)
                       setPropertyFromGroup('playerStrums',i,'downScroll',true)
                       noteTweenY("y1",0,550,0.15,"cubeInOut");
                       noteTweenY("y2",1,550,0.15,"cubeInOut");
                       noteTweenY("y3",2,550,0.15,"cubeInOut");
                       noteTweenY("y4",3,550,0.15,"cubeInOut");
                       noteTweenY("y5",4,550,0.15,"cubeInOut");
                       noteTweenY("y6",5,550,0.15,"cubeInOut");
                       noteTweenY("y7",6,550,0.15,"cubeInOut");
                       noteTweenY("y8",7,550,0.15,"cubeInOut");
                       setProperty('healthBar.y', 110)
                       setProperty('iconP1.y', 40)
                       setProperty('iconP2.y', 40)
                       ran = true
                   end
               end
           else
               if value1 == 0 then
                   for i=0,7 do
                   setPropertyFromGroup('opponentStrums',i,'downScroll',false)
                   setPropertyFromGroup('playerStrums',i,'downScroll',false)
                   noteTweenY("y1",0,50,0.15,"cubeInOut");
                   noteTweenY("y2",1,50,0.15,"cubeInOut");
                   noteTweenY("y3",2,50,0.15,"cubeInOut");
                   noteTweenY("y4",3,50,0.15,"cubeInOut");
                   noteTweenY("y5",4,50,0.15,"cubeInOut");
                   noteTweenY("y6",5,50,0.15,"cubeInOut");
                   noteTweenY("y7",6,50,0.15,"cubeInOut");
                   noteTweenY("y8",7,50,0.15,"cubeInOut");
                   setProperty('healthBar.y', 640)
                   setProperty('iconP1.y',570)
                   setProperty('iconP2.y', 570)
                   ran = false
                   end
               else
                   if value1 == 10 then
                       if xx1 then
                           noteTweenX("x5",4,defaultPlayerStrumX0-323,0.1,"cubeInOut");
                           noteTweenX("x8",7,defaultPlayerStrumX3-323,0.1,"cubeInOut");
                           xx1 = false
                       else
                           noteTweenX("x5",4,defaultPlayerStrumX3-323,0.1,"cubeInOut");
                           noteTweenX("x8",7,defaultPlayerStrumX0-323,0.1,"cubeInOut");
                           xx1 = true
                       end
                   else
                       if value1 == 11 then
                           if xx2 then
                               noteTweenX("x6",5,defaultPlayerStrumX1-323,0.1,"cubeInOut");
                               noteTweenX("x7",6,defaultPlayerStrumX2-323,0.1,"cubeInOut");
                               xx2 = false
                           else
                               noteTweenX("x6",5,defaultPlayerStrumX2-323,0.1,"cubeInOut");
                               noteTweenX("x7",6,defaultPlayerStrumX1-323,0.1,"cubeInOut");
                              xx2 = true
                           end
                       else
                           if value1 == 12 then
                               if xx3 then
                                   noteTweenX("x5",4,defaultPlayerStrumX0-323,0.1,"cubeInOut");
                                   noteTweenX("x8",7,defaultPlayerStrumX3-323,0.1,"cubeInOut");
                                   noteTweenX("x6",5,defaultPlayerStrumX1-323,0.1,"cubeInOut");
                                   noteTweenX("x7",6,defaultPlayerStrumX2-323,0.1,"cubeInOut");
                                   xx3 = false
                               else
                                   noteTweenX("x5",4,defaultPlayerStrumX3-323,0.1,"cubeInOut");
                                   noteTweenX("x8",7,defaultPlayerStrumX0-323,0.1,"cubeInOut");
                                   noteTweenX("x6",5,defaultPlayerStrumX2-323,0.1,"cubeInOut");
                                   noteTweenX("x7",6,defaultPlayerStrumX1-323,0.1,"cubeInOut");
                                   xx3 = true
                               end
                           end
                       end
                   end
               end
           end
       -- Swap sides with opponent
           if value2 == 1 then 
               if ran1 then
                  noteTweenX("x1",0,defaultOpponentStrumX0,0.2,"cubeInOut");
                  noteTweenX("x2",1,defaultOpponentStrumX1,0.2,"cubeInOut");
                  noteTweenX("x3",2,defaultOpponentStrumX2,0.2,"cubeInOut");
                  noteTweenX("x4",3,defaultOpponentStrumX3,0.2,"cubeInOut");
                  noteTweenX("x5",4,defaultPlayerStrumX0,0.2,"cubeInOut");
                  noteTweenX("x6",5,defaultPlayerStrumX1,0.2,"cubeInOut");
                  noteTweenX("x7",6,defaultPlayerStrumX2,0.2,"cubeInOut");
                  noteTweenX("x8",7,defaultPlayerStrumX3,0.2,"cubeInOut");
                  ls = false
                  mdsc = false
                  ran1 = false
               else
                  noteTweenX("x1",0,defaultPlayerStrumX0,0.2,"cubeInOut");
                  noteTweenX("x2",1,defaultPlayerStrumX1,0.2,"cubeInOut");
                  noteTweenX("x3",2,defaultPlayerStrumX2,0.2,"cubeInOut");
                  noteTweenX("x4",3,defaultPlayerStrumX3,0.2,"cubeInOut");
                  noteTweenX("x5",4,defaultOpponentStrumX0,0.2,"cubeInOut");
                  noteTweenX("x6",5,defaultOpponentStrumX1,0.2,"cubeInOut");
                  noteTweenX("x7",6,defaultOpponentStrumX2,0.2,"cubeInOut");
                  noteTweenX("x8",7,defaultOpponentStrumX3,0.2,"cubeInOut");
                  ls = true
                  mdsc = false
                  ran1 = true
               end
            elseif value2 == 0 then
               noteTweenX("x1",0,defaultOpponentStrumX0,0.2,"cubeInOut");
               noteTweenX("x2",1,defaultOpponentStrumX1,0.2,"cubeInOut");
               noteTweenX("x3",2,defaultOpponentStrumX2,0.2,"cubeInOut");
               noteTweenX("x4",3,defaultOpponentStrumX3,0.2,"cubeInOut");
               noteTweenX("x5",4,defaultPlayerStrumX0,0.2,"cubeInOut");
               noteTweenX("x6",5,defaultPlayerStrumX1,0.2,"cubeInOut");
               noteTweenX("x7",6,defaultPlayerStrumX2,0.2,"cubeInOut");
               noteTweenX("x8",7,defaultPlayerStrumX3,0.2,"cubeInOut");
               ls = false
               mdsc = false
               ran1 = false 
            elseif value2 == 60 then
               lk = false
               mdsc = false
               ran1 = false 
               cancelTween('defaultOpponentStrumY0')
               cancelTween('defaultOpponentStrumY1')
               cancelTween('defaultOpponentStrumY2')
               cancelTween('defaultOpponentStrumY3')
               cancelTween('defaultPlayerStrumY0')
               cancelTween('defaultPlayerStrumY1')
               cancelTween('defaultPlayerStrumY2')
               cancelTween('defaultPlayerStrumY3')
               cancelTween('defaultOpponentStrumX0')
               cancelTween('defaultOpponentStrumX1')
               cancelTween('defaultOpponentStrumX2')
               cancelTween('defaultOpponentStrumX3')
               cancelTween('defaultPlayerStrumX0')
               cancelTween('defaultPlayerStrumX1')
               cancelTween('defaultPlayerStrumX2')
               cancelTween('defaultPlayerStrumX3')
               noteTweenX("x1",0,defaultOpponentStrumX0,0.2,"cubeInOut");
               noteTweenX("x2",1,defaultOpponentStrumX1,0.2,"cubeInOut");
               noteTweenX("x3",2,defaultOpponentStrumX2,0.2,"cubeInOut");
               noteTweenX("x4",3,defaultOpponentStrumX3,0.2,"cubeInOut");
               noteTweenX("x5",4,defaultPlayerStrumX0,0.2,"cubeInOut");
               noteTweenX("x6",5,defaultPlayerStrumX1,0.2,"cubeInOut");
               noteTweenX("x7",6,defaultPlayerStrumX2,0.2,"cubeInOut");
               noteTweenX("x8",7,defaultPlayerStrumX3,0.2,"cubeInOut");
               noteTweenY("y1",0,defaultOpponentStrumY0,0.2,"cubeInOut");
               noteTweenY("y2",1,defaultOpponentStrumY1,0.2,"cubeInOut");
               noteTweenY("y3",2,defaultOpponentStrumY2,0.2,"cubeInOut");
               noteTweenY("y4",3,defaultOpponentStrumY3,0.2,"cubeInOut");
               noteTweenY("y5",4,defaultPlayerStrumY0,0.2,"cubeInOut");
               noteTweenY("y6",5,defaultPlayerStrumY1,0.2,"cubeInOut");
               noteTweenY("y7",6,defaultPlayerStrumY2,0.2,"cubeInOut");
               noteTweenY("y8",7,defaultPlayerStrumY3,0.2,"cubeInOut");
               noteTweenAlpha("o1",0,1,0.2,"quartInOut");
               noteTweenAlpha("o2",1,1,0.2,"quartInOut");
               noteTweenAlpha("o3",2,1,0.2,"quartInOut");
               noteTweenAlpha("o4",3,1,0.2,"quartInOut");
           elseif value2 == 3 then
               noteTweenAlpha("o1",0,0,0.5,"quartInOut");
               noteTweenAlpha("o2",1,0,0.5,"quartInOut");
               noteTweenAlpha("o3",2,0,0.5,"quartInOut");
               noteTweenAlpha("o4",3,0,0.5,"quartInOut");
               noteTweenX("x1",0,defaultOpponentStrumX0+75,0.2,"cubeInOut");
               noteTweenX("x2",1,defaultOpponentStrumX1+75,0.2,"cubeInOut");
               noteTweenX("x3",2,defaultPlayerStrumX2-79,0.2,"cubeInOut");
               noteTweenX("x4",3,defaultPlayerStrumX3-79,0.2,"cubeInOut");

               noteTweenX("x5",4,defaultPlayerStrumX0-323,0.2,"cubeInOut");
               noteTweenX("x6",5,defaultPlayerStrumX1-323,0.2,"cubeInOut");
               noteTweenX("x7",6,defaultPlayerStrumX2-323,0.2,"cubeInOut");
               noteTweenX("x8",7,defaultPlayerStrumX3-323,0.2,"cubeInOut");
               ls = false
               mdsc = true
         end
      end
   end
   if value2 == 90 then
       lk = true
   elseif value2 == 91 then
       lk = false
       cancelTween('defaultOpponentStrumY0')
       cancelTween('defaultOpponentStrumY1')
       cancelTween('defaultOpponentStrumY2')
       cancelTween('defaultOpponentStrumY3')
       cancelTween('defaultPlayerStrumY0')
       cancelTween('defaultPlayerStrumY1')
       cancelTween('defaultPlayerStrumY2')
       cancelTween('defaultPlayerStrumY3')
       cancelTween('defaultOpponentStrumX0')
       cancelTween('defaultOpponentStrumX1')
       cancelTween('defaultOpponentStrumX2')
       cancelTween('defaultOpponentStrumX3')
       cancelTween('defaultPlayerStrumX0')
       cancelTween('defaultPlayerStrumX1')
       cancelTween('defaultPlayerStrumX2')
       cancelTween('defaultPlayerStrumX3')
   end
   if name == 'Cam Zoom Toggle B' then
    if camzoomB == false then
        camzoomB = true
    elseif camzoomB == true then
        camzoomB = false
    end
   end
    if name == 'Cam Zoom Toggle Small' then
        if camzoomS == false then
            camzoomS = true
        elseif camzoomS == true then
            camzoomS = false
        end
    end
    if name == 'Cam Zoom Toggle' then
        if camzoomN == false then
            camzoomN = true
        elseif camzoomN == true then
            camzoomN = false
        end
    end
end

function onBeatHit()
    if camzoomB == true then
        triggerEvent('Add Camera Zoom', 0.24, 0.18);
        health = getProperty('health')
        setProperty('health', health- 0.08);
        characterPlayAnim('bf', 'idle', true);
     end
     if camzoomS == true then
        triggerEvent('Add Camera Zoom', 0.08, 0.035);
    end
    if camzoomN == true then
        triggerEvent('Add Camera Zoom', 0.24, 0.1);
    end
end
--eww onUpdate crap
function onUpdate()
   if lk and not ls and not mdsc then
       songPos = getSongPosition()
       local currentBeat = (songPos/5000)*(curBpm/60)
       noteTweenY('defaultOpponentStrumY0', 0, defaultPlayerStrumY0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY1', 1, defaultPlayerStrumY1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY2', 2, defaultPlayerStrumY2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY3', 3, defaultPlayerStrumY3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX0', 0, defaultPlayerStrumX0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX1', 1, defaultPlayerStrumX1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX2', 2, defaultPlayerStrumX2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX3', 3, defaultPlayerStrumX3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX0', 4, defaultPlayerStrumX0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX1', 5, defaultPlayerStrumX1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX2', 6, defaultPlayerStrumX2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX3', 7, defaultPlayerStrumX3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
   end
   if lk and mdsc and not ls then
       songPos = getSongPosition()
       local currentBeat = (songPos/5000)*(curBpm/60)
       noteTweenY('defaultOpponentStrumY0', 0, defaultPlayerStrumY0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY1', 1, defaultPlayerStrumY1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY2', 2, defaultPlayerStrumY2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY3', 3, defaultPlayerStrumY3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY0', 4, defaultPlayerStrumY0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY1', 5, defaultPlayerStrumY1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY2', 6, defaultPlayerStrumY2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY3', 7, defaultPlayerStrumY3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX0', 0, defaultPlayerStrumX0+323 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX1', 1, defaultPlayerStrumX1+323 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX2', 2, defaultPlayerStrumX2+323 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX3', 3, defaultPlayerStrumX3+323 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX0', 4, defaultPlayerStrumX0-323 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX1', 5, defaultPlayerStrumX1-323 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX2', 6, defaultPlayerStrumX2-323 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX3', 7, defaultPlayerStrumX3-323 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
   end
   if lk and ls and not mdsc then
       songPos = getSongPosition()
       local currentBeat = (songPos/5000)*(curBpm/60)
       noteTweenY('defaultPlayerStrumY0', 0, defaultOpponentStrumY0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY1', 1, defaultOpponentStrumY1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY2', 2, defaultOpponentStrumY2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenY('defaultPlayerStrumY3', 3, defaultOpponentStrumY3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY0', 4, defaultOpponentStrumY0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY1', 5, defaultOpponentStrumY1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY2', 6, defaultOpponentStrumY2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenY('defaultOpponentStrumY3', 7, defaultOpponentStrumY3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX0', 0, defaultOpponentStrumX0 - 50*math.sin((currentBeat+0*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX1', 1, defaultOpponentStrumX1 - 50*math.sin((currentBeat+1*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX2', 2, defaultOpponentStrumX2 - 50*math.sin((currentBeat+2*0.25)*math.pi), 0.5)
       noteTweenX('defaultPlayerStrumX3', 3, defaultOpponentStrumX3 - 50*math.sin((currentBeat+3*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX0', 4, defaultOpponentStrumX0 - 50*math.sin((currentBeat+4*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX1', 5, defaultOpponentStrumX1 - 50*math.sin((currentBeat+5*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX2', 6, defaultOpponentStrumX2 - 50*math.sin((currentBeat+6*0.25)*math.pi), 0.5)
       noteTweenX('defaultOpponentStrumX3', 7, defaultOpponentStrumX3 - 50*math.sin((currentBeat+7*0.25)*math.pi), 0.5)
   end
end

--@PringleKitten