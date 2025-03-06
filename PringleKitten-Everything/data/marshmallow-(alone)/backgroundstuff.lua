function onSectionHit()
    if curSection == 21 then
        makeLuaSprite('bg', 'me/backgrounds/void', -700, -500);
	    scaleObject('bg', 8, 8);

	    addLuaSprite('bg', false);
    elseif curSection == 29 then
        scaleObject('bg', 0, 0);
    elseif curSection == 77 then
        scaleObject('bg', 8, 8);
    elseif curSection == 85 then
        scaleObject('bg', 0, 0);
    end
end