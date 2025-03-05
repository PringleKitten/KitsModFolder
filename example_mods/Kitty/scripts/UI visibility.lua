local pran1 = false
local pran = false
local oran = false
local oran1 = false
local hb = 1

function onEvent(name, value1, value2)
    if name == "HideNotes" then
        voa = 0.5
        ist = false
        if songName == 'Octagon of Destiny' then
            voa = 0.2
        end
        if value1 == 'insta' then
            value2 = tonumber(value2);
            ist = true
        elseif value2 == 'insta' then
            value1 = tonumber(value1)
            ist = true
        else
            value1 = tonumber(value1)
            value2 = tonumber(value2)
        end
        if (value1 ~= '' or value1 ~= nil or value1 ~= 'insta') and (value2 ~= '' or value2 ~= nil or value2 ~= 'insta') then
            ager = true
        end
        if value1 == 1 then
            if oran then
                showO()
            else
                hideO()
            end
        elseif value1 == 12 then
            hideO()
        elseif value1 == 11 then
            if oran then
                showOF()
            else
                hideO()
            end
        elseif value1 == 112 then
            showOF()
        elseif value1 == 2 then
            if pran then
                showPF()
            else
                hideP()
            end
        elseif value1 == 22 then
            if pran then
                showP()
            else
                hideP()
            end
        elseif value1 == 222 then
            showPF()
        elseif value1 == 0 then
            showPF()
            showO()           
        elseif value1 == 100 then
            showPF()
            showOF()
        end
        if value2 == 0 then
            showPFa()
            showOa()
        elseif value2 == 100 then
            showPFa()
            showOFa()
        elseif value2 == 1 then
            if oran1 then
                showOa()
            else
                hideOa()
            end
        elseif value2 == 12 then
            hideOa()
        elseif value2 == 11 then
            if oran1 then
                showOFa()    
            else
                hideOa()
            end
        elseif value2 == 112 then
            showOFa()
        elseif value2 == 2 then
            if pran1 then
                showPFa()
            else
                hidePa()
            end
        elseif value2 == 22 then
            if pran1 then
                showPa()
            else
                hidePa()
            end
        elseif value2 == 222 then
            showPFa()
        end
        local Pa = getPropertyFromGroup('notes', 4, 'alpha')
        local Oa = getPropertyFromGroup('notes', 0, 'alpha')
    end
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
    pran1 = true
    pran = true
    oran = true
    oran1 = true
	if kPN then
		pN = 1
        pran1 = false
        pran = false
	end
	if kON then
		oN = 1
        oran = false
        oran1 = false
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
    pran1 = false
    pran = false
    oran = false
    oran1 = false
end
function combO(showcbo)
	setProperty('showRating', showcbo);
	setProperty('showComboNum', showcbo);
end

function showOF()
    opS = true
    if ist then
        sPFG(false,'opponentStrums',1)
    end
    if ager then
        sPFG(true,'o','a',1)
    else
        sPFG(true,'o',1)
    end
    oran1 = false
    oran = false
end
function showO()
    opS = true
    if ist then
        sPFG(false,'opponentStrums',0.5)
    end
    if ager then
        sPFG(true,'o','b',0.5)
    else
        sPFG(true,'o',0.5)
    end
    oran1 = false
    oran = false
end
function showPF()
    plS = true
    if ist then
        sPFG(false,'playerStrums',1)
    end
    if ager then
        sPFG(true,'o','c',1)
    else
        sPFG(true,'o',1)
    end
    pran1 = false
    pran = false
end
function showP()
    plS = true
    if ist then
        sPFG(false,'playerStrums',0.5)
    end
    if ager then
        sPFG(true,'o','d',0.5)
    else
        sPFG(true,'o',0.5)
    end
    pran1 = false
    pran = false
end
function hideO()
    opS = true
    if ist then
        sPFG(false,'opponentStrums',0)
    end
    if ager then
        sPFG(true,'o','e',0)
    else
        sPFG(true,'o',0)
    end
    oran1 = true
    oran = true
end
function hideP()
    plS = true
    if ist then
        sPFG(false,'playerStrums',0)
    end
    if ager then 
        sPFG(true,'o','f',0)
    else
        sPFG(true,'o',0)
    end
    pran1 = true
    pran = true
end

function sPFG(tween,stl,bit,num)
    if tween then
        if bit == nil or bit == '' then
            bit = 'z'
        end
        if opS then
            noteTweenAlpha(stl..(bit)..(1),0,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(2),1,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(3),2,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(4),3,num,voa,"quartInOut");
            opS = false
        elseif plS then
            noteTweenAlpha(stl..(bit)..(5),4,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(6),5,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(7),6,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(8),7,num,voa,"quartInOut");
            plS = false
        end
    else
        for i = 0,3 do
            setPropertyFromGroup(stl,i,'alpha',num)
        end
    end
end
function showOFa()
    opS = true
    if ist then
        sPFGa(false,'opponentStrums',1)
    end
    if ager then
        sPFGa(true,'o','a',1)
    else
        sPFGa(true,'o',1)
    end
    oran1 = false
    oran = false
end
function showOa()
    opS = true
    if ist then
        sPFGa(false,'opponentStrums',0.5)
    end
    if ager then
        sPFGa(true,'o','b',0.5)
    else
        sPFGa(true,'o',0.5)
    end
    oran1 = false
    oran = false
end
function showPFa()
    plS = true
    if ist then
        sPFGa(false,'playerStrums',1)
    end
    if ager then
        sPFGa(true,'o','c',1)
    else
        sPFGa(true,'o',1)
    end
    pran1 = false
    pran = false
end
function showPa()
    plS = true
    if ist then
        sPFGa(false,'playerStrums',0.5)
    end
    if ager then
        sPFGa(true,'o','d',0.5)
    else
        sPFGa(true,'o',0.5)
    end
    pran1 = false
    pran = false
end
function hideOa()
    opS = true
    if ist then
        sPFGa(false,'opponentStrums',0)
    end
    if ager then
        sPFGa(true,'o','e',0)
    else
        sPFGa(true,'o',0)
    end
    oran1 = true
    oran = true
end
function hidePa()
    plS = true
    if ist then
        sPFGa(false,'playerStrums',0)
    end
    if ager then 
        sPFGa(true,'o','f',0)
    else
        sPFGa(true,'o',0)
    end
    pran1 = true
    pran = true
end

function sPFGa(tween,stl,bit,num)
    if tween then
        if bit == nil or bit == '' then
            bit = 'zA'
        end
        if opS then
            noteTweenAlpha(stl..(bit)..(1),0,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(2),1,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(3),2,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(4),3,num,voa,"quartInOut");
            opS = false
        elseif plS then
            noteTweenAlpha(stl..(bit)..(5),4,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(6),5,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(7),6,num,voa,"quartInOut");
            noteTweenAlpha(stl..(bit)..(8),7,num,voa,"quartInOut");
            plS = false
        end
    else
        for i = 0,3 do
            setPropertyFromGroup(stl,i,'alpha',num)
        end
    end
end

function onDestroy()
    close(true)
end