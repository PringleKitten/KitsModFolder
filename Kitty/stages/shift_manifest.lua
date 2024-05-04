function onCreate()
    makeAnimatedLuaSprite('bg','sky/bg_manifest',-350,10)
    addLuaSprite('bg')
    addAnimationByPrefix('bg','bump','sky/bg_manifest',24)
    objectPlayAnimation('bg','bump',true)

    makeAnimatedLuaSprite('floor','sky/floorManifest',-970,-180)
    addLuaSprite('floor')
    addAnimationByPrefix('floor','bump','sky/floorManifest',24)
    objectPlayAnimation('floor','bump',true)
end