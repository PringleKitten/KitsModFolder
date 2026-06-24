local zooming = false
local zoom = 0
local abLOL = false
local dbLOL = false
local wereUsingMobile = false
local hzE = false
local hurtMORE = 1
--CUPHEAD ATTACK
local dodge = 0
local theyAttackedH = false
local BigShotCurrent = 0
local BigShotDestroyed = 0
local BigShotTexture = 'cup/bull/Cuphead Hadoken'
local instaKill = false
local doAlert = true

local cupAttacks = {}
local dadAttackAnim = 'attack'

--CUPHEAD DOUBLE ATTACK
local cupAlerts = {}

local currentDouble = 0
local doubleOffsetY = 0
local doubleTexture = 'cup/bull/Roundabout'
local doubleScaleX = 1.3
local doubleScaleY = 1.3


local attackAnim = 'attack'

--CUPHEAD SHOOTING
local isShotting = false
local BfAttacking = false

local enableAttack = false

local ShottingStyle = 0

local PeaShootCounter = 1
local PeaShotHurt = 0
local PeaOffsetX = 400
local PeaOffsetY = 210
local ChaserOffsetX = 390
local ChaserOffsetY = 350

local ChaserShotNumber = 0
local ChaserShotHurt = 0
local ChaserShotSound = 0

local BulletTimer = 0

local changeHealthNotes = 0

local bulletsLength = 3
local bulletsTexture = 'cup/bull/Cupheadshoot'

local CupheadShotAnimations = {"pewLEFT","pewDOWN","pewUP","pewRIGHT"}
function onCreate()
    makeAnimatedLuaSprite('FlashShot','cup/bull/Cupheadshoot',getProperty('dad.x') + PeaOffsetX - 80,getProperty('dad.y') + PeaOffsetY + 180)
    addAnimationByPrefix('FlashShot','Flash','BulletFlashFX instance 1',24,false)
    -- cuphead blue shot
    for BulletsLength = 1, bulletsLength do
        makeAnimatedLuaSprite('Peashoot' ..BulletsLength, bulletsTexture, getProperty('dad.x') + PeaOffsetX, getProperty('boyfriend.y') - PeaOffsetY - (25 * (BulletsLength - 1)));
    
        for bulletsAnimations = 1,bulletsLength do
            addAnimationByPrefix('Peashoot' ..BulletsLength, 'H-Tween'..bulletsAnimations, 'Shot0'..bulletsAnimations..' instance 1', 25, false);
        end
    end

    for greenBullets = 0, 7 do
        makeAnimatedLuaSprite('GreenShit' ..greenBullets, 'cup/bull/GreenShit', getProperty('dad.x') + 360, getProperty('dad.y') + 60);
        for greenAnimations = 1,3 do
            addAnimationByPrefix('GreenShit'..greenBullets,'ChaserShot'..greenAnimations, 'GreenShit0'..greenAnimations, 24,false);
        end
        setBlendMode('GreenShit' ..greenBullets,'add')
    end

    precacheImage('cup/bull/Cupheadshoot')
    precacheImage('cup/bull/GreenShit')
    precacheImage('cup/bull/NMcupheadBull')
end
function onCreatePost()
    if buildTarget == 'android' or getPropertyFromClass('backend.ClientPrefs', 'data.mobileChoice') == 1 then
        makeAnimatedLuaSprite('attackB', 'buttons_IC/AttackButtonLeft', 5, 580)
        addAnimationByPrefix('attackB', 'idle', 'Attack 10000', 0, false)
        addAnimationByPrefix('attackB', 'pressed', 'Attack 10001', 0, false)
        setObjectCamera("attackB", 'other')
        scaleObject("attackB", 1, 1)
        addLuaSprite("attackB", true)

        makeAnimatedLuaSprite('dodgeB', 'buttons_IC/DodgeButtonMobile', 1145, 580)
        addAnimationByPrefix('dodgeB', 'idle', 'Dodge 10000', 0, false)
        addAnimationByPrefix('dodgeB', 'pressed', 'Dodge 10001', 0, false)
        setObjectCamera("dodgeB", 'other')
        scaleObject("dodgeB", 1, 1)
        addLuaSprite("dodgeB", true)
        wereUsingMobile = true
    end
    for events = 0,getProperty('eventNotes.length')-1 do
        if getPropertyFromGroup('eventNotes',events,'event') == 'CupheadDoubleAttack' then
            table.insert(cupAlerts,getPropertyFromGroup('eventNotes',events,'strumTime'))
        end
    end
    if difficulty == 2 then
        instaKill = true
    end
    detectAttack(true)
    for events = 0,getProperty('eventNotes.length')-1 do
        if getPropertyFromGroup('eventNotes',events,'event') == 'CupheadAttack' then
            table.insert(cupAttacks,getPropertyFromGroup('eventNotes',events,'strumTime'))
        end
    end
    if difficulty == 2 then
        instaKill = true
    end
