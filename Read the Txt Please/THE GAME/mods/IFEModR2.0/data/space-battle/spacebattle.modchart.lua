callScript("scripts/videoSprite", "performanceD")
callScript("scripts/LaneUnderlay", "noChoice")
callScript("scripts/ratings", "noChoice")
local nuh = 0
local camW = 0
local camH = 0
local mM = 1
local ignoreCall = false
    local dSM = 1
    local wtffs = 0
    local a = 0
    local sSs = 2.6
    local ialrdid = false
    local wtff = false
    local goDownMore = 0
    local mcS = 1
    local p0x = 0
    local p1x = 0
    local p2x = 0
    local p3x = 0
    local p0y = 0
    local p1y = 0
    local p2y = 0
    local p3y = 0
    local ffi
    local letter = '?'
    local nr = 0
    local posXR = 0
    local posYR = 0
    local tweening = false
    local tweenEndTime = 0
    local windowShaking = false
    local shakeLevel = 25
    local windowOriginX = 0
    local windowOriginY = 0
    local newOriginX = 0
    local newOriginY = 0
    local coolNoteThing = false
    local lockWindow = true
    local TRANSPARENT_COLOR = 0x00FF00FF
    local noteHit = {
        [0] = function()
            setWindow(windowOriginX-50,"+0",1280,720)
            tWin(1,windowOriginX, 0.4, 'quadOut')
            tweening = true
            aa = true
        end,
    
        [1] = function()
            setWindow("+0",windowOriginY+50,1280,720)
            tWin(2,windowOriginY, 0.4, 'quadOut')
            tweening = true
            bb = true
        end,
    
        [2] = function()
            setWindow("+0",windowOriginY-50,1280,720)
            tWin(2,windowOriginY, 0.4, 'quadOut')
            tweening = true
            bb = true
        end,
    
        [3] = function()
            setWindow(windowOriginX+50,"+0",1280,720)
            tWin(1,windowOriginX, 0.4, 'quadOut')
            tweening = true
            aa = true
        end
    }
