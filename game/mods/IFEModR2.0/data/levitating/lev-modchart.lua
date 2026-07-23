local lyricLines = {
    -- Dua Lipa Verse 1
    {" ", "Bill", "board", " Ba", "by,", " Du", "a", " Li", "pa", " make", " 'em", " dance", " when", " it", " come", " on"},
    {" ", "E'ry", "bo", "dy", " loo", "kin'", " for", " a", " dance", " floor", " to", " run", " on"},
    {" ", "If", " you", " wan", "na", " run", " a", "way", " with", " me,", " I", " know", " a", " ga", "lax", "y"},
    {" ", "And", " I", " can", " take", " you", " for", " a", " ride"},
    {" ", "I", " had", " a", " pre", "mo", "ni", "tion", " that", " we", " fell", " in", " to", " a", " rhy", "thm"},
    {" ", "Where", " the", " mu", "sic", " don't", " stop", " for", " life"},
    {" ", "Glit", "ter", " in", " the", " sky,", " glit", "ter", " in", " my", " eyes"},
    {" ", "Shi", "ning", " just", " the", " way", " I", " like"},
    {" ", "If", " you're", " fee", "ling", " like", " you", " need", " a", " lit", "tle", " bit", " of", " com", "pa", "ny"},
    {" ", "You", " met", " me", " at", " the", " per", "fect", " time"},

    -- Chorus 1
    {" ", "You", " want", " me,", " I", " want", " you,", " ba", "by"},
    {" ", "My", " su", "gar", "boo,", " I'm", " le", "vi", "ta", "ting"},
    {" ", "The", " Mil", "ky", " Way,", " we're", " re", "ne", "ga", "ding"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "I", " got", " you,", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night,", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"},
    {" ", "You,", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night,", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"},

    -- DaBaby Verse
    {" ", "I'm", " one", " of", " the", " grea", "test,", " ain't", " no", " de", "ba", "tin'", " on", " it", " (let's", " go)"},
    {" ", "I'm", " still", " le", "vi", "ta", "tin',", " I'm", " hea", "vi", "ly", " me", "di", "ca", "ted"},
    {" ", "I", " ro", "nic,", " I", " gave", " 'em", " love,", " and", " they", " end", " up", " ha", "tin'", " on", " me", " (cold)"},
    {" ", "She", " told", " me", " she", " love", " me,", " and", " she'd", " been", " wai", "tin'"},
    {" ", "Been", " figh", "tin'", " hard", " for", " your", " love,", " and", " I'm", " run", "nin'", " thin", " on", " my", " pa", "tience"},
    {" ", "Nee", "ded", " some", "one", " to", " hug,", " e", "ven", " took", " it", " back", " to", " the", " ba", "sics"},
    {" ", "You", " see", " what", " you", " got", " me", " out", " here", " doi", "n'?"},
    {" ", "Might", "'ve", " threw", " me", " off,", " but", " can't", " no", " bo", "dy", " stop", " the", " move", "ment,", " uh-", "uh", " let's", " go"},
    {" ", "left", " foot,", " right", " foot,", " le", "vi", "ta", "tin'", " (come", " on)"},
    {" ", "Pop", " stars", " Du", "a", " Li", "pa", " with", " Da", " Ba", "by"},
    {" ", "I", " had", " to", " lace", " my", " shoes", " for", " all", " the", " bles", "sings", " I", " was", " cha", "sin'"},
    {" ", "If", " I", " e", "ver", " slip,", " I'll", " fall", " in", " to", " a", " bet", "ter", " si", "tu", "a", "tion"},
    {" ", "So", " catch", " up,", " go", " put", " some", " cheese", " on", " it"},
    {" ", "Get", " out", " and", " get", " your", " bread", " up"},
    {" ", "They", " al", "ways", " leave", " when", " you", " fall,", " but", " you", " run", " to", "ge", "ther"},
    {" ", "Weight", " of", " the", " world", " on", " my", " shoul", "ders,", " I", " kept", " my", " head", " up"},
    {" ", "Now,", " ba", "by,", " stand", " up,", " 'cause", " girl,", " you"},

    -- Chorus 2
    {" ", "You", " want", " me", " (hey),", " I", " want", " you,", " ba", "by"},
    {" ", "My", " su", "gar", "boo,", " I'm", " le", "vi", "ta", "ting"},
    {" ", "The", " Mil", "ky", " Way,", " we're", " re", "ne", "ga", "ding"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "I", " got", " you,", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night,", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"},
    {" ", "You,", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night,", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"},

    -- Bridge
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "Ba", "by,", " let", " me", " take", " you", " for", " a", " ride"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "I'm", " le", "vi", "ta", "ting"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "Ba", "by,", " let", " me", " take", " you", " for", " a", " ride"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},

    -- Post-Chorus/Pre-Drop
    {" ", "My", " love", " is", " like", " a", " roc", "ket,", " watch", " it", " blast", " off"},
    {" ", "And", " I'm", " fee", "ling", " so", " e", "lec", "tric,", " dance", " my", " arse", " off"},
    {" ", "And", " e", "ven", " if", " I", " wan", "ted", " to,", " I", " can't", " stop"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "My", " love", " is", " like", " a", " roc", "ket,", " watch", " it", " blast", " off"},
    {" ", "And", " I'm", " fee", "ling", " so", " e", "lec", "tric,", " dance", " my", " arse", " off"},
    {" ", "And", " e", "ven", " if", " I", " wan", "ted", " to,", " I", " can't", " stop"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},

    -- Final Chorus Setup
    {" ", "You", " want", " me,", " I", " want", " you,", " ba", "by"},
    {" ", "My", " su", "gar", "boo,", " I'm", " le", "vi", "ta", "ting"},
    {" ", "The", " Mil", "ky", " Way,", " we're", " re", "ne", "ga", "ding"},
    {" ", "I", " got", " you", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "Ba", "by,", " let", " me", " take", " you", " for", " a", " ride"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "I'm", " le", "vi", "ta", "ting"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "You", " can", " fly", " a", "way", " with", " me", " to", "night"},
    {" ", "Ba", "by,", " let", " me", " take", " you", " for", " a", " ride"},
    {" ", "Yeah,", " yeah,", " yeah,", " yeah,", " yeah"},
    {" ", "I", " got", " you,", " moon", "light,", " you're", " my", " star", "light"},
    {" ", "I", " need", " you", " all", " night,", " come", " on,", " dance", " with", " me"},
    {" ", "I'm", " le", "vi", "ta", "ting"}
}
local currentLineIdx = 1
local currentWordIdx = 0
local wordsInCurrentLine = {}
function updateCaptionDisplay()
    if currentLineIdx > #lyricLines then 
        setTextString('captions', '')
        setTextString('captionsHighlight', '')
        if luaSpriteExists('captionBG') then
            setProperty('captionBG.visible', false)
        end
        return 
    end
    local baseString = ""
    local highlightString = ""
    for i = 1, #wordsInCurrentLine do
        local chunk = wordsInCurrentLine[i]
        baseString = baseString .. chunk
        if i <= currentWordIdx then
            highlightString = highlightString .. chunk
        else
            highlightString = highlightString .. string.rep(" ", string.len(chunk))
        end
    end
    setTextString('captions', baseString)
    setTextString('captionsHighlight', highlightString)
    runHaxeCode([[
        var cap = game.getLuaObject('captions');
        var capH = game.getLuaObject('captionsHighlight');
        if (cap != null) cap.updateHitbox();
        if (capH != null) capH.updateHitbox();
    ]])
    screenCenter('captions', 'x')
    screenCenter('captionBG', 'x')
    screenCenter('captionsHighlight', 'x')
    if luaSpriteExists('captionBG') then
        setProperty('captionBG.visible', true)
        local textW = getProperty('captions.width')
        local textH = getProperty('captions.height')
        local baseW = 70
        local baseH = 55
        local bgW = textW
        local bgH = textH
        setProperty('captionBG.scale.x', bgW / baseW + 1)
        setProperty('captionBG.scale.y', bgH / baseH + 0.5)
        local textX = getProperty('captions.x')
        local textY = getProperty('captions.y')
        setProperty('captionBG.y', textY-10)
    end
