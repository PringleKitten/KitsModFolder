function onEvent(name, value1, value2)
    if name == "HideNotes" then
        if not ran then
            ran = false
        end
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
        elseif value1 == '1+' then
            if ran then
                noteTweenAlpha("o1",0,1,0.5,"quartInOut");
                noteTweenAlpha("o2",1,1,0.5,"quartInOut");
                noteTweenAlpha("o3",2,1,0.5,"quartInOut");
                noteTweenAlpha("o4",3,1,0.5,"quartInOut");
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
        elseif value1 == '2+' then
            if ran then
                noteTweenAlpha("o5",4,0.5,0.5,"quartInOut");
                noteTweenAlpha("o6",5,0.5,0.5,"quartInOut");
                noteTweenAlpha("o7",6,0.5,0.5,"quartInOut");
                noteTweenAlpha("o8",7,0.5,0.5,"quartInOut");
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
        elseif value1 == '0+' then
            noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
            noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
            
            
            ran = false
        end
        if value2 == 0 then
            noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
            noteTweenAlpha("o1",0,0.5,0.5,"quartInOut");
            noteTweenAlpha("o2",1,0.5,0.5,"quartInOut");
            noteTweenAlpha("o3",2,0.5,0.5,"quartInOut");
            noteTweenAlpha("o4",3,0.5,0.5,"quartInOut");
            
            
            ran = false
        elseif value2 == '0+' then
            noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
            noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
            
            
            ran = false
        elseif value2 == 1 then
            if ran then
                noteTweenAlpha("oo1",0,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo2",1,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo3",2,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo4",3,0.5,0.5,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("oo1",0,0,0.5,"quartInOut");
                noteTweenAlpha("oo2",1,0,0.5,"quartInOut");
                noteTweenAlpha("oo3",2,0,0.5,"quartInOut");
                noteTweenAlpha("oo4",3,0,0.5,"quartInOut");
                ran = true
                
            end
        elseif value2 == '1+' then
            if ran then
                noteTweenAlpha("oo1",0,1,0.5,"quartInOut");
                noteTweenAlpha("oo2",1,1,0.5,"quartInOut");
                noteTweenAlpha("oo3",2,1,0.5,"quartInOut");
                noteTweenAlpha("oo4",3,1,0.5,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("oo1",0,0,0.5,"quartInOut");
                noteTweenAlpha("oo2",1,0,0.5,"quartInOut");
                noteTweenAlpha("oo3",2,0,0.5,"quartInOut");
                noteTweenAlpha("oo4",3,0,0.5,"quartInOut");
                ran = true
                
            end
        elseif value2 == 2 then
            if ran then
                noteTweenAlpha("oo5",4,1,0.5,"quartInOut");
                noteTweenAlpha("oo6",5,1,0.5,"quartInOut");
                noteTweenAlpha("oo7",6,1,0.5,"quartInOut");
                noteTweenAlpha("oo8",7,1,0.5,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("oo5",4,0,0.5,"quartInOut");
                noteTweenAlpha("oo6",5,0,0.5,"quartInOut");
                noteTweenAlpha("oo7",6,0,0.5,"quartInOut");
                noteTweenAlpha("oo8",7,0,0.5,"quartInOut");
                ran = true
                
            end
        elseif value2 == '2+' then
            if ran then
                noteTweenAlpha("oo5",4,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo6",5,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo7",6,0.5,0.5,"quartInOut");
                noteTweenAlpha("oo8",7,0.5,0.5,"quartInOut");
                ran = false
                
            else
                noteTweenAlpha("oo5",4,0,0.5,"quartInOut");
                noteTweenAlpha("oo6",5,0,0.5,"quartInOut");
                noteTweenAlpha("oo7",6,0,0.5,"quartInOut");
                noteTweenAlpha("oo8",7,0,0.5,"quartInOut");
                ran = true
                
            end
        end
        local Pa = getPropertyFromGroup('notes', 4, 'alpha')
        local Oa = getPropertyFromGroup('notes', 0, 'alpha')
    end
end