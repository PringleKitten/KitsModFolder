local hb = 1
function onEvent(name,value1,value2)
	if name == 'Hide_Hud' then
		if value1 == 'insta' then
            value2 = value2;
            insttt = true
        elseif value2 == 'insta' then
            value1 = value1
            insttt = true
        else
            value1 = value1
            value2 = value2
        end
		if value1 == '1' then
			hideUI(false,false,0)
			hudHideN()
		elseif value1 == '2' then
			showUI()
			hudShowN()
		elseif value1 == '22' then
			hideUI(true,false,0)
		elseif value1 == '222' then
			hideUI(false,true,0)
		elseif value1 == '0' then
			showUI()
			hudShowN()
		end
		if value2 == '1' then
			hideUI(true,true,0)
		elseif value2 == '12' then
			hideUI(true,false,0)
		elseif value2 == '122' then
			hideUI(false,true,0)
		elseif value2 == '11' then
			hideUI(false,false,0)
			hudHideN()
		elseif value2 == '2' then
			hideUI(true,true,1)
		elseif value2 == '22' then
			hideUI(true,false,1)
		elseif value2 == '222' then
			hideUI(false,true,1)
		elseif value2 == '3' then
			hideUI(false,false,1)
		elseif value2 == '4' then
			combO(false)
		elseif value2 == '44' then
			combO(false)
		elseif value2 == '444' then
			combO(true)
		end
	end	
end
local kPN = false
local kON = false
function hideUI(kPNa,kONa,hB)
	if (kPNa ~= nil or kPNa ~= '') then
		kPN = kPNa
	end
	if (kONa ~= nil or kONa ~= '') then
		kON = kONa
	end
	if (hb == nil or hb == '') then
		hb = hb
	end
	if kPN or kON then
		hudHideN()
	end
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
end
function showUI()
	hb = 1
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
end
function hudHideN()
	local bpm = getPropertyFromClass('backend.Conductor','bpm')
    local beatDur = 60 / bpm
    local tweenTime = beatDur * 0.7
	pN = 0
	oN = 0
	if kPN then
		pN = 1
	end
	if kON then
		oN = 1
	end
	if insttt then
		setPropertyFromGroup("playerStrums", 0,'alpha',pN)
		setPropertyFromGroup("playerStrums", 1,'alpha',pN)
		setPropertyFromGroup("playerStrums", 2,'alpha',pN)
		setPropertyFromGroup("playerStrums", 3,'alpha',pN)
		setPropertyFromGroup("opponentStrums", 0,'alpha',oN)
		setPropertyFromGroup("opponentStrums", 1,'alpha',oN)
		setPropertyFromGroup("opponentStrums", 2,'alpha',oN)
		setPropertyFromGroup("opponentStrums", 3,'alpha',oN)
	else
		noteTweenAlpha("oz1",0,oN,tweenTime,"quartInOut");
		noteTweenAlpha("oz2",1,oN,tweenTime,"quartInOut");
		noteTweenAlpha("oz3",2,oN,tweenTime,"quartInOut");
		noteTweenAlpha("oz4",3,oN,tweenTime,"quartInOut");
		noteTweenAlpha("oz5",4,pN,tweenTime,"quartInOut");
		noteTweenAlpha("oz6",5,pN,tweenTime,"quartInOut");
		noteTweenAlpha("oz7",6,pN,tweenTime,"quartInOut");
		noteTweenAlpha("oz8",7,pN,tweenTime,"quartInOut");
	end
end
function hudShowN()
	if insttt then
		setPropertyFromGroup("playerStrums", 0,'alpha',1)
		setPropertyFromGroup("playerStrums", 1,'alpha',1)
		setPropertyFromGroup("playerStrums", 2,'alpha',1)
		setPropertyFromGroup("playerStrums", 3,'alpha',1)
		setPropertyFromGroup("opponentStrums", 0,'alpha',1)
		setPropertyFromGroup("opponentStrums", 1,'alpha',1)
		setPropertyFromGroup("opponentStrums", 2,'alpha',1)
		setPropertyFromGroup("opponentStrums", 3,'alpha',1)
	else
		noteTweenAlpha("oz1",0,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz2",1,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz3",2,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz4",3,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz5",4,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz6",5,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz7",6,1,tweenTime,"quartInOut");
		noteTweenAlpha("oz8",7,1,tweenTime,"quartInOut");
	end
end
function combO(showcbo)
	setProperty('showRating', showcbo);
	setProperty('showComboNum', showcbo);
end