local stepBlocks = {
    {128,130}, 132, {134,136}, 138, {140,142}, {144,146}, 148, {150,152}, 154, {156,158}, {160,162}, 164, {166,168}, 170, {172,174}, {176,178}, 180, {182,184}, 186, {188,190}, {192,194}, 196, {198,200}, 202, {204,206}, {208,210}, 212, {214,216}, 218, {220,222}, {224,226}, 228, {230,232}, 234, {236,238},
    {528,542}, {560,574},
    {2048,2050}, 2052, {2054,2056}, 2058, {2060,2062}, {2064,2066}, 2068, {2070,2072}, 2074, {2076,2078}, {2080,2082}, 2084, {2086,2088}, 2090, {2092,2094}, {2096,2098}, 2100, {2102,2104}, 2106, {2108,2110}, {2112,2114}, 2116, {2118,2120}, 2122, {2124,2126}, {2128,2130}, 2132, {2134,2136}, 2138, {2140,2142}, {2144,2146}, 2148, {2150,2152}, 2154, {2156,2158},
    {2176,2178}, 2180, {2182,2184}, 2186, {2188,2190}, {2192,2194}, 2196, {2198,2200}, 2202, {2204,2206}, {2208,2210}, 2212, {2214,2216}, 2218, {2220,2222}, {2224,2226}, 2228, {2230,2232}, 2234, {2236,2238}, {2240,2242}, 2244, {2246,2248}, 2250, {2252,2254}, {2256,2258}, 2260, {2262,2264}, 2266, {2268,2270}, {2272,2274}, 2276, {2278,2280}, 2282, {2284,2286},
    {2304,2306}, 2308, {2310,2312}, 2314, {2316,2318}, {2320,2322}, 2324, {2326,2328}, 2330, {2332,2334}, {2336,2338}, 2340, {2342,2344}, 2346, {2348,2350}, {2352,2354}, 2356, {2358,2360}, 2362, {2364,2366}, {2368,2370}, 2372, {2374,2376}, 2378, {2380,2382}, {2384,2386}, 2388, {2390,2392}, 2394, {2396,2398}, {2400,2402}, 2404, {2406,2408}, 2410, {2412,2414},
    {1328,1342}
}
local stepActions = {
    [240] = function()
        setProperty('camThree.y', -100 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [244] = function()
        setProperty('camThree.y', 0)
        doTweenY('sv', 'camThree', -100 /mM*dSM, 0.3, 'linear')
    end,
    [248] = function()
        wtff = true
        runTimer('wtff', 0.02)
        setProperty('camThree.y', 0)
    end,
    [252] = function()
        wtff = false
        goDownMore = 0
        setProperty('camThree.y', 50)
    end,
    [254] = function()
        setProperty('camThree.y', -50)
    end,
    [256] = function()
        setProperty('camThree.y', 0)
        goingG = false
        mcS = 2
    end,
    [574] = function()
        changeCam()
        goingG = true
        r = true
        doTweenX('strumsXX', 'camThree', 900, 0.07, 'sineIn')
        doTweenX('svXX', 'camTwo', 900, 0.07, 'sineIn')
        doTweenAngle('viewa', 'camThree', 35, 0.8, 'sineOut')
        doTweenAngle('viewb', 'camTwo', 35, 0.8, 'sineOut')
    end,
    [576] = function()
        doTweenX('strumsXXe', 'camTwo', 100, 1.04, 'sineOut')
        doTweenX('svXXe', 'camThree', 100, 1.04, 'sineOut')
    end,
    [590] = function()
        r = false
        doTweenX('strumsXX', 'camThree', -900, 0.07, 'sineIn')
        doTweenX('svXX', 'camTwo', -900, 0.07, 'sineIn')
        doTweenAngle('viewa', 'camThree', -35, 0.8, 'sineOut')
        doTweenAngle('viewb', 'camTwo', -35, 0.8, 'sineOut')
    end,
    [592] = function()
        doTweenX('strumsXXe', 'camTwo', -100, 1.04, 'sineOut')
        doTweenX('svXXe', 'camThree', -100, 1.04, 'sineOut')
    end,
    [608] = function()
        setProperty('camTwo.y', -300)
        setProperty('camThree.y', 600)
        setProperty('camTwo.angle', 0)
        setProperty('camThree.angle', 0)
        setProperty('camTwo.x', 0)
        setProperty('camThree.x', 0)
        doTweenY('strumsXXe', 'camTwo', 0, 0.4, 'backOut')
        doTweenY('svXXe', 'camThree', 0, 0.4, 'backOut')
    end,
    [960] = function()
        lockWindow = false
        windowShaking = true
    end,
    [1007] = function()
        windowShaking = false
        resizeW()
        coolNoteThing = true
    end,
    [1023] = function()
        coolNoteThing = false
        resizeW()
        if buildTarget ~= 'android' then
            runHaxeCode([[
                import lime.app.Application;
                import flixel.tweens.FlxTween;
                import flixel.tweens.FlxEase;
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
                wnd.borderless = true;
                var startW = wnd.width;
                var startH = wnd.height;
                FlxTween.tween(wnd, {width: 1920, height: 1082}, 0.2, {ease: FlxEase.sineOut});
                FlxTween.tween(wnd, {x: 0, y: 0}, 0.2, {ease: FlxEase.sineOut});
            ]])
            runTimer('tweenW', 0.2)
        else
            setWindow('center','center',1920,1082,true)
            doTweenAlpha('screenB', 'screen', 0, 0.3)
        end
    end,
    [1040] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1044] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1048] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1052] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1056] = function()
        newWO = false
    end,
    [1057] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1072] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1076] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1080] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1084] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1088] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1136] = function()
        goingG = true
        setProperty('camThree.y', -100 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [1140] = function()
        setProperty('camThree.y', 0 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [1144] = function()
        wtff = true
        wtffs = -9
        runTimer('wtff', 0.02)
        setProperty('camThree.y', 0)
    end,
    [1151] = function()
        cancelTimer('wtff')
        wtff = false
        goDownMore = 0
        setProperty('camThree.y', 0)
    end,
    [1168] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1172] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1176] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1180] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1184] = function()
        newWO = false
    end,
    [1185] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1200] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1204] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1208] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1212] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1216] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1264] = function()
        goingG = true
        setProperty('camThree.y', -100 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [1268] = function()
        setProperty('camThree.y', 0 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [1272] = function()
        wtff = true
        wtffs = -9
        runTimer('wtff', 0.02)
        setProperty('camThree.y', 0)
    end,
    [1279] = function()
        cancelTimer('wtff')
        wtff = false
        goDownMore = 0
        setProperty('camThree.y', 0)
    end,
    [1392] = function()
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
    end,
    [1919] = function()
        setWindow("center","center",1280,720)
    end,
    [2046] = function()
        mcS = 1
    end,
    [2816] = function()
        setWindow("center","center",1280,720)
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY-100, 1.18, 'quadOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        endingYO = true
        tweening = true
    end,
    [2832] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        tweening = true
        windowShaking = true
    end,
    [2840] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2844] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2848] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [2849] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2864] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        tweening = true
        windowShaking = true
    end,
    [2872] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2876] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2880] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [2881] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2896] = function()
        tWin(2,windowOriginY+100, 1.18, 'easeOut',true,true)
    end,
    [2912] = function()
        tWin(2,windowOriginY, 1.18, 'easeOut',true,true)
    end,
    [2944] = function()
        setWindow("center","center",1280,720)
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        newWO = true
        tWin(2,windowOriginY-100, 1.18, 'quadOut',true,true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        tweening = true
    end,
    [2960] = function()
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true,true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        tweening = true
        windowShaking = true
    end,
    [2968] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true,true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2972] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true,true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [2976] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true,true)
        windowShaking = false
        newWO = false
    end,
    [2977] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2992] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        tweening = true
        windowShaking = true
    end,
    [3000] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [3004] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        if buildTarget ~= 'android' then
            newOriginX = windowOriginX
            newOriginY = windowOriginY
        end
        windowShaking = true
    end,
    [3008] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [3009] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [3024] = function()
        tWin(2,windowOriginY+100, 1.18, 'easeOut',true)
    end,
    [3040] = function()
        tWin(2,windowOriginY, 1.18, 'easeOut',true)
    end,
    [3264] = function()
        lockWindow = false
        windowShaking = true
    end,
    [3311] = function()
        windowShaking = false
        resizeW()
        coolNoteThing = true
        endingYO = false
    end,
    --
    [3327] = function()
        coolNoteThing = false
        resizeW()
        if buildTarget ~= 'android' then
            runHaxeCode([[
                import lime.app.Application;
                import flixel.tweens.FlxTween;
                import flixel.tweens.FlxEase;
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
                wnd.borderless = true;
                var startW = wnd.width;
                var startH = wnd.height;
                FlxTween.tween(wnd, {width: 1920, height: 1082}, 0.2, {ease: FlxEase.sineOut});
                FlxTween.tween(wnd, {x: 0, y: 0}, 0.2, {ease: FlxEase.sineOut});
            ]])
            runTimer('tweenW', 0.2)
        else
            setWindow('center','center',1920,1082,true)
            doTweenAlpha('screenB', 'screen', 0, 0.3)
        end
    end,
    [3344] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3348] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3352] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3356] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3360] = function()
        newWO = false
    end,
    [3361] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [3376] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3380] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3384] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3388] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3393] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [3440] = function()
        goingG = true
        setProperty('camThree.y', -100 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [3444] = function()
        setProperty('camThree.y', 0 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [3448] = function()
        wtff = true
        wtffs = -9
        runTimer('wtff', 0.02)
        setProperty('camThree.y', 0)
    end,
    [3455] = function()
        cancelTimer('wtff')
        wtff = false
        goDownMore = 0
        setProperty('camThree.y', 0)
    end,
    [3472] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3476] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3480] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3484] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3488] = function()
        newWO = false
    end,
    [3489] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [3504] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3508] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3512] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3516] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3521] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [3568] = function()
        goingG = true
        setProperty('camThree.y', -100 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [3572] = function()
        setProperty('camThree.y', 0 /mM*dSM)
        doTweenY('sv', 'camThree', 100 /mM*dSM, 0.3, 'linear')
    end,
    [3576] = function()
        wtff = true
        wtffs = -9
        runTimer('wtff', 0.02)
        setProperty('camThree.y', 0)
    end,
    [3583] = function()
        cancelTimer('wtff')
        wtff = false
        goDownMore = 0
        setProperty('camThree.y', 0)
    end,
    [3584] = function()
        setWindow("center","center",1280,720)
    end,
    [3696] = function()
        setProperty('screen.alpha',1)
    end,
    [4224] = function()
        setWindow("center","center",1920,1082)
    end,
    [4248] = function()
        setWindow("+0","-500",1920,1082)
        lockWindow = false
    end,
    [4250] = function()
        setWindow("+0","+2500",1920,1082)
    end
}
local stepActions2 = {
    [574] = function()
        changeCam()
        goingG = true
        r = true
        doTweenX('strumsXX', 'camThree', 900, 0.07, 'sineIn')
        doTweenX('svXX', 'camTwo', 900, 0.07, 'sineIn')
        doTweenAngle('viewa', 'camThree', 35, 0.8, 'sineOut')
        doTweenAngle('viewb', 'camTwo', 35, 0.8, 'sineOut')
    end,
    [576] = function()
        doTweenX('strumsXXe', 'camTwo', 100, 1.04, 'sineOut')
        doTweenX('svXXe', 'camThree', 100, 1.04, 'sineOut')
    end,
    [590] = function()
        r = false
        doTweenX('strumsXX', 'camThree', -900, 0.07, 'sineIn')
        doTweenX('svXX', 'camTwo', -900, 0.07, 'sineIn')
        doTweenAngle('viewa', 'camThree', -35, 0.8, 'sineOut')
        doTweenAngle('viewb', 'camTwo', -35, 0.8, 'sineOut')
    end,
    [592] = function()
        doTweenX('strumsXXe', 'camTwo', -100, 1.04, 'sineOut')
        doTweenX('svXXe', 'camThree', -100, 1.04, 'sineOut')
    end,
    [608] = function()
        setProperty('camTwo.y', -300)
        setProperty('camThree.y', 600)
        setProperty('camTwo.angle', 0)
        setProperty('camThree.angle', 0)
        setProperty('camTwo.x', 0)
        setProperty('camThree.x', 0)
        doTweenY('strumsXXe', 'camTwo', 0, 0.4, 'backOut')
        doTweenY('svXXe', 'camThree', 0, 0.4, 'backOut')
    end,
    [616] = function()
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camTwo];
            }
        ]])
        goingG = true
    end,
    [960] = function()
        goingG = false
        runHaxeCode([[
            for (i in 0...4) {
                playerStrums.members[i].cameras = [camOne];
            }
            grpNoteSplashes.forEachAlive(function(splash) splash.cameras = [camOne]);
        ]])

        lockWindow = false
        windowShaking = true
    end,
    [1007] = function()
        windowShaking = false
        resizeW()
        coolNoteThing = true
    end,
    [1023] = function()
        if buildTarget ~= 'android' then
            coolNoteThing = false
            cancelTween('windowTweenX')
            cancelTween('windowTweenY')
            resizeW()
            runHaxeCode([[
                import lime.app.Application;
                import flixel.tweens.FlxTween;
                import flixel.tweens.FlxEase;
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
                wnd.borderless = true;
                var startW = wnd.width;
                var startH = wnd.height;
                FlxTween.tween(wnd, {width: 1920, height: 1082}, 0.2, {ease: FlxEase.sineOut});
                FlxTween.tween(wnd, {x: 0, y: 0}, 0.2, {ease: FlxEase.sineOut});
            ]])
            runTimer('tweenW', 0.2)
        else
            setWindow('center','center',1920,1082,true)
        end
    end,
    [1040] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1044] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1048] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1052] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1056] = function()
        newWO = false
    end,
    [1057] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1072] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1076] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1080] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1084] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1088] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1168] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1172] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1176] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1180] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1184] = function()
        newWO = false
    end,
    [1185] = function()
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = tru
    end,
    [1200] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1204] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [1208] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [1212] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [1216] = function()
        newWO = false
        windowShaking = false
        resizeW()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [1392] = function()
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
    end,
    [1919] = function()
        setWindow("center","center",1280,720)
    end,
    [2816] = function()
        setWindow("center","center",1280,720)
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY-100, 1.18, 'quadOut',true)
        endingYO = true
        tweening = true
    end,
    [2832] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        tweening = true
        windowShaking = true
    end,
    [2840] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2844] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2848] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [2849] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2864] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        tweening = true
        windowShaking = true
    end,
    [2872] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2876] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2880] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [2881] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2896] = function()
        tWin(2,windowOriginY+100, 1.18, 'easeOut',true)
    end,
    [2912] = function()
        tWin(2,windowOriginY, 1.18, 'easeOut',true)
    end,
    [2944] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            setWindow("center","center",1280,720)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY-100, 1.18, 'quadOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        tweening = true
    end,
    [2960] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        tweening = true
        windowShaking = true
    end,
    [2968] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2972] = function()
        tWin(2,windowOriginY+100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [2976] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [2977] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [2992] = function()
        lockWindow = false
        newWO = true
        tWin(2,windowOriginY+100, 0.59, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        tweening = true
        windowShaking = true
    end,
    [3000] = function()
        tWin(2,windowOriginY-100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [3004] = function()
        tWin(2, windowOriginY+100, 0.29, 'easeOut',true)
        newOriginX = windowOriginX
        newOriginY = windowOriginY
        windowShaking = true
    end,
    [3008] = function()
        tWin(2,windowOriginY-100, 1.18, 'easeOut',true)
        windowShaking = false
        newWO = false
    end,
    [3009] = function()
        if buildTarget ~= 'android' then
            setProperty('bg.x',0)
            setProperty('bg.y',0)
        end
    end,
    [3024] = function()
        tWin(2,windowOriginY+100, 1.18, 'easeOut',true)
    end,
    [3040] = function()
        tWin(2,windowOriginY, 1.18, 'easeOut',true)
    end,
    [3264] = function()
        lockWindow = false
        windowShaking = true
    end,
    [3311] = function()
        windowShaking = false
        resizeW()
        coolNoteThing = true
        endingYO = false
    end,
    [3327] = function()
        if buildTarget ~= 'android' then
            coolNoteThing = false
            cancelTween('windowTweenY')
            cancelTween('windowTweenX')
            runHaxeCode([[
                import lime.app.Application;
                import flixel.tweens.FlxTween;
                import flixel.tweens.FlxEase;
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
                wnd.borderless = true;
                var startW = wnd.width;
                var startH = wnd.height;
                FlxTween.tween(wnd, {width: 1920, height: 1082}, 0.2, {ease: FlxEase.sineOut});
                FlxTween.tween(wnd, {x: 0, y: 0}, 0.2, {ease: FlxEase.sineOut});
            ]])
            runTimer('tweenW', 0.2)
        else
            setWindow('center','center',1920,1082,true)
        end
    end,
    [3344] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3348] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3352] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3356] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3360] = function()
        newWO = false
    end,
    [3361] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        setWindow(0,0,1920,1082)
        windowShaking = false
        lockWindow = true
        resizeW()
    end,
    [3376] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3380] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3384] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3388] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3393] = function()
        newWO = false
        windowShaking = false
        resizeW()
        setWindow(0,0,1920,1082)
        lockWindow = true
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
    end,
    [3472] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3476] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3480] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3484] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3488] = function()
        newWO = false
    end,
    [3489] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
        windowShaking = false
        resizeW()
        setWindow(0,0,1920,1082)
        lockWindow = true
    end,
    [3504] = function()
        if buildTarget ~= 'android' then
            scaleObject('bg', 0,0,true)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = false;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("+0","+0",1280,720)
        lockWindow = false
        newWO = true
        newOriginX = windowOriginX-100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3508] = function()
        newOriginX = windowOriginX-20
        newOriginY = windowOriginY-80
        windowShaking = true
    end,
    [3512] = function()
        newOriginX = windowOriginX+100
        newOriginY = windowOriginY-10
        windowShaking = true
    end,
    [3516] = function()
        newOriginX = windowOriginX-50
        newOriginY = windowOriginY+100
        windowShaking = true
    end,
    [3521] = function()
        newWO = false
        windowShaking = false
        resizeW()
        setWindow(0,0,1920,1082)
        lockWindow = true
        if buildTarget ~= 'android' then
            scaleObject('bg', 1,1,true)
            setProperty('bg.x',0)
            setProperty('bg.y',0)
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.borderless = true;
            ]])
        end
        if buildTarget == 'android' then
            setProperty('screen.alpha',0)
        end
    end,
    [3584] = function()
        setWindow("center","center",1280,720)
    end,
    [3696] = function()
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
    end,
    [4224] = function()
        if buildTarget == 'android' then
            setProperty('screen.alpha',1)
        end
        setWindow("center","center",1920,1082)
    end,
    [4248] = function()
        setWindow("+0","-500",1920,1082)
        lockWindow = false
    end,
    [4250] = function()
        setWindow("+0","+2500",1920,1082)
    end
}
local stepSet = {}
for _, block in ipairs(stepBlocks) do
    if type(block) == "table" then
        for i = block[1], block[2] do
            stepSet[i] = true
        end
    else
        stepSet[block] = true
    end
