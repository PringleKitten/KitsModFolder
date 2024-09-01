local duration = 1
local charterB = true
local coderB = true
local artB = true
local musicB = true
local roleCredits =
{
	{
	song = 'power-of-terry',
	coders = {'pringlekitten', nil, {0,0}},--name,icon,iconOffset
	artists = {'Old Spice Collaboration Team', nil, {0,0}},--name,icon,iconOffset
	composers = {'Old Spice Collaboration Team', nil, {0,0}},--name,icon,iconOffset
	charters = {'pringlekitten', nil, {0,0}},--name,icon,iconOffset
	barFG = {'ff00a2', '000000', '000000', 'ff00a2'}, --coder,artist,composer,charter
	barBG = {'2f00ff', 'FFFFFF', 'FFFFFF', '2f00ff'}, --coder,artist,composer,charter
	textColor = {'ff008c', '000000', '000000', 'ff008c'}, --coder,artist,composer,charter
	textBorderColor = {'FFFFFF', 'FFFFFF', 'FFFFFF', 'FFFFFF'} --coder,artist,composer,charter
	},
}
------------/\/\/\/\-EDIT HERE-/\/\/\/\------------

--IGNORE BEYOND HERE--
--IGNORE BEYOND HERE--
--IGNORE BEYOND HERE--
local roleCreditSelected = 0
function onCreate()
	local minLength = 180
	for i = 1, #roleCredits do
		if songName == roleCredits[i].song then
			roleCreditSelected = i
		end
    end
	if roleCreditSelected == 0 then
		debugPrint("'roleCredits.song' IS INVALID OR DOES NOT EXIST!")
	end
	if coderB then
	--coding
	if #roleCredits[roleCreditSelected].coders[1]*25 < minLength then
		luaGraphic('creditsGraphicAa', -minLength-(150+roleCredits[roleCreditSelected].coders[3][1]), 180, minLength, 90, roleCredits[roleCreditSelected].barBG[1])
	else
		luaGraphic('creditsGraphicAa', (-#roleCredits[roleCreditSelected].coders[1]*25)-(150+roleCredits[roleCreditSelected].coders[3][1]), 180, #roleCredits[roleCreditSelected].coders[1]*25, 90, roleCredits[roleCreditSelected].barBG[1])
	end
	luaGraphic('creditsGraphicAb', getProperty('creditsGraphicAa.x'), getProperty('creditsGraphicAa.y')+5, getProperty('creditsGraphicAa.width')-5, getProperty('creditsGraphicAa.height')-10, roleCredits[roleCreditSelected].barFG[1])
	luaText('creditsTextAa', getProperty('creditsGraphicAb.x')+5, getProperty('creditsGraphicAb.y')+3, 30, '000000', 'FFFFFF', 'Coding:')
	luaText('creditsTextAb', getProperty('creditsGraphicAb.x')+5, getProperty('creditsGraphicAb.y')+35, 40, roleCredits[roleCreditSelected].textColor[1], roleCredits[roleCreditSelected].textBorderColor[1], roleCredits[roleCreditSelected].coders[1])
		setTextWidth('creditsTextAa', getProperty('creditsGraphicAb.width'))
	end
	if charterB then
	--chart
	if #roleCredits[roleCreditSelected].charters[1]*25 < minLength then
		luaGraphic('creditsGraphicBa', -minLength-(150+roleCredits[roleCreditSelected].charters[3][1]), getProperty('creditsGraphicAa.y')+getProperty('creditsGraphicAa.height'), minLength, 90, roleCredits[roleCreditSelected].barBG[4])
	else
		luaGraphic('creditsGraphicBa', (-#roleCredits[roleCreditSelected].charters[1]*25)-(150+roleCredits[roleCreditSelected].charters[3][1]), getProperty('creditsGraphicAa.y')+getProperty('creditsGraphicAa.height'), #roleCredits[roleCreditSelected].charters[1]*25, 90, roleCredits[roleCreditSelected].barBG[4])
	end
	luaGraphic('creditsGraphicBb', getProperty('creditsGraphicBa.x'), getProperty('creditsGraphicBa.y')+5, getProperty('creditsGraphicBa.width')-5, getProperty('creditsGraphicBa.height')-10, roleCredits[roleCreditSelected].barFG[4])
	luaText('creditsTextBa', getProperty('creditsGraphicBb.x')+5, getProperty('creditsGraphicBb.y')+3, 30, '000000', 'FFFFFF', 'Charting:')
	luaText('creditsTextBb', getProperty('creditsGraphicBb.x')+5, getProperty('creditsGraphicBb.y')+35, 40, roleCredits[roleCreditSelected].textColor[4], roleCredits[roleCreditSelected].textBorderColor[4], roleCredits[roleCreditSelected].charters[1])
		setTextWidth('creditsTextBa', getProperty('creditsGraphicBb.width'))
	end
	if musicB then
	--music
	if #roleCredits[roleCreditSelected].composers[1]*25 < minLength then
		luaGraphic('creditsGraphicCa', -minLength-(150+roleCredits[roleCreditSelected].composers[3][1]), getProperty('creditsGraphicBa.y')+getProperty('creditsGraphicBa.height'), minLength, 90, roleCredits[roleCreditSelected].barBG[3])
	else
		luaGraphic('creditsGraphicCa', (-#roleCredits[roleCreditSelected].composers[1]*25)-(150+roleCredits[roleCreditSelected].composers[3][1]), getProperty('creditsGraphicBa.y')+getProperty('creditsGraphicBa.height'), #roleCredits[roleCreditSelected].composers[1]*25, 90, roleCredits[roleCreditSelected].barBG[3])
	end
	luaGraphic('creditsGraphicCb', getProperty('creditsGraphicCa.x'), getProperty('creditsGraphicCa.y')+5, getProperty('creditsGraphicCa.width')-5, getProperty('creditsGraphicCa.height')-10, roleCredits[roleCreditSelected].barFG[3])
	luaText('creditsTextCa', getProperty('creditsGraphicCb.x')+5, getProperty('creditsGraphicCb.y')+3, 30, '000000', 'FFFFFF', 'Music:')
	luaText('creditsTextCb', getProperty('creditsGraphicCb.x')+5, getProperty('creditsGraphicCb.y')+35, 40, roleCredits[roleCreditSelected].textColor[3], roleCredits[roleCreditSelected].textBorderColor[3], roleCredits[roleCreditSelected].composers[1])
		setTextWidth('creditsTextCa', getProperty('creditsGraphicCb.width'))
	end
	if artB then
	--art
	if #roleCredits[roleCreditSelected].artists[1]*25 < minLength then
		luaGraphic('creditsGraphicDa', -minLength-(150+roleCredits[roleCreditSelected].artists[3][1]), getProperty('creditsGraphicCa.y')+getProperty('creditsGraphicCa.height'), minLength, 90, roleCredits[roleCreditSelected].barBG[2])
	else
		luaGraphic('creditsGraphicDa', (-#roleCredits[roleCreditSelected].artists[1]*25)-(150+roleCredits[roleCreditSelected].artists[3][1]), getProperty('creditsGraphicCa.y')+getProperty('creditsGraphicCa.height'), #roleCredits[roleCreditSelected].artists[1]*25, 90, roleCredits[roleCreditSelected].barBG[2])
	end
	luaGraphic('creditsGraphicDb', getProperty('creditsGraphicDa.x'), getProperty('creditsGraphicDa.y')+5, getProperty('creditsGraphicDa.width')-5, getProperty('creditsGraphicDa.height')-10, roleCredits[roleCreditSelected].barFG[2])
	luaText('creditsTextDa', getProperty('creditsGraphicCb.x')+5, getProperty('creditsGraphicDb.y')+3, 30, '000000', 'FFFFFF', 'Art:')
	luaText('creditsTextDb', getProperty('creditsGraphicCb.x')+5, getProperty('creditsGraphicDb.y')+35, 40, roleCredits[roleCreditSelected].textColor[2], roleCredits[roleCreditSelected].textBorderColor[2], roleCredits[roleCreditSelected].artists[1])
		setTextWidth('creditsTextDa', getProperty('creditsGraphicDb.width'))
	end


	if roleCredits[roleCreditSelected].coders[2] ~= nil then
		luaSprite('iconA', roleCredits[roleCreditSelected].coders[2], getProperty('creditsGraphicAa.x')+getProperty('creditsGraphicAa.width'), (getProperty('creditsGraphicAa.y')-(getProperty('creditsGraphicAa.height')/2))+roleCredits[roleCreditSelected].coders[3][2])
	end
	if roleCredits[roleCreditSelected].artists[2] ~= nil then
		luaSprite('iconB', roleCredits[roleCreditSelected].artists[2], getProperty('creditsGraphicBa.x')+getProperty('creditsGraphicBa.width'), (getProperty('creditsGraphicBa.y')-(getProperty('creditsGraphicBa.height')/2))+roleCredits[roleCreditSelected].artists[3][2])
	end
	if roleCredits[roleCreditSelected].composers[2] ~= nil then
		luaSprite('iconC', roleCredits[roleCreditSelected].composers[2], getProperty('creditsGraphicCa.x')+getProperty('creditsGraphicCa.width'), (getProperty('creditsGraphicCa.y')-(getProperty('creditsGraphicCa.height')/2))+roleCredits[roleCreditSelected].composers[3][2])
	end
	if roleCredits[roleCreditSelected].charters[2] ~= nil then
		luaSprite('iconD', roleCredits[roleCreditSelected].charters[2], getProperty('creditsGraphicDa.x')+getProperty('creditsGraphicDa.width'), (getProperty('creditsGraphicDa.y')-(getProperty('creditsGraphicDa.height')/2))+roleCredits[roleCreditSelected].charters[3][2])
	end
end
function onCountdownTick(counter)
	if counter == 0 then
		doTweenX('tweenAaX1', 'creditsGraphicAa', 0, 0.25, 'QuintOut')
		doTweenX('tweenAbX1', 'creditsGraphicAb', 0, 0.4, 'QuadOut')
	elseif counter == 1 then
		doTweenX('tweenBaX1', 'creditsGraphicBa', 0, 0.25, 'QuintOut')
		doTweenX('tweenBbX1', 'creditsGraphicBb', 0, 0.4, 'QuadOut')
	elseif counter == 2 then
		doTweenX('tweenCaX1', 'creditsGraphicCa', 0, 0.25, 'QuintOut')
		doTweenX('tweenCbX1', 'creditsGraphicCb', 0, 0.4, 'QuadOut')
	elseif counter == 3 then
		doTweenX('tweenDaX1', 'creditsGraphicDa', 0, 0.25, 'QuintOut')
		doTweenX('tweenDbX1', 'creditsGraphicDb', 0, 0.4, 'QuadOut')
		runTimer('endCredits', duration, 1)
	end
end
function onTweenCompleted(tag)
	if tag == 'tweenDbX2' then
		runTimer('destroyScript', 1, 1)
	end
end
function onTimerCompleted(tag)
	if tag == 'endCredits' then
		runTimer('end1', 1.2, 1)
		runTimer('end2', 1.2, 1)
		runTimer('end3', 1.2, 1)
		runTimer('end4', 1.2, 1)
	end
	if tag == 'end1' then
		doTweenX('tweenAaX2', 'creditsGraphicAa', -getProperty('creditsGraphicAa.width')-(150+roleCredits[roleCreditSelected].coders[3][1]), 0.4, 'QuadIn')
		doTweenX('tweenAbX2', 'creditsGraphicAb', -getProperty('creditsGraphicAb.width'), 0.25, 'QuintIn')
	elseif tag == 'end2' then
		doTweenX('tweenBaX2', 'creditsGraphicBa', -getProperty('creditsGraphicBa.width')-(150+roleCredits[roleCreditSelected].artists[3][1]), 0.4, 'QuadIn')
		doTweenX('tweenBbX2', 'creditsGraphicBb', -getProperty('creditsGraphicBb.width'), 0.25, 'QuintIn')
	elseif tag == 'end3' then
		doTweenX('tweenCaX2', 'creditsGraphicCa', -getProperty('creditsGraphicCa.width')-(150+roleCredits[roleCreditSelected].composers[3][1]), 0.4, 'QuadIn')
		doTweenX('tweenCbX2', 'creditsGraphicCb', -getProperty('creditsGraphicCb.width'), 0.25, 'QuintIn')
	elseif tag == 'end4' then
		doTweenX('tweenDaX2', 'creditsGraphicDa', -getProperty('creditsGraphicDa.width')-(150+roleCredits[roleCreditSelected].charters[3][1]), 0.4, 'QuadIn')
		doTweenX('tweenDbX2', 'creditsGraphicDb', -getProperty('creditsGraphicDb.width'), 0.25, 'QuintIn')
	elseif tag == 'destroyScript' then
		for i = 1,4 do
			removeLuaSprite('creditsGraphic'..string.char(64+i)..'a')
			removeLuaSprite('creditsGraphic'..string.char(64+i)..'b')
			removeLuaText('creditsText'..string.char(64+i)..'a')
			removeLuaText('creditsText'..string.char(64+i)..'b')
			removeLuaScript(scriptName)
		end
	end
end
function onUpdate()
	setProperty('creditsTextAa.x', getProperty('creditsGraphicAb.x')+5)
	setProperty('creditsTextAb.x', getProperty('creditsGraphicAb.x')+5)

	setProperty('creditsTextBa.x', getProperty('creditsGraphicBb.x')+5)
	setProperty('creditsTextBb.x', getProperty('creditsGraphicBb.x')+5)

	setProperty('creditsTextCa.x', getProperty('creditsGraphicCb.x')+5)
	setProperty('creditsTextCb.x', getProperty('creditsGraphicCb.x')+5)

	setProperty('creditsTextDa.x', getProperty('creditsGraphicDb.x')+5)
	setProperty('creditsTextDb.x', getProperty('creditsGraphicDb.x')+5)

	if roleCredits[roleCreditSelected].coders[2] ~= nil then
		setProperty('iconA.x', (getProperty('creditsGraphicAa.x')+getProperty('creditsGraphicAa.width'))+roleCredits[roleCreditSelected].coders[3][1])
	end
	if roleCredits[roleCreditSelected].artists[2] ~= nil then
		setProperty('iconB.x', (getProperty('creditsGraphicBa.x')+getProperty('creditsGraphicBa.width'))+roleCredits[roleCreditSelected].artists[3][1])
	end
	if roleCredits[roleCreditSelected].composers[2] ~= nil then
		setProperty('iconC.x', (getProperty('creditsGraphicCa.x')+getProperty('creditsGraphicCa.width'))+roleCredits[roleCreditSelected].composers[3][1])
	end
	if roleCredits[roleCreditSelected].charters[2] ~= nil then
		setProperty('iconD.x', (getProperty('creditsGraphicDa.x')+getProperty('creditsGraphicDa.width'))+roleCredits[roleCreditSelected].charters[3][1])
	end
end
function luaSprite(tag,image,xPos,yPos)
	makeLuaSprite(tag, 'credits/'..image, xPos, yPos)
    setObjectCamera(tag, 'other')
	addLuaSprite(tag)
end
function luaGraphic(tag,xPos,yPos,width,height,color)
	makeLuaSprite(tag, '', xPos, yPos)
	makeGraphic(tag, width, height, color)
	setObjectCamera(tag, 'other')
	addLuaSprite(tag)
end
function luaText(tag,xPos,yPos,size,colorA,colorB,text)
	makeLuaText(tag, text, 0, xPos, yPos)
	setTextSize(tag, size)
	setTextColor(tag, colorA)
	setTextBorder(tag, 2, colorB)
	setTextAlignment(tag, 'left')
	setObjectCamera(tag, 'other')
	addLuaText(tag)
end