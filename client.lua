local IsAnimal = false
local IsAttacking = false
local IsCarrying = false
local CarriedPed = nil
local attackPressedTime = nil

AddNetEvent("fixanimals:attack")

function SetControlContext(pad, context)
	Citizen.InvokeNative(0x2804658EB7D8A50B, pad, context)
end

function GetPedCrouchMovement(ped)
	return Citizen.InvokeNative(0xD5FE956C70FF370B, ped)
end

function SetPedCrouchMovement(ped, state, immediately)
	Citizen.InvokeNative(0x7DE9692C6F64CFE8, ped, state, immediately)
end

function PlayAnimation(anim)
	if not DoesAnimDictExist(anim.dict) then
		print("Invalid animation dictionary: " .. anim.dict)
		return
	end

	RequestAnimDict(anim.dict)

	local timeout = 0
	while not HasAnimDictLoaded(anim.dict) do
		Citizen.Wait(100)
		timeout = timeout + 100
		if timeout >= 5000 then
			print("Timed out waiting for animation dictionary: " .. anim.dict)
			return
		end
	end

	TaskPlayAnim(PlayerPedId(), anim.dict, anim.name, 4.0, 4.0, -1, 0, 0.0, false, false, false)

	RemoveAnimDict(anim.dict)
end

function IsPvpEnabled()
	return GetRelationshipBetweenGroups(`PLAYER`, `PLAYER`) == 5
end

function IsValidTarget(ped)
	return not IsPedDeadOrDying(ped, true) and not (IsPedAPlayer(ped) and not IsPvpEnabled())
end

function GetClosestPed(playerPed, radius)
	local playerCoords = GetEntityCoords(playerPed)

	local itemset = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, playerCoords, radius, itemset, 1, Citizen.ResultAsInteger())

	local closestPed
	local minDist = radius

	if size > 0 then
		for i = 0, size - 1 do
			local ped = GetIndexedItemInItemset(i, itemset)

			if playerPed ~= ped and IsValidTarget(ped) then
				local pedCoords = GetEntityCoords(ped)
				local distance = #(playerCoords - pedCoords)

				if distance < minDist then
					closestPed = ped
					minDist = distance
				end
			end
		end
	end

	if IsItemsetValid(itemset) then
		DestroyItemset(itemset)
	end

	return closestPed
end

function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1)
	local p2 = GetEntityCoords(entity2)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)

	SetEntityHeading(entity1, heading)
end

function GetAttackType(playerPed)
	local playerModel = GetEntityModel(playerPed)

	for _, attackType in ipairs(Config.AttackTypes) do
		for _, model in ipairs(attackType.models) do
			if playerModel == model then
				return attackType
			end
		end
	end
end

function ApplyAttackToTarget(attacker, target, attackType)
	if attackType.force > 0 then
		SetPedToRagdoll(target, 1000, 1000, 0, 0, 0, 0)
		SetEntityVelocity(target, GetEntityForwardVector(attacker) * attackType.force)
	end

	if attackType.damage > 0 then
		ApplyDamageToPed(target, attackType.damage, 1, -1, 0)
	end
end

function GetPlayerServerIdFromPed(ped)
	for _, player in ipairs(GetActivePlayers()) do
		if GetPlayerPed(player) == ped then
			return GetPlayerServerId(player)
		end
	end
end

function GetAnimalSize(ped)
	return Config.AnimalSizes[GetEntityModel(ped)]
end

function CanCarry(carrier, target)
	if not DoesEntityExist(target) then return false end
	if not IsPedDeadOrDying(target, true) then return false end  -- only dead peds
	if IsPedAPlayer(target) then return false end

	local carrierSize = GetAnimalSize(carrier)
	local targetSize  = GetAnimalSize(target)

	return carrierSize ~= nil and targetSize ~= nil and carrierSize > targetSize
end

function GrabPed(playerPed, target)
	-- Attempt to take network control for networked entities
	if NetworkGetEntityIsNetworked(target) and not NetworkHasControlOfEntity(target) then
		NetworkRequestControlOfEntity(target)
	end

	ClearPedTasksImmediately(target)
	SetEntityInvincible(target, true)
	-- No ragdoll call needed – ped is already dead/limp

	-- Prefer jaw bone, fall back to head, then root
	local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_Jaw")
	if boneIndex == -1 then
		boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_Head")
	end

	AttachEntityToEntity(
		target, playerPed, boneIndex,
		Config.CarryOffset.x, Config.CarryOffset.y, Config.CarryOffset.z,
		Config.CarryRotation.x, Config.CarryRotation.y, Config.CarryRotation.z,
		false, false, false, false, 2, true
	)

	CarriedPed = target
	IsCarrying = true