end
function onCreate()
    makeLuaSprite('captionBG', nil, 0, 500)
    makeGraphic('captionBG', 70, 55, '000000')
    setObjectCamera('captionBG', 'other')
    setProperty('captionBG.alpha', 0.6)
    addLuaSprite('captionBG', false)
    makeLuaText('captions', '...', 0, 0, 500)
    setTextSize('captions', 28)
    setTextColor('captions', 'FFFFFF')
    setObjectCamera('captions', 'other')
    setTextAlignment('captions', 'center')
    addLuaText('captions')
    makeLuaText('captionsHighlight', '', 0, 0, 500)
    setTextSize('captionsHighlight', 28)
    setTextColor('captionsHighlight', '0000FF')
    setObjectCamera('captionsHighlight', 'other')
    setTextAlignment('captionsHighlight', 'center')
    addLuaText('captionsHighlight')
    screenCenter('captions', 'x')
    screenCenter('captionBG', 'x')
    screenCenter('captionsHighlight', 'x')
    if #lyricLines > 0 then
        wordsInCurrentLine = lyricLines[1]
    end
    local enableShader = getPropertyFromClass('backend.ClientPrefs','data.shaders')
    if enableShader == nil or enableShader then
        enableShader = true
        callShader('createShader', {'barrel', 'MirrorRepeatEffect'})
        callShader('runShader', {'camGame', 'barrel'})
        callShader('createShader', {'barrelHUD', 'MirrorRepeatEffect'})
        callShader('runShader', {'camHUD', 'barrelHUD'})
        shaderVar('barrelHUD', 'enableClone', true, 'bool')
    end
