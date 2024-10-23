function onCreate()
	-- background shit
	makeLuaSprite('bg', 'bg', -600, -300);
	setScrollFactor('bg', 0.9, 0.9);
	
	makeLuaSprite('bg2', 'bg2', -650, 600);
	setScrollFactor('bg2', 0.9, 0.9);
	scaleObject('bg2', 1.1, 1.1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeLuaSprite('stagelight_left', 'not2', -125, -100);
		setScrollFactor('stagelight_left', 0.9, 0.9);
		scaleObject('stagelight_left', 1.1, 1.1);
		
		makeLuaSprite('stagelight_right', 'not3', 1225, -100);
		setScrollFactor('stagelight_right', 0.9, 0.9);
		scaleObject('stagelight_right', 1.1, 1.1);
		setProperty('stagelight_right.flipX', true); --mirror sprite horizontally

	end

	addLuaSprite('bg', false);
	addLuaSprite('bg2', true);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end