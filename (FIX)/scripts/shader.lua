local shaderArray = {}
local runningShaders = {}
local shaderTween = {}
local changeCharacterStrum = {}
local enableShader = true
function onCreate()
    enableShader = getPropertyFromClass('ClientPrefs','shaders')
    if enableShader == nil then
        enableShader = true
    end
end
function onCreatePost()
    for events = 0,getProperty('eventNotes.length') do
        if getPropertyFromGroup('eventNotes',events,'event') == 'Change Character' then
            table.insert(changeCharacterStrum,{getPropertyFromGroup('eventNotes',events,'strumTime'),getPropertyFromGroup('eventNotes',events,'value1')})
        end
    end
end
function createShader(lua,s,obrigatory)--(tag, shader, obrigatory)
    if checkFileExists('shaders/'..s..'.frag') then
        if not luaShaderIsRunning(lua) then
            if obrigatory == nil then
                if s == 'MirrorRepeatEffect' then
                    obrigatory = true
                end
            end
            if not enableShader then
                if obrigatory then
                    setPropertyFromClass('ClientPrefs','shaders',true)
                end
            end
            initLuaShader(s)
            makeLuaSprite(lua,nil)
            loadShader(lua,s)
            if obrigatory and not enableShader then
                setPropertyFromClass('ClientPrefs','shaders',false)
            end
        end
    end
end
function getArrayAsString(array)
    local r = nil
    if type(array) == 'table' then
        r = '['
        for i, s in ipairs(array) do
            local g = s
            if i == 1 then
                g = '"'..g..'"'
            elseif i > 1 then
                g = ',"'..g..'"'
            end
            r = r..g
        end
        r = r.."]"
    elseif type(array) == 'string' then
        r = '["'..array.."]"
    end
    return r
end
function loadShader(lua,shader)
    local s = {lua,shader}
    shaderArray[lua] = shader
    runHaxeCode(
        [[
            var shaderLua = ]]..getArrayAsString(s)..[[;
            game.getLuaObject(shaderLua[0]).shader = game.createRuntimeShader(shaderLua[1]);
        ]]
    )

    if shader == 'MirrorRepeatEffect' then
        setShaderFloat(lua,'x',0.0)
        setShaderFloat(lua,'y',0.0)
        setShaderFloat(lua,'angle',0.0)
        setShaderFloat(lua,'zoom',1.0)
        --setShaderFloat(lua,'screenWidth',screenWidth)
        --setShaderFloat(lua,'screenHeight',screenHeight)
    elseif shader == 'ColorSwapEffect' then
        setShaderFloat(lua,'contrast',0)
        setShaderFloat(lua,'saturation',1)
        setShaderFloat(lua,'brightness',1)
    elseif shader == 'GreyscaleEffect' then
        setShaderFloat(lua,'strength',0)

    elseif shader == 'VignetteEffect' or shader == 'PaletteEffect' then
        setShaderFloat(lua,'size',0)
        setShaderFloat(lua,'stretch',0)
        setShaderFloat(lua,'red',0)
        setShaderFloat(lua,'green',0)
        setShaderFloat(lua,'blue',0)
    elseif shader == 'ChromAbEffect' or shader == 'BlurEffect' or shader == 'MosaicEffect' then
        setShaderFloat(lua,'strength',0)

    elseif shader == 'BarrelBlurEffect' then
        setShaderFloat(lua,'barrel',0.0)
        setShaderFloat(lua,'effect',0.0)
        setShaderFloat(lua,'zoom',1.0)
        setShaderBool(lua, 'doChroma', false)
    elseif shader == 'BarrelBlurEffectWithMirror' then
        setShaderFloat(lua,'barrel',0.0)
        setShaderFloat(lua,'effect',0.0)
        setShaderFloat(lua,'zoom',1.0)
        setShaderBool(lua, 'doChroma', false)

        setShaderFloat(lua,'x',0.0)
        setShaderFloat(lua,'y',0.0)
        setShaderFloat(lua,'angle',0.0)
        setShaderFloat(lua,'zoom',1.0)
    elseif shader == 'ColorOverrideEffect' then
        setShaderFloat(lua,'r',0.0)
        setShaderFloat(lua,'b',0.0)
        setShaderFloat(lua,'g',0.0)
    elseif shader == 'ScanlineEffect' then
        setShaderFloat(lua,'strength',0.0)
        setShaderFloat(lua,'pixelsBetweenEachLine',10)
        setShaderFloat(lua,'lineHeight',0.6)
    elseif shader == 'BloomEffect'then
        setShaderFloat(lua,'strength',0.0)
        setShaderFloat(lua,'effect',0.0)
        setShaderFloat(lua,'contrast',0.0)
        setShaderFloat(lua,'brightness',0.0)
    elseif shader == 'ColorFillEffect' then
        setShaderFloat(lua,'red',255)
        setShaderFloat(lua,'blue',255)
        setShaderFloat(lua,'green',255)
        setShaderFloat(lua,'fade',1)
    elseif shader == 'AreaCloneEffect' then
        setShaderFloat(lua,'posXStart',0)
        setShaderFloat(lua,'posXEnd',-1)
        setShaderFloat(lua,'posYStart',0)
        setShaderFloat(lua,'posYEnd',-1)
        setShaderFloat(lua,'x',0)
        setShaderFloat(lua,'y',0)
        setShaderFloat(lua,'fade',0)
    elseif shader == 'ColorShader' then
        setShaderFloat(lua,'red',1)
        setShaderFloat(lua,'blue',1)
        setShaderFloat(lua,'green',1)
        setShaderFloat(lua,'zoom',1)
    end
