function onEvent(name,value1, value2)
    if name == 'ArrowToggling' then
        value1 = tonumber(value1)
        value2 = tonumber(value2)
        if value2 == 0 or value2 == 60 then
            ran1 = false
            mdsc = false
        elseif value2 == 3 then
            mdsc = true
        elseif value2 == 1 then
            if ran1 then
                ls = false
                mdsc = false
                ran1 = false
            else
                ls = true
                mdsc = false
                ran1 = true
            end
        end
    end
    if name == 'moveonHit' then
        value1 = tonumber(value1)
        if value1 == 1 then
            k = true
        elseif value1 == 0 then
            k = false
        end
    end
end

function onUpdate()
    if k then
        if mdsc then
            if keyJustPressed('left') then
                noteTweenX("x5",4,defaultPlayerStrumX0-473,0.15,"bounceInOut");
            elseif keyJustPressed('down') then
                noteTweenY("y6",5,defaultPlayerStrumY1+100,0.15,"bounceInOut");
            elseif keyJustPressed('up') then
                noteTweenY("y7",6,defaultPlayerStrumY2-100,0.15,"bounceInOut");
            elseif keyJustPressed('right') then
                noteTweenX("x8",7,defaultPlayerStrumX3-173,0.15,"bounceInOut");
            end
        elseif ls then
            if keyJustPressed('left') then
                noteTweenX("xx5",4,defaultOpponentStrumX0-150,0.15,"bounceInOut");
            elseif keyJustPressed('down') then
                noteTweenY("yy6",5,defaultOpponentStrumY1+100,0.15,"bounceInOut");
            elseif keyJustPressed('up') then
                noteTweenY("yy7",6,defaultOpponentStrumY2-100,0.15,"bounceInOut");
            elseif keyJustPressed('right') then
                noteTweenX("xx8",7,defaultOpponentStrumX3+150,0.15,"bounceInOut");
            end
        else
            if keyJustPressed('left') then
                noteTweenX("xxx5",4,defaultPlayerStrumX0-150,0.15,"bounceInOut");
            elseif keyJustPressed('down') then
                noteTweenY("yyy6",5,defaultPlayerStrumY1+100,0.15,"bounceInOut");
            elseif keyJustPressed('up') then
                noteTweenY("yyy7",6,defaultPlayerStrumY2-100,0.15,"bounceInOut");
            elseif keyJustPressed('right') then
                noteTweenX("xxx8",7,defaultPlayerStrumX3+150,0.15,"bounceInOut");
            end 
        end    
    end
end

function onTweenCompleted(tag)
    if mdsc then
        if tag == 'x5' then
            noteTweenX('x5',4,defaultPlayerStrumX0-323,0.25,"bounceInOut");
            noteTweenY('y5',4,defaultPlayerStrumY0,0.25,"bounceInOut");
        elseif tag == 'y6' then
            noteTweenY("y6",5,defaultPlayerStrumY1,0.25,"bounceInOut");
            noteTweenX("x6",5,defaultPlayerStrumX1-323,0.25,"bounceInOut");
        elseif tag == 'y7' then
            noteTweenY("y7",6,defaultPlayerStrumY2,0.25,"bounceInOut");
            noteTweenX('x7',6,defaultPlayerStrumX2,0.25,"bounceInOut");
        elseif tag == 'x8' then
            noteTweenX('x8',7,defaultPlayerStrumX3-323,0.25,"bounceInOut");
            noteTweenY('y8',7,defaultPlayerStrumY3,0.25,"bounceInOut");
        end
    elseif ls then
        if tag == 'xx5' then
            noteTweenX("xx1",0,defaultPlayerStrumX0,0.25,"bounceInOut");
            noteTweenX("xx5",4,defaultOpponentStrumX0,0.25,"bounceInOut");
            noteTweenY('yy5',4,defaultPlayerStrumY0,0.25,"bounceInOut");
        elseif tag == 'yy6' then
            noteTweenY('yy6',5,defaultPlayerStrumY1,0.25,"bounceInOut");
            noteTweenX("xx2",1,defaultPlayerStrumX1,0.25,"bounceInOut");
            noteTweenX("xx6",5,defaultOpponentStrumX1,0.25,"bounceInOut");
        elseif tag == 'yy7' then
            noteTweenY('yy7',6,defaultPlayerStrumY2,0.25,"bounceInOut");
            noteTweenX("xx3",2,defaultPlayerStrumX2,0.25,"bounceInOut");
            noteTweenX("xx7",6,defaultOpponentStrumX2,0.25,"bounceInOut");
        elseif tag == 'xx8' then
            noteTweenX("xx8",7,defaultOpponentStrumX3,0.25,"bounceInOut");
            noteTweenY('yy8',7,defaultPlayerStrumY3,0.25,"bounceInOut");
            noteTweenX("xx4",3,defaultPlayerStrumX3,0.25,"bounceInOut");
        end
    elseif not ls and not mdsc then
        if tag == 'xxx5' then
            noteTweenX("xxx5",4,defaultPlayerStrumX0,0.25,"bounceInOut");
        elseif tag == 'yyy6' then
            noteTweenY("yyy6",5,defaultPlayerStrumY1,0.25,"bounceInOut");
        elseif tag == 'yyy7' then
            noteTweenY("yyy7",6,defaultPlayerStrumY2,0.25,"bounceInOut");
        elseif tag == 'xxx8' then
            noteTweenX("xxx8",7,defaultPlayerStrumX3,0.25,"bounceInOut");
        end
    end
end

--noteTweenX('x5',4,defaultPlayerStrumX0,0.25,"bounceInOut");
--noteTweenX('x6',5,defaultPlayerStrumX1,0.25,"bounceInOut");
--noteTweenX('x7',6,defaultPlayerStrumX2,0.25,"bounceInOut");
--noteTweenX('x8',7,defaultPlayerStrumX3,0.25,"bounceInOut");

--noteTweenX("x5",4,defaultPlayerStrumX0-323,0.25,"bounceInOut");
--noteTweenX("x6",5,defaultPlayerStrumX1-323,0.25,"bounceInOut");
--noteTweenX("x7",6,defaultPlayerStrumX2-323,0.25,"bounceInOut");
--noteTweenX("x8",7,defaultPlayerStrumX3-323,0.25,"bounceInOut");

--noteTweenY('y5',4,defaultPlayerStrumY0,0.25,"bounceInOut");
--noteTweenY('y6',5,defaultPlayerStrumY1,0.25,"bounceInOut");
--noteTweenY('y7',6,defaultPlayerStrumY2,0.25,"bounceInOut");
--noteTweenY('y8',7,defaultPlayerStrumY3,0.25,"bounceInOut");

--noteTweenX("x1",0,defaultPlayerStrumX0,0.25,"bounceInOut");
--noteTweenX("x2",1,defaultPlayerStrumX1,0.25,"bounceInOut");
--noteTweenX("x3",2,defaultPlayerStrumX2,0.25,"bounceInOut");
--noteTweenX("x4",3,defaultPlayerStrumX3,0.25,"bounceInOut");
--noteTweenX("x5",4,defaultOpponentStrumX0,0.25,"bounceInOut");
--noteTweenX("x6",5,defaultOpponentStrumX1,0.25,"bounceInOut");
--noteTweenX("x7",6,defaultOpponentStrumX2,0.25,"bounceInOut");
--noteTweenX("x8",7,defaultOpponentStrumX3,0.25,"bounceInOut");