end
function mouseOverlaps(tag, camera)
    x = getMouseX(camera or 'camHUD')
    y = getMouseY(camera or 'camHUD')
    return (x > getProperty(tag..'.x') and y > getProperty(tag..'.y') and x < (getProperty(tag..'.x') + getProperty(tag..'.width')) and y < (getProperty(tag..'.y') + getProperty(tag..'.height')))
end
local doneZO = false
function onEvent(name,value1,value2)
    if name == '' and value1 == 'indieZoom' and value2 ~= 'h' then
        hzE = false
        if not doneZO then
            doneZO = true
        else
            doneZO = false
        end
    elseif value2 == 'h' and value1 == 'indieZoom' and name == '' then
        hzE = true
    end
    if name == "Set Cam Zoom" then
		local easing = 'sineInOut'
		local easingStart = 0
		local easingEnd = 0
		local duration = 0
		local textStringStart = 0
		local textStringLast = 0
		local easings = {'quart','quint','sine','linear','bounce','back','circ','cube','elastic','expo','quad','smoothStep'}
		textStringStart,textStringLast = string.find(value2,value2)
		if string.find(value2,',',0,true) ~= nil then
			easingStart,easingEnd = string.find(value2,',',textStringStart,true)
			easing = string.sub(value2,easingEnd + 1)
			if string.sub(value2,0,easingStart - 1) ~= string.sub(value2,textStringLast - 1,textStringLast) then
				duration = string.sub(value2,0,easingStart - 1)
			else
				duration = 1 /getProperty('cameraSpeed')
			end
		else
			for easingsLength = 1,#easings do
				if string.find(string.lower(value2),easings[easingsLength],0,true) ~= nil then
					easing = value2
				else
					easing = 'sineInOut'
				end
			end
			if tonumber(value2) == nil then
				duration = 0.8
			else
				duration = tonumber(value2)
			end
		end
		if string.match(value1,'cur') == 'cur' and string.find(value1,',',0,true) ~= nil then
			local comma1 = 0
			local comma2 = 0
			comma1,comma2 = string.find(value1,',',0,true)
			if zoom == 0 then
				zoom = getProperty('defaultCamZoom') + string.sub(value1,comma2 + 1)
			else
				zoom = zoom + string.sub(value1,comma2 + 1)
			end
		else
			zoom = value1
		end
		cancelTween('camz')
		if value2 ~= '' then
			if duration ~= 0 then
				doTweenZoom('camz','camGame',zoom,duration,easing)
				setProperty('defaultCamZoom',zoom)
			else
				setProperty('camGame.zoom',zoom)
				setProperty('defaultCamZoom',zoom)
			end
		else
			setProperty('defaultCamZoom',zoom)
		end
		zooming = true
	end
        if name == "CupheadAttack" then
            BigShotCurrent = BigShotCurrent + 1
            local big = 'BigShotCuphead'..BigShotCurrent
            makeAnimatedLuaSprite(big, BigShotTexture,getProperty('dad.x') - 200,getProperty('boyfriend.y') - 100);
            addAnimationByPrefix(big,'Burst','BurstFX instance 1',24,true);
            if BigShotTexture ~= 'cup/bull/NMcupheadAttacks' then
                addAnimationByPrefix(big,'Hadolen','Hadolen instance 1',24,false);
                addOffset(big,'Hadolen',450,850)
            end
            addOffset(big,'Burst',0,0)
            setProperty(big..'.velocity.x',2500)
            setBlendMode(big,'add')
            addLuaSprite(big,true)
            playAnim(big,'Burst')
            playSound('Cup/CupShoot', 0.5)
            runTimer('dodgeCupAttack'..BigShotCurrent,math.abs((getProperty('boyfriend.x') - getProperty('dad.x')) / 10000))
        
        elseif name == 'Change Character' then
            if string.lower(v1) == 'dad' or v1 == '1' then
                detectAttack(false)
            end
        end
        if name == "CupheadDoubleAttack" then
            makeAnimatedLuaSprite('Roundabout'..currentDouble, doubleTexture,getProperty('dad.x') + 370,getProperty('boyfriend.y'));
            addAnimationByPrefix('Roundabout'..currentDouble,'idle','Roundabout instance 1',24,true);
            scaleObject('Roundabout'..currentDouble,doubleScaleX,doubleScaleY)
            setProperty('Roundabout'..currentDouble..'.offset.y', doubleOffsetY)
            addLuaSprite('Roundabout'..currentDouble,true)
            setObjectOrder('Roundabout'..currentDouble,getObjectOrder('boyfriendGroup') - 1)
            doTweenX('RoundaboutX'..currentDouble,'Roundabout'..currentDouble,getProperty('boyfriend.x') + 500, 0.9, 'QuadOut');
            setBlendMode('Roundabout'..currentDouble,'add')
            runTimer('dodgeDoubleAttack'..currentDouble,math.abs((getProperty('boyfriendGroup.x') - getProperty('dadGroup.x')) / 30000))
            playSound('Cup/CupShoot', 0.5)
            currentDouble = currentDouble + 1
        
        elseif name == 'Change Character' then
            if string.lower(value1) == 'dad' or value1 == '1' then
                detectRoundAttack(false)
            end
        end
        if (name == 'CupheadShooting') then
            if (string.lower(value2) ~= 'false') then
                changeHealthNotes = 2
                if value1 == '' then
                    BulletTimer = 0.1
                    ShottingStyle = 0
                    theyAttackedH = false
                    isShotting = true
                elseif value1 == '1' then
                    ShottingStyle = 1
                    isShotting = true
                elseif value1 == '2' then
                    if theyAttackedH and ShottingStyle == 0 then
                        isShotting = false
                    elseif not theyAttackedH and ShottingStyle == 0 then
                        isShotting = true
                    end
                end
            else
                isShotting = false
                ShottingStyle = 0
            end
            if (botplay or not mechanics) and ShottingStyle ~= 1 then
                attackCup()
            end
        end