end
function loadShaderCam(camera,shader)
    local function shaderCamStart(cam,sha)
        if cam == 'camGame' or cam == 'camHUD' or cam == 'camOther' then
            cam = 'game.'..cam
        end
        runHaxeCode(
            [[
                var voiidShaders = [];
                var voiidLuas = ]]..getArrayAsString(sha)..[[;
                for(s in voiidLuas){
                    var initLua = game.getLuaObject(s).shader;
                    if(initLua != null){
                        voiidShaders.insert(voiidShaders.length,new ShaderFilter(initLua));
                    }
                }
                ]]..cam..[[.setFilters(voiidShaders);
            ]]
        )
    end
    local getFromArray = false
    if shader == nil then
        getFromArray = true
    end
    if camera == nil then
        for cam, sha in pairs(runningShaders) do
            if getFromArray then
                shader = sha
            end
            shaderCamStart(cam,shader)
        end
    else
        if getFromArray then
            shader = runningShaders[camera]
        end
        shaderCamStart(camera,shader)
    end
end
function loadShaderSprite(sprite,shader)
    if shader == nil then
        shader = runningShaders[sprite]
    end
    if shader == nil then
        return
    end
    runHaxeCode(
        [[
            var voiidLuas = ]]..getArrayAsString(shader)..[[;
            game.]]..sprite..[[.shader = game.getLuaObject(voiidLuas[0]).shader;
        ]]
    )
end
function luaShaderIsRunning(shader)
    if shaderArray[shader] ~= nil then
        return true
    end
    return false
end
function setShaderArray(object,shader,add)
    if runningShaders[object] == nil then
        runningShaders[object] = {}
    end
    if add == false then
        runningShaders[object] = shader
    else
        for i, sha in pairs(shader) do
            for s, detect in pairs(runningShaders[object]) do
                if sha == detect then
                    table.remove(runningShaders[object],s)
                end
            end
            table.insert(runningShaders[object],sha)
        end
    end
end
function runShader(cam,s,add)
    local set = {}
    if type(s) == 'string' then
        table.insert(set,s)
    elseif type(s) == 'table' then
        set = s
    end        
    for f, curShader in pairs(set) do--detect if shader exists
        if not luaShaderIsRunning(curShader) then
            table.remove(set,f)
        end
    end
    if type(cam) == 'string' then
        setShaderArray(cam,set,add)
    elseif type(cam) == 'table' then
        for i, cams in pairs(cam) do

            setShaderArray(cams,set,add)
        end
    end
    loadShaderCam()
end
function runShaderOnSprite(sprite,s,add)--JUST WORK ONE SHADER!!!!
    local spriteExists = false
    local luaObject = true
    if sprite == 'boyfriend' or sprite == 'boyfriendGroup' or sprite == 'dad' or sprite == 'dadGroup' or sprite == 'gf' or sprite == 'gfGroup' then
        spriteExists = true
        luaObject = false
    else
        spriteExists =  luaSpriteExists(sprite)
    end
    if spriteExists then
        if luaObject then
            sprite = 'getLuaObject("'..sprite..'")'
        end
        local set = {}
        if type(s) == 'string' then
            set[1] = s
        elseif type(s) == 'table' then
            set = s
        end
        --[[for f, runShader in pairs(set) do-- detect if shader exists
            for i, shaders in pairs(shaderArray) do
                if runShader == shaders[1] then
                    break
                end
                if i == #shaderArray then
                    table.remove(set,f)
                end
            end
        end]]--
        setShaderArray(sprite,set,add)
        loadShaderSprite(sprite)
    end
