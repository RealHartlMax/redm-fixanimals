RegisterNetEvent("fixanimals:attack")

AddEventHandler("fixanimals:attack", function(target, entity)
	target = tonumber(target)
	entity = tonumber(entity)

	-- Validate inputs: both must be numbers
	if type(target) ~= "number" or type(entity) ~= "number" then
		return
	end

	-- target must be -1 (NPC) or a valid connected player server ID
	if target ~= -1 then
		if not GetPlayerName(tostring(target)) then
			return
		end
	end

	-- entity must be -1 (player target) or a positive network ID
	if entity ~= -1 and entity <= 0 then
		return
	end

	TriggerClientEvent("fixanimals:attack", target, source, entity)
end)
