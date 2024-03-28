-- When pasting this script, change the numbers to the step you want it to zoom
-- I couldn't get the custom event to work at all due to bpm changing issues
local beatinSteps = {
    208,
    220,
    228,
    234,
    236,
    240,
    252,
    260,
    264,
    268,
    272,
    284,
    292,
    298,
    300,
    304,
    316,
    336,
    348,
    356,
    362,
    364,
    368,
    380,
    388,
    392,
    396,
    400,
    412,
    420,
    426,
    428,
    432,
    444,
    464,
    476,
    484,
    490,
    492,
    496,
    508,
    516,
    520,
    524,
    528,
    540,
    548,
    554,
    556,
    592,
    598,
    604,
    612,
    614,
    618,
    620,
    624,
    636,
    644,
    648,
    652,
    656,
    668,
    676,
    682,
    684,
    688
}
function onCreatePost()
    callShader('createShader',{'ca','ChromAbEffect'})
    callShader('createShader',{'barrel','MirrorRepeatEffect'})
    callShader('createShader',{'colorSwap','ColorSwapEffect'})

    callShader('runShader',{'camGame',{'barrel','colorSwap'}})
    callShader('runShader',{'camHUD',{'colorSwap'}})

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

function onSongStart()
    shaderVar('barrel', 'zoom', 1)
    setProperty('camZoomingMult', 0)
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

function onStepHit()
    if #beatinSteps > 0 then
        for i = 1,#beatinSteps do
            if curStep == beatinSteps[i]-1 then
                shaderTween('barrel', 'zoom', 0.8, stepCrochet*0.001, 'cubeIn') --THIS ZOOMS IN
            elseif curStep == beatinSteps[i] then 
                shaderTween('barrel', 'zoom', 1, stepCrochet*0.001*2, 'cubeOut')
                table.remove(beatinSteps,i)
            elseif curStep > beatinSteps[i] then
                table.remove(beatinSteps,i)
            elseif curStep < beatinSteps[i]-1 then
                break
            end
        end
    end
end