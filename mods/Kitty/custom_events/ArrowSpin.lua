function onEvent(name, value1, value2)
    if name == "ArrowSpin" then
        value1 = tonumber(value1);
        value2 = tonumber(value2);
    if value1 == 1 then
        noteTweenAngle("r1",0,360,value2, "quartInOut");
        noteTweenAngle("r2",1,360,value2, "quartInOut");
        noteTweenAngle("r3",2,360,value2, "quartInOut");
        noteTweenAngle("r4",3,360,value2, "quartInOut")
    elseif value1 == 2 then
        noteTweenAngle("r5",4,360,value2, "quartInOut");
        noteTweenAngle("r6",5,360,value2, "quartInOut");
        noteTweenAngle("r7",6,360,value2, "quartInOut");
        noteTweenAngle("r8",7,360,value2, "quartInOut")
    elseif value1 == 3 then
        noteTweenAngle("r1",0,360,value2, "quartInOut");
        noteTweenAngle("r2",1,360,value2, "quartInOut");
        noteTweenAngle("r3",2,360,value2, "quartInOut");
        noteTweenAngle("r4",3,360,value2, "quartInOut");
        noteTweenAngle("r5",4,360,value2, "quartInOut");
        noteTweenAngle("r6",5,360,value2, "quartInOut");
        noteTweenAngle("r7",6,360,value2, "quartInOut");
        noteTweenAngle("r8",7,360,value2, "quartInOut")
    end
end
end

function onTweenCompleted(tag)
    if tag == "r1" then
        noteTweenAngle("rr1",0,0,0.01, "quartInOut");
    elseif tag == "r2" then
        noteTweenAngle("rr2",1,0,0.01, "quartInOut");
    elseif tag == "r3" then
        noteTweenAngle("rr3",2,0,0.01, "quartInOut");
    elseif tag == "r4" then
        noteTweenAngle("rr4",3,0,0.01, "quartInOut");
    elseif tag == "r5" then
        noteTweenAngle("rr5",4,0,0.01, "quartInOut");
    elseif tag == "r6" then
        noteTweenAngle("rr6",5,0,0.01, "quartInOut");
    elseif tag == "r7" then
        noteTweenAngle("rr7",6,0,0.01, "quartInOut");
    elseif tag == "r8" then
        noteTweenAngle("rr8",7,0,0.01, "quartInOut")
    end
end