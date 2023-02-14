local ran = false
local ran1 = false
function onEvent(name, value1, value2)
    if name == "ArrowToggling" then
        if ClientPrefs.assetMovement == true then
        value1 = tonumber(value1);
        value2 = tonumber(value2);

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
            ran1 = false 
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
        end
    end
end
end