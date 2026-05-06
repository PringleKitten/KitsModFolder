local curSplash = 0
local destroyed = 0
local splashAlpha = false
function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Parry Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'cup/NOTECup_assets');
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false);
		end
	end
	splashAlpha = getPropertyFromClass('backend.ClientPrefs','data.splashAlpha')
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Parry Note' and not isSustainNote then
		-- put something here if you want
		playSound('Cup/CupParry', 1.5)
		if splashAlpha > 0 then
			curSplash = curSplash + 1
			local name = 'parrySplash'..curSplash
			makeAnimatedLuaSprite(name,'noteSplashes/noteParry',getPropertyFromGroup('playerStrums',noteData,'x') - 210,getPropertyFromGroup('playerStrums',noteData,'y') - 240)
			addAnimationByPrefix(name,'anim','ParryFX',24,false)
			setObjectCamera(name,'hud')
			setProperty(name..'.alpha',splashAlpha)
			addLuaSprite(name,true)
		end
	end
end
function onUpdate()
	if splashAlpha > 0 and curSplash > destroyed then
		for splash = destroyed,curSplash do
			if getProperty('parrySplash'..splash..'.animation.curAnim.finished') == true then
				removeLuaSprite('parrySplash'..splash,true)
				destroyed = destroyed + 1
			end
		end
	end
end