end
function onSongStart()
    callScript('scripts/eventsandOffset', 'noBopBruh', {true})
end
function onBeatHit()
    scaleObject('iconP1', 1, 1)
    scaleObject('iconP2', 1, 1)
    if curBeat == 295 then
        playAnim('dad', 'phase 2', true, true)
        setProperty('dad.skipDance', true)
    elseif curBeat == 303 then
        setProperty('dad.skipDance', false)
    end
    if curBeat == 400 then
        doTweenZoom('normalllll', 'game', 0.65, 0.1, 'expoOut')
        setProperty('defaultCamZoom', 0.65)
    end
    if doneZO then
        setProperty('camHUD.zoom', 1.1)
        if not hzE then
            setProperty('camGame.zoom', getProperty('camGame.zoom')+0.1)
        end
        doTweenZoom('bkH', 'hud', 1, 0.2, 'cubeOut')
        doTweenZoom('bkG', 'game', getProperty('defaultCamZoom'), 0.2, 'cubeOut')
    end
end
function onUpdate(el)
    if wereUsingMobile then
        if mouseOverlaps('dodgeB', 'camOther') and mouseClicked("left") then
            dbLOL = true
            playAnim("dodgeB", "pressed")
        else
            dbLOL = false
        end
        if mouseOverlaps('attackB', 'camOther') and mouseClicked("left") then
            abLOL = true
            playAnim("attackB", "pressed")
        else
            abLOL = false
        end
        if mouseReleased("left") or not mouseOverlaps('dodgeB', 'camOther') then
            playAnim("dodgeB", "idle")
        end
        if mouseReleased("left") or not mouseOverlaps('attackB', 'camOther') then
            playAnim("attackB", "idle")
        end
    end
    if zooming then
        setProperty('defaultCamZoom',getProperty('camGame.zoom'))
    end
    if BigShotDestroyed < BigShotCurrent then
        for big = BigShotDestroyed + 1,BigShotCurrent do
            local name = 'BigShotCuphead'..big
            if luaSpriteExists(name) then
                if getProperty(name..'.animation.curAnim.name') == 'Hadolen' and getProperty(name..'.animation.curAnim.finished') == true then
                    removeLuaSprite(name,true)
                    BigShotDestroyed = BigShotDestroyed + 1
                else
                    local bigShotX = getProperty(name..'.x')
                    local bfX = getProperty('boyfriend.x') - getProperty('boyfriend.positionArray[0]')
                    if bigShotX > (bfX + (screenWidth * (1 + (1 - getProperty('defaultCamZoom')))) + 200) then
                        removeLuaSprite(name,true)
                        BigShotDestroyed = BigShotDestroyed + 1
                    end
                end

            end
        end
    end
    for i, time in pairs(cupAttacks) do
        if time - getSongPosition() < (doAlert and 600 or 700) then
            playAnim('dad', '')
            callScript('data/knockout-(metal-cover)/script','dodgeT')
            if doAlert then
                callScript('data/knockout-(metal-cover)/script','createAlert')
                runTimer('CupheadPreAttack'..i,0.25)
            else
                runTimer('CupheadPreAttack'..i,0.4)
            end
            dodge = 2
            table.remove(cupAttacks,i)
        end
    end
    if dodge == 2 and ((keyboardJustPressed('SPACE') or dbLOL) and not botPlay or (botPlay or not mechanics)) then
        dodge = 1
        dbLOL = false
    end
    for i, time in pairs(cupAlerts) do
        if time <= getSongPosition() + 700 then
            playSound('Cup/CupPre_shoot', 0.5)
            callScript('data/knockout-(metal-cover)/script','createAlert')
            callScript('data/knockout-(metal-cover)/script','dodgeT')
            dodge = 2
            runTimer('CupheadPreAttack',0.25)
            table.remove(cupAlerts,i)
        end
    end
    if dodge == 2 and ((keyboardJustPressed('SPACE') or dbLOL) and not botPlay or (botPlay or not mechanics)) then
        dodge = 1
        dbLOL = false
    end
    if (isShotting and ShottingStyle == 0) then
        if (BulletTimer > 0) then
            BulletTimer = BulletTimer - el

        elseif (BulletTimer <= 0) then
            BulletTimer = 0.14
            PeaShootCounter = PeaShootCounter + 1
            playAnim('dad','shotting', true)
            setProperty('dad.specialAnim', true)
            addLuaSprite('Peashoot' ..PeaShootCounter-1, true)
            setProperty('Peashoot'..(PeaShootCounter-1)..'.x',getProperty('dad.x') + PeaOffsetX)
            setProperty('Peashoot'..(PeaShootCounter-1)..'.y',getProperty('dad.y') - getProperty('dad.positionArray[1]') + PeaOffsetY - (25 * (PeaShootCounter - 1)))
            playAnim('Peashoot' ..PeaShootCounter-1, 'H-Tween' ..(getRandomInt(1,bulletsLength)), true)
            playSound('Cup/pea'..(math.random(0, 5)), 0.5)
            addLuaSprite('FlashShot', true)
            setProperty('FlashShot.x',getProperty('dad.x') + PeaOffsetX - 80)
            setProperty('FlashShot.y',getProperty('dad.y') + PeaOffsetY + 180)
            playAnim('FlashShot', 'Flash', true)
        end
    end

    if ChaserShotNumber > 7 then
        ChaserShotNumber = 0
    end

    if ChaserShotSound > 3 then
        ChaserShotSound = 0
    end

    if (PeaShootCounter > bulletsLength) then
        PeaShootCounter = 1
    end

    for ChaserShotCount = 1,7 do
        if getProperty('GreenShit'..ChaserShotCount..'.animation.curAnim.finished') == true then
            removeLuaSprite('GreenShit'..ChaserShotCount,false)
        end
         if(getProperty('GreenShit'..ChaserShotCount..'.animation.curAnim.curFrame') == 10 and ChaserShotHurt ~= ChaserShotCount and getHealth() > 0.05) then
            setHealth(getHealth() - (0.023))
            ChaserShotHurt = ChaserShotCount
        end
    end
    if getProperty('FlashShot.animation.curAnim.finished') == true then
        removeLuaSprite('FlashShot',false)
    end
    for PeaShotC = 1, bulletsLength do
        if (getProperty('Peashoot'..PeaShotC..'.animation.curAnim.finished')) then
            removeLuaSprite('Peashoot'..PeaShotC, false)
        end
        if(getProperty('Peashoot'..PeaShotC..'.animation.curAnim.curFrame') == 6 and PeaShotHurt ~= PeaShotC)then
            setProperty('health', getProperty('health') - 0.06*hurtMORE)
            hurtMORE = hurtMORE*1.05
            PeaShotHurt = PeaShotC
        end
    end
    if getProperty('Cardcrap.animation.curAnim.name') ~= 'Used' then 
        if not BfAttacking and ((keyboardJustPressed('SHIFT') or abLOL) and not botplay or isShotting and ShottingStyle == 0 and (botPlay or not mechanics)) then
            attackCup()
            abLOL = false
        end
    end
