--local beatinSteps = {}
--
--function onCreatePost()
--    for i = 0,getProperty('eventNotes.length')-1 do
--        if getProperty('eventNotes['..i..'].event') == 'zoomeffect' then
--            table.insert(beatinSteps,getProperty('eventNotes['..i..'].strumTime'))
--        end
--    end
--    callShader('createShader',{'ca','ChromAbEffect'})
--    callShader('createShader',{'barrel','MirrorRepeatEffect'})
--    callShader('createShader',{'colorSwap','ColorSwapEffect'})
--    callShader('createShader',{'grey','GreyscaleEffect'})
--
--    callShader('runShader',{'camGame',{'barrel','colorSwap','grey'}})
--    callShader('runShader',{'camHUD',{'colorSwap','grey'}})
--
--    --shaderTween('barrel','angle',360,5,'linear')
--		callShader('runShader',{'camHUD','barrel'})
--
--end
--function callShader(func,vars)
--    callScript('scripts/shader',func,vars)
--end
--function shaderVar(shader,var,value,type)
--    callShader('setShaderVar',{shader,var,value,type})
--end
--function shaderTween(shader,var,value,time,easing)
--    callShader('tweenShaderValue',{shader,var,value,time,easing})
--end
--
--function onSongStart()
--    shaderTween('barrel', 'zoom', 1, stepCrochet*0.001*63, 'cubeInOut')
--end
--
--function onEvent(name,value1,value2)
--    if name == 'barrelzoom' then
--        shaderVar('barrel','zoom', value1)
--        shaderTween('barrel','zoom', 1.0, stepCrochet*0.001*value2, 'cubeOut')
--    end
--    if name == 'barrelangle' then
--        shaderVar('barrel','angle', value1)
--        shaderTween('barrel','angle', 0.0, stepCrochet*0.001*value2, 'cubeOut')
--    end
--end
--
--function onSongStart()
--    debugPrint(beatinSteps)
--end
--
--function onStepHit()
--    debugPrint(timems)
--    if #beatinSteps > 0 then
--        for i = 1,#beatinSteps do
--            if timems == beatinSteps[i]-1 then
--                shaderTween('barrel', 'zoom', 0.8, stepCrochet*0.001, 'cubeIn')
--            elseif timems == beatinSteps[i] then 
--                shaderTween('barrel', 'zoom', 1, stepCrochet*0.001*3.8, 'cubeOut')
--                table.remove(beatinSteps,i)
--            elseif timems > beatinSteps[i] then
--                table.remove(beatinSteps,i)
--            elseif timems < beatinSteps[i]-1 then
--                break
--            end
--        end
--    end
--end

-- THIS IS IN DEVELOPMENT, DO NOT USE YET, WILL BE READY NEXT UPDATE HOPEFULLY TO MAKE THE NEW EVENT WORK