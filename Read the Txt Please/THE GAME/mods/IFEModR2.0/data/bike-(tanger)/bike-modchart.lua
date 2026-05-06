-- multi commented lines are cancelled script due to memory crashes... damn, it was gonna be so cool too.
local pos = 0
local p0x = 0
local p1x = 0
local p2x = 0
local p3x = 0
local p0y = 0
local p1y = 0
local p2y = 0
local p3y = 0
local nyo = true
local bleh = 0
local windowOriginX = 0
local windowOriginY = 0
local newOriginX = 0
local newOriginY = 0
local newSX = 1920
local newSY = 1082
local shakeThing = 0
local android = false
local plz = false
local was = false
-- --[[local mirrorCount = 1 -- Number of windows
-- local scaleFactor = 0.5 -- 0.5 for stability, 1 for quality
-- local desktopWidth = 1920
-- local desktopHeight = 1080]]
function onEvent(n,a,b)
    if n == '' then
        if a == 'count' then
            pos = pos+1
            func(pos)
        elseif a == 'zit' then
            b = tonumber(b)
            if b == 1 then
                if android then else setProperty('camHUD.angle', -25) end
                setProperty('camTwo.angle', -25)
                setProperty('camThree.angle', -25)
                if android then else doTweenAngle('zit1', 'camHUD', 0, 0.3, 'sineOut') end
                doTweenAngle('zit2', 'camTwo', 0, 0.3, 'sineOut')
                doTweenAngle('zit3', 'camThree', 0, 0.3, 'sineOut')
            elseif b == 2 then
                if android then else setProperty('camHUD.angle', 25) end
                setProperty('camTwo.angle', 25)
                setProperty('camThree.angle', 25)
                if android then else doTweenAngle('zit1', 'camHUD', 0, 0.3, 'sineOut') end
                doTweenAngle('zit2', 'camTwo', 0, 0.3, 'sineOut')
                doTweenAngle('zit3', 'camThree', 0, 0.3, 'sineOut')
            elseif b == 3 then
                if android then else setProperty('camHUD.zoom', 1.1) end
                setProperty('camTwo.zoom', 1.1)
                setProperty('camThree.zoom', 1.1)
                doTweenZoom('otherCams1', 'camTwo', 1, 0.3, 'sineOut')
                doTweenZoom('otherCams2', 'camThree', 1, 0.3, 'sineOut')
            else
                if android then else setProperty('camHUD.zoom', 1.1) end
                setProperty('camTwo.zoom', 1.1)
                setProperty('camThree.zoom', 1.1)
                doTweenZoom('otherCams1', 'camTwo', 1, 0.3, 'sineOut')
                doTweenZoom('otherCams2', 'camThree', 1, 0.3, 'sineOut')
                if android then else setProperty('camHUD.angle', 25) end
                setProperty('camTwo.angle', 25)
                setProperty('camThree.angle', 25)
                if android then else doTweenAngle('zit1', 'camHUD', 0, 0.3, 'sineOut') end
                doTweenAngle('zit2', 'camTwo', 0, 0.3, 'sineOut')
                doTweenAngle('zit3', 'camThree', 0, 0.3, 'sineOut')
            end
        end
        if a == 'sz' then
            local size = {}
            for value in string.gmatch(b, '([^,]+)') do
                local number = load("return " .. value)()
                table.insert(size, number)
            end
            if size[1] and size[2] then
                setWindow('center', 'center', size[1], size[2])
            end
        end
    end
end
function onTimerCompleted(t)
--    --[[if t == 'startMirrors' then
--        initMirrors()
--        runHaxeCode([[
--            var newRate = 60;
--            FlxG.updateFramerate = newRate;
--            FlxG.drawFramerate = newRate;
--            if (FlxG.game != null)
--                FlxG.game.targetFramerate = newRate;
--
--            var window = Lib.current.window;
--            if (window != null)
--                window.vsync = false;
--        ] ])
--    end
--    if t == 'closeGame' then
--        os.exit()
--    end
--    if t == 'forceMainTopPS' then
--        os.execute('powershell -ExecutionPolicy Bypass -File "ForceTop.ps1"')
--    end]]
    if t == 'belh' then
        nyo = true
        cancelTimer('repeat')
    end
    if t == 'repeat' then
        bleh = bleh-1
    end
    if t == 'vib' then
        if shakeThing > 0 then
            local a = -shakeThing
            local b = shakeThing
            if a ~= 0 then
                a = -shakeThing + 1
            end
            if b ~= 0 then
                b = shakeThing - 1
            end
            setWindow(newOriginX+getRandomInt(a,b), newOriginY+getRandomInt(a,b), newSX, newSY)
            shakeThing = shakeThing - 1
            runTimer('vib', 0.0012)
        end
    end