end
local flip = false
local camzoomthing = ''
function onEvent(e, v1, v2)
    if e == '' then
        -- shaderVar('barrel', 'flip', true, 'bool')
        -- shaderVar('barrelHUD', 'flip', true, 'bool')
        -- shaderTween('barrel', 'x', ran1, stepCrochet*0.001*16, 'cubeOut')
        -- shaderTween('barrelHUD', 'x', ran1, stepCrochet*0.001*16, 'cubeOut')
        -- shaderTween('barrel', 'y', ran2, stepCrochet*0.001*16, 'cubeOut')
        -- shaderTween('barrelHUD', 'y', ran2, stepCrochet*0.001*16, 'cubeOut')
        if v1 == 'shader' then
            local vt = {}
            for value in string.gmatch(v2, '([^,]+)') do
                value = string.gsub(value, "^%s*(.-)%s*$", "%1")
                table.insert(vt, value)
            end
            if vt[1] and vt[2] then
                if not vt[5] or vt[5] == '' then
                    vt[5] = 'cubeOut'
                end
                if tostring(vt[1]) == 'both' then
                    if tostring(vt[2]) == 'flip' then
                        flip = not flip
                        shaderVar('barrel', 'flip', flip, 'bool')
                        shaderVar('barrelHUD', 'flip', flip, 'bool')
                    else
                        shaderTween('barrel', tostring(vt[2]), vt[3], stepCrochet * 0.001 * vt[4], tostring(vt[5]))
                        shaderTween('barrelHUD', tostring(vt[2]), vt[3], stepCrochet * 0.001 * vt[4], tostring(vt[5]))
                    end
                elseif tostring(vt[2]) == 'flip' then
                    flip = not flip
                    shaderVar('barrel', 'flip', flip, 'bool')
                    shaderVar('barrelHUD', 'flip', flip, 'bool')
                else                    
                    shaderTween(tostring(vt[1]), tostring(vt[2]), vt[3], stepCrochet * 0.001 * vt[4], tostring(vt[5]))
                end
            end
            runTimer('st', stepCrochet*0.001*vt[4])
        end
        if v1 == 'lyric' then
            if currentLineIdx <= #lyricLines then
                local skipValue = math.floor(tonumber(v2) or 1)
                if skipValue < 1 then
                    skipValue = 1
                end
                local wordsInLine = #wordsInCurrentLine
                if currentWordIdx < wordsInLine then
                    -- Before the final word: clamp movement to this line only.
                    currentWordIdx = math.min(currentWordIdx + skipValue, wordsInLine)
                else
                    -- On the final word: carry the full skip value into following line(s).
                    local remainingSkip = skipValue
                    while remainingSkip > 0 and currentLineIdx <= #lyricLines do
                        currentLineIdx = currentLineIdx + 1
                        if currentLineIdx <= #lyricLines then
                            wordsInCurrentLine = lyricLines[currentLineIdx]
                            local nextLineWords = #wordsInCurrentLine
                            if remainingSkip <= nextLineWords then
                                currentWordIdx = remainingSkip
                                remainingSkip = 0
                            else
                                remainingSkip = remainingSkip - nextLineWords
                                currentWordIdx = nextLineWords
                            end
                        else
                            currentWordIdx = 0
                        end
                    end
                end
                setProperty('captions.alpha', 1)
                setProperty('captionsHighlight.alpha', 1)
                setProperty('captionBG.alpha', 0.6)
                updateCaptionDisplay()
            end
        end
        if v1 == 'sg' then
            local vt = {}
            for value in string.gmatch(v2, '([^,]+)') do
                value = string.gsub(value, "^%s*(.-)%s*$", "%1")
                table.insert(vt, value)
            end
            if vt[1] and vt[2] and vt[3] then
                vt[1] = tostring(vt[1])
                vt[4] = tostring(vt[4])
                if vt[1] == 'both' then
                    doTweenZoom('zoomCS', 'game', vt[2], stepCrochet * 0.001 * vt[3], vt[4])
                    doTweenZoom('zoomCS2', 'hud', vt[2], stepCrochet * 0.001 * vt[3], vt[4])
                else
                    doTweenZoom('zoomCS', vt[1], vt[2], stepCrochet * 0.001 * vt[3], vt[4])
                end
                camzoomthing = vt[1]
                runTimer('st', stepCrochet*0.001*vt[3])
            end
        end
    end
