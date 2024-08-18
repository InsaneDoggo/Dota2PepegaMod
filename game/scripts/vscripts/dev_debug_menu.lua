
if not DevDebugMenu then
    DevDebugMenu = class({})
else
    -- Script Is Reloading
    print("[DevDebugMenu] Script Is Reloading. Sync Panorama")
    -- One Frame delay to let GetDebugButtonNames() be updated
    Timers:CreateTimer(function()
        -- Sync Panorama UI in case if Buttons were changed
        DevDebugMenu:InitUIForAll()       
    end)
end

function DevDebugMenu:Init()
    DebugPrint("[DevDebugMenu] Init")
    print("[DevDebugMenu] Init")

    CustomGameEventManager:RegisterListener("debug_dev_menu_button_clicked", Dynamic_Wrap(DevDebugMenu, "OnDebugButtonClickedEvent"))
    CustomGameEventManager:RegisterListener("debug_dev_menu_request_for_sync", Dynamic_Wrap(DevDebugMenu, "OnRequestForSync"))
end

function DevDebugMenu:OnRequestForSync(event)
    local player = PlayerResource:GetPlayer(event.playerId)
    DevDebugMenu:InitUIForPlayer(player)
end

function DevDebugMenu:InitUIForAll()
    print("[DevDebugMenu] InitUIForAll")
    CustomGameEventManager:Send_ServerToAllClients("debug_dev_menu_setup_ui", DevDebugMenu:GetDebugButtonNames())
end

function DevDebugMenu:InitUIForPlayer(player)
    print("[DevDebugMenu] InitUIForPlayer ")
    CustomGameEventManager:Send_ServerToPlayer(player, "debug_dev_menu_setup_ui", DevDebugMenu:GetDebugButtonNames())
end

-- event: { "FunctionNameToCall" : "SomeText" }
function DevDebugMenu:OnDebugButtonClickedEvent(event)
    if DevDebugMenu[event.FunctionNameToCall] then
        -- Find function by name and call it
        DevDebugMenu[event.FunctionNameToCall]()
    else
        print('OnDebugButtonClickedEvent Unknown FunctionNameToCall: ' .. event.FunctionNameToCall)
    end
end

-- ================================ Debug Actions ========================================
function DevDebugMenu:GetDebugButtonNames()
    return {
        { callbackFunctionName = "OnClickDebugButton1", label = "Run Http Request" },
        { callbackFunctionName = "OnClickDebugButton2", label = "Assign Player 1 to team GoodGuys" },
        { callbackFunctionName = "OnClickDebugButton3", label = "Assign Player 1 to team BadGuys" },
        { callbackFunctionName = "OnClickDebugButton4", label = "Test 4" },
        { callbackFunctionName = "OnClickDebugButton5", label = "Test 5" }
    }
end

function DevDebugMenu:OnClickDebugButton1()
    DevDebugMenu:DemoHttpRequest()
end

function DevDebugMenu:OnClickDebugButton2()
    print("Assign to GoodGuys")
    PlayerResource:SetCustomTeamAssignment( 1, DOTA_TEAM_GOODGUYS )
end

function DevDebugMenu:OnClickDebugButton3()
    print("Assign to BadGuys")
    PlayerResource:SetCustomTeamAssignment( 1, DOTA_TEAM_BADGUYS )
end

function DevDebugMenu:OnClickDebugButton4()
    local player = PlayerResource:GetPlayer(0)
    local hero = player:GetAssignedHero()
    
    print('Hello world!')
    
    -- print('Agility: ' .. hero:GetAgility())
    if false AND nil.test() then 
        print('Strength: ' .. hero:GetStrength())
    end
end

function DevDebugMenu:OnClickDebugButton5()
    local player = PlayerResource:GetPlayer(0)
    local hero = player:GetAssignedHero()
    --print(player:GetAssignedHero())
    --hero:RespawnUnit()

    -- print(PlayerResource:IsValidTeamPlayer(1))
    -- PlayerResource:ReplaceHeroWith(1,'npc_dota_hero_axe', 1000, 100)

    -- local number = PlayerResource:GetSteamID(0)
    local flag = DOTA_ABILITY_BEHAVIOR_AOE

    local ability = hero:GetAbilityByIndex(0)

    print("Raw: ")
    print(ability:GetAbilityName())
    print(ability:GetBehavior())
    print(bit.band(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_AOE) > 0)
end


function DevDebugMenu:DemoHttpRequest()
	print("Start DemoHttpRequest")

    -- url - just random open api that returns small JSON response
    -- you can open it in a browser (e.g. chrome) to see expected result
    local url = "https://jsonplaceholder.typicode.com/todos/1"
	-- Google: "REST API methods"
    local method = "GET"

    local requestHandle = CreateHTTPRequest(method, url)
    -- headers contains additional information about the request/response
    -- more info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
	requestHandle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	
    local timeStartMS = GetSystemTimeMS()
    -- callback. see description of "Send" function below.
	local callbackFunction = function(response)
        local timeSpentMS = GetSystemTimeMS() - timeStartMS
        print("Http Response: " .. response.StatusCode)		
        -- Google: List of HTTP status codes
        -- 2xx - success
        -- 4xx - client errors
        -- 5xx - server errors
        if response.StatusCode == 200 then
			print(response.Body)
		end

        print(string.format("[Debug] Time Spent: %.2f ms", timeSpentMS))
	end
    
    -- Send is asynchronous i.e. it needs time for data(packets) to reach server
    -- and return back to client. When we(engine) recevie response, function, that we had put 
    -- as a parameter into requestHandle:Send() will be called.
    requestHandle:Send(callbackFunction)
end