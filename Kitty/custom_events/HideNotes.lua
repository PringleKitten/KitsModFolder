function onEvent(name, value1, value2)
    if name == "HideNotes" then
        voa = 0.5
        value1 = tonumber(value1);
        value2 = tonumber(value2);
        if songName == 'Octagon of Destiny' then
            voa = 0.2
        end
        if value1 == 1 then
            if ran then
                noteTweenAlpha("o1",0,0.5,voa,"quartInOut");
                noteTweenAlpha("o2",1,0.5,voa,"quartInOut");
                noteTweenAlpha("o3",2,0.5,voa,"quartInOut");
                noteTweenAlpha("o4",3,0.5,voa,"quartInOut");
                
                ran = false
            else
                noteTweenAlpha("o1",0,0,voa,"quartInOut");
                noteTweenAlpha("o2",1,0,voa,"quartInOut");
                noteTweenAlpha("o3",2,0,voa,"quartInOut");
                noteTweenAlpha("o4",3,0,voa,"quartInOut");
                ran = true
                
            end
        elseif value1 == 12 then
            noteTweenAlpha("o1",0,0,voa,"quartInOut");
            noteTweenAlpha("o2",1,0,voa,"quartInOut");
            noteTweenAlpha("o3",2,0,voa,"quartInOut");
            noteTweenAlpha("o4",3,0,voa,"quartInOut");
            ran = true
        elseif value1 == 11 then
            if ran then
                noteTweenAlpha("o1",0,1,voa,"quartInOut");
                noteTweenAlpha("o2",1,1,voa,"quartInOut");
                noteTweenAlpha("o3",2,1,voa,"quartInOut");
                noteTweenAlpha("o4",3,1,voa,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("o1",0,0,voa,"quartInOut");
                noteTweenAlpha("o2",1,0,voa,"quartInOut");
                noteTweenAlpha("o3",2,0,voa,"quartInOut");
                noteTweenAlpha("o4",3,0,voa,"quartInOut");
                ran = true
                
            end
        elseif value1 == 112 then
            noteTweenAlpha("o1",0,1,voa,"quartInOut");
            noteTweenAlpha("o2",1,1,voa,"quartInOut");
            noteTweenAlpha("o3",2,1,voa,"quartInOut");
            noteTweenAlpha("o4",3,1,voa,"quartInOut");
            ran = false
        elseif value1 == 2 then
            if ran then
                noteTweenAlpha("o5",4,1,voa,"quartInOut");
                noteTweenAlpha("o6",5,1,voa,"quartInOut");
                noteTweenAlpha("o7",6,1,voa,"quartInOut");
                noteTweenAlpha("o8",7,1,voa,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("o5",4,0,voa,"quartInOut");
                noteTweenAlpha("o6",5,0,voa,"quartInOut");
                noteTweenAlpha("o7",6,0,voa,"quartInOut");
                noteTweenAlpha("o8",7,0,voa,"quartInOut");
                ran = true
                
            end
        elseif value1 == 22 then
            if ran then
                noteTweenAlpha("o5",4,0.5,voa,"quartInOut");
                noteTweenAlpha("o6",5,0.5,voa,"quartInOut");
                noteTweenAlpha("o7",6,0.5,voa,"quartInOut");
                noteTweenAlpha("o8",7,0.5,voa,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("o5",4,0,voa,"quartInOut");
                noteTweenAlpha("o6",5,0,voa,"quartInOut");
                noteTweenAlpha("o7",6,0,voa,"quartInOut");
                noteTweenAlpha("o8",7,0,voa,"quartInOut");
                ran = true
                
            end
        elseif value1 == 222 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            ran = false
        elseif value1 == 0 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            noteTweenAlpha("o1",0,0.5,voa,"quartInOut");
            noteTweenAlpha("o2",1,0.5,voa,"quartInOut");
            noteTweenAlpha("o3",2,0.5,voa,"quartInOut");
            noteTweenAlpha("o4",3,0.5,voa,"quartInOut");
            
            
            ran = false
        elseif value1 == 100 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            noteTweenAlpha("o1",0,1,voa,"quartInOut");
            noteTweenAlpha("o2",1,1,voa,"quartInOut");
            noteTweenAlpha("o3",2,1,voa,"quartInOut");
            noteTweenAlpha("o4",3,1,voa,"quartInOut");
            
            
            ran = false
        end
        if value2 == 0 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            noteTweenAlpha("o1",0,0.5,voa,"quartInOut");
            noteTweenAlpha("o2",1,0.5,voa,"quartInOut");
            noteTweenAlpha("o3",2,0.5,voa,"quartInOut");
            noteTweenAlpha("o4",3,0.5,voa,"quartInOut");
            
            
            ran = false
            ran1 = false
        elseif value2 == 100 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            noteTweenAlpha("o1",0,1,voa,"quartInOut");
            noteTweenAlpha("o2",1,1,voa,"quartInOut");
            noteTweenAlpha("o3",2,1,voa,"quartInOut");
            noteTweenAlpha("o4",3,1,voa,"quartInOut");
            
            
            ran = false
            ran1 = false
        elseif value2 == 1 then
            if ran1 then
                noteTweenAlpha("oo1",0,0.5,voa,"quartInOut");
                noteTweenAlpha("oo2",1,0.5,voa,"quartInOut");
                noteTweenAlpha("oo3",2,0.5,voa,"quartInOut");
                noteTweenAlpha("oo4",3,0.5,voa,"quartInOut");
                ran1 = false
                
            else
                noteTweenAlpha("oo1",0,0,voa,"quartInOut");
                noteTweenAlpha("oo2",1,0,voa,"quartInOut");
                noteTweenAlpha("oo3",2,0,voa,"quartInOut");
                noteTweenAlpha("oo4",3,0,voa,"quartInOut");
                ran1 = true
                
            end
        elseif value2 == 12 then
            noteTweenAlpha("o1",0,0,voa,"quartInOut");
            noteTweenAlpha("o2",1,0,voa,"quartInOut");
            noteTweenAlpha("o3",2,0,voa,"quartInOut");
            noteTweenAlpha("o4",3,0,voa,"quartInOut");
            ran1 = true
        elseif value2 == 11 then
            if ran1 then
                noteTweenAlpha("oo1",0,1,voa,"quartInOut");
                noteTweenAlpha("oo2",1,1,voa,"quartInOut");
                noteTweenAlpha("oo3",2,1,voa,"quartInOut");
                noteTweenAlpha("oo4",3,1,voa,"quartInOut");
                ran1 = false
                
            else
                noteTweenAlpha("oo1",0,0,voa,"quartInOut");
                noteTweenAlpha("oo2",1,0,voa,"quartInOut");
                noteTweenAlpha("oo3",2,0,voa,"quartInOut");
                noteTweenAlpha("oo4",3,0,voa,"quartInOut");
                ran1 = true
                
            end
        elseif value2 == 112 then
            noteTweenAlpha("o1",0,1,voa,"quartInOut");
            noteTweenAlpha("o2",1,1,voa,"quartInOut");
            noteTweenAlpha("o3",2,1,voa,"quartInOut");
            noteTweenAlpha("o4",3,1,voa,"quartInOut");
            ran1 = false
        elseif value2 == 2 then
            if ran1 then
                noteTweenAlpha("oo5",4,1,voa,"quartInOut");
                noteTweenAlpha("oo6",5,1,voa,"quartInOut");
                noteTweenAlpha("oo7",6,1,voa,"quartInOut");
                noteTweenAlpha("oo8",7,1,voa,"quartInOut");
                ran1 = false
                
            else
                noteTweenAlpha("oo5",4,0,voa,"quartInOut");
                noteTweenAlpha("oo6",5,0,voa,"quartInOut");
                noteTweenAlpha("oo7",6,0,voa,"quartInOut");
                noteTweenAlpha("oo8",7,0,voa,"quartInOut");
                ran1 = true
                
            end
        elseif value2 == 22 then
            if ran1 then
                noteTweenAlpha("oo5",4,0.5,voa,"quartInOut");
                noteTweenAlpha("oo6",5,0.5,voa,"quartInOut");
                noteTweenAlpha("oo7",6,0.5,voa,"quartInOut");
                noteTweenAlpha("oo8",7,0.5,voa,"quartInOut");
                ran1 = false
                
            else
                noteTweenAlpha("oo5",4,0,voa,"quartInOut");
                noteTweenAlpha("oo6",5,0,voa,"quartInOut");
                noteTweenAlpha("oo7",6,0,voa,"quartInOut");
                noteTweenAlpha("oo8",7,0,voa,"quartInOut");
                ran1 = true
                
            end
        elseif value2 == 222 then
            noteTweenAlpha("o5",4,1,voa,"quartInOut");
            noteTweenAlpha("o6",5,1,voa,"quartInOut");
            noteTweenAlpha("o7",6,1,voa,"quartInOut");
            noteTweenAlpha("o8",7,1,voa,"quartInOut");
            ran1 = false
        end
        local Pa = getPropertyFromGroup('notes', 4, 'alpha')
        local Oa = getPropertyFromGroup('notes', 0, 'alpha')
    end
end