end
----[[function onCreate()
--    runHaxeCode([[
--        setVar('mirrorActive', false);
--    ] ])
--end]]
function onCreatePost()
    --buildTarget = 'android'
    if not assetMovement then
        close()
    elseif buildTarget ~= 'android' then
        windowOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		windowOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        runHaxeCode([[
            import lime.app.Application;
            setVar('wnd', Application.current.window);
            var wnd = Application.current.window;
            wnd.resizable = false;
            wnd.fullscreen = false;
            FlxG.resizeGame(1920, 1082);
            FlxG.resizeWindow(1920, 1082);
        ]])
        resizeW()
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/hidePS.ps1"')
    elseif buildTarget == 'android' then
        android = true
        setObjectCamera('healthBar', 'two')
        setObjectCamera('healthBarBG', 'two')
        setObjectCamera('iconP1', 'two')
        setObjectCamera('iconP2', 'two')
        setObjectCamera('scoreTxt', 'two')
        setObjectCamera('timeBar', 'two')
        setObjectCamera('timeBarBG', 'two')
        setObjectCamera('timeTxt', 'two')
        setObjectCamera('botplayTxt', 'two')
        setObjectCamera('practiceTxt', 'two')
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
    end
end
lastA = -1
avoidCount = 0
function getSmartRandom()
    local a = getRandomInt(1,4)
    if avoidCount > 0 then
        while a == lastA do
            a = getRandomInt(1,4)
        end
        avoidCount = avoidCount - 1
    else
        if a == lastA then
            avoidCount = 2
            while a == lastA do
                a = getRandomInt(1,4)
            end
        end
    end
    lastA = a
    return a
