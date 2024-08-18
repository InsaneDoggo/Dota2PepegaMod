-- Generated from template

if _G.CAddonTemplateGameMode == nil then
	_G.CAddonTemplateGameMode = class({})
end

-- Settings
_G.USE_DEBUG = true

require('util')
require('libraries/player_resource')
require('libraries/timers')
require('events')
require('dev_debug_menu')

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )

	local gamemode = GameRules:GetGameModeEntity()
	gamemode:SetThink( "OnThink", self, "GlobalThink", 2 )	

	-- Fast Start	
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:SetHeroSelectionTime(0.0)
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetHeroSelectPenaltyTime(0.0)
	GameRules:SetStrategyTime(0.0)

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CAddonTemplateGameMode, 'OnGameRulesStateChange'), self)

	DevDebugMenu:Init()
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end