end
function onStepHit()
    if curStep == 488 then
        coolTh('camHUD', -250, '', '', 2, 'backOut')
    elseif curStep == 490 then
        coolTh('camHUD', '', '', 0.85, 2, 'backOut')
    elseif curStep == 494 then
        coolTh('camHUD', 250, '', 1, 2, 'backOut')
    elseif curStep == 496 then
        coolTh('camHUD', '', '', 0.85, 2, 'backOut')
    elseif curStep == 500 then
        coolTh('camHUD', 0, '', 1, 2, 'backOut')
    elseif curStep == 504 then
        coolTh('camHUD', '', -50, 0.9, 2, 'backOut')
    elseif curStep == 506 then
        coolTh('camHUD', '', 50, '', 2, 'backOut')
    elseif curStep == 510 then
        coolTh('camHUD', '', 0, 1, 2, 'backOut')
    elseif curStep == 512 then
        coolTh('camHUD', -250, '', 0.85, 2, 'backOut')
    elseif curStep == 514 then
        coolTh('camHUD', 250, '', '', 2, 'backOut')
    elseif curStep == 516 then
        coolTh('camHUD', 0, '', 1, 2, 'backOut')
    end
end
local no = false
function coolTh(a,b,bb,c,d,e)
    local aa = ''
    local f = ''
    local g = ''
    if a == 'camHUD' then
        aa = 'hud'
        f = 'zoomCS2'
        g = 'uilol'
    elseif a == 'camGame' then
        aa = 'game'
        f = 'zoomCS'
        g = 'glol'
    end
    if b ~= '' and b ~= getProperty(a..'.x') then
        doTweenX(f, a, b,stepCrochet * 0.001 * d, e)
    end
    if bb ~= '' and bb ~= getProperty(a..'.y') then
        doTweenY(f, a, bb,stepCrochet * 0.001 * d, e)
    end
    if c ~= '' and c ~= getProperty(a..'.zoom') then
        doTweenZoom(g, aa, c,stepCrochet * 0.001 * d, e)
        no = false
    end
    if not no then
        camzoomthing = aa
        runTimer('st', stepCrochet * 0.001 * d)
    end
end
function onTimerCompleted(t)
    if t == 'st' then
        camzoomthing = ''
        no = false
    end
end
function onUpdate()
    if camzoomthing == 'both' then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
        setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
    elseif camzoomthing == 'game' then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
    elseif camzoomthing == 'hud' then
        setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
    end
end
function onTweenCompleted(t)
    if t == 'zoomCS' then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
    end
    if t == 'zoomCS2' then
        setProperty('defaultCamUIZoom', getProperty('camHUD.zoom'))
    end
end
function callShader(func, vars)
    callScript('scripts/shader', func, vars)
end
function shaderVar(shader, var, value, type)
    callShader('setShaderVar', {shader, var, value, type})
end
function shaderTween(shader, var, value, time, easing)
    callShader('tweenShaderValue', {shader, var, value, time, easing})
end