
local ffi = require("ffi")
local fS, maxxed = false, false
local script = false
local mkT = false
local mk2 = false
local fP = false
local wd = 1280
local ht = 720
local mWd = 1920
local mHt = 1050
local x = 320
local y = 180
local mx = 0
local my = 0

local colorT = 0x00000000

function onCreatePost()
    if getPropertyFromClass('backend.ClientPrefs', 'data.assetMovement') == false then
        close(true)
    else
        script = true
        if buildTarget == 'android' then
            onDestroy = function () end
            ffi, fS, maxxed = nil, nil, nil
            return
        end
    end
end

function onEvent(name, value1, value2)
    if name == "transparentWindow" then
        if script then
            value1 = tonumber(value1)
            value2 = tonumber(value2)
            colorT = value2

            if value1 == 1 then
                mkT = true
                mk2 = false
                dTP()
                setPropertyFromClass("openfl.Lib", "application.window.x", wd)
                setPropertyFromClass("openfl.Lib", "application.window.y", ht)
            elseif value1 == 2 then
                mkT = true
                mk2 = true
                dTP()
                setPropertyFromClass("openfl.Lib", "application.window.x", mx)
                setPropertyFromClass("openfl.Lib", "application.window.y", my)
            elseif value1 == 3 then
                mkT = true
                mk2 = true
                fP = true
                dTP()
            elseif value1 == 0 then
                mkT = false
                mk2 = false
                ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)    
                setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
                setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', fS)
                setPropertyFromClass("openfl.Lib", "application.window.width", wd)
                setPropertyFromClass("openfl.Lib", "application.window.height", ht)
                setPropertyFromClass("openfl.Lib", "application.window.x", x)
                setPropertyFromClass("openfl.Lib", "application.window.y", y)
            end
        end
    end
end

function dTP()
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
    ffi.C.SetLayeredWindowAttributes(hwnd, colorT, 0, 0x00000001)
    fS = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
    maxxed = getPropertyFromClass('openfl.Lib', 'application.window.maximized')
end

function onUpdatePost()
    if mkT then
        if mk2 then
            if not getPropertyFromClass('openfl.Lib', 'application.window.borderless') or not getPropertyFromClass('openfl.Lib', 'application.window.maximized') or getPropertyFromClass('openfl.Lib', 'application.window.fullscreen') then
                setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
                setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
                setPropertyFromClass("openfl.Lib", "application.window.width", mWd)
                setPropertyFromClass("openfl.Lib", "application.window.height", mHt)
                if fP then
                    setPropertyFromClass("openfl.Lib", "application.window.x", mx)
                    setPropertyFromClass("openfl.Lib", "application.window.y", my)
                end
            end
        else
            if not getPropertyFromClass('openfl.Lib', 'application.window.borderless') or getPropertyFromClass('openfl.Lib', 'application.window.maximized') or getPropertyFromClass('openfl.Lib', 'application.window.fullscreen') then
                setPropertyFromClass('openfl.Lib', 'application.window.borderless', true)
                setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
                setPropertyFromClass("openfl.Lib", "application.window.width", wd)
                setPropertyFromClass("openfl.Lib", "application.window.height", ht)
                if fP then
                    setPropertyFromClass("openfl.Lib", "application.window.x", x)
                    setPropertyFromClass("openfl.Lib", "application.window.y", y)
                end
            end
        end
    end
end

function onDestroy()
    if script then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)    
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', false)
        setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', fS)
        setPropertyFromClass("openfl.Lib", "application.window.width", wd)
        setPropertyFromClass("openfl.Lib", "application.window.height", ht)
        setPropertyFromClass("openfl.Lib", "application.window.x", x)
        setPropertyFromClass("openfl.Lib", "application.window.y", y)
        close(true)
    end
end