end
local lesser = 0.022
function func(p) -- pringlekiten's cool events/visuals
    if p >= 1 and p < 32 then
        setPropertyFromGroup('playerStrums',0,'x',p0x+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',1,'x',p1x+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',2,'x',p2x+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',3,'x',p3x+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',0,'y',p0y+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',1,'y',p1y+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',2,'y',p2y+getRandomInt(-30,30))
        setPropertyFromGroup('playerStrums',3,'y',p3y+getRandomInt(-30,30))
    elseif p == 32 then
        setPropertyFromGroup('playerStrums',0,'x',p0x)
        setPropertyFromGroup('playerStrums',1,'x',p1x)
        setPropertyFromGroup('playerStrums',2,'x',p2x)
        setPropertyFromGroup('playerStrums',3,'x',p3x)
        setPropertyFromGroup('playerStrums',0,'y',p0y)
        setPropertyFromGroup('playerStrums',1,'y',p1y)
        setPropertyFromGroup('playerStrums',2,'y',p2y)
        setPropertyFromGroup('playerStrums',3,'y',p3y)
        setWindow('center', 'center', 1280, 720)
    elseif p > 32 and p < 35 then
        setWindow(newOriginX+getRandomInt(-70,70), newOriginY+getRandomInt(-70,70), 1280, 720)
    elseif p == 35 then
        --setMirrorCount(0)
        setWindow('center', 'center', 1280, 720)
    elseif p > 35 and p < 38 then
        setWindow(newOriginX+getRandomInt(-70,70), newOriginY+getRandomInt(-70,70), 1280, 720)
    elseif p == 38 then
        --setMirrorCount(1)
        setWindow('center', 'center', 1280, 720)
    elseif p > 38 and p < 41 then
        setWindow(newOriginX+getRandomInt(-70,70), newOriginY+getRandomInt(-70,70), 1280, 720)
    elseif p == 41 then
        setWindow('center', 'center', 1280, 720)
    elseif p > 41 and p < 43 then
        setWindow(newOriginX+getRandomInt(-70,70), newOriginY+getRandomInt(-70,70), 1280, 720)
    elseif p == 43 then
        --setMirrorCount(2)
        setWindow('center', 'center', 1280, 720)
    elseif p == 44 then
        tWin(1, 300, 0.08, 'expoOut')
        tWin(2, 300, 0.08, 'expoIn')
    elseif p == 45 then
        tWin(1, -300, 0.08, 'expoOut')
        tWin(2, -300, 0.08, 'expoOut')
        plz = true
    elseif p > 45 and p < 98 then
        local a = getSmartRandom()
        local dirs = {
            [1] = {b = -200, c = 0},
            [2] = {b = 0,  c = 100},
            [3] = {b = 0,  c = -100},
            [4] = {b = 200, c = 0}
        }

        local b = dirs[a].b
        local c = dirs[a].c
        plz = false
        setWindow('center','center',1280,720)
        tWin(1, b, 0.07, 'sineOut')
        tWin(2, c, 0.07, 'sineOut')
    elseif p >= 98 and p < 107 then
        plz = false
        was = false
        bleh = bleh + 1
        if bleh <= 2 then
            tWin(1, -100, 0.07, 'sineOut')
        elseif bleh > 2 and bleh <= 4 then
            tWin(2, -100, 0.07, 'sineOut')
            tWin(1, 100, 0.07, 'sineIn')
        elseif bleh > 4 and bleh <= 6 then
            tWin(1, 100, 0.07, 'sineOut')
        elseif bleh > 6 and bleh <= 8 then
            tWin(1, -200, 0.07, 'sineOut')
            tWin(2, 200, 0.07, 'sineOut')
        elseif bleh == 9 then
            tWin(1, 200, 0.07, 'sineOut')
            tWin(2, -200, 0.07, 'sineOut')
            bleh = 0
        end
    elseif p > 107 and p < 179 then
        setWindow(windowOriginX+getRandomInt(-150,-20), windowOriginY+getRandomInt(-150,-20), getRandomInt(1100,1600), getRandomInt(600,900))
    elseif p == 179 then
        setWindow('center','center', 1280, 720)
    elseif p > 179 and p < 185 then
        bleh = bleh+1
        if bleh == 1 then
            setWindow('center','center',1920,600)
        elseif bleh == 2 then
            setWindow('center','center',1560,600)
        elseif bleh == 3 then
            setWindow('center','center',1280,600)
        elseif bleh == 4 then
            setWindow('center','center',780,1080)
        elseif bleh == 5 then
            setWindow('center','center',1280,720)
            bleh = 0
        end
    elseif p >= 185 and p < 219 then
        if bleh == 0 then
            plz = true
            was = true
            bleh = 1
        end
        if p == 207 then
            bleh = 2
            plz = false
            was = false
        end
        local a = getSmartRandom()
        local dirs = {
            [1] = {b = -200, c = 0},
            [2] = {b = 0,  c = 100},
            [3] = {b = 0,  c = -100},
            [4] = {b = 200, c = 0}
        }

        local b = dirs[a].b
        local c = dirs[a].c
        plz = false
        setWindow('center','center',1280,720)
        tWin(1, b, 0.07, 'sineOut')
        tWin(2, c, 0.07, 'sineOut')
    elseif p == 219 then
        setWindow('center','center',1600,720)
        newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        shakeThing = 100
        onTimerCompleted('vib')
    elseif p == 220 then
        setWindow('center','center',1920,720)
        newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
    elseif p == 221 then
        setWindow('center','center',1920,900)
        newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
    elseif p == 222 then
        setWindow('center','center',1920,1082)
        newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        bleh = 0
    elseif p >= 223 and p <= 225 then
        if bleh == 0 then
            setPropertyFromGroup('playerStrums', 0, 'angle', 25)
            setPropertyFromGroup('playerStrums', 1, 'angle', 165)
            setPropertyFromGroup('playerStrums', 2, 'angle', 95)
            setPropertyFromGroup('playerStrums', 3, 'angle', -85)
        elseif bleh == 1 then
            setPropertyFromGroup('playerStrums', 0, 'angle', 79)
            setPropertyFromGroup('playerStrums', 1, 'angle', 24)
            setPropertyFromGroup('playerStrums', 2, 'angle', -15)
            setPropertyFromGroup('playerStrums', 3, 'angle', 100)
        elseif bleh == 2 then
            setPropertyFromGroup('playerStrums', 0, 'angle', 0)
            setPropertyFromGroup('playerStrums', 1, 'angle', 0)
            setPropertyFromGroup('playerStrums', 2, 'angle', 0)
            setPropertyFromGroup('playerStrums', 3, 'angle', 0)
        end
        bleh = bleh+1
    elseif p >= 226 and p <= 229 then
        if bleh == 3 then
            setWindow('center','center',1920/1.05,1080)
        elseif bleh == 4 then
            setWindow('center','center',1920/1.1,1080)
        elseif bleh == 5 then
            setWindow('center','center',1920/1.1,1080/1.05)
        elseif bleh == 6 then
            setWindow('center','center',1920/1.1,1080/1.1)
        end
        bleh = bleh+1
        if bleh == 7 then
            bleh = 0
        end
    elseif p >= 230 and p <= 247 then
        if bleh ~= 9 and bleh ~= 10 then
            setWindow('center','center',1920/(1.1+lesser),1080/(1.1+lesser))
            newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
		    newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
        end
        if bleh >= 9 and bleh <= 10 then
            setWindow(newOriginX+getRandomInt(-70,70), newOriginY+getRandomInt(-70,70),1920/(1.1+lesser),1080/(1.1+lesser))
        elseif bleh == 11 then
            setWindow('center','center',1920/(1.1+lesser),1080/(1.1+lesser))
        elseif bleh == 17 then
            setWindow('center','center',1280,720)
        end
        lesser = lesser+0.022
        bleh = bleh+1
        if bleh == 18 then
            bleh = 0
            lesser = 0
        end
    elseif p >= 248 and p <= 250 then
        if bleh == 0 then
            setWindow('center','center',1920,600)
        elseif bleh == 1 then
            setWindow('center','center',1100,1082)
        elseif bleh == 2 then
            setWindow('center','center',1280,720)
        end
        bleh = bleh+1
    elseif p == 251 then
        plz = true
    elseif p >= 251 and p < 288 then
        bleh  = 0
        local a = getSmartRandom()
        local dirs = {
            [1] = {b = -200, c = 0},
            [2] = {b = 0,  c = 100},
            [3] = {b = 0,  c = -100},
            [4] = {b = 200, c = 0}
        }

        local b = dirs[a].b
        local c = dirs[a].c
        plz = false
        setWindow('center','center',1280,720)
        tWin(1, b, 0.07, 'sineOut')
        tWin(2, c, 0.07, 'sineOut')
    elseif p == 288 then
        plz = false
        was = false
    elseif p == 289 then
        bleh = 240
        nyo = false
        setWindow(newOriginX+getRandomInt(-bleh,bleh), newOriginY+getRandomInt(-bleh,bleh), 1280, 720)
        runTimer('belh', 0.57)
        runTimer('repeat', 0.00189,250)
    elseif p == 290 then
        tWin(1, -200, 0.07, 'sineOut')
    elseif p == 291 then
        tWin(2, -100, 0.07, 'sineOut')
    elseif p == 292 then
        tWin(1, 400, 0.07, 'sineOut')
    elseif p == 293 then
        tWin(2, 300, 0.07, 'sineOut')
    elseif p == 294 then
        tWin(1, -200, 0.07, 'sineOut')
    elseif p == 295 then
        tWin(2, -100, 0.07, 'sineOut')
    elseif p == 296 then
        tWin(1, -200, 0.07, 'sineOut')
    elseif p == 297 then
        tWin(2, -100, 0.07, 'sineOut')
    elseif p == 298 then
        setWindow('center','center',1280,720)
    end
