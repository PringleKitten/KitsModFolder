callScript("scripts/videoSprite", "performanceD")
setProperty('camGame.visible', false)
function onCountdownStarted()
    setPropertyFromGroup('playerStrums',0,'x',defaultPlayerStrumX0-310)
    setPropertyFromGroup('playerStrums',1,'x',defaultPlayerStrumX1-310)
    setPropertyFromGroup('playerStrums',2,'x',defaultPlayerStrumX2-310)
    setPropertyFromGroup('playerStrums',3,'x',defaultPlayerStrumX3-310)
for i = 0, 3 do
        setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
        setPropertyFromGroup('opponentStrums',i,'visible',false)
    end
    close()
end