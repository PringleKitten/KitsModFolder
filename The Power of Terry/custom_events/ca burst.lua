
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
    if name == "ca burst" then
        strength = strength + value1
        if value2 ~= nil or value2 ~= '' then
            if (strength > value2) then
                strength = value2
            end
        end
    end
end

function onUpdate(elapsed)
    if strength ~= 0 then
        strength = lerp(strength, 0, elapsed*5)
        if math.abs(strength) <= 0.001 then
            strength = 0
        end
        callShader('setShaderVar',{'chromAb','strength',strength})
    end
end