end
function onSongStart()
    --runTimer('startMirrors', 2)
    p0x = getPropertyFromGroup('playerStrums',0,'x')
    p1x = getPropertyFromGroup('playerStrums',1,'x')
    p2x = getPropertyFromGroup('playerStrums',2,'x')
    p3x = getPropertyFromGroup('playerStrums',3,'x')
    p0y = getPropertyFromGroup('playerStrums',0,'y')
    p1y = getPropertyFromGroup('playerStrums',1,'y')
    p2y = getPropertyFromGroup('playerStrums',2,'y')
    p3y = getPropertyFromGroup('playerStrums',3,'y')
end
----[[function initMirrors()
--    runHaxeCode([[
--        import lime.app.Application;
--        import openfl.Lib;
--        import openfl.display.Bitmap;
--        import openfl.display.BitmapData;
--        import flixel.FlxG;
--
--        FlxG.autoPause = false;
--
--        var mainWindow = Lib.current.stage;
--        var totalMirrors = ] ] .. mirrorCount .. [[;
--        var mScale = ] ] .. scaleFactor .. [[;
--
--        var w = mainWindow.stageWidth;
--        var h = mainWindow.stageHeight;
--
--        setVar('myWindows', []);
--
--        for (i in 0...totalMirrors)
--        {
--            var bmpData = new BitmapData(w, h, false, 0xFF000000);
--            var winAttr = {
--                title: "Mirror " + (i + 1),
--                width: w,
--                height: h,
--                resizable: true
--            };
--            var newWin = Application.current.createWindow(winAttr);
--            var bmp = new Bitmap(bmpData);
--            bmp.smoothing = true;
--            newWin.stage.addChild(bmp);
--            getVar('myWindows').push({
--                tag: "mirror_" + i,
--                winn: newWin,
--                bmp: bmp
--            });
--        }
--        setVar('mirrorActive', true);
--    ] ])
--    runTimer('forceMainTopPS', 0.01)
--end
--function setMirrorCount(newCount)
--    mirrorCount = newCount
--    runHaxeCode([[
--        import openfl.Lib;
--        import lime.app.Application;
--        import openfl.display.Bitmap;
--        import openfl.display.BitmapData;
--        var mainWindow = Lib.current.stage;
--        var totalMirrors = ] ] .. mirrorCount .. [[;
--        var mScale = ] ] .. scaleFactor .. [[;
--        var oldWindows = getVar('myWindows');
--        if (oldWindows != null) {
--            for (obj in oldWindows) {
--                if (obj.winn != null) obj.winn.close();
--            }
--        }
--        setVar('myWindows', []);
--        var w = mainWindow.stageWidth;
--        var h = mainWindow.stageHeight;
--        for (i in 0...totalMirrors)
--        {
--            var bmpData = new BitmapData(w, h, false, 0xFF000000);
--            var winAttr = {
--                title: "Mirror " + (i + 1),
--                width: w,
--                height: h,
--                resizable: true
--            };
--            var newWin = Application.current.createWindow(winAttr);
--            var bmp = new Bitmap(bmpData);
--            bmp.smoothing = true;
--            newWin.stage.addChild(bmp);
--
--            getVar('myWindows').push({
--                tag: "mirror_" + i,
--                winn: newWin,
--                bmp: bmp
--            });
--        }
--    ] ])
--end]]
function onUpdatePost()
    setProperty('camOne.x', getProperty("camOther.x"))
    setProperty('camOne.y', getProperty("camOther.y"))
    setProperty('camOne.zoom', getProperty('camOther.zoom'))
    if plz then
        setWindow(newOriginX+getRandomInt(-10,10), newOriginY+getRandomInt(-10,10), 1280, 720)
        was = true
    end
    if not nyo then
        setWindow(newOriginX+getRandomInt(-bleh,bleh), newOriginY+getRandomInt(-bleh,bleh), 1280, 720)
    end
