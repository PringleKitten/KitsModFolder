local shaderArray = {}
local runningShaders = {}
local shaderTween = {}
local enableShader = true

function onCreate()
    enableShader = getPropertyFromClass('backend.ClientPrefs','data.shaders')
    if enableShader == nil then
        enableShader = true
    elseif enableShader == false then
        close()
    end
end

function createShader(lua,s,obrigatory)
    if checkFileExists('shaders/'..s..'.frag') then
        if not luaShaderIsRunning(lua) then
            if obrigatory == nil then
                if s == 'MirrorRepeatEffect' then
                    obrigatory = true
                end
            end
            if not enableShader then
                if obrigatory then
                    setPropertyFromClass('backend.ClientPrefs','data.shaders',true)
                end
            end
            initLuaShader(s)
            makeLuaSprite(lua,nil)
            loadShader(lua,s)
            if obrigatory and not enableShader then
                setPropertyFromClass('backend.ClientPrefs','data.shaders',false)
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
    runHaxeCode([[
        var shaderLua = ]]..getArrayAsString(s)..[[;
        game.getLuaObject(shaderLua[0]).shader = game.createRuntimeShader(shaderLua[1]);
    ]])
    if shader == 'MirrorRepeatEffect' then
        setShaderFloat(lua,'x',0.0)
        setShaderFloat(lua,'y',0.0)
        setShaderFloat(lua,'angle',0.0)
        setShaderFloat(lua,'zoom',1.0)
    end
end

function loadShaderCam(camera,shader)
    local function shaderCamStart(cam,sha)
        local code = [[]]
        if cam == 'camGame' or cam == 'camHUD' or cam == 'camOther' then
            code = [[
                var camera = game.]]..cam..[[;
            ]]
        else
            code = [[
                var camera = getVar("]]..cam..[[");
            ]]
        end
        
        code = code..[[
            var sh = [];
            var shL = ]]..getArrayAsString(sha)..[[;
            for(s in shL){
                var initLua = game.getLuaObject(s).shader;
                if(initLua != null){
                    sh.insert(sh.length,new ShaderFilter(initLua));
                }
            }
            
            if(camera != null){
                camera.setFilters(sh);
            }
        ]]
        runHaxeCode(code)
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
            var shL = ]]..getArrayAsString(shader)..[[;
            game.]]..sprite..[[.shader = game.getLuaObject(shL[0]).shader;
        ]]
    )
end

function luaShaderIsRunning(shader)
    return shaderArray[shader] ~= nil
end

function setShaderArray(object,shader,add)
    if runningShaders[object] == nil then
        runningShaders[object] = {}
    end
    if add == false then
        runningShaders[object] = shader
    else
        for _, sha in pairs(shader) do
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
    for f, curShader in pairs(set) do
        if not luaShaderIsRunning(curShader) then
            table.remove(set,f)
        end
    end
    if type(cam) == 'string' then
        setShaderArray(cam,set,add)
    elseif type(cam) == 'table' then
        for _, cams in pairs(cam) do
            setShaderArray(cams,set,add)
        end
    end
    loadShaderCam()
end

function runShaderOnSprite(sprite,s,add)
    local spriteExists = false
    local luaObject = true
    if sprite == 'boyfriend' or sprite == 'boyfriendGroup' or sprite == 'dad' or sprite == 'dadGroup' or sprite == 'gf' or sprite == 'gfGroup' then
        spriteExists = true
        luaObject = false
    else
        spriteExists = luaSpriteExists(sprite)
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
        setShaderArray(sprite,set,add)
        loadShaderSprite(sprite)
    end
end

function onUpdate()
    if #shaderTween > 0 then
        for tween = 1,#shaderTween do
            local shader = shaderTween[tween]
            local value = getProperty(shader[4]..'.x')
            if value == shader[4]..'.x' then
                endTweenShader(shader,tween)
            else
                setShaderVar(shader[2],shader[3],value)
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

function onEvent(name,v1)
    if name == 'Change Character' then
        if (string.lower(v1) == 'bf' or v1 == '0') and runningShaders['boyfriend'] ~= nil then
            loadShaderSprite('boyfriend')
        end
    end
end