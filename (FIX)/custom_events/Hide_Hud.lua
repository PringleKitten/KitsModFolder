local hidecbo = false
function onEvent(name,value1,value2)
	if name == 'Hide_Hud' then
		if value1 == '1' then
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,0,0.5,"quartInOut");
            noteTweenAlpha("o2",1,0,0.5,"quartInOut");
            noteTweenAlpha("o3",2,0,0.5,"quartInOut");
            noteTweenAlpha("o4",3,0,0.5,"quartInOut");
			noteTweenAlpha("o5",4,0,0.5,"quartInOut");
            noteTweenAlpha("o6",5,0,0.5,"quartInOut");
            noteTweenAlpha("o7",6,0,0.5,"quartInOut");
            noteTweenAlpha("o8",7,0,0.5,"quartInOut");
		elseif value1 == '2' then
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
			setProperty('timeTxt.visible', true)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		elseif value1 == '22' then
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
			setProperty('timeTxt.visible', true)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		elseif value1 == '222' then
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
			setProperty('timeTxt.visible', true)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value1 == '0' then
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
			setProperty('timeTxt.visible', true)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		end
		if value2 == '1' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value2 == '12' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		elseif value2 == '122' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value2 == '11' then
			setProperty('timeBar.visible', true)
			setProperty('timeBarBG.visible', true)
			setProperty('timeTxt.visible', true)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			if not hidecbo then
				setProperty('showRating', true);
				setProperty('showComboNum', true);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value2 == '2' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value2 == '22' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		elseif value2 == '222' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("o1",0,1,0.5,"quartInOut");
            noteTweenAlpha("o2",1,1,0.5,"quartInOut");
            noteTweenAlpha("o3",2,1,0.5,"quartInOut");
            noteTweenAlpha("o4",3,1,0.5,"quartInOut");
		elseif value2 == '3' then
			setProperty('timeBar.visible', false)
			setProperty('timeBarBG.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			if not hidecbo then
				setProperty('showRating', false);
				setProperty('showComboNum', false);
			end
			noteTweenAlpha("ot1",0,0,0.5,"quartInOut");
            noteTweenAlpha("ot2",1,0,0.5,"quartInOut");
            noteTweenAlpha("ot3",2,0,0.5,"quartInOut");
            noteTweenAlpha("ot4",3,0,0.5,"quartInOut");
			noteTweenAlpha("ot5",4,0,0.5,"quartInOut");
            noteTweenAlpha("ot6",5,0,0.5,"quartInOut");
            noteTweenAlpha("ot7",6,0,0.5,"quartInOut");
            noteTweenAlpha("ot8",7,0,0.5,"quartInOut");
		elseif value2 == '4' then
			hidecbo = true
		elseif value2 == '44' then
			hidecbo = true
			setProperty('showRating', true);
			setProperty('showComboNum', true);
		elseif value2 == '444' then
			hidecbo = false
		end
	end	
end