end
function shotHit(target)
    if target == nil then
        target = 'boyfriend'
    end
    local name = 'BigShotCuphead'..BigShotCurrent
    playAnim(name,'Hadolen',true)
    setProperty(name..'.velocity.x',0)
    if target == 'boyfriend' then
        setProperty(name..'.x',getProperty('boyfriend.x') - getProperty('boyfriend.positionArray[0]'))
        setProperty(name..'.y',getProperty('boyfriend.y') + getProperty('boyfriend.positionArray[1]'))
    else
        setProperty(name..'.x',getProperty(target..'.x'))
        setProperty(name..'.y',getProperty(target..'.y'))
    end
end
function detectAttack(precache)
    local dad = getProperty('dad.curCharacter')
    if dad ~= 'cuphead-pissed' then
        dadAttackAnim = 'attack'
    end
end
function onTweenCompleted(tag)
    if name == 'camz' then
		zoom = 0
		zooming = false
	end
    if string.find(tag, 'Roundabout',0,true) then
        local round = ''
        if string.find(tag,'RoundaboutXBye',0,true) then
            removeLuaSprite(string.gsub(tag,'RoundaboutXBye',''))
        elseif string.find(tag,'RoundaboutX',0,true) then
            setCamTarget('bf')
            round = string.gsub(tag,'X','')
            doTweenX('RoundaboutXBye'..round,round,getProperty('boyfriend.x') - (1280 * (2 + math.abs(1 - getProperty('defaultCamZoom')))), 1.5, 'quadIn');
            setObjectOrder(round,getObjectOrder('boyfriendGroup') + 1)
            doTweenX('RoundaboutScaleX'..round,round..'.scale',getProperty(round..'.scale.x') + 0.15,1,'QuadIn')
            doTweenY('RoundaboutScaleY'..round,round..'.scale',getProperty(round..'.scale.y') + 0.15,1,'QuadIn')
            dodge = 2
            runTimer('dodgeDoubleAttack'..round,0.4)
            setObjectOrder(round,getObjectOrder('boyfriendGroup') + 1)
        end
    end
