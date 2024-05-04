function onEvent(name, value1)
    if name == "Offset" then
        asdlkj = 0
        asdlkj = getPropertyFromClass('ClientPrefs', 'noteOffset')
        value1 = tonumber(value1)
        setPropertyFromClass('ClientPrefs', 'noteOffset', asdlkj+value1)
    end
end

function onDestroy()
    setPropertyFromClass('ClientPrefs', 'noteOffset', asdlkj)
end