local ran = false
function onEvent(name, value1, value2)
    if name == "HideNotes" then
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        if value1 == 1 then
            if ran then
                noteTweenAlpha("o1",0,0.5,0.5,"quartInOut");
                noteTweenAlpha("o2",1,0.5,0.5,"quartInOut");
                noteTweenAlpha("o3",2,0.5,0.5,"quartInOut");
                noteTweenAlpha("o4",3,0.5,0.5,"quartInOut");
                ran = false
            else
                noteTweenAlpha("o1",0,0,0.5,"quartInOut");
                noteTweenAlpha("o2",1,0,0.5,"quartInOut");
                noteTweenAlpha("o3",2,0,0.5,"quartInOut");
                noteTweenAlpha("o4",3,0,0.5,"quartInOut");
                ran = true
            end
        elseif value1 == 2 then
            if ran then
                noteTweenAlpha("o5",4,1,0.5,"quartInOut");
                noteTweenAlpha("o6",5,1,0.5,"quartInOut");
                noteTweenAlpha("o7",6,1,0.5,"quartInOut");
                noteTweenAlpha("o8",7,1,0.5,"quartInOut");
                ran = false
            else
                noteTweenAlpha("o5",4,0,0.5,"quartInOut");
                noteTweenAlpha("o6",5,0,0.5,"quartInOut");
                noteTweenAlpha("o7",6,0,0.5,"quartInOut");
                noteTweenAlpha("o8",7,0,0.5,"quartInOut");
                ran = true
            end
        elseif value1 == 0 then
            noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
            noteTweenAlpha("o1",0,0.5,0.5,"quartInOut");
            noteTweenAlpha("o2",1,0.5,0.5,"quartInOut");
            noteTweenAlpha("o3",2,0.5,0.5,"quartInOut");
            noteTweenAlpha("o4",3,0.5,0.5,"quartInOut");
            ran = false
        end
        if value2 == 1 then
            if ran then
                noteTweenAlpha("o1",0,0.5,0.5,"quartInOut");
                noteTweenAlpha("o2",1,0.5,0.5,"quartInOut");
                noteTweenAlpha("o3",2,0.5,0.5,"quartInOut");
                noteTweenAlpha("o4",3,0.5,0.5,"quartInOut");
                ran = false
            else
                noteTweenAlpha("o1",0,0,0.5,"quartInOut");
                noteTweenAlpha("o2",1,0,0.5,"quartInOut");
                noteTweenAlpha("o3",2,0,0.5,"quartInOut");
                noteTweenAlpha("o4",3,0,0.5,"quartInOut");
                ran = true
            end
        elseif value2 == 2 then
            if ran then
                noteTweenAlpha("o5",4,1,0.5,"quartInOut");
                noteTweenAlpha("o6",5,1,0.5,"quartInOut");
                noteTweenAlpha("o7",6,1,0.5,"quartInOut");
                noteTweenAlpha("o8",7,1,0.5,"quartInOut");
                ran = false
            else
                noteTweenAlpha("o5",4,0,0.5,"quartInOut");
                noteTweenAlpha("o6",5,0,0.5,"quartInOut");
                noteTweenAlpha("o7",6,0,0.5,"quartInOut");
                noteTweenAlpha("o8",7,0,0.5,"quartInOut");
                ran = true
            end
        end
    end
end