end

function attackCup()
    theyAttackedH = true
    hurtMORE = 1
    if ShottingStyle == 0 then
        cancelTimer('keepShooting')
        actuallyDidIt = true
    end
    disableNotes(true,1000)
    playAnim('boyfriend','attack',true)
    setProperty('boyfriend.specialAnim',true)
    runTimer('CupheadHurt',0.3)
    playSound('Cup/Throw'..(math.random(1,3)), 0.5)
    BfAttacking = true
    runTimer('enableCupAttack',1)
    callScript('data/knockout-(metal-cover)/script','unfillCard')
end
function disableNotes(mustPress,time)
    if time == nil then
        time = 500
    end
    for notesLength = 0,getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', notesLength, 'strumTime') - getSongPosition() <= time and getPropertyFromGroup('notes', notesLength, 'mustPress') == mustPress then
            setPropertyFromGroup('notes', notesLength, 'noAnimation', true)
        end
    end
end

function setCamTarget(target)
    setProperty('isCameraOnForcedPos',target ~= nil)
    if target ~= nil then
        cameraSetTarget(target)
    else
        if not gfSection then
            if mustHitSection then
                cameraSetTarget('boyfriend')
            else
                cameraSetTarget('dad')
            end
        else
            cameraSetTarget('gf')
        end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if isShotting and getPropertyFromGroup('notes',id,'hitHealth') > 0 then
        setHealth(getHealth() - getPropertyFromGroup('notes',id,'hitHealth'))
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote and isShotting == true then
        if ShottingStyle == 1 then
            playAnim('dad',CupheadShotAnimations[noteData + 1],true)
            setProperty('dad.specialAnim',true)
            addLuaSprite('GreenShit'..ChaserShotNumber,true)
            setProperty('GreenShit'..ChaserShotNumber..'.x',getProperty('dad.x') + ChaserOffsetX)
            setProperty('GreenShit'..ChaserShotNumber..'.y',getProperty('dad.y') + ChaserOffsetY)
            playAnim('GreenShit'..ChaserShotNumber,'ChaserShot'..(math.random(1,3)), false)
            playSound('Cup/chaser'..ChaserShotSound, 0.5)
            ChaserShotNumber  = ChaserShotNumber + 1
            ChaserShotSound  = ChaserShotSound + 1
        else
            isShotting = false
            changeHealthNotes = 1
        end
    end