--    --[[runHaxeCode([[
--        if (!getVar('mirrorActive')) return;
--
--        import flixel.FlxG;
--        import openfl.Lib;
--        import openfl.geom.Matrix;
--        import openfl.display.BitmapData;
--
--        var windows = getVar('myWindows');
--        if (windows == null || windows.length == 0) return;
--
--        var mainW = Lib.current.stage.stageWidth;
--        var mainH = Lib.current.stage.stageHeight;
--
--        // Anchors for each corner
--        var anchors = [
--            {x:0, y:0},
--            {x:] ] .. desktopWidth .. [[, y:0},
--            {x:0, y:] ] .. desktopHeight .. [[},
--            {x:] ] .. desktopWidth .. [[, y:] ] .. desktopHeight .. [[}
--        ];
--
--        for (i in 0...windows.length)
--        {
--            var obj = windows[i];
--            var win = obj.winn;
--            var bmp = obj.bmp;
--
--            if (win.stage != null && bmp != null)
--            {
--                if (win.width != mainW || win.height != mainH)
--                {
--                    win.width = mainW;
--                    win.height = mainH;
--                    var anchor = anchors[i];
--                    if (i == 0) { win.x = anchor.x; win.y = anchor.y; }               
--                    if (i == 1) { win.x = anchor.x - win.width; win.y = anchor.y; }  
--                    if (i == 2) { win.x = anchor.x; win.y = anchor.y - win.height; } 
--                    if (i == 3) { win.x = anchor.x - win.width; win.y = anchor.y - win.height; } 
--
--                    // Resize bitmapData to match window
--                    if (bmp.bitmapData.width != win.stage.stageWidth || bmp.bitmapData.height != win.stage.stageHeight)
--                    {
--                        bmp.bitmapData.dispose();
--                        bmp.bitmapData = new BitmapData(win.stage.stageWidth, win.stage.stageHeight, false, 0xFF000000);
--                    }
--                    bmp.width = bmp.bitmapData.width;
--                    bmp.height = bmp.bitmapData.height;
--                }
--
--                // Draw the main game into bitmapData
--                var matrix = new Matrix();
--                bmp.bitmapData.draw(FlxG.game, matrix);
--            }
--        }
--    ] ])]]
end
function onCountdownStarted()
--    --[[setProperty('boyfriend.alpha', 0)
--    setProperty('iconP1.alpha', 0)
--    setProperty('iconP2.alpha', 0)]]
    runHaxeCode([[
        comboGroup.cameras = [camTwo];
        for (note in game.notes) {
            note.camera = game.camTwo;
        }
        for (note in game.unspawnNotes) {
            note.camera = game.camTwo;
        }
        for (i in 0...4) {
            playerStrums.members[i].cameras = [camTwo];
        }
        grpNoteSplashes.cameras = [camTwo];
    ]])
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
    ]])