end
function onStepHit()
    if not mechanicsAgain and assetMovement then
        if stepActions2[curStep] then
            stepActions2[curStep]()
        end
        if goingG then
            runHaxeCode([[
                for (note in notes) {
                    if (note.mustPress) {
                        note.cameras = [camThree];
                    }
                }
            ]])
        end
    end
    if mechanicsAgain then
        if mcS == 1 and stepSet[curStep] then
            goingG = true
            setProperty('camThree.y', -109/mM*dSM)
            doTweenY('sv', 'camThree', 109/mM*dSM, 0.152, 'linear')
        end
        if stepActions[curStep] then
            stepActions[curStep]()
        end
        if mcS == 2 and stepSet[curStep] and (curStep % 2 == 0) then
            goingG = true
            setProperty('camThree.y', -109/mM*dSM)
            doTweenY('sv', 'camThree', 109/mM*dSM, 0.152, 'linear')
        end
        -- Other Thing --
        if goingG then
            runHaxeCode([[
                for (note in notes) {
                    if (note.mustPress) {
                        note.cameras = [camThree];
                    }
                }
            ]])
        end
    end
end
function onEvent(n,v1,v2)
    if assetMovement and n == '' then
        if v1 == 'winZoom' then
            if buildTarget ~= 'android' then
                scaleObject('bg', 0,0,true)
                setWindow("center","center",getPropertyFromClass('openfl.Lib', 'application.window.width')/1.2,getPropertyFromClass('openfl.Lib', 'application.window.height')/1.2)
            else
                setWindow("center","center",(1280*newZoom)*1.2,(720*newZoom)*1.2)
            end
        elseif v1 == 'winZoom-' then
            if buildTarget ~= 'android' then
                setWindow("center","center",getPropertyFromClass('openfl.Lib', 'application.window.width')*1.3,getPropertyFromClass('openfl.Lib', 'application.window.height')*1.3)
            else
                setWindow("center","center",(1280*newZoom)*2,(720*newZoom)*2)
            end
        elseif v1 == 'winZoom+' then
            setWindow("center","center",1920,1082)
            setProperty('screen.alpha', 1)
        end
        if v1 == 'wR' then
            setWindow('+50','center',1280,720)
            tWin(1, windowOriginX, 0.4, 'quadOut')
            tweening = true
            aa = true
        end
        if v1 == 'wL' then
            setWindow('-50',"center",1280,720)
            tWin(1, windowOriginX, 0.4, 'quadOut')
            tweening = true
            aa = true
        end
        if v1 == 'wU' then
            setWindow("center",'-50',1280,720)
            tWin(2, windowOriginY, 0.4, 'quadOut')
            tweening = true
            bb = true
        end
        if v1 == 'funny' then
            if v2 == 'o' then
                setPropertyFromGroup('playerStrums',0,'x',p0x)
                setPropertyFromGroup('playerStrums',1,'x',p1x)
                setPropertyFromGroup('playerStrums',2,'x',p2x)
                setPropertyFromGroup('playerStrums',3,'x',p3x)
                setPropertyFromGroup('playerStrums',0,'y',p0y)
                setPropertyFromGroup('playerStrums',1,'y',p1y)
                setPropertyFromGroup('playerStrums',2,'y',p2y)
                setPropertyFromGroup('playerStrums',3,'y',p3y)
            else
                setPropertyFromGroup('playerStrums',0,'x',p0x+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',1,'x',p1x+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',2,'x',p2x+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',3,'x',p3x+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',0,'y',p0y+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',1,'y',p1y+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',2,'y',p2y+getRandomInt(-30,30))
                setPropertyFromGroup('playerStrums',3,'y',p3y+getRandomInt(-30,30))
            end
        end
        local bruh = 1
        if buildTarget == 'android' then
            bruh = 3/4
        end
        if v1 == 'zz1' then
            goingG = true
            setProperty('camTwo.zoom', getProperty('camTwo.zoom')+0.2)
            doTweenZoom('cz', 'camTwo', 1, 0.3, 'sineIn')
            if buildTarget ~= 'android' then
                setProperty('camThree.zoom', getProperty('camThree.zoom')+0.3)
                doTweenZoom('czz', 'camThree', 0.5, 0.3, 'sineIn')
            else
                setProperty('camThree.zoom', getProperty('camThree.zoom')+0.3/getProperty('camThree.flashSprite.scaleY'))
                doTweenZoom('czz', 'camThree', (1 / getProperty('camThree.flashSprite.scaleY')) - 0.5, 0.3, 'sineIn')
            end
        elseif v1 == 'zz2' then
            if v2 == 'o' then
                goingG = true
                setProperty('camTwo.zoom', getProperty('camTwo.zoom')-0.2)
                doTweenZoom('cz', 'camTwo', 1, 0.3, 'sineIn')
                if buildTarget ~= 'android' then
                    setProperty('camThree.zoom', getProperty('camThree.zoom')-0.3)
                    doTweenZoom('czz', 'camThree', 0.5, 0.3, 'sineIn')
                else
                    setProperty('camThree.zoom', getProperty('camThree.zoom')-0.3/getProperty('camThree.flashSprite.scaleY'))
                    doTweenZoom('czz', 'camThree', (1 / getProperty('camThree.flashSprite.scaleY')) - 0.5, 0.3, 'sineIn')
                end
            else
                goingG = true
                setProperty('camTwo.zoom', getProperty('camTwo.zoom')+0.2)
                doTweenZoom('cz', 'camTwo', 1, 0.3, 'sineIn')
                if buildTarget ~= 'android' then
                    setProperty('camThree.zoom', getProperty('camThree.zoom')+0.3)
                    doTweenZoom('czz', 'camThree', 0.5, 0.3, 'sineIn')
                else
                    setProperty('camThree.zoom', getProperty('camThree.zoom')+0.3/getProperty('camThree.flashSprite.scaleY'))
                    doTweenZoom('czz', 'camThree', (1 / getProperty('camThree.flashSprite.scaleY')) - 0.5, 0.3, 'sineIn')
                end
            end
        end
    end