end
function onUpdate(el)
    if #shaderTween > 0 then
        for tween = 1,#shaderTween do
            local shader = shaderTween[tween]
            local value = getProperty(shader[4]..'.x')
            if value == shader[4]..'.x' then
                endTweenShader(shader,tween)
            else
                setShaderFloat(shader[2],shader[3],value)
            end
        end
    end
    if enableShader then
        if (runningShaders['boyfriend'] ~= nil or runningShaders['dad'] ~= nil or runningShaders['gf'] ~= nil) and #changeCharacterStrum > 0 then
            for event = 1,#changeCharacterStrum do
                if getSongPosition() < changeCharacterStrum[event][1] - 100 then--otimization
                    break
                end
                local character = changeCharacterStrum[event][2]
                if runningShaders['boyfriend'] ~= nil and (string.lower(character) == 'bf' or character == '0') then
                    removeSpriteShader('boyfriend')
                end
                if runningShaders['dad'] ~= nil and (string.lower(character) == 'dad' or character == '1') then
                    removeSpriteShader('dad',nil)
                elseif runningShaders['gf'] ~= nil and (string.lower(character) == 'gf' or character == '2') then
                    removeSpriteShader('gf',nil)
                end
                table.remove(changeCharacterStrum,event)
            end
        end
    end
end
function setShaderVar(shader,var,value,type)
    if luaShaderIsRunning(shader) then
        if type == nil or type == 'float' then
            setShaderFloat(shader,var,value)
        elseif type == 'bool' then
            setShaderBool(shader,var,value)
        end
    end
end

function deleteShader(s)
    if shaderArray[s] ~= nil then
        table.remove(shaderArray,s)
        for object, shaTable in pairs(runningShaders) do
            for i, shader in pairs(shaTable[object]) do
                if shader == s then
                    table.remove(runningShaders[object],i)
                end
            end
        end
    end
end
function removeShader(object,s,isCamera)
    if runningShaders[object] ~= nil then
        for i, shader in pairs(runningShaders[object]) do
            if shader == s then
                table.remove(runningShaders[object],i)
            end
        end
        if isCamera then
            loadShaderCam()
        else
            loadShaderSprite(object)
        end
    end
end

function tweenShaderValue(shader,var,value,time,easing)
    if luaShaderIsRunning(shader) then
        local tag = 'shaderTween'..shader..var
        local luaTween = shader..'tweenLua'..var
        local float = getShaderFloat(shader,var)
        cancelShaderTween(tag,nil)
        if float == nil then
            float = 0
        end
        makeLuaSprite(luaTween,nil, float)
        
        if easing == nil then
            easing = 'linear'
        end

        doTweenX(tag,luaTween,value,time,easing)
        table.insert(shaderTween,{tag,shader,var,luaTween,value})
    end
end
function onTweenCompleted(tag)
    if string.find(tag,'shaderTween') then
        for tween = 1,#shaderTween do
            if tag == shaderTween[tween][1] then
                endTweenShader(shaderTween[tween],tween)
                break
            end
        end
    end
end
function cancelShaderTween(tag,pos)
    if #shaderTween > 0 then
        if pos == nil then
            for tweens = 1,#shaderTween do
                if shaderTween[tweens][1] == tag then
                    pos = tweens
                    break
                else
                    if tweens == #shaderTween then
                        return
                    end
                end
            end
        end
        if shaderTween[pos][1] == tag then
            table.remove(shaderTween,pos)
            cancelTween(tag)
        end
    end
end
function endTweenShader(shader,pos)
    table.remove(shaderTween,pos)
    setShaderVar(shader[2],shader[3],shader[5])
    removeLuaSprite(shader[4],true)
end
function onEvent(name,value1,value2)
    if name == 'Change Character' then
        if (string.lower(value1) == 'bf' or value1 == '0') and runningShaders['boyfriend'] ~= nil then
            loadShaderSprite('boyfriend')
        end
    end
    if name == 'shaderthing' then
        shaderVar('barrel','zoom', v1)
        shaderTween('barrel','zoom', 1.0, stepCrochet*0.001*v2, 'cubeOut')
    end
end
function goodNoteHit(id,data,type,sus)
    if (type == 'HIT' or type == 'HIT2') then
        triggerEvent('ca burst', '0.007', '0.01')
    end
end
--[[function getShaderVar(shader,var,type)
    if type == nil or type == 'float' then
        return getShaderFloat(shader,var)
    elseif type == 'bool' then
        return getShaderBool(shader,var)
    end
end]]--