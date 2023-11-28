function onSongStart()
    precacheImage('me/anim/Transform')
    precacheImage('me/anim/slash')
end
function onUpdate()
    if curStep == 498 then
        makeAnimatedLuaSprite('tf', 'me/anim/Transform', 250, 600)
        addAnimationByPrefix('tf', 'Transform', 'Transform Transform', 18, false)
        addLuaSprite('tf', true)
        setProperty('tf.scale.x', 5)
        setProperty('tf.scale.y', 5)
    end
    if getProperty('tf.animation.curAnim.finished') then
        removeLuaSprite('tf')
    end
end