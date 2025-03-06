function onCreate()
	makeLuaSprite('bg', 'me/backgrounds/blank', -800, -500);
	scaleObject('bg', 2.1, 2.1);

	addLuaSprite('bg', false);
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end