end
function onCreatePost()
    --buildTarget = 'android'
    if not downscroll then
        setProperty('botplayTxt.y',90)
        setProperty('practiceTxt.y', 90)
    else
        setProperty('botplayTxt.y',610)
        setProperty('practiceTxt.y', 610)
    end
    health = (getHealth()*50)
    nr = (math.floor(rating*10000)/100)
    luatxt("mainacc", (letter..' - '..nr.."%"), 1280, 0, 25,'other',30,'.','.','right','.')
    luatxt("mainsc", score, 1280, 0, 55,'other',25,'.','.','right','.')
    luatxt("mainhp", ("[Health] "..health), 1280, 0, 0,'other',25,'00AAFF','.','right','.')
        screenCenter("mainhp", 'x')
    luatxt("timeLeftText", "0:00", 200, 0, -2, 'other', 32, 'FF00FF', '.', 'center', '.')
        screenCenter("timeLeftText", 'x')
    luatxt("msText", 'ms', 200, 0, 0, 'other', 20, 'FFFFFF', '.', 'center', '.')
        screenCenter("msText",'xy')
        setProperty("msText.alpha", 0)
    setProperty('botplayTxt.x', 105)
    setProperty('practiceTxt.x', 710)
    setTextSize("botplayTxt", 25)
    setTextSize("practiceTxt", 25)
    setTextBorder('botplayTxt', 1, 'ff00ff')
    setTextColor('botplayTxt', '00ffff')
    setTextBorder('practiceTxt', 1, 'ff00ff')
    setTextColor('practiceTxt', 'ffff00')
    if mechanicsAgain then
        if downscroll then
            dSM = -1
        end
    end
    if buildTarget ~= 'android' then
        setProperty('camThree.flashSprite.scaleX', 2)
        setProperty('camThree.flashSprite.scaleY', 2)
        setProperty('camThree.zoom', 0.5)
        mM = 1
        ffi = require("ffi")
        runHaxeCode([[
            import lime.app.Application;
            setVar('wnd', Application.current.window);
        ]])
        makeLuaSprite('bg', '', 0, 0)
        makeGraphic('bg', 1280, 720, '131313')
        setObjectCamera('bg', 'game')
        scaleObject('bg', 0,0,true)
        screenCenter('bg','xy')
        setScrollFactor('bg', 0,0)
        addLuaSprite('bg')
        runHaxeCode([[
            FlxG.resizeGame(1280, 720);
            FlxG.resizeWindow(1280, 720);
            import lime.app.Application;
            var wnd = Application.current.window;
            wnd.resizable = false;
            wnd.fullscreen = false;
            wnd.borderless = false;
        ]])
        resizeW()
        ffi.cdef([[
            typedef void* HWND;
            typedef int BOOL;
            typedef unsigned char BYTE;
            typedef unsigned long DWORD;
            HWND GetActiveWindow();
            long SetWindowLongA(HWND hWnd, int nIndex, long dwNewLong);
            BOOL SetLayeredWindowAttributes(HWND hwnd, DWORD crKey, BYTE bAlpha, DWORD dwFlags);
        ]])
        local hwnd = ffi.C.GetActiveWindow()
        ffi.C.SetWindowLongA(hwnd, -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(hwnd, 0x131313, 0, 0x00000001)
        addHaxeLibrary('Lib', 'openfl')
        windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/hidePS.ps1"')
    elseif buildTarget == 'android' then
        setProperty('camThree.flashSprite.scaleX', 2/3)
        setProperty('camThree.flashSprite.scaleY', 2/3)
        setProperty('camThree.zoom',1)
        setProperty('camOther.flashSprite.scaleX', 2/3)
        setProperty('camOther.flashSprite.scaleY', 2/3)
        setProperty('camOther.zoom',2/3)
        mM = 1.5
        setObjectCamera('healthBar', 'one')
        setObjectCamera('healthBarBG', 'one')
        setObjectCamera('iconP1', 'one')
        setObjectCamera('iconP2', 'one')
        setObjectCamera('scoreTxt', 'one')
        setObjectCamera('timeBar', 'one')
        setObjectCamera('timeBarBG', 'one')
        setObjectCamera('timeTxt', 'one')
        setObjectCamera('botplayTxt', 'one')
        setObjectCamera('practiceTxt', 'one')
        windowOriginX = getProperty('camOther.x')
		windowOriginY = getProperty('camOther.y')
        for i = 0, getProperty('notes.length')-1 do
            setPropertyFromGroup('notes', i, 'camera', 'camTwo')
        end
        makeLuaSprite('mobileDesktop','me/mobile/desktop')
        setObjectCamera('mobileDesktop', 'hud')
        scaleObject('mobileDesktop', 2/3, 2/3)
        addLuaSprite('mobileDesktop',false)
        makeLuaSprite('screen')
        makeGraphic('screen', 1280, 720, '000000')
        setObjectCamera('screen','one')
        addLuaSprite('screen',false)
        setWindow('center','center',1280,720)
    end
end
function onCountdownTick()
    runHaxeCode([[
        for (spr in game.members)
        {
            if (spr != null && Std.isOfType(spr, FlxSprite) && spr.graphic != null)
            {
                if (spr.graphic.key.indexOf('ready') != -1 || spr.graphic.key.indexOf('set') != -1 || spr.graphic.key.indexOf('go') != -1)
                {
                    spr.cameras = [camOne];
                }
            }
        }
        comboGroup.cameras = [camOne];
        for (note in game.notes) {
            note.camera = game.camTwo;
        }
        for (note in game.unspawnNotes) {
            note.camera = game.camTwo;
        }
        for (i in 0...4) {
            playerStrums.members[i].cameras = [camTwo];
        }
        grpNoteSplashes.cameras = [camOther];
    ]])
end
function onCountdownStarted()
    setProperty('healthBar.alpha', 0);
    setProperty('healthBarBG.alpha', 0);
    setProperty('iconP1.alpha', 0);
    setProperty('iconP2.alpha', 0);
    setProperty('scoreTxt.alpha', 0);
    setProperty('timeBar.alpha', 0);
    setProperty('timeTxt.alpha', 0);
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
    setPropertyFromGroup('playerStrums',0,'x',defaultPlayerStrumX0-312)
    setPropertyFromGroup('playerStrums',1,'x',defaultPlayerStrumX1-312)
    setPropertyFromGroup('playerStrums',2,'x',defaultPlayerStrumX2-312)
    setPropertyFromGroup('playerStrums',3,'x',defaultPlayerStrumX3-312)
    for i = 0, 3 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        setPropertyFromGroup('opponentStrums',i,'visible',false)
    end
    if not assetMovement and not mechanicsAgain then
        setProperty('songSpeed',3.2)
        close()
    end

end
function onSongStart()
    p0x = getPropertyFromGroup('playerStrums',0,'x')
    p1x = getPropertyFromGroup('playerStrums',1,'x')
    p2x = getPropertyFromGroup('playerStrums',2,'x')
    p3x = getPropertyFromGroup('playerStrums',3,'x')
    p0y = getPropertyFromGroup('playerStrums',0,'y')
    p1y = getPropertyFromGroup('playerStrums',1,'y')
    p2y = getPropertyFromGroup('playerStrums',2,'y')
    p3y = getPropertyFromGroup('playerStrums',3,'y')
end
function onUpdate()
    setTextString("timeLeftText", getProperty("timeTxt.text"))
    if assetMovement then
        if buildTarget ~= 'android' and getPropertyFromClass('openfl.Lib', 'application.window.fullscreen') then
            runHaxeCode([[
                import lime.app.Application;
                Application.current.window.fullscreen = false;
            ]])
        end
        if endingYO then
            if buildTarget ~= 'android' then
                newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
            else
                newOriginY = getProperty('camOther.y')
            end
        end
        if lockWindow and not tweening then
            if buildTarget ~= 'android' then
                resizeW()
            end
        end
        if windowShaking then
            if newWO then
                if buildTarget ~= 'android' then
                    setPropertyFromClass('openfl.Lib','application.window.x', newOriginX + getRandomFloat(-shakeLevel,shakeLevel))
                    setPropertyFromClass('openfl.Lib','application.window.y', newOriginY + getRandomFloat(-shakeLevel,shakeLevel))
                else
                    setWindow(newOriginX + getRandomFloat(-shakeLevel,shakeLevel),newOriginY + getRandomFloat(-shakeLevel,shakeLevel),1280,720)
                end
            else
                if buildTarget ~= 'android' then
                    setPropertyFromClass('openfl.Lib','application.window.x', windowOriginX + getRandomFloat(-shakeLevel,shakeLevel))
                    setPropertyFromClass('openfl.Lib','application.window.y', windowOriginY + getRandomFloat(-shakeLevel,shakeLevel))
                else
                    setWindow(windowOriginX + getRandomFloat(-shakeLevel,shakeLevel),windowOriginY + getRandomFloat(-shakeLevel,shakeLevel),1280,720)
                end
            end
        end
    end
end
function goodNoteHit(index, noteDir, noteType, isSustainNote)
    if coolNoteThing and not isSustainNote then
        noteHit[noteDir]()
    end
    updHP()
    if not isSustainNote then
        customRatingThing(false)
        local ms = math.floor((getPropertyFromGroup('notes', index, 'strumTime') - getSongPosition() + getPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset'))*100)/100
        setProperty("msText.alpha", 1)
        setProperty("msText.x", getProperty('msText.x')+posXR)
        setProperty("msText.y", getProperty('msText.y')+posYR)
        setTextString("msText", ms..'ms')
        runTimer('hideMS',1.5)
    end
end
function noteMiss(id, noteData, noteType, isSustainNote)
    updHP()
    if not isSustainNote then
        customRatingThing(true)
    end
end
function updHP()
    health = (getHealth()*50)
    if health >= 100 then
        health = 100
    end
    if health <= 100 then
        setTextString("mainhp", ("[Health] "..health))
    end
end
function onTimerCompleted(tag)
    if tag == 'hideMS' then
        setProperty("msText.alpha", 0)
    end
    if tag == 'tweenW' and buildTarget ~= 'android' then
        startTween('bgM', 'bg.scale', {x=1,y=1}, 0.2, {ease = 'sineOut'})
    end
    if tag == 'wtff' and wtff then
        runTimer('wtff', 0.02)
        if ialrdid then
            setProperty('camThree.y', getProperty('camThree.y')+((150+goDownMore)/mM*dSM))
            goDownMore = goDownMore+(12+wtffs)
            ialrdid = false
        else
            setProperty('camThree.y', getProperty('camThree.y')-((150-goDownMore)/mM*dSM))
            goDownMore = goDownMore+(12+wtffs)
            ialrdid = true
        end
    end
end
function onTweenCompleted(t)
    if buildTarget ~= 'android' then
        if t == 'windowTweenX' then
            aa = false
            if not bb and not ignoreCall then
                tweening = false
                lockWindow = true
            end
        end
        if t == 'windowTweenY' then
            bb = false
            if not aa and not ignoreCall then
                tweening = false
                lockWindow = true
            end
        end
    else
        if t == 'mobileTweenX' then
            aa = false
            if not bb and not ignoreCall then
                tweening = false
                lockWindow = true
            end
        end
        if t == 'mobileTweenY' then
            bb = false
            if not aa and not ignoreCall then
                tweening = false
                lockWindow = true
            end
        end
    end
    if mechanicsAgain then
        if t == 'strumsXX' then
            if r then
                setProperty('camTwo.x', -900)
                setProperty('camThree.x', -900)
            else
                setProperty('camTwo.x', 900)
                setProperty('camThree.x', 900)
            end
            doTweenX('strumsXXe', 'camTwo', 0, 0.07, 'sineIn')
            doTweenX('svXXe', 'camThree', 0, 0.07, 'sineIn')
        end
        if t == 'sv' then
            setProperty('camThree.y', 0)
        end
        if t == 'cOy' then
            doTweenY('cOya', 'camThree', 200/mM*dSM, 0.1, 'sineOut')
        end
        if t == 'cOy2' then
            doTweenY('cOya', 'camThree', -200/mM*dSM, 0.1, 'sineOut')
        end
    end
end
function onDestroy()
    if buildTarget ~= "android" then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
        runHaxeCode([[
            import lime.app.Application;
            var wnd = Application.current.window;
            wnd.resizable = true;
            wnd.fullscreen = false;
            wnd.borderless = false;
        ]])
        setWindow('center', 'center', 1280, 720)
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/showPS.ps1"')
    end
end
function goBack()
    runHaxeCode([[
        for (note in notes) {
            if (note.mustPress) {
                note.cameras = [camTwo];
            }
        }
    ]])
end
function changeCam()
    runHaxeCode([[
        for (i in 0...4) {
            playerStrums.members[i].cameras = [camTwo];
        }
        grpNoteSplashes.forEachAlive(function(splash) splash.cameras = [camTwo]);
    ]])
end
function tWin(a,v,d,e,g)
    tweening = true
    if g == nil or g == null or g == '' then
        g = false
    end
    ignoreCall = g
    if buildTarget ~= 'android' then
        if a == 1 then
            cancelTween('windowTweenX')
            newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
            doTweenX('windowTweenX', 'wnd', v, d, e)
        elseif a == 2 then
            cancelTween('windowTweenY')
            newOriginY = getPropertyFromClass('openfl.Lib','application.window.x')
            doTweenY('windowTweenY', 'wnd', v, d, e)
        end
    else
        if a == 1 then
            cancelTween('mobileTweenX')
            cancelTween('mobileTweenX1')
            cancelTween('mobileTweenX2')
            cancelTween('mobileTweenX3')
            if g then
                newOriginX = getProperty('camOther.x')
            end
            doTweenX('mobileTweenX', 'camOther', v, d, e)
            doTweenX('mobileTweenX1', 'camTwo', v, d, e)
            doTweenX('mobileTweenX2', 'camThree', v, d, e)
            doTweenX('mobileTweenX3', 'camOne', v, d, e)
        elseif a == 2 then
            cancelTween('mobileTweenY')
            cancelTween('mobileTweenY1')
            cancelTween('mobileTweenY2')
            cancelTween('mobileTweenY3')
            if g then
                newOriginY = getProperty('camOther.y')
            end
            doTweenY('mobileTweenY', 'camOther', v, d, e)
            doTweenY('mobileTweenY3', 'camOne', v, d, e)
            doTweenY('mobileTweenY1', 'camTwo', v, d, e)
            doTweenY('mobileTweenY2', 'camThree', v, d, e)
        end
    end
end
function parseValue(param, current, screenSize, windowSize)
    if type(param) == "string" then
        if buildTarget ~= 'android' and param == "center" and screenSize and windowSize then
            return (screenSize - windowSize) / 2
        end
        local sign, num = param:match("^([+-])(%d+)$")
        if sign and num then
            local offset = tonumber(num)
            return sign == "+" and current + offset or current - offset
        end
        local n = tonumber(param)
        if n then return n end
    elseif type(param) == "number" then
        return param
    end
    return current
end
function setWindow(x, y, w, h, t)
    if buildTarget ~= 'android' then
        local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
        local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
        local newW, newH = parseValue(w, current.width), parseValue(h, current.height)
        local newX, newY = parseValue(x, current.x, screen.sw, newW), parseValue(y, current.y, screen.sh, newH)
        runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], newX, newY, newW, newH))
        lockedPosition = { x = newX, y = newY, width = newW, height = newH }
    else
        if t == null or t == nil or t == '' then
            t = false
        end
        if not t then
            cancelTween('back')
            local screenW = 1280 -- Rendering Resolution. Never changes unless some other engine does so
            local screenH = 720
            if type(w) ~= "string" then w = w * (screenW/1920) end
            if type(h) ~= "string" then h = h * (screenH/1080) end
            if type(x) ~= "string" then x = x * (screenW/1920) end
            if type(y) ~= "string" then y = y * (screenH/1080) end
            camW = getProperty("camOther.width")
            camH = getProperty("camOther.height")
            local newCamX = parseValue(x, getProperty("camOther.x"), screenW, camW)
            local newCamY = parseValue(y, getProperty("camOther.y"), screenH, camH)
            setProperty("camOther.x", newCamX)
            setProperty("camOther.y", newCamY)
            setProperty("camOne.x", newCamX)
            setProperty("camOne.y", newCamY)
            setProperty("camTwo.x", newCamX)
            setProperty("camTwo.y", newCamY)
            setProperty("camThree.x", newCamX)
            setProperty("camThree.y", newCamY)
            local zoomX = w / camW
            local zoomY = h / camH
            newZoom = (zoomX + zoomY) / 2
            setProperty('camOne.flashSprite.scaleX', newZoom)
            setProperty('camOne.flashSprite.scaleY', newZoom)
            setProperty("camOne.zoom", newZoom/newZoom)
            setProperty('camOther.flashSprite.scaleX', newZoom)
            setProperty('camOther.flashSprite.scaleY', newZoom)
            setProperty("camOther.zoom", newZoom/newZoom)
            setProperty('camTwo.flashSprite.scaleX', newZoom)
            setProperty('camTwo.flashSprite.scaleY', newZoom)
            setProperty("camTwo.zoom", newZoom/newZoom)
            setProperty('camThree.flashSprite.scaleX', newZoom)
            setProperty('camThree.flashSprite.scaleY', newZoom)
            setProperty("camThree.zoom", newZoom/newZoom)
            mM = getProperty('camOther.zoom')/(newZoom)
            lockedPosition = {
                x = newCamX,
                y = newCamY,
                width = camW * newZoom,
                height = camH * newZoom
            }
        else
            doTweenZoom('mobileZoom','camOther',newZoom/newZoom,0.3,'linear')
            startTween('mobileZoom1', 'camOther.flashSprite', {scaleX = newZoom/newZoom}, 0.3, {ease = 'linear'})
            startTween('mobileZoom2', 'camOther.flashSprite', {scaleY = newZoom/newZoom}, 0.3, {ease = 'linear'})
            doTweenZoom('mobileZoom3','camThree',newZoom/newZoom,0.3,'linear')
            startTween('mobileZoom4', 'camThree.flashSprite', {scaleX = newZoom/newZoom}, 0.3, {ease = 'linear'})
            startTween('mobileZoom5', 'camThree.flashSprite', {scaleY = newZoom/newZoom}, 0.3, {ease = 'linear'})
            doTweenZoom('mobileZoom6','camTwo',newZoom/newZoom,0.3,'linear')
            startTween('mobileZoom7', 'camTwo.flashSprite', {scaleX = newZoom/newZoom}, 0.3, {ease = 'linear'})
            startTween('mobileZoom8', 'camTwo.flashSprite', {scaleY = newZoom/newZoom}, 0.3, {ease = 'linear'})
            doTweenZoom('mobileZoom9','camOne',newZoom/newZoom,0.3,'linear')
            startTween('mobileZoom10', 'camOne.flashSprite', {scaleX = newZoom/newZoom}, 0.3, {ease = 'linear'})
            startTween('mobileZoom11', 'camOne.flashSprite', {scaleY = newZoom/newZoom}, 0.3, {ease = 'linear'})
        end
    end
