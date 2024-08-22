local sks = 0
local gds = 0
local bds = 0
local brs = 0
local mss = 0
local health = 0

function onCreate()

    --Text Basics!
    makeLuaText("S", ("Sicks: "..sks), 0, 0, 0)
    makeLuaText("G", ("Goods: "..gds), 0, 0, 0)
    makeLuaText("B", ("Bads: "..bds), 0, 0, 0)
    makeLuaText("VB", ("Bruh: "..brs), 0, 0, 0)
    makeLuaText("Mss", ("Misses: "..mss), 0, 0, 0)
    makeLuaText("hp", ("Health: "..health), 0, 0, 0)

    setObjectCamera("S", "other")
    setObjectCamera("G", "other")
    setObjectCamera("B", "other")
    setObjectCamera("VB", "other")
    setObjectCamera("Mss", "other")
    setObjectCamera("hp", "other")
    
    addLuaText("S")
    addLuaText("G")
    addLuaText("B")
    addLuaText("VB")
    addLuaText("Mss")
    addLuaText("hp")

    --Text Positioning
    screenCenter("S", 'y')
    screenCenter("G", 'y')
    screenCenter("B", 'y')
    screenCenter("VB", 'y')
    screenCenter("Mss", 'y')
    screenCenter("hp", 'y')
    y1 = getProperty('S.y')-60
    y2 = getProperty('G.y')-40
    y3 = getProperty('B.y')-20
    y4 = getProperty('Mss.y')+20
    y5 = getProperty('hp.y')+40
    setProperty('S.y', y1)
    setProperty('G.y', y2)
    setProperty('B.y', y3)
    setProperty('Mss.y', y4)
    setProperty('hp.y', y5)

    --Text Properties!
    setTextSize("S", 20)
    setTextSize("G", 20)
    setTextSize("B", 20)
    setTextSize("VB", 20)
    setTextSize("Mss", 20)
    setTextSize("hp", 20)
    setTextAlignment("S", 'left')
    setTextAlignment("G", 'left')
    setTextAlignment("B", 'left')
    setTextAlignment("VB", 'left')
    setTextAlignment("Mss", 'left')
    setTextAlignment("hp", 'left')
    setTextColor("S", "D540FF")
    setTextColor("G", "06B300")
    setTextColor("B", "D0D300")
    setTextColor("VB", "FF8400")
    setTextColor("Mss", "FF0000")
    setTextColor("hp", "0080FF")
end

function onUpdate()
    health = (getProperty('health')*50)
    setTextString("hp", ("Health: "..health))
end

function goodNoteHit(i)
    if getPropertyFromGroup('notes',i,'rating') == 'sick' then
        sks = sks+1
    end
    if getPropertyFromGroup('notes',i,'rating') == 'good' then
        gds = gds+1
    end
    if getPropertyFromGroup('notes',i,'rating') == 'bad' then
        bds = bds+1
    end
    if getPropertyFromGroup('notes',i,'rating') == 'shit' then
        brs = brs+1
    end
    setTextString("S", ("Sicks: "..sks), 100, 0, 0)
    setTextString("G", ("Goods: "..gds), 100, 0, 0)
    setTextString("B", ("Bads: "..bds), 100, 0, 0)
    setTextString("VB", ("Bruh: "..brs), 150, 0, 0)
end

function noteMiss()
    mss = mss+1
    setTextString("Mss", ("Misses: "..mss), 150, 0, 0)
end

--@PringleKitten's Very Simple Custom Ratings!