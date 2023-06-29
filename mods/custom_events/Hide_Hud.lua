function onEvent(name,value1,value2)
	if name == 'Hide_Hud' then
		if value1 == '0' then
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			setProperty('showRating', true);
			setProperty('showComboNum', true);
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		end
		if value2 == '0' then
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			setProperty('showRating', true);
			setProperty('showComboNum', true);
			setProperty('timeTxt.alpha', 1);
			noteTweenAlpha("o5",4,1,0.5,"quartInOut");
            noteTweenAlpha("o6",5,1,0.5,"quartInOut");
            noteTweenAlpha("o7",6,1,0.5,"quartInOut");
            noteTweenAlpha("o8",7,1,0.5,"quartInOut");
		end
		if value1 == '1' then
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			setProperty('showRating', false);
			setProperty('showComboNum', false);
			noteTweenAlpha("o1",0,0,0.5,"quartInOut");
            noteTweenAlpha("o2",1,0,0.5,"quartInOut");
            noteTweenAlpha("o3",2,0,0.5,"quartInOut");
            noteTweenAlpha("o4",3,0,0.5,"quartInOut");
			noteTweenAlpha("o5",4,0,0.5,"quartInOut");
            noteTweenAlpha("o6",5,0,0.5,"quartInOut");
            noteTweenAlpha("o7",6,0,0.5,"quartInOut");
            noteTweenAlpha("o8",7,0,0.5,"quartInOut");
		end
	
		if value1 == '2' then
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
			setProperty('showRating', true);
			setProperty('showComboNum', true);
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
			setProperty('healthBar.alpha', 0);
			setProperty('healthBarBG.alpha', 0);
			setProperty('iconP1.alpha', 0);
			setProperty('iconP2.alpha', 0);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			setProperty('showRating', false);
			setProperty('showComboNum', false);
		end
		if value2 == '2' then
			setProperty('showRating', true);
			setProperty('showComboNum', true);
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 1);
			setProperty('timeBar.alpha', 1);
			setProperty('timeTxt.alpha', 1);
		end
		if value2 == '3' then
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			setProperty('showRating', false);
			setProperty('showComboNum', false);
		end
		if value2 == '4' then
			setProperty('healthBar.alpha', 1);
			setProperty('healthBarBG.alpha', 1);
			setProperty('iconP1.alpha', 1);
			setProperty('iconP2.alpha', 1);
			setProperty('scoreTxt.alpha', 0);
			setProperty('timeBar.alpha', 0);
			setProperty('timeTxt.alpha', 0);
			setProperty('showRating', false);
			setProperty('showComboNum', false);
			noteTweenAlpha("ot1",0,0,0.5,"quartInOut");
            noteTweenAlpha("ot2",1,0,0.5,"quartInOut");
            noteTweenAlpha("ot3",2,0,0.5,"quartInOut");
            noteTweenAlpha("ot4",3,0,0.5,"quartInOut");
			noteTweenAlpha("ot5",4,0,0.5,"quartInOut");
            noteTweenAlpha("ot6",5,0,0.5,"quartInOut");
            noteTweenAlpha("ot7",6,0,0.5,"quartInOut");
            noteTweenAlpha("ot8",7,0,0.5,"quartInOut");
		end
	end	
end