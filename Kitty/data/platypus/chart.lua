local defaultNotePos = {};
function onCreatePost()

    callShader('createShader',{'barrel','MirrorRepeatEffect'})
    callShader('createShader',{'colorSwap','ColorSwapEffect'})
    callShader('createShader',{'grey','GreyscaleEffect'})

    callShader('runShader',{'camGame',{'barrel','colorSwap','grey'}})
    callShader('runShader',{'camHUD',{'colorSwap','grey'}})

    --shaderTween('barrel','angle',360,5,'linear')
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
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')-323
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x,y})

        setPropertyFromGroup('strumLineNotes', i, 'scale.x', 0.9)
        setPropertyFromGroup('strumLineNotes', i, 'scale.y', 0.5)
        setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] - 60)
    end
end

function onUpdate()
    setProperty('camHUD.x', mathlerp(getProperty('camHUD.x'), 0, 0.1))

    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'scale.x', mathlerp(getPropertyFromGroup('strumLineNotes', i, 'scale.x'), 0.7, 0.1))
        setPropertyFromGroup('strumLineNotes', i, 'scale.y', mathlerp(getPropertyFromGroup('strumLineNotes', i, 'scale.y'), 0.7, 0.1))
        setPropertyFromGroup('strumLineNotes', i, 'x', mathlerp(getPropertyFromGroup('strumLineNotes', i, 'x'), defaultNotePos[i + 1][1], 0.1))
        setPropertyFromGroup('strumLineNotes', i, 'y', mathlerp(getPropertyFromGroup('strumLineNotes', i, 'y'), defaultNotePos[i + 1][2], 0.1))
    end
end

function mathlerp(from,to,i)return from+(to-from)*i end

function onBeatHit()
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'scale.x', 1.2)
        setPropertyFromGroup('strumLineNotes', i, 'scale.y', 0.2)
        
        if curBeat % 2 == 1 then
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + 70)
            setProperty('camHUD.x',20)
        end
    end
end