end
function onDestroy()
    if buildTarget ~= 'android' then
        setWindow('center', 'center', 1280, 720)
        noFS(true)
        os.execute('start "" /min powershell -ExecutionPolicy Bypass -File "' .. debug.getinfo(1).source:sub(2):gsub("[/\\][^/\\]*$", "") .. '/../../powerShell/showPS.ps1"') 
    end
--    --[[local gamePath = "IFE.exe"
--    os.execute('start "" "' .. gamePath .. '"')
--    os.exit()]]
end
function onUpdate()
    if getPropertyFromClass('openfl.Lib','application.window.fullscreen') then
        noFS()
    end
end

function tWin(a,v,d,e)
    if buildTarget ~= 'android' then
        if a == 1 then
            cancelTween('windowTweenX')
            newOriginX = getPropertyFromClass('openfl.Lib','application.window.x')
            doTweenX('windowTweenX', 'wnd', newOriginX+v, d, e)
        elseif a == 2 then
            cancelTween('windowTweenY')
            newOriginY = getPropertyFromClass('openfl.Lib','application.window.y')
            doTweenY('windowTweenY', 'wnd', newOriginY+v, d, e)
        end
    else
        if a == 1 then
            cancelTween('mobileTweenX')
            cancelTween('mobileTweenX2')
            newOriginX = getProperty('camOther.x')
            doTweenX('mobileTweenX', 'camOther', ((newOriginX/newZoom)+v)*newZoom, d, e)
            doTweenX('mobileTweenX2', 'camTwo', ((newOriginX/newZoom)+v)*newZoom, d, e)
        elseif a == 2 then
            cancelTween('mobileTweenY')
            cancelTween('mobileTweenY2')
            newOriginY = getProperty('camOther.y')
            doTweenY('mobileTweenY', 'camOther', ((newOriginY/newZoom)+v)*newZoom, d, e)
            doTweenY('mobileTweenY2', 'camTwo', ((newOriginY/newZoom)+v)*newZoom, d, e)
        end
    end