end
function bfDodge()
    disableNotes(true,500)
    playAnim('boyfriend','dodge',true)
    setProperty('boyfriend.specialAnim',true)
    playSound('Cup/CupDodge', 0.5)
end
function bfHurt()
    playAnim('boyfriend','hurt',true)
    setProperty('boyfriend.specialAnim',true)
    local force = 1.2
    if instaKill then
        force = 2
    end
    if getHealth() - force > 0 then
        setHealth(getHealth() - 1.2)
    else
        runTimer('GameOverCuphead',0.3)
    end
end
function detectRoundAttack(precache)
    attackAnim = 'big shot'
    doubleTexture = 'cup/bull/Roundabout'
    doubleScaleX = 1.3
    doubleScaleY = 1.3
    doubleOffsetY = 0
    if precache then
        precacheImage(doubleTexture)
    end
end
function onTimerCompleted(tag)
    if tag == 'keepShooting' then
        if not actuallyDidIt then
            isShotting = true
        else
            isShotting = false
            actuallyDidIt = false
        end
    end
    if tag == 'CupheadHurt' then
        setHealth(getHealth() + 1)
        if isShotting == true or getProperty('dad.curCharacter') == 'cuphead-pissed' then
            if changeHealthNotes == 2 then
                changeHealthNotes = 1
            end
            playAnim('dad','hurt',true)
            setProperty('dad.specialAnim',true)
            playSound('Cup/CupHurt', 0.5)
            if isShotting then
                runTimer('keepShooting', 0.75)
            end
            isShotting = false
        elseif isShotting == false then
            disableNotes(false,500)
            playAnim('dad','dodge',true)
            setProperty('dad.specialAnim',true)
            playSound('Cup/CupDodge', 0.5)
        end
    elseif tag == 'enableCupAttack' then
        BfAttacking = false
    end
    if tag == 'CupheadPreAttack' then
        callScript('')
        disableNotes(false,1000)
        playAnim('dad', 'big shot', false);
        setProperty('dad.specialAnim', true);
    elseif string.find(tag,'dodgeDoubleAttack',0,true)  then
        setProperty('isCameraOnForcedPos',false)
        if dodge == 1 then
            bfDodge()
        elseif dodge == 2 then
            bfHurt()
            playAnim('BigShotCuphead','Burst',false)
        end
    elseif tag == 'dodgeRound' then
        if dodge == 1 then
            bfDodge()
		elseif dodge == 2 then
            bfHurt()
        end
    elseif tag == 'GameOverCuphead' then
        setHealth(-1)
    end
    if stringStartsWith(tag,'CupheadPreAttack') then
        playSound('Cup/CupPre_shoot', 0.5)
        disableNotes(false,1000)
        playAnim('dad', 'big shot', false);
        setProperty('dad.specialAnim', true);
    elseif stringStartsWith(tag,'dodgeCupAttack') then
        if dodge == 1 then
            bfDodge()
        elseif dodge == 2 then
            bfHurt()
            shotHit()
        end
    elseif tag == 'GameOverCuphead' then
        setHealth(-0.1);
    end
end