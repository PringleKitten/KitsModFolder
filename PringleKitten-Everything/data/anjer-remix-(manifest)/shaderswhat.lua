function onCreatePost()
    callShader('createShader',{'barrel','MirrorRepeatEffect'})
    callShader('createShader',{'colorSwap','ColorSwapEffect'})
    callShader('createShader',{'grey','GreyscaleEffect'})

    callShader('runShader',{'camGame',{'barrel','colorSwap','grey'}})
    callShader('runShader',{'camHUD',{'colorSwap','grey'}})
	callShader('runShader',{'camHUD','barrel'})

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

function onEvent(name,value1,value2)
    if name == 'barrelzoom' then
        shaderVar('barrel','zoom', value1)
        shaderTween('barrel','zoom', 1.0, stepCrochet*0.001*value2, 'cubeOut')
    end
    if name == 'barrelangle' then
        shaderVar('barrel','angle', value1)
        shaderTween('barrel','angle', 0.0, stepCrochet*0.001*value2, 'cubeOut')
    end
end