end
function onTweenCompleted(t)
    if t == 'windowTweenX' or t == 'mobileTweenX' then
        if was then plz = true end
    end
    if t == 'windowTweenY' or t == 'mobileTweenY' then
        if was then plz = true end
    end
end
function noFS(a)
    if buildTarget ~= 'android' then
        if not a then
            runHaxeCode([[
                import lime.app.Application;
                var wnd = Application.current.window;
                wnd.resizable = false;
                wnd.fullscreen = false;
            ]])
        else
            runHaxeCode([[
                import lime.app.Application;
                var wnd = Application.current.window;
                wnd.resizable = true;
                wnd.fullscreen = false;
            ]])
        end
    end
end
function parseValue(param, current, screenSize, windowSize)
    if type(param) == "string" then
        if param == "center" and screenSize and windowSize then
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
function scaleWindowParams(x, y, w, h)
    local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
    local scaleX, scaleY = screen.sw / 1920, screen.sh / 1080
    return x * scaleX, y * scaleY, w * scaleX, h * scaleY
end
function setWindow(x, y, w, h)
    if buildTarget ~= 'android' then
        local screen = runHaxeCode([[import lime.app.Application; var d = Application.current.window.display.bounds; return { sw: d.width, sh: d.height };]])
        local current = runHaxeCode([[import lime.app.Application; var wnd = Application.current.window; return { x: wnd.x, y: wnd.y, width: wnd.width, height: wnd.height };]])
        local newW, newH = parseValue(w, current.width), parseValue(h, current.height)
        local newX, newY = parseValue(x, current.x, screen.sw, newW), parseValue(y, current.y, screen.sh, newH)
        runHaxeCode(string.format([[import lime.app.Application; var wnd = Application.current.window; wnd.x = %f; wnd.y = %f; wnd.width = %f; wnd.height = %f;]], newX, newY, newW, newH))
        lockedPosition = { x = newX, y = newY, width = newW, height = newH }
        newSX = newW
        newSY = newH
    else
        cancelTween('back')
        local screenW = 1280 -- Rendering Resolution. Never changes unless some other engine does so
        local screenH = 720
        if w == 1920 and h == 1082 then
            w = 1920
            h = 1080
        end
        if type(w) ~= "string" then w = w * (screenW/1920) end
        if type(h) ~= "string" then h = h * (screenH/1080) end
        if type(x) ~= "string" then x = x * (screenW/1920) end
        if type(y) ~= "string" then y = y * (screenH/1080) end
        local camW = getProperty("camOther.width")
        local camH = getProperty("camOther.height")
        local newCamX = parseValue(x, getProperty("camOther.x"), screenW, camW)
        local newCamY = parseValue(y, getProperty("camOther.y"), screenH, camH)
        setProperty("camOther.x", newCamX)
        setProperty("camOther.y", newCamY)
        setProperty("camTwo.x", newCamX)
        setProperty("camTwo.y", newCamY)
        local zoomX = w / camW
        local zoomY = h / camH
        newSX = w
        newSY = h
        newZoom = (zoomX + zoomY) / 2
        if newZoom <= 0.09 then
            newZoom = 1
        end
        setProperty("camOther.zoom", newZoom)
        setProperty('camTwo'..'.flashSprite.scaleX', newZoom)
        setProperty('camTwo'..'.flashSprite.scaleY', newZoom)
        setProperty("camTwo.zoom", newZoom/newZoom)
        lockedPosition = {
            x = newCamX,
            y = newCamY,
            width = camW * newZoom,
            height = camH * newZoom
        }
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
        local screenWidth = getPropertyFromClass("openfl.Lib", "application.window.width") or 1280
        local screenHeight = getPropertyFromClass("openfl.Lib", "application.window.height") or 720
        local camWidth = getProperty("camOther.width") or 1280
        local camHeight = getProperty("camOther.height") or 720

        local centerX = (screenWidth - camWidth) / 2
        local centerY = (screenHeight - camHeight) / 2

        setProperty("camOther.x", centerX)
        setProperty("camOther.y", centerY)
        setProperty("camTwo.x", centerX)
        setProperty("camTwo.y", centerY)
    end
end