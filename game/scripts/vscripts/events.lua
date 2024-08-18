-- The overall game state has changed
function CAddonTemplateGameMode:OnGameRulesStateChange(keys) 
	--PrintTable(keys)

	local new_state = GameRules:State_Get()

	if new_state == DOTA_GAMERULES_STATE_INIT then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_INIT")

	elseif new_state == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD")

	elseif new_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP")
		GameRules:SetCustomGameSetupAutoLaunchDelay(0.0)

	elseif new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_HERO_SELECTION")

	elseif new_state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_STRATEGY_TIME")

		-- Force Random a hero for every player that didnt picked or randomed a hero 
		-- We do this as a failsafe so players don't end up without a hero
		for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:IsValidPlayerID(playerID) and PlayerResource:IsValidPlayer(playerID) then
				-- If this player still hasn't picked a hero, random one
				-- PlayerResource:IsConnected(index) is custom-made! Can be found in 'player_resource.lua' library
				if not PlayerResource:HasSelectedHero(playerID) and PlayerResource:IsConnected(playerID) then
					PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection() -- this will cause an error if player is disconnected, that's why we check if player is connected
					PlayerResource:SetHasRandomed(playerID)
					PlayerResource:SetCanRepick(playerID, false)
					DebugPrint("[BAREBONES] Randomed a hero for a player number "..playerID)
				end
			end
		end

	elseif new_state == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_TEAM_SHOWCASE")

	elseif new_state == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD")

	elseif new_state == DOTA_GAMERULES_STATE_PRE_GAME then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_PRE_GAME")
		local gamemode = GameRules:GetGameModeEntity()
		gamemode:SetCustomDireScore(0)
		gamemode:SetCustomRadiantScore(0)

	elseif new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_GAME_IN_PROGRESS")		

	elseif new_state == DOTA_GAMERULES_STATE_POST_GAME then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_POST_GAME")

	elseif new_state == DOTA_GAMERULES_STATE_DISCONNECT then
		DebugPrint("[BAREBONES] Game State changed to: DOTA_GAMERULES_STATE_DISCONNECT")
	end
end