end

function DropPed()
	if not IsCarrying or not CarriedPed then return end

	DetachEntity(CarriedPed, true, true)
	SetEntityInvincible(CarriedPed, false)
	SetPedToRagdoll(CarriedPed, 2000, 2000, 0, 0, 0, 0)

	CarriedPed = nil
	IsCarrying = false
end

function Attack()
	if IsAttacking or IsCarrying then
		return
	end

	local playerPed = PlayerPedId()

	if IsPedDeadOrDying(playerPed, true) or IsPedRagdoll(playerPed) then
		return
	end

	local attackType = GetAttackType(playerPed)

	if attackType then
		local target = GetClosestPed(playerPed, attackType.radius)

		if target then
			IsAttacking = true

			MakeEntityFaceEntity(playerPed, target)

			PlayAnimation(attackType.animation)

			if IsPedAPlayer(target) then
				TriggerServerEvent("fixanimals:attack", GetPlayerServerIdFromPed(target), -1)
			elseif NetworkGetEntityIsNetworked(target) and not NetworkHasControlOfEntity(target) then
				TriggerServerEvent("fixanimals:attack", -1, PedToNet(target))
			else
				ApplyAttackToTarget(playerPed, target, attackType)
			end

			Citizen.SetTimeout(Config.AttackCooldown, function()
				IsAttacking = false
			end)
		end
	end
end

function ToggleCrouch()
	local playerPed = PlayerPedId()

	SetPedCrouchMovement(playerPed, not GetPedCrouchMovement(playerPed), true)
end

AddEventHandler("fixanimals:attack", function(attacker, entity)
	local attackerPed = GetPlayerPed(GetPlayerFromServerId(attacker))
	local attackType = GetAttackType(attackerPed)

	-- Attacker model may not be in config (e.g. ped changed after attack was triggered)
	if not attackType then
		return
	end

	if entity == -1 then
		-- Player-vs-player: only the targeted player receives this event
		if IsPvpEnabled() then
			ApplyAttackToTarget(attackerPed, PlayerPedId(), attackType)
		end
	else
		-- NPC attack is broadcast to all clients; only the entity owner should apply damage
		local targetPed = NetToPed(entity)
		if targetPed ~= 0 and NetworkHasControlOfEntity(targetPed) then
			ApplyAttackToTarget(attackerPed, targetPed, attackType)
		end
	end
end)

-- Detect change between human and animal ped
Citizen.CreateThread(function()
	local lastPed = 0

	while true do
		local ped = PlayerPedId()

		if ped ~= lastPed then
			if IsPedHuman(ped) then			-- Drop any carried ped before switching back to human
			if IsCarrying then
				DropPed()
			end				-- Reset control context
				SetControlContext(2, 0)
				IsAnimal = false
			else
				-- Prevent animal peds from climbing on ladders, as this crashes the game
				SetPedConfigFlag(ped, 43, true)
				IsAnimal = true
			end

			lastPed = ped
		end

		Citizen.Wait(1000)
	end
end)

-- Handle special animal ped workarounds
Citizen.CreateThread(function()
	while true do
		if IsAnimal then
			-- Change control context
			SetControlContext(2, `OnMount`)

			-- Disable first person mode as an animal since the camera is glitchy and may cause crashes
			DisableFirstPersonCamThisFrame()

			local playerPed = PlayerPedId()

			-- Short press = attack; hold (Config.CarryHoldTime ms) = grab/drop
			if IsControlJustPressed(0, `INPUT_ATTACK`) then
				attackPressedTime = GetGameTimer()
			end

			if IsControlJustReleased(0, `INPUT_ATTACK`) then
				if attackPressedTime then
					local heldMs = GetGameTimer() - attackPressedTime
					attackPressedTime = nil

					if IsCarrying then
						DropPed()
					elseif heldMs >= Config.CarryHoldTime then
						local target = GetClosestPed(playerPed, Config.CarryRadius)
						if target and CanCarry(playerPed, target) then
							GrabPed(playerPed, target)
						end
					else
						Attack()
					end
				end
			end

			-- Drop carried ped if it was somehow removed
			if IsCarrying then
				if not CarriedPed or not DoesEntityExist(CarriedPed) then
					DropPed()
				end
			end

			-- Toggle crouched movement
			if IsControlJustPressed(0, `INPUT_HORSE_MELEE`) then
				ToggleCrouch()
			end
		end

		Citizen.Wait(0)
	end
end)
