
local strength = 0
function onCreate()
    callShader('createShader',{'chromAb','ChromAbEffect'})
    callShader('runShader',{{'camGame','camHUD'},'chromAb'})
end
function callShader(func,var)
    callScript('scripts/shader',func,var)
end
function lerp(a, b, ratio)
	return a + ratio * (b - a);
end
function onEvent(name, value1, value2)
    if name == "ca strength" then
        callShader('setShaderVar',{'chromAb','strength',value1})
    end
end