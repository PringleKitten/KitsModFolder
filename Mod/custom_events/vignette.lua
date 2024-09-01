local strength = 1
local size = 0
local lerpedStrength = 0
local lerpedSize = 0
function onCreate()
    callShader('createShader',{'vignette', 'VignetteEffect'})
    callShader('runShader',{'camGame', 'vignette'})
end
function callShader(func,vars)
    callScript('scripts/shader',func,vars)
end
function onEvent(name, value1, value2)
    if name == "vignette" then
        strength = tonumber(value1)
		size = tonumber(value2)
    end
end
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end

function onUpdate(elapsed)
    lerpedStrength = lerp(lerpedStrength, strength, elapsed*5)
    lerpedSize = lerp(lerpedSize, size, elapsed*5)
    callShader('setShaderVar',{'vignette', 'strength', lerpedStrength})
    callShader('setShaderVar',{'vignette', 'size', lerpedSize})
end