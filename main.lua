killed = {}
hunger = {}




function Initialize(Plugin)
	Plugin:SetName("Fixes")
	Plugin:SetVersion(0)

	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_FOOD_LEVEL_CHANGE, OnPlayerFoodLevelChange);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_SPAWNED, OnPlayerSpawned);
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING, OnKilling);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined);

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function OnPlayerFoodLevelChange(Player, NewFoodLevel)
	if Player:GetWorld():GetName() == "MG" then
		if Player:GetFoodLevel() > NewFoodLevel then
			return true
		end
	elseif Player:GetFoodLevel() > NewFoodLevel then
		if hunger[Player:GetName()] == nil then
			hunger[Player:GetName()] = 1
			return true
		elseif hunger[Player:GetName()] == 10 then
			hunger[Player:GetName()] = 0
			return false
		else
			hunger[Player:GetName()] = hunger[Player:GetName()] + 1
		end
	end
end
        

function OnPlayerSpawned(Player)
	World = Player:GetWorld()
	if (killed[Player:GetName()] == true) then
		Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	end
	killed[Player:GetName()] = false
	if Player:GetName() == "Topplecat" then
		Player:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
		Player:Respawn()
	end
end

function OnKilling(Victim, Killer)
	if Victim:IsPlayer() then
		Player = tolua.cast(Victim, "cPlayer")
		killed[Player:GetName()] = true
	end
end
