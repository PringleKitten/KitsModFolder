function onCreatePost()
    enableShader = getPropertyFromClass('backend.ClientPrefs','data.shaders')
    if enableShader == nil then
        enableShader = true
    elseif enableShader == false then
        close()
    end
    callShader('createShader',{'barrel','MirrorRepeatEffect'})
	callShader('runShader',{'camGame','barrel'})
	callShader('createShader',{'barrelHUD','MirrorRepeatEffect'})
	callShader('runShader',{'camHUD','barrelHUD'})
	shaderVar('barrelHUD','enableClone',true,'bool')
end

function onUpdatePost(elapsed)
    callScript("scripts/shader", "shaderUpdate", {elapsed, getSongPosition()})
end

function onSongStart()
    shaderTween('barrel', 'zoom', 3, stepCrochet*0.001*16, 'cubeOut')
	shaderTween('barrelHUD', 'zoom', 3, stepCrochet*0.001*16, 'cubeOut')
    shaderTween('barrel', 'x', 1, stepCrochet*0.001*16, 'cubeOut')
	shaderTween('barrelHUD', 'x', 1, stepCrochet*0.001*16, 'cubeOut')
end

function onSectionHit()
    ran1 = getRandomInt(2, 8, ran1)
    ran2 = getRandomInt(2, 8, ran2)
    --if a then
    --    shaderVar('barrel', 'flip', true, 'bool')
    --    shaderVar('barrelHUD', 'flip', true, 'bool')
    --else
    --    shaderVar('barrel', 'flip', false, 'bool')
    --    shaderVar('barrelHUD', 'flip', false, 'bool')
    --end
    shaderTween('barrel', 'x', ran1, stepCrochet*0.001*16, 'cubeOut')
	shaderTween('barrelHUD', 'x', ran1, stepCrochet*0.001*16, 'cubeOut')
    shaderTween('barrel', 'y', ran2, stepCrochet*0.001*16, 'cubeOut')
	shaderTween('barrelHUD', 'y', ran2, stepCrochet*0.001*16, 'cubeOut')
end

function callShader(func,vars)
	callScript('scripts/shader',func,vars)
end
function shaderVar(shader,var,value,type)
	callShader('setShaderVar',{shader,var,value,type})
end
function shaderTween(shader,var,value,time,easing)
	callShader('tweenShaderValue',{shader,var,value,time,easing})
end