end
function resizeW()
    if buildTarget ~= 'android' then
        runHaxeCode([[
            import openfl.Lib;
	        import flixel.FlxG;
	    	FlxG.game.setFilters([]);
	    	var stage = Lib.current.stage;
	    	var resolutionX = 0;
	    	var resolutionY = 0;
	    	if (stage.window != null)
	    	{
	    		var display = stage.window.display;
	    		if (display != null)
	    		{
	    			resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
	    			resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
	    		}
	    	}
	    	if(resolutionX <= 0){
	    		resolutionX = stage.stageWidth;
	    		resolutionY = stage.stageHeight;
	    	}
	        Lib.application.window.x = (resolutionX - Lib.application.window.width)/2;
	        Lib.application.window.y = (resolutionY - Lib.application.window.height)/2;
	    ]])
    else
        local screenWidth = 1280
        local screenHeight = 720
        local camWidth = screenWidth/getProperty('camOther.zoom')
        local camHeight = screenHeight/getProperty('camOther.zoom')

        local centerX = (screenWidth - camWidth) / 2
        local centerY = (screenHeight - camHeight) / 2

        setProperty("camOther.x", centerX)
        setProperty("camOther.y", centerY)
        setProperty("camOne.x", centerX)
        setProperty("camOne.y", centerY)
        setProperty("camTwo.x", centerX)
        setProperty("camTwo.y", centerY)
        setProperty("camThree.x", centerX)
        setProperty("camThree.y", centerY)
    end
