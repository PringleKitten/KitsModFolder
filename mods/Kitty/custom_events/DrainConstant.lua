function onEvent(name, value1, value2)
	if name == "DrainConstantg" then
		if getPropertyFromClass('ClientPrefs', 'healthDrain') == true then
	function onUpdate()
		if getProperty('health') > (value2 / 50) and getProperty('health') < (value1 / 50) then -- Health is from 0 to 2, so dividing the value by 50 allow to just turn it into percentage easly
			setProperty('health', (value2 / 50))
		else if  getProperty('health') > (value2 / 50) and getProperty('health') > (value1 / 50) then
			setProperty('health', getProperty('health')-(value1 / 50))
		end
		end
	end
	end
end
end