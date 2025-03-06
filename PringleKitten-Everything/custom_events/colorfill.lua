
local fade = 1
local targetFade = 0
function onCreatePost()
    callShader('createShader',{'colorFill','ColorFillEffect'})
    callShader('runShaderOnSprite', {'dad','colorFill'})
    callShader('runShaderOnSprite', {'boyfriend','colorFill'})
    callShader('runShaderOnSprite', {'gf','colorFill'})
    --makeSprite('colorBG', '', 0,0)
    --makeGraphicRGB('colorBG', 1500/getCamZoom(),1000/getCamZoom(), '0,0,0')
    --actorScreenCenter('colorBG')
    --setActorScroll(0,0,'colorBG')
    --setActorLayer('colorBG', 0)
    makeLuaSprite('colorBG', '', 0,0)
    makeGraphic('colorBG', 3000/getProperty('defaultCamZoom'),3000/getProperty('defaultCamZoom'), 'FFFFFF')
    screenCenter('colorBG')
    setScrollFactor('colorBG',0,0)
    setProperty('colorBG.alpha',0.001)
    addLuaSprite('colorBG',false)
    setObjectOrder('colorBG', getObjectOrder('gfGroup')-1)
end
function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function callShader(func,vars)
    callScript('scripts/shader',func,vars)
end
function colorVar(var,value)
    callShader('setShaderVar',{'colorFill',var,value})
end
function tweenShader(var,value,time,easing)
    callShader('tweenShaderValue',{'colorFill',var,value,time,easing})
end
function toRGB(rgb)
    --Credits to marceloCodget for the script = https://gist.github.com/marceloCodget/3862929
	local hexadecimal = ''
	for key, value in pairs(rgb) do
		local hex = ''

		while(tonumber(value) ~= nil and tonumber(value) > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end
    return getColorFromHex(hexadecimal);
end
local enabled = false
function onEvent(name, value1, value2)
    if name == "colorfill" then
        enabled = not enabled
        local charCol = split(value1, ",")
        --local str = easeStuff[2]
        --trace(charCol)
        local easeStuff = {}
        if value2 ~= '' then
            easeStuff = split(value2, ",")
        else
            easeStuff = {0.5,'sineOut'}
        end

        if enabled then
            local characterColor = toRGB({charCol[1],charCol[2],charCol[3]})
            setObjectOrder('colorBG',getObjectOrder('gfGroup')-1)
            setProperty('colorBG.color',toRGB({charCol[4],charCol[5],charCol[6]}))
            doTweenAlpha('colorBGAlpha', 'colorBG', 1, tonumber(easeStuff[1]), easeStuff[2])
            --doTweenColor('colorBFFill','boyfriend',characterColor,tonumber(easeStuff[1]),easeStuff[2])
            --doTweenColor('colorDadFill','dad',characterColor,tonumber(easeStuff[1]),easeStuff[2])
            --doTweenColor('colorGFFill','gf',characterColor,tonumber(easeStuff[1]),easeStuff[2])
            colorVar('red', tonumber(charCol[1]))
            colorVar('green', tonumber(charCol[2]))
            colorVar('blue', tonumber(charCol[3]))
            tweenShader('fade', 0, tonumber(easeStuff[1]), easeStuff[2])
        else
            --doTweenColor('colorBFFill','boyfriend','FFFFFF',tonumber(easeStuff[1]),easeStuff[2])
            --doTweenColor('colorDadFill','dad','FFFFFF',tonumber(easeStuff[1]),easeStuff[2])
            doTweenAlpha('colorBGAlpha', 'colorBG', 0, tonumber(easeStuff[1]), easeStuff[2])
            tweenShader('fade', 1, tonumber(easeStuff[1]), easeStuff[2])
                        --doTweenColor('colorGfFill','gf','FFFFFF',tonumber(easeStuff[1]),easeStuff[2])
            --targetFade = 1
        end
    end
end