end
function luatxt(tag,txt,w,x,y,cam,ts,tc,sc,ali,f) -- set certain values to '.' for default or no value
    makeLuaText(tag,txt,w,x,y)
    setObjectCamera(tag,cam)
    setTextSize(tag, ts)
    if tc == '.' then
        tc = 'FFFFFF'
    end
    setTextColor(tag, tc)
    if sc ~= '.' then
        screenCenter(tag, sc)
    end
    if ali == '.' then
        ali = 'center'
    end
    setTextAlignment(tag, ali)
    if f == '.' then
        f = false
    end
    addLuaText(tag,f)
end
function txtSet(tag,w,a,t,o)
    setTextWidth(tag, w)
    setTextAlignment(tag,a)
    setTextString(tag, t)
    setObjectOrder(tag, o)
end
function customRatingThing(m)
    nr = math.floor(rating * 10000) / 100
    local ratingData = {
        {100, "00FFFF", "P"},
        {95, "FF00FF", "S"},
        {90, "00FF00", "A"},
        {80, "0075FF", "B"},
        {70, "FFFF00", "C"},
        {60, "FF7500", "D"},
        {0, "FF0000", "F"}
    }
    for _, data in ipairs(ratingData) do
        if nr >= data[1] then
            setTextColor("mainacc", data[2])
            letter = data[3]
            break
        end
    end
    setTextString("mainacc", string.format("%s - %.2f%%", letter, nr))
